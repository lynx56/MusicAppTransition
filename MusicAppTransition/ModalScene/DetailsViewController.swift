//
//  DetailsViewController.swift
//  MusicAppTransition
//
//  Created by lynx on 09/09/2018.
//  Copyright © 2018 Gulnaz. All rights reserved.
//

import UIKit
import AVFoundation

class DetailsViewController: UIViewController {
    @IBOutlet weak var chevronView: ChevronView!
    
    private var audioPlayer: AVAudioPlayer?
    private var present: UpTransition!
    private var wantsInteractive = false
    private var gesture: UIPanGestureRecognizer?

    override func awakeFromNib() {
        present = UpTransition(originView: self.view)
        modalPresentationStyle = .custom
        transitioningDelegate = self
        view.addSubview(chevronView)
    }
    
   override func viewDidLoad() {
        super.viewDidLoad()
        gesture = UIPanGestureRecognizer(target: self, action: #selector(pan))
        self.view.addGestureRecognizer(gesture!)
    
        if let soundUrl = Bundle.main.url(forResource: "sound", withExtension: "wav") {
            audioPlayer = try? AVAudioPlayer(contentsOf: soundUrl)
            audioPlayer?.play()
        }
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

extension DetailsViewController: UIViewControllerTransitioningDelegate {
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

