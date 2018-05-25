//
//  ViewController.swift
//  DemoCoreData
//
//  Created by Callsoft on 24/05/18.
//  Copyright © 2018 Callsoft. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    //MARK:-OUTLETS
    //MARK:
    
    //MARK:-VARIABLES
    //MARK:
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var itemArray = [Item]()
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
    
    func saveItems(){
        do{
           try context.save()
        }catch{
            print("Error saving context \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems(with request:NSFetchRequest<Item> = Item.fetchRequest(),predicate:NSPredicate? = nil){
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        if let additionalPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionalPredicate])
        }
        else{
            request.predicate = categoryPredicate
        }
        do{
            itemArray = try context.fetch(request)
        }catch{
            print("Error in fetching request \(error)")
        }
    }
    
    //MARK:-ACTIONS
    //MARK:
    @IBAction func addNewItemTapped(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.saveItems()
            self.itemArray.append(newItem)
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
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        cell.accessoryType = itemArray[indexPath.row].done ? .checkmark:.none
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //itemArray[indexPath.row].setValue("Completed", forKey: "title") //UPDATING DATA IN CORE DATA
        
        //DELETING DATA FROM DATABASE ORDER OF STATEMENTS MATTERS ALOT
        //context.delete(itemArray[indexPath.row])
        //itemArray.remove(at: indexPath.row)
        
        
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    //MARK:-SEARCHBAR DELEGATES
    //MARK:
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request:NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with : request,predicate: predicate)
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
