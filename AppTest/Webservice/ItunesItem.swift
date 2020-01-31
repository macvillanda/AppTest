//
//  ItunesItem.swift
//  AppTest
//
//  Created by macvillanda on 28/01/2020.
//  Copyright © 2020 macvillanda. All rights reserved.
//

import Foundation
import Unrealm

struct ItunesItem: Codable, Realmable {
    var resultCount: Int = 0
    var results: [ItemResult] = []
}

// MARK: - ItemResult
struct ItemResult: Codable, Realmable {
    var trackID: Int = 0
    var trackName: String = ""
    var artworkUrl30: String = ""
    var artworkUrl60: String = ""
    var artworkUrl100: String = ""
    var trackPrice: Double = 0.0
    var currency: String = ""
    var primaryGenreName: String = ""
    var shortDescription: String = ""
    var longDescription: String = ""

    enum CodingKeys: String, CodingKey {
        case trackID = "trackId"
        case trackName
        case artworkUrl30, artworkUrl60, artworkUrl100
        case trackPrice
        case primaryGenreName
        case currency
        case shortDescription, longDescription
    }
    
    static func primaryKey() -> String? {
        return "trackName"
    }
}

extension ItemResult {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        trackID = try container.decodeIfPresent(Int.self, forKey: .trackID) ?? 0
        trackName = try container.decodeIfPresent(String.self, forKey: .trackName) ??  ""
        artworkUrl30 = try container.decodeIfPresent(String.self, forKey: .artworkUrl30) ?? ""
        artworkUrl60 = try container.decodeIfPresent(String.self, forKey: .artworkUrl60) ?? ""
        artworkUrl100 = try container.decodeIfPresent(String.self, forKey: .artworkUrl100) ?? ""
        trackPrice = try container.decodeIfPresent(Double.self, forKey: .trackPrice) ?? 0.0
        primaryGenreName = try container.decodeIfPresent(String.self, forKey: .primaryGenreName) ?? ""
        currency = try container.decodeIfPresent(String.self, forKey: .currency) ?? ""
        shortDescription = try container.decodeIfPresent(String.self, forKey: .shortDescription) ?? ""
        longDescription = try container.decodeIfPresent(String.self, forKey: .longDescription) ?? ""
    }
}
