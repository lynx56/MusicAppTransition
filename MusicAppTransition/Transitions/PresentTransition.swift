//
//  PresentTransition.swift
//  Widgets
//
//  Created by lynx on 16/03/2019.
//  Copyright © 2019 Underplot ltd. All rights reserved.
//

import Foundation
import UIKit

class PresentTransition: UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning {
    var auxAnimations: (()-> Void)?
    var auxAnimationsCancel: (()-> Void)?
    var maxHeight: CGFloat = 70
    
    var context: UIViewControllerContextTransitioning?
    var animator: UIViewPropertyAnimator?
    var operation: PresentOperation = .present
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.75
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            transitionAnimator(using: transitionContext).startAnimation()
    }
    
    func transitionAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        switch operation {
        case .present:
            return transitionAnimator(using: transitionContext, transitionAnimation: { from, to in
                return {
                let frame = CGRect(x: 0, y: UIScreen.main.bounds.minY + self.maxHeight,
                                   width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                to.frame = frame
                to.layer.cornerRadius = 12
                from.alpha = 1
                }})
        case .dismiss:
            return transitionAnimator(using: transitionContext, transitionAnimation: { from, to in
                return {
                    let finalFrameTopPoint = CGPoint(x: 0, y: UIScreen.main.bounds.height)
                    from.frame = CGRect(origin: finalFrameTopPoint, size: UIScreen.main.bounds.size)
                    from.alpha = 0
                }})
        }
    }
    
    func transitionAnimator(using transitionContext: UIViewControllerContextTransitioning, transitionAnimation: @escaping (UIView, UIView) -> () -> Void) -> UIViewImplicitlyAnimating {
        let duration = transitionDuration(using: transitionContext)
        
        guard let fromViewController = transitionContext.viewController(forKey: .from),
            let toViewController = transitionContext.viewController(forKey: .to)
            else {
                fatalError()
        }
        
        if operation == .present {
            let screenBounds = UIScreen.main.bounds
            toViewController.view.frame = CGRect(x: screenBounds.minX, y: screenBounds.maxY, width: screenBounds.width, height: 0)
        }
        transitionContext.containerView.addSubview(toViewController.view)
        
        if let snapshot = fromViewController.view.snapshotView(afterScreenUpdates: false){
            snapshot.isUserInteractionEnabled = false
            
            snapshot.tag = 100
            transitionContext.containerView.insertSubview(snapshot, belowSubview: toViewController.view)
        }
        
        let animator = UIViewPropertyAnimator(duration: duration, curve: .easeOut)
        
        animator.addAnimations(transitionAnimation(fromViewController.view, toViewController.view), delayFactor: 0.15)
        
        animator.addCompletion { position in
            switch position {
            case .end:
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            default:
                transitionContext.completeTransition(false)
                self.auxAnimationsCancel?()
            }
        }
        
        if let auxAnimations = auxAnimations {
            animator.addAnimations(auxAnimations)
        }
        
        self.animator = animator
        self.context = transitionContext
        
        animator.addCompletion { [unowned self] _ in
            self.animator = nil
            self.context = nil
        }
        animator.isUserInteractionEnabled = true
        
        
        
        return animator
    }
    
    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        return transitionAnimator(using: transitionContext)
    }
    
    func interruptTransition() {
        guard let context = context else {
            return
        }
        context.pauseInteractiveTransition()
        pause()
    }
    
    enum PresentOperation {
        case present
        case dismiss
    }
}
