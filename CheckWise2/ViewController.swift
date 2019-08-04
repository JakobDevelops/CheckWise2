//
//  ViewController.swift
//  CheckWise2
//
//  Created by Jakob Wiemer on 28.05.19.
//  Copyright © 2019 Jakob Wiemer. All rights reserved.
//

import UIKit
import AudioToolbox

class ViewController: UITableViewController {

    @IBOutlet var todoTableView: UITableView!
    @IBOutlet weak var deleteAll: UIBarButtonItem!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* tapRecognizer
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: Selector("longPress:"))
        let tabRecognizer = UITapGestureRecognizer (target: self, action: "shortTab")
        
        self.view.addGestureRecognizer(tabRecognizer)
        self.view.addGestureRecognizer(longPressRecognizer)*/
        
        
        todoTableView.delegate = self //Abspeicherung einer Referenz zum ViewController
        todoTableView.dataSource = self
    }
    
    
    let transition = SlideInTransition()
    
    @IBAction func didTab(_ sender: UIBarButtonItem) {
        guard  let menuViewContoller = storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController else { return }
        menuViewContoller.modalPresentationStyle = .overCurrentContext
        menuViewContoller.transitioningDelegate = self
        present(menuViewContoller, animated: true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        CoreDataManager.shared.loadItems()
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if CoreDataManager.shared.getNumberOfItem() == 0 {
            tableView.setEmptyView(title: "You don't have any Todos.", message: "Enjoy your day!")
        }
        else {
            tableView.restore()
        }
        
        return CoreDataManager.shared.getNumberOfItem() //Zeigt Anzahl der gespeicherten Elemente an in Tabelle: 6 Elemente = 6 Zeilen
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let todo = CoreDataManager.shared.getTodoItem(index: indexPath.row) //Darstellung der Todos aus dem Array an der jeweiligen Index-Stelle
        cell.textLabel?.text = todo.name
        
        checkAccessoryType(cell: cell, isCompleted: todo.completed)
        
        return cell
    }

    
    //Strikethrough
    func checkAccessoryType(cell: UITableViewCell, isCompleted: Bool) {
        if isCompleted {
            cell.accessoryType = .checkmark
            
            let textColorGray = UIColor.lightGray
            cell.textLabel?.textColor = textColorGray
            
            //Strikethough Methode
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: cell.textLabel!.text!)
            
            attributeString.addAttribute(.strikethroughStyle, value: 1, range: NSRange(location: 0, length: cell.textLabel!.text!.count))
            
            cell.textLabel?.attributedText = attributeString
            
        } else {
            cell.accessoryType = .none
            
            //Kein Strikethrough mehr
            let underLineColor = UIColor(white: 1, alpha: 0)
            
            let textColor = UIColor.darkGray
            cell.textLabel?.textColor = textColor
            
            let underlineAttributes = [NSAttributedString.Key.underlineColor: underLineColor] as [NSAttributedString.Key : Any]
    
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: cell.textLabel!.text!, attributes: underlineAttributes)
            
            attributeString.addAttribute(.underlineStyle, value: 1,
                                        range: NSRange(location: 0,
                                        length: cell.textLabel!.text!.count))
            
            cell.textLabel?.attributedText = attributeString
        }
    }
    
    //Check Tab
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let todo = CoreDataManager.shared.getTodoItem(index: indexPath.row)
        
        //Haptic Feedback
        AudioServicesPlaySystemSound(1520)
        AudioServicesPlaySystemSound(1103)

        
        todo.completed = !todo.completed
        CoreDataManager.shared.safeContext()
        
        if let cell = tableView.cellForRow(at: indexPath){
            checkAccessoryType(cell: cell, isCompleted: todo.completed)
            
            //Implement: Tab or long press recognizer to tab check or update
            //performSegue(withIdentifier: "ShowAddTodo", sender: tableView.cellForRow(at: indexPath))
        }
    }
    
    //CheckSwipe
    override func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let closeAction = UIContextualAction(style: .normal, title:  "Check", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            
            //Haptic Feedback
            AudioServicesPlaySystemSound(1519)
            
            let todo = CoreDataManager.shared.getTodoItem(index: indexPath.row)
            todo.completed = !todo.completed
            CoreDataManager.shared.safeContext()
            
            if let cell = tableView.cellForRow(at: indexPath){
                self.checkAccessoryType(cell: cell, isCompleted: todo.completed)
            }
            
            print("OK, marked as Closed")
            success(true)
        })
        closeAction.backgroundColor = .blue
        closeAction.image = UIImage(named: "check")

        
        return UISwipeActionsConfiguration(actions: [closeAction])
        
    }
    
    //Delete Swipe
    override func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        
        let deleteAction = UIContextualAction(style: .destructive, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            
            //Haptic Feedback
            AudioServicesPlaySystemSound(1519)
            //AudioServicesPlaySystemSound(1305)
            
            //Animation
            let range = NSMakeRange(0, self.tableView.numberOfSections)
            let sections = NSIndexSet(indexesIn: range)
            self.tableView.reloadSections(sections as IndexSet, with: .fade)
            
            //Call delete function from CoreDataManager.swift
            let todo = CoreDataManager.shared.getTodoItem(index: indexPath.row)
            CoreDataManager.shared.deleteItems(item2: todo)
            tableView.reloadData()
            success(true)
        })
        deleteAction.image = UIImage(named: "trash1")
        deleteAction.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    @IBAction func deleteAll(_ sender: Any) {
        //Haptic Feedback
        AudioServicesPlaySystemSound(1102)
    
        //Animation
        let range = NSMakeRange(0, self.tableView.numberOfSections)
        let sections = NSIndexSet(indexesIn: range)
        self.tableView.reloadSections(sections as IndexSet, with: .left)
        
        //Delete and Reload
        CoreDataManager.shared.deleteAllRecords()
        tableView.reloadData()
    }
    
   

    
    /*Gesture
     func longPress(longPressGestureRecognizer: UILongPressGestureRecognizer) {
     
     if longPressGestureRecognizer.state == UIGestureRecognizer.State.began {
     
     let touchPoint = longPressGestureRecognizer.location(in: self.view)
     if let indexPath = tableView.indexPathForRow(at: touchPoint) {
     
     let todo = CoreDataManager.shared.getTodoItem(index: indexPath.row)
     print("Klappt")
     
     // your code here, get the row for the indexPath or do whatever you want
     }
     }
     }*/
    

}

extension ViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
       transition.isPresenting = false
        return transition
    }
}

extension UITableView {
    func setEmptyView(title: String, message: String) {
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        let titleLabel = UILabel()
        let messageLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        messageLabel.textColor = UIColor.lightGray
        messageLabel.font = UIFont(name: "HelveticaNeue-Regular", size: 17)
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageLabel)
        titleLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 20).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -20).isActive = true
        titleLabel.text = title
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        // The only tricky part is here:
        self.backgroundView = emptyView
        self.separatorStyle = .none
    }
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}


