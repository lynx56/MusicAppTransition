//
//  PresentaitionController.swift
//  MusicAppTransition
//
//  Created by lynx on 18/04/2019.
//  Copyright © 2019 Gulnaz. All rights reserved.
//

import UIKit

protocol TopLimitationFrameProvider {
    var limitFrame: CGRect { get }
    var gap: CGFloat { get }
}

class PresentationController: UIPresentationController {
    private let dimmingView = UIView()
    
    override init(presentedViewController: UIViewController,
         presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dimmmingViewTapped))
        dimmingView.addGestureRecognizer(tap)
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return .zero }
        guard let provider = presentingViewController as? TopLimitationFrameProvider
            else { assertionFailure("PresentedViewController not implemented TopLimitationFrameProvider protocol")
                   return containerView.bounds }
        
        return CGRect(x: 0,
                      y: containerView.bounds.minY + provider.limitFrame.maxY + provider.gap,
                      width: containerView.bounds.width,
                      height: containerView.bounds.height - provider.limitFrame.maxY - provider.gap)
    }
    
    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else { return }
        
        dimmingView.alpha = dimmingViewAlpha
        dimmingView.frame = containerView.frame
        dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        containerView.addSubview(dimmingView)
        dimmingView.addSubview(presentedViewController.view)
        
        presentingViewController.transitionCoordinator?.animate(alongsideTransition: { [unowned self] _ in
            self.dimmingView.alpha = self.dimmingView.alpha
        }) { [unowned self] _ in
            if self.isPresentingOnAnotherDimmedView {
                self.dimmingView.backgroundColor = .clear
                self.dimmingView.alpha = 1
            }
        }
        
    }
    
    override func dismissalTransitionWillBegin() {
        dimmingView.alpha = 1
        presentingViewController.transitionCoordinator?.animate(alongsideTransition: { [unowned self] _ in
            self.dimmingView.alpha = 0
        })
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        dimmingView.removeFromSuperview()
    }
    
    @objc func dimmmingViewTapped(_ gesture: UITapGestureRecognizer) {
        guard gesture.state == .ended else { return }
        presentingViewController.dismiss(animated: true, completion: nil)
    }
    
    private var isPresentingOnAnotherDimmedView: Bool {
        return presentingViewController.presentationController as? PresentationController != nil
    }
    
    private var dimmingViewAlpha: CGFloat {
        return isPresentingOnAnotherDimmedView ? 0 : 1
    }
}
