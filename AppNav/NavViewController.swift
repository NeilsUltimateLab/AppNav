//
//  NavViewController.swift
//  AppNav
//
//  Created by Neil Jain on 12/9/18.
//  Copyright © 2018 Neil Jain. All rights reserved.
//

import UIKit

extension UIView {
    func anchor(_ anotherView: UIView) {
        anotherView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(anotherView)
        anotherView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        anotherView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        anotherView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        anotherView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
}

class NavViewController: UIViewController {

    lazy var navigationBar: UINavigationBar = {
        let navigationBar = UINavigationBar(frame: .zero)
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.delegate = self
        return navigationBar
    }()
    
    lazy var containerView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .white
        return view
    }()
    
    lazy var swipeGesture: UISwipeGestureRecognizer = {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(_:)))
        swipe.direction = .right
        return swipe
    }()
    
    var viewControllers: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutNavigationBar()
        setupNavigationItems()
        setupChildVCs()
    }
    
    var topViewController: UIViewController? {
        return viewControllers.last
    }
    
    init(withRoot rootViewController: UIViewController) {
        viewControllers = [rootViewController]
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Storyboard is not supported")
    }

    func layoutNavigationBar() {
        self.view.anchor(containerView)
        self.view.addSubview(navigationBar)
        navigationBar.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor).isActive = true
        navigationBar.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        navigationBar.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
    }
    
    func setupNavigationItems() {
        guard let topVCItems = self.topViewController?.navigationItem else { return }
        self.navigationBar.setItems([topVCItems], animated: false)
    }
    
    func setupChildVCs() {
        guard let topVC = self.topViewController else { return }
        self.addChildVC(child: topVC)
    }
    
    func addChildVC(child vc: UIViewController?) {
        guard let vc = vc else { return }
        vc.willMove(toParent: self)
        self.addChild(vc)
        self.containerView.anchor(vc.view)
        vc.didMove(toParent: self)
    }
    
    func removeChildVC(vc: UIViewController?) {
        vc?.willMove(toParent: nil)
        vc?.view.removeFromSuperview()
        vc?.removeFromParent()
        vc?.didMove(toParent: nil)
    }
    
    func push(viewController: UIViewController) {
        guard let previousVC = topViewController else {
            return
        }
        self.viewControllers.append(viewController)
        
        previousVC.willMove(toParent: nil)
        viewController.willMove(toParent: self)
        let animator = NavAnimatedTransition()
        let transitionContext = NavTransitionContext(fromViewController: previousVC, toViewController: viewController, isForword: true)
        transitionContext.isAnimated = true
        transitionContext.isInteractive = false
        transitionContext.onCompletion = { (didCompleted) in
            self.removeChildVC(vc: previousVC)
            viewController.didMove(toParent: self)
        }
        
        animator.animateTransition(using: transitionContext)
        self.navigationBar.pushItem(viewController.navigationItem, animated: true)
    }
    
    @objc func swipeAction(_ gesture: UISwipeGestureRecognizer) {
        switch gesture.state {
        case .changed:
            print("Changed")
        default:
            print(gesture.state)
        }
    }

}

extension NavViewController: UINavigationBarDelegate {
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
    func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
        guard let topVC = self.topViewController else { return false }
        topVC.willMove(toParent: nil)
        self.viewControllers.removeLast()
        self.topViewController?.willMove(toParent: self)
        
        let animator = NavAnimatedTransition()
        let transitionContext = NavTransitionContext(fromViewController: topVC, toViewController: topViewController!, isForword: false)
        transitionContext.isInteractive = false
        transitionContext.isAnimated = true
        transitionContext.onCompletion = { (didCompleted) in
            self.removeChildVC(vc: topVC)
            self.topViewController?.didMove(toParent: self)
        }
        animator.animateTransition(using: transitionContext)
        self.addChildVC(child: self.topViewController)
        return true
    }
    
    func navigationBar(_ navigationBar: UINavigationBar, didPop item: UINavigationItem) {
        
    }

}
