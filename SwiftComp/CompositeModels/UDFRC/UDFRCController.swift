//
//  UDFRCController.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 12/6/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import UIKit
import CoreData

import Moya
import SwiftyJSON

class UDFRCController: UIViewController, HomogenizationControllerType, ErrorPopoverRenderer {
    var method: Method = .swiftComp

    var structuralModel: StructuralModel = StructuralModel(model: .solid(.cauchyContinuum))

    var typeOfAnalysis: TypeOfAnalysis = .elastic

    lazy var fiberVolumeFraction = VolumeFraction(value: 0.3, cellLength: 1.0)

    lazy var fiberMaterials: Materials = Materials(
        sectionTitle: "Fiber Material",
        materials: [
            Material(name: "E-Glass",
                     materialType: .isotropic(.elastic),
                     materialProperties: [
                         MaterialProperty(name: .E, value: 77.0),
                         MaterialProperty(name: .nu, value: 0.22),
            ]),
            Material(name: "New Transversely Material", materialType: .transverselyIsotropic(.elastic)),
            Material(name: "New Orthotropic Material", materialType: .orthotropic(.elastic)),
        ],
        selectedIndex: 0)

    lazy var matrixMaterials: Materials = Materials(
        sectionTitle: "Matrix Material",
        materials: [
            Material(name: "Epoxy",
                     materialType: .isotropic(.elastic),
                     materialProperties: [
                         MaterialProperty(name: .E, value: 4.6),
                         MaterialProperty(name: .nu, value: 0.36),
            ]),
            Material(name: "New Transversely Material", materialType: .transverselyIsotropic(.elastic)),
            Material(name: "New Orthotropic Material", materialType: .orthotropic(.elastic)),
        ],
        selectedIndex: 0)

    private lazy var calculationButton = SCCalculateButton()

    private lazy var provider = MoyaProvider<UDFRCAPI>()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .greybackgroundColor
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MethodCell.self, forCellReuseIdentifier: "MethodCell")
        tableView.register(TypeOfAnalysisCell.self, forCellReuseIdentifier: "TypeOfAnalysisCell")
        tableView.register(StructuralModelCell.self, forCellReuseIdentifier: "StructuralModelCell")
        tableView.register(FiberVolumeFractionCell.self, forCellReuseIdentifier: "FiberVolumeFractionCell")
        tableView.register(MaterialsCell.self, forCellReuseIdentifier: "MaterialsCell")
        return tableView
    }()

    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupKeyboard()
        setupReachabilityListener()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetCalculationBar()
    }
}

// MARK: - private functions

extension UDFRCController {
    // MARK: setupView

