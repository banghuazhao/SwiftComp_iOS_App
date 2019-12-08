//
//  HoneycombSandwichController.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 12/2/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import UIKit

import Moya
import SwiftyJSON

class HoneycombSandwichController: UIViewController, HomogenizationControllerType, ErrorPopoverRenderer {
    var method: Method = .swiftComp

    var structuralModel: StructuralModel = StructuralModel(model: .plate(.kirchhoffLove))

    var typeOfAnalysis: TypeOfAnalysis = .elastic

    private lazy var honeycombCore = HoneycombCore(coreLength: 3.6, coreThickness: 0.1, coreHeight: 10)

    private lazy var faceSheetGeometry = StackingSequence(sectionTitle: "Facesheet", stackingSequenceText: "[45/-45]", layerThickness: 0.1, maxNumOfLayers: 6)

    private lazy var coreMaterials: Materials = Materials(
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

    private lazy var facesheetMaterials: Materials = Materials(
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

    private lazy var calculationButton = SCCalculateButton()

    private lazy var provider = MoyaProvider<HoneycombSandwichAPI>()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .greybackgroundColor
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MethodCell.self, forCellReuseIdentifier: "MethodCell")
        tableView.register(TypeOfAnalysisCell.self, forCellReuseIdentifier: "TypeOfAnalysisCell")
        tableView.register(StructuralModelCell.self, forCellReuseIdentifier: "StructuralModelCell")
        tableView.register(HoneycombCoreCell.self, forCellReuseIdentifier: "HoneycombCoreCell")
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

extension HoneycombSandwichController {
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

    // MARK: resetCalculationBar

    private func resetCalculationBar() {
        if method == .swiftComp {
            if NetworkManager.sharedInstance.reachability.connection != .none {
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

        guard honeycombCore.isValid else {
            wrongHoneycombCoreGeometryPopover()
            return false
        }

        guard !faceSheetGeometry.tooManyLayers else {
            tooManyLayersPopover(maxNumOfLayers: 6)
            return false
        }

        guard faceSheetGeometry.isValid else {
            wrongStackingSequencePopover()
            return false
        }

        guard faceSheetGeometry.layerThickness != nil else {
            wrongLayerThicknessPopover()
            return false
        }

        guard coreMaterials.selectedMaterial.isValid && facesheetMaterials.selectedMaterial.isValid else {
            wrongMaterialPropertiesPopover()
            return false
        }
        return true
    }
}

// MARK: - actions

extension HoneycombSandwichController {
    // MARK: SwiftComp calculate

    @objc func swiftCompCalculate(_ sender: UIButton) {
        guard isInputValid() else { return }
        showCalculationHUD()
        provider.request(.Homogenization(structuralModel: structuralModel, typeOfAnalysis: typeOfAnalysis, honeycombCore: honeycombCore, stackingSequence: faceSheetGeometry, coreMaterial: coreMaterials.selectedMaterial, facesheetMaterial: facesheetMaterials.selectedMaterial)) { [weak self] result in
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
                        let homInformation = HomInformation(route: "honeycombSandwich", dataJSON: dataJSON)
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
        print("Not implemented")
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension HoneycombSandwichController: UITableViewDelegate, UITableViewDataSource {
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
            return 2
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

extension HoneycombSandwichController: MethodCellDelegate {
    func changeMethod(button: SCAnalysisButton) {
        let actionSheet = UIAlertController(title: "Change Method", message: nil, preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: Constant.MethodName.swiftComp, style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
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

extension HoneycombSandwichController: StructuralModelCellDelegate {
    func changeStructuralModel(button: SCAnalysisButton) {
        let actionSheet = UIAlertController(title: "Change Structural Model", message: nil, preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: Constant.ModelName.beam, style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            self.structuralModel.model = .beam(.eulerBernoulli)
            self.tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
        })
        let action2 = UIAlertAction(title: Constant.ModelName.plate, style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            self.structuralModel.model = .plate(.kirchhoffLove)
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

extension HoneycombSandwichController: TypeOfAnalysisCellDelegate {
    func changeTypeOfAnalysis(button: SCAnalysisButton) {
        let actionSheet = UIAlertController(title: "Change Type of Analysis", message: nil, preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "Elastic Analysis", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            self.typeOfAnalysis = .elastic
            self.coreMaterials.materials.forEach { $0.changeAnalysisType(to: .elastic) }
            self.facesheetMaterials.materials.forEach { $0.changeAnalysisType(to: .elastic) }
            self.tableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .automatic)
            self.tableView.reloadSections(IndexSet(arrayLiteral: 2), with: .automatic)
        })
        let action2 = UIAlertAction(title: "Thermoelastic Analysis", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            self.typeOfAnalysis = .thermoElastic
            self.coreMaterials.materials.forEach { $0.changeAnalysisType(to: .thermoElastic) }
            self.facesheetMaterials.materials.forEach { $0.changeAnalysisType(to: .thermoElastic) }
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

extension HoneycombSandwichController: MaterialCellDelegate {
    func changeSelectedMaterialType(index: Int, materialTitle: String?) {
        if materialTitle == "Core Material" {
            tableView.reloadRows(at: [IndexPath(row: 0, section: 2)], with: .automatic)
        } else {
            tableView.reloadRows(at: [IndexPath(row: 1, section: 2)], with: .automatic)
        }
    }
}
