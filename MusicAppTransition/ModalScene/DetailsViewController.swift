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
    private var audioPlayer: AVAudioPlayer?
    @IBOutlet weak var ch: ChevronView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let soundUrl = Bundle.main.url(forResource: "sound", withExtension: "wav") {
            audioPlayer = try? AVAudioPlayer(contentsOf: soundUrl)
            audioPlayer?.play()
        }
    }
}
