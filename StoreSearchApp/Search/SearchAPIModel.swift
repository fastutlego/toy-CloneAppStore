//
//  SearchAPIModel.swift
//  StoreSearchApp
//
//  Created by hasung jung on 2023/03/22.
//

import Foundation

// MARK: - SearchResult
struct SearchAPIResult: Codable {
    let resultCount: Int
    let results: [SearchAPIResult.Result]

    static var empty = SearchAPIResult(resultCount: 0, results: [])

    struct Result: Codable {
        let features: [String]
        let supportedDevices: [String]
        let isGameCenterEnabled: Bool
        let advisories: [String]
        let screenshotUrls: [String]
        let artworkUrl60, artworkUrl512, artworkUrl100: String
        let artistViewURL: String
        let ipadScreenshotUrls: [String]
        let kind: String
        let currentVersionReleaseDate: String
        let releaseNotes: String
        let artistID: Int
        let artistName: String
        let genres: [String]
        let price: Double
        let primaryGenreName: String
        let primaryGenreID, trackID: Int
        let trackName, description: String
        let isVppDeviceBasedLicensingEnabled: Bool
        let genreIDS: [String]
        let sellerName, bundleID: String
        let releaseDate: String
        let currency: String
        let minimumOSVersion, trackCensoredName: String
        let languageCodesISO2A: [String]
        let fileSizeBytes: String
        let sellerURL: String?
        let formattedPrice: String
        let contentAdvisoryRating: String
        let averageUserRatingForCurrentVersion: Double
        let userRatingCountForCurrentVersion: Int
        let averageUserRating: Double
        let trackViewURL: String
        let trackContentRating: String
        let version: String
        let wrapperType: String
        let userRatingCount: Int

        enum CodingKeys: String, CodingKey {
            case features, supportedDevices, isGameCenterEnabled, advisories, screenshotUrls, artworkUrl60, artworkUrl512, artworkUrl100
            case artistViewURL = "artistViewUrl"
            case ipadScreenshotUrls, kind, currentVersionReleaseDate, releaseNotes
            case artistID = "artistId"
            case artistName, genres, price, primaryGenreName
            case primaryGenreID = "primaryGenreId"
            case trackID = "trackId"
            case trackName, description, isVppDeviceBasedLicensingEnabled
            case genreIDS = "genreIds"
            case sellerName
            case bundleID = "bundleId"
            case releaseDate, currency
            case minimumOSVersion = "minimumOsVersion"
            case trackCensoredName, languageCodesISO2A, fileSizeBytes
            case sellerURL = "sellerUrl"
            case formattedPrice, contentAdvisoryRating, averageUserRatingForCurrentVersion, userRatingCountForCurrentVersion, averageUserRating
            case trackViewURL = "trackViewUrl"
            case trackContentRating, version, wrapperType, userRatingCount
        }
    }
}


let CustomJsonDecoder: JSONDecoder = {
  let decoder = JSONDecoder()
  let formatter = DateFormatter()
  formatter.calendar = Calendar(identifier: .iso8601)
  formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
  formatter.timeZone = TimeZone(secondsFromGMT: 0)
  formatter.locale = Locale(identifier: "en_US_POSIX")
  decoder.dateDecodingStrategy = .formatted(formatter)
  return decoder
}()
