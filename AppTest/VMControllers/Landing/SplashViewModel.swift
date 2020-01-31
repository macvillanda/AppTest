//
//  SplashViewModel.swift
//  AppTest
//
//  Created by macvillanda on 31/01/2020.
//  Copyright © 2020 macvillanda. All rights reserved.
//

import RxSwift
import MVVMCore

final class SplashViewModel: CoordinatedInitiable {
    
    weak var coordinateDelegate: CoordinatorDelegate?
    var disposeBag = DisposeBag()
    // MARK: - Observable vars
    
    required init(model: Any?) {
        
    }
    func didFinishLoad() {
        var screensCoordinated: [ScreenCoordinated] = [SearchScreens.search]
        if let navScreens = RealmHelper().objects(NavScreen.self) {
            screensCoordinated = navScreens.compactMap { SearchScreens(rawValue: $0.name) }
        }
        if screensCoordinated.isEmpty {
            screensCoordinated = [SearchScreens.search]
        }
        print("screens \(screensCoordinated)")
        coordinateDelegate?.set(screens: screensCoordinated)
    }
}
