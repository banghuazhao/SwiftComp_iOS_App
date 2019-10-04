//
//  UDFRC.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 9/14/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import UIKit
import Accelerate

class UDFRC: SwiftCompTemplateViewController, FiberMaterialDataBaseDelegate, MatrixMaterialDataBaseDelegate, UITextFieldDelegate {
    
    // Data
    
    enum ROMMethod {
        case Voigt
        case Reuss
        case Hybrid
    }
    
    var romMethod : ROMMethod = .Voigt
    
    var Vf = 0.0 // fiber volume fraction
    var squarePackLength = 1.0
    
    var (ef1, ef2, ef3, gf12, gf13, gf23, nuf12, nuf13, nuf23) = (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
    var (alphaf11, alphaf22, alphaf33, alphaf23, alphaf13, alphaf12) = (0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
    
    var (em1, em2, em3, gm12, gm13, gm23, num12, num13, num23) = (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
    var (alpham11, alpham22, alpham33, alpham23, alpham13, alpham12) = (0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
    
    // Core data
    
    var userSavedFiberMaterials = [UserFiberMaterial]()
    var userSavedMatrixMaterials = [UserMatrixMaterial]()
    
    // Geometry
    
    var geometryView: UIView = UIView()
    var geometryLabel: UILabel = UILabel()
    var geometrySquarePackView: UIView = UIView()
    var geometrySquare: CAShapeLayer = CAShapeLayer()
    var fiberGeometry: CAShapeLayer = CAShapeLayer()
    var fiberPositionOffset: CGFloat = CGFloat(0.0)
    var fiberGeometryPath: UIBezierPath = UIBezierPath()
    var volumeFractionSlider: UISlider = UISlider()
    var squarePackLengthLabel: UILabel = UILabel()
    var squarePackLengthTextField: UITextField = UITextField()
    
    // Fiber material
    
    var fiberMaterialType : MaterialType = .isotropic
    
    var fiberMaterialView: UIView = UIView()
    var fiberMaterialDataBase: UIButton = UIButton()
    var UDFRCFiberMaterialDataBaseViewController = FiberMaterialDataBase()
    let fiberMaterialTypeSegementedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Isotropic", "Transversely", "Orthotropic"])
        sc.selectedSegmentIndex = 0
        sc.apportionsSegmentWidthsByContent = true
        return sc
    }()
    var fiberMaterialCard: UIView = UIView()
    var fiberMaterialNameLabel: UILabel = UILabel()
    var fiberMaterialPropertiesLabel: [UILabel] = []
    var fiberMaterialPropertiesTextField: [UITextField] = []
    var saveFiberMaterialButton: UIButton = UIButton()
    
    
    // Matrix material
    
    var matrixMaterialType : MaterialType = .isotropic
    
    var matrixMaterialView: UIView = UIView()
    var matrixMaterialDataBase: UIButton = UIButton()
    var UDFRCMatrixMaterialDataBaseViewController = MatrixMaterialDataBase()
    let matrixMaterialTypeSegementedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Isotropic", "Transversely", "Orthotropic"])
        sc.selectedSegmentIndex = 0
        sc.apportionsSegmentWidthsByContent = true
        return sc
    }()
    var matrixMaterialCard: UIView = UIView()
    var matrixMaterialNameLabel: UILabel = UILabel()
    var matrixMaterialPropertiesLabel: [UILabel] = []
    var matrixMaterialPropertiesTextField: [UITextField] = []
    var saveMatrixMaterialButton: UIButton = UIButton()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        navigationItem.title = "UDFRC"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        
        loadCoreData()
        
    }
    
    
    // MARK: creaete layout
    
    override func createLayout() {
        super .createLayout()
        
        typeOfAnalysisView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -40).isActive = false
        scrollView.constraints.filter({$0.firstAttribute == NSLayoutConstraint.Attribute.bottom}).forEach{ $0.isActive = false }
        
        scrollView.addSubviews(geometryView, fiberMaterialView, matrixMaterialView)

        // geometry
        
        var geometryQuestionButton: UIButton = UIButton()
        
        createViewCardWithTitleHelpButton(viewCard: geometryView, title: "Geometry", helpButton: &geometryQuestionButton, aboveConstraint: typeOfAnalysisView.bottomAnchor, under: scrollView)
        
        geometryQuestionButton.addTarget(self, action: #selector(geometryQuestionExplain), for: .touchUpInside)
        
        geometryView.addSubview(geometrySquarePackView)
        geometryView.addSubview(geometryLabel)
        geometryView.addSubview(volumeFractionSlider)
        
        geometrySquarePackView.translatesAutoresizingMaskIntoConstraints = false
        geometrySquarePackView.topAnchor.constraint(equalTo: geometryView.topAnchor, constant: 30).isActive = true
        geometrySquarePackView.heightAnchor.constraint(equalToConstant: 100) .isActive = true
        geometrySquarePackView.widthAnchor.constraint(equalToConstant: 100) .isActive = true
        geometrySquarePackView.centerXAnchor.constraint(equalTo: geometryView.centerXAnchor, constant: 0).isActive = true
        geometrySquarePackView.layer.addSublayer(geometrySquare)
        geometrySquarePackView.layer.addSublayer(fiberGeometry)
        
        let squarePath = UIBezierPath()
        squarePath.move(to: CGPoint(x: geometrySquarePackView.frame.minX, y: geometrySquarePackView.frame.minY))
        squarePath.addLine(to: CGPoint(x: geometrySquarePackView.frame.minX + 100, y: geometrySquarePackView.frame.minY))
        squarePath.addLine(to: CGPoint(x: geometrySquarePackView.frame.minX + 100, y: geometrySquarePackView.frame.minY+100))
        squarePath.addLine(to: CGPoint(x: geometrySquarePackView.frame.minX, y: geometrySquarePackView.frame.minY+100))
        squarePath.close()
        geometrySquare.path = squarePath.cgPath
        geometrySquare.fillColor = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 1.0).cgColor
        
        fiberPositionOffset = CGFloat(50-sqrt(3000/Double.pi))
        fiberGeometryPath = UIBezierPath(ovalIn: CGRect(x: geometrySquarePackView.frame.minX + fiberPositionOffset, y: geometrySquarePackView.frame.minY + fiberPositionOffset, width: CGFloat(2*sqrt(3000/Double.pi)), height: CGFloat(2*sqrt(3000/Double.pi))))
        fiberGeometry.path = fiberGeometryPath.cgPath
        fiberGeometry.fillColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0).cgColor
        
