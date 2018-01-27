//
//  ViewController.swift
//  ToDoEy
//
//  Created by Oliver Sutton on 26/01/2018.
//  Copyright © 2018 IOSDevelopment-Ollie. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray: [Item] = [Item]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        loadItems()
        
    }
    
    //MARK: Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel!.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
        
    }
    
    //MARK: TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: Add New Items
    
    @IBAction func addButtonPress(_ sender: UIBarButtonItem) {
        
        var textField: UITextField = UITextField()
        
        let alert = UIAlertController(title: "Add new item to ToDoEy", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            // What happens when the user touches the add item button.
            
            if textField.text! != "" {
                
                let newItem = Item()
                newItem.title = textField.text!
                
                self.itemArray.append(newItem)
                
                self.saveItems()
                
            }
            
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add a new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: Deals with encoding and decoding data.
    
    func saveItems() {
        
        // Saves the data to user defaults allowing the user to have persistent data.
        let encoder = PropertyListEncoder()
        
        do {
            
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
            
        } catch {
            print("Error encoding or saving data, \(error)")
        }
    }
    
    func loadItems() {
        
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
            itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print(error)
            }
        }
        
    }
}

