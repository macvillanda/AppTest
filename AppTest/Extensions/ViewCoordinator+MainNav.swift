//
//  ViewCoordinator+MainNav.swift
//  WhiteLabel
//
//  Created by macgyver.s.villanda on 07/06/2019.
//  Copyright © 2019 Accenture. All rights reserved.
//

import MVVMCore
extension ViewCoordinator {
    convenience init(screen: ScreenCoordinated) {
        self.init(screen: screen, navController: MainNavigationController())
    }
    
    convenience init(singleScreen: ScreenCoordinated) {
        self.init(singleScreen: singleScreen, navController: MainNavigationController())
    }
}
