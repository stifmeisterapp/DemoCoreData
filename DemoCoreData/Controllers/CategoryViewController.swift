//
//  CategoryViewController.swift
//  DemoCoreData
//
//  Created by Callsoft on 25/05/18.
//  Copyright © 2018 Callsoft. All rights reserved.
//

import UIKit
import RealmSwift
class CategoryViewController: UITableViewController {

    
    //MARK:-VARIABLES
    //MARK:
    let realm = try! Realm()
    var categoryArray:Results<Category>?
    
    
    //MARK:-METHODS
    //MARK:
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func saveCategories(category:Category){
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("Error in saving category \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadCategories(){
          categoryArray = realm.objects(Category.self)
        self.tableView.reloadData()
    }
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categoryArray?.count ?? 1
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Category Added Yet!"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "gotoItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            vc.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK:-ACTIONS
    //MARK:
    
    @IBAction func btnAddTapped(_ sender: UIBarButtonItem) {
        var textFeild = UITextField()
        let alert = UIAlertController(title: "Add New Category Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = textFeild.text!
            self.saveCategories(category: newCategory)
            self.tableView.reloadData()
        }
        alert.addTextField { (actionTextFeid) in
            actionTextFeid.placeholder = "Add New Category"
            textFeild = actionTextFeid
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
  

}