    private func setupView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        let calculationBar = UIView()
        view.addSubview(calculationBar)
        calculationBar.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-50)
        }
        calculationBar.backgroundColor = .SCNavigation
        calculationBar.addSubview(calculationButton)
        calculationButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(8)
        }
    }

    // MARK: setupReachabilityListener

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

    // MARK: resetCalcutionBar

    private func resetCalculationBar() {
        if method == .swiftComp {
            if NetworkManager.sharedInstance.reachability.connection != .unavailable {
                calculationButton.changeStyle(style: .cloud)
                calculationButton.addTarget(self, action: #selector(swiftCompCalculate), for: .touchUpInside)
            } else {
                calculationButton.changeStyle(style: .noInternet)
                calculationButton.addTarget(self, action: #selector(swiftCompCalculateOffline), for: .touchUpInside)
            }
        } else {
            calculationButton.changeStyle(style: .local)
            calculationButton.addTarget(self, action: #selector(nonSwiftCompCalculate), for: .touchUpInside)
        }
    }

    // MARK: - isInputValid

    private func isInputValid() -> Bool {
        switch structuralModel.model {
        case .beam:
            guard structuralModel.beamExtraInput.isValid else {
                wrongBeamSubmodelParameters()
                return false
            }
        case .plate:
            guard structuralModel.plateExtraInput.isValid else {
                wrongPlateSubmodelParameters()
                return false
            }
        case .solid:
            break
        }
        
        guard fiberVolumeFraction.cellLength != nil else {
            wrongSquarePackLengthPopover()
            return false
        }

        guard fiberMaterials.selectedMaterial.isValid && matrixMaterials.selectedMaterial.isValid else {
            wrongMaterialPropertiesPopover()
            return false
        }
        return true
    }
}

// MARK: - actions

extension UDFRCController {
    // MARK: SwiftComp calculate

    @objc func swiftCompCalculate(_ sender: UIButton) {
        guard isInputValid() else { return }

        showCalculationHUD()
        provider.request(.Homogenization(structuralModel: structuralModel, typeOfAnalysis: typeOfAnalysis, fiberVolumeFraction: fiberVolumeFraction, fiberMaterial: fiberMaterials.selectedMaterial, matrixMaterial: matrixMaterials.selectedMaterial)) { [weak self] result in
            guard let self = self else { return }

            if self.isCalculationCancelled { return }

            switch result {
            case let .success(moyaResponse):

                do {
                    _ = try moyaResponse.filterSuccessfulStatusCodes()
                    let dataJSON = try JSON(data: moyaResponse.data)
                    print(dataJSON)

                    self.showCalculationSuccessHUD {
                        let homResultController = HomResultController()
                        switch self.structuralModel.model {
                        case .beam:
                            let homBeamResult = HomBeamResult(typeOfAnalysis: self.typeOfAnalysis, structuralModel: self.structuralModel, dataJSON: dataJSON)
                            homResultController.homBeamResult = homBeamResult
                        case .plate:
                            let homPlateResult = HomPlateResult(typeOfAnalysis: self.typeOfAnalysis, dataJSON: dataJSON)
                            homResultController.homPlateResult = homPlateResult
                        case .solid:
                            let homSolidResult = HomSolidResult(typeOfAnalysis: self.typeOfAnalysis, dataJSON: dataJSON)
                            homResultController.homSolidResult = homSolidResult
                        }
                        let homMeshImage = HomMeshImage(imageData: Data())
                        let homInformation = HomInformation(route: "UDFRC", dataJSON: dataJSON)
                        homResultController.homMeshImage = homMeshImage
                        homResultController.homInformation = homInformation
                        self.navigationController?.pushViewController(homResultController, animated: true)
                    }
                } catch let error {
                    print(error)
                    self.dismissHUD()
                    if moyaResponse.statusCode == 400 {
                        self.swiftcompCalculationErrorPopover()
                    } else {
                        self.unknownErrorPopover()
                    }
                }
            case let .failure(error):
                print(error)
                self.dismissHUD()
                self.networkErrorPopover()
            }
        }
    }

    // MARK: swiftCompCalculateOffline

    @objc func swiftCompCalculateOffline() {
        noNetworkErrorPopover()
    }

    // MARK: nonSwiftCompCalculate

    @objc func nonSwiftCompCalculate() {
        guard isInputValid() else { return }
        ROMCalculate()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension UDFRCController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 2 {
            return tablewViewFooterHeight
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
            return 1
        case 2:
            return 2
        default:
            return 0
        }
    }

    // MARK: cellForRowAt indexPath

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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FiberVolumeFractionCell") as? FiberVolumeFractionCell else { return UITableViewCell() }
            cell.fiberVolumeFraction = fiberVolumeFraction
            cell.structrualModel = structuralModel
            return cell
        case 2:
            if indexPath.row == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "MaterialsCell") as? MaterialsCell else { return UITableViewCell() }
                cell.materials = fiberMaterials
                cell.delegate = self
                return cell
            } else if indexPath.row == 1 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "MaterialsCell") as? MaterialsCell else { return UITableViewCell() }
                cell.materials = matrixMaterials
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

