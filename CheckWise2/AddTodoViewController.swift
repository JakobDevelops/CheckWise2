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
    @IBOutlet weak var cancelButton: UIButton!
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
        textView.resignFirstResponder()
        //wenn cancel gedrückt wird, wird das Keyboard instant geschlossen
    }
    
    @IBAction func done(_ sender: UIButton) {
        
        if (getLenght() > 0){
        
            AudioServicesPlaySystemSound(1522)
            createItem()
            
        } else {
        
            AudioServicesPlaySystemSound(1521)
            let alert = UIAlertController(title: "Wait a minute!", message: "You haven't typed anything. Are you sure you want to proceed?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                self.createItem()}))
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
        }
    }
    
    func getLenght() -> Int {
        return textView.text.count
    }
    
    func createItem(){
        AudioServicesPlaySystemSound(1520)
        guard let text = textView.text else {
            print("Bitte Text eingeben")
            return
        }
        
        CoreDataManager.shared.createObj(name: text)
        dismiss(animated: true)
        textView.resignFirstResponder()
    }
    
    //Maximale Länge der Eingabe = 20
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 20// Max 20 Characters
        
    }
    
    //Segmented Control to mark todos as important
    @IBAction func indexChanged(_ sender: Any) {
        
        if (getLenght() > 1){
            
            AudioServicesPlaySystemSound(1522)
            switch segmentedControl.selectedSegmentIndex {
                
            case 0:
                guard let text = textView.text else {
                    return
                }
                
                CoreDataManager.shared.createObj(name: text)
                dismiss(animated: true)
                textView.resignFirstResponder()
                
            case 1:
                let text = textView.text + "!"
                
                CoreDataManager.shared.createObj(name: text)
                dismiss(animated: true)
                textView.resignFirstResponder()
                
            default:
                break
            }
            
        } else {
            
            AudioServicesPlaySystemSound(1521)
            let alert = UIAlertController(title: "Wait a minute!", message: "You haven't typed anything. Are you sure you want to proceed?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                self.createItem()}))
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
        }
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

@IBDesignable extension UIButton {
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}

