//
//  SearchViewController.swift
//  AppTest
//
//  Created by macvillanda on 28/01/2020.
//  Copyright © 2020 macvillanda. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MVVMCore

final class SearchViewController: UIViewController, ViewControllerModellable, ControllerModellable {
    
    typealias ViewModel = SearchViewModel

    fileprivate struct LayoutConstraints {
        // Put static constants for layouts here
    }
    
    // MARK: - Subviews -
    
    fileprivate let search: UISearchController = {
        let view = UISearchController(searchResultsController: nil)
        view.searchBar.barStyle = .default
        view.searchBar.placeholder = "Search"
        view.obscuresBackgroundDuringPresentation = false
        view.searchBar.showsCancelButton = false
        view.hidesNavigationBarDuringPresentation = false
        return view
    }()
    
    fileprivate let table: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.rowHeight = UITableView.automaticDimension
        view.estimatedRowHeight = 80.0
        view.backgroundColor = .white
        view.separatorStyle = .singleLine
        view.register(cellType: SearchItemCell.self)
        return view
    }()
    
    // MARK: - Properties
    let coordinatedModel: CoordinatedInitiable
    fileprivate let viewModel: ViewModel
    let disposeBag = DisposeBag()
    fileprivate var currentOffSet = 0
    
    // MARK: - View lifecycle
    
    required init(model: ViewModel) {
        self.viewModel = model
        self.coordinatedModel = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpViews()
        setUpModelObservables()
        setUpViewObservables()
        viewModel.viewWillEnter()
        navigationController?.isNavigationBarHidden = false
    }
    
    fileprivate func setUpViews() {
        navigationController?.isNavigationBarHidden = false
        navigationItem.searchController = search
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
        definesPresentationContext = true
        navigationController?.definesPresentationContext = true
        presentedViewController?.definesPresentationContext = true
        
        view.addSubview(table)
        NSLayoutConstraint.activate([
            table.topAnchor.constraint(equalTo: view.topAnchor),
            table.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            table.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            table.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filters",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(showFilters))
        
    }
    
    @objc func showFilters() {
        search.resignFirstResponder()
        search.dismiss(animated: true, completion: {
            self.viewModel.showFilters()
        })
    }
    
    fileprivate func setUpModelObservables() {
        viewModel.content.asObservable()
        .flatMap{ [weak self] items -> Observable<[ViewModel.SearchItem]> in
            self?.currentOffSet = items.count
            self?.table.tableFooterView?.isHidden = items.count == 0
            return Observable.just(items)
        }.bind(to: table.rx.items(cellIdentifier: SearchItemCell.className, cellType: SearchItemCell.self)) { [weak self] (row, item, cell) in
            cell.lblTitle.text = item.trackName
            cell.lblSubtitle.text = item.genre
            cell.lblAccessory.text = item.price
            cell.setImage(url: item.artwork)
            if let items = self?.viewModel.content.value {
                if row == items.count - 1 && items.count >= 10 {
                    self?.loadNext()
                    self?.viewModel.search(term: self?.search.searchBar.text ?? "", offset: self?.currentOffSet ?? 0)
                } else {
                    self?.table.tableFooterView?.isHidden = false
                }
            }
        }.disposed(by: disposeBag)
    }
    
    fileprivate func loadNext() {
        let spinner = UIActivityIndicatorView(style: .gray)
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: table.bounds.width, height: CGFloat(44))

        table.tableFooterView = spinner
        table.tableFooterView?.isHidden = false
    }
    
    fileprivate func setUpViewObservables() {
        
        let searchObs = search.searchBar.rx.text
        .filter { text in
            return ((text?.count ?? 0) > 2)
        }
        .debounce(1.0, scheduler: MainScheduler.instance)
        .distinctUntilChanged { $0 == $1 }
        .flatMapLatest { Observable.just($0) }
        
        searchObs.subscribe(onNext: { [weak self] text in
            guard let weakSelf = self, let term = text else {
                return
            }
            weakSelf.currentOffSet = 0
            weakSelf.viewModel.search(term: term, offset: weakSelf.currentOffSet)
        }).disposed(by: disposeBag)
        
        table.rx.didEndDisplayingCell
            .subscribe(onNext: { (cell, path) in
                if let itemCell = cell as? CellDownloadCancellable {
                    itemCell.downloadableImage.kf.cancelDownloadTask()
                }
            }).disposed(by: disposeBag)
        table.rx.itemSelected
            .subscribe(onNext: { [weak self] path in
                self?.table.deselectRow(at: path, animated: true)
                self?.viewModel.didSelectItemAt(index: path.row)
            }).disposed(by: disposeBag)
        search.searchBar.text = viewModel.currentSearch.term
    }

    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        if parent == nil {
            viewModel.dispose()
        }
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        if parent == nil {
            viewModel.viewWillExit()
        }
    }
}

// MARK: - Extensions

extension SearchViewController {
    
}
