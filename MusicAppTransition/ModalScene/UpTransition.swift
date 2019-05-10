//
//  PresentTransition.swift
//  Widgets
//
//  Created by lynx on 16/03/2019.
//  Copyright © 2019 Underplot ltd. All rights reserved.
//

import Foundation
import UIKit

public struct Animations {
    let direct: ()->Void
    let cancel: ()->Void
    
    public init(direct: @escaping ()->Void, cancel: @escaping ()->Void) {
        self.direct = direct
        self.cancel = cancel
    }
}

class UpTransition: NSObject, UIViewControllerInteractiveTransitioning, UIViewControllerAnimatedTransitioning {
    internal weak var panGestureRecognizer: UIPanGestureRecognizer? {
        didSet {
            panGestureRecognizer?.addTarget(self, action: #selector(handlePan))
        }
    }
    var originView : UIView
    var animator : UIViewPropertyAnimator?
    
    enum State {
        case present
        case dismiss
        case presentWithAnimations(Animations)
        case dismissWithAnimations(Animations)
    }
    
    var state = State.present
    
    init(originView : UIView) {
        self.originView = originView
    }
    
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: originView)
        var progress: CGFloat = abs(translation.y/originView.bounds.height)
        progress = min(max(progress, 0.01), 0.99)
        
        self.animator?.fractionComplete = progress
        
        if gesture.state == .ended {
            let complete = progress > 0.3
            self.animator?.isReversed = !complete
            self.animator?.startAnimation()
        }
    }
    
    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        if let animator = self.animator { return animator }
        let animator = UIViewPropertyAnimator(duration: transitionDuration(using: transitionContext), curve: .linear)
        
        guard let fromViewController = transitionContext.viewController(forKey: .from), let fromView = transitionContext.view(forKey: .from) else {
            assertionFailure("source controller or it's view are not in transition context"); return animator  }
        guard let toViewController = transitionContext.viewController(forKey: .to), let toView = transitionContext.view(forKey: .to) else {
            assertionFailure("destination controller or it's view are not found in transition context"); return animator  }
        
        let containerView = transitionContext.containerView
        
        switch state {
        case .presentWithAnimations(let animations):
            animator.addAnimations(animations.direct, delayFactor: 0.2)
            animator.addCompletion { position in
                if position != .end {
                    animations.cancel()
                }
            }
            fallthrough
        case .present:
            let finalFrame = transitionContext.finalFrame(for: toViewController)
            toView.frame = CGRect(x: finalFrame.minX, y: finalFrame.maxY,
                                  width: finalFrame.width, height: finalFrame.height)
            containerView.addSubview(toView)
            
            animator.addAnimations {
                toView.frame = finalFrame
                toView.layer.cornerRadius = 12
            }
        case .dismissWithAnimations(let animations):
            animator.addAnimations(animations.direct, delayFactor: 0.2)
            animator.addCompletion { position in
                if position != .end {
                    animations.cancel()
                }
            }
            fallthrough
        case .dismiss:
            let finalFrame = transitionContext.finalFrame(for: fromViewController)
            
            animator.addAnimations {
                fromView.frame = CGRect(x: 0,
                                        y: finalFrame.maxY,
                                        width: finalFrame.width,
                                        height: finalFrame.height)
                fromView.layer.cornerRadius = 0
            }
            
            animator.addCompletion { state in
                if state == .end {
                    containerView.insertSubview(toView, belowSubview: fromView)
                }
            }
        }
        
        animator.addCompletion { state in
            transitionContext.completeTransition(state == .end)
            self.animator = nil
        }
        
        self.animator = animator
        return animator
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        self.interruptibleAnimator(using: transitionContext).startAnimation()
    }
    
    func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        let _ = self.interruptibleAnimator(using: transitionContext)
    }
}
