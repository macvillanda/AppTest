//
//  SearchState.swift
//  AppTest
//
//  Created by macvillanda on 30/01/2020.
//  Copyright © 2020 macvillanda. All rights reserved.
//

import Foundation
import RxSwift
import Unrealm

struct SearchState {
    let searchRequest: Variable<SearchRequest>
    fileprivate let disposeBag = DisposeBag()
    var searchItems: [ItemResult] {
        didSet {
            if let itemResults = RealmHelper().objects(ItemResult.self) {
                RealmHelper().delete(itemResults.map { $0 })
            }
            RealmHelper().add(searchItems, update: true)
        }
    }
    
    var selectedItemResult: ItemDetail {
        didSet {
            if let itemResults = RealmHelper().objects(ItemDetail.self) {
                RealmHelper().delete(itemResults.map { $0 })
            }
            RealmHelper().add(selectedItemResult, update: true)
        }
    }
    
    init() {
        
        // retrieve all objects save in realm DB for each required states
        if let srch = RealmHelper().objects(SearchRequest.self)?.first {
            searchRequest = Variable(srch)
        } else {
            searchRequest = Variable(SearchRequest())
        }
        var objects: [ItemResult] = []
        if let itemResults = RealmHelper().objects(ItemResult.self) {
            objects = itemResults.map { $0 }
        }
        searchItems = objects
        selectedItemResult = RealmHelper().objects(ItemDetail.self)?.last ?? ItemDetail()
        observeChanges()
    }
    
    fileprivate func observeChanges() {
        searchRequest.asObservable()
            .subscribe(onNext: { updateRequest in
                RealmHelper().add([updateRequest], update: true)
            }).disposed(by: disposeBag)
    }
}
