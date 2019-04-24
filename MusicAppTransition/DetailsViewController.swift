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
    var audioPlayer: AVAudioPlayer?
    @IBOutlet weak var chevronView: ChevronView!
    
    override func awakeFromNib() {
        modalPresentationStyle = .custom
        transitioningDelegate = self
        view.addSubview(chevronView)
    }
    var gesture: UIPanGestureRecognizer?
   override func viewDidLoad() {
        super.viewDidLoad()
        gesture = UIPanGestureRecognizer(target: self, action: #selector(pan))
        self.view.addGestureRecognizer(gesture!)
        chevronView.direction = .down
    
  //      self.transitioningDelegate = self
    
    /*
        if let soundUrl = Bundle.main.url(forResource: "sound", withExtension: "wav") {
            audioPlayer = try? AVAudioPlayer(contentsOf: soundUrl)
            audioPlayer?.play()
        }
 */
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    var transitionBegan = false
    @objc func pan(_ gesture: UIPanGestureRecognizer){
        if !transitionBegan && gesture.state == .changed  {
            self.dismiss(animated: true, completion: nil)
            transitionBegan = true
        }
    }
    
    lazy var present = PresentTransition()
    lazy var dismiss = PresentTransition()
}

extension DetailsViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PresentationController(presentedViewController: presented, presenting: presenting)
    }
    

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        present.operation = .present
        present.startInteractive = false
        return present
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        present.operation = .present
        present.startInteractive = false
        present.panGestureRecognizer = gesture
        return present
    }
    
        func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            dismiss.operation = .dismiss
            dismiss.startInteractive = false
             dismiss.panGestureRecognizer = gesture
            return dismiss
        }
    
        func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
            dismiss.operation = .dismiss
            dismiss.startInteractive = true
            dismiss.panGestureRecognizer = gesture
            return dismiss
        }
}

extension DetailsViewController: AnimatableViewProvider {
    var animateCancel: () -> Void {
        return { }
    }
    
    func animate() -> () -> Void {
        return chevronView.finishAnimation()
    }
}


//
//class TransitionDelegate: NSObject, UIViewControllerTransitioningDelegate{
//    lazy var present = PresentTransition()
//    lazy var dismiss = PresentTransition()
//
//    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        present.operation = .present
//        present.wantsInteractiveStart = false
//        return present
//    }
//
//    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
//        present.operation = .present
//        present.wantsInteractiveStart = false
//        return present
//    }
//
//    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        dismiss.operation = .dismiss
//     //   dismiss.completionSpeed = 1
//        dismiss.wantsInteractiveStart = true
//        dismiss.completionSpeed = 0.9999
//        return dismiss
//    }
//
//    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
//        dismiss.operation = .dismiss
//      //  dismiss.completionSpeed = 1
//        dismiss.wantsInteractiveStart = true
//        dismiss.completionSpeed = 0.9999
//
//        return dismiss
//    }
//}
//
