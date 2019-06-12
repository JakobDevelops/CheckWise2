//
//  AddTodoViewController.swift
//  checkwise
//
//  Created by Jakob Wiemer on 08.05.19.
//  Copyright © 2019 Jakob Wiemer. All rights reserved.
//

import UIKit
import CoreData
import AudioToolbox

class AddTodoViewController: UIViewController {
    
    var managedContext: NSManagedObjectContext!
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(with:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        
        textView.becomeFirstResponder() //Anweisung, dass die TextView direkt ausgewählt ist beim öffnen der Aktivität
            }
    
    //Maximale Länge der Eingabe = 20
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 20// 20 Limit Value
        
    }
    
    
    //Methode um den Bottom Constraint anzupassen, sobald das Keyboard sich öffnet
    @objc func keyboardWillShow(with notification: Notification){
        
        let key = "UIKeyboardFrameEndUserInfoKey"
        guard let keyboardFrame = notification.userInfo?[key] as? NSValue else {return}
        
        let keyboardHeight = keyboardFrame.cgRectValue.height + 7
        
        bottomConstraint.constant = keyboardHeight
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true)
        AudioServicesPlaySystemSound(1520)
        textView.resignFirstResponder()
        //wenn cancel gedrückt wird, wird das Keyboard instant geschlossen
    }
    
    @IBAction func done(_ sender: UIButton) {
        //Add alert message if nothing has been added and play AudioServicesPlaySystemSound(1521)
        
        AudioServicesPlaySystemSound(1520)
        guard let text = textView.text else {
            print("Bitte Text eingeben")
            return
        }
        CoreDataManager.shared.createObj(name: text)
    
        
        dismiss(animated: true)
        textView.resignFirstResponder() //schließt Keyboard direkt nachdem done gedrückt wurde
    }
}

extension AddTodoViewController: UITextViewDelegate{
    func textViewDidChangeSelection(_ textView: UITextView) {
        if doneButton.isHidden{
            textView.text.removeAll() //sobald remove gedrückt wird, wird der gesamte Text entfernt
            textView.textColor = .gray //textfarbe stat orange jetzt auf grau
            
            doneButton.isHidden = false
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
}
