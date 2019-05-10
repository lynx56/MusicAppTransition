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
    
    @IBAction func showMrMeeseeks(_ sender: Any) {
        let details = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        self.present(details, animated: true, completion: nil)
    }
}

extension MainViewController: TopLimitationFrameProvider {
    var limitFrame: CGRect {
        return stopLabel.frame
    }
    
    var gap: CGFloat {
        return 5
    }
}

