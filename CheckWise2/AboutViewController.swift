//
//  About.swift
//  CheckWise2
//
//  Created by Jakob Wiemer on 09.07.19.
//  Copyright © 2019 Jakob Wiemer. All rights reserved.
//

import UIKit
import AudioToolbox
import AVFoundation

class AboutViewController: UIViewController {

    @IBOutlet weak var rocket: UIImageView!
    var player: AVAudioPlayer!

    
    @IBAction func cancel(_ sender: UIButton) {
        AudioServicesPlaySystemSound(1520)
        dismiss(animated: true, completion: nil)
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
    
        //Play sound
        let path = Bundle.main.path(forResource: "rocket_sound", ofType: "mp3")!
        let url = URL(fileURLWithPath: path)
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
        } catch {
            print(error.localizedDescription)
        }
        
        player.play()
        
        //Animation
        UIView.animate(withDuration: 2.0, delay: 0.0, options: .curveEaseIn, animations:{
            self.rocket.frame = CGRect (x: 200, y: -100, width: 82, height: 119)
        }){
            (finished) in
            self.rocket.isHidden = true
        }
    }
    
}
