//
//  ViewController.swift
//  DemoCoreData
//
//  Created by Callsoft on 24/05/18.
//  Copyright © 2018 Callsoft. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {

    //MARK:-OUTLETS
    //MARK:
    
    //MARK:-VARIABLES
    //MARK:
    var todoItems:Results<Item>?
    let realm = try!Realm()
    var selectedCategory:Category?{
        didSet{
             loadItems()
        }
    }
    
    //MARK:-METHODS
    //MARK:
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    func initialMethod(){
        //searchBar.delegate = self
    }
    
//    func saveItems(){
//        do{
//           try context.save()
//        }catch{
//            print("Error saving context \(error)")
//        }
//        self.tableView.reloadData()
//    }
    
    func loadItems(){
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//        if let additionalPredicate = predicate{
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionalPredicate])
//        }
//        else{
//            request.predicate = categoryPredicate
//        }
//        do{
//            itemArray = try context.fetch(request)
//        }catch{
//            print("Error in fetching request \(error)")
//        }
        tableView.reloadData()
    }
    
    //MARK:-ACTIONS
    //MARK:
    @IBAction func addNewItemTapped(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory{
                do{
                try self.realm.write {
                    let newItem = Item()
                    newItem.title = textField.text!
                    newItem.dateCreated = Date()
                    currentCategory.items.append(newItem)
                    }
                }catch{
                    print("Error saving new item \(error)")
                }
            }
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextFeild) in
            alertTextFeild.placeholder = "Add New Item"
            textField = alertTextFeild
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
  
}

//MARK:-EXTENSION OF CLASS
//MARK:
extension TodoListViewController:UISearchBarDelegate{
    //TODO:-DATASOURCE AND DELEGATE OF TABLEVIEW
    //TODO:
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row]{
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark:.none
        }
        else{
            cell.textLabel?.text = "No Items Added Yet!"
        }
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         //**********UPDATING AND DELETING DATA USING REALM***********//
        if let item = todoItems?[indexPath.row]{
            do{
                try realm.write {
                    //realm.delete(item) //deleting items from realm
                    item.done = !item.done
                }
            }catch{
                print("Error saving done status, \(error)")
            }
        }
        
        
        //**********UPDATING AND DELETING DATA USING CORE DATA***********//
        
        //itemArray[indexPath.row].setValue("Completed", forKey: "title") //UPDATING DATA IN CORE DATA
        
        //DELETING DATA FROM DATABASE ORDER OF STATEMENTS MATTERS ALOT
        //context.delete(itemArray[indexPath.row])
        //itemArray.remove(at: indexPath.row)
        
        
        
        //todoItems[indexPath.row].done = !todoItems[indexPath.row].done
//        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    //MARK:-SEARCHBAR DELEGATES
    //MARK:
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            DispatchQueue.main.async {
            searchBar.resignFirstResponder()
            }
            
        }
    }
}
