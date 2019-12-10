//
//  FiberMaterialDataBaseVC.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 11/5/17.
//  Copyright © 2017 Banghua Zhao. All rights reserved.
//

import CoreData
import UIKit

protocol FiberMaterialDataBaseVCDelegate: AnyObject {
    func didSelectFiberMaterial(material: Material)
}

class FiberMaterialDataBaseVC: UITableViewController {
    let predefinedMaterials: [Material] = [
        Material(name: "Empty Isotropic Material", materialType: .isotropic(.thermoElastic)),
        Material(name: "Empty Transversely Isotropic Material", materialType: .transverselyIsotropic(.thermoElastic)),
        Material(name: "Empty Orthotropic Material", materialType: .orthotropic(.thermoElastic)),
        Material(name: "E-Glass",
                 materialType: .isotropic(.thermoElastic),
                 materialProperties: [
                     MaterialProperty(name: .E, value: 77.0),
                     MaterialProperty(name: .nu, value: 0.22),
                     MaterialProperty(name: .alpha, value: 5.4),
        ]),
        Material(name: "S-Glass",
                 materialType: .isotropic(.thermoElastic),
                 materialProperties: [
                     MaterialProperty(name: .E, value: 85.0),
                     MaterialProperty(name: .nu, value: 0.23),
                     MaterialProperty(name: .alpha, value: 1.6),
        ]),
        Material(name: "Carbon (IM)",
                 materialType: .isotropic(.thermoElastic),
                 materialProperties: [
                     MaterialProperty(name: .E, value: 230.0),
                     MaterialProperty(name: .nu, value: 0.20),
                     MaterialProperty(name: .alpha, value: -0.3),
        ]),
        Material(name: "Carbon (HM)",
                 materialType: .isotropic(.thermoElastic),
                 materialProperties: [
                     MaterialProperty(name: .E, value: 350.0),
                     MaterialProperty(name: .nu, value: 0.20),
                     MaterialProperty(name: .alpha, value: -0.8),
        ]),
        Material(name: "Boron",
                 materialType: .isotropic(.thermoElastic),
                 materialProperties: [
                     MaterialProperty(name: .E, value: 385.0),
                     MaterialProperty(name: .nu, value: 0.22),
                     MaterialProperty(name: .alpha, value: 5.4),
        ]),
        Material(name: "Kelvar-49",
                 materialType: .isotropic(.thermoElastic),
                 materialProperties: [
                     MaterialProperty(name: .E, value: 130.0),
                     MaterialProperty(name: .nu, value: 0.34),
                     MaterialProperty(name: .alpha, value: -2.0),
        ]),
    ]

    private lazy var userSavedMaterials: [UserFiberMaterial] = []

    weak var delegate: FiberMaterialDataBaseVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCancelButton()

        tableView.register(MaterialDataBaseCell.self, forCellReuseIdentifier: "MaterialDataBaseCell")

        tableView.tableFooterView = UIView()

        navigationItem.title = "Fiber Material DB"

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
            let material = Material(userFiberMaterial: userMaterial)
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
                userSavedMaterials = try context.fetch(UserFiberMaterial.fetchRequest())
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
            material = Material(userFiberMaterial: userMaterial)
        }

        dismiss(animated: true, completion: {
            self.delegate?.didSelectFiberMaterial(material: material)
        })
    }

    func fetchData() {
        let context = CoreDataManager.shared.persistentContainer.viewContext

        do {
            userSavedMaterials = try context.fetch(UserFiberMaterial.fetchRequest())
        } catch {
            print(error)
        }
    }
}
