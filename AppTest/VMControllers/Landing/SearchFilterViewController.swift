//
//  SearchFilterViewController.swift
//  AppTest
//
//  Created by macvillanda on 29/01/2020.
//  Copyright © 2020 macvillanda. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MVVMCore

final class SearchFilterViewController: UIViewController, ViewControllerModellable, ControllerModellable {
    
    typealias ViewModel = SearchFilterViewModel

    fileprivate struct LayoutConstraints {
        // Put static constants for layouts here
    }
    
    // MARK: - Subviews -
    fileprivate let picker: UIPickerView = {
        let view = UIPickerView()
        return view
    }()
    
    fileprivate let hiddenTextField: UITextField = {
        let view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate let table: UITableView = {
        let view = UITableView(frame: CGRect.zero, style: .grouped)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.rowHeight = UITableView.automaticDimension
        view.estimatedRowHeight = 80.0
        view.backgroundColor = .white
        view.separatorStyle = .singleLine
        return view
    }()
    
    // MARK: - Properties
    let coordinatedModel: CoordinatedInitiable
    fileprivate let viewModel: ViewModel
    let disposeBag = DisposeBag()
    fileprivate var cellIndex = 0
    
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
        view.backgroundColor = UIColor.white
        setUpViews()
        setUpModelObservables()
        viewModel.viewWillEnter()
        navigationController?.isNavigationBarHidden = false
        navigationItem.largeTitleDisplayMode = .never
    }
    
    fileprivate func setUpViews() {
        view.addSubview(table)
        view.addSubview(hiddenTextField)
        NSLayoutConstraint.activate([
            hiddenTextField.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            hiddenTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hiddenTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hiddenTextField.heightAnchor.constraint(equalToConstant: 44),
            table.topAnchor.constraint(equalTo: view.topAnchor),
            table.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            table.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            table.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    fileprivate func setUpModelObservables() {
        
        viewModel.content.asObservable()
            .bind(to: table.rx.items) { (tbl, path, item) -> UITableViewCell in
                let cell: UITableViewCell = {
                    guard let cell = tbl.dequeueReusableCell(withIdentifier: UITableViewCell.className) else {
                        return UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: UITableViewCell.className)
                    }
                    return cell
                }()
                cell.textLabel?.text = item.title
                cell.detailTextLabel?.text = item.value
                return cell
        }.disposed(by: disposeBag)
        
        viewModel.selection.asObservable()
            .bind(to: picker.rx.itemTitles) { _, item in
                return item.title
            }.disposed(by: disposeBag)
        
        
        table.rx.itemSelected
            .subscribe(onNext: { [weak self] (path) in
                self?.cellIndex = path.row
                self?.showOptions(row: path.row)
            }).disposed(by: disposeBag)
    }
    
    fileprivate func showOptions(row: Int) {
        viewModel.selectionType = row == 0 ? .country : .media
        let filterValue = viewModel.content.value[row].value
        if hiddenTextField.inputAccessoryView == nil {
            let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
            toolbar.barStyle = .default
            let btnDone = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(selectOption))
            let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            toolbar.items = [space, btnDone]
            hiddenTextField.inputAccessoryView = toolbar
        }
        hiddenTextField.inputView = picker
        picker.selectRow(viewModel.selection.value.firstIndex(where: { filterValue == $0.title }) ?? 0,
                         inComponent: 0, animated: true)
        hiddenTextField.becomeFirstResponder()
    }
    
    @objc func selectOption() {
        let selectedOption = picker.selectedRow(inComponent: 0)
        let value = viewModel.selection.value[selectedOption].title
        viewModel.updateValue(value, atIndex: cellIndex)
        hiddenTextField.resignFirstResponder()
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

extension SearchFilterViewController {
    
}
