//
//  ViewController.swift
//  CheckWise2
//
//  Created by Jakob Wiemer on 28.05.19.
//  Copyright © 2019 Jakob Wiemer. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    @IBOutlet var todoTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        todoTableView.delegate = self //Abspeicherung einer Referenz zum ViewController
        todoTableView.dataSource = self
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
        return CoreDataManager.shared.getNumberOfItem() //Zeigt Anzahl der gespeicherten Elemente an in Tabelle: 6 Elemente = 6 Zeilen
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let todo = CoreDataManager.shared.getTodoItem(index: indexPath.row) //Darstellung der Todos aus dem Array an der jeweiligen Index-Stelle
        cell.textLabel?.text = todo.name
        
        checkAccessoryType(cell: cell, isCompleted: todo.completed)
        
        return cell
    }

    
    //CheckAccessory Funktion
    func checkAccessoryType(cell: UITableViewCell, isCompleted: Bool) {
        if isCompleted {
            cell.accessoryType = .checkmark
            
            //Strikethough Methode
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: cell.textLabel!.text!)
            
            attributeString.addAttribute(.strikethroughStyle, value: 1, range: NSRange(location: 0, length: cell.textLabel!.text!.count))
            
            cell.textLabel?.attributedText = attributeString
            
        } else {
            cell.accessoryType = .none
            
            //Kein Strikethrough mehr
            let underLineColor = UIColor(white: 1, alpha: 0)
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
            
            //Animation
            let range = NSMakeRange(0, self.tableView.numberOfSections)
            let sections = NSIndexSet(indexesIn: range)
            self.tableView.reloadSections(sections as IndexSet, with: .fade)
            
            //Call delete function from CoreDataManager.swift
            let todo = CoreDataManager.shared.getTodoItem(index: indexPath.row)
            CoreDataManager.shared.deleteItems(item2: todo)
            tableView.reloadData()
            
            print("Löschen")
            success(true)
        })
        deleteAction.image = UIImage(named: "trash1")
        deleteAction.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    //Alternative
    /*
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let todo = CoreDataManager.shared.getTodoItem(index: indexPath.row)
            CoreDataManager.shared.deleteItems(item2: todo)
            todoTableView.deleteRows(at: [indexPath], with: .fade)
            CoreDataManager.shared.safeContext()
            tableView.reloadData()
            print("wurde gelöscht")
        }
        
    }*/
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
