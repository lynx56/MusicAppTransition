//
//  Driver.swift
//  MusicAppTransition
//
//  Created by lynx on 24/04/2019.
//  Copyright © 2019 Gulnaz. All rights reserved.
//

import UIKit

enum TransitionOperation {
    case present, dismiss
}

class Driver {
    private weak var panGesture: UIPanGestureRecognizer?
    private let operation: TransitionOperation
    private let context: UIViewControllerContextTransitioning
    var animator: UIViewPropertyAnimator?
    
    init(for operation: TransitionOperation, in context: UIViewControllerContextTransitioning, with gesture: UIPanGestureRecognizer?) {
        self.operation = operation
        self.context = context
        animator?.isReversed = false
        panGesture = gesture
        panGesture?.addTarget(self, action: #selector(pan))
        
        guard let fromViewController  = context.viewController(forKey: .from) else { return }
        guard let toViewController = context.viewController(forKey: .to) else { return }
        
        if operation == .present {
            let finalFrame = context.finalFrame(for: toViewController)
            toViewController.view.frame = CGRect(x: finalFrame.minX, y: finalFrame.maxY, width: finalFrame.width, height: 0)
            context.containerView.addSubview(toViewController.view)
            
            setupAnimator(with: {
                toViewController.view.frame = finalFrame
                toViewController.view.layer.cornerRadius = 12
            }, and: { position in
                if position == .end {
                    //fromViewController.view.removeFromSuperview()
                    toViewController.view.frame = finalFrame
                }
            })
        } else {
            setupAnimator(with: {
                fromViewController.view.frame = CGRect(x: 0, y: toViewController.view.frame.maxY,
                                                       width: toViewController.view.frame.width, height: 0)
                fromViewController.view.layer.cornerRadius = 0
            }, and: { position in
                if position == .end {
                    fromViewController.view.removeFromSuperview()
                }
            })
        }
        
        if !context.isInteractive {
            animate(to: .end)
        }
    }
    
    func setupAnimator(with animations: @escaping ()->Void, and completion: @escaping (UIViewAnimatingPosition)->Void) {
        let duration = Driver.animationDuration()
        animator = UIViewPropertyAnimator(duration: duration, curve: .easeOut, animations: animations)
        animator?.addCompletion { [unowned self] position in
            completion(position)
            self.context.completeTransition(position == .end)
        }
    }

    class func animationDuration() -> TimeInterval {
        return Driver.propertyAnimator().duration
    }
    
    class func propertyAnimator( _ initialVelocity: CGVector = .zero) -> UIViewPropertyAnimator{
        let timingParameters = UISpringTimingParameters(mass: 2.5, stiffness: 1000, damping: 65, initialVelocity: initialVelocity)
        return UIViewPropertyAnimator(duration: 0 , timingParameters: timingParameters)
    }
    
    func animate(to position: UIViewAnimatingPosition) {
        animator?.isReversed = position == .start
        
        if animator?.state == .active {
            animator?.continueAnimation(withTimingParameters: nil, durationFactor: 1)
        } else {
            animator?.startAnimation()
        }
    }
    
    func pauseAnimation() {
        animator?.pauseAnimation()
        context.pauseInteractiveTransition()
    }
    
    @objc func pan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: context.containerView)
        var progress: CGFloat = abs(translation.y/context.containerView.bounds.height)
        progress = min(max(progress, 0.01), 0.99)
        print(progress)
        switch gesture.state {
        case .began,.changed:
            animator?.fractionComplete = progress
            context.updateInteractiveTransition( progress )
         //   gesture.setTranslation(CGPoint.zero, in: context.containerView)
            
        case .ended, .cancelled: endInteraction(progress)
        default: break
        }
    }
    
    func endInteraction(_ progress: CGFloat) {
        guard let animator = animator else { return }
    
        if progress > 0.2 {
            //animator.stopAnimation(false)
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 6)
            context.finishInteractiveTransition()
        }else{
            animator.isReversed = true
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 6)
            context.cancelInteractiveTransition()
        }
    }
}
