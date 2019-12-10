//
//  MatrixMaterialDataBaseVC.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 11/5/17.
//  Copyright © 2017 Banghua Zhao. All rights reserved.
//

import CoreData
import UIKit

protocol MatrixMaterialDataBaseVCDelegate: AnyObject {
    func didSelectMatrixMaterial(material: Material)
}

class MatrixMaterialDataBaseVC: UITableViewController {
    let predefinedMaterials: [Material] = [
        Material(name: "Empty Isotropic Material", materialType: .isotropic(.thermoElastic)),
        Material(name: "Empty Transversely Isotropic Material", materialType: .transverselyIsotropic(.thermoElastic)),
        Material(name: "Empty Orthotropic Material", materialType: .orthotropic(.thermoElastic)),
        Material(name: "Epoxy",
                 materialType: .isotropic(.thermoElastic),
                 materialProperties: [
                     MaterialProperty(name: .E, value: 4.6),
                     MaterialProperty(name: .nu, value: 0.36),
                     MaterialProperty(name: .alpha, value: 63),
        ]),
        Material(name: "Polyester",
                 materialType: .isotropic(.thermoElastic),
                 materialProperties: [
                     MaterialProperty(name: .E, value: 2.8),
                     MaterialProperty(name: .nu, value: 0.30),
                     MaterialProperty(name: .alpha, value: 130),
        ]),
        Material(name: "Polyimide",
                 materialType: .isotropic(.thermoElastic),
                 materialProperties: [
                     MaterialProperty(name: .E, value: 3.5),
                     MaterialProperty(name: .nu, value: 0.35),
                     MaterialProperty(name: .alpha, value: 36),
        ]),
        Material(name: "PEEK",
                 materialType: .isotropic(.thermoElastic),
                 materialProperties: [
                     MaterialProperty(name: .E, value: 400),
                     MaterialProperty(name: .nu, value: 0.25),
                     MaterialProperty(name: .alpha, value: 78),
        ]),
        Material(name: "Copper",
                 materialType: .isotropic(.thermoElastic),
                 materialProperties: [
                     MaterialProperty(name: .E, value: 117),
                     MaterialProperty(name: .nu, value: 0.33),
                     MaterialProperty(name: .alpha, value: 17),
        ]),
        Material(name: "Silicon Carbide",
                 materialType: .isotropic(.thermoElastic),
                 materialProperties: [
                     MaterialProperty(name: .E, value: 400),
                     MaterialProperty(name: .nu, value: 0.25),
                     MaterialProperty(name: .alpha, value: 4.8),
        ]),
    ]

    private lazy var userSavedMaterials: [UserMatrixMaterial] = []

    weak var delegate: MatrixMaterialDataBaseVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCancelButton()

        tableView.register(MaterialDataBaseCell.self, forCellReuseIdentifier: "MaterialDataBaseCell")

        tableView.tableFooterView = UIView()

        navigationItem.title = "Matrix Material DB"

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
            let material = Material(userMatrixMaterial: userMaterial)
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
                userSavedMaterials = try context.fetch(UserMatrixMaterial.fetchRequest())
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
            material = Material(userMatrixMaterial: userMaterial)
        }

        dismiss(animated: true, completion: {
            self.delegate?.didSelectMatrixMaterial(material: material)
        })
    }

    func fetchData() {
        let context = CoreDataManager.shared.persistentContainer.viewContext

        do {
            userSavedMaterials = try context.fetch(UserMatrixMaterial.fetchRequest())
        } catch {
            print(error)
        }
    }
}
