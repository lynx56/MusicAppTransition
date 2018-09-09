//
//  MenuAnimator.swift
//  HamburgerMenu
//
//  Created by lynx on 01/09/2018.
//  Copyright © 2018 Gulnaz. All rights reserved.
//

import UIKit

class DismissAnimator: NSObject, UIViewControllerAnimatedTransitioning{
    let duration = 0.2
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from),
            let toViewController = transitionContext.viewController(forKey: .to)
            else {
                return
        }
        
        let containerView = transitionContext.containerView
        
        containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
        
        let finalFrameTopPoint = CGPoint(x: 0, y: UIScreen.main.bounds.height)
        
        UIView.animate(withDuration: duration, animations: {
            fromViewController.view.frame = CGRect(origin: finalFrameTopPoint, size: UIScreen.main.bounds.size)
            
        }){ _ in
            fromViewController.view.isHidden = false
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
