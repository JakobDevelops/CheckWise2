//
//  MenuViewController.swift
//  CheckWise2
//
//  Created by Jakob Wiemer on 28.06.19.
//  Copyright © 2019 Jakob Wiemer. All rights reserved.
//

import UIKit

class MenuViewController: UITableViewController {

    enum MenuType: Int {
        case support
        case about
        case synro
    }
    
    @IBAction func backHome(_ sender: Any) {
        dismiss(animated: true)
        print("Tap on back home")
    }
    
    @IBAction func buttonSupport(_ sender: UIButton) {
        openSupport()
        print("Tap on Support")
    }
    
    @IBAction func buttonAbout(_ sender: UIButton) {
        print("Tap on About")
    }

    @IBAction func buttonSyncho(_ sender: UIButton) {
        dismiss(animated: true)
        print("Tap on Synchronisation")
    }
    
    func openSupport() {
        guard  let creditViewContoller = storyboard?.instantiateViewController(withIdentifier: "support") as? CreditViewController else { return }
        present(creditViewContoller, animated: true)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    /*
    var didTapMenuType: ((MenuType) -> Void)?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let menuType = MenuType(rawValue: indexPath.row) else {return}
        dismiss(animated: true) {[weak self] in
        print("Dismissing: \(menuType)")
            self?.didTapMenuType?(menuType)}
    }*/

}
