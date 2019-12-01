//
//  HomogenizationController.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 11/17/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import JGProgressHUD
import Moya
import SwiftyJSON
import UIKit

class HomogenizationController: UIViewController {
    lazy private var method: Method = .swiftComp
    lazy private var structuralModel = StructuralModel(model: .plate(.kirchhoffLove))
    lazy private var typeOfAnalysis: TypeOfAnalysis = .elastic

    lazy private var faceSheetGeometry = StackingSequence(sectionTitle: "Facesheet", stackingSequenceText: "[45/-45]", layerThickness: 0.1)
    lazy private var honeycombCore = HoneycombCore(coreLength: 3.6, coreThickness: 0.1, coreHeight: 10)

    private var coreMaterials: Materials = Materials(
        sectionTitle: "Core Material",
        materials: [
            Material(name: "Nomex",
                     materialType: .isotropic(.elastic),
                     materialProperties: [
                         MaterialProperty(name: .E, value: 3),
                         MaterialProperty(name: .nu, value: 0.3),
            ]),
            Material(name: "New Transversely Material", materialType: .transverselyIsotropic(.elastic)),
            Material(name: "New Orthotropic Material", materialType: .orthotropic(.elastic)),
        ],
        selectedIndex: 0)

    private var facesheetMaterials: Materials = Materials(
        sectionTitle: "Facesheet Material",
        materials: [
            Material(name: "New Transversely Material", materialType: .transverselyIsotropic(.elastic)),
            Material(name: "IM7/8552",
                     materialType: .orthotropic(.elastic),
                     materialProperties: [
                         MaterialProperty(name: .E1, value: 161),
                         MaterialProperty(name: .E2, value: 11.38),
                         MaterialProperty(name: .E3, value: 11.38),
                         MaterialProperty(name: .G12, value: 5.17),
                         MaterialProperty(name: .G13, value: 5.17),
                         MaterialProperty(name: .G23, value: 3.98),
                         MaterialProperty(name: .nu12, value: 0.32),
                         MaterialProperty(name: .nu13, value: 0.32),
                         MaterialProperty(name: .nu23, value: 0.44),

            ]),
            Material(name: "New Anisotropic Material", materialType: .anisotropic(.elastic)),
        ],
        selectedIndex: 1)

    lazy private var progressHUD = JGProgressHUD(style: .dark)
    lazy private var provider = MoyaProvider<HoneycombAPI>()
    
    lazy private var calculationButton = SCCalculateButton()
    lazy private var cancelCloudCalculation: Bool = false

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .greybackgroundColor
        tableView.register(MethodCell.self, forCellReuseIdentifier: "MethodCell")
        tableView.register(StructuralModelCell.self, forCellReuseIdentifier: "StructuralModelCell")
        tableView.register(TypeOfAnalysisCell.self, forCellReuseIdentifier: "TypeOfAnalysisCell")
        tableView.register(StackingSequenceCell.self, forCellReuseIdentifier: "StackingSequenceCell")
        tableView.register(HoneycombCoreCell.self, forCellReuseIdentifier: "HoneycombCoreCell")
        tableView.register(MaterialsCell.self, forCellReuseIdentifier: "MaterialsCell")
        return tableView
    }()

    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupReachabilityListener()
        hideKeyboardWhenTappedAround()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        editToolBar()
    }
}

// MARK: - private functions

