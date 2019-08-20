//
//  UserSavedFiberMaterial.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 11/5/17.
//  Copyright © 2017 Banghua Zhao. All rights reserved.
//

import UIKit
import CoreData

protocol FiberMaterialDataBaseDelegate {
    func userTypeFiberMaterialDataBase(materialName: String)
}

class UDFRCFiberMaterialDataBase: UITableViewController {
    
    let predefinedMaterial: [String] = ["Empty Material", "E-Glass", "S-Glass", "Carbon (IM)", "Carbon (HM)", "Boron", "Kelvar-49"]

    var userSavedMaterial: [UserFiberMaterial] = []
    
    var delegate: FiberMaterialDataBaseDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UserSavedMaterialCell.self, forCellReuseIdentifier: "CellID")
        
        tableView.tableFooterView = UIView()
        
        fetchData()
        
        tableView.reloadData()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Predefined"
        } else {
            return "User Saved (Sweep Left to Delete)"
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return predefinedMaterial.count
        } else {
            return userSavedMaterial.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath) as! UserSavedMaterialCell
        
        if indexPath.section == 0 {
            let name = predefinedMaterial[indexPath.row]
            cell.nameLabel.text = name
        } else {
            let name = userSavedMaterial[indexPath.row].name
            cell.nameLabel.text = name
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if indexPath.section == 0 {
            return UITableViewCell.EditingStyle.none
        } else {
            return UITableViewCell.EditingStyle.delete
        }
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        if editingStyle == .delete {
            
            let material = userSavedMaterial[indexPath.row]
            context.delete(material)
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            do {
                userSavedMaterial = try context.fetch(UserFiberMaterial.fetchRequest())
            }
            catch {
                print(error)
            }
            
        }
        
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var materialName: String
        if indexPath.section == 0 {
            materialName = predefinedMaterial[indexPath.row]
        } else {
            materialName = userSavedMaterial[indexPath.row].name!
        }
        
        delegate?.userTypeFiberMaterialDataBase(materialName: materialName)
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    func fetchData() {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            userSavedMaterial = try context.fetch(UserFiberMaterial.fetchRequest())
        }
        catch {
            print(error)
        }
        
    }

}

