//
//  PresentTransition.swift
//  Widgets
//
//  Created by lynx on 16/03/2019.
//  Copyright © 2019 Underplot ltd. All rights reserved.
//

import Foundation
import UIKit

protocol AnimatableViewProvider {
    func animate() -> () -> Void
    var animateCancel: () -> Void { get }
}

class PresentTransition: NSObject, UIViewControllerInteractiveTransitioning, UIViewControllerAnimatedTransitioning {
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
    }
    
    internal var startInteractive = false
    internal weak var panGestureRecognizer: UIPanGestureRecognizer?
    internal var operation: TransitionOperation = .present
    var driver: Driver?
    
    var wantsInteractiveStart: Bool {
        return startInteractive
    }
    
    func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        if let gesture = panGestureRecognizer {
            driver = Driver(for: operation, in: transitionContext, with: gesture)
        } else {
            driver = Driver(for: operation, in: transitionContext, with: nil)
        }
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return Driver.animationDuration()
    }
    
    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        return (driver?.animator)!
    }
    
    func animationEnded(_ transitionCompleted: Bool) {
        
    }
}
