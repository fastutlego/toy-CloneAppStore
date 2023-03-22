//
//  SearchListView.swift
//  StoreSearchApp
//
//  Created by hasung jung on 2023/03/22.
//

import SwiftUI

import ComposableArchitecture

struct SearchFeature: ReducerProtocol {
    struct SearchState: Equatable {
        var searchText = ""
        var filteredData: [String] = []
        var data: [String] = []
        var searchedList: [SearchResult] = []
        var currentPage = 1
    }

    enum SearchAction: Equatable {
        case searchTextDidChanged(String)
        case searchTextChangeDebounced
        case itemsUpdated([String])
        case searchResponse(TaskResult<[SearchResult]>)
        case searchResultTapped(SearchResult)
    }

    @Dependency(\.searchResult) var searchResult
    private enum SearchAppStoreID {}

    func reduce(into state: inout SearchState, action: SearchAction) -> EffectTask<SearchAction> {
        switch action {
        case let .searchTextDidChanged(text):
            state.searchText = text
//            state.filteredData = state.data.filter { $0.lowercased().contains(text.lowercased()) }
            return .none
        case .searchTextChangeDebounced:
            guard state.searchText.isEmpty == false else {
                state.searchedList = []
                return .none }
            return .task { [query = state.searchText] in
                await .searchResponse(TaskResult { try await self.searchResult.fetch(query, 10, 1) })
            }
            .cancellable(id: SearchAppStoreID.self)
        case let .itemsUpdated(items):
            print(items)
            state.filteredData = items
            return .none
        case .searchResponse(.failure):
            state.data = []
            return .none
        case let .searchResponse(.success(response)):
            state.searchedList = response
            return .none
        case .searchResultTapped(_):
            return .none
        }

    }


}


struct SearchListView: View {
    let store: StoreOf<SearchFeature>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationView {
                List {
                    ForEach(viewStore.searchedList) { item in
                        NavigationLink(destination: DetailView(detail: item)) {
                            HStack {
                                Image(systemName: "magnifyingglass")
                                Text(item.title).font(.headline)
                                Text(item.companyName).font(.body)
                            }
                        }
                    }
                }
                .searchable(text: viewStore.binding(
                    get: { $0.searchText },
                    send: { .searchTextDidChanged($0) }))
                .navigationTitle("검색")
            }
            .navigationViewStyle(.stack)
            .task(id: viewStore.searchText) {
                do {
                    try await Task.sleep(nanoseconds: NSEC_PER_SEC / 3)
                    await viewStore.send(.searchTextChangeDebounced).finish()
                } catch {}
            }
        }
    }
}

struct ContentView: View {
    var body: some View {
        SearchListView(
            store: Store(
                initialState: SearchFeature.State(),
                reducer: SearchFeature()._printChanges()
            )
        )
    }
}


//WithViewStore(store) { viewStore in
//    NavigationView {
//        List(viewStore.data, id: \.self) { item in
//            NavigationLink(
//                destination: Text(item),
//                label: {
//                    Text(item)
//                }
//            )
//        }
//        .searchable(text: viewStore.binding(
//            get: { $0.searchText },
//            send: .searchTextDidChanged($0.searchText))
//        )
//        .navigationTitle("My List")
//    }
//}

//
//struct SearchListView: View {
//    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//    }
//}
//
//struct SearchListView_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchListView()
//    }
//}
