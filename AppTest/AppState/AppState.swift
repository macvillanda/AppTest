//
//  AppState.swift
//  AppTest
//
//  Created by macvillanda on 30/01/2020.
//  Copyright © 2020 macvillanda. All rights reserved.
//

final class AppState {

    // MARK: - Properties
    
    // all state that will be peristed throughout the app
    static let shared = AppState()
    var searchState = SearchState()
    var navState = NavigationState()
    private init() {
        
    }

}