extension HomogenizationController {
    private func setupView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func editToolBar() {
        if NetworkManager.sharedInstance.reachability.connection != .none {
            calculationButton.changeStyle(style: .cloud)
            calculationButton.addTarget(self, action: #selector(swiftCompCalculate), for: .touchUpInside)
        } else {
            calculationButton.changeStyle(style: .noInternet)
            calculationButton.addTarget(self, action: #selector(swiftCompCalculateOffline), for: .touchUpInside)
        }

        let item = UIBarButtonItem(customView: calculationButton)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        navigationController?.setToolbarHidden(false, animated: false)
        toolbarItems = [flexibleSpace, item, flexibleSpace]
    }

    private func setupReachabilityListener() {
        NetworkManager.isReachable { [weak self] _ in
            guard let self = self else { return }
            if self.method == .swiftComp {
                DispatchQueue.main.async {
                    self.calculationButton.changeStyle(style: .cloud)
                    self.calculationButton.addTarget(self, action: #selector(self.swiftCompCalculate(_:)), for: .touchUpInside)
                }
            }
        }

        NetworkManager.isUnreachable { [weak self] _ in
            guard let self = self else { return }
            if self.method == .swiftComp {
                DispatchQueue.main.async {
                    self.calculationButton.changeStyle(style: .noInternet)
                    self.calculationButton.addTarget(self, action: #selector(self.swiftCompCalculateOffline), for: .touchUpInside)
                }
            }
        }

        NetworkManager.sharedInstance.reachability.whenReachable = { [weak self] _ in
            guard let self = self else { return }
            if self.method == .swiftComp {
                DispatchQueue.main.async {
                    self.calculationButton.changeStyle(style: .cloud)
                    self.calculationButton.addTarget(self, action: #selector(self.swiftCompCalculate(_:)), for: .touchUpInside)
                }
            }
        }

        NetworkManager.sharedInstance.reachability.whenUnreachable = { [weak self] _ in
            guard let self = self else { return }
            if self.method == .swiftComp {
                DispatchQueue.main.async {
                    self.calculationButton.changeStyle(style: .noInternet)
                    self.calculationButton.addTarget(self, action: #selector(self.swiftCompCalculateOffline), for: .touchUpInside)
                }
            }
        }
    }

    private func calculateResultBySwiftComp() {
    }
}

// MARK: - actions

extension HomogenizationController {
    // MARK: - SwiftComp calculate

    @objc private func swiftCompCalculate(_ sender: UIButton) {
        sender.isEnabled = false
        navigationController?.navigationBar.isUserInteractionEnabled = false

        progressHUD = JGProgressHUD(style: .dark)
        progressHUD.textLabel.text = "Calculating"
        progressHUD.detailTextLabel.text = "Tap to cancel"
        cancelCloudCalculation = false
        progressHUD.tapOnHUDViewBlock = { _ in
            sender.isEnabled = true
            self.navigationController?.navigationBar.isUserInteractionEnabled = true
            self.cancelCloudCalculation = true
            self.progressHUD.dismiss(afterDelay: 0)
            return
        }
        progressHUD.show(in: view, animated: true)
        progressHUD.backgroundColor = .init(displayP3Red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)

        provider.request(.Homogenization(structuralModel: structuralModel, typeOfAnalysis: typeOfAnalysis, honeycombCore: honeycombCore, stackingSequence: faceSheetGeometry, coreMaterial: coreMaterials.selectedMaterial, facesheetMaterial: facesheetMaterials.selectedMaterial)) { result in
            sender.isEnabled = true
            self.navigationController?.navigationBar.isUserInteractionEnabled = true

            if self.cancelCloudCalculation { return }

            switch result {
            case let .success(moyaResponse):

                do {
                    _ = try moyaResponse.filterSuccessfulStatusCodes()
                    let dataJSON = try JSON(data: moyaResponse.data)
                    print(dataJSON)
                    let homBeamResult = HomBeamResult(typeOfAnalysis: self.typeOfAnalysis, structuralModel: self.structuralModel, dataJSON: dataJSON)
                    let homPlateResult = HomPlateResult(typeOfAnalysis: self.typeOfAnalysis, dataJSON: dataJSON)
                    let homSolidResult = HomSolidResult(typeOfAnalysis: self.typeOfAnalysis, dataJSON: dataJSON)
                    let homMeshImage = HomMeshImage(imageData: Data())
                    let homInformation = HomInformation(route: "honeycombSandwich", dataJSON: dataJSON)

                    UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                        self.progressHUD.detailTextLabel.text = ""
                        self.progressHUD.textLabel.text = "Finished"
                        self.progressHUD.indicatorView = JGProgressHUDSuccessIndicatorView()
                    }) { _ in
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            self.progressHUD.dismiss()
                            let homResultController = HomResultController()
                            switch self.structuralModel.model {
                            case .beam:
                                homResultController.homBeamResult = homBeamResult
                            case .plate:
                                homResultController.homPlateResult = homPlateResult
                            case .solid:
                                homResultController.homSolidResult = homSolidResult
                            }
                            homResultController.homMeshImage = homMeshImage
                            homResultController.homInformation = homInformation
                            self.navigationController?.pushViewController(homResultController, animated: true)
                        }
                    }
                } catch let error {
                    print(error)
                    self.progressHUD.dismiss()
                    let ac = UIAlertController(title: "Input Error", message: "Please double check the input", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(ac, animated: true, completion: nil)
                }
            case let .failure(error):
                print(error)
                self.progressHUD.dismiss()
                let ac = UIAlertController(title: "Network Error", message: "Please double check the network", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(ac, animated: true, completion: nil)
            }
        }
    }

    // MARK: - SwiftComp calculate offline

    @objc private func swiftCompCalculateOffline() {
        let ac = UIAlertController(title: "No Network Connection", message: "To run SwiftComp, please connect to internet", preferredStyle: UIAlertController.Style.alert)
        ac.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

        present(ac, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension HomogenizationController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 2 {
            return 60
        }
        return .leastNonzeroMagnitude
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var title = ""
        switch section {
        case 0:
            title = "Analysis Setting"
        case 1:
            title = "Geometry Setting"
        case 2:
            title = "Material Setting"
        default:
            title = ""
        }

        return HomogenizationHeaderView(title: title)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return 2
        case 2:
            return 2
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "MethodCell") as? MethodCell else { return UITableViewCell() }
                cell.method = method
                cell.delegate = self
                return cell
            } else if indexPath.row == 1 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "StructuralModelCell") as? StructuralModelCell else { return UITableViewCell() }
                cell.structuralModel = structuralModel
                cell.delegate = self
                return cell
            } else if indexPath.row == 2 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "TypeOfAnalysisCell") as? TypeOfAnalysisCell else { return UITableViewCell() }
                cell.typeOfAnalysis = typeOfAnalysis
                cell.delegate = self
                return cell
            }
        case 1:
            if indexPath.row == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "HoneycombCoreCell") as? HoneycombCoreCell else { return UITableViewCell() }
                cell.honeycombCore = honeycombCore
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "StackingSequenceCell") as? StackingSequenceCell else { return UITableViewCell() }
                cell.stackingSequence = faceSheetGeometry
                return cell
            }

        case 2:
            if indexPath.row == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "MaterialsCell") as? MaterialsCell else { return UITableViewCell() }
                cell.materials = coreMaterials
                cell.delegate = self
                return cell
            } else if indexPath.row == 1 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "MaterialsCell") as? MaterialsCell else { return UITableViewCell() }
                cell.materials = facesheetMaterials
                cell.delegate = self
                return cell
            }
        default:
            break
        }
        return UITableViewCell()
    }
}

