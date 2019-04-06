//
//  MenuAnimator.swift
//  HamburgerMenu
//
//  Created by lynx on 01/09/2018.
//  Copyright © 2018 Gulnaz. All rights reserved.
//

import UIKit

class RevealAnimator: UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning{
    var maxHeight: CGFloat = 70
    var interactive = false
    private var pausedTime: CFTimeInterval = 0
    var animationDuration: TimeInterval = 1
    
    var context: UIViewControllerContextTransitioning?
    var animator: UIViewPropertyAnimator?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if interactive == true {
            let transitionLayer = transitionContext.containerView.layer
            pausedTime = transitionLayer.convertTime(CACurrentMediaTime(), from: nil)
            transitionLayer.speed = 0
            transitionLayer.timeOffset = pausedTime
        }
        pres(using: transitionContext)
    }
    
    let topView = ChevronView()
    private func pres(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from) else { fatalError("Invalid source view in transitionContext") }
        guard let toView = transitionContext.view(forKey: .to) else { fatalError("Invalid destination view in transitionContext") }
        context = transitionContext
        let finalFrame = transitionContext.finalFrame(for: transitionContext.viewController(forKey: .to)!)
    
        let oldOrigin = CGPoint(x: finalFrame.minX + finalFrame.width/2, y: finalFrame.maxY + finalFrame.height/2)
        toView.frame = CGRect(origin: oldOrigin, size: CGSize(width: finalFrame.width, height: finalFrame.height - maxHeight))
        transitionContext.containerView.addSubview(toView)
  
        if let snapshot = fromView.snapshotView(afterScreenUpdates: false){
            snapshot.isUserInteractionEnabled = false
            snapshot.tag = 100
            transitionContext.containerView.insertSubview(snapshot, belowSubview: toView)
        }
        
      
        let positionAnimation = CABasicAnimation(keyPath: "position")
        let newOrigin = CGPoint(x: finalFrame.minX + finalFrame.width/2, y: finalFrame.maxY + self.maxHeight - finalFrame.height/2)
        positionAnimation.fromValue = NSValue(cgPoint: oldOrigin)
        positionAnimation.toValue = NSValue(cgPoint: newOrigin)
        
        topView.frame = CGRect(origin: CGPoint(x: finalFrame.midX, y: maxHeight), size: CGSize(width: 40, height: 18))
        transitionContext.containerView.insertSubview(topView, aboveSubview: toView)
        
        let roundCornersAnimation = CABasicAnimation(keyPath: "cornerRadius")
        roundCornersAnimation.toValue = 12
        
        //let topViewAnimation = topView.finish(for: .down)
        
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [positionAnimation, roundCornersAnimation]
        animationGroup.duration = animationDuration
        //todo self function
        animationGroup.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        animationGroup.delegate = self
        animationGroup.isRemovedOnCompletion = false
        animationGroup.fillMode = kCAFillModeForwards
    
        toView.layer.add(animationGroup, forKey: nil)
    }
    
    override func cancel() {
        restart(finishing: false)
        super.cancel()
    }
    
    override func finish() {
        restart(finishing: true)
        super.finish()
    }
    
    override func update(_ percentComplete: CGFloat) {
        super.update(percentComplete)
        let animationProgress = animationDuration * TimeInterval(percentComplete)
        context?.containerView.layer.timeOffset = pausedTime + animationProgress
    }
    
    //fix ios10 bug for layer animations
    private func restart(finishing: Bool) {
        let transitionLayer = context?.containerView.layer
        transitionLayer?.beginTime = CACurrentMediaTime()
        transitionLayer?.speed = finishing ? 1 : -1
    }
    
}

extension RevealAnimator: CAAnimationDelegate {
    
    func animationDidStart(_ anim: CAAnimation) {
        print("start")
    }
 //   func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
/*        if let context = context,
            let fromVC = context.viewController(forKey: .from),
            let toVC = context.viewController(forKey: .to){
            context.completeTransition(!context.transitionWasCancelled)
            fromVC.view.layer.removeAllAnimations()
            toVC.view.layer.mask = nil
        }
        context = nil
    }*/
}

