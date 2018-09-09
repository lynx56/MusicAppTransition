//
//  ViewController.swift
//  MusicAppTransition
//
//  Created by lynx on 09/09/2018.
//  Copyright © 2018 Gulnaz. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    var interactiveTransitionDelegate: InteractiveTransitionDelegateProtocol = InteractiveTransitionDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showMrMeeseeks(_ sender: Any) {
        self.interactiveTransitionDelegate.interactiveTransition.maxHeight = UIScreen.main.bounds.height - 70
        let details = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        details.transitioningDelegate = interactiveTransitionDelegate
        details.interactor = interactiveTransitionDelegate.interactiveTransition
        self.present(details, animated: true, completion: nil)
    }
    
}

