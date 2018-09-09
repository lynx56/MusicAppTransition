//
//  DetailsViewController.swift
//  MusicAppTransition
//
//  Created by lynx on 09/09/2018.
//  Copyright © 2018 Gulnaz. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var interactor: VerticalInteractiveTransition?

    @IBOutlet weak var chevronView: ChevronView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(pan)))
        
        interactor?.subscribers.removeAll()
        interactor?.subscribers.append(chevronView)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func pan(_ gesture: UIPanGestureRecognizer){
        interactor?.update(for: gesture, in: self.view, andBeginAction: { [unowned self] in
            self.dismiss(animated: true, completion: nil)
        })
    }
}
