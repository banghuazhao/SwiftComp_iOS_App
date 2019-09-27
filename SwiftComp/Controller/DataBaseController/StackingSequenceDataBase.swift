//
//  UserSavedStackingSequence.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 11/4/17.
//  Copyright © 2017 Banghua Zhao. All rights reserved.
//

import UIKit
import CoreData

protocol LaminateStackingSequenceDataBaseDelegate: AnyObject {
    func userTypeStackingSequenceDataBase(stackingSequence: String)
}

class StackingSequenceDataBase: UITableViewController {

    let predefinedStackingSequence: [String] = ["Empty Stacking Sequence", "[0/90]", "[45/-45]", "[0/30/-30]", "[0/60/-60]s", "[0/90/45/-45]s"]
    
    var userSavedStackingSequence: [UserStackingSequence] = []
    
    weak var delegate: LaminateStackingSequenceDataBaseDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UserSavedStackingSequenceCell.self, forCellReuseIdentifier: "CellID")
        
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
            return predefinedStackingSequence.count
        } else {
            return userSavedStackingSequence.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath) as! UserSavedStackingSequenceCell
        if indexPath.section == 0 {
            let name = predefinedStackingSequence[indexPath.row]
            cell.nameLabel.text = name
        } else {
            let name = userSavedStackingSequence[indexPath.row].name
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
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        if editingStyle == .delete {
            
            let material = userSavedStackingSequence[indexPath.row]
            context.delete(material)
            
            CoreDataManager.shared.saveContext()
            
            do {
                userSavedStackingSequence = try context.fetch(UserStackingSequence.fetchRequest())
            }
            catch {
                print(error)
            }
            
        }
        
        tableView.reloadData()
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var stackingSequence: String
        if indexPath.section == 0 {
            stackingSequence = predefinedStackingSequence[indexPath.row]
        } else {
            stackingSequence = userSavedStackingSequence[indexPath.row].name!
        }
        
        delegate?.userTypeStackingSequenceDataBase(stackingSequence: stackingSequence)
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    func fetchData() {
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        do {
            userSavedStackingSequence = try context.fetch(UserStackingSequence.fetchRequest())
        }
        catch {
            print(error)
        }
        
    }
    
    
    
}
