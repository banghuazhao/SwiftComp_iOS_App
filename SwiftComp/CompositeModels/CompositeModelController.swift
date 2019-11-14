//
//  LaminateController.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 10/4/17.
//  Copyright © 2017 Banghua Zhao. All rights reserved.
//

import CoreData
import UIKit

class CompositeModelController: UIViewController {
    let sectionHeaderHeight: CGFloat = 36
    let compositeModels = CompoisteModels()

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(CompositeModelCell.self, forCellReuseIdentifier: "cellID")
        tableView.backgroundColor = .greybackgroundColor
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        // clearCoreDataStore()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tabBarController?.title = "Composite Models"
        
        if !isIPhone {
            if let indexPath = tableView.indexPathForSelectedRow, indexPath != IndexPath(row: 0, section: 0) {
                tableView(tableView, didSelectRowAt: indexPath)
            } else {
                tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .middle)
                tableView(tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
            }
        }

        editNavigationBar()
    }

    // MARK: set up navigation bar

    func editNavigationBar() {
        navigationController?.setToolbarHidden(true, animated: false)
    }
}

// MARK: - UITableViewDataSource

extension CompositeModelController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 86
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: .zero)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = CompositeModelHeaderCell()

        switch section {
        case 0:
            cell.label.text = "Using 1D SG"
        case 1:
            cell.label.text = "Using 2D SG"
        case 2:
            cell.label.text = "Using 3D SG"
        default:
            break
        }

        return cell
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as? CompositeModelCell else { return UITableViewCell() }
        var compositeModel: CompositeModel?

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

        return cell
    }
}

// MARK: - UITableViewDelegate

extension CompositeModelController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isIPhone {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                if isIPhone {
                    navigationController?.pushViewController(LaminateController(), animated: true)
                } else { showDetailViewController(SCNavigationController(rootViewController: LaminateController()), sender: self)
                }
            }
        case 1:
            if indexPath.row == 0 {
                if isIPhone {
                    navigationController?.pushViewController(UDFRCController(), animated: true)
                } else {
                    showDetailViewController(SCNavigationController(rootViewController: UDFRCController()), sender: self)
                }
            }
        case 2:
            if indexPath.row == 0 {
                if isIPhone {
                    navigationController?.pushViewController(HoneycombSandwichController(), animated: true)
                } else {
                    showDetailViewController(SCNavigationController(rootViewController: HoneycombSandwichController()), sender: self)
                }
            }
        default:
            return
        }
    }
}
