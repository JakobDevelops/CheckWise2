//
//  CoreDataManager.swift
//  CheckWise2
//
//  Created by Jakob Wiemer on 29.05.19.
//  Copyright © 2019 Jakob Wiemer. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    public var todos = [Todo]()
    
    // Cotnext als Variable
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext //Zugriff auf App-Delegate
    
    private init(){
        loadItems()
    }
    
    //Objekte erstellen
    func createObj(name: String) {
        let todo = NSEntityDescription.insertNewObject(forEntityName: "Todo", into: context) as! Todo
        //Objekte werden aus der Entitiy Todo erstellt und im Kontext abgespeichert
        
            todo.name = name
            todo.completed = false
        
            safeContext()
            print("Objekt erstellt und gesichert.")
    }
    
    //Count Array
    func getNumberOfItem() -> Int {
        return todos.count
    }
    
    func getTodoItem(index: Int) -> Todo {
        return todos[index]
    }
    
    //Objekte laden
    func loadItems(){
        let request = NSFetchRequest<Todo>(entityName: "Todo")
        
        do {
            todos = try context.fetch(request)
            print("Geladen")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getIndex(item: Todo) -> Int{
        guard let index =  todos.firstIndex(of: item) else { return 0 }
        return index
    }
    
    func deleteAll (){
        //If (todo.comoplete = true){}
        todos.removeAll()
        CoreDataManager.shared.safeContext()
    }
    
    func deleteItems(item2: Todo){
        todos.remove(at: getIndex(item: item2))
        CoreDataManager.shared.safeContext()
    }
    
    //Context speichern: Objekte werden gespeichert
    func safeContext(){
        do {
            try context.save()
        } catch  {
            print(error.localizedDescription)
        }
    }
}
