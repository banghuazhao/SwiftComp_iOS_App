//
//  LaminateController.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 12/3/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import CoreData
import UIKit

import Moya
import SwiftyJSON

class LaminateController: UIViewController, HomogenizationControllerType, ErrorPopoverRenderer {
    var method: Method = .swiftComp

    var structuralModel: StructuralModel = StructuralModel(model: .solid(.cauchyContinuum))

    var typeOfAnalysis: TypeOfAnalysis = .elastic

    lazy var stackingSequence = StackingSequence(stackingSequenceText: "[0/90/45/-45]s", layerThickness: 1.0, maxNumOfLayers: 1000)

    lazy var laminaMaterials: Materials = Materials(
        sectionTitle: "Lamina Material",
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

    private lazy var calculationButton = SCCalculateButton()

    private lazy var provider = MoyaProvider<LaminateControllerAPI>()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .SCBackground
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MethodCell.self, forCellReuseIdentifier: "MethodCell")
        tableView.register(TypeOfAnalysisCell.self, forCellReuseIdentifier: "TypeOfAnalysisCell")
        tableView.register(StructuralModelCell.self, forCellReuseIdentifier: "StructuralModelCell")
        tableView.register(StackingSequenceCell.self, forCellReuseIdentifier: "StackingSequenceCell")
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

extension LaminateController {
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
                    self.calculationButton.addTarget(self, action: #selector(self.swiftCompCalculate), for: .touchUpInside)
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
                    self.calculationButton.addTarget(self, action: #selector(self.swiftCompCalculate), for: .touchUpInside)
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

    // MARK: editToolBar

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

        guard !stackingSequence.tooManyLayers else {
            tooManyLayersPopover(maxNumOfLayers: stackingSequence.maxNumOfLayers)
            return false
        }

        guard stackingSequence.isValid else {
            wrongStackingSequencePopover()
            return false
        }

        guard stackingSequence.layerThickness != nil else {
            wrongLayerThicknessPopover()
            return false
        }

        guard laminaMaterials.selectedMaterial.isValid else {
            wrongMaterialPropertiesPopover()
            return false
        }
        return true
    }
}

// MARK: - actions

extension LaminateController {
    // MARK: SwiftComp calculate

