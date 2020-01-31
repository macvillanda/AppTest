//
//  SearchViewModel.swift
//  AppTest
//
//  Created by macvillanda on 28/01/2020.
//  Copyright © 2020 macvillanda. All rights reserved.
//

import RxSwift
import MVVMCore

final class SearchViewModel: CoordinatedInitiable {
    
    struct SearchItem {
        let artwork: String
        let trackName: String
        let price: String
        let genre: String
    }
    
    fileprivate var searchedItems: [SearchItem] = []
    weak var coordinateDelegate: CoordinatorDelegate?
    var disposeBag = DisposeBag()
    var currentSearch: SearchRequest
    fileprivate var isLoading = false
    let content: Variable<[SearchItem]> = Variable([])
    fileprivate var currentSearchedItems: [ItemResult] = []
    // MARK: - Observable vars
    
    required init(model: Any?) {
        currentSearch = AppState.shared.searchState.searchRequest.value
        currentSearchedItems = AppState.shared.searchState.searchItems
        content.value = currentSearchedItems.map { SearchItem(artwork: $0.artworkUrl60,
                                                     trackName: $0.trackName,
                                                     price: "\($0.trackPrice)",
        genre: $0.primaryGenreName) }
        observeChanges()
    }
    
    func search(term: String, offset: Int = 0) {
        if isLoading {
            return
        }
        
        isLoading = true
        currentSearch.term = term
        currentSearch.offset = offset
        AppState.shared.searchState.searchRequest.value = currentSearch
        
    }
    func showFilters() {
        coordinateDelegate?.coordinate(to: SearchScreens.filter)
    }
    
    fileprivate func observeChanges() {
        var currentOffset = 0
        AppState.shared.searchState.searchRequest.asObservable()
            .skip(1) // don't load since we need to load the last content
            .flatMap { [weak self] srcReq -> Single<ItunesItem?> in
                if srcReq.term.count < 3 {
                    return Single.just(nil)
                }
                self?.currentSearch = srcReq
                currentOffset = srcReq.offset
                return ItunesWebservice.search(srcReq).request()
            }.flatMap { [weak self] (item: ItunesItem?) -> Single<[SearchItem]> in
                guard let weakSelf = self, let items = item else {
                    AppState.shared.searchState.searchItems = []
                    return Single.just([])
                }
                let searchItems = items.results.map { SearchItem(artwork: $0.artworkUrl60,
                                                             trackName: $0.trackName,
                                                             price: "\($0.trackPrice)",
                genre: $0.primaryGenreName) }
                if currentOffset == 0 {
                    weakSelf.currentSearchedItems = items.results
                    weakSelf.searchedItems = searchItems
                } else {
                    weakSelf.currentSearchedItems.append(contentsOf: items.results)
                    weakSelf.searchedItems.append(contentsOf: searchItems)
                }
                AppState.shared.searchState.searchItems = weakSelf.currentSearchedItems
                return Single.just(weakSelf.searchedItems)
            }.catchErrorJustReturn([])
            .flatMap { [weak self] items -> Single<[SearchItem]> in
                self?.isLoading = false
                return Single.just(items)
            }.bind(to: content)
            .disposed(by: disposeBag)
    }
    
    func didSelectItemAt(index: Int) {
        let item = AppState.shared.searchState.searchItems[index]
        AppState.shared.searchState.selectedItemResult = ItemDetail(result: item)
        coordinateDelegate?.coordinate(to: SearchScreens.detail)
    }
    
    func viewWillEnter() {
        AppState.shared.navState.enter(screen: .search)
    }
    
    func viewWillExit() {
        AppState.shared.navState.exit(screen: .search)
    }
}
