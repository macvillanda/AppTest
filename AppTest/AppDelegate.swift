//
//  AppDelegate.swift
//  AppTest
//
//  Created by macvillanda on 28/01/2020.
//  Copyright © 2020 macvillanda. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        Realm.registerRealmables([ItunesItem.self, ItemResult.self, SearchRequest.self, NavScreen.self, ItemDetail.self])
        _ = AppState.shared
        window = UIWindow(frame: UIScreen.main.bounds)
        SearchCoordinator(window: window).start()
        window?.makeKeyAndVisible()
        
        return true
    }

}

