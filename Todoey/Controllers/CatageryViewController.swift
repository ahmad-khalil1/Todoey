//
//  CatageryViewController.swift
//  Todoey
//
//  Created by ahmad$$ on 4/20/19.
//  Copyright © 2019 ahmad. All rights reserved.
//

import UIKit
import CoreData

class CatageryViewController: UITableViewController {
    
    var catageryArray = [Catageries]()
    let context = (UIApplication.shared.delegate as! AppDelegate ).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        loadData()

    }
   
    
    //MARK :- tableview dataSource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "catageryCell", for: indexPath) as! UITableViewCell
        cell.textLabel?.text = catageryArray[indexPath.row].name
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catageryArray.count
    }
    
    
    //MARK :- AddButtonPressed Method
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Categery", message: nil, preferredStyle: .alert  )
        let action = UIAlertAction(title: "Add Catagery", style: .default) { (action) in
            let newCatagery = Catageries(context: self.context)
            newCatagery.name = textField.text!
            self.catageryArray.append(newCatagery)
            self.saveData()
        }
        alert.addAction(action)
        alert.addTextField { (addbuttontextfield) in
            textField = addbuttontextfield
        }
        present(alert, animated: true, completion: nil)
    }
    //MARK :- TabelView delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        if  let indexPath = tableView.indexPathForSelectedRow{
         destinationVC.selectedCatagery = catageryArray[indexPath.row]
        }
    }
    
    //MARK :- Manipulating data methods
    
    func saveData(){
        do{
            try context.save()
        }catch{
            print("error saving data in Catageries \(error)")
        }
        self.tableView.reloadData()
    }
    func loadData(with request : NSFetchRequest<Catageries > = Catageries.fetchRequest() ){
        do{
            catageryArray = try context.fetch(request)
        }catch {
            print ("error fetching data from Catageries \(error)")
        }
        self.tableView.reloadData()
    }
    
    
}
