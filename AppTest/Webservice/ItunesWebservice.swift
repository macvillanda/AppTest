//
//  ItunesWebservice.swift
//  AppTest
//
//  Created by macvillanda on 28/01/2020.
//  Copyright © 2020 macvillanda. All rights reserved.
//

import MVVMCore
import Foundation
import Alamofire

enum ItunesWebservice: APIWebservice {
    
    case search(JSONEncodable)
    
    var baseURL: String {
        return "https://itunes.apple.com"
    }
    
    var endpoint: String {
        switch self {
        case .search:
            return "/search"
        }
    }
    
    var params: [String : Any]? {
        switch self {
        case .search(let query):
            return query.customJSONDictionary
        }
    }
    
    var method: HTTPMethod {
        return HTTPMethod.get
    }
    
    
}
