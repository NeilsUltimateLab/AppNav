//
//  NavTransitionContext.swift
//  AppNav
//
//  Created by Neil Jain on 2/24/19.
//  Copyright © 2019 Neil Jain. All rights reserved.
//

import UIKit

class NavTransitionContext: NSObject, UIViewControllerContextTransitioning {
    var containerView: UIView
    var isAnimated: Bool = true
    var isInteractive: Bool = false
    var transitionWasCancelled: Bool = false
    var presentationStyle: UIModalPresentationStyle = .custom
    var targetTransform: CGAffineTransform = .identity
    
    var onCompletion: ((Bool) -> Void)?
    
    private var viewControllers: [UITransitionContextViewControllerKey: UIViewController] = [:]
    private var views: [UITransitionContextViewKey: UIView] = [:]
    private var disappearingFromRect: CGRect = .zero
    private var disappearingToRect: CGRect = .zero
    private var appearingFromRect: CGRect = .zero
    private var appearingToRect: CGRect = .zero
    
    init(fromViewController: UIViewController, toViewController: UIViewController, isForword: Bool) {
        assert(fromViewController.view.superview != nil, "The fromViewController must reside in containerView upon initialising the context")
        self.containerView = fromViewController.view.superview!
        viewControllers[.from] = fromViewController
        viewControllers[.to] = toViewController
        views[.from] = fromViewController.view
        views[.to] = toViewController.view
        
        let travel = isForword ? containerView.bounds.width : -containerView.bounds.width
        self.disappearingFromRect = containerView.bounds
        self.appearingToRect = containerView.bounds
        self.disappearingToRect = containerView.bounds.offsetBy(dx: travel, dy: 0)
        self.appearingFromRect = containerView.bounds.offsetBy(dx: -travel, dy: 0)
        super.init()
    }
    
    func updateInteractiveTransition(_ percentComplete: CGFloat) {
        return
    }
    
    func finishInteractiveTransition() {
        return
    }
    
    func cancelInteractiveTransition() {
        return
    }
    
    func pauseInteractiveTransition() {
        return
    }
    
    func completeTransition(_ didComplete: Bool) {
        onCompletion?(didComplete)
    }
    
    func viewController(forKey key: UITransitionContextViewControllerKey) -> UIViewController? {
        return viewControllers[key]
    }
    
    func view(forKey key: UITransitionContextViewKey) -> UIView? {
        return views[key]
    }
    
    
    func initialFrame(for vc: UIViewController) -> CGRect {
        if vc == viewControllers[.from] {
            return disappearingFromRect
        } else {
            return appearingFromRect
        }
    }
    
    func finalFrame(for vc: UIViewController) -> CGRect {
        if vc == viewControllers[.from] {
            return disappearingToRect
        } else {
            return appearingToRect
        }
    }
    
}
