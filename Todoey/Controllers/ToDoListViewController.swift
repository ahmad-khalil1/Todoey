//
//  ViewController.swift
//  Todoey
//
//  Created by ahmad$$ on 4/11/19.
//  Copyright © 2019 ahmad. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    // declare intant variabel

    var toDoArray = [Items]()
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let newItem = Items()
        newItem.title = "get milk"
        toDoArray.append(newItem)
        
        let newItem1 = Items()
        newItem1.title = "play football "
        toDoArray.append(newItem1)
       
        
        
         //retrive the data from the user default , doing the binary check
        if let itemsArrayRetrived = defaults.array(forKey: "toDoArray") as? [Items]  {
            toDoArray = itemsArrayRetrived
        }

    }

 ////////////////////////////////////////////////////////////////
    
    //MARK:- TabelView Datasource Methods
    
    // cellForRowMethod : associat the cell and input data to the tabel view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemCell", for: indexPath) as! UITableViewCell
        
        cell.textLabel?.text = toDoArray[indexPath.row].title
        
        cell.accessoryType = toDoArray[indexPath.row].done ? .checkmark : .none
        return cell
    }
    
    // numberOfRowsInSection Method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoArray.count
    }

    //MARK:- deleget method to perform when the user press a cell
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(toDoArray[indexPath.row])
        
        //makeing selecting cell and deselcting it in animated (from static gray back to be white)
        tableView.deselectRow(at: indexPath, animated: true)
        
        //method to enabel the checkmark accessory t othe selected cell
        //cellForRow(at: indexPath): to specify which cell by associate it with the indexpath variabel
        //checking to see the state of the accessory type
        toDoArray[indexPath.row].done = !toDoArray[indexPath.row].done
        tableView.reloadData()
    }
    
    //MARK:- navigation bar add Button
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        //declar a local variable to be accesed to all closure
        var textfield = UITextField()
        let alert = UIAlertController(title: "Add a New Item to the list", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
           // the code thet will excuted when the user press the button of action alert
         
            let newitem = Items()
            newitem.title = textfield.text!

            self.toDoArray.append(newitem)
            // saving the values in .plist sothat we can retrive it with the key
            self.defaults.set(self.toDoArray, forKey: "toDoArray")
            self.tableView.reloadData()
        }
        alert.addAction(action)
        alert.addTextField { (addButtonTextfield) in
            textfield = addButtonTextfield
        }
        present(alert, animated: true, completion: nil)
        
    }
}

