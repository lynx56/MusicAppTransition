//
//  ViewController.swift
//  MusicAppTransition
//
//  Created by lynx on 09/09/2018.
//  Copyright © 2018 Gulnaz. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    let shared = TransitionDelegate()
    @IBAction func showMrMeeseeks(_ sender: Any) {
        let details = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        shared.presentAnimator.wantsInteractiveStart = false

        details.transitioningDelegate = shared
        self.present(details, animated: true, completion: nil)
    }
}

