//
//  SearchListView.swift
//  StoreSearchApp
//
//  Created by hasung jung on 2023/03/22.
//

import SwiftUI
import Foundation

import ComposableArchitecture

struct RecentSearchStore {
    static let storedKey = "keyword"
    static func loadList() -> [String] {
        guard let searchList = UserDefaults.standard.stringArray(forKey: RecentSearchStore.storedKey)
              else {
            return []
        }
        return searchList
    }

    static func save(keywordList: [String]) {
        UserDefaults.standard.set(keywordList,
                                  forKey: RecentSearchStore.storedKey)
    }
}

struct SearchFeature: ReducerProtocol {
    struct SearchState: Equatable {
        var searchText = ""
        var filteredData: [String] = []
        var data: [String] = []
        var searchedList: [SearchResult] = []
        var keywordList: [String] = [] {
            didSet {
                RecentSearchStore.save(keywordList: keywordList)
            }
        }
        var currentPage = 1

        init() {
            keywordList = RecentSearchStore.loadList()
        }
    }

    enum SearchAction: Equatable {
        case searchTextDidChanged(String)
        case searchTextChangeDebounced
        case searchResponse(TaskResult<[SearchResult]>)

    }

    @Dependency(\.searchResult) var searchResult
    private enum SearchAppStoreID {}

    func reduce(into state: inout SearchState, action: SearchAction) -> EffectTask<SearchAction> {
        switch action {
        case let .searchTextDidChanged(text):
            state.searchText = text
            return .none
        case .searchTextChangeDebounced:
            guard state.searchText.isEmpty == false else {
                state.searchedList = []
                return .none }
            return .task { [query = state.searchText] in
                await .searchResponse(TaskResult { try await self.searchResult.fetch(query, 10, 1) })
            }
            .cancellable(id: SearchAppStoreID.self)
        case .searchResponse(.failure):
            state.data = []
            return .none
        case let .searchResponse(.success(response)):
            state.searchedList = response

            let queryString = state.searchText
            if !state.keywordList.contains(where: { $0 == queryString }) {
                state.keywordList.append(state.searchText)
            }
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
                    if viewStore.keywordList.count > 0 &&
                        viewStore.searchText.isEmpty {
                        ForEach(viewStore.keywordList, id: \.self) { item in
                            Button(action: { viewStore.send(.searchTextDidChanged(item)) }) {
                                Text(item)
                            }
                        }
                    } else {
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
                }.searchable(text: viewStore.binding(
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
