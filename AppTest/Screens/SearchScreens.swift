//
//  SearchScreens.swift
//  AppTest
//
//  Created by macvillanda on 28/01/2020.
//  Copyright © 2020 macvillanda. All rights reserved.
//

import Foundation
import UIKit
import MVVMCore

enum SearchScreens: String, ScreenCoordinated {
    
    case search
    case filter
    case detail
    case splash
    
    var tabItem: UITabBarItem? {
        return nil
    }
    
    var title: String? {
        switch self {
        case .search:
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d yyyy"
            return dateFormatter.string(from: Date())
        case .filter:
            return "Filters"
        case .detail:
            return AppState.shared.searchState.selectedItemResult.selectedItemResult.trackName
        case .splash:
            return ""
        }
    }
    
    var tabTitle: String? {
        return ""
    }
    
    var configuration: ControllerConfiguration {
        return ControllerConfiguration()
    }
    
    var controllerModel: ControllerModel {
        switch self {
        case .search:
            return build(SearchViewController.self, modelType: SearchViewModel.self, object: nil)
        case .filter:
            return build(SearchFilterViewController.self, modelType: SearchFilterViewModel.self, object: nil)
        case .detail:
            return build(DetailViewController.self, modelType: DetailViewModel.self, object: nil)
        case .splash:
            return build(SplashViewController.self, modelType: SplashViewModel.self, object: nil)
        }
    }
}

extension SearchScreens: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.search, .search):
            return true
        case (.filter, .filter):
            return true
        case (.detail, .detail):
            return true
        case (.splash, .splash):
            return true
        default:
            return false
        }
    }
}
