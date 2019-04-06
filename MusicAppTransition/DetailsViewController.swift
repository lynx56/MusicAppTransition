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

  //  @IBOutlet weak var chevronView: ChevronView!
    let shared = TransitionDelegate()
    override func viewDidLoad() {
        super.viewDidLoad()

        transitioningDelegate = shared
        shared.dismissAnimator.wantsInteractiveStart = true
        shared.presentAnimator.wantsInteractiveStart = false
        self.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(pan)))

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
    
    @objc func pan(_ gesture: UIPanGestureRecognizer){
        shared.dismissAnimator.update(for: gesture, in: self.view, andBeginAction: {
            self.dismiss(animated: true, completion: nil)
        })
    }
}
