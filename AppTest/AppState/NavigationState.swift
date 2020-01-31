//
//  NavigationState.swift
//  AppTest
//
//  Created by macvillanda on 30/01/2020.
//  Copyright © 2020 macvillanda. All rights reserved.
//

import Foundation
import MVVMCore
import Unrealm

struct NavScreen: Realmable {
    var name: String = ""
    static func primaryKey() -> String? {
        return "name"
    }
}

extension NavScreen: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.name == rhs.name
    }
}

final class NavigationState {
    fileprivate var navScreens: [NavScreen] = [] {
        didSet {
            if let itemResults = RealmHelper().objects(NavScreen.self) {
                RealmHelper().delete(itemResults.map { $0 })
            }
            RealmHelper().add(navScreens, update: true)
        }
    }
    init() {
        
    }
    
    func enter(screen: SearchScreens) {
        if navScreens.contains(NavScreen(name: screen.rawValue)) {
            return
        }
        var tempScreens = navScreens
        tempScreens.append(NavScreen(name: screen.rawValue))
        navScreens = tempScreens
    }
    
    func exit(screen: SearchScreens) {
        if let lastIndex = navScreens.lastIndex(of: NavScreen(name: screen.rawValue)) {
            var tempScreens = navScreens
            tempScreens.remove(at: lastIndex)
            navScreens = tempScreens
        }
    }
    
}
