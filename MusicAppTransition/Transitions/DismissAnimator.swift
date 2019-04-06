//
//  MenuAnimator.swift
//  HamburgerMenu
//
//  Created by lynx on 01/09/2018.
//  Copyright © 2018 Gulnaz. All rights reserved.
//

import UIKit

class DismissAnimator: UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning{
    var auxAnimations: (()-> Void)?
    var auxAnimationsCancel: (()-> Void)?
    var maxHeight: CGFloat = 70
    
    var context: UIViewControllerContextTransitioning?
    var animator: UIViewPropertyAnimator?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        transitionAnimator(using: transitionContext).startAnimation()
    }
    
    func transitionAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        guard let fromViewController = transitionContext.viewController(forKey: .from),
            let toViewController = transitionContext.viewController(forKey: .to)
            else {
                fatalError()
        }
        
        let containerView = transitionContext.containerView
        
        containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
        let finalFrameTopPoint = CGPoint(x: 0, y: UIScreen.main.bounds.height)
        
      
        let spring = UISpringTimingParameters(mass: 10, stiffness: 5, damping: 30, initialVelocity: CGVector.zero)
        let animator = UIViewPropertyAnimator(duration: 0.2, timingParameters: spring)
        animator.isUserInteractionEnabled = true
        animator.addAnimations {
            fromViewController.view.frame = CGRect(origin: finalFrameTopPoint, size: UIScreen.main.bounds.size)
            fromViewController.view.alpha = 1
        }
        
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
    
    override func finish() {
        completionSpeed = 50
        super.finish()
    }
}
