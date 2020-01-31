//
//  SearchRequest.swift
//  AppTest
//
//  Created by macvillanda on 28/01/2020.
//  Copyright © 2020 macvillanda. All rights reserved.
//

import Foundation
import Unrealm
import MVVMCore

enum MediaType: String, Codable, RealmableEnum, CaseIterable {
    case movie
    case podcast
    case music
    case musicVideo
    case audiobook
    case shortFilm
    case tvShow
    case software
    case ebook
    case all
    
    static let cases: [MediaType] = [.movie, .podcast, .music, .musicVideo, .audiobook, .shortFilm, .tvShow, .software, .ebook, .all]
}

struct SearchRequest: Codable, Realmable {
    var term: String = ""
    var country: String = "US"
    var media: MediaType = .all
    var limit: Int = 10
    var offset: Int = 0
    var keyID = Self.className()
    
    static func primaryKey() -> String? {
        return "keyID"
    }
}

extension SearchRequest {
    init(term: String, country: String, media: MediaType) {
        self.term = term
        self.country = country
        self.media = media
    }
}

extension SearchRequest: JSONEncodable {
    var customJSONDictionary: JSONDictionary? {
        var dict: JSONDictionary = ["term": term, "country": country, "media": media.rawValue, "limit": limit]
        if offset > 0 {
            dict["offset"] = offset
        }
        return dict
    }
}
