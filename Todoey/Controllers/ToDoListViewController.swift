//
//  ViewController.swift
//  Todoey
//
//  Created by ahmad$$ on 4/11/19.
//  Copyright © 2019 ahmad. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    // declare instant variabel
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var toDoArray = [Items]()
    var selectedCatagery :Catageries? {
        didSet{
            loadData()
        }
    }
    
   // let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")
    
//    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let newItem = Items()
//        newItem.title = "get milk"
//        toDoArray.append(newItem)
//
//        let newItem1 = Items()
//        newItem1.title = "play football "
//        toDoArray.append(newItem1)
        
       // print ( FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
       
        
         //retrive the data from the user default , doing the binary check
       //loadData()
//        if let itemsArrayRetrived = defaults.array(forKey: "toDoArray") as? [Items]  {
//            toDoArray = itemsArrayRetrived
//        }

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
        
        //deleting item from Core data
//        context.delete(toDoArray[indexPath.row])
//        toDoArray.remove(at: indexPath.row)
        
        //method to enabel the checkmark accessory t othe selected cell
        //cellForRow(at: indexPath): to specify which cell by associate it with the indexpath variabel
        //checking to see the state of the accessory type
        toDoArray[indexPath.row].done = !toDoArray[indexPath.row].done
        tableView.reloadData()
        self.saveItems()
    }
    
    //MARK:- navigation bar add Button
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        //declar a local variable to be accesed to all closure
        var textfield = UITextField()
        let alert = UIAlertController(title: "Add a New Item to the list", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
           // the code thet will excuted when the user press the button of action alert
         
            let newitem = Items(context: self.context)
            newitem.title = textfield.text!
            newitem.done = false
            newitem.parrentCategry = self.selectedCatagery

            self.toDoArray.append(newitem)
            // saving the values in .plist sothat we can retrive it with the key
            self.saveItems()
            //self.defaults.set(self.toDoArray, forKey: "toDoArray")
           
        }
        alert.addAction(action)
        alert.addTextField { (addButtonTextfield) in
            textfield = addButtonTextfield
        }
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveItems(){
        do{
        try context.save()
        }catch{
            print("error saving context \(error)")
        }
         self.tableView.reloadData()
    }
    
    //with = external prams , request = internal prams , siting an default value to the input if we did'nt give one
    func loadData(with request : NSFetchRequest<Items> = Items.fetchRequest() , predicat : NSPredicate? = nil){
     //   let request : NSFetchRequest<Items> = Items.fetchRequest()
        let catageryPredicate = NSPredicate(format: "parrentCategry.name MATCHES %@", selectedCatagery!.name!)
        
        if let SearchPredicat = predicat {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [catageryPredicate,SearchPredicat])
        }else{
            request.predicate = catageryPredicate
        }
        do{
            toDoArray = try context.fetch(request)
        } catch{
              print("error fetching data \(error)")
            }

      tableView.reloadData()
    }
    
}

extension ToDoListViewController : UISearchBarDelegate {
    // searching bar delegate methode thet deals with searching process
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Items> = Items.fetchRequest()
        //adding the predicate to the request thet will search for the title that contains the text in the searchbar
        let predicate =  NSPredicate(format: "title CONTAINS[CD] %@", searchBar.text!)
        //adding the sortdescriptors thet will sort the title alphapitacally by  (ascending: true)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadData(with: request , predicat: predicate)
        
    }
    // searching bar delegate methode thet deals withdismis the keyboard and return to the firest case
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadData()
            // need to be reviewed
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }

    
    
}