extension UDFRCController: MethodCellDelegate {
    func changeMethod(button: SCAnalysisButton) {
        let actionSheet = UIAlertController(title: "Change Method", message: nil, preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: Constant.MethodName.swiftComp, style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            self.method = .swiftComp
            self.resetCalculationBar()
            self.tableView.reloadSections(IndexSet(arrayLiteral: 0,1), with: .automatic)
        })
        let action2 = UIAlertAction(title: Constant.MethodName.NonSwiftComp.voigtROM, style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            self.method = .nonSwiftComp(.voigtROM)
            self.structuralModel.model = .solid(.cauchyContinuum)
            self.resetCalculationBar()
            self.tableView.reloadSections(IndexSet(arrayLiteral: 0,1), with: .automatic)
        })
        let action3 = UIAlertAction(title: Constant.MethodName.NonSwiftComp.reussROM, style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            self.method = .nonSwiftComp(.reussROM)
            self.structuralModel.model = .solid(.cauchyContinuum)
            self.resetCalculationBar()

            self.tableView.reloadSections(IndexSet(arrayLiteral: 0,1), with: .automatic)
        })
        let action4 = UIAlertAction(title: Constant.MethodName.NonSwiftComp.hybridROM, style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            self.method = .nonSwiftComp(.hybridROM)
            self.structuralModel.model = .solid(.cauchyContinuum)
            self.resetCalculationBar()
            self.tableView.reloadSections(IndexSet(arrayLiteral: 0,1), with: .automatic)
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(action1)
        actionSheet.addAction(action2)
        actionSheet.addAction(action3)
        actionSheet.addAction(action4)
        actionSheet.addAction(cancel)
        actionSheet.popoverPresentationController?.sourceView = button
        actionSheet.popoverPresentationController?.sourceRect = button.bounds
        present(actionSheet, animated: true, completion: nil)
    }
}

// MARK: - StructuralModelCellDelegate

extension UDFRCController: StructuralModelCellDelegate {
    func changeStructuralModel(button: SCAnalysisButton) {
        let actionSheet = UIAlertController(title: "Change Structural Model", message: nil, preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: Constant.ModelName.beam, style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            self.structuralModel.model = .beam(.eulerBernoulli)
            self.tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
            self.tableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .automatic)
        })
        let action2 = UIAlertAction(title: Constant.ModelName.plate, style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            self.structuralModel.model = .plate(.kirchhoffLove)
            self.tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
            self.tableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .automatic)
        })
        let action3 = UIAlertAction(title: Constant.ModelName.solid, style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            self.structuralModel.model = .solid(.cauchyContinuum)
            self.tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
            self.tableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .automatic)
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        if (method == .swiftComp) {
            actionSheet.addAction(action1)
            actionSheet.addAction(action2)
        }
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
            self.structuralModel.model = .beam(.eulerBernoulli)
            self.tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
        })
        let action2 = UIAlertAction(title: Constant.SubmodelName.Beam.timoshenko, style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
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
            self.structuralModel.model = .plate(.kirchhoffLove)
            self.tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
        })
        let action2 = UIAlertAction(title: Constant.SubmodelName.Plate.reissnerMindlin, style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
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

extension UDFRCController: TypeOfAnalysisCellDelegate {
    func changeTypeOfAnalysis(button: SCAnalysisButton) {
        let actionSheet = UIAlertController(title: "Change Type of Analysis", message: nil, preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "Elastic Analysis", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            self.typeOfAnalysis = .elastic
            self.fiberMaterials.materials.forEach { $0.changeAnalysisType(to: .elastic) }
            self.matrixMaterials.materials.forEach { $0.changeAnalysisType(to: .elastic) }
            self.tableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .automatic)
            self.tableView.reloadSections(IndexSet(arrayLiteral: 2), with: .automatic)
        })
        let action2 = UIAlertAction(title: "Thermoelastic Analysis", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            self.typeOfAnalysis = .thermoElastic
            self.fiberMaterials.materials.forEach { $0.changeAnalysisType(to: .thermoElastic) }
            self.matrixMaterials.materials.forEach { $0.changeAnalysisType(to: .thermoElastic) }
            self.tableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .automatic)
            self.tableView.reloadSections(IndexSet(arrayLiteral: 2), with: .automatic)
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

extension UDFRCController: MaterialCellDelegate {
    func importButtonTapped(sectionTitle: String) {
        if sectionTitle == "Fiber Material" {
            let ac = UIAlertController(title: "Save Fiber Material", message: "Fiber Material to be saved:\n\(fiberMaterials.selectedMaterial.name)", preferredStyle: UIAlertController.Style.alert)
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            ac.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak self] _ in
                guard let self = self else { return }
                let userMaterial = NSEntityDescription.insertNewObject(forEntityName: "UserFiberMaterial", into: CoreDataManager.sharedContext) as! UserFiberMaterial
                userMaterial.setValue(self.fiberMaterials.selectedMaterial.name, forKey: "name")
                userMaterial.setValue(self.fiberMaterials.selectedMaterial.getMaterialTypeText(), forKey: "type")

                var materialProperties: [String: String] = [:]
                self.fiberMaterials.selectedMaterial.materialProperties.forEach {
                    materialProperties[$0.name.rawValue] = $0.valueText
                }
                userMaterial.setValue(materialProperties, forKey: "properties")
                // perform the save
                do {
                    try CoreDataManager.sharedContext.save()

                    // success
                    self.showSavedHuD()

                } catch let saveErr {
                    print(saveErr)
                }
            }))
            present(ac, animated: true, completion: nil)
        } else {
            let ac = UIAlertController(title: "Save Matrix Material", message: "Matrix Material to be saved:\n\(matrixMaterials.selectedMaterial.name)", preferredStyle: UIAlertController.Style.alert)
              ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
              ac.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak self] _ in
                  guard let self = self else { return }
                  let userMaterial = NSEntityDescription.insertNewObject(forEntityName: "UserMatrixMaterial", into: CoreDataManager.sharedContext) as! UserMatrixMaterial
                  userMaterial.setValue(self.matrixMaterials.selectedMaterial.name, forKey: "name")
                  userMaterial.setValue(self.matrixMaterials.selectedMaterial.getMaterialTypeText(), forKey: "type")

                  var materialProperties: [String: String] = [:]
                  self.matrixMaterials.selectedMaterial.materialProperties.forEach {
                      materialProperties[$0.name.rawValue] = $0.valueText
                  }
                  userMaterial.setValue(materialProperties, forKey: "properties")
                  // perform the save
                  do {
                      try CoreDataManager.sharedContext.save()

                      // success
                      self.showSavedHuD()

                  } catch let saveErr {
                      print(saveErr)
                  }
              }))
              present(ac, animated: true, completion: nil)
        }
    }
    
    func exportButtonTapped(sectionTitle: String) {
        if sectionTitle == "Fiber Material" {
            let fiberMaterialDataBaseVC = FiberMaterialDataBaseVC()
            fiberMaterialDataBaseVC.delegate = self
            let navController = SCNavigationController(rootViewController: fiberMaterialDataBaseVC)
            present(navController, animated: true, completion: nil)
        } else {
            let matrixMaterialDataBaseVC = MatrixMaterialDataBaseVC()
            matrixMaterialDataBaseVC.delegate = self
            let navController = SCNavigationController(rootViewController: matrixMaterialDataBaseVC)
            present(navController, animated: true, completion: nil)
        }
    }
    
    func changeSelectedMaterialType(index: Int, materialTitle: String?) {
        if materialTitle == "Fiber Material" {
            tableView.reloadRows(at: [IndexPath(row: 0, section: 2)], with: .automatic)
        } else {
            tableView.reloadRows(at: [IndexPath(row: 1, section: 2)], with: .automatic)
        }
    }
}

