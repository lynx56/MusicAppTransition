//
//  ChevronViewController.swift
//  MusicAppTransition
//
//  Created by lynx on 10/05/2019.
//  Copyright © 2019 Gulnaz. All rights reserved.
//

import UIKit

class ChevronViewController: UIViewController {
    private let _contentController: UIViewController
    private var present: UpTransition
    private var wantsInteractive = false
    private var gesture: UIPanGestureRecognizer?
    private var chevronView: ChevronView
    
    init(_ contentController: UIViewController) {
        _contentController = contentController
        present = UpTransition()
        chevronView = ChevronView(frame: .zero)
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
        view.backgroundColor = #colorLiteral(red: 0.4902378321, green: 0.8693413138, blue: 0.9952403903, alpha: 1)
        
        gesture = UIPanGestureRecognizer(target: self, action: #selector(pan))
        view.addGestureRecognizer(gesture!)
    }
    
    private func setupLayout() {
        addChildViewController(_contentController)
        let margins = view.layoutMarginsGuide
        
        view.addSubview(chevronView)
        chevronView.translatesAutoresizingMaskIntoConstraints = false
        chevronView.topAnchor.constraint(equalTo: view.topAnchor, constant: 13).isActive = true
        chevronView.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        chevronView.widthAnchor.constraint(equalToConstant: 37).isActive = true
        chevronView.heightAnchor.constraint(equalToConstant: 12).isActive = true
        
        let contentView: UIView = _contentController.view
        view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: chevronView.bottomAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        _contentController.didMove(toParentViewController: self)
        view.setNeedsLayout()
    }
    
    override func viewDidLayoutSubviews() {
        chevronView.updateLayers()
        chevronView.down()
    }
    
    @objc func pan(_ gesture: UIPanGestureRecognizer){
        if gesture.state == .began  {
            wantsInteractive = true
            self.dismiss(animated: true, completion: nil)
        }
        if gesture.state == .ended {
            wantsInteractive = false
        }
    }
}

extension ChevronViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        present.state = .presentWithAnimations(Animations(direct: self.chevronView.down, cancel: self.chevronView.neutral))
        present.animator = nil
        return present
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        present.state = .dismissWithAnimations(Animations(direct: self.chevronView.neutral, cancel: self.chevronView.down))
        present.animator = nil
        return present
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if !wantsInteractive {
            return nil
        }
        
        present.panGestureRecognizer = gesture
        return present
    }
}
