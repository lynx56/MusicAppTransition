//
//  MenuAnimator.swift
//  HamburgerMenu
//
//  Created by lynx on 01/09/2018.
//  Copyright © 2018 Gulnaz. All rights reserved.
//

import UIKit

class PresentAnimator: NSObject, UIViewControllerAnimatedTransitioning{
    let duration = 0.5
    var maxHeight: CGFloat = 0
      
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from),
              let toViewController = transitionContext.viewController(forKey: .to)
        else {
            return
        }
        
        let screenBounds = UIScreen.main.bounds
        toViewController.view.frame = CGRect(x: screenBounds.minX, y: screenBounds.maxY, width: screenBounds.width, height: 0)
        
        transitionContext.containerView.addSubview(toViewController.view)
        
        if let snapshot = fromViewController.view.snapshotView(afterScreenUpdates: false){
            snapshot.isUserInteractionEnabled = false
            
            snapshot.tag = 100
            transitionContext.containerView.insertSubview(snapshot, belowSubview: toViewController.view)
        }
        
        
        let frame = CGRect(x: 0, y: UIScreen.main.bounds.maxY - maxHeight, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        UIView.animate(withDuration: duration, animations: {
            toViewController.view.frame = frame
        }){ _ in
            fromViewController.view.isHidden = false
            toViewController.view.layer.cornerRadius = 12
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