// MARK: - MethodCellDelegate

extension HomogenizationController: MethodCellDelegate {
    func changeMethod(button: SCAnalysisButton) {
        let actionSheet = UIAlertController(title: "Change Method", message: nil, preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: Constant.MethodName.swiftComp, style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            guard self.method != .swiftComp else { return }
            self.method = .swiftComp
            self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(action1)
        actionSheet.addAction(cancel)
        actionSheet.popoverPresentationController?.sourceView = button
        actionSheet.popoverPresentationController?.sourceRect = button.bounds
        present(actionSheet, animated: true, completion: nil)
    }
}

// MARK: - StructuralModelCellDelegate

extension HomogenizationController: StructuralModelCellDelegate {
    func changeStructuralModel(button: SCAnalysisButton) {
        let actionSheet = UIAlertController(title: "Change Structural Model", message: nil, preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: Constant.ModelName.beam, style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            guard self.structuralModel.model != .beam(.eulerBernoulli) && self.structuralModel.model != .beam(.timoshenko) else { return }
            self.structuralModel.model = .beam(.eulerBernoulli)
            self.tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
        })
        let action2 = UIAlertAction(title: Constant.ModelName.plate, style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            guard self.structuralModel.model != .plate(.kirchhoffLove) && self.structuralModel.model != .plate(.reissnerMindlin) else { return }
            self.structuralModel.model = .plate(.kirchhoffLove)
            self.tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
        })
        let action3 = UIAlertAction(title: Constant.ModelName.solid, style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            guard self.structuralModel.model != .solid(.cauchyContinuum) else { return }
            self.structuralModel.model = .solid(.cauchyContinuum)
            self.tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(action1)
        actionSheet.addAction(action2)
        actionSheet.addAction(action3)
        actionSheet.addAction(cancel)
        actionSheet.popoverPresentationController?.sourceView = button
        actionSheet.popoverPresentationController?.sourceRect = button.bounds
        present(actionSheet, animated: true, completion: nil)
    }

