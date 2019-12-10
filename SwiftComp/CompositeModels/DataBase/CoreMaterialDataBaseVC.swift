//
//  CoreMaterialDataBaseVC.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 11/5/17.
//  Copyright © 2017 Banghua Zhao. All rights reserved.
//

import CoreData
import UIKit

protocol CoreMaterialDataBaseVCDelegate: AnyObject {
    func didSelectCoreMaterial(material: Material)
}

class CoreMaterialDataBaseVC: UITableViewController {
    let predefinedMaterials: [Material] = [
        Material(name: "Empty Isotropic Material", materialType: .isotropic(.thermoElastic)),
        Material(name: "Empty Transversely Isotropic Material", materialType: .transverselyIsotropic(.thermoElastic)),
        Material(name: "Empty Orthotropic Material", materialType: .orthotropic(.thermoElastic)),
        Material(name: "Nomex",
                 materialType: .isotropic(.thermoElastic),
                 materialProperties: [
                     MaterialProperty(name: .E, value: 3.0),
                     MaterialProperty(name: .nu, value: 0.3),
                     MaterialProperty(name: .alpha, value: 20),
        ]),
        Material(name: "Aluminum",
                 materialType: .isotropic(.thermoElastic),
                 materialProperties: [
                     MaterialProperty(name: .E, value: 68.0),
                     MaterialProperty(name: .nu, value: 0.36),
                     MaterialProperty(name: .alpha, value: 8.1),
        ]),
        Material(name: "Steel",
                 materialType: .isotropic(.thermoElastic),
                 materialProperties: [
                     MaterialProperty(name: .E, value: 200.0),
                     MaterialProperty(name: .nu, value: 0.25),
                     MaterialProperty(name: .alpha, value: 11.5),
        ]),
    ]

    private lazy var userSavedMaterials: [UserCoreMaterial] = []

    weak var delegate: CoreMaterialDataBaseVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCancelButton()

        tableView.register(MaterialDataBaseCell.self, forCellReuseIdentifier: "MaterialDataBaseCell")

        tableView.tableFooterView = UIView()

        navigationItem.title = "Core Material DB"

        fetchData()

        tableView.reloadData()
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
            return predefinedMaterials.count
        } else {
            return userSavedMaterials.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MaterialDataBaseCell", for: indexPath) as! MaterialDataBaseCell
        if indexPath.section == 0 {
            cell.material = predefinedMaterials[indexPath.row]

        } else {
            let userMaterial = userSavedMaterials[indexPath.row]
            let material = Material(userCoreMaterial: userMaterial)
            cell.material = material
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
            let material = userSavedMaterials[indexPath.row]
            context.delete(material)

            CoreDataManager.shared.saveContext()

            do {
                userSavedMaterials = try context.fetch(UserCoreMaterial.fetchRequest())
            } catch {
                print(error)
            }
        }

        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var material: Material = predefinedMaterials[0]

        if indexPath.section == 0 {
            material = predefinedMaterials[indexPath.row]
        } else {
            let userMaterial = userSavedMaterials[indexPath.row]
            material = Material(userCoreMaterial: userMaterial)
        }

        dismiss(animated: true, completion: {
            self.delegate?.didSelectCoreMaterial(material: material)
        })
    }

    func fetchData() {
        let context = CoreDataManager.shared.persistentContainer.viewContext

        do {
            userSavedMaterials = try context.fetch(UserCoreMaterial.fetchRequest())
        } catch {
            print(error)
        }
    }
}
