//
//  UserSavedMatrixMaterial.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 11/5/17.
//  Copyright © 2017 Banghua Zhao. All rights reserved.
//

import UIKit
import CoreData

class UserSavedMatrixMaterial: UITableViewController {

    var userSavedMaterial: [UserMatrixMaterial] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UserSavedMaterialCell.self, forCellReuseIdentifier: "CellID")
        
        tableView.tableFooterView = UIView()
        
        fetchData()
        
        tableView.reloadData()
        
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "User Saved Matrix Material"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return userSavedMaterial.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath) as! UserSavedMaterialCell
        let name = userSavedMaterial[indexPath.row].name
        cell.nameLabel.text = name
        
        return cell
        
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        if editingStyle == .delete {
            
            let material = userSavedMaterial[indexPath.row]
            context.delete(material)
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            do {
                userSavedMaterial = try context.fetch(UserMatrixMaterial.fetchRequest())
            }
            catch {
                print(error)
            }
            
        }
        
        tableView.reloadData()
    }
    
    func fetchData() {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            userSavedMaterial = try context.fetch(UserMatrixMaterial.fetchRequest())
        }
        catch {
            print(error)
        }
        
    }

}
