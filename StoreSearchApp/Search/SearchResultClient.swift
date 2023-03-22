//
//  SearchAPI.swift
//  StoreSearchApp
//
//  Created by hasung jung on 2023/03/22.
//

import Foundation

import ComposableArchitecture

struct SearchResult: Equatable, Sendable, Decodable, Identifiable {
    var id: Int

    var appIcon: URL?
    var title: String
    var averageUserRating: Double
    var screenshots: [URL]
}

extension SearchResult {
    init(_ model: SearchAPIResult.Result) {
        self.id = model.trackID
        self.appIcon = URL(string: model.artworkUrl512)
        self.title = model.trackName
        self.averageUserRating = model.averageUserRatingForCurrentVersion
        self.screenshots = model.screenshotUrls.map { URL(string: $0) }.compactMap { $0 }
    }
}

struct SearchResultClient {
    var fetch: (String, Int, Int) async throws -> [SearchResult]
}

extension SearchResultClient: DependencyKey {
    static let liveValue = Self(
        fetch: { query, limit, page in
            return await SearchResultClient.fetchSearchList(query: query, limit: limit, page: page)
        }
    )

    static func fetchSearchList(query: String, limit: Int, page: Int) async -> [SearchResult] {
        let urlString = "https://itunes.apple.com/search?media=software&attributeType=software&lang=ko_kr&entity=software&term=\(query)&page=\(page)"
        guard let url = URL(string: urlString) else { return [] }

        let decoder = JSONDecoder()
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try decoder.decode(SearchAPIResult.self, from: data)
            return response.results.map { apiModel in
                let trackId = apiModel.trackID
                let appIconURL = URL(string: apiModel.artworkUrl512)
                let ratingCount = apiModel.averageUserRatingForCurrentVersion
                let title = apiModel.trackName
                let screenshots = apiModel.screenshotUrls.map {
                    URL(string: $0)
                }.compactMap { $0 }

                return SearchResult(id: trackId,
                                    appIcon: appIconURL,
                                    title: title,
                                    averageUserRating: ratingCount,
                                    screenshots: screenshots)
            }
        } catch let error {
            print(error)
            return []
        }
    }
}

extension DependencyValues {
    var searchResult: SearchResultClient {
        get { self[SearchResultClient.self] }
        set { self[SearchResultClient.self] = newValue }
    }
}
