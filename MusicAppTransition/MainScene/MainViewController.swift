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
        let detailsWithChevronController = ChevronViewController(details, withBackgroundColor: #colorLiteral(red: 0.4902378321, green: 0.8693413138, blue: 0.9952403903, alpha: 1))
        self.present(detailsWithChevronController, animated: true, completion: nil)
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