    @objc func swiftCompCalculate() {
        guard isInputValid() else { return }
        showCalculationHUD()
        provider.request(.Homogenization(structuralModel: structuralModel, typeOfAnalysis: typeOfAnalysis, stackingSequence: stackingSequence, laminaMaterial: laminaMaterials.selectedMaterial)) { [weak self] result in
            guard let self = self else { return }

            if self.isCalculationCancelled { return }

            switch result {
            case let .success(moyaResponse):
                do {
                    let dataJSON = try JSON(data: moyaResponse.data)
                    print(dataJSON)
                    _ = try moyaResponse.filterSuccessfulStatusCodes()

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
                        let homInformation = HomInformation(route: "laminate", dataJSON: dataJSON)
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

    @objc func nonSwiftCompCalculate() {
        guard isInputValid() else { return }
        CLPTCalculate()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension LaminateController: UITableViewDelegate, UITableViewDataSource {
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
            return 1
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "StackingSequenceCell") as? StackingSequenceCell else { return UITableViewCell() }
            cell.stackingSequence = stackingSequence
            cell.structrualModel = structuralModel
            cell.delegate = self
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MaterialsCell") as? MaterialsCell else { return UITableViewCell() }
            cell.materials = laminaMaterials
            cell.delegate = self
            return cell
        default:
            break
        }
        return UITableViewCell()
    }
}

// MARK: - MethodCellDelegate

extension LaminateController: MethodCellDelegate {
    func changeMethod(button: SCAnalysisButton) {
        let actionSheet = UIAlertController(title: "Change Method", message: nil, preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: Constant.MethodName.swiftComp, style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            self.method = .swiftComp
            self.resetCalculationBar()
            self.tableView.reloadSections(IndexSet(arrayLiteral: 0, 1), with: .automatic)
        })
        let action2 = UIAlertAction(title: Constant.MethodName.NonSwiftComp.clpt, style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            self.method = .nonSwiftComp(.clpt)
            self.resetCalculationBar()
            self.tableView.reloadSections(IndexSet(arrayLiteral: 0, 1), with: .automatic)
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

// MARK: - StructuralModelCellDelegate

extension LaminateController: StructuralModelCellDelegate {
    func changeStructuralModel(button: SCAnalysisButton) {
        let actionSheet = UIAlertController(title: "Change Structural Model", message: nil, preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: Constant.ModelName.plate, style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            self.structuralModel.model = .plate(.kirchhoffLove)
            self.tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
            self.tableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .automatic)
        })
        let action2 = UIAlertAction(title: Constant.ModelName.solid, style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            self.structuralModel.model = .solid(.cauchyContinuum)
            self.tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
            self.tableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .automatic)
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(action1)
        actionSheet.addAction(action2)
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

extension LaminateController: TypeOfAnalysisCellDelegate {
    func changeTypeOfAnalysis(button: SCAnalysisButton) {
        let actionSheet = UIAlertController(title: "Change Type of Analysis", message: nil, preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "Elastic Analysis", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            self.typeOfAnalysis = .elastic
            self.laminaMaterials.materials.forEach { $0.changeAnalysisType(to: .elastic) }
            self.tableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .automatic)
            self.tableView.reloadSections(IndexSet(arrayLiteral: 2), with: .automatic)
        })
        let action2 = UIAlertAction(title: "Thermoelastic Analysis", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            self.typeOfAnalysis = .thermoElastic
            self.laminaMaterials.materials.forEach { $0.changeAnalysisType(to: .thermoElastic) }
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

// MARK: - StackingSequenceCellDelegate

extension LaminateController: StackingSequenceCellDelegate {
    func importButtonTapped() {
        let ac = UIAlertController(title: "Save Stacking Sequence", message: "Stacking sequence to be saved:\n\(stackingSequence.stackingSequenceText)", preferredStyle: UIAlertController.Style.alert)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        ac.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            let userStackingSequence = NSEntityDescription.insertNewObject(forEntityName: "UserStackingSequence", into: CoreDataManager.sharedContext) as! UserStackingSequence
            userStackingSequence.setValue(self.stackingSequence.stackingSequenceText, forKey: "name")
            userStackingSequence.setValue(self.stackingSequence.stackingSequenceText, forKey: "stackingSequence")
            // perform the save
            do {
                try CoreDataManager.sharedContext.save()

                // success
                self.showSavedHuD()

            } catch let saveErr {
                print("Failed to save stacking sequence:", saveErr)
            }

        }))
        present(ac, animated: true, completion: nil)
    }

    func exportButtonTapped() {
        let stackingSequenceDataBaseVC = StackingSequenceDataBaseVC()

        stackingSequenceDataBaseVC.delegate = self

        let navController = SCNavigationController(rootViewController: stackingSequenceDataBaseVC)

        present(navController, animated: true, completion: nil)
    }
}

// MARK: - StackingSequenceDataBaseVCDelegate

extension LaminateController: StackingSequenceDataBaseVCDelegate {
    func didSelectStackingSequence(stackingSequence: String) {
        self.stackingSequence.stackingSequenceText = stackingSequence
        tableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .automatic)
    }
}

// MARK: - MaterialCellDelegate

extension LaminateController: MaterialCellDelegate {
    func importButtonTapped(sectionTitle: String) {
        let ac = UIAlertController(title: "Save Lamina Material", message: "Lamina Material to be saved:\n\(laminaMaterials.selectedMaterial.name)", preferredStyle: UIAlertController.Style.alert)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        ac.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            let userLaminaMaterial = NSEntityDescription.insertNewObject(forEntityName: "UserLaminaMaterial", into: CoreDataManager.sharedContext) as! UserLaminaMaterial
            userLaminaMaterial.setValue(self.laminaMaterials.selectedMaterial.name, forKey: "name")
            userLaminaMaterial.setValue(self.laminaMaterials.selectedMaterial.getMaterialTypeText(), forKey: "type")

            var materialProperties: [String: String] = [:]
            self.laminaMaterials.selectedMaterial.materialProperties.forEach {
                materialProperties[$0.name.rawValue] = $0.valueText
            }
            userLaminaMaterial.setValue(materialProperties, forKey: "properties")
            // perform the save
            do {
                try CoreDataManager.sharedContext.save()

                // success
                self.showSavedHuD()

            } catch let saveErr {
                print("Failed to save stacking sequence:", saveErr)
            }
        }))
        present(ac, animated: true, completion: nil)
    }

    func exportButtonTapped(sectionTitle: String) {
        let laminaMaterialDataBaseVC = LaminaMaterialDataBaseVC()
        laminaMaterialDataBaseVC.delegate = self
        let navController = SCNavigationController(rootViewController: laminaMaterialDataBaseVC)
        present(navController, animated: true, completion: nil)
    }

    func changeSelectedMaterialType(index: Int, materialTitle: String?) {
        tableView.reloadRows(at: [IndexPath(row: 0, section: 2)], with: .automatic)
    }
}

// MARK: - LaminateMaterialDataBaseDelegate

extension LaminateController: LaminaMaterialDataBaseVCDelegate {
    func didSelectLaminaMaterial(material: Material) {
        material.changeAnalysisType(to: typeOfAnalysis)
        var newSelectedIndex = 0
        switch material.materialType {
        case .transverselyIsotropic(_):
            newSelectedIndex = 0
        case .orthotropic(_):
            newSelectedIndex = 1
        case .anisotropic(_):
            newSelectedIndex = 2
        default:
            break
        }
        laminaMaterials.changeSelectedMaterial(newMaterial: material, newSelectedIndex: newSelectedIndex)
        tableView.reloadRows(at: [IndexPath(row: 0, section: 2)], with: .automatic)
    }
}
