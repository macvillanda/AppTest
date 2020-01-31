//
//  SearchFilterViewModel.swift
//  AppTest
//
//  Created by macvillanda on 29/01/2020.
//  Copyright © 2020 macvillanda. All rights reserved.
//

import RxSwift
import MVVMCore

final class SearchFilterViewModel: CoordinatedInitiable {
    struct FilterItem {
        let title: String
        let value: String
    }
    
    struct SelectionItem {
        let title: String
    }
    enum SelectionType {
        case country
        case media
        case none
    }
    
    weak var coordinateDelegate: CoordinatorDelegate?
    var disposeBag = DisposeBag()
    let content: Variable<[FilterItem]> = Variable([])
    fileprivate(set) var selection: Variable<[SelectionItem]> = Variable([])
    fileprivate(set) var countries: [Country] = []
    var selectionType: SelectionType = .none {
        didSet {
            switch selectionType {
            case .country:
                selection.value = countries.map { SelectionItem(title: $0.name) }
            case .media:
                selection.value = MediaType.cases.map { SelectionItem(title: $0.rawValue) }
            case .none:
                selection.value = []
            }
        }
    }
    // MARK: - Observable vars
    
    required init(model: Any?) {
        loadCountries()
        observeChanges()
    }
    
    fileprivate func loadCountries() {
        
        if let path = Bundle.main.path(forResource: "country_codes", ofType: "json") {
            do {
                  let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                countries = try JSONDecoder().decode([Country].self, from: data)
              } catch {
                   print("ERROR: unable to load countries \(error)")
              }
        }
    }
    
    fileprivate func observeChanges() {
        
        AppState.shared.searchState.searchRequest.asObservable()
            .subscribe(onNext: { [weak self] srchRequest in
                let country = self?.countries.first(where: { $0.code.lowercased() == srchRequest.country.lowercased() })
                self?.content.value = [
                    FilterItem(title: "Country", value: country?.name ?? ""),
                    FilterItem(title: "Media", value: srchRequest.media.rawValue)
                ]
            }).disposed(by: disposeBag)
    }
    
    func updateValue(_ value: String, atIndex: Int) {
        var currentSearch = AppState.shared.searchState.searchRequest.value
        if atIndex == 0 {
            let country = countries.first(where: { $0.name.lowercased() == value.lowercased() })
            currentSearch.country = country?.code ?? ""
        } else if atIndex == 1 {
            currentSearch.media = MediaType(rawValue: value) ?? .all
        }
        currentSearch.offset = 0
        AppState.shared.searchState.searchRequest.value = currentSearch
    }
    
    func viewWillEnter() {
        AppState.shared.navState.enter(screen: .filter)
    }
    
    func viewWillExit() {
        AppState.shared.navState.exit(screen: .filter)
    }
}
