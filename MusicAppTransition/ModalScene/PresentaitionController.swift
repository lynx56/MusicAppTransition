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
        dimmingView.isUserInteractionEnabled = true
    }
    
    override var shouldRemovePresentersView: Bool {
        return true
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
    
        dimmingView.alpha = 1
        dimmingView.frame = containerView.frame
        dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        dimmingView.accessibilityIdentifier = "dimming"
        if let snapshot = presentingViewController.view.snapshotView(afterScreenUpdates: false) {
            snapshot.isUserInteractionEnabled = false
            snapshot.tag = 100
            containerView.addSubview(snapshot)
        }
        containerView.addSubview(dimmingView)
        
    }
    
    override func dismissalTransitionWillBegin() {
        dimmingView.alpha = 1
 
        presentingViewController.transitionCoordinator?.animate(alongsideTransition: { [unowned self] _ in
            self.dimmingView.alpha = 0
        })
    }

    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            dimmingView.removeFromSuperview()
            containerView?.viewWithTag(100)?.removeFromSuperview()
        } else {
            dimmingView.alpha = 1
        }
    }

    @objc func dimmmingViewTapped(_ gesture: UITapGestureRecognizer) {
        guard gesture.state == .ended else { return }
        
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}
