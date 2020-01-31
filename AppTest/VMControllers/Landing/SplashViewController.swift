//
//  SplashViewController.swift
//  AppTest
//
//  Created by macvillanda on 31/01/2020.
//  Copyright © 2020 macvillanda. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MVVMCore

final class SplashViewController: UIViewController, ViewControllerModellable, ControllerModellable {
    
    typealias ViewModel = SplashViewModel

    fileprivate struct LayoutConstraints {
        // Put static constants for layouts here
    }
    
    // MARK: - Subviews -
    
    // MARK: - Properties
    let coordinatedModel: CoordinatedInitiable
    fileprivate let viewModel: ViewModel
    let disposeBag = DisposeBag()
    
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
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.isNavigationBarHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: { [weak self] in
            self?.viewModel.didFinishLoad()
        })
    }
    
    fileprivate func setUpViews() {
        
        NSLayoutConstraint.activate([
            
        ])
    }
    
    fileprivate func setUpModelObservables() {
        
    }

    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        if parent == nil {
            viewModel.dispose()
        }
    }
}

// MARK: - Extensions

extension SplashViewController {
    
}