        geometryLabel.translatesAutoresizingMaskIntoConstraints = false
        geometryLabel.text = "Fiber Volume Fraction: 0.30"
        geometryLabel.textAlignment = .center
        geometryLabel.font = UIFont.systemFont(ofSize: 14)
        geometryLabel.heightAnchor.constraint(equalToConstant: 16).isActive = true
        geometryLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: geometryLabel.intrinsicContentSize.width + 20).isActive = true
        geometryLabel.topAnchor.constraint(equalTo: geometrySquarePackView.bottomAnchor, constant: 10).isActive = true
        geometryLabel.centerXAnchor.constraint(equalTo: geometryView.centerXAnchor).isActive = true
        
        volumeFractionSlider.minimumValue = 0
        volumeFractionSlider.maximumValue = 1.00
        volumeFractionSlider.isContinuous = true
        volumeFractionSlider.value = 0.30
        volumeFractionSlider.addTarget(self, action: #selector(changeVolumeFraction), for: .valueChanged)
        volumeFractionSlider.translatesAutoresizingMaskIntoConstraints = false
        volumeFractionSlider.topAnchor.constraint(equalTo: geometryLabel.bottomAnchor, constant: 0).isActive = true
        volumeFractionSlider.widthAnchor.constraint(equalTo: geometryView.widthAnchor, multiplier: 0.8).isActive = true
        volumeFractionSlider.centerXAnchor.constraint(equalTo: geometryView.centerXAnchor, constant: 0).isActive = true
        volumeFractionSlider.heightAnchor.constraint(equalToConstant: 30).isActive = true
        volumeFractionSlider.bottomAnchor.constraint(equalTo: geometryView.bottomAnchor, constant: -12).isActive = true
        
        geometryView.addSubview(squarePackLengthLabel)
        geometryView.addSubview(squarePackLengthTextField)
        
        squarePackLengthLabel.translatesAutoresizingMaskIntoConstraints = false
        squarePackLengthLabel.text = "Square Pack Length"
        squarePackLengthLabel.font = UIFont.systemFont(ofSize: 14)
        squarePackLengthLabel.topAnchor.constraint(equalTo: volumeFractionSlider.bottomAnchor, constant: 8).isActive = true
        squarePackLengthLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        squarePackLengthLabel.centerXAnchor.constraint(equalTo: geometryView.centerXAnchor, constant: -54).isActive = true
        squarePackLengthLabel.widthAnchor.constraint(equalToConstant: 140).isActive = true
        
        squarePackLengthTextField.translatesAutoresizingMaskIntoConstraints = false
        squarePackLengthTextField.placeholder = "Length"
        squarePackLengthTextField.text = "1.0"
        squarePackLengthTextField.borderStyle = .roundedRect
        squarePackLengthTextField.font = UIFont.systemFont(ofSize: 14)
        squarePackLengthTextField.heightAnchor.constraint(equalToConstant: 25).isActive = true
        squarePackLengthTextField.topAnchor.constraint(equalTo: volumeFractionSlider.bottomAnchor, constant: 8).isActive = true
        squarePackLengthTextField.centerXAnchor.constraint(equalTo: geometryView.centerXAnchor, constant: 74).isActive = true
        squarePackLengthTextField.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        squarePackLengthTextField.bottomAnchor.constraint(equalTo: geometryView.bottomAnchor, constant: -12).isActive = false
        
        squarePackLengthLabel.isHidden = true
        squarePackLengthTextField.isHidden = true
        
        
        // fiber material
        
        var fiberMaterialQuestionButton: UIButton = UIButton()
        
        createViewCardWithTitleHelpButtonDatabaseButton(viewCard: fiberMaterialView, title: "Fiber Material", helpButton: &fiberMaterialQuestionButton, databaseButton: &fiberMaterialDataBase, saveDatabaseButton: &saveFiberMaterialButton, aboveConstraint: geometryView.bottomAnchor, under: scrollView)
        
        fiberMaterialQuestionButton.addTarget(self, action: #selector(fiberMaterialQuestionExplain), for: .touchUpInside)
        fiberMaterialDataBase.addTarget(self, action: #selector(enterFiberMaterialDataBase), for: .touchUpInside)
        saveFiberMaterialButton.addTarget(self, action: #selector(saveFiberMaterial), for: .touchUpInside)
        
        fiberMaterialView.addSubview(fiberMaterialTypeSegementedControl)
        fiberMaterialView.addSubview(fiberMaterialCard)
        
        
        fiberMaterialTypeSegementedControl.translatesAutoresizingMaskIntoConstraints = false
        fiberMaterialTypeSegementedControl.addTarget(self, action: #selector(changeFiberMaterialType), for: .valueChanged)
        fiberMaterialTypeSegementedControl.widthAnchor.constraint(equalTo: fiberMaterialView.widthAnchor, multiplier: 0.8).isActive = true
        fiberMaterialTypeSegementedControl.topAnchor.constraint(equalTo: fiberMaterialDataBase.bottomAnchor, constant: 8).isActive = true
        fiberMaterialTypeSegementedControl.centerXAnchor.constraint(equalTo: fiberMaterialView.centerXAnchor).isActive = true
        
        fiberMaterialNameLabel.text = "E-Glass"
        createMaterialCard(materialCard: &fiberMaterialCard, materialName: fiberMaterialNameLabel, label: &fiberMaterialPropertiesLabel, value: &fiberMaterialPropertiesTextField, aboveConstraint: fiberMaterialTypeSegementedControl.bottomAnchor, under: fiberMaterialView, typeOfAnalysis: analysisSettings.typeOfAnalysis, materialType: .isotropic)
        
        fiberMaterialCard.bottomAnchor.constraint(equalTo: fiberMaterialView.bottomAnchor, constant: -12).isActive = true
        
        
        // matrix material
        
        var matrixMaterialQuestionButton: UIButton = UIButton()
        
        createViewCardWithTitleHelpButtonDatabaseButton(viewCard: matrixMaterialView, title: "Matrix Material", helpButton: &matrixMaterialQuestionButton, databaseButton: &matrixMaterialDataBase, saveDatabaseButton: &saveMatrixMaterialButton, aboveConstraint: fiberMaterialView.bottomAnchor, under: scrollView)
        
        matrixMaterialQuestionButton.addTarget(self, action: #selector(matrixMaterialQuestionExplain), for: .touchUpInside)
        matrixMaterialDataBase.addTarget(self, action: #selector(enterMatrixMaterialDataBase), for: .touchUpInside)
        saveMatrixMaterialButton.addTarget(self, action: #selector(saveMatrixMaterial), for: .touchUpInside)
        
        matrixMaterialView.addSubview(matrixMaterialTypeSegementedControl)
        matrixMaterialView.addSubview(matrixMaterialCard)
        
        matrixMaterialTypeSegementedControl.translatesAutoresizingMaskIntoConstraints = false
        matrixMaterialTypeSegementedControl.addTarget(self, action: #selector(changeMatrixMaterialType), for: .valueChanged)
        matrixMaterialTypeSegementedControl.widthAnchor.constraint(equalTo: matrixMaterialView.widthAnchor, multiplier: 0.8).isActive = true
        matrixMaterialTypeSegementedControl.topAnchor.constraint(equalTo: matrixMaterialDataBase.bottomAnchor, constant: 8).isActive = true
        matrixMaterialTypeSegementedControl.centerXAnchor.constraint(equalTo: matrixMaterialView.centerXAnchor).isActive = true
        
        matrixMaterialNameLabel.text = "Epoxy"
        createMaterialCard(materialCard: &matrixMaterialCard, materialName: matrixMaterialNameLabel, label: &matrixMaterialPropertiesLabel, value: &matrixMaterialPropertiesTextField, aboveConstraint: matrixMaterialTypeSegementedControl.bottomAnchor, under: matrixMaterialView, typeOfAnalysis: analysisSettings.typeOfAnalysis, materialType: .isotropic)
        
        matrixMaterialCard.bottomAnchor.constraint(equalTo: matrixMaterialView.bottomAnchor, constant: -12).isActive = true
        
        matrixMaterialView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -40).isActive = true
        
        changeMaterialDataField()
    }
    
    
    // MARK: question button section
    
    // method section
    
    override func methodQuestionExplain(_ sender: UIButton) {
        sender.flash()
        
        let explainDetialView : UIView = UIView()
        explainDetialView.explainDetialViewPureTextDesign(pureText: ExplainModel().methodExplain + "\n\n" + ExplainModel().UDFRCMethodExplain)
        
        methodExplain.showExplain(boxHeight: 300, title: "Method", explainDetailView: explainDetialView)
    }
    
    
    // Structural Model
    
    override func structuralModelQuestionExplain(_ sender: UIButton) {
        sender.flash()
        
        let explainDetialView : UIView = UIView()
        explainDetialView.explainDetialViewPureTextDesign(pureText: ExplainModel().structureModel + "\n\n" + ExplainModel().UDFRCStructureModel)
        
        structuralModelExplain.showExplain(boxHeight: 300, title: "Structural Model", explainDetailView: explainDetialView)
        
    }
    
    // type of analysis
    
    override func changeTypeOfAnalysisLabel(_ sender: UIButton) {
        sender.flash()
        if analysisSettings.structuralModel != .beam {
            self.present(typeOfAnalysisDataBaseAlterController, animated: true, completion: nil)
        } else {
            self.present(typeOfAnalysisDataBaseAlterControllerBeam, animated: true, completion: nil)
        }
    }
    
    let geometryExplain = ExplainBoxDesign()
    @objc func geometryQuestionExplain(_ sender: UIButton, event: UIEvent) {
        sender.flash()
        
        let explainDetialView : UIView = UIView()
        explainDetialView.explainDetialViewPureTextDesign(pureText: ExplainModel().UDFRCGeometryExplain)
        
        geometryExplain.showExplain(boxHeight: 300, title: "Geometry", explainDetailView: explainDetialView)
    }
    
    let fiberMaterialExplain = ExplainBoxDesign()
    @objc func fiberMaterialQuestionExplain(_ sender: UIButton, event: UIEvent) {
        sender.flash()
        
        let explainDetialView : UIView = UIView()
        explainDetialView.explainDetialViewPureTextDesign(pureText: ExplainModel().UDFRCFiberMaterialExplain + "\n\n" + ExplainModel().materialExplain)
        
        fiberMaterialExplain.showExplain(boxHeight: 400, title: "Fiber Material", explainDetailView: explainDetialView)
    }
    
    
    let matrixMaterialExplain = ExplainBoxDesign()
    @objc func matrixMaterialQuestionExplain(_ sender: UIButton, event: UIEvent) {
        sender.flash()
        
        let explainDetialView : UIView = UIView()
        explainDetialView.explainDetialViewPureTextDesign(pureText: ExplainModel().UDFRCMatrixMaterialExplain + "\n\n" + ExplainModel().materialExplain)
        
        matrixMaterialExplain.showExplain(boxHeight: 400, title: "Matrix Material", explainDetailView: explainDetialView)
    }
    
    
    
    @objc func changeVolumeFraction(_ sender: UISlider) {
        geometryLabel.text = "Fiber Volume Fraction: " + String(format: "%.2f", sender.value)
        
        if Double(sender.value) < 0.7800 {
            fiberPositionOffset = CGFloat(50-sqrt(10000*Double(sender.value)/Double.pi))
            fiberGeometryPath = UIBezierPath(ovalIn: CGRect(x:  geometrySquare.frame.minX + fiberPositionOffset, y:  geometrySquare.frame.minY + fiberPositionOffset, width: CGFloat(2*sqrt(10000*Double(sender.value)/Double.pi)), height: CGFloat(2*sqrt(10000*Double(sender.value)/Double.pi))))
        } else {
            fiberPositionOffset = CGFloat(50-100*Double(sender.value)/2)
            fiberGeometryPath = UIBezierPath(rect: CGRect(x: geometrySquare.frame.minX + fiberPositionOffset, y:  geometrySquare.frame.minY + fiberPositionOffset, width: CGFloat(100*Double(sender.value)), height: CGFloat(100*Double(sender.value))))
        }
        fiberGeometry.path = fiberGeometryPath.cgPath
        
    }
    
    
    @objc func enterFiberMaterialDataBase(_ sender: UIButton, event: UIEvent) {
        sender.flash()
        
        UDFRCFiberMaterialDataBaseViewController = FiberMaterialDataBase()
        
        UDFRCFiberMaterialDataBaseViewController.delegate = self
        
        let navController = UINavigationController(rootViewController: UDFRCFiberMaterialDataBaseViewController)
        
        self.present(navController, animated: true, completion: nil)
        
    }
    
    func userTypeFiberMaterialDataBase(materialName: String) {
        self.fiberMaterialNameLabel.text = materialName
        determineFiberMaterialType()
        changeFiberMaterialType()
        changeMaterialDataField()
    }
    
    func determineFiberMaterialType() {
        let allMaterials = MaterialBank()
        
        let materialCurrectName = fiberMaterialNameLabel.text!
        
        for material in allMaterials.list {
            
            if materialCurrectName == material.materialName {
                fiberMaterialType = material.materialType
            }
        }
        
        for userSaveMaterial in userSavedFiberMaterials {
            if materialCurrectName == userSaveMaterial.name {
                switch userSaveMaterial.type {
                case "Isotropic", "isotropic":
                    fiberMaterialType = .isotropic
                    break
                case "Transversely Isotropic", "Transversely isotropic":
                    fiberMaterialType = .transverselyIsotropic
                    break
                case "Orthotropic", "orthotropic":
                    fiberMaterialType = .orthotropic
                    break
                default:
                    fiberMaterialType = .isotropic
                    break
                }
            }
        }
        
        switch fiberMaterialType {
        case .isotropic:
            fiberMaterialTypeSegementedControl.selectedSegmentIndex = 0
        case .transverselyIsotropic:
            fiberMaterialTypeSegementedControl.selectedSegmentIndex = 1
        case .orthotropic:
            fiberMaterialTypeSegementedControl.selectedSegmentIndex = 2
        default:
            break
        }
    }
    
    @objc func changeFiberMaterialType() {
        switch fiberMaterialTypeSegementedControl.selectedSegmentIndex {
        case 0:
            fiberMaterialType = .isotropic
        case 1:
            fiberMaterialType = .transverselyIsotropic
        case 2:
            fiberMaterialType = .orthotropic
        default:
            fiberMaterialType = .isotropic
        }
        
        createMaterialCard(materialCard: &self.fiberMaterialCard, materialName: self.fiberMaterialNameLabel, label: &self.fiberMaterialPropertiesLabel, value: &self.fiberMaterialPropertiesTextField, aboveConstraint: self.fiberMaterialTypeSegementedControl.bottomAnchor, under: self.fiberMaterialView, typeOfAnalysis: analysisSettings.typeOfAnalysis, materialType: fiberMaterialType)
        
        self.fiberMaterialCard.bottomAnchor.constraint(equalTo: self.fiberMaterialView.bottomAnchor, constant: -12).isActive = true
        
        self.changeMaterialDataField()
        
    }
    
    @objc func saveFiberMaterial(_ sender: UIButton) {
        
        sender.flash()
        
        let inputAlter = UIAlertController(title: "Save Fiber Material", message: "Enter the material name.", preferredStyle: UIAlertController.Style.alert)
        inputAlter.addTextField { (textField: UITextField) in
            textField.placeholder = "Material Name"
        }
        inputAlter.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        inputAlter.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action:UIAlertAction) in
            
            let materialNameTextField = inputAlter.textFields?.first
            
            // check empty name
            
            let emptyNameAlter = UIAlertController(title: "Empty Name", message: "Please enter a name for this material.", preferredStyle: UIAlertController.Style.alert)
            emptyNameAlter.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            var userMaterialName : String = ""
            
            if materialNameTextField?.text != "" {
                userMaterialName = (materialNameTextField?.text)!
            }
            else {
                self.present(emptyNameAlter, animated: true, completion: nil)
                return
            }
            
            // check wrong or empty material value
            
            var userFiberMaterialDictionary : [String: Double] = [:]
            var userFiberMaterialType : String = ""
            
            let wrongMaterialValueAlter = UIAlertController(title: "Wrong Material Values", message: "Please enter valid values (number) for this material.", preferredStyle: UIAlertController.Style.alert)
            wrongMaterialValueAlter.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            let emptyMaterialValueAlter = UIAlertController(title: "Empty Material Value", message: "Please enter values (number) for this material.", preferredStyle: UIAlertController.Style.alert)
            emptyMaterialValueAlter.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            if self.fiberMaterialType == .isotropic {
                userFiberMaterialType = "Isotropic"
                for i in 0...materialPropertyName.isotropic.count - 1 {
                    if let valueString = self.fiberMaterialPropertiesTextField[i].text {
                        if let value = Double(valueString) {
                            userFiberMaterialDictionary[materialPropertyName.isotropic[i]] = value
                        } else {
                            self.present(wrongMaterialValueAlter, animated: true, completion: nil)
                            return
                        }
                    } else {
                        self.present(emptyMaterialValueAlter, animated: true, completion: nil)
                        return
                    }
                }
                if self.analysisSettings.typeOfAnalysis == .thermoElastic {
                    for i in 0...materialPropertyName.isotropicThermal.count - 1 {
                        if let valueString = self.fiberMaterialPropertiesTextField[i + materialPropertyName.isotropic.count].text {
                            if let value = Double(valueString) {
                                userFiberMaterialDictionary[materialPropertyName.isotropicThermal[i]] = value
                            } else {
                                self.present(wrongMaterialValueAlter, animated: true, completion: nil)
                                return
                            }
                        } else {
                            self.present(emptyMaterialValueAlter, animated: true, completion: nil)
                            return
                        }
                    }
                }
            } else if self.fiberMaterialType == .transverselyIsotropic {
                userFiberMaterialType = "Transversely Isotropic"
                for i in 0...materialPropertyName.transverselyIsotropic.count - 1 {
                    if let valueString = self.fiberMaterialPropertiesTextField[i].text {
                        if let value = Double(valueString) {
                            userFiberMaterialDictionary[materialPropertyName.transverselyIsotropic[i]] = value
                        } else {
                            self.present(wrongMaterialValueAlter, animated: true, completion: nil)
                            return
                        }
                    } else {
                        self.present(emptyMaterialValueAlter, animated: true, completion: nil)
                        return
                    }
                }
                if self.analysisSettings.typeOfAnalysis == .thermoElastic {
                    for i in 0...materialPropertyName.transverselyIsotropicThermal.count - 1 {
                        if let valueString = self.fiberMaterialPropertiesTextField[i + materialPropertyName.transverselyIsotropic.count].text {
                            if let value = Double(valueString) {
                                userFiberMaterialDictionary[materialPropertyName.transverselyIsotropicThermal[i]] = value
                            } else {
                                self.present(wrongMaterialValueAlter, animated: true, completion: nil)
                                return
                            }
                        } else {
                            self.present(emptyMaterialValueAlter, animated: true, completion: nil)
                            return
                        }
                    }
                }
            } else if self.fiberMaterialType == .orthotropic {
                userFiberMaterialType = "Orthotropic"
                for i in 0...materialPropertyName.orthotropic.count - 1 {
                    if let valueString = self.fiberMaterialPropertiesTextField[i].text {
                        if let value = Double(valueString) {
                            userFiberMaterialDictionary[materialPropertyName.orthotropic[i]] = value
                        } else {
                            self.present(wrongMaterialValueAlter, animated: true, completion: nil)
                            return
                        }
                    } else {
                        self.present(emptyMaterialValueAlter, animated: true, completion: nil)
                        return
                    }
                }
                if self.analysisSettings.typeOfAnalysis == .thermoElastic {
                    for i in 0...materialPropertyName.orthotropicThermal.count - 1 {
                        if let valueString = self.fiberMaterialPropertiesTextField[i + materialPropertyName.orthotropic.count].text {
                            if let value = Double(valueString) {
                                userFiberMaterialDictionary[materialPropertyName.orthotropicThermal[i]] = value
                            } else {
                                self.present(wrongMaterialValueAlter, animated: true, completion: nil)
                                return
                            }
                        } else {
                            self.present(emptyMaterialValueAlter, animated: true, completion: nil)
                            return
                        }
                    }
                }
            }
            
            // check same material name
            
            let sameMaterialNameAlter = UIAlertController(title: "Same Material Name", message: "Please enter a differet material name.", preferredStyle: UIAlertController.Style.alert)
            sameMaterialNameAlter.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            for name in ["Empty Material", "E-Glass", "S-Glass", "Carbon (IM)", "Carbon (HM)", "Boron", "Kelvar-49"] {
                if userMaterialName == name {
                    self.present(sameMaterialNameAlter, animated: true, completion: nil)
                    return
                }
            }
            
            for userSavedFiberMaterial in self.userSavedFiberMaterials {
                if let name = userSavedFiberMaterial.name {
                    if userMaterialName == name {
                        self.present(sameMaterialNameAlter, animated: true, completion: nil)
                        return
                    }
                }
            }
            
            let currentUserFiberMaterial = UserFiberMaterial(context: context)
            currentUserFiberMaterial.setValue(userMaterialName, forKey: "name")
            currentUserFiberMaterial.setValue(userFiberMaterialType, forKey: "type")
            currentUserFiberMaterial.setValue(userFiberMaterialDictionary, forKey: "properties")
            
            do {
                try context.save()
                self.loadCoreData()
                
                // material card saving animation
                
                let MaterialCardImage: UIImage = UIImage(named: "user_defined_material_card")!
                let MaterialCardImageView: UIImageView = UIImageView(image: MaterialCardImage)
                
                self.fiberMaterialView.addSubview(MaterialCardImageView)
                
                MaterialCardImageView.frame.origin.x = self.fiberMaterialCard.frame.origin.x + self.fiberMaterialCard.frame.width / 2 - MaterialCardImageView.frame.width / 2
                MaterialCardImageView.frame.origin.y = self.fiberMaterialCard.frame.origin.y + self.fiberMaterialCard.frame.height / 2
                
                UIView.animate(withDuration: 0.8, animations: {
                    MaterialCardImageView.frame.origin.x = self.fiberMaterialDataBase.frame.origin.x + self.fiberMaterialDataBase.frame.width / 2 - MaterialCardImageView.frame.width / 2
                    MaterialCardImageView.frame.origin.y = self.fiberMaterialDataBase.frame.origin.y + self.fiberMaterialDataBase.frame.height / 2
                }, completion: { (true) in
                    UIView.animate(withDuration: 0.2, animations: {
                        MaterialCardImageView.removeFromSuperview()
                    })
                })
                
            } catch {
                print("Could not save data: \(error.localizedDescription)")
            }
            
        }))
        
        self.present(inputAlter, animated: true, completion: nil)
        
    }
    
    
    @objc func enterMatrixMaterialDataBase(_ sender: UIButton, event: UIEvent) {
        sender.flash()
        
        UDFRCMatrixMaterialDataBaseViewController = MatrixMaterialDataBase()
        
        UDFRCMatrixMaterialDataBaseViewController.delegate = self
        
        let navController = UINavigationController(rootViewController: UDFRCMatrixMaterialDataBaseViewController)
        
        self.present(navController, animated: true, completion: nil)

    }
    
    
    func userTypeMatrixMaterialDataBase(materialName: String) {
        self.matrixMaterialNameLabel.text = materialName
        determineMatrixMaterialType()
        changeMatrixMaterialType()
        changeMaterialDataField()
    }
    
    func determineMatrixMaterialType() {
        let allMaterials = MaterialBank()
        
        let materialCurrectName = matrixMaterialNameLabel.text!
        
        for material in allMaterials.list {
            
            if materialCurrectName == material.materialName {
                matrixMaterialType = material.materialType
            }
        }
        
        for userSaveMaterial in userSavedMatrixMaterials {
            if materialCurrectName == userSaveMaterial.name {
                switch userSaveMaterial.type {
                case "Isotropic", "isotropic":
                    matrixMaterialType = .isotropic
                    break
                case "Transversely Isotropic", "Transversely isotropic":
                    matrixMaterialType = .transverselyIsotropic
                    break
                case "Orthotropic", "orthotropic":
                    matrixMaterialType = .orthotropic
                    break
                default:
                    matrixMaterialType = .isotropic
                    break
                }
            }
        }
        
        switch matrixMaterialType {
        case .isotropic:
            matrixMaterialTypeSegementedControl.selectedSegmentIndex = 0
        case .transverselyIsotropic:
            matrixMaterialTypeSegementedControl.selectedSegmentIndex = 1
        case .orthotropic:
            matrixMaterialTypeSegementedControl.selectedSegmentIndex = 2
        default:
            break
        }
    }
    
    @objc func changeMatrixMaterialType() {
        switch matrixMaterialTypeSegementedControl.selectedSegmentIndex {
        case 0:
            matrixMaterialType = .isotropic
        case 1:
            matrixMaterialType = .transverselyIsotropic
        case 2:
            matrixMaterialType = .orthotropic
        default:
            matrixMaterialType = .transverselyIsotropic
        }
        
        createMaterialCard(materialCard: &self.matrixMaterialCard, materialName: self.matrixMaterialNameLabel, label: &self.matrixMaterialPropertiesLabel, value: &self.matrixMaterialPropertiesTextField, aboveConstraint: self.matrixMaterialTypeSegementedControl.bottomAnchor, under: self.matrixMaterialView, typeOfAnalysis: analysisSettings.typeOfAnalysis, materialType: matrixMaterialType)
        
        self.matrixMaterialCard.bottomAnchor.constraint(equalTo: self.matrixMaterialView.bottomAnchor, constant: -12).isActive = true
        
        self.changeMaterialDataField()
        
    }
    
    
    @objc func saveMatrixMaterial(_ sender: UIButton) {
        sender.flash()
        
        let inputAlter = UIAlertController(title: "Save Matrix Material", message: "Enter the material name.", preferredStyle: UIAlertController.Style.alert)
        inputAlter.addTextField { (textField: UITextField) in
            textField.placeholder = "Material Name"
        }
        inputAlter.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        inputAlter.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action:UIAlertAction) in
            
            let materialNameTextField = inputAlter.textFields?.first
            
            // check empty name
            
            let emptyNameAlter = UIAlertController(title: "Empty Name", message: "Please enter a name for this material.", preferredStyle: UIAlertController.Style.alert)
            emptyNameAlter.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            var userMaterialName : String = ""
            
            if materialNameTextField?.text != "" {
                userMaterialName = (materialNameTextField?.text)!
            }
            else {
                self.present(emptyNameAlter, animated: true, completion: nil)
                return
            }
            
            // check wrong or empty material valuw
            
            var userMatrixMaterialDictionary : [String: Double] = [:]
            var userMatrixMaterialType : String = ""
            
            let wrongMaterialValueAlter = UIAlertController(title: "Wrong Material Values", message: "Please enter valid values (number) for this material.", preferredStyle: UIAlertController.Style.alert)
            wrongMaterialValueAlter.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            let emptyMaterialValueAlter = UIAlertController(title: "Empty Material Value", message: "Please enter values (number) for this material.", preferredStyle: UIAlertController.Style.alert)
            emptyMaterialValueAlter.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            if self.matrixMaterialType == .isotropic {
                userMatrixMaterialType = "Isotropic"
                for i in 0...materialPropertyName.isotropic.count - 1 {
                    if let valueString = self.matrixMaterialPropertiesTextField[i].text {
                        if let value = Double(valueString) {
                            userMatrixMaterialDictionary[materialPropertyName.isotropic[i]] = value
                        } else {
                            self.present(wrongMaterialValueAlter, animated: true, completion: nil)
                            return
                        }
                    } else {
                        self.present(emptyMaterialValueAlter, animated: true, completion: nil)
                        return
                    }
                }
                if self.analysisSettings.typeOfAnalysis == .thermoElastic {
                    for i in 0...materialPropertyName.isotropicThermal.count - 1 {
                        if let valueString = self.matrixMaterialPropertiesTextField[i + materialPropertyName.isotropic.count].text {
                            if let value = Double(valueString) {
                                userMatrixMaterialDictionary[materialPropertyName.isotropicThermal[i]] = value
                            } else {
                                self.present(wrongMaterialValueAlter, animated: true, completion: nil)
                                return
                            }
                        } else {
                            self.present(emptyMaterialValueAlter, animated: true, completion: nil)
                            return
                        }
                    }
                }
            } else if self.matrixMaterialType == .transverselyIsotropic {
                userMatrixMaterialType = "Transversely Isotropic"
                for i in 0...materialPropertyName.transverselyIsotropic.count - 1 {
                    if let valueString = self.matrixMaterialPropertiesTextField[i].text {
                        if let value = Double(valueString) {
                            userMatrixMaterialDictionary[materialPropertyName.transverselyIsotropic[i]] = value
                        } else {
                            self.present(wrongMaterialValueAlter, animated: true, completion: nil)
                            return
                        }
                    } else {
                        self.present(emptyMaterialValueAlter, animated: true, completion: nil)
                        return
                    }
                }
                if self.analysisSettings.typeOfAnalysis == .thermoElastic {
                    for i in 0...materialPropertyName.transverselyIsotropicThermal.count - 1 {
                        if let valueString = self.matrixMaterialPropertiesTextField[i + materialPropertyName.transverselyIsotropic.count].text {
                            if let value = Double(valueString) {
                                userMatrixMaterialDictionary[materialPropertyName.transverselyIsotropicThermal[i]] = value
                            } else {
                                self.present(wrongMaterialValueAlter, animated: true, completion: nil)
                                return
                            }
                        } else {
                            self.present(emptyMaterialValueAlter, animated: true, completion: nil)
                            return
                        }
                    }
                }
            } else if self.matrixMaterialType == .orthotropic {
                userMatrixMaterialType = "Orthotropic"
                for i in 0...materialPropertyName.orthotropic.count - 1 {
                    if let valueString = self.matrixMaterialPropertiesTextField[i].text {
                        if let value = Double(valueString) {
                            userMatrixMaterialDictionary[materialPropertyName.orthotropic[i]] = value
                        } else {
                            self.present(wrongMaterialValueAlter, animated: true, completion: nil)
                            return
                        }
                    } else {
                        self.present(emptyMaterialValueAlter, animated: true, completion: nil)
                        return
                    }
                }
                if self.analysisSettings.typeOfAnalysis == .thermoElastic {
                    for i in 0...materialPropertyName.orthotropicThermal.count - 1 {
                        if let valueString = self.matrixMaterialPropertiesTextField[i + materialPropertyName.orthotropic.count].text {
                            if let value = Double(valueString) {
                                userMatrixMaterialDictionary[materialPropertyName.orthotropicThermal[i]] = value
                            } else {
                                self.present(wrongMaterialValueAlter, animated: true, completion: nil)
                                return
                            }
                        } else {
                            self.present(emptyMaterialValueAlter, animated: true, completion: nil)
                            return
                        }
                    }
                }
            }
            
            // check same material name
            
            let sameMaterialNameAlter = UIAlertController(title: "Same Material Name", message: "Please enter a differet material name.", preferredStyle: UIAlertController.Style.alert)
            sameMaterialNameAlter.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            for name in ["Empty Material", "Epoxy", "Polyester", "Polyimide", "PEEK", "Copper", "Silicon Carbide"] {
                if userMaterialName == name {
                    self.present(sameMaterialNameAlter, animated: true, completion: nil)
                    return
                }
            }
            
            for userSavedMatrixMaterial in self.userSavedMatrixMaterials {
                if let name = userSavedMatrixMaterial.name {
                    if userMaterialName == name {
                        self.present(sameMaterialNameAlter, animated: true, completion: nil)
                        return
                    }
                }
            }
            
            let currentUserMatrixMaterial = UserMatrixMaterial(context: context)
            currentUserMatrixMaterial.setValue(userMaterialName, forKey: "name")
            currentUserMatrixMaterial.setValue(userMatrixMaterialType, forKey: "type")
            currentUserMatrixMaterial.setValue(userMatrixMaterialDictionary, forKey: "properties")
            
            do {
                try context.save()
                self.loadCoreData()
                
                // material card saving animation
                
                let MaterialCardImage: UIImage = UIImage(named: "user_defined_material_card")!
                let MaterialCardImageView: UIImageView = UIImageView(image: MaterialCardImage)
                
                self.matrixMaterialView.addSubview(MaterialCardImageView)
                
                MaterialCardImageView.frame.origin.x = self.matrixMaterialCard.frame.origin.x + self.matrixMaterialCard.frame.width / 2 - MaterialCardImageView.frame.width / 2
                MaterialCardImageView.frame.origin.y = self.matrixMaterialCard.frame.origin.y + self.matrixMaterialCard.frame.height / 2
                
                UIView.animate(withDuration: 0.8, animations: {
                    MaterialCardImageView.frame.origin.x = self.matrixMaterialDataBase.frame.origin.x + self.matrixMaterialDataBase.frame.width / 2 - MaterialCardImageView.frame.width / 2
                    MaterialCardImageView.frame.origin.y = self.matrixMaterialDataBase.frame.origin.y + self.matrixMaterialDataBase.frame.height / 2
                }, completion: { (true) in
                    UIView.animate(withDuration: 0.2, animations: {
                        MaterialCardImageView.removeFromSuperview()
                    })
                })
                
            } catch {
                print("Could not save data: \(error.localizedDescription)")
            }
            
        }))
        
        self.present(inputAlter, animated: true, completion: nil)
        
    }
    
    
    // change material data fields
    
    func changeMaterialDataField() {
        let allMaterials = MaterialBank()
        
        // change fiber material card
        
        let fiberMaterialCurrectName = fiberMaterialNameLabel.text!
        
        for material in allMaterials.list {
            
            if fiberMaterialCurrectName == material.materialName {
                if fiberMaterialType == .isotropic  {
                    for i in 0...materialPropertyName.isotropic.count - 1 {
                        if let property = material.materialProperties[materialPropertyName.isotropic[i]] {
                            fiberMaterialPropertiesTextField[i].text = String(format: "%.2f", property)
                        } else {
                            fiberMaterialPropertiesTextField[i].text = ""
                        }
                    }
                    if analysisSettings.typeOfAnalysis == .thermoElastic {
                        for i in 0...materialPropertyName.isotropicThermal.count - 1 {
                            if let property = material.materialProperties[materialPropertyName.isotropicThermal[i]] {
                                fiberMaterialPropertiesTextField[i+materialPropertyName.isotropic.count].text = String(format: "%.2f", property)
                            } else {
                                fiberMaterialPropertiesTextField[i+materialPropertyName.isotropic.count].text = ""
                            }
                        }
                    }
                } else if fiberMaterialType == .transverselyIsotropic {
                    for i in 0...materialPropertyName.transverselyIsotropic.count - 1 {
                        if let property = material.materialProperties[materialPropertyName.transverselyIsotropic[i]] {
                            fiberMaterialPropertiesTextField[i].text = String(format: "%.2f", property)
                        } else {
                            fiberMaterialPropertiesTextField[i].text = ""
                        }
                    }
                    if analysisSettings.typeOfAnalysis == .thermoElastic {
                        for i in 0...materialPropertyName.transverselyIsotropicThermal.count - 1 {
                            if let property = material.materialProperties[materialPropertyName.transverselyIsotropicThermal[i]] {
                                fiberMaterialPropertiesTextField[i+materialPropertyName.transverselyIsotropic.count].text = String(format: "%.2f", property)
                            } else {
                                fiberMaterialPropertiesTextField[i+materialPropertyName.transverselyIsotropic.count].text = ""
                            }
                        }
                    }
                } else if fiberMaterialType == .orthotropic {
                    for i in 0...materialPropertyName.orthotropic.count - 1 {
                        if let property = material.materialProperties[materialPropertyName.orthotropic[i]] {
                            fiberMaterialPropertiesTextField[i].text = String(format: "%.2f", property)
                        } else {
                            fiberMaterialPropertiesTextField[i].text = ""
                        }
                    }
                    if analysisSettings.typeOfAnalysis == .thermoElastic {
                        for i in 0...materialPropertyName.orthotropicThermal.count - 1 {
                            if let property = material.materialProperties[materialPropertyName.orthotropicThermal[i]] {
                                fiberMaterialPropertiesTextField[i+materialPropertyName.orthotropic.count].text = String(format: "%.2f", property)
                            } else {
                                fiberMaterialPropertiesTextField[i+materialPropertyName.orthotropic.count].text = ""
                            }
                        }
                    }
                }
            } else if fiberMaterialCurrectName == "Empty Material" {
                if fiberMaterialType == .isotropic {
                    for i in 0...materialPropertyName.isotropic.count - 1 {
                        fiberMaterialPropertiesTextField[i].text = ""
                    }
                    if analysisSettings.typeOfAnalysis == .thermoElastic {
                        for i in 0...materialPropertyName.isotropicThermal.count - 1 {
                            fiberMaterialPropertiesTextField[i+materialPropertyName.isotropic.count].text = ""
                        }
                    }
                } else if fiberMaterialType == .transverselyIsotropic {
                    for i in 0...materialPropertyName.transverselyIsotropic.count - 1 {
                        fiberMaterialPropertiesTextField[i].text = ""
                    }
                    if analysisSettings.typeOfAnalysis == .thermoElastic {
                        for i in 0...materialPropertyName.transverselyIsotropicThermal.count - 1 {
                            fiberMaterialPropertiesTextField[i+materialPropertyName.transverselyIsotropic.count].text = ""
                        }
                    }
                } else if fiberMaterialType == .orthotropic {
                    for i in 0...materialPropertyName.orthotropic.count - 1 {
                        fiberMaterialPropertiesTextField[i].text = ""
                    }
                    if analysisSettings.typeOfAnalysis == .thermoElastic {
                        for i in 0...materialPropertyName.orthotropicThermal.count - 1 {
                            fiberMaterialPropertiesTextField[i+materialPropertyName.orthotropic.count].text = ""
                        }
                    }
                }
            }
        }
        
        for userSaveMaterial in userSavedFiberMaterials {
            if fiberMaterialCurrectName == userSaveMaterial.name {
                if fiberMaterialType == .isotropic {
                    for i in 0...materialPropertyName.isotropic.count - 1 {
                        if let valueDictionary = userSaveMaterial.properties as? [String: Double] {
                            if let value = valueDictionary[materialPropertyName.isotropic[i]] {
                                fiberMaterialPropertiesTextField[i].text = String(format: "%.2f", value)
                            } else {
                                fiberMaterialPropertiesTextField[i].text = ""
                            }
                        } else {
                            fiberMaterialPropertiesTextField[i].text = ""
                        }
                    }
                    if analysisSettings.typeOfAnalysis == .thermoElastic {
                        for i in 0...materialPropertyName.isotropicThermal.count - 1 {
                            if let valueDictionary = userSaveMaterial.properties as? [String: Double] {
                                if let value = valueDictionary[materialPropertyName.isotropicThermal[i]] {
                                    fiberMaterialPropertiesTextField[i+materialPropertyName.isotropic.count].text = String(format: "%.2f", value)
                                } else {
                                    fiberMaterialPropertiesTextField[i+materialPropertyName.isotropic.count].text = ""
                                }
                            } else {
                                fiberMaterialPropertiesTextField[i+materialPropertyName.isotropic.count].text = ""
                            }
                        }
                    }
                } else if fiberMaterialType == .transverselyIsotropic {
                    for i in 0...materialPropertyName.transverselyIsotropic.count - 1 {
                        if let valueDictionary = userSaveMaterial.properties as? [String: Double] {
                            if let value = valueDictionary[materialPropertyName.transverselyIsotropic[i]] {
                                fiberMaterialPropertiesTextField[i].text = String(format: "%.2f", value)
                            } else {
                                fiberMaterialPropertiesTextField[i].text = ""
                            }
                        } else {
                            fiberMaterialPropertiesTextField[i].text = ""
                        }
                    }
                    if analysisSettings.typeOfAnalysis == .thermoElastic {
                        for i in 0...materialPropertyName.transverselyIsotropicThermal.count - 1 {
                            if let valueDictionary = userSaveMaterial.properties as? [String: Double] {
                                if let value = valueDictionary[materialPropertyName.transverselyIsotropicThermal[i]] {
                                    fiberMaterialPropertiesTextField[i+materialPropertyName.transverselyIsotropic.count].text = String(format: "%.2f", value)
                                } else {
                                    fiberMaterialPropertiesTextField[i+materialPropertyName.transverselyIsotropic.count].text = ""
                                }
                            } else {
                                fiberMaterialPropertiesTextField[i+materialPropertyName.transverselyIsotropic.count].text = ""
                            }
                        }
                    }
                } else if fiberMaterialType == .orthotropic {
                    for i in 0...materialPropertyName.orthotropic.count - 1 {
                        if let valueDictionary = userSaveMaterial.properties as? [String: Double] {
                            if let value = valueDictionary[materialPropertyName.orthotropic[i]] {
                                fiberMaterialPropertiesTextField[i].text = String(format: "%.2f", value)
                            } else {
                                fiberMaterialPropertiesTextField[i].text = ""
                            }
                        } else {
                            fiberMaterialPropertiesTextField[i].text = ""
                        }
                    }
                    if analysisSettings.typeOfAnalysis == .thermoElastic {
                        for i in 0...materialPropertyName.orthotropicThermal.count - 1 {
                            if let valueDictionary = userSaveMaterial.properties as? [String: Double] {
                                if let value = valueDictionary[materialPropertyName.orthotropicThermal[i]] {
                                    fiberMaterialPropertiesTextField[i+materialPropertyName.orthotropic.count].text = String(format: "%.2f", value)
                                } else {
                                    fiberMaterialPropertiesTextField[i+materialPropertyName.orthotropic.count].text = ""
                                }
                            } else {
                                fiberMaterialPropertiesTextField[i+materialPropertyName.orthotropic.count].text = ""
                            }
                        }
                    }
                }
            }
        }
        
        // change matrix material card
        
        let matrixMaterialCurrectName = matrixMaterialNameLabel.text!
        
        for material in allMaterials.list {
            
            if matrixMaterialCurrectName == material.materialName {
                if matrixMaterialType == .isotropic  {
                    for i in 0...materialPropertyName.isotropic.count - 1 {
                        if let property = material.materialProperties[materialPropertyName.isotropic[i]] {
                            matrixMaterialPropertiesTextField[i].text = String(format: "%.2f", property)
                        } else {
                            matrixMaterialPropertiesTextField[i].text = ""
                        }
                    }
                    if analysisSettings.typeOfAnalysis == .thermoElastic {
                        for i in 0...materialPropertyName.isotropicThermal.count - 1 {
                            if let property = material.materialProperties[materialPropertyName.isotropicThermal[i]] {
                                matrixMaterialPropertiesTextField[i+materialPropertyName.isotropic.count].text = String(format: "%.2f", property)
                            } else {
                                matrixMaterialPropertiesTextField[i+materialPropertyName.isotropic.count].text = ""
                            }
                        }
                    }
                } else if matrixMaterialType == .transverselyIsotropic {
                    for i in 0...materialPropertyName.transverselyIsotropic.count - 1 {
                        if let property = material.materialProperties[materialPropertyName.transverselyIsotropic[i]] {
                            matrixMaterialPropertiesTextField[i].text = String(format: "%.2f", property)
                        } else {
                            matrixMaterialPropertiesTextField[i].text = ""
                        }
                    }
                    if analysisSettings.typeOfAnalysis == .thermoElastic {
                        for i in 0...materialPropertyName.transverselyIsotropicThermal.count - 1 {
                            if let property = material.materialProperties[materialPropertyName.transverselyIsotropicThermal[i]] {
                                matrixMaterialPropertiesTextField[i+materialPropertyName.transverselyIsotropic.count].text = String(format: "%.2f", property)
                            } else {
                                matrixMaterialPropertiesTextField[i+materialPropertyName.transverselyIsotropic.count].text = ""
                            }
                        }
                    }
                } else if matrixMaterialType == .orthotropic {
                    for i in 0...materialPropertyName.orthotropic.count - 1 {
                        if let property = material.materialProperties[materialPropertyName.orthotropic[i]] {
                            matrixMaterialPropertiesTextField[i].text = String(format: "%.2f", property)
                        } else {
                            matrixMaterialPropertiesTextField[i].text = ""
                        }
                    }
                    if analysisSettings.typeOfAnalysis == .thermoElastic {
                        for i in 0...materialPropertyName.orthotropicThermal.count - 1 {
                            if let property = material.materialProperties[materialPropertyName.orthotropicThermal[i]] {
                                matrixMaterialPropertiesTextField[i+materialPropertyName.orthotropic.count].text = String(format: "%.2f", property)
                            } else {
                                matrixMaterialPropertiesTextField[i+materialPropertyName.orthotropic.count].text = ""
                            }
                        }
                    }
                }
            } else if matrixMaterialCurrectName == "Empty Material" {
                if matrixMaterialType == .isotropic {
                    for i in 0...materialPropertyName.isotropic.count - 1 {
                        matrixMaterialPropertiesTextField[i].text = ""
                    }
                    if analysisSettings.typeOfAnalysis == .thermoElastic {
                        for i in 0...materialPropertyName.isotropicThermal.count - 1 {
                            matrixMaterialPropertiesTextField[i+materialPropertyName.isotropic.count].text = ""
                        }
                    }
                } else if matrixMaterialType == .transverselyIsotropic {
                    for i in 0...materialPropertyName.transverselyIsotropic.count - 1 {
                        matrixMaterialPropertiesTextField[i].text = ""
                    }
                    if analysisSettings.typeOfAnalysis == .thermoElastic {
                        for i in 0...materialPropertyName.transverselyIsotropicThermal.count - 1 {
                            matrixMaterialPropertiesTextField[i+materialPropertyName.transverselyIsotropic.count].text = ""
                        }
                    }
                } else if matrixMaterialType == .orthotropic {
                    for i in 0...materialPropertyName.orthotropic.count - 1 {
                        matrixMaterialPropertiesTextField[i].text = ""
                    }
                    if analysisSettings.typeOfAnalysis == .thermoElastic {
                        for i in 0...materialPropertyName.orthotropicThermal.count - 1 {
                            matrixMaterialPropertiesTextField[i+materialPropertyName.orthotropic.count].text = ""
                        }
                    }
                }
            }
        }
        
        for userSaveMaterial in userSavedMatrixMaterials {
            if matrixMaterialCurrectName == userSaveMaterial.name {
                if matrixMaterialType == .isotropic {
                    for i in 0...materialPropertyName.isotropic.count - 1 {
                        if let valueDictionary = userSaveMaterial.properties as? [String: Double] {
                            if let value = valueDictionary[materialPropertyName.isotropic[i]] {
                                matrixMaterialPropertiesTextField[i].text = String(format: "%.2f", value)
                            } else {
                                matrixMaterialPropertiesTextField[i].text = ""
                            }
                        } else {
                            matrixMaterialPropertiesTextField[i].text = ""
                        }
                    }
                    if analysisSettings.typeOfAnalysis == .thermoElastic {
                        for i in 0...materialPropertyName.isotropicThermal.count - 1 {
                            if let valueDictionary = userSaveMaterial.properties as? [String: Double] {
                                if let value = valueDictionary[materialPropertyName.isotropicThermal[i]] {
                                    matrixMaterialPropertiesTextField[i+materialPropertyName.isotropic.count].text = String(format: "%.2f", value)
                                } else {
                                    matrixMaterialPropertiesTextField[i+materialPropertyName.isotropic.count].text = ""
                                }
                            } else {
                                matrixMaterialPropertiesTextField[i+materialPropertyName.isotropic.count].text = ""
                            }
                        }
                    }
                } else if matrixMaterialType == .transverselyIsotropic {
                    for i in 0...materialPropertyName.transverselyIsotropic.count - 1 {
                        if let valueDictionary = userSaveMaterial.properties as? [String: Double] {
                            if let value = valueDictionary[materialPropertyName.transverselyIsotropic[i]] {
                                matrixMaterialPropertiesTextField[i].text = String(format: "%.2f", value)
                            } else {
                                matrixMaterialPropertiesTextField[i].text = ""
                            }
                        } else {
                            matrixMaterialPropertiesTextField[i].text = ""
                        }
                    }
                    if analysisSettings.typeOfAnalysis == .thermoElastic {
                        for i in 0...materialPropertyName.transverselyIsotropicThermal.count - 1 {
                            if let valueDictionary = userSaveMaterial.properties as? [String: Double] {
                                if let value = valueDictionary[materialPropertyName.transverselyIsotropicThermal[i]] {
                                    matrixMaterialPropertiesTextField[i+materialPropertyName.transverselyIsotropic.count].text = String(format: "%.2f", value)
                                } else {
                                    matrixMaterialPropertiesTextField[i+materialPropertyName.transverselyIsotropic.count].text = ""
                                }
                            } else {
                                matrixMaterialPropertiesTextField[i+materialPropertyName.transverselyIsotropic.count].text = ""
                            }
                        }
                    }
                } else if matrixMaterialType == .orthotropic {
                    for i in 0...materialPropertyName.orthotropic.count - 1 {
                        if let valueDictionary = userSaveMaterial.properties as? [String: Double] {
                            if let value = valueDictionary[materialPropertyName.orthotropic[i]] {
                                matrixMaterialPropertiesTextField[i].text = String(format: "%.2f", value)
                            } else {
                                matrixMaterialPropertiesTextField[i].text = ""
                            }
                        } else {
                            matrixMaterialPropertiesTextField[i].text = ""
                        }
                    }
                    if analysisSettings.typeOfAnalysis == .thermoElastic {
                        for i in 0...materialPropertyName.orthotropicThermal.count - 1 {
                            if let valueDictionary = userSaveMaterial.properties as? [String: Double] {
                                if let value = valueDictionary[materialPropertyName.orthotropicThermal[i]] {
                                    matrixMaterialPropertiesTextField[i+materialPropertyName.orthotropic.count].text = String(format: "%.2f", value)
                                } else {
                                    matrixMaterialPropertiesTextField[i+materialPropertyName.orthotropic.count].text = ""
                                }
                            } else {
                                matrixMaterialPropertiesTextField[i+materialPropertyName.orthotropic.count].text = ""
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    // MARK: Create action sheet
    
    override func createActionSheet() {
        super.createActionSheet()
        
        let m0 = UIAlertAction(title: "SwiftComp", style: UIAlertAction.Style.default) { [weak self] (action) -> Void in
            
            guard let self = self else {return}
            
            self.methodLabelButton.setTitle("SwiftComp", for: .normal)
            self.methodLabelButton.layoutIfNeeded()
            
            self.analysisSettings.calculationMethod = .SwiftComp
            self.editToolBar()
            
            if self.analysisSettings.structuralModel == .beam {
                
                if self.analysisSettings.structuralSubmodel != .EulerBernoulliBeamModel && self.analysisSettings.structuralSubmodel != .TimoshenkoBeamModel {
                    self.analysisSettings.structuralSubmodel = .EulerBernoulliBeamModel
                }
                
                self.plateSubmodelView.isHidden = true
                
                self.structuralModelView.constraints.filter({$0.firstAttribute == NSLayoutConstraint.Attribute.bottom}).forEach{ $0.isActive = false }
                self.structuralModelLabelButton.bottomAnchor.constraint(equalTo: self.structuralModelView.bottomAnchor, constant: -12).isActive = false
                self.plateInitialCurvaturesView.bottomAnchor.constraint(equalTo: self.structuralModelView.bottomAnchor, constant: -12).isActive = false
                self.beamObliqueCrossSectionView.bottomAnchor.constraint(equalTo: self.structuralModelView.bottomAnchor, constant: -12).isActive = true
                self.structuralModelView.constraints.filter({$0.firstAttribute == NSLayoutConstraint.Attribute.bottom}).forEach{ $0.isActive = true }
                
                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.view.layoutIfNeeded()
                }, completion: { (true) in
                    self.beamSubmodelView.isHidden = false
                    self.beamInitialTwistCurvaturesView.isHidden = false
                    self.beamObliqueCrossSectionView.isHidden = false
                })
                
            } else if self.analysisSettings.structuralModel == .plate {
                
                if self.analysisSettings.structuralSubmodel != .KirchhoffLovePlateShellModel && self.analysisSettings.structuralSubmodel != .ReissnerMindlinPlateShellModel {
                    self.analysisSettings.structuralSubmodel = .KirchhoffLovePlateShellModel
                }
                
                self.beamSubmodelView.isHidden = true
                
                self.structuralModelView.constraints.filter({$0.firstAttribute == NSLayoutConstraint.Attribute.bottom}).forEach{ $0.isActive = false }
                self.structuralModelLabelButton.bottomAnchor.constraint(equalTo: self.structuralModelView.bottomAnchor, constant: -12).isActive = false
                self.plateInitialCurvaturesView.bottomAnchor.constraint(equalTo: self.structuralModelView.bottomAnchor, constant: -12).isActive = true
                self.beamObliqueCrossSectionView.bottomAnchor.constraint(equalTo: self.structuralModelView.bottomAnchor, constant: -12).isActive = false
                self.structuralModelView.constraints.filter({$0.firstAttribute == NSLayoutConstraint.Attribute.bottom}).forEach{ $0.isActive = true }
                
                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.view.layoutIfNeeded()
                }, completion: { (true) in
                    self.plateSubmodelView.isHidden = false
                    self.plateInitialCurvaturesView.isHidden = false
                })
                
            } else {
                self.analysisSettings.structuralSubmodel = .CauchyContinuumModel
            }
            
        }
        
        let m1 = UIAlertAction(title: "Voigt Rules of Mixture", style: UIAlertAction.Style.default) { [weak self] (action) -> Void in
            
            guard let self = self else {return}
            
            self.methodLabelButton.setTitle("Voigt Rules of Mixture", for: .normal)
            self.methodLabelButton.layoutIfNeeded()
            
            self.analysisSettings.calculationMethod = .NonSwiftComp
            self.romMethod = .Voigt
            
            self.editToolBar()
            
            if self.analysisSettings.structuralModel != .solid {
                
                self.structuralModelLabelButton.setTitle("Solid Model", for: .normal)
                self.analysisSettings.structuralModel = .solid
                self.analysisSettings.structuralSubmodel = .CauchyContinuumModel
                
                self.beamSubmodelView.isHidden = true
                self.plateSubmodelView.isHidden = true
                self.plateInitialCurvaturesView.isHidden = true
                self.beamInitialTwistCurvaturesView.isHidden = true
                self.beamObliqueCrossSectionView.isHidden = true
                
                self.structuralModelView.constraints.filter({$0.firstAttribute == NSLayoutConstraint.Attribute.bottom}).forEach{ $0.isActive = false }
                self.structuralModelLabelButton.bottomAnchor.constraint(equalTo: self.structuralModelView.bottomAnchor, constant: -12).isActive = true
                self.plateInitialCurvaturesView.bottomAnchor.constraint(equalTo: self.structuralModelView.bottomAnchor, constant: -12).isActive = false
                self.beamObliqueCrossSectionView.bottomAnchor.constraint(equalTo: self.structuralModelView.bottomAnchor, constant: -12).isActive = false
                self.structuralModelView.constraints.filter({$0.firstAttribute == NSLayoutConstraint.Attribute.bottom}).forEach{ $0.isActive = true }
                
                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.view.layoutIfNeeded()
                }, completion: nil)
                
            }
        }
        
        let m2 = UIAlertAction(title: "Reuss Rules of Mixture", style: UIAlertAction.Style.default) { [weak self] (action) -> Void in
            
            guard let self = self else {return}
            
            self.methodLabelButton.setTitle("Reuss Rules of Mixture", for: .normal)
            self.methodLabelButton.layoutIfNeeded()
            
            self.analysisSettings.calculationMethod = .NonSwiftComp
            self.romMethod = .Reuss
            
            self.editToolBar()
            
            if self.analysisSettings.structuralModel != .solid {
                
                self.structuralModelLabelButton.setTitle("Solid Model", for: .normal)
                self.analysisSettings.structuralModel = .solid
                self.analysisSettings.structuralSubmodel = .CauchyContinuumModel
                
                self.beamSubmodelView.isHidden = true
                self.plateSubmodelView.isHidden = true
                self.plateInitialCurvaturesView.isHidden = true
                self.beamInitialTwistCurvaturesView.isHidden = true
                self.beamObliqueCrossSectionView.isHidden = true
                
                self.structuralModelView.constraints.filter({$0.firstAttribute == NSLayoutConstraint.Attribute.bottom}).forEach{ $0.isActive = false }
                self.structuralModelLabelButton.bottomAnchor.constraint(equalTo: self.structuralModelView.bottomAnchor, constant: -12).isActive = true
                self.plateInitialCurvaturesView.bottomAnchor.constraint(equalTo: self.structuralModelView.bottomAnchor, constant: -12).isActive = false
                self.beamObliqueCrossSectionView.bottomAnchor.constraint(equalTo: self.structuralModelView.bottomAnchor, constant: -12).isActive = false
                self.structuralModelView.constraints.filter({$0.firstAttribute == NSLayoutConstraint.Attribute.bottom}).forEach{ $0.isActive = true }
                
                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.view.layoutIfNeeded()
                }, completion: nil)
                
            }
        }
        
        let m3 = UIAlertAction(title: "Hybrid Rules of Mixture", style: UIAlertAction.Style.default) { [weak self] (action) -> Void in
            
            guard let self = self else {return}
            
            self.methodLabelButton.setTitle("Hybrid Rules of Mixture", for: .normal)
            self.methodLabelButton.layoutIfNeeded()
            
            self.analysisSettings.calculationMethod = .NonSwiftComp
            self.romMethod = .Hybrid
            
            self.editToolBar()
            
            if self.analysisSettings.structuralModel != .solid {
                
                self.structuralModelLabelButton.setTitle("Solid Model", for: .normal)
                self.analysisSettings.structuralModel = .solid
                self.analysisSettings.structuralSubmodel = .CauchyContinuumModel
                
                self.beamSubmodelView.isHidden = true
                self.plateSubmodelView.isHidden = true
                self.plateInitialCurvaturesView.isHidden = true
                self.beamInitialTwistCurvaturesView.isHidden = true
                self.beamObliqueCrossSectionView.isHidden = true
                
                self.structuralModelView.constraints.filter({$0.firstAttribute == NSLayoutConstraint.Attribute.bottom}).forEach{ $0.isActive = false }
                self.structuralModelLabelButton.bottomAnchor.constraint(equalTo: self.structuralModelView.bottomAnchor, constant: -12).isActive = true
                self.plateInitialCurvaturesView.bottomAnchor.constraint(equalTo: self.structuralModelView.bottomAnchor, constant: -12).isActive = false
                self.beamObliqueCrossSectionView.bottomAnchor.constraint(equalTo: self.structuralModelView.bottomAnchor, constant: -12).isActive = false
                self.structuralModelView.constraints.filter({$0.firstAttribute == NSLayoutConstraint.Attribute.bottom}).forEach{ $0.isActive = true }
                
                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.view.layoutIfNeeded()
                }, completion: nil)
                
            }
        }
        
        methodDataBaseAlterController.addAction(m0)
        methodDataBaseAlterController.addAction(m1)
        methodDataBaseAlterController.addAction(m2)
        methodDataBaseAlterController.addAction(m3)
        
        let s0 = UIAlertAction(title: "Beam Model", style: UIAlertAction.Style.default) { [weak self] (action) -> Void in
            
            guard let self = self else {return}
            
            self.structuralModelLabelButton.setTitle("Beam Model", for: .normal)
            self.structuralModelLabelButton.layoutIfNeeded()
            
            self.analysisSettings.structuralModel = .beam
            self.beamSubmodelLabelButton.setTitle("Euler-Bernoulli Model", for: .normal)
            self.analysisSettings.structuralSubmodel = .EulerBernoulliBeamModel
            
            self.analysisSettings.typeOfAnalysis = .elastic
            self.typeOfAnalysisLabelButton.setTitle("Elastic Analysis", for: .normal)
            
            self.plateSubmodelView.isHidden = true
            self.plateInitialCurvaturesView.isHidden = true
            
            self.structuralModelView.constraints.filter({$0.firstAttribute == NSLayoutConstraint.Attribute.bottom}).forEach{ $0.isActive = false }
            self.structuralModelLabelButton.bottomAnchor.constraint(equalTo: self.structuralModelView.bottomAnchor, constant: -12).isActive = false
            self.plateInitialCurvaturesView.bottomAnchor.constraint(equalTo: self.structuralModelView.bottomAnchor, constant: -12).isActive = false
            self.beamObliqueCrossSectionView.bottomAnchor.constraint(equalTo: self.structuralModelView.bottomAnchor, constant: -12).isActive = true
            self.structuralModelView.constraints.filter({$0.firstAttribute == NSLayoutConstraint.Attribute.bottom}).forEach{ $0.isActive = true }
            
            self.geometryView.constraints.filter({$0.firstAttribute == NSLayoutConstraint.Attribute.bottom}).forEach{ $0.isActive = false }
            self.volumeFractionSlider.bottomAnchor.constraint(equalTo: self.geometryView.bottomAnchor, constant: -12).isActive = false
            self.squarePackLengthTextField.bottomAnchor.constraint(equalTo: self.geometryView.bottomAnchor, constant: -12).isActive = true
            self.geometryView.constraints.filter({$0.firstAttribute == NSLayoutConstraint.Attribute.bottom}).forEach{ $0.isActive = true }
            
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: { (true) in
                self.beamSubmodelView.isHidden = false
                self.beamInitialTwistCurvaturesView.isHidden = false
                self.beamObliqueCrossSectionView.isHidden = false
                self.squarePackLengthLabel.isHidden = false
                self.squarePackLengthTextField.isHidden = false
            })
            
        }
        
        let s1 = UIAlertAction(title: "Plate Model", style: UIAlertAction.Style.default) { [weak self] (action) -> Void in
            
            guard let self = self else {return}
            
            self.structuralModelLabelButton.setTitle("Plate Model", for: .normal)
            self.structuralModelLabelButton.layoutIfNeeded()
            
            self.analysisSettings.structuralModel = .plate
            self.plateSubmodelLabelButton.setTitle("Kirchho-Love Model", for: .normal)
            self.analysisSettings.structuralSubmodel = .KirchhoffLovePlateShellModel
            
            self.beamSubmodelView.isHidden = true
            self.beamInitialTwistCurvaturesView.isHidden = true
            self.beamObliqueCrossSectionView.isHidden = true
            
            self.structuralModelView.constraints.filter({$0.firstAttribute == NSLayoutConstraint.Attribute.bottom}).forEach{ $0.isActive = false }
            self.structuralModelLabelButton.bottomAnchor.constraint(equalTo: self.structuralModelView.bottomAnchor, constant: -12).isActive = false
            self.plateInitialCurvaturesView.bottomAnchor.constraint(equalTo: self.structuralModelView.bottomAnchor, constant: -12).isActive = true
            self.beamObliqueCrossSectionView.bottomAnchor.constraint(equalTo: self.structuralModelView.bottomAnchor, constant: -12).isActive = false
            self.structuralModelView.constraints.filter({$0.firstAttribute == NSLayoutConstraint.Attribute.bottom}).forEach{ $0.isActive = true }
            
            self.geometryView.constraints.filter({$0.firstAttribute == NSLayoutConstraint.Attribute.bottom}).forEach{ $0.isActive = false }
            self.volumeFractionSlider.bottomAnchor.constraint(equalTo: self.geometryView.bottomAnchor, constant: -12).isActive = false
            self.squarePackLengthTextField.bottomAnchor.constraint(equalTo: self.geometryView.bottomAnchor, constant: -12).isActive = true
            self.geometryView.constraints.filter({$0.firstAttribute == NSLayoutConstraint.Attribute.bottom}).forEach{ $0.isActive = true }
            
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: { (true) in
                self.plateSubmodelView.isHidden = false
                self.plateInitialCurvaturesView.isHidden = false
                self.squarePackLengthLabel.isHidden = false
                self.squarePackLengthTextField.isHidden = false
            })
            
        }
        
        let s2 = UIAlertAction(title: "Solid Model", style: UIAlertAction.Style.default) { [weak self] (action) -> Void in
            
            guard let self = self else {return}
            
            self.structuralModelLabelButton.setTitle("Solid Model", for: .normal)
            self.structuralModelLabelButton.layoutIfNeeded()
            
            self.analysisSettings.structuralModel = .solid
            self.analysisSettings.structuralSubmodel = .CauchyContinuumModel
            
            // hide submodel and initial curvatures subsection
            
            if self.analysisSettings.calculationMethod == .SwiftComp {
                
                self.beamSubmodelView.isHidden = true
                self.plateSubmodelView.isHidden = true
                self.plateInitialCurvaturesView.isHidden = true
                self.beamInitialTwistCurvaturesView.isHidden = true
                self.beamObliqueCrossSectionView.isHidden = true
                self.squarePackLengthLabel.isHidden = true
                self.squarePackLengthTextField.isHidden = true
                
                self.structuralModelView.constraints.filter({$0.firstAttribute == NSLayoutConstraint.Attribute.bottom}).forEach{ $0.isActive = false }
                self.structuralModelLabelButton.bottomAnchor.constraint(equalTo: self.structuralModelView.bottomAnchor, constant: -12).isActive = true
                self.plateInitialCurvaturesView.bottomAnchor.constraint(equalTo: self.structuralModelView.bottomAnchor, constant: -12).isActive = false
                self.beamObliqueCrossSectionView.bottomAnchor.constraint(equalTo: self.structuralModelView.bottomAnchor, constant: -12).isActive = false
                self.structuralModelView.constraints.filter({$0.firstAttribute == NSLayoutConstraint.Attribute.bottom}).forEach{ $0.isActive = true }
                
                self.geometryView.constraints.filter({$0.firstAttribute == NSLayoutConstraint.Attribute.bottom}).forEach{ $0.isActive = false }
                self.volumeFractionSlider.bottomAnchor.constraint(equalTo: self.geometryView.bottomAnchor, constant: -12).isActive = true
                self.squarePackLengthTextField.bottomAnchor.constraint(equalTo: self.geometryView.bottomAnchor, constant: -12).isActive = false
                self.geometryView.constraints.filter({$0.firstAttribute == NSLayoutConstraint.Attribute.bottom}).forEach{ $0.isActive = true }
                
                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.view.layoutIfNeeded()
                }, completion: nil)
                
            }
        }
        
        let s2ROM = UIAlertAction(title: "Solid Model", style: UIAlertAction.Style.default) { [weak self] (action) -> Void in
            
            guard let self = self else {return}
            
            self.structuralModelLabelButton.setTitle("Solid Model", for: .normal)
            self.structuralModelLabelButton.layoutIfNeeded()
            
            self.analysisSettings.structuralModel = .solid
            self.analysisSettings.structuralSubmodel = .CauchyContinuumModel
            
            // hide submodel and initial curvatures subsection
            
            if self.analysisSettings.calculationMethod == .SwiftComp {
                
                self.beamSubmodelView.isHidden = true
                self.plateSubmodelView.isHidden = true
                self.plateInitialCurvaturesView.isHidden = true
                self.beamInitialTwistCurvaturesView.isHidden = true
                self.beamObliqueCrossSectionView.isHidden = true
                
                self.structuralModelView.constraints.filter({$0.firstAttribute == NSLayoutConstraint.Attribute.bottom}).forEach{ $0.isActive = false }
                self.structuralModelLabelButton.bottomAnchor.constraint(equalTo: self.structuralModelView.bottomAnchor, constant: -12).isActive = true
                self.plateInitialCurvaturesView.bottomAnchor.constraint(equalTo: self.structuralModelView.bottomAnchor, constant: -12).isActive = false
                self.beamObliqueCrossSectionView.bottomAnchor.constraint(equalTo: self.structuralModelView.bottomAnchor, constant: -12).isActive = false
                self.structuralModelView.constraints.filter({$0.firstAttribute == NSLayoutConstraint.Attribute.bottom}).forEach{ $0.isActive = true }
                
                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.view.layoutIfNeeded()
                }, completion: nil)
                
            }
        }
        

        structuralModelDataBaseAlterController.addAction(s0)
        structuralModelDataBaseAlterController.addAction(s1)
        structuralModelDataBaseAlterController.addAction(s2)
        
        structuralModelDataBaseAlterControllerNonSwiftComp.addAction(s2ROM)
        
        let subBeam0 = UIAlertAction(title: "Euler-Bernoulli Model", style: UIAlertAction.Style.default) { [weak self] (action) -> Void in
            guard let self = self else {return}
            self.beamSubmodelLabelButton.setTitle("Euler-Bernoulli Model", for: .normal)
            self.analysisSettings.structuralSubmodel = .EulerBernoulliBeamModel
        }
        
        let subBeam1 = UIAlertAction(title: "Timoshenko Model", style: UIAlertAction.Style.default) { [weak self] (action) -> Void in
            guard let self = self else {return}
            self.beamSubmodelLabelButton.setTitle("Timoshenko Model", for: .normal)
            self.analysisSettings.structuralSubmodel = .TimoshenkoBeamModel
        }
        
        beamSubmodelDataBaseAlterController.addAction(subBeam0)
        beamSubmodelDataBaseAlterController.addAction(subBeam1)

        let subPlate0 = UIAlertAction(title: "Kirchho-Love Model", style: UIAlertAction.Style.default) { [weak self] (action) -> Void in
            guard let self = self else {return}
            self.plateSubmodelLabelButton.setTitle("Kirchho-Love Model", for: .normal)
            self.analysisSettings.structuralSubmodel = .KirchhoffLovePlateShellModel
        }
        
        let subPlate1 = UIAlertAction(title: "Reissner-Mindlin Model", style: UIAlertAction.Style.default) { [weak self] (action) -> Void in
            guard let self = self else {return}
            self.plateSubmodelLabelButton.setTitle("Reissner-Mindlin Model", for: .normal)
            self.analysisSettings.structuralSubmodel = .ReissnerMindlinPlateShellModel
        }
        
        plateSubmodelDataBaseAlterController.addAction(subPlate0)
        plateSubmodelDataBaseAlterController.addAction(subPlate1)
        
        let t0 = UIAlertAction(title: "Elastic Analysis", style: UIAlertAction.Style.default) { [weak self] (action) -> Void in
            guard let self = self else {return}
            self.typeOfAnalysisLabelButton.setTitle("Elastic Analysis", for: .normal)
            self.analysisSettings.typeOfAnalysis = .elastic
            self.changeTypeOfAnalysis(typeOfAnalysis: .elastic)
        }
        
        let t1 = UIAlertAction(title: "Thermoelastic Analysis", style: UIAlertAction.Style.default) { [weak self] (action) -> Void in
            guard let self = self else {return}
            self.typeOfAnalysisLabelButton.setTitle("Thermoelastic Analysis", for: .normal)
            self.analysisSettings.typeOfAnalysis = .thermoElastic
            self.changeTypeOfAnalysis(typeOfAnalysis: .thermoElastic)
        }
        
        typeOfAnalysisDataBaseAlterController.addAction(t0)
        typeOfAnalysisDataBaseAlterController.addAction(t1)
        
        let t0beam = UIAlertAction(title: "Elastic Analysis", style: UIAlertAction.Style.default) { [weak self] (action) -> Void in
            guard let self = self else {return}
            self.typeOfAnalysisLabelButton.setTitle("Elastic Analysis", for: .normal)
            self.analysisSettings.typeOfAnalysis = .elastic
            self.changeTypeOfAnalysis(typeOfAnalysis: .elastic)
        }
        
        typeOfAnalysisDataBaseAlterControllerBeam.addAction(t0beam)
    }
    
    
    // change type of analysis
    
    func changeTypeOfAnalysis(typeOfAnalysis: TypeOfAnalysis) {
        
        createMaterialCard(materialCard: &self.fiberMaterialCard, materialName: self.fiberMaterialNameLabel, label: &self.fiberMaterialPropertiesLabel, value: &self.fiberMaterialPropertiesTextField, aboveConstraint: self.fiberMaterialTypeSegementedControl.bottomAnchor, under: self.fiberMaterialView, typeOfAnalysis: typeOfAnalysis, materialType: fiberMaterialType)
        
        self.fiberMaterialCard.bottomAnchor.constraint(equalTo: self.fiberMaterialView.bottomAnchor, constant: -12).isActive = true
        
        createMaterialCard(materialCard: &self.matrixMaterialCard, materialName: self.matrixMaterialNameLabel, label: &self.matrixMaterialPropertiesLabel, value: &self.matrixMaterialPropertiesTextField, aboveConstraint: self.matrixMaterialTypeSegementedControl.bottomAnchor, under: self.matrixMaterialView, typeOfAnalysis: typeOfAnalysis, materialType: matrixMaterialType)
        
        self.matrixMaterialCard.bottomAnchor.constraint(equalTo: self.matrixMaterialView.bottomAnchor, constant: -12).isActive = true
        
        self.changeMaterialDataField()
        
    }
    
    
    // MARK: Load core data
    
    func loadCoreData() {
        
        // add fiber material
        
        do {
            userSavedFiberMaterials = try context.fetch(UserFiberMaterial.fetchRequest())
        } catch {
            print("Could not load fiber material from database \(error.localizedDescription)")
        }
        
        
        // add matrix material
        
        do {
            userSavedMatrixMaterials = try context.fetch(UserMatrixMaterial.fetchRequest())
        } catch {
            print("Could not load matrix material from database \(error.localizedDescription)")
        }
        
    }
    
    
    // get parameters
    
    override func getCalculationParameters() -> GetParametersStatus {
        
        analysisSettings.compositeModelName = .UDFRC
        
        (k12_plate, k21_plate) = (0.0, 0.0)
        (k11_beam, k12_beam, k13_beam) = (0.0, 0.0, 0.0)
        (cos_angle1, cos_angle2) = (1.0, 0.0)
        
        Vf = 0.0
        squarePackLength = 1.0
        
        (ef1, ef2, ef3, gf12, gf13, gf23, nuf12, nuf13, nuf23) = (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
        (alphaf11, alphaf22, alphaf33, alphaf23, alphaf13, alphaf12) = (0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
        
        (em1, em2, em3, gm12, gm13, gm23, num12, num13, num23) = (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
        (alpham11, alpham22, alpham33, alpham23, alpham13, alpham12) = (0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
        
        if analysisSettings.structuralModel == .beam {
            
            guard let k11Guard = Double(beamInitialTwistCurvaturesk11TextField.text!), let k12Guard = Double(beamInitialTwistCurvaturesk12TextField.text!), let k13Guard = Double(beamInitialTwistCurvaturesk13TextField.text!) else {
                return .wrongBeamInitialTwistCurvatures
            }
            (k11_beam, k12_beam, k13_beam) = (k11Guard, k12Guard, k13Guard)
            
            guard let cos_angle1Guard = Double(beamObliqueCrossSectionCosAngle1TextField.text!), let cos_angle2Guard = Double(beamObliqueCrossSectionCosAngle2TextField.text!) else {
                return .wrongBeamObliqueCrossSections
            }
            (cos_angle1, cos_angle2) = (cos_angle1Guard, cos_angle2Guard)
            
        } else if analysisSettings.structuralModel == .plate {
            
            guard let k12Guard = Double(plateInitialCurvaturesk21TextField.text!), let k21Guard = Double(plateInitialCurvaturesk21TextField.text!) else {
                return .wrongPlateInitialCurvatures
            }
            (k12_plate, k21_plate) = (k12Guard, k21Guard)
            
        }
        
        let Vftext : String = geometryLabel.text ?? ""
        Vf = Double(Vftext[Vftext.index(Vftext.endIndex, offsetBy: -4) ..< Vftext.endIndex])! // fiber volume fraction
        
        if analysisSettings.structuralModel != .solid {
            guard let squarePackLengthGuard = Double(squarePackLengthTextField.text!) else {return .wrongSquarePackLength}
            if squarePackLengthGuard == 0.0 {
                return .wrongSquarePackLength
            }
            squarePackLength = squarePackLengthGuard
        }
        
        
        // fiber material parameters
        
        if fiberMaterialType == .isotropic {
            guard let ef1Guard = Double(fiberMaterialPropertiesTextField[0].text!), let nuf12Guard = Double(fiberMaterialPropertiesTextField[1].text!) else {
                return .wrongMaterialValue
            }
            
            if nuf12Guard == -1 {
                return .wrongNuValue
            }
            
            (ef1, ef2, ef3, gf12, gf13, gf23, nuf12, nuf13, nuf23) = (ef1Guard, ef1Guard, ef1Guard, ef1Guard / (2*(1+nuf12Guard)), ef1Guard / (2*(1+nuf12Guard)), ef1Guard / (2*(1+nuf12Guard)), nuf12Guard, nuf12Guard, nuf12Guard)
            
            if self.analysisSettings.typeOfAnalysis == .thermoElastic {
                guard let alphaf11Guard = Double(fiberMaterialPropertiesTextField[2].text!) else {
                    return .wrongCTEValue
                }
                (alphaf11, alphaf22, alphaf33, alphaf23, alphaf13, alphaf12) = (alphaf11Guard, alphaf11Guard, alphaf11Guard, 0, 0, 0)
            }
            
        } else if fiberMaterialType == .transverselyIsotropic {
            guard let ef1Guard = Double(fiberMaterialPropertiesTextField[0].text!), let ef2Guard = Double(fiberMaterialPropertiesTextField[1].text!), let gf12Guard = Double(fiberMaterialPropertiesTextField[2].text!), let nuf12Guard = Double(fiberMaterialPropertiesTextField[3].text!), let nuf23Guard = Double(fiberMaterialPropertiesTextField[4].text!) else {
                return .wrongMaterialValue
            }
            
            if nuf23Guard == -1 {
                return .wrongNuValue
            }
            
            let ef3Guard   = ef2Guard
            let gf13Guard  = gf12Guard
            let gf23Guard  = ef2Guard / (2 * (1 + nuf23Guard))
            let nuf13Guard = nuf12Guard
            
            (ef1, ef2, ef3, gf12, gf13, gf23, nuf12, nuf13, nuf23) = (ef1Guard, ef2Guard, ef3Guard, gf12Guard, gf13Guard, gf23Guard, nuf12Guard, nuf13Guard, nuf23Guard)
            
            if self.analysisSettings.typeOfAnalysis == .thermoElastic {
                guard let alphaf11Guard = Double(fiberMaterialPropertiesTextField[5].text!), let alphaf22Guard = Double(fiberMaterialPropertiesTextField[6].text!) else {
                    return .wrongCTEValue
                }
                (alphaf11, alphaf22, alphaf33, alphaf23, alphaf13, alphaf12) = (alphaf11Guard, alphaf22Guard, alphaf22Guard, 0, 0, 0)
            }
            
        } else if fiberMaterialType == .orthotropic {
            guard let ef1Guard = Double(fiberMaterialPropertiesTextField[0].text!), let ef2Guard = Double(fiberMaterialPropertiesTextField[1].text!), let ef3Guard = Double(fiberMaterialPropertiesTextField[2].text!), let gf12Guard = Double(fiberMaterialPropertiesTextField[3].text!), let gf13Guard = Double(fiberMaterialPropertiesTextField[4].text!), let gf23Guard = Double(fiberMaterialPropertiesTextField[5].text!), let nuf12Guard = Double(fiberMaterialPropertiesTextField[6].text!), let nuf13Guard = Double(fiberMaterialPropertiesTextField[7].text!), let nuf23Guard = Double(fiberMaterialPropertiesTextField[8].text!) else {
                return .wrongMaterialValue
            }
            
            (ef1, ef2, ef3, gf12, gf13, gf23, nuf12, nuf13, nuf23) = (ef1Guard, ef2Guard, ef3Guard, gf12Guard, gf13Guard, gf23Guard, nuf12Guard, nuf13Guard, nuf23Guard)
            
            if self.analysisSettings.typeOfAnalysis == .thermoElastic {
                guard let alphaf11Guard = Double(fiberMaterialPropertiesTextField[9].text!), let alphaf22Guard = Double(fiberMaterialPropertiesTextField[10].text!), let alphaf33Guard = Double(fiberMaterialPropertiesTextField[11].text!) else {
                    return .wrongCTEValue
                }
                (alphaf11, alphaf22, alphaf33, alphaf23, alphaf13, alphaf12) = (alphaf11Guard, alphaf22Guard, alphaf33Guard, 0, 0, 0)
            }
            
        }
        
        // matrix material parameters
        
        if matrixMaterialType == .isotropic {
            guard let em1Guard = Double(matrixMaterialPropertiesTextField[0].text!), let num12Guard = Double(matrixMaterialPropertiesTextField[1].text!) else {
                return .wrongMaterialValue
            }
            
            (em1, em2, em3, gm12, gm13, gm23, num12, num13, num23) = (em1Guard, em1Guard, em1Guard, em1Guard / (2*(1+num12Guard)), em1Guard / (2*(1+num12Guard)), em1Guard / (2*(1+num12Guard)), num12Guard, num12Guard, num12Guard)
            
            if self.analysisSettings.typeOfAnalysis == .thermoElastic {
                guard let alpham11Guard = Double(matrixMaterialPropertiesTextField[2].text!) else {
                    return .wrongCTEValue
                }
                (alpham11, alpham22, alpham33, alpham23, alpham13, alpham12) = (alpham11Guard, alpham11Guard, alpham11Guard, 0, 0, 0)
            }
            
        } else if matrixMaterialType == .transverselyIsotropic {
            guard let em1Guard = Double(matrixMaterialPropertiesTextField[0].text!), let em2Guard = Double(matrixMaterialPropertiesTextField[1].text!), let gm12Guard = Double(matrixMaterialPropertiesTextField[2].text!), let num12Guard = Double(matrixMaterialPropertiesTextField[3].text!), let num23Guard = Double(matrixMaterialPropertiesTextField[4].text!) else {
                return .wrongMaterialValue
            }
            
            let em3Guard   = em2Guard
            let gm13Guard  = gm12Guard
            let gm23Guard  = em2Guard / (2 * (1 + num23Guard))
            let num13Guard = num12Guard
            
            (em1, em2, em3, gm12, gm13, gm23, num12, num13, num23) = (em1Guard, em2Guard, em3Guard, gm12Guard, gm13Guard, gm23Guard, num12Guard, num13Guard, num23Guard)
            
            if self.analysisSettings.typeOfAnalysis == .thermoElastic {
                guard let alpham11Guard = Double(matrixMaterialPropertiesTextField[5].text!), let alpham22Guard = Double(matrixMaterialPropertiesTextField[6].text!) else {
                    return .wrongCTEValue
                }
                (alpham11, alpham22, alpham33, alpham23, alpham13, alpham12) = (alpham11Guard, alpham22Guard, alpham22Guard, 0, 0, 0)
            }
            
        } else if matrixMaterialType == .orthotropic {
            guard let em1Guard = Double(matrixMaterialPropertiesTextField[0].text!), let em2Guard = Double(matrixMaterialPropertiesTextField[1].text!), let em3Guard = Double(matrixMaterialPropertiesTextField[2].text!), let gm12Guard = Double(matrixMaterialPropertiesTextField[3].text!), let gm13Guard = Double(matrixMaterialPropertiesTextField[4].text!), let gm23Guard = Double(matrixMaterialPropertiesTextField[5].text!), let num12Guard = Double(matrixMaterialPropertiesTextField[6].text!), let num13Guard = Double(matrixMaterialPropertiesTextField[7].text!), let num23Guard = Double(matrixMaterialPropertiesTextField[8].text!) else {
                return .wrongMaterialValue
            }
            
            (em1, em2, em3, gm12, gm13, gm23, num12, num13, num23) = (em1Guard, em2Guard, em3Guard, gm12Guard, gm13Guard, gm23Guard, num12Guard, num13Guard, num23Guard)
            
            if self.analysisSettings.typeOfAnalysis == .thermoElastic {
                guard let alpham11Guard = Double(matrixMaterialPropertiesTextField[9].text!), let alpham22Guard = Double(matrixMaterialPropertiesTextField[10].text!), let alpham33Guard = Double(matrixMaterialPropertiesTextField[11].text!) else {
                    return .wrongCTEValue
                }
                (alpham11, alpham22, alpham33, alpham23, alpham13, alpham12) = (alpham11Guard, alpham22Guard, alpham33Guard, 0, 0, 0)
            }
            
        }
        
        return .noError
    }
    
    
    // calculate result by ROM
    
    override func calculationResultByNonSwiftComp() {
        var Sf : [Double] = []
        var Sm : [Double] = []
        var SHf : [Double] = []
        var SHm : [Double] = []
        
        Sf = [1/ef1, -nuf12/ef1, -nuf13/ef1, 0, 0, 0, -nuf12/ef1, 1/ef2, -nuf23/ef2, 0, 0, 0, -nuf12/ef1, -nuf23/ef2, 1/ef3, 0, 0, 0, 0, 0, 0, 1/gf23, 0, 0, 0, 0, 0, 0, 1/gf13, 0, 0, 0, 0, 0, 0, 1/gf12]
        SHf = [ef1, nuf12, nuf13, 0, 0, 0, -nuf12, 1/ef2 - nuf12*nuf12/ef1, -nuf23/ef2 - nuf13*nuf13/ef1, 0, 0, 0, -nuf23, -nuf23/ef2 - nuf12*nuf12/ef1, 1/ef3 - nuf13*nuf13/ef1, 0, 0, 0, 0, 0, 0, 1/gf23, 0, 0, 0, 0, 0, 0, 1/gf13, 0, 0, 0, 0, 0, 0, 1/gf12]
        
        Sm = [1/em1, -num12/em1, -num13/em1, 0, 0, 0, -num12/em1, 1/em2, -num23/em2, 0, 0, 0, -num12/em1, -num23/em2, 1/em3, 0, 0, 0, 0, 0, 0, 1/gm23, 0, 0, 0, 0, 0, 0, 1/gm13, 0, 0, 0, 0, 0, 0, 1/gm12]
        SHm = [em1, num12, num13, 0, 0, 0, -num12, 1/em2 - num12*num12/em1, -num23/em2 - num13*num13/em1, 0, 0, 0, -num23, -num23/em2 - num12*num12/em1, 1/em3 - num13*num13/em1, 0, 0, 0, 0, 0, 0, 1/gm23, 0, 0, 0, 0, 0, 0, 1/gm13, 0, 0, 0, 0, 0, 0, 1/gm12]
        
        var SRs = [Double](repeating: 0, count: 36)
        var SVs = [Double](repeating: 0, count: 36)
        var SHs = [Double](repeating: 0, count: 36)
        
        var Cf = [Double](repeating: 0, count: 36)
        var Cm = [Double](repeating: 0, count: 36)
        var CVs = [Double](repeating: 0, count: 36)
        var CRs = [Double](repeating: 0, count: 36)
        
        var temp1 = [Double](repeating: 0, count: 36)
        var temp2 = [Double](repeating: 0, count: 36)
        
        var Vm = 1 - Vf
        
        vDSP_vsmulD(Sf, 1, &Vf, &temp1, 1, 36)
        vDSP_vsmulD(Sm, 1, &Vm, &temp2, 1, 36)
        vDSP_vaddD(temp1, 1, temp2, 1, &SRs, 1, 36)
        
        vDSP_vsmulD(SHf, 1, &Vf, &temp1, 1, 36)
        vDSP_vsmulD(SHm, 1, &Vm, &temp2, 1, 36)
        vDSP_vaddD(temp1, 1, temp2, 1, &SHs, 1, 36)
        
        Cf = invert(matrix : Sf)
        Cm = invert(matrix : Sm)
        
        vDSP_vsmulD(Cf, 1, &Vf, &temp1, 1, 36)
        vDSP_vsmulD(Cm, 1, &Vm, &temp2, 1, 36)
        vDSP_vaddD(temp1, 1, temp2, 1, &CVs, 1, 36)
        
        SVs = invert(matrix: CVs)
        CRs = invert(matrix: SRs)
        
        // Voigt results
        let eV1  = 1/SVs[0]
        let eV2  = 1/SVs[7]
        let eV3  = 1/SVs[14]
        let gV12 = 1/SVs[35]
        let gV13 = 1/SVs[28]
        let gV23 = 1/SVs[21]
        let nuV12 = -1/SVs[0]*SVs[1]
        let nuV13 = -1/SVs[0]*SVs[2]
        let nuV23 = -1/SVs[7]*SVs[8]
        
        // Reuss results
        let eR1  = 1/SRs[0]
        let eR2  = 1/SRs[7]
        let eR3  = 1/SRs[14]
        let gR12 = 1/SRs[35]
        let gR13 = 1/SRs[28]
        let gR23 = 1/SRs[21]
        let nuR12 = -1/SRs[0]*SRs[1]
        let nuR13 = -1/SRs[0]*SRs[2]
        let nuR23 = -1/SRs[7]*SRs[8]
        
        
        //Hybird results
        let eH1 = SHs[0]
        
        let nuH12 = SHs[1]
        let nuH13 = SHs[2]
        
        let gH12 = SHs[35]
        let gH13 = SHs[28]
        let gH23 = SHs[21]
        
        let eH2 = 1 / (SHs[7] + nuH12*nuH12/eH1)
        let eH3 = 1 / (SHs[14] + nuH13*nuH13/eH1)
        
        let nuH23 = -eH2 * (SHs[8] + nuH12*nuH12 / eH1)
        
        var SHsEngineering = [Double](repeating: 0, count: 36)
        var CHsEngineering = [Double](repeating: 0, count: 36)
        
        SHsEngineering = [1/eH1, -nuH12/eH1, -nuH13/eH1, 0, 0, 0, -nuH12/eH1, 1/eH2, -nuH23/eH2, 0, 0, 0, -nuH12/eH1, -nuH23/eH2, 1/eH3, 0, 0, 0, 0, 0, 0, 1/gH23, 0, 0, 0, 0, 0, 0, 1/gH13, 0, 0, 0, 0, 0, 0, 1/gH12]
        CHsEngineering = invert(matrix: SHsEngineering)
        
        
        if self.romMethod == .Voigt {
            resultData.engineeringConstantsOrthotropic[0] = eV1
            resultData.engineeringConstantsOrthotropic[1] = eV2
            resultData.engineeringConstantsOrthotropic[2] = eV3
            resultData.engineeringConstantsOrthotropic[3] = gV12
            resultData.engineeringConstantsOrthotropic[4] = gV13
            resultData.engineeringConstantsOrthotropic[5] = gV23
            resultData.engineeringConstantsOrthotropic[6] = nuV12
            resultData.engineeringConstantsOrthotropic[7] = nuV13
            resultData.engineeringConstantsOrthotropic[8] = nuV23
            resultData.effectiveSolidStiffnessMatrix = CVs
            
        } else if self.romMethod == .Reuss {
            resultData.engineeringConstantsOrthotropic[0] = eR1
            resultData.engineeringConstantsOrthotropic[1] = eR2
            resultData.engineeringConstantsOrthotropic[2] = eR3
            resultData.engineeringConstantsOrthotropic[3] = gR12
            resultData.engineeringConstantsOrthotropic[4] = gR13
            resultData.engineeringConstantsOrthotropic[5] = gR23
            resultData.engineeringConstantsOrthotropic[6] = nuR12
            resultData.engineeringConstantsOrthotropic[7] = nuR13
            resultData.engineeringConstantsOrthotropic[8] = nuR23
            resultData.effectiveSolidStiffnessMatrix = CRs
            
        } else {
            resultData.engineeringConstantsOrthotropic[0] = eH1
            resultData.engineeringConstantsOrthotropic[1] = eH2
            resultData.engineeringConstantsOrthotropic[2] = eH3
            resultData.engineeringConstantsOrthotropic[3] = gH12
            resultData.engineeringConstantsOrthotropic[4] = gH13
            resultData.engineeringConstantsOrthotropic[5] = gH23
            resultData.engineeringConstantsOrthotropic[6] = nuH12
            resultData.engineeringConstantsOrthotropic[7] = nuH13
            resultData.engineeringConstantsOrthotropic[8] = nuH23
            resultData.effectiveSolidStiffnessMatrix = CHsEngineering
        }
        
        
        
        if self.analysisSettings.typeOfAnalysis == .thermoElastic {
            
            let alphaf : [Double] = [alphaf11, alphaf22, alphaf33, alphaf23, alphaf13, alphaf12]
            let alpham : [Double] = [alpham11, alpham22, alpham33, alpham23, alpham13, alpham12]
            
            let alphaf11 = alphaf[0]
            let alphaf22 = alphaf[1]
            let alphaf33 = alphaf[2]
            
            let alpham11 = alpham[0]
            let alpham22 = alpham[1]
            let alpham33 = alpham[2]
            
            var temp3 = [Double](repeating: 0, count: 6)
            var temp4 = [Double](repeating: 0, count: 6)
            vDSP_mmulD(Cf, 1, alphaf, 1, &temp3, 1, 6, 1, 6)
            vDSP_mmulD(Cm, 1, alpham, 1, &temp4, 1, 6, 1, 6)
            
            var temp5 = [Double](repeating: 0, count: 6)
            vDSP_vsmulD(temp3, 1, &Vf, &temp1, 1, 6)
            vDSP_vsmulD(temp4, 1, &Vm, &temp2, 1, 6)
            vDSP_vaddD(temp1, 1, temp2, 1, &temp5, 1, 6)
            
            var alphamVs = [Double](repeating: 0, count: 6)
            vDSP_mmulD(SVs, 1, temp5, 1, &alphamVs, 1, 6, 1, 6)
            
            let alphaV11 = alphamVs[0]
            let alphaV22 = alphamVs[1]
            let alphaV33 = alphamVs[2]
            
            let alphamRs : [Double] =  [Vf*alphaf11+Vm*alpham11,  Vf*alphaf22+Vm*alpham22, Vf*alphaf33+Vm*alpham33, 0 ,0 ,0]
            
            let alphaR11 = alphamRs[0]
            let alphaR22 = alphamRs[1]
            let alphaR33 = alphamRs[2]
            
            let ef1 = 1/Sf[0]
            let vf12 = -ef1*Sf[1]
            let vf13 = -ef1*Sf[2]
            
            let em1 = 1/Sm[0]
            let vm12 = -em1*Sm[1]
            let vm13 = -em1*Sm[2]
            
            let alphaHf : [Double] =  [-ef1 * alphaf11, alphaf11 * vf12 + alphaf22, alphaf11 * vf13 + alphaf33,0 ,0 ,0]
            let alphaHm : [Double] =  [-em1 * alpham11, alpham11 * vm12 + alpham22, alpham11 * vm13 + alpham33,0 ,0 ,0]
            
            var tempAlphaf = [Double](repeating: 0, count: 6)
            var tempAlpham = [Double](repeating: 0, count: 6)
            
            var alphaHs = [Double](repeating: 0, count: 6)
            
            vDSP_vsmulD(alphaHf, 1, &Vf, &tempAlphaf, 1, 6)
            vDSP_vsmulD(alphaHm, 1, &Vm, &tempAlpham, 1, 6)
            vDSP_vaddD(tempAlphaf, 1, tempAlpham, 1, &alphaHs, 1, 6)
            
            let alphaH11 = -alphaHs[0] / eH1
            let alphaH22 = alphaHs[1] - alphaH11 * nuH12
            let alphaH33 = alphaHs[2] - alphaH11 * nuH13
            
            
            if self.romMethod == .Voigt {
                resultData.effectiveThermalCoefficients[0] = alphaV11
                resultData.effectiveThermalCoefficients[1] = alphaV22
                resultData.effectiveThermalCoefficients[2] = alphaV33
            } else if self.romMethod == .Reuss {
                resultData.effectiveThermalCoefficients[0] = alphaR11
                resultData.effectiveThermalCoefficients[1] = alphaR22
                resultData.effectiveThermalCoefficients[2] = alphaR33
                
            } else {
                resultData.effectiveThermalCoefficients[0] = alphaH11
                resultData.effectiveThermalCoefficients[1] = alphaH22
                resultData.effectiveThermalCoefficients[2] = alphaH33
            }
            
            resultData.effectiveThermalCoefficients[3] = 0
            resultData.effectiveThermalCoefficients[4] = 0
            resultData.effectiveThermalCoefficients[5] = 0
        }
    }
    
    // calculate result by SwiftComp
    
    override func calculateResultBySwiftComp() -> swiftcompCalculationStatus {
        
        var typeOfAnalysisValue : String = "Elastic"
        var structuralModelValue : String = "Solid"
        var structuralSubmodelValue : String = "CauchyContinuumModel"
        var fiberMaterialTypeValue : String = "Isotropic"
        var fiberMaterialPropertiesValue : String = ""
        var matrixMaterialTypeValue : String = "Isotropic"
        var matrixMaterialPropertiesValue : String = ""
        
        if analysisSettings.typeOfAnalysis == .elastic {
            typeOfAnalysisValue = "Elastic"
        } else if analysisSettings.typeOfAnalysis == .thermoElastic {
            typeOfAnalysisValue = "Thermoelastic"
        }
        
        if analysisSettings.structuralModel == .beam {
            structuralModelValue = "Beam"
        } else if analysisSettings.structuralModel == .plate {
            structuralModelValue = "Plate"
        } else {
            structuralModelValue = "Solid"
        }
        
        API_URL = "\(baseURL)/UDFRC/homogenization?typeOfAnalysis=\(typeOfAnalysisValue)&structuralModel=\(structuralModelValue)"
        
        if analysisSettings.structuralModel == .beam {
            
            if analysisSettings.structuralSubmodel == .EulerBernoulliBeamModel {
                structuralSubmodelValue = "EulerBernoulliBeamModel"
            } else if analysisSettings.structuralSubmodel == .TimoshenkoBeamModel {
                structuralSubmodelValue = "TimoshenkoBeamModel"
            }
            
            API_URL += "&structuralSubmodel=\(structuralSubmodelValue)&k11_beam=\(k11_beam)&k12_beam=\(k12_beam)&k13_beam=\(k13_beam)&cos_angle1=\(cos_angle1)&cos_angle2=\(cos_angle2)"
            
        } else if analysisSettings.structuralModel == .plate {
            
            if analysisSettings.structuralSubmodel == .KirchhoffLovePlateShellModel {
                structuralSubmodelValue = "KirchhoffLovePlateShellModel"
            } else if analysisSettings.structuralSubmodel == .ReissnerMindlinPlateShellModel {
                structuralSubmodelValue = "ReissnerMindlinPlateShellModel"
            }
            
            API_URL += "&structuralSubmodel=\(structuralSubmodelValue)&k12_plate=\(k12_plate)&k21_plate=\(k21_plate)"
            
        }
        
        API_URL += "&fiberVolumeFraction=\(Vf)&squarePackLength=\(squarePackLength)"
        
        fiberMaterialTypeValue = "Orthotropic"
        
        fiberMaterialPropertiesValue = "Ef1=\(ef1)&Ef2=\(ef2)&Ef3=\(ef3)&Gf12=\(gf12)&Gf13=\(gf13)&Gf23=\(gf23)&nuf12=\(nuf12)&nuf13=\(nuf13)&nuf23=\(nuf23)"
        
        matrixMaterialTypeValue = "Orthotropic"
        
        matrixMaterialPropertiesValue = "Em1=\(em1)&Em2=\(em2)&Em3=\(em3)&Gm12=\(gm12)&Gm13=\(gm13)&Gm23=\(gm23)&num12=\(num12)&num13=\(num13)&num23=\(num23)"
        
        if analysisSettings.typeOfAnalysis == .thermoElastic {
            fiberMaterialPropertiesValue += "&alphaf11=\(alphaf11)&alphaf22=\(alphaf22)&alphaf33=\(alphaf33)&alphaf23=\(alphaf23)&alphaf13=\(alphaf13)&alphaf12=\(alphaf12)"
            matrixMaterialPropertiesValue += "&alpham11=\(alpham11)&alpham22=\(alpham22)&alpham33=\(alpham33)&alpham23=\(alpham23)&alpham13=\(alpham13)&alpham12=\(alpham12)"
        }
        
        API_URL += "&fiberMaterialType=\(fiberMaterialTypeValue)&\(fiberMaterialPropertiesValue)&matrixMaterialType=\(matrixMaterialTypeValue)&\(matrixMaterialPropertiesValue)"
        
        let group = DispatchGroup()
        
        group.enter()
        
        fetchSwiftCompHomogenizationResultJSON(API_URL: API_URL, timeoutIntervalForRequest: 15) { (res) in
            switch res {
            case .success(let result):
                
                self.resultData.swiftcompCwd = result.swiftcompCwd
                
                self.resultData.swiftcompCalculationInfo = result.swiftcompCalculationInfo
                
                if self.analysisSettings.structuralModel == .beam {
                    
                    self.resultData.effectiveBeamStiffness4by4[0] =  Double(result.beamModelResult.effectiveBeamStiffness4by4.S11) ?? 0
                    self.resultData.effectiveBeamStiffness4by4[1] =  Double(result.beamModelResult.effectiveBeamStiffness4by4.S12) ?? 0
                    self.resultData.effectiveBeamStiffness4by4[2] =  Double(result.beamModelResult.effectiveBeamStiffness4by4.S13) ?? 0
                    self.resultData.effectiveBeamStiffness4by4[3] =  Double(result.beamModelResult.effectiveBeamStiffness4by4.S14) ?? 0
                    
                    self.resultData.effectiveBeamStiffness4by4[4] =  Double(result.beamModelResult.effectiveBeamStiffness4by4.S12) ?? 0
                    self.resultData.effectiveBeamStiffness4by4[5] =  Double(result.beamModelResult.effectiveBeamStiffness4by4.S22) ?? 0
                    self.resultData.effectiveBeamStiffness4by4[6] =  Double(result.beamModelResult.effectiveBeamStiffness4by4.S23) ?? 0
                    self.resultData.effectiveBeamStiffness4by4[7] =  Double(result.beamModelResult.effectiveBeamStiffness4by4.S24) ?? 0
                    
                    self.resultData.effectiveBeamStiffness4by4[8] =  Double(result.beamModelResult.effectiveBeamStiffness4by4.S13) ?? 0
                    self.resultData.effectiveBeamStiffness4by4[9] =  Double(result.beamModelResult.effectiveBeamStiffness4by4.S23) ?? 0
                    self.resultData.effectiveBeamStiffness4by4[10] = Double(result.beamModelResult.effectiveBeamStiffness4by4.S33) ?? 0
                    self.resultData.effectiveBeamStiffness4by4[11] = Double(result.beamModelResult.effectiveBeamStiffness4by4.S34) ?? 0
                    
                    self.resultData.effectiveBeamStiffness4by4[12] = Double(result.beamModelResult.effectiveBeamStiffness4by4.S14) ?? 0
                    self.resultData.effectiveBeamStiffness4by4[13] = Double(result.beamModelResult.effectiveBeamStiffness4by4.S24) ?? 0
                    self.resultData.effectiveBeamStiffness4by4[14] = Double(result.beamModelResult.effectiveBeamStiffness4by4.S34) ?? 0
                    self.resultData.effectiveBeamStiffness4by4[15] = Double(result.beamModelResult.effectiveBeamStiffness4by4.S44) ?? 0
                    
                    self.resultData.effectiveBeamStiffness6by6[0] =  Double(result.beamModelResult.effectiveBeamStiffness6by6.S11) ?? 0
                    self.resultData.effectiveBeamStiffness6by6[1] =  Double(result.beamModelResult.effectiveBeamStiffness6by6.S12) ?? 0
                    self.resultData.effectiveBeamStiffness6by6[2] =  Double(result.beamModelResult.effectiveBeamStiffness6by6.S13) ?? 0
                    self.resultData.effectiveBeamStiffness6by6[3] =  Double(result.beamModelResult.effectiveBeamStiffness6by6.S14) ?? 0
                    self.resultData.effectiveBeamStiffness6by6[4] =  Double(result.beamModelResult.effectiveBeamStiffness6by6.S15) ?? 0
                    self.resultData.effectiveBeamStiffness6by6[5] =  Double(result.beamModelResult.effectiveBeamStiffness6by6.S16) ?? 0
                    
                    self.resultData.effectiveBeamStiffness6by6[6] =  Double(result.beamModelResult.effectiveBeamStiffness6by6.S12) ?? 0
                    self.resultData.effectiveBeamStiffness6by6[7] =  Double(result.beamModelResult.effectiveBeamStiffness6by6.S22) ?? 0
                    self.resultData.effectiveBeamStiffness6by6[8] =  Double(result.beamModelResult.effectiveBeamStiffness6by6.S23) ?? 0
                    self.resultData.effectiveBeamStiffness6by6[9] =  Double(result.beamModelResult.effectiveBeamStiffness6by6.S24) ?? 0
                    self.resultData.effectiveBeamStiffness6by6[10] = Double(result.beamModelResult.effectiveBeamStiffness6by6.S25) ?? 0
                    self.resultData.effectiveBeamStiffness6by6[11] = Double(result.beamModelResult.effectiveBeamStiffness6by6.S26) ?? 0
                    
                    self.resultData.effectiveBeamStiffness6by6[12] = Double(result.beamModelResult.effectiveBeamStiffness6by6.S13) ?? 0
                    self.resultData.effectiveBeamStiffness6by6[13] = Double(result.beamModelResult.effectiveBeamStiffness6by6.S23) ?? 0
                    self.resultData.effectiveBeamStiffness6by6[14] = Double(result.beamModelResult.effectiveBeamStiffness6by6.S33) ?? 0
                    self.resultData.effectiveBeamStiffness6by6[15] = Double(result.beamModelResult.effectiveBeamStiffness6by6.S34) ?? 0
                    self.resultData.effectiveBeamStiffness6by6[16] = Double(result.beamModelResult.effectiveBeamStiffness6by6.S35) ?? 0
                    self.resultData.effectiveBeamStiffness6by6[17] = Double(result.beamModelResult.effectiveBeamStiffness6by6.S36) ?? 0
                    
                    self.resultData.effectiveBeamStiffness6by6[18] = Double(result.beamModelResult.effectiveBeamStiffness6by6.S14) ?? 0
                    self.resultData.effectiveBeamStiffness6by6[19] = Double(result.beamModelResult.effectiveBeamStiffness6by6.S24) ?? 0
                    self.resultData.effectiveBeamStiffness6by6[20] = Double(result.beamModelResult.effectiveBeamStiffness6by6.S34) ?? 0
                    self.resultData.effectiveBeamStiffness6by6[21] = Double(result.beamModelResult.effectiveBeamStiffness6by6.S44) ?? 0
                    self.resultData.effectiveBeamStiffness6by6[22] = Double(result.beamModelResult.effectiveBeamStiffness6by6.S45) ?? 0
                    self.resultData.effectiveBeamStiffness6by6[23] = Double(result.beamModelResult.effectiveBeamStiffness6by6.S46) ?? 0
                    
                    self.resultData.effectiveBeamStiffness6by6[24] = Double(result.beamModelResult.effectiveBeamStiffness6by6.S15) ?? 0
                    self.resultData.effectiveBeamStiffness6by6[25] = Double(result.beamModelResult.effectiveBeamStiffness6by6.S25) ?? 0
                    self.resultData.effectiveBeamStiffness6by6[26] = Double(result.beamModelResult.effectiveBeamStiffness6by6.S35) ?? 0
                    self.resultData.effectiveBeamStiffness6by6[27] = Double(result.beamModelResult.effectiveBeamStiffness6by6.S45) ?? 0
                    self.resultData.effectiveBeamStiffness6by6[28] = Double(result.beamModelResult.effectiveBeamStiffness6by6.S55) ?? 0
                    self.resultData.effectiveBeamStiffness6by6[29] = Double(result.beamModelResult.effectiveBeamStiffness6by6.S56) ?? 0
                    
                    self.resultData.effectiveBeamStiffness6by6[30] = Double(result.beamModelResult.effectiveBeamStiffness6by6.S16) ?? 0
                    self.resultData.effectiveBeamStiffness6by6[31] = Double(result.beamModelResult.effectiveBeamStiffness6by6.S26) ?? 0
                    self.resultData.effectiveBeamStiffness6by6[32] = Double(result.beamModelResult.effectiveBeamStiffness6by6.S36) ?? 0
                    self.resultData.effectiveBeamStiffness6by6[33] = Double(result.beamModelResult.effectiveBeamStiffness6by6.S46) ?? 0
                    self.resultData.effectiveBeamStiffness6by6[34] = Double(result.beamModelResult.effectiveBeamStiffness6by6.S56) ?? 0
                    self.resultData.effectiveBeamStiffness6by6[35] = Double(result.beamModelResult.effectiveBeamStiffness6by6.S66) ?? 0
                    
                    
                    if self.analysisSettings.typeOfAnalysis == .thermoElastic {
                        
                        self.resultData.effectiveThermalCoefficients[0] = Double(result.beamModelResult.thermalCoefficients.alpha11) ?? 0
                        self.resultData.effectiveThermalCoefficients[1] = Double(result.beamModelResult.thermalCoefficients.alpha22) ?? 0
                        self.resultData.effectiveThermalCoefficients[2] = Double(result.beamModelResult.thermalCoefficients.alpha33) ?? 0
                        self.resultData.effectiveThermalCoefficients[3] = Double(result.beamModelResult.thermalCoefficients.alpha23) ?? 0
                        self.resultData.effectiveThermalCoefficients[4] = Double(result.beamModelResult.thermalCoefficients.alpha13) ?? 0
                        self.resultData.effectiveThermalCoefficients[5] = Double(result.beamModelResult.thermalCoefficients.alpha12) ?? 0
                        self.resultData.effectiveThermalCoefficients[3] /= 2
                        self.resultData.effectiveThermalCoefficients[4] /= 2
                        self.resultData.effectiveThermalCoefficients[5] /= 2
                        
                    }
                    
                } else if self.analysisSettings.structuralModel == .plate {
                    
                    let A11 = Double(result.plateModelResult.effectivePlateStiffness.A11) ?? 0
                    let A12 = Double(result.plateModelResult.effectivePlateStiffness.A12) ?? 0
                    let A16 = Double(result.plateModelResult.effectivePlateStiffness.A16) ?? 0
                    let A22 = Double(result.plateModelResult.effectivePlateStiffness.A22) ?? 0
                    let A26 = Double(result.plateModelResult.effectivePlateStiffness.A26) ?? 0
                    let A66 = Double(result.plateModelResult.effectivePlateStiffness.A66) ?? 0
                    
                    let B11 = Double(result.plateModelResult.effectivePlateStiffness.B11) ?? 0
                    let B12 = Double(result.plateModelResult.effectivePlateStiffness.B12) ?? 0
                    let B16 = Double(result.plateModelResult.effectivePlateStiffness.B16) ?? 0
                    let B22 = Double(result.plateModelResult.effectivePlateStiffness.B22) ?? 0
                    let B26 = Double(result.plateModelResult.effectivePlateStiffness.B26) ?? 0
                    let B66 = Double(result.plateModelResult.effectivePlateStiffness.B66) ?? 0
                    
                    let D11 = Double(result.plateModelResult.effectivePlateStiffness.D11) ?? 0
                    let D12 = Double(result.plateModelResult.effectivePlateStiffness.D12) ?? 0
                    let D16 = Double(result.plateModelResult.effectivePlateStiffness.D16) ?? 0
                    let D22 = Double(result.plateModelResult.effectivePlateStiffness.D22) ?? 0
                    let D26 = Double(result.plateModelResult.effectivePlateStiffness.D26) ?? 0
                    let D66 = Double(result.plateModelResult.effectivePlateStiffness.D66) ?? 0
                    
                    self.resultData.AMatrix = [A11, A12, A16, A12, A22, A26, A16, A26, A66]
                    self.resultData.BMatrix = [B11, B12, B16, B12, B22, B26, B16, B26, B66]
                    self.resultData.DMatrix = [D11, D12, D16, D12, D22, D26, D16, D26, D66]
                    
                    self.resultData.effectiveInplaneProperties[0] = Double(result.plateModelResult.inPlaneProperties.E1) ?? 0
                    self.resultData.effectiveInplaneProperties[1] = Double(result.plateModelResult.inPlaneProperties.E2) ?? 0
                    self.resultData.effectiveInplaneProperties[2] = Double(result.plateModelResult.inPlaneProperties.G12) ?? 0
                    self.resultData.effectiveInplaneProperties[3] = Double(result.plateModelResult.inPlaneProperties.nu12) ?? 0
                    self.resultData.effectiveInplaneProperties[4] = Double(result.plateModelResult.inPlaneProperties.eta121) ?? 0
                    self.resultData.effectiveInplaneProperties[5] = Double(result.plateModelResult.inPlaneProperties.eta122) ?? 0
                    
                    self.resultData.effectiveFlexuralProperties[0] = Double(result.plateModelResult.flexuralProperties.E1) ?? 0
                    self.resultData.effectiveFlexuralProperties[1] = Double(result.plateModelResult.flexuralProperties.E2) ?? 0
                    self.resultData.effectiveFlexuralProperties[2] = Double(result.plateModelResult.flexuralProperties.G12) ?? 0
                    self.resultData.effectiveFlexuralProperties[3] = Double(result.plateModelResult.flexuralProperties.nu12) ?? 0
                    self.resultData.effectiveFlexuralProperties[4] = Double(result.plateModelResult.flexuralProperties.eta121) ?? 0
                    self.resultData.effectiveFlexuralProperties[5] = Double(result.plateModelResult.flexuralProperties.eta122) ?? 0
                    
                    if self.analysisSettings.structuralSubmodel == .ReissnerMindlinPlateShellModel {
                        self.resultData.CMatrix[0] = Double(result.plateModelResult.effectivePlateStiffnessRefined.C11) ?? 0
                        self.resultData.CMatrix[1] = Double(result.plateModelResult.effectivePlateStiffnessRefined.C12) ?? 0
                        self.resultData.CMatrix[2] = Double(result.plateModelResult.effectivePlateStiffnessRefined.C12) ?? 0
                        self.resultData.CMatrix[3] = Double(result.plateModelResult.effectivePlateStiffnessRefined.C22) ?? 0
                    }
                    
                    if self.analysisSettings.typeOfAnalysis == .thermoElastic {
                        
                        self.resultData.effectiveThermalCoefficients[0] = Double(result.plateModelResult.thermalCoefficients.alpha11) ?? 0
                        self.resultData.effectiveThermalCoefficients[1] = Double(result.plateModelResult.thermalCoefficients.alpha22) ?? 0
                        self.resultData.effectiveThermalCoefficients[2] = Double(result.plateModelResult.thermalCoefficients.alpha33) ?? 0
                        self.resultData.effectiveThermalCoefficients[3] = Double(result.plateModelResult.thermalCoefficients.alpha23) ?? 0
                        self.resultData.effectiveThermalCoefficients[4] = Double(result.plateModelResult.thermalCoefficients.alpha13) ?? 0
                        self.resultData.effectiveThermalCoefficients[5] = Double(result.plateModelResult.thermalCoefficients.alpha12) ?? 0
                        self.resultData.effectiveThermalCoefficients[3] /= 2
                        self.resultData.effectiveThermalCoefficients[4] /= 2
                        self.resultData.effectiveThermalCoefficients[5] /= 2
                        
                    }
                    
                } else if self.analysisSettings.structuralModel == .solid {
                    
                    self.resultData.effectiveSolidStiffnessMatrix[0] = Double(result.solidModelResult.effectiveSolidStiffness.C11) ?? 0
                    self.resultData.effectiveSolidStiffnessMatrix[1] = Double(result.solidModelResult.effectiveSolidStiffness.C12) ?? 0
                    self.resultData.effectiveSolidStiffnessMatrix[2] = Double(result.solidModelResult.effectiveSolidStiffness.C13) ?? 0
                    self.resultData.effectiveSolidStiffnessMatrix[3] = Double(result.solidModelResult.effectiveSolidStiffness.C14) ?? 0
                    self.resultData.effectiveSolidStiffnessMatrix[4] = Double(result.solidModelResult.effectiveSolidStiffness.C15) ?? 0
                    self.resultData.effectiveSolidStiffnessMatrix[5] = Double(result.solidModelResult.effectiveSolidStiffness.C16) ?? 0
                    
                    self.resultData.effectiveSolidStiffnessMatrix[6] = Double(result.solidModelResult.effectiveSolidStiffness.C12) ?? 0
                    self.resultData.effectiveSolidStiffnessMatrix[7] = Double(result.solidModelResult.effectiveSolidStiffness.C22) ?? 0
                    self.resultData.effectiveSolidStiffnessMatrix[8] = Double(result.solidModelResult.effectiveSolidStiffness.C23) ?? 0
                    self.resultData.effectiveSolidStiffnessMatrix[9] = Double(result.solidModelResult.effectiveSolidStiffness.C24) ?? 0
                    self.resultData.effectiveSolidStiffnessMatrix[10] = Double(result.solidModelResult.effectiveSolidStiffness.C25) ?? 0
                    self.resultData.effectiveSolidStiffnessMatrix[11] = Double(result.solidModelResult.effectiveSolidStiffness.C26) ?? 0
                    
                    self.resultData.effectiveSolidStiffnessMatrix[12] = Double(result.solidModelResult.effectiveSolidStiffness.C13) ?? 0
                    self.resultData.effectiveSolidStiffnessMatrix[13] = Double(result.solidModelResult.effectiveSolidStiffness.C23) ?? 0
                    self.resultData.effectiveSolidStiffnessMatrix[14] = Double(result.solidModelResult.effectiveSolidStiffness.C33) ?? 0
                    self.resultData.effectiveSolidStiffnessMatrix[15] = Double(result.solidModelResult.effectiveSolidStiffness.C34) ?? 0
                    self.resultData.effectiveSolidStiffnessMatrix[16] = Double(result.solidModelResult.effectiveSolidStiffness.C35) ?? 0
                    self.resultData.effectiveSolidStiffnessMatrix[17] = Double(result.solidModelResult.effectiveSolidStiffness.C36) ?? 0
                    
                    self.resultData.effectiveSolidStiffnessMatrix[18] = Double(result.solidModelResult.effectiveSolidStiffness.C14) ?? 0
                    self.resultData.effectiveSolidStiffnessMatrix[19] = Double(result.solidModelResult.effectiveSolidStiffness.C24) ?? 0
                    self.resultData.effectiveSolidStiffnessMatrix[20] = Double(result.solidModelResult.effectiveSolidStiffness.C34) ?? 0
                    self.resultData.effectiveSolidStiffnessMatrix[21] = Double(result.solidModelResult.effectiveSolidStiffness.C44) ?? 0
                    self.resultData.effectiveSolidStiffnessMatrix[22] = Double(result.solidModelResult.effectiveSolidStiffness.C45) ?? 0
                    self.resultData.effectiveSolidStiffnessMatrix[23] = Double(result.solidModelResult.effectiveSolidStiffness.C46) ?? 0
                    
                    self.resultData.effectiveSolidStiffnessMatrix[24] = Double(result.solidModelResult.effectiveSolidStiffness.C15) ?? 0
                    self.resultData.effectiveSolidStiffnessMatrix[25] = Double(result.solidModelResult.effectiveSolidStiffness.C25) ?? 0
                    self.resultData.effectiveSolidStiffnessMatrix[26] = Double(result.solidModelResult.effectiveSolidStiffness.C35) ?? 0
                    self.resultData.effectiveSolidStiffnessMatrix[27] = Double(result.solidModelResult.effectiveSolidStiffness.C45) ?? 0
                    self.resultData.effectiveSolidStiffnessMatrix[28] = Double(result.solidModelResult.effectiveSolidStiffness.C55) ?? 0
                    self.resultData.effectiveSolidStiffnessMatrix[29] = Double(result.solidModelResult.effectiveSolidStiffness.C56) ?? 0
                    
                    self.resultData.effectiveSolidStiffnessMatrix[30] = Double(result.solidModelResult.effectiveSolidStiffness.C16) ?? 0
                    self.resultData.effectiveSolidStiffnessMatrix[31] = Double(result.solidModelResult.effectiveSolidStiffness.C26) ?? 0
                    self.resultData.effectiveSolidStiffnessMatrix[32] = Double(result.solidModelResult.effectiveSolidStiffness.C36) ?? 0
                    self.resultData.effectiveSolidStiffnessMatrix[33] = Double(result.solidModelResult.effectiveSolidStiffness.C46) ?? 0
                    self.resultData.effectiveSolidStiffnessMatrix[34] = Double(result.solidModelResult.effectiveSolidStiffness.C56) ?? 0
                    self.resultData.effectiveSolidStiffnessMatrix[35] = Double(result.solidModelResult.effectiveSolidStiffness.C66) ?? 0
                    
                    
                    self.resultData.engineeringConstantsOrthotropic[0] = Double(result.solidModelResult.engineeringConstants.E1) ?? 0
                    self.resultData.engineeringConstantsOrthotropic[1] = Double(result.solidModelResult.engineeringConstants.E2) ?? 0
                    self.resultData.engineeringConstantsOrthotropic[2] = Double(result.solidModelResult.engineeringConstants.E3) ?? 0
                    self.resultData.engineeringConstantsOrthotropic[3] = Double(result.solidModelResult.engineeringConstants.G12) ?? 0
                    self.resultData.engineeringConstantsOrthotropic[4] = Double(result.solidModelResult.engineeringConstants.G13) ?? 0
                    self.resultData.engineeringConstantsOrthotropic[5] = Double(result.solidModelResult.engineeringConstants.G23) ?? 0
                    self.resultData.engineeringConstantsOrthotropic[6] = Double(result.solidModelResult.engineeringConstants.nu12) ?? 0
                    self.resultData.engineeringConstantsOrthotropic[7] = Double(result.solidModelResult.engineeringConstants.nu13) ?? 0
                    self.resultData.engineeringConstantsOrthotropic[8] = Double(result.solidModelResult.engineeringConstants.nu23) ?? 0
                    
                    if self.analysisSettings.typeOfAnalysis == .thermoElastic {
                        
                        self.resultData.effectiveThermalCoefficients[0] = Double(result.solidModelResult.thermalCoefficients.alpha11) ?? 0
                        self.resultData.effectiveThermalCoefficients[1] = Double(result.solidModelResult.thermalCoefficients.alpha22) ?? 0
                        self.resultData.effectiveThermalCoefficients[2] = Double(result.solidModelResult.thermalCoefficients.alpha33) ?? 0
                        self.resultData.effectiveThermalCoefficients[3] = Double(result.solidModelResult.thermalCoefficients.alpha23) ?? 0
                        self.resultData.effectiveThermalCoefficients[4] = Double(result.solidModelResult.thermalCoefficients.alpha13) ?? 0
                        self.resultData.effectiveThermalCoefficients[5] = Double(result.solidModelResult.thermalCoefficients.alpha12) ?? 0
                        self.resultData.effectiveThermalCoefficients[3] /= 2
                        self.resultData.effectiveThermalCoefficients[4] /= 2
                        self.resultData.effectiveThermalCoefficients[5] /= 2
                        
                    }
                    
                }
                
            case .failure(let swiftcompCalculationError):
                
                print("Failed to fetch courses:", swiftcompCalculationError.localizedDescription)
                
                self.swiftCompCalculationError = swiftcompCalculationError
                
            }
            
            group.leave()
        }
        
        group.wait()
        
        if self.swiftCompCalculationError == .networkError {
            return .networkError
        } else if self.swiftCompCalculationError == .parseJSONError {
            return .parseJSONError
        } else if self.swiftCompCalculationError == .timeOutError {
            return .timeOutError
        }
        
        return .success
        
    }
    
}
