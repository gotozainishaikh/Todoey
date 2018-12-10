//
//  ViewController.swift
//  Todoey
//
//  Created by Zain Shaikh on 26/11/2018.
//  Copyright © 2018 Zain Shaikh. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {

    

    let date = Date()
    let formatter = DateFormatter()
    
    var todoItem: Results<Item>?
    
    let realm = try? Realm()
    var categoryType : Category? {
        didSet{
           loadData()
        }
    }
    
    
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        tableView.rowHeight = 80.0
//        print(dataFilePath)
//         print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
//

//        loadData()

        // Do any additional setup after loading the view, typically from a nib.
        
//        if  let item = defaults.array(forKey: "myList") as? [Items] {
//            arrayItems = item
//        }
    }
    
    //MARK - Table View Datasource Method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItem?.count ?? 1
    } 
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = todoItem?[indexPath.row] {
            cell.textLabel?.text = todoItem?[indexPath.row].title
            
            cell.accessoryType = item.done == true ? .checkmark : .none
          
            if let mainclr = UIColor(hexString: categoryType?.colorBG ?? "") {
                if let color = mainclr.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(todoItem!.count)){
                    cell.backgroundColor = color
                    cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
                }
            }
           
        }else {
            cell.textLabel?.text = "NO Item added"
        }
        
        return cell
    }
    
    //MARK - Table View Delegate Method
    
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(arrayItems[indexPath.row])
    
//    if todoItem[indexPath.row].done == false {
//        todoItem[indexPath.row].done = true
//    }else {
//        todoItem[indexPath.row].done = false
//    }
        if let item = todoItem?[indexPath.row] {
            do {
                try realm?.write {
                    item.done = !item.done
                }
            }catch {
                print("Error in checking \(error)")
            }
        }
    
    tableView.reloadData()
    
    tableView.deselectRow(at: indexPath, animated: true)
    }

    
    //MARK - Add new item
    
    @IBAction func btnAdd(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if textField.text?.isEmpty == true {
                let empAlert = UIAlertController(title: "Warning", message: "Please Enter Any Item", preferredStyle: .alert)
                
                let okay = UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
                    empAlert.dismiss(animated: true, completion: nil)
                    self.present(alert, animated: true, completion: nil)
                })
                
                empAlert.addAction(okay)
                
                self.present(empAlert, animated: true, completion: nil)
            }else {
            
                if let currentCategory = self.categoryType {
                    do {
                        try self.realm!.write {
                            let newItem = Item()
                            newItem.title = textField.text!
                            newItem.done = false
                            currentCategory.item.append(newItem)
                            
                            newItem.dateCreated = Date()
                            
                        }
                    }catch {
                        print("Error while saving item \(error)")
                    }
                }
                
              self.tableView.reloadData()
                

//                self.saveData()
               
            
            }
            
        }
        
        alert.addTextField { (addText) in
            addText.placeholder = "Create new item"
            textField = addText
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
//    func saveData(){
//        let encoder = PropertyListEncoder()
        
//        do {
//            let data = try encoder.encode(self.arrayItems)
//            try data.write(to: self.dataFilePath!)
            
          //  try context.save()
            
//        } catch {
//            print("Error in encoding, \(error)")
//        }
//        self.tableView.reloadData()
//    }
    
    func loadData(){

        todoItem = categoryType?.item.sorted(byKeyPath: "title", ascending: true)

        }
    
    override func updateData(at indexpath: IndexPath) {
        if let item = self.todoItem?[indexpath.row] {
            do {
                try realm?.write {
                    realm?.delete(item)
                }
            }catch {
                print(error)
            }
        }
    }

}

//MARK - UISearch Methods
extension TodoListViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        todoItem = todoItem?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            
           loadData()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
    
}

