//
//  CatageryViewController.swift
//  Todoey
//
//  Created by ahmad$$ on 4/20/19.
//  Copyright © 2019 ahmad. All rights reserved.
//

import UIKit
import RealmSwift

class CatageryViewController: UITableViewController {
    
    // initializing Rrealm ,, !: mean that i know what i am doing
    let realm = try! Realm()
    // ? to be optional instead of force unraping it
    var catageryArray : Results<Catageries>?
    //Results<Catageries>?
    
    //let context = (UIApplication.shared.delegate as! AppDelegate ).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        loadData()

    }
   
    
    //MARK:- tableview dataSource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "catageryCell", for: indexPath) as! UITableViewCell
        
        // adding ? to say if it is't nil then do that ,, and ?? if it is nil do that
        cell.textLabel?.text = catageryArray?[indexPath.row].name ?? "there is no catageries yet "
        //cell.textLabel?.text = catageryArray![indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catageryArray?.count ?? 1
    }
    
    
    //MARK:- TabelView delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        if  let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCatagery = catageryArray?[indexPath.row]
        }
    }
    
    
    //MARK:- AddButtonPressed Method
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Categery", message: nil, preferredStyle: .alert  )
       
        let action = UIAlertAction(title: "Add Catagery", style: .default) { (action) in
            let newCatagery = Catageries()
            newCatagery.name = textField.text!
            // no need more for apending ,cause the RESULT is self updating container
        // self.catageryArray.append(newCatagery)
            self.saveData(categery: newCatagery)
            
        }
        
        alert.addAction(action)
        alert.addTextField { (addbuttontextfield) in
            textField = addbuttontextfield
            textField.placeholder = "add a new categordy "
        }
        present(alert, animated: true, completion: nil)
    }
  
    
    //MARK:- Manipulating data methods
    
    func saveData(categery : Catageries){
        do{
            try realm.write {
                realm.add(categery)
            }
        }catch{
            print("error saving data in Catageries \(error)")
        }
        self.tableView.reloadData()
        
    }
    func loadData(){

        catageryArray = realm.objects(Catageries.self)

        self.tableView.reloadData()
    }


    }
    

