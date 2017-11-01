//
//  Home.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 10/4/17.
//  Copyright © 2017 Banghua Zhao. All rights reserved.
//

import UIKit

class Home: UITableViewController {
    
    var compositeModels: [CompositeModel]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCompositeModels()
        
        editNavigationBar()
        
        tableView.register(CompositeModelCell.self, forCellReuseIdentifier: "cellID")
        
        tableView.tableFooterView = UIView()

    }
    
    
    
    
    // MARK: set up navigation bar
    
    func editNavigationBar() {
        navigationController?.navigationBar.backgroundColor = .black
        
        navigationItem.title = "Home"
        
        let backItem = UIBarButtonItem()
        backItem.title = "Home"
        self.navigationItem.backBarButtonItem = backItem
    }
    
    
    
    // MARK: Set up composite models

    func setupCompositeModels() {
        let compositeModel1 = CompositeModel(name: "Laminate", image: #imageLiteral(resourceName: "laminate"))
        let compositeModel2 = CompositeModel(name: "Unidirectional Fiber Reinforced Composite", image: #imageLiteral(resourceName: "spuarePack"))
        
        self.compositeModels = [compositeModel1, compositeModel2]
    }
    
    
    
    
    

    
    // MARK: - Table view
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 86
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = compositeModels?.count {
            return count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as! CompositeModelCell
        
        let compositeModel = compositeModels?[indexPath.row]
        
        cell.compositeModel = compositeModel
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
        switch indexPath.row {
        case 0:
            let laminateViewController = Laminate()
            self.navigationController?.pushViewController(laminateViewController, animated: true)
        case 1:
            let UDFRCViewController = UDFRC()
            self.navigationController?.pushViewController(UDFRCViewController, animated: true)
        default:
            return
        }
        
    }
    

}
















