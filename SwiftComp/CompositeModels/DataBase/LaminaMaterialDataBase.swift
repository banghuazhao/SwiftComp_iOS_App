//
//  UserSavedMaterial.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 11/4/17.
//  Copyright © 2017 Banghua Zhao. All rights reserved.
//

import CoreData
import UIKit

protocol LaminateMaterialDataBaseDelegate: AnyObject {
    func userTypeLaminaMaterialDataBase(materialName: String)
}

class LaminaMaterialDataBase: UITableViewController {
    let predefinedMaterial: [String] = ["Empty Material", "IM7/8552", "T2C190/F155"]

    var userSavedMaterial: [UserLaminaMaterial] = []

    weak var delegate: LaminateMaterialDataBaseDelegate?

    let allMaterials = MaterialBank()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCancelButton()

        tableView.register(UserSavedMaterialCell.self, forCellReuseIdentifier: "CellID")

        tableView.tableFooterView = UIView()

        navigationController?.setToolbarHidden(true, animated: false)

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

            if name != "Empty Material" {
                cell.materialCardImageView.image = UIImage(named: "user_defined_material_card")

                let material = allMaterials.list.first(where: { $0.materialName == name })!

                switch material.materialType {
                case .transverselyIsotropic:
                    cell.materialTypeLabel.text = "Transversely isotropic material"
                    break
                case .orthotropic:
                    cell.materialTypeLabel.text = "Orthotropic material"
                    break
                case .anisotropic:
                    cell.materialTypeLabel.text = "Anisotropic material"
                    break
                default:
                    break
                }
            } else {
                cell.materialCardImageView.image = UIImage(named: "empty_material_card")
                cell.materialTypeLabel.text = "Orthotropic material"
            }

        } else {
            let name = userSavedMaterial[indexPath.row].name
            cell.materialCardImageView.image = UIImage(named: "user_defined_material_card")
            cell.nameLabel.text = name

            let material = userSavedMaterial[indexPath.row]

            switch material.type {
            case "Transversely Isotropic":
                cell.materialTypeLabel.text = "Transversely isotropic material"
                break
            case "transversely isotropic":
                cell.materialTypeLabel.text = "Transversely isotropic material"
                break
            case "Orthotropic":
                cell.materialTypeLabel.text = "Orthotropic material"
                break
            case "orthotropic":
                cell.materialTypeLabel.text = "Orthotropic material"
                break
            case "Anisotropic":
                cell.materialTypeLabel.text = "Anisotropic material"
                break
            case "anisotropic":
                cell.materialTypeLabel.text = "Anisotropic material"
                break
            default:
                break
            }
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
            let material = userSavedMaterial[indexPath.row]
            context.delete(material)

            CoreDataManager.shared.saveContext()

            do {
                userSavedMaterial = try context.fetch(UserLaminaMaterial.fetchRequest())
            } catch {
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

        delegate?.userTypeLaminaMaterialDataBase(materialName: materialName)

        dismiss(animated: true, completion: nil)
    }

    func fetchData() {
        let context = CoreDataManager.shared.persistentContainer.viewContext

        do {
            userSavedMaterial = try context.fetch(UserLaminaMaterial.fetchRequest())
        } catch {
            print(error)
        }
    }
}
