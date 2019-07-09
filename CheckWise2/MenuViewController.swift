//
//  MenuViewController.swift
//  CheckWise2
//
//  Created by Jakob Wiemer on 28.06.19.
//  Copyright © 2019 Jakob Wiemer. All rights reserved.
//

import UIKit
import AudioToolbox

class MenuViewController: UITableViewController {

    enum MenuType: Int {
        case support
        case about
        case synro
    }
    
    //Closing the menu
    @IBAction func backHome(_ sender: Any) {
        dismiss(animated: true)
        print("Tap on back home")
    }
    
    @IBAction func backHome2(_ sender: UIButton) {
        dismiss(animated: true)
        print("Tap on back home")
    }
    
    
    //Opening view controllers
    @IBAction func buttonSupport(_ sender: UIButton) {
        openSupport()
        print("Tap on Support")
    }
    
    @IBAction func buttonAbout(_ sender: UIButton) {
        openAbout()
        print("Tap on About")
    }

    @IBAction func buttonSyncho(_ sender: UIButton) {
        openSync()
        print("Tap on Synchronisation")
    }
    
    
    //Methods to open specific view controllers
    func openSupport() {
        guard  let creditViewContoller = storyboard?.instantiateViewController(withIdentifier: "support") as? CreditViewController else { return }
        present(creditViewContoller, animated: true)
    }
    
    func openSync() {
        guard  let syncViewController = storyboard?.instantiateViewController(withIdentifier: "snyc") as? SyncViewController else { return }
        present(syncViewController, animated: true)
    }
    
    func openAbout() {
        guard  let aboutViewController = storyboard?.instantiateViewController(withIdentifier: "about") as?
            AboutViewController else { return }
        present(aboutViewController, animated: true)
    }
    
    //viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }

}
