//
//  Home.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 10/4/17.
//  Copyright © 2017 Banghua Zhao. All rights reserved.
//

import UIKit
import CoreData

class CompositeModelsViewController: UITableViewController {
    
    let sectionHeaderHeight : CGFloat = 30
    
    let compositeModels = CompoisteModels()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(CompositeModelCell.self, forCellReuseIdentifier: "cellID")
        tableView.tableFooterView = UIView()
        
        self.view.backgroundColor = .greybackgroundColor

        // clearCoreDataStore()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        
        self.tabBarController?.title = "Composite Models"
        
        editNavigationBar()
        
    }
    
    
    // MARK: set up navigation bar
    
    func editNavigationBar() {
   
        self.navigationController?.setToolbarHidden(true, animated: false)

    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return sectionHeaderHeight + 20
        }
        
        return sectionHeaderHeight
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: sectionHeaderHeight))
        view.backgroundColor = .greybackgroundColor
        
        let label = UILabel()
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8).isActive = true
        label.textColor = .greyFont2Color
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        switch section {
        case 0:
            label.text = "Using 1D SG"
        case 1:
            label.text = "Using 2D SG"
        case 2:
            label.text = "Using 3D SG"
        default:
            break
        }
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 86
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return compositeModels.SG1D.count
        case 1:
            return compositeModels.SG2D.count
        case 2:
            return compositeModels.SG3D.count
        default:
            break
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as? CompositeModelCell {
            
            var compositeModel : CompositeModel?
            
            switch indexPath.section {
                case 0:
                    compositeModel = compositeModels.SG1D[indexPath.row]
                case 1:
                    compositeModel = compositeModels.SG2D[indexPath.row]
                case 2:
                    compositeModel = compositeModels.SG3D[indexPath.row]
                default:
                    break
            }
            
            cell.compositeModel = compositeModel
            
            cell.accessoryType = .disclosureIndicator
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                self.navigationController?.pushViewController(Laminate(), animated: true)
            }
        case 1:
            if indexPath.row == 0 {
                self.navigationController?.pushViewController(UDFRC(), animated: true)
            }
        case 2:
            if indexPath.row == 0 {
                self.navigationController?.pushViewController(HoneycombSandwich(), animated: true)
            }
        default:
            return
        }
        
    }
    
    
}