// MARK: - FiberMaterialDataBaseVCDelegate

extension UDFRCController: FiberMaterialDataBaseVCDelegate {
    func didSelectFiberMaterial(material: Material) {
        material.changeAnalysisType(to: typeOfAnalysis)
        var newSelectedIndex = 0
        switch material.materialType {
        case .isotropic(_):
            newSelectedIndex = 0
        case .transverselyIsotropic(_):
            newSelectedIndex = 1
        case .orthotropic(_):
            newSelectedIndex = 2
        default:
            break
        }
        fiberMaterials.changeSelectedMaterial(newMaterial: material, newSelectedIndex: newSelectedIndex)
        tableView.reloadRows(at: [IndexPath(row: 0, section: 2)], with: .automatic)
    }
}

// MARK: - MatrixMaterialDataBaseVCDelegate

extension UDFRCController: MatrixMaterialDataBaseVCDelegate {
    func didSelectMatrixMaterial(material: Material) {
        material.changeAnalysisType(to: typeOfAnalysis)
        var newSelectedIndex = 0
        switch material.materialType {
        case .isotropic(_):
            newSelectedIndex = 0
        case .transverselyIsotropic(_):
            newSelectedIndex = 1
        case .orthotropic(_):
            newSelectedIndex = 2
        default:
            break
        }
        matrixMaterials.changeSelectedMaterial(newMaterial: material, newSelectedIndex: newSelectedIndex)
        tableView.reloadRows(at: [IndexPath(row: 1, section: 2)], with: .automatic)
    }
}
