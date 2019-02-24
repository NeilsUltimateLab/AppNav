//
//  NavAnimatedTransition.swift
//  AppNav
//
//  Created by Neil Jain on 2/24/19.
//  Copyright © 2019 Neil Jain. All rights reserved.
//

import UIKit


class NavAnimatedTransition: NSObject, UIViewControllerAnimatedTransitioning {
    var duration: TimeInterval = 1
    
    private lazy var darkView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return view
    }()
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from),
            let toViewController = transitionContext.viewController(forKey: .to) else { return }
        
        let travelDistance = transitionContext.containerView.bounds.width
        let goingForword = transitionContext.initialFrame(for: fromViewController).origin.x < transitionContext.initialFrame(for: toViewController).origin.x
        
        let travel = CGAffineTransform(translationX: goingForword ? travelDistance : -travelDistance, y: 0)
        transitionContext.containerView.anchor(toViewController.view)
        toViewController.view.transform = travel.inverted()
        if goingForword {
            toViewController.view.anchor(darkView)
        } else {
            fromViewController.view.anchor(darkView)
        }
        darkView.alpha = goingForword ? 1 : 0
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            fromViewController.view.transform = travel
            self.darkView.alpha = goingForword ? 0 : 1
            toViewController.view.transform = .identity
            toViewController.view.alpha = 1
        }) { (success) in
            self.darkView.removeFromSuperview()
            fromViewController.view.transform = .identity
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
    }
    
}
