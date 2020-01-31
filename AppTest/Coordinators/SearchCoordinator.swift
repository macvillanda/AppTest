//
//  SearchCoordinator.swift
//  AppTest
//
//  Created by macvillanda on 28/01/2020.
//  Copyright © 2020 macvillanda. All rights reserved.
//

import Foundation
import UIKit
import MVVMCore

final class SearchCoordinator: Coordinator {
    
    fileprivate let window: UIWindow?
    @discardableResult
    init(window: UIWindow?) {
        self.window = window
    }
    
    func start() {
        // load the splash-- this would just be a placeholder
        let startController = ViewCoordinator(singleScreen: SearchScreens.splash)
        self.window?.rootViewController = startController.navController
    }
}
