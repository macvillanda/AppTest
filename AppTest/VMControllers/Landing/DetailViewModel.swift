//
//  DetailViewModel.swift
//  AppTest
//
//  Created by macvillanda on 30/01/2020.
//  Copyright © 2020 macvillanda. All rights reserved.
//

import RxSwift
import MVVMCore

final class DetailViewModel: CoordinatedInitiable {
    
    struct DetailItem {
        let title: String
        let imgURL: String
        let description: String
    }
    
    
    weak var coordinateDelegate: CoordinatorDelegate?
    var disposeBag = DisposeBag()
    let detailItem: DetailItem
    // MARK: - Observable vars
    
    required init(model: Any?) {
        let item = AppState.shared.searchState.selectedItemResult
        var detail = item.selectedItemResult.longDescription
        if detail.isEmpty {
            detail = item.selectedItemResult.shortDescription
        }
        let artwork = item.selectedItemResult.artworkUrl100.replacingOccurrences(of: "100x100", with: "400x400")
        detailItem = DetailItem(title: item.selectedItemResult.trackName, imgURL: artwork, description: detail)
    }
    
    func viewWillEnter() {
        AppState.shared.navState.enter(screen: .detail)
    }
    
    func viewWillExit() {
        AppState.shared.navState.exit(screen: .detail)
    }
}
