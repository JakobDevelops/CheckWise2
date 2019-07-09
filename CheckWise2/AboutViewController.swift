//
//  About.swift
//  CheckWise2
//
//  Created by Jakob Wiemer on 09.07.19.
//  Copyright © 2019 Jakob Wiemer. All rights reserved.
//

import UIKit
import AudioToolbox

class AboutViewController: UIViewController {

    @IBAction func cancel(_ sender: UIButton) {
        AudioServicesPlaySystemSound(1520)
        dismiss(animated: true, completion: nil)
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
}
