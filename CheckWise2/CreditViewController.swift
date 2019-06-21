//
//  CreditViewController.swift
//  CheckWise2
//
//  Created by Jakob Wiemer on 13.06.19.
//  Copyright © 2019 Jakob Wiemer. All rights reserved.
//

import UIKit
import AVFoundation

class CreditViewController: UIViewController {

    @IBOutlet weak var button109: UIButton!
    @IBOutlet weak var button549: UIButton!
    @IBOutlet weak var button349: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    
    @IBOutlet weak var milk: UIImageView!
    @IBOutlet weak var egg1: UIImageView!
    @IBOutlet weak var banana: UIImageView!
    @IBOutlet weak var apple: UIImageView!
    @IBOutlet weak var lime: UIImageView!
    @IBOutlet weak var egg2: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.1, animations:{
            self.milk.isHidden = false
        }){
            (finished) in
            //self.creditText.isHidden = false
            //player.play()
        }
        
        UIView.animate(withDuration: 0.1, delay: 0.3, animations:{
            self.banana.isHidden = false
        }){
            (finished) in
            //self.creditText.isHidden = false
            //player.play()
        }
    
    }
    
    
    
    
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true)
    }

}
