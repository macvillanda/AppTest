//
//  MainNavigationController.swift
//
import UIKit
import MVVMCore

final class MainNavigationController: UINavigationController {
    
    fileprivate var lastNavigationHiddenState = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.barStyle = .default
        navigationBar.isTranslucent = false
        navigationBar.isOpaque = true
        navigationBar.prefersLargeTitles = true
        delegate = self
        interactivePopGestureRecognizer?.delegate = nil
        interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
}

extension MainNavigationController: UINavigationControllerDelegate {
    
    public func navigationController(_ navigationController: UINavigationController,
                                     willShow viewController: UIViewController, animated: Bool) {
        viewController.hidesBottomBarWhenPushed = configuration.hideBottomBarWhenPushed
        switch viewController.configuration.leftButton {
        case .empty:
            viewController.navigationItem.hidesBackButton = true
            viewController.navigationItem.leftBarButtonItem = nil
        default:
            viewController.navigationItem.hidesBackButton = false
        }
        
        setUpNavigationItems(navigationController: navigationController, viewController: viewController)
        //viewController.navigationController?.isNavigationBarHidden = viewController.configuration.isNavHidden
        // handle edge swipes
        if let coordinator = topViewController?.transitionCoordinator {
            
            coordinator.notifyWhenInteractionChanges({ context in
                if !context.isCancelled {
                    if let controller = viewController as? ControllerModellable {
                        controller.coordinatedModel.coordinateDelegate?
                            .navigateBack(removeTopController: false)
                        viewController.navigationController?.isNavigationBarHidden = viewController.configuration.isNavHidden
                    }
                }
            })
        }
    }
    
    func navigationController(_ navigationController: UINavigationController,
                              didShow viewController: UIViewController, animated: Bool) {
        lastNavigationHiddenState = navigationController.isNavigationBarHidden
        viewController.navigationController?.isNavigationBarHidden = viewController.configuration.isNavHidden
    }
}

extension MainNavigationController {
    
    fileprivate func setUpNavigationItems(navigationController: UINavigationController, viewController: UIViewController) {
        if let controller = viewController as? ControllerModellable {
            switch viewController.configuration.leftButton {
            case .menu:
                break
            case .back:
                break
            case .none:
                viewController.navigationItem.leftBarButtonItem = nil
            case .customBack:
                break
            default:
                setUpDefaultLeftButtons(navigationController: navigationController,
                                        viewController: viewController,
                                        controller: controller)
            }
        }
        
    }
    
    fileprivate func setUpDefaultLeftButtons(navigationController: UINavigationController,
                                             viewController: UIViewController,
                                             controller: ControllerModellable) {
        if navigationController.viewControllers.count > 1 {
            
//            let backView = BackView(frame: CGRect(x: 0, y: 0, width: 30, height: 21))
//            backView.addTapGestureRecognizer {
//                controller.coordinatedModel.coordinateDelegate?
//                    .navigateBack(removeTopController: true)
//            }
//            let navBack = UIBarButtonItem(customView: backView)
//            navBack.tintColor = AppColors.black
//            viewController.navigationItem.leftBarButtonItem = navBack
//
        }
    }
    
}
