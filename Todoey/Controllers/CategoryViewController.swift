//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Zain Shaikh on 30/11/2018.
//  Copyright © 2018 Zain Shaikh. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController { 
    


    let realm = try! Realm()
    
    var arrayItem: Results<Category>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 80.0
        reloadData()
        
    }
    
    //MARK - Table View Data Source Method
  override  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayItem?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = arrayItem?[indexPath.row].name ?? "No Category Added yet"
        
        if let hexclr = arrayItem?[indexPath.row].colorBG {
            cell.backgroundColor = UIColor(hexString: hexclr)
            
        }
       
        return cell
    }
    
    //MARK - Table view delegate method

    
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(arrayItem[indexPath.row])

    performSegue(withIdentifier: "gotoCell", sender: self)
    
    tableView.deselectRow(at: indexPath, animated: true)
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoListViewController
        
        if let index = tableView.indexPathForSelectedRow {
           
            destinationVC.categoryType = arrayItem?[index.row]
            
        }
    }
    
    //MARK - DATA MANIPULATION METHOD
    
    
    
    //MARK - add category
    
    @IBAction func addBtn(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Add Category", message: "Type New Category", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Save", style: .default) { (addaction) in
            
            if textfield.text?.isEmpty == true {
                let empAlert = UIAlertController(title: "Warning", message: "Please Enter Any Item", preferredStyle: .alert)
                
                let okay = UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
                    empAlert.dismiss(animated: true, completion: nil)
                    self.present(alert, animated: true, completion: nil)
                })
                
                empAlert.addAction(okay)
                
                self.present(empAlert, animated: true, completion: nil)
            }else {
            
                let newItem = Category()
                newItem.name = textfield.text!
                newItem.colorBG  = UIColor.randomFlat.hexValue()
                self.saveItem(category: newItem)
                
        }
        }
        
        alert.addTextField { (addText) in
            addText.placeholder = "Create new category"
            
            textfield = addText
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
    
    
    
    
    
    
    
    
    
    func saveItem(category: Category){
        
        do{
          try realm.write {
                realm.add(category)
            }
            
        }catch{
            print("error save data :: \(error)")
        }
        tableView.reloadData()
    }
    

    func reloadData(){

        arrayItem = realm.objects(Category.self)
        
        

        tableView.reloadData()
    }
    
    override func updateData(at indexpath: IndexPath) {

        if let itemdlt = self.arrayItem?[indexpath.row] {
                        do {
                            try self.realm.write {
                                self.realm.delete(itemdlt)
                            }
                        }catch {
                            print("error in deleting item \(error)")
                        }
    }
}

}
