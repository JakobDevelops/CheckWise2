//
//  CreditViewController.swift
//  CheckWise2
//
//  Created by Jakob Wiemer on 13.06.19.
//  Copyright © 2019 Jakob Wiemer. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox


class CreditViewController: UIViewController {

    @IBOutlet weak var button109: UIButton!
    @IBOutlet weak var button549: UIButton!
    @IBOutlet weak var button349: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var band: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 30, delay: 0.0, options: .curveEaseInOut, animations:{
            self.band.frame = CGRect (x: 0, y: 610, width: 1542, height: 203)
        }){
            (finished) in
            //self.creditText.isHidden = false
            //player.play()
        }
    
    }
    

    @IBAction func cancelButton(_ sender: Any) {
        AudioServicesPlaySystemSound(1520)
        dismiss(animated: true, completion: nil)
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }

}
