//
//  ViewController.swift
//  MusicAppTransition
//
//  Created by lynx on 09/09/2018.
//  Copyright © 2018 Gulnaz. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var stopLabel: UILabel!
    @IBOutlet weak var showButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showMrMeeseeks(_ sender: Any) {
        let details = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        self.present(details, animated: true, completion: nil)
    }
    
    lazy var present = PresentTransition()
    lazy var dismiss = PresentTransition()
}

//
//extension MainViewController: UIViewControllerTransitioningDelegate{
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
//        dismiss.wantsInteractiveStart = true
//        return dismiss
//    }
//    
//    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
//        dismiss.operation = .dismiss
//        //  dismiss.completionSpeed = 1
//        dismiss.wantsInteractiveStart = true
//        
//        return dismiss
//    }
//}


extension MainViewController: TopLimitationFrameProvider {
    var limitFrame: CGRect {
        return stopLabel.frame
    }
    
    var gap: CGFloat {
        return 10
    }
    
    
}