    func changeBeamStructuralSubmodel(button: SCAnalysisButton) {
        let actionSheet = UIAlertController(title: "Change Beam Submodel", message: nil, preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: Constant.SubmodelName.Beam.eulerBernoulli, style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            guard self.structuralModel.model != .beam(.eulerBernoulli) else { return }
            self.structuralModel.model = .beam(.eulerBernoulli)
            self.tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
        })
        let action2 = UIAlertAction(title: Constant.SubmodelName.Beam.timoshenko, style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            guard self.structuralModel.model != .beam(.timoshenko) else { return }
            self.structuralModel.model = .beam(.timoshenko)
            self.tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(action1)
        actionSheet.addAction(action2)
        actionSheet.addAction(cancel)
        actionSheet.popoverPresentationController?.sourceView = button
        actionSheet.popoverPresentationController?.sourceRect = button.bounds
        present(actionSheet, animated: true, completion: nil)
    }

    func changePlateStructuralSubmodel(button: SCAnalysisButton) {
        let actionSheet = UIAlertController(title: "Change Plate/Shell Submodel", message: nil, preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: Constant.SubmodelName.Plate.kirchhoffLove, style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            guard self.structuralModel.model != .plate(.kirchhoffLove) else { return }
            self.structuralModel.model = .plate(.kirchhoffLove)
            self.tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
        })
        let action2 = UIAlertAction(title: Constant.SubmodelName.Plate.reissnerMindlin, style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            guard self.structuralModel.model != .plate(.reissnerMindlin) else { return }
            self.structuralModel.model = .plate(.reissnerMindlin)
            self.tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(action1)
        actionSheet.addAction(action2)
        actionSheet.addAction(cancel)
        actionSheet.popoverPresentationController?.sourceView = button
        actionSheet.popoverPresentationController?.sourceRect = button.bounds
        present(actionSheet, animated: true, completion: nil)
    }
}

// MARK: - TypeOfAnalysisCellDelegate

extension HomogenizationController: TypeOfAnalysisCellDelegate {
    func changeTypeOfAnalysis(button: SCAnalysisButton) {
        let actionSheet = UIAlertController(title: "Change Type of Analysis", message: nil, preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "Elastic Analysis", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            guard self.typeOfAnalysis != .elastic else { return }
            self.typeOfAnalysis = .elastic
            self.coreMaterials.materials.forEach { $0.changeAnalysisType(to: .elastic) }
            self.facesheetMaterials.materials.forEach { $0.changeAnalysisType(to: .elastic) }
            self.tableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .automatic)
            self.tableView.reloadRows(at: [IndexPath(row: 0, section: 2)], with: .automatic)
            self.tableView.reloadRows(at: [IndexPath(row: 1, section: 2)], with: .automatic)
        })
        let action2 = UIAlertAction(title: "Thermoelastic Analysis", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            guard self.typeOfAnalysis != .thermoElastic else { return }
            self.typeOfAnalysis = .thermoElastic
            self.coreMaterials.materials.forEach { $0.changeAnalysisType(to: .thermoElastic) }
            self.facesheetMaterials.materials.forEach { $0.changeAnalysisType(to: .thermoElastic) }
            self.tableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .automatic)
            self.tableView.reloadRows(at: [IndexPath(row: 0, section: 2)], with: .automatic)
            self.tableView.reloadRows(at: [IndexPath(row: 1, section: 2)], with: .automatic)
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(action1)
        if structuralModel.model != .beam(.eulerBernoulli) && structuralModel.model != .beam(.timoshenko) {
            actionSheet.addAction(action2)
        }
        actionSheet.addAction(cancel)
        actionSheet.popoverPresentationController?.sourceView = button
        actionSheet.popoverPresentationController?.sourceRect = button.bounds
        present(actionSheet, animated: true, completion: nil)
    }
}

// MARK: - MaterialCellDelegate

extension HomogenizationController: MaterialCellDelegate {
    func changeSelectedMaterialType(index: Int, materialTitle: String?) {
        if materialTitle == "Core Material" {
            tableView.reloadRows(at: [IndexPath(row: 0, section: 2)], with: .automatic)
        } else {
            tableView.reloadRows(at: [IndexPath(row: 1, section: 2)], with: .automatic)
        }
    }
}
