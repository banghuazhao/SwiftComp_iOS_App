//
//  UserSavedMaterial.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 11/4/17.
//  Copyright © 2017 Banghua Zhao. All rights reserved.
//

import CoreData
import UIKit

protocol LaminaMaterialDataBaseVCDelegate: AnyObject {
    func didSelectLaminaMaterial(material: Material)
}

class LaminaMaterialDataBaseVC: UITableViewController {
    let predefinedMaterials: [Material] = [
        Material(name: "Empty Transversely Isotropic Material", materialType: .transverselyIsotropic(.thermoElastic)),
        Material(name: "Empty Orthotropic Material", materialType: .orthotropic(.thermoElastic)),
        Material(name: "Empty Anisotropic Material", materialType: .anisotropic(.thermoElastic)),
        Material(name: "IM7/8552",
                 materialType: .orthotropic(.thermoElastic),
                 materialProperties: [
                     MaterialProperty(name: .E1, value: 161.0),
                     MaterialProperty(name: .E2, value: 11.38),
                     MaterialProperty(name: .E3, value: 11.38),
                     MaterialProperty(name: .G12, value: 5.17),
                     MaterialProperty(name: .G13, value: 5.17),
                     MaterialProperty(name: .G23, value: 3.98),
                     MaterialProperty(name: .nu12, value: 0.32),
                     MaterialProperty(name: .nu13, value: 0.32),
                     MaterialProperty(name: .nu23, value: 0.44),
                     MaterialProperty(name: .alpha11, value: 10),
                     MaterialProperty(name: .alpha22, value: 20),
                     MaterialProperty(name: .alpha33, value: 20),

        ]),
        Material(name: "T2C190/F155",
                 materialType: .orthotropic(.thermoElastic),
                 materialProperties: [
                     MaterialProperty(name: .E1, value: 122.7),
                     MaterialProperty(name: .E2, value: 8.69),
                     MaterialProperty(name: .E3, value: 8.69),
                     MaterialProperty(name: .G12, value: 5.9),
                     MaterialProperty(name: .G13, value: 5.9),
                     MaterialProperty(name: .G23, value: 3.3),
                     MaterialProperty(name: .nu12, value: 0.340),
                     MaterialProperty(name: .nu13, value: 0.340),
                     MaterialProperty(name: .nu23, value: 0.400),
                     MaterialProperty(name: .alpha11, value: 10),
                     MaterialProperty(name: .alpha22, value: 20),
                     MaterialProperty(name: .alpha33, value: 20),

        ]),
    ]

    private lazy var userSavedMaterials: [UserLaminaMaterial] = []

    weak var delegate: LaminaMaterialDataBaseVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCancelButton()

        tableView.register(MaterialDataBaseCell.self, forCellReuseIdentifier: "MaterialDataBaseCell")

        tableView.tableFooterView = UIView()

        navigationItem.title = "Lamina Material DB"

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
            let material = Material(userLaminaMaterial: userMaterial)
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
                userSavedMaterials = try context.fetch(UserLaminaMaterial.fetchRequest())
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
            material = Material(userLaminaMaterial: userMaterial)
        }

        dismiss(animated: true, completion: {
            self.delegate?.didSelectLaminaMaterial(material: material)
        })
    }

    func fetchData() {
        let context = CoreDataManager.shared.persistentContainer.viewContext

        do {
            userSavedMaterials = try context.fetch(UserLaminaMaterial.fetchRequest())
        } catch {
            print(error)
        }
    }
}
