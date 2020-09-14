//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray = [DataModel]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Iten.plist")
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadsData()
        
    }
    
    
    //MARK: - tableview functions
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
       
        cell.accessoryType = item.status ? .none : .checkmark
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        itemArray[indexPath.row].status = !itemArray[indexPath.row].status
        saveData()
    }
    
    
    //MARK: - Add button activities
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        var item = UITextField()
        let alert = UIAlertController(title: "Add New Todey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let obj = DataModel()
            obj.title = item.text!
            self.itemArray.append(obj)
            self.saveData()
            
        }
        
        alert.addTextField { (uiTextField) in
            uiTextField.placeholder = "create new item"
            item = uiTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - fileDataPath data encoding decoding functions
    
    func saveData() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }catch {
            print(error)
        }
        
        self.tableView.reloadData()
        
    }
    
    func loadsData() {
        let decoder = PropertyListDecoder()
        if let data = try? Data(contentsOf: dataFilePath!) {
            do {
                itemArray = try decoder.decode([DataModel].self, from: data)
            }catch {
                
            }
        }else{
            
        }
        
    }
    
}


