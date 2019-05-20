//
//  ChevronViewController.swift
//  MusicAppTransition
//
//  Created by lynx on 10/05/2019.
//  Copyright © 2019 Gulnaz. All rights reserved.
//

import UIKit

class ChevronViewController: UIViewController {
    private let contentController: UIViewController
    private let backgroundColor: UIColor
    private let transition = UpTransition()
    private let chevronView: ChevronView = ChevronView(frame: .zero)
    private var wantsInteractive = false
    private var gesture: UIPanGestureRecognizer?
    
    init(_ contentController: UIViewController, withBackgroundColor backgroundColor: UIColor = .white) {
        self.contentController = contentController
        self.backgroundColor = backgroundColor
        super.init(nibName: nil, bundle: nil)
        
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        view.backgroundColor = backgroundColor
        gesture = UIPanGestureRecognizer(target: self, action: #selector(pan))
        view.addGestureRecognizer(gesture!)
    }
    
    private func setupLayout() {
        addChildViewController(contentController)
        let margins = view.layoutMarginsGuide
        
        view.addSubview(chevronView)
        chevronView.translatesAutoresizingMaskIntoConstraints = false
        chevronView.topAnchor.constraint(equalTo: view.topAnchor, constant: 13).isActive = true
        chevronView.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        chevronView.widthAnchor.constraint(equalToConstant: 37).isActive = true
        chevronView.heightAnchor.constraint(equalToConstant: 12).isActive = true
        
        let contentView: UIView = contentController.view
        view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: chevronView.bottomAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        contentController.didMove(toParentViewController: self)
        view.setNeedsLayout()
    }
    
    override func viewDidLayoutSubviews() {
        chevronView.setupLayers()
        chevronView.down()
    }
    
    @objc func pan(_ gesture: UIPanGestureRecognizer){
        switch gesture.state {
        case .began:
            wantsInteractive = true
            self.dismiss(animated: true, completion: nil)
        case .ended, .cancelled, .failed:
            wantsInteractive = false
        default:
            break
        }
    }
}

extension ChevronViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.state = .presentWithAnimations(Animations(direct: self.chevronView.down, cancel: self.chevronView.neutral))
        return transition
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.state = .dismissWithAnimations(Animations(direct: self.chevronView.neutral, cancel: self.chevronView.down))
        return transition
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if !wantsInteractive {
            return nil
        }
        
        transition.panGestureRecognizer = gesture
        return transition
    }
}
