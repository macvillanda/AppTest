//
//  DetailViewController.swift
//  AppTest
//
//  Created by macvillanda on 30/01/2020.
//  Copyright © 2020 macvillanda. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MVVMCore

final class DetailViewController: UIViewController, ViewControllerModellable, ControllerModellable {
    
    typealias ViewModel = DetailViewModel

    fileprivate struct LayoutConstraints {
        static let margin: CGFloat = 20.0
    }
    
    // MARK: - Subviews -
    
    fileprivate let scrollview: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    fileprivate let contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    fileprivate let imgView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    fileprivate let lblContent: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0
        view.font = UIFont.systemFont(ofSize: 14)
        return view
    }()
    
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
        viewModel.viewWillEnter()
        navigationController?.isNavigationBarHidden = false
        navigationItem.largeTitleDisplayMode = .never
    }
    
    fileprivate func setUpViews() {
        
        view.addSubview(scrollview)
        scrollview.addSubview(contentView)
        
        contentView.addSubview(imgView)
        contentView.addSubview(lblContent)
        let botConsts = lblContent.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -LayoutConstraints.margin)
        botConsts.priority = UILayoutPriority(800)
        let trailConts = lblContent.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                              constant: -LayoutConstraints.margin)
        trailConts.priority = UILayoutPriority(800)
        NSLayoutConstraint.activate([
            scrollview.topAnchor.constraint(equalTo: view.topAnchor),
            scrollview.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollview.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollview.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            imgView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imgView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imgView.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 3.0 / 4.0),
            
            lblContent.topAnchor.constraint(equalTo: imgView.bottomAnchor, constant: LayoutConstraints.margin),
            lblContent.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: LayoutConstraints.margin),
            trailConts,
            botConsts
        ])
    }
    
    fileprivate func setUpModelObservables() {
        lblContent.text = viewModel.detailItem.description
        imgView.loadImageFrom(url: viewModel.detailItem.imgURL)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        lblContent.preferredMaxLayoutWidth = view.frame.size.width - LayoutConstraints.margin * 2
        view.layoutIfNeeded()
        let contentFrame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height)
        if contentView.frame != contentFrame {
            contentView.frame = contentFrame
            scrollview.contentSize = contentFrame.size
            contentView.layoutIfNeeded()
        }
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

extension DetailViewController {
    
}
