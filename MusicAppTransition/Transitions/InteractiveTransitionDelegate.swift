//
//  SlideOutMenuTransitioningDelegate.swift
//  HamburgerMenu
//
//  Created by lynx on 01/09/2018.
//  Copyright © 2018 Gulnaz. All rights reserved.
//

import UIKit

class InteractiveTransitionDelegate: NSObject, InteractiveTransitionDelegateProtocol{
    let interactiveTransition = VerticalInteractiveTransition()
  
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = PresentAnimator()
        animator.maxHeight = interactiveTransition.maxHeight
        
        return animator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissAnimator()
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransition
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransition
    }
}
