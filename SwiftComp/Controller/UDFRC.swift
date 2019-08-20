//
//  UDFRC.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 10/29/17.
//  Copyright © 2017 Banghua Zhao. All rights reserved.
//

import UIKit
import Accelerate
import CoreData
import JGProgressHUD

class UDFRC: UIViewController, UINavigationControllerDelegate, FiberMaterialDataBaseDelegate, MatrixMaterialDataBaseDelegate {
    
    // Global variables
    
    var typeOfAnalysis : typeOfAnalysis = .elastic
    var fiberMaterialType : materialType = .isotropic
    var matrixMaterialType : materialType = .isotropic
    
    var materialPropertyName = MaterialPropertyName()
    var materialPropertyPlaceHolder = MaterialPropertyPlaceHolder()
    
    // Transition animation
    
    let transition = CircleTransitionDesign()
    var touchLocation: CGPoint = CGPoint.zero
    
    // Core data
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var userSavedFiberMaterials = [UserFiberMaterial]()
    var userSavedMatrixMaterials = [UserMatrixMaterial]()
    
    // layout
    
    var scrollView: UIScrollView = UIScrollView()
    
    // Navigation bar
    
    let calculationButton = UIButton()
    var UDFRCResultViewController = UDFRCResult()
    
    var engineeringConstantsTransverselyIsotropic = [Double](repeating: 0.0, count: 5)
    var engineeringConstantsTransverselyIsotropicThermal = [Double](repeating: 0.0, count: 2)
    
    var engineeringConstantsOrthotropic = [Double](repeating: 0.0, count: 9)
    var engineeringConstantsOrthotropicThermal = [Double](repeating: 0.0, count: 3)
    
    var planeStressReducedCompliance = [Double](repeating: 0.0, count: 9)
    var planeStressReducedStiffness = [Double](repeating: 0.0, count: 9)
    
    // first section: Method
    
    var methodView: UIView = UIView()
    var methodLabelButton: UIButton = UIButton()
    var methodDataBaseAlterController : UIAlertController!
    
    // second section: Type of Analysis
    
    var typeOfAnalysisView: UIView = UIView()
    var typeOfAnalysisLabelButton: UIButton = UIButton()
    var typeOfAnalysisDataBaseAlterController : UIAlertController!
    
    // third section: Geometry

    var geometryView: UIView = UIView()
    var geometryLabel: UILabel = UILabel()
    var geometrySquarePackView: UIView = UIView()
    var geometrySquare: CAShapeLayer = CAShapeLayer()
    var fiberGeometry: CAShapeLayer = CAShapeLayer()
    var fiberPositionOffset: CGFloat = CGFloat(0.0)
    var fiberGeometryPath: UIBezierPath = UIBezierPath()
    var volumeFractionSlider: UISlider = UISlider()
    
    // fourth section: Fiber material
    
    var fiberMaterialView: UIView = UIView()
    var fiberMaterialDataBase: UIButton = UIButton()
    var UDFRCFiberMaterialDataBaseViewController = UDFRCFiberMaterialDataBase()
    let fiberMaterialTypeSegementedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Isotropic", "Transversely", "Orthotropic"])
        sc.selectedSegmentIndex = 0
        return sc
    }()
    var fiberMaterialCard: UIView = UIView()
    var fiberMaterialNameLabel: UILabel = UILabel()
    var fiberMaterialPropertiesLabel: [UILabel] = []
    var fiberMaterialPropertiesTextField: [UITextField] = []
    var saveFiberMaterialButton: UIButton = UIButton()
    
    
    // fifth section: Matrix material
    
    var matrixMaterialView: UIView = UIView()
    var matrixMaterialDataBase: UIButton = UIButton()
    var UDFRCMatrixMaterialDataBaseViewController = UDFRCMatrixMaterialDataBase()
    let matrixMaterialTypeSegementedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Isotropic", "Transversely", "Orthotropic"])
        sc.selectedSegmentIndex = 0
        return sc
    }()
    var matrixMaterialCard: UIView = UIView()
    var matrixMaterialNameLabel: UILabel = UILabel()
    var matrixMaterialPropertiesLabel: [UILabel] = []
    var matrixMaterialPropertiesTextField: [UITextField] = []
    var saveMatrixMaterialButton: UIButton = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        self.navigationController?.delegate = self
        
        editNavigationBar()
        
        createLayout()
        
        loadCoreData()
        
        createActionSheet()
        
        changeMaterialDataField()
        
        hideKeyboardWhenTappedAround()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        loadCoreData()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        transition.startingPoint = touchLocation
        
        if operation == .push {
            transition.transitionMode = .present
            switch toVC {
            case UDFRCFiberMaterialDataBaseViewController:
                transition.circleColor = fiberMaterialDataBase.backgroundColor!
            case UDFRCMatrixMaterialDataBaseViewController:
                transition.circleColor = matrixMaterialDataBase.backgroundColor!
            default:
                return nil
            }
        } else {
            transition.transitionMode = .dismiss
            switch fromVC {
            case UDFRCFiberMaterialDataBaseViewController:
                transition.circleColor = fiberMaterialDataBase.backgroundColor!
            case UDFRCMatrixMaterialDataBaseViewController:
                transition.circleColor = matrixMaterialDataBase.backgroundColor!
            default:
                return nil
            }
        }
        return transition
    }
    
    
    // MARK: Edit navigation bar
    
    func editNavigationBar() {
        
        navigationItem.title = "UDFRC"
        
        calculationButton.calculateButtonDesign()
        calculationButton.addTarget(self, action: #selector(calculate), for: .touchUpInside)
        calculationButton.widthAnchor.constraint(equalToConstant: calculationButton.intrinsicContentSize.width + 20).isActive = true
        let item = UIBarButtonItem(customView: calculationButton)
        self.navigationItem.setRightBarButtonItems([item], animated: true)
    }
    
    @objc func calculate(_ sender: UIButton, event: UIEvent) {
        
        sender.flash()
        
        UDFRCResultViewController = UDFRCResult()
        
        let touch = event.touches(for: sender)?.first
        touchLocation = touch?.location(in: self.view) ?? CGPoint.zero
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Calculating"
        hud.show(in: self.view)
        
        let start = DispatchTime.now()
        
        if self.calculateResult() {
            
            UDFRCResultViewController.typeOfAnalysis = self.typeOfAnalysis
            
            if fiberMaterialType == .orthotropic || matrixMaterialType == .orthotropic {
                UDFRCResultViewController.resultMaterialType = .orthotropic
                for i in 0...engineeringConstantsOrthotropic.count-1 {
                    UDFRCResultViewController.engineeringConstantsOrthotropic[i] = self.engineeringConstantsOrthotropic[i]
                }
                
                for i in 0...engineeringConstantsOrthotropicThermal.count-1 {
                    UDFRCResultViewController.engineeringConstantsOrthotropicThermal[i] = self.engineeringConstantsOrthotropicThermal[i]
                }
            } else {
                UDFRCResultViewController.resultMaterialType = .transverselyIsotropic
                for i in 0...engineeringConstantsTransverselyIsotropic.count-1 {
                    UDFRCResultViewController.engineeringConstantsTransverselyIsotropic[i] = self.engineeringConstantsTransverselyIsotropic[i]
                }
                
                for i in 0...engineeringConstantsTransverselyIsotropicThermal.count-1 {
                    UDFRCResultViewController.engineeringConstantsTransverselyIsotropicThermal[i] = self.engineeringConstantsTransverselyIsotropicThermal[i]
                }
            }
            
            for i in 0...8 {
                UDFRCResultViewController.planeStressReducedCompliance[i] = self.planeStressReducedCompliance[i]
            }
            
            for i in 0...8 {
                UDFRCResultViewController.planeStressReducedStiffness[i] = self.planeStressReducedStiffness[i]
            }
            
            let end = DispatchTime.now()
            
            let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds // <<<<< Difference in nano seconds (UInt64)
            let timeInterval = Double(nanoTime) / 1_000_000_000
            
            if timeInterval >= 1 {
                UIView.animate(withDuration: 0.1, animations: {
                    hud.textLabel.text = "Finished"
                    hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                })
                hud.dismiss(afterDelay: 0.5)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(600)) {
                    self.navigationController?.pushViewController(self.UDFRCResultViewController, animated: true)
                }
            } else {
                hud.dismiss(afterDelay: 0.0)
                self.navigationController?.pushViewController(self.UDFRCResultViewController, animated: true)
            }
        } else {
            hud.dismiss(afterDelay: 0.0)
        }
        
    }
    
    
    // MARK: Create layout
    
    func createLayout() {
        
        self.view.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        scrollView.addSubview(methodView)
        scrollView.addSubview(typeOfAnalysisView)
        scrollView.addSubview(geometryView)
        scrollView.addSubview(fiberMaterialView)
        scrollView.addSubview(matrixMaterialView)
        
        
        // first section
        
        creatViewCard(viewCard: methodView, title: "Method", aboveConstraint: scrollView.topAnchor, under: scrollView)
        methodView.addSubview(methodLabelButton)
        
        methodLabelButton.setTitle("Voigt Rules of Mixture", for: UIControl.State.normal)
        methodLabelButton.addTarget(self, action: #selector(changeMethodLabel(_:)), for: .touchUpInside)
        methodLabelButton.methodButtonDesign()
        methodLabelButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        methodLabelButton.widthAnchor.constraint(greaterThanOrEqualToConstant: methodLabelButton.intrinsicContentSize.width + 40).isActive = true
        methodLabelButton.topAnchor.constraint(equalTo: methodView.topAnchor, constant: 40).isActive = true
        methodLabelButton.centerXAnchor.constraint(equalTo: methodView.centerXAnchor).isActive = true
        methodLabelButton.bottomAnchor.constraint(equalTo: methodView.bottomAnchor, constant: -20).isActive = true
        
        // second section
        
        creatViewCard(viewCard: typeOfAnalysisView, title: "Type of Analysis", aboveConstraint: methodView.bottomAnchor, under: scrollView)
        typeOfAnalysisView.addSubview(typeOfAnalysisLabelButton)
        
        typeOfAnalysisLabelButton.setTitle("Elastic Analysis", for: UIControl.State.normal)
        typeOfAnalysisLabelButton.addTarget(self, action: #selector(changeTypeOfAnalysisLabel(_:)), for: .touchUpInside)
        typeOfAnalysisLabelButton.methodButtonDesign()
        typeOfAnalysisLabelButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        typeOfAnalysisLabelButton.widthAnchor.constraint(greaterThanOrEqualToConstant: typeOfAnalysisLabelButton.intrinsicContentSize.width + 100).isActive = true
        typeOfAnalysisLabelButton.topAnchor.constraint(equalTo: typeOfAnalysisView.topAnchor, constant: 40).isActive = true
        typeOfAnalysisLabelButton.centerXAnchor.constraint(equalTo: typeOfAnalysisView.centerXAnchor).isActive = true
        typeOfAnalysisLabelButton.bottomAnchor.constraint(equalTo: typeOfAnalysisView.bottomAnchor, constant: -20).isActive = true
        
        
        
        // second section
        
        creatViewCard(viewCard: geometryView, title: "Geometry", aboveConstraint: typeOfAnalysisView.bottomAnchor, under: scrollView)
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
        volumeFractionSlider.bottomAnchor.constraint(equalTo: geometryView.bottomAnchor, constant: -20).isActive = true

        
        // third secion
        
        creatViewCard(viewCard: fiberMaterialView, title: "Fiber Material", aboveConstraint: geometryView.bottomAnchor, under: scrollView)
        fiberMaterialView.addSubview(fiberMaterialDataBase)
        fiberMaterialView.addSubview(saveFiberMaterialButton)
        fiberMaterialView.addSubview(fiberMaterialTypeSegementedControl)
        fiberMaterialView.addSubview(fiberMaterialCard)
        
        fiberMaterialDataBase.dataBaseButtonDesign(title: "\u{2630} Database", under: fiberMaterialView)
        fiberMaterialDataBase.addTarget(self, action: #selector(enterFiberMaterialDataBase), for: .touchUpInside)
        
        saveFiberMaterialButton.saveButtonDesign(title: "\u{21E9} Save", under: fiberMaterialView)
        saveFiberMaterialButton.addTarget(self, action: #selector(saveFiberMaterial), for: .touchUpInside)
        
        
        fiberMaterialTypeSegementedControl.translatesAutoresizingMaskIntoConstraints = false
        fiberMaterialTypeSegementedControl.addTarget(self, action: #selector(changeFiberMaterialType), for: .valueChanged)
        fiberMaterialTypeSegementedControl.widthAnchor.constraint(equalTo: fiberMaterialView.widthAnchor, multiplier: 0.8).isActive = true
        fiberMaterialTypeSegementedControl.topAnchor.constraint(equalTo: fiberMaterialDataBase.bottomAnchor, constant: 8).isActive = true
        fiberMaterialTypeSegementedControl.centerXAnchor.constraint(equalTo: fiberMaterialView.centerXAnchor).isActive = true
        
        fiberMaterialNameLabel.text = "E-Glass"
        createMaterialCard(materialCard: &fiberMaterialCard, materialName: fiberMaterialNameLabel, label: &fiberMaterialPropertiesLabel, value: &fiberMaterialPropertiesTextField, aboveConstraint: fiberMaterialTypeSegementedControl.bottomAnchor, under: fiberMaterialView, typeOfAnalysis: typeOfAnalysis, materialType: .isotropic)

        fiberMaterialCard.bottomAnchor.constraint(equalTo: fiberMaterialView.bottomAnchor, constant: -20).isActive = true
        
        
        // fourth secion
        
        creatViewCard(viewCard: matrixMaterialView, title: "Matrix Material", aboveConstraint: fiberMaterialView.bottomAnchor, under: scrollView)
        matrixMaterialView.addSubview(matrixMaterialDataBase)
        matrixMaterialView.addSubview(saveMatrixMaterialButton)
        matrixMaterialView.addSubview(matrixMaterialTypeSegementedControl)
        matrixMaterialView.addSubview(matrixMaterialCard)
        
        matrixMaterialDataBase.dataBaseButtonDesign(title: "\u{2630} Database", under: matrixMaterialView)
        matrixMaterialDataBase.addTarget(self, action: #selector(enterMatrixMaterialDataBase), for: .touchUpInside)
        
        saveMatrixMaterialButton.saveButtonDesign(title: "\u{21E9} Save", under: matrixMaterialView)
        saveMatrixMaterialButton.addTarget(self, action: #selector(saveMatrixMaterial), for: .touchUpInside)
        
        
        matrixMaterialTypeSegementedControl.translatesAutoresizingMaskIntoConstraints = false
        matrixMaterialTypeSegementedControl.addTarget(self, action: #selector(changeMatrixMaterialType), for: .valueChanged)
        matrixMaterialTypeSegementedControl.widthAnchor.constraint(equalTo: matrixMaterialView.widthAnchor, multiplier: 0.8).isActive = true
        matrixMaterialTypeSegementedControl.topAnchor.constraint(equalTo: matrixMaterialDataBase.bottomAnchor, constant: 8).isActive = true
        matrixMaterialTypeSegementedControl.centerXAnchor.constraint(equalTo: matrixMaterialView.centerXAnchor).isActive = true
        
        matrixMaterialNameLabel.text = "Epoxy"
        createMaterialCard(materialCard: &matrixMaterialCard, materialName: matrixMaterialNameLabel, label: &matrixMaterialPropertiesLabel, value: &matrixMaterialPropertiesTextField, aboveConstraint: matrixMaterialTypeSegementedControl.bottomAnchor, under: matrixMaterialView, typeOfAnalysis: typeOfAnalysis, materialType: .isotropic)
        
        matrixMaterialCard.bottomAnchor.constraint(equalTo: matrixMaterialView.bottomAnchor, constant: -20).isActive = true
        
        matrixMaterialView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20).isActive = true

    }
    
    
    
    // First section: Change method
    
    @objc func changeMethodLabel(_ sender: UIButton) {
        sender.flash()
        self.present(methodDataBaseAlterController, animated: true, completion: nil)
    }
    
    
    // Second section
    
    @objc func changeTypeOfAnalysisLabel(_ sender: UIButton) {
        sender.flash()
        self.present(typeOfAnalysisDataBaseAlterController, animated: true, completion: nil)
        
    }
    
    
    // Third section: Volume fraction
    
    @objc func changeVolumeFraction(_ sender: UISlider) {
        geometryLabel.text = "Fiber Volume Fraction: " + String(format: "%.2f", sender.value)
        
        if Double(sender.value) < 0.7850 {
            fiberPositionOffset = CGFloat(50-sqrt(10000*Double(sender.value)/Double.pi))
            fiberGeometryPath = UIBezierPath(ovalIn: CGRect(x:  geometrySquare.frame.minX + fiberPositionOffset, y:  geometrySquare.frame.minY + fiberPositionOffset, width: CGFloat(2*sqrt(10000*Double(sender.value)/Double.pi)), height: CGFloat(2*sqrt(10000*Double(sender.value)/Double.pi))))
        } else {
            fiberPositionOffset = CGFloat(50-100*Double(sender.value)/2)
            fiberGeometryPath = UIBezierPath(rect: CGRect(x: geometrySquare.frame.minX + fiberPositionOffset, y:  geometrySquare.frame.minY + fiberPositionOffset, width: CGFloat(100*Double(sender.value)), height: CGFloat(100*Double(sender.value))))
        }
        fiberGeometry.path = fiberGeometryPath.cgPath
    
    }
    
    
    // Fourth section: Fiber material
    
    @objc func enterFiberMaterialDataBase(_ sender: UIButton, event: UIEvent) {
        sender.flash()
        
        let touch = event.touches(for: sender)?.first
        touchLocation = touch?.location(in: self.view) ?? CGPoint.zero
        
        UDFRCFiberMaterialDataBaseViewController = UDFRCFiberMaterialDataBase()
        
        UDFRCFiberMaterialDataBaseViewController.delegate = self
        
        self.navigationController?.pushViewController(UDFRCFiberMaterialDataBaseViewController, animated: true)
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
                case "Isotropic":
                    fiberMaterialType = .isotropic
                case "Transversely Isotropic":
                    fiberMaterialType = .transverselyIsotropic
                case "orthotropic":
                    fiberMaterialType = .orthotropic
                default:
                    continue
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
        
        createMaterialCard(materialCard: &self.fiberMaterialCard, materialName: self.fiberMaterialNameLabel, label: &self.fiberMaterialPropertiesLabel, value: &self.fiberMaterialPropertiesTextField, aboveConstraint: self.fiberMaterialTypeSegementedControl.bottomAnchor, under: self.fiberMaterialView, typeOfAnalysis: typeOfAnalysis, materialType: fiberMaterialType)
        
        self.fiberMaterialCard.bottomAnchor.constraint(equalTo: self.fiberMaterialView.bottomAnchor, constant: -20).isActive = true
        
        self.changeMaterialDataField()
        
    }
    
    @objc func saveFiberMaterial(_ sender: UIButton) {
        
        sender.flash()
        
        let inputAlter = UIAlertController(title: "Save Material", message: "Enter the material name.", preferredStyle: UIAlertController.Style.alert)
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
                for i in 0...self.materialPropertyName.isotropic.count - 1 {
                    if let valueString = self.fiberMaterialPropertiesTextField[i].text {
                        if let value = Double(valueString) {
                            userFiberMaterialDictionary[self.materialPropertyName.isotropic[i]] = value
                        } else {
                            self.present(wrongMaterialValueAlter, animated: true, completion: nil)
                            return
                        }
                    } else {
                        self.present(emptyMaterialValueAlter, animated: true, completion: nil)
                        return
                    }
                }
                if self.typeOfAnalysis == .thermalElatic {
                    for i in 0...self.materialPropertyName.isotropicThermal.count - 1 {
                        if let valueString = self.fiberMaterialPropertiesTextField[i + self.materialPropertyName.isotropic.count].text {
                            if let value = Double(valueString) {
                                userFiberMaterialDictionary[self.materialPropertyName.isotropicThermal[i]] = value
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
                for i in 0...self.materialPropertyName.transverselyIsotropic.count - 1 {
                    if let valueString = self.fiberMaterialPropertiesTextField[i].text {
                        if let value = Double(valueString) {
                            userFiberMaterialDictionary[self.materialPropertyName.transverselyIsotropic[i]] = value
                        } else {
                            self.present(wrongMaterialValueAlter, animated: true, completion: nil)
                            return
                        }
                    } else {
                        self.present(emptyMaterialValueAlter, animated: true, completion: nil)
                        return
                    }
                }
                if self.typeOfAnalysis == .thermalElatic {
                    for i in 0...self.materialPropertyName.transverselyIsotropicThermal.count - 1 {
                        if let valueString = self.fiberMaterialPropertiesTextField[i + self.materialPropertyName.transverselyIsotropic.count].text {
                            if let value = Double(valueString) {
                                userFiberMaterialDictionary[self.materialPropertyName.transverselyIsotropicThermal[i]] = value
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
                userFiberMaterialType = "orthotropic"
                for i in 0...self.materialPropertyName.orthotropic.count - 1 {
                    if let valueString = self.fiberMaterialPropertiesTextField[i].text {
                        if let value = Double(valueString) {
                            userFiberMaterialDictionary[self.materialPropertyName.orthotropic[i]] = value
                        } else {
                            self.present(wrongMaterialValueAlter, animated: true, completion: nil)
                            return
                        }
                    } else {
                        self.present(emptyMaterialValueAlter, animated: true, completion: nil)
                        return
                    }
                }
                if self.typeOfAnalysis == .thermalElatic {
                    for i in 0...self.materialPropertyName.orthotropicThermal.count - 1 {
                        if let valueString = self.fiberMaterialPropertiesTextField[i + self.materialPropertyName.orthotropic.count].text {
                            if let value = Double(valueString) {
                                userFiberMaterialDictionary[self.materialPropertyName.orthotropicThermal[i]] = value
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
            
            let currentUserFiberMaterial = UserFiberMaterial(context: self.context)
            currentUserFiberMaterial.setValue(userMaterialName, forKey: "name")
            currentUserFiberMaterial.setValue(userFiberMaterialType, forKey: "type")
            currentUserFiberMaterial.setValue(userFiberMaterialDictionary, forKey: "properties")
            
            do {
                try self.context.save()
                self.loadCoreData()
                
                // material card saving animation
                
                let MaterialCardImage: UIImage = UIImage(named: "MaterialCardImg")!
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
    
    
    // Fifth section: Matrix material
    
    @objc func enterMatrixMaterialDataBase(_ sender: UIButton, event: UIEvent) {
        sender.flash()
        
        let touch = event.touches(for: sender)?.first
        touchLocation = touch?.location(in: self.view) ?? CGPoint.zero
        
        UDFRCMatrixMaterialDataBaseViewController = UDFRCMatrixMaterialDataBase()
        
        UDFRCMatrixMaterialDataBaseViewController.delegate = self
        
        self.navigationController?.pushViewController(UDFRCMatrixMaterialDataBaseViewController, animated: true)
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
                case "Isotropic":
                    matrixMaterialType = .isotropic
                case "Transversely Isotropic":
                    matrixMaterialType = .transverselyIsotropic
                case "orthotropic":
                    matrixMaterialType = .orthotropic
                default:
                    continue
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
        
        createMaterialCard(materialCard: &self.matrixMaterialCard, materialName: self.matrixMaterialNameLabel, label: &self.matrixMaterialPropertiesLabel, value: &self.matrixMaterialPropertiesTextField, aboveConstraint: self.matrixMaterialTypeSegementedControl.bottomAnchor, under: self.matrixMaterialView, typeOfAnalysis: typeOfAnalysis, materialType: matrixMaterialType)
        
        self.matrixMaterialCard.bottomAnchor.constraint(equalTo: self.matrixMaterialView.bottomAnchor, constant: -20).isActive = true
        
        self.changeMaterialDataField()
        
    }
    
    
    @objc func saveMatrixMaterial(_ sender: UIButton) {
        sender.flash()
        
        let inputAlter = UIAlertController(title: "Save Material", message: "Enter the material name.", preferredStyle: UIAlertController.Style.alert)
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
                for i in 0...self.materialPropertyName.isotropic.count - 1 {
                    if let valueString = self.matrixMaterialPropertiesTextField[i].text {
                        if let value = Double(valueString) {
                            userMatrixMaterialDictionary[self.materialPropertyName.isotropic[i]] = value
                        } else {
                            self.present(wrongMaterialValueAlter, animated: true, completion: nil)
                            return
                        }
                    } else {
                        self.present(emptyMaterialValueAlter, animated: true, completion: nil)
                        return
                    }
                }
                if self.typeOfAnalysis == .thermalElatic {
                    for i in 0...self.materialPropertyName.isotropicThermal.count - 1 {
                        if let valueString = self.matrixMaterialPropertiesTextField[i + self.materialPropertyName.isotropic.count].text {
                            if let value = Double(valueString) {
                                userMatrixMaterialDictionary[self.materialPropertyName.isotropicThermal[i]] = value
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
                for i in 0...self.materialPropertyName.transverselyIsotropic.count - 1 {
                    if let valueString = self.matrixMaterialPropertiesTextField[i].text {
                        if let value = Double(valueString) {
                            userMatrixMaterialDictionary[self.materialPropertyName.transverselyIsotropic[i]] = value
                        } else {
                            self.present(wrongMaterialValueAlter, animated: true, completion: nil)
                            return
                        }
                    } else {
                        self.present(emptyMaterialValueAlter, animated: true, completion: nil)
                        return
                    }
                }
                if self.typeOfAnalysis == .thermalElatic {
                    for i in 0...self.materialPropertyName.transverselyIsotropicThermal.count - 1 {
                        if let valueString = self.matrixMaterialPropertiesTextField[i + self.materialPropertyName.transverselyIsotropic.count].text {
                            if let value = Double(valueString) {
                                userMatrixMaterialDictionary[self.materialPropertyName.transverselyIsotropicThermal[i]] = value
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
                userMatrixMaterialType = "orthotropic"
                for i in 0...self.materialPropertyName.orthotropic.count - 1 {
                    if let valueString = self.matrixMaterialPropertiesTextField[i].text {
                        if let value = Double(valueString) {
                            userMatrixMaterialDictionary[self.materialPropertyName.orthotropic[i]] = value
                        } else {
                            self.present(wrongMaterialValueAlter, animated: true, completion: nil)
                            return
                        }
                    } else {
                        self.present(emptyMaterialValueAlter, animated: true, completion: nil)
                        return
                    }
                }
                if self.typeOfAnalysis == .thermalElatic {
                    for i in 0...self.materialPropertyName.orthotropicThermal.count - 1 {
                        if let valueString = self.matrixMaterialPropertiesTextField[i + self.materialPropertyName.orthotropic.count].text {
                            if let value = Double(valueString) {
                                userMatrixMaterialDictionary[self.materialPropertyName.orthotropicThermal[i]] = value
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
            
            let currentUserMatrixMaterial = UserMatrixMaterial(context: self.context)
            currentUserMatrixMaterial.setValue(userMaterialName, forKey: "name")
            currentUserMatrixMaterial.setValue(userMatrixMaterialType, forKey: "type")
            currentUserMatrixMaterial.setValue(userMatrixMaterialDictionary, forKey: "properties")
            
            do {
                try self.context.save()
                self.loadCoreData()
                
                // material card saving animation
                
                let MaterialCardImage: UIImage = UIImage(named: "MaterialCardImg")!
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
    
    
    // MARK: Create action sheet
    
    func createActionSheet() {
        
        methodDataBaseAlterController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        let s0 = UIAlertAction(title: "Voigt Rules of Mixture", style: UIAlertAction.Style.default) { (action) -> Void in
            self.methodLabelButton.setTitle("Voigt Rules of Mixture", for: UIControl.State.normal)
        }
        
        let s1 = UIAlertAction(title: "Reuss Rules of Mixture", style: UIAlertAction.Style.default) { (action) -> Void in
            self.methodLabelButton.setTitle("Reuss Rules of Mixture", for: UIControl.State.normal)
        }
        
        let s2 = UIAlertAction(title: "Hybrid Rules of Mixture", style: UIAlertAction.Style.default) { (action) -> Void in
            self.methodLabelButton.setTitle("Hybrid Rules of Mixture", for: UIControl.State.normal)
        }
  
        methodDataBaseAlterController.addAction(s0)
        methodDataBaseAlterController.addAction(s1)
        methodDataBaseAlterController.addAction(s2)
        methodDataBaseAlterController.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
        typeOfAnalysisDataBaseAlterController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        let t0 = UIAlertAction(title: "Elastic Analysis", style: UIAlertAction.Style.default) { (action) -> Void in
            self.typeOfAnalysisLabelButton.setTitle("Elastic Analysis", for: UIControl.State.normal)
            self.typeOfAnalysisLabelButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            self.typeOfAnalysis = .elastic
            self.changeTypeOfAnalysis(typeOfAnalysis: .elastic)
        }
        
        let t1 = UIAlertAction(title: "Thermoelastic Analysis", style: UIAlertAction.Style.default) { (action) -> Void in
            self.typeOfAnalysisLabelButton.setTitle("Thermoelastic Analysis", for: UIControl.State.normal)
            self.typeOfAnalysisLabelButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            self.typeOfAnalysis = .thermalElatic
            self.changeTypeOfAnalysis(typeOfAnalysis: .thermalElatic)
        }
        
        typeOfAnalysisDataBaseAlterController.addAction(t0)
        typeOfAnalysisDataBaseAlterController.addAction(t1)
        typeOfAnalysisDataBaseAlterController.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
    }
    
    // change type of analysis
    
    func changeTypeOfAnalysis(typeOfAnalysis: typeOfAnalysis) {
        
        createMaterialCard(materialCard: &self.fiberMaterialCard, materialName: self.fiberMaterialNameLabel, label: &self.fiberMaterialPropertiesLabel, value: &self.fiberMaterialPropertiesTextField, aboveConstraint: self.fiberMaterialTypeSegementedControl.bottomAnchor, under: self.fiberMaterialView, typeOfAnalysis: typeOfAnalysis, materialType: fiberMaterialType)

        self.fiberMaterialCard.bottomAnchor.constraint(equalTo: self.fiberMaterialView.bottomAnchor, constant: -20).isActive = true
        
        createMaterialCard(materialCard: &self.matrixMaterialCard, materialName: self.matrixMaterialNameLabel, label: &self.matrixMaterialPropertiesLabel, value: &self.matrixMaterialPropertiesTextField, aboveConstraint: self.matrixMaterialTypeSegementedControl.bottomAnchor, under: self.matrixMaterialView, typeOfAnalysis: typeOfAnalysis, materialType: matrixMaterialType)
        
        self.matrixMaterialCard.bottomAnchor.constraint(equalTo: self.matrixMaterialView.bottomAnchor, constant: -20).isActive = true
        
        self.changeMaterialDataField()
        
    }
    
    
    // MARK: Change material data fields
    
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
                    if typeOfAnalysis == .thermalElatic {
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
                    if typeOfAnalysis == .thermalElatic {
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
                    if typeOfAnalysis == .thermalElatic {
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
                    if typeOfAnalysis == .thermalElatic {
                        for i in 0...materialPropertyName.isotropicThermal.count - 1 {
                            fiberMaterialPropertiesTextField[i+materialPropertyName.isotropic.count].text = ""
                        }
                    }
                } else if fiberMaterialType == .transverselyIsotropic {
                    for i in 0...materialPropertyName.transverselyIsotropic.count - 1 {
                        fiberMaterialPropertiesTextField[i].text = ""
                    }
                    if typeOfAnalysis == .thermalElatic {
                        for i in 0...materialPropertyName.transverselyIsotropicThermal.count - 1 {
                            fiberMaterialPropertiesTextField[i+materialPropertyName.transverselyIsotropic.count].text = ""
                        }
                    }
                } else if fiberMaterialType == .orthotropic {
                    for i in 0...materialPropertyName.orthotropic.count - 1 {
                        fiberMaterialPropertiesTextField[i].text = ""
                    }
                    if typeOfAnalysis == .thermalElatic {
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
                    if typeOfAnalysis == .thermalElatic {
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
                    if typeOfAnalysis == .thermalElatic {
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
                    if typeOfAnalysis == .thermalElatic {
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
                    if typeOfAnalysis == .thermalElatic {
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
                    if typeOfAnalysis == .thermalElatic {
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
                    if typeOfAnalysis == .thermalElatic {
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
                    if typeOfAnalysis == .thermalElatic {
                        for i in 0...materialPropertyName.isotropicThermal.count - 1 {
                            matrixMaterialPropertiesTextField[i+materialPropertyName.isotropic.count].text = ""
                        }
                    }
                } else if matrixMaterialType == .transverselyIsotropic {
                    for i in 0...materialPropertyName.transverselyIsotropic.count - 1 {
                        matrixMaterialPropertiesTextField[i].text = ""
                    }
                    if typeOfAnalysis == .thermalElatic {
                        for i in 0...materialPropertyName.transverselyIsotropicThermal.count - 1 {
                            matrixMaterialPropertiesTextField[i+materialPropertyName.transverselyIsotropic.count].text = ""
                        }
                    }
                } else if matrixMaterialType == .orthotropic {
                    for i in 0...materialPropertyName.orthotropic.count - 1 {
                        matrixMaterialPropertiesTextField[i].text = ""
                    }
                    if typeOfAnalysis == .thermalElatic {
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
                    if typeOfAnalysis == .thermalElatic {
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
                    if typeOfAnalysis == .thermalElatic {
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
                    if typeOfAnalysis == .thermalElatic {
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
    
    

    
    
    
    // MARK: Calculate result
    
    func calculateResult() -> Bool {
        
        // Handle material and calculate
        
        let wrongMaterialValue = UIAlertController(title: "Wrong Material Values", message: "Please double check!", preferredStyle: UIAlertController.Style.alert)
        wrongMaterialValue.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        var Sf : [Double] = []
        var Sm : [Double] = []
        var SHf : [Double] = []
        var SHm : [Double] = []
        
        if fiberMaterialType == .isotropic {
            guard let ef1 = Double(fiberMaterialPropertiesTextField[0].text!) else {
                self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            guard let ef2 = Double(fiberMaterialPropertiesTextField[0].text!) else {            self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            guard let ef3 = Double(fiberMaterialPropertiesTextField[0].text!) else {            self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            guard let vf12 = Double(fiberMaterialPropertiesTextField[1].text!) else {            self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            guard let vf13 = Double(fiberMaterialPropertiesTextField[1].text!) else {            self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            guard let vf23 = Double(fiberMaterialPropertiesTextField[1].text!) else {            self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            let gf12 = ef1 / (2*(1+vf12))
            let gf13 = ef1 / (2*(1+vf12))
            let gf23 = ef1 / (2*(1+vf12))
            Sf = [1/ef1, -vf12/ef1, -vf13/ef1, 0, 0, 0, -vf12/ef1, 1/ef2, -vf23/ef2, 0, 0, 0, -vf12/ef1, -vf23/ef2, 1/ef3, 0, 0, 0, 0, 0, 0, 1/gf23, 0, 0, 0, 0, 0, 0, 1/gf13, 0, 0, 0, 0, 0, 0, 1/gf12]
            SHf = [ef1, vf12, vf13, 0, 0, 0, -vf12, 1/ef2 - vf12*vf12/ef1, -vf23/ef2 - vf13*vf13/ef1, 0, 0, 0, -vf23, -vf23/ef2 - vf12*vf12/ef1, 1/ef3 - vf13*vf13/ef1, 0, 0, 0, 0, 0, 0, 1/gf23, 0, 0, 0, 0, 0, 0, 1/gf13, 0, 0, 0, 0, 0, 0, 1/gf12]
            
        } else if fiberMaterialType == .transverselyIsotropic {
            guard let ef1 = Double(fiberMaterialPropertiesTextField[0].text!) else {            self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            guard let ef2 = Double(fiberMaterialPropertiesTextField[1].text!) else {            self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            guard let ef3 = Double(fiberMaterialPropertiesTextField[1].text!) else {            self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            guard let gf12 = Double(fiberMaterialPropertiesTextField[2].text!) else {            self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            guard let gf13 = Double(fiberMaterialPropertiesTextField[2].text!) else {            self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            guard let vf12 = Double(fiberMaterialPropertiesTextField[3].text!) else {            self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            guard let vf13 = Double(fiberMaterialPropertiesTextField[3].text!) else {            self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            guard let vf23 = Double(fiberMaterialPropertiesTextField[4].text!) else {            self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            let gf23 = ef2 / (2*(1 + vf23))
            Sf = [1/ef1, -vf12/ef1, -vf13/ef1, 0, 0, 0, -vf12/ef1, 1/ef2, -vf23/ef2, 0, 0, 0, -vf12/ef1, -vf23/ef2, 1/ef3, 0, 0, 0, 0, 0, 0, 1/gf23, 0, 0, 0, 0, 0, 0, 1/gf13, 0, 0, 0, 0, 0, 0, 1/gf12]
            SHf = [ef1, vf12, vf13, 0, 0, 0, -vf12, 1/ef2 - vf12*vf12/ef1, -vf23/ef2 - vf13*vf13/ef1, 0, 0, 0, -vf23, -vf23/ef2 - vf12*vf12/ef1, 1/ef3 - vf13*vf13/ef1, 0, 0, 0, 0, 0, 0, 1/gf23, 0, 0, 0, 0, 0, 0, 1/gf13, 0, 0, 0, 0, 0, 0, 1/gf12]
            
        } else if fiberMaterialType == .orthotropic {
            guard let ef1 = Double(fiberMaterialPropertiesTextField[0].text!) else {            self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            guard let ef2 = Double(fiberMaterialPropertiesTextField[1].text!) else {            self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            guard let ef3 = Double(fiberMaterialPropertiesTextField[2].text!) else {            self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            guard let gf12 = Double(fiberMaterialPropertiesTextField[3].text!) else {            self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            guard let gf13 = Double(fiberMaterialPropertiesTextField[4].text!) else {            self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            guard let gf23 = Double(fiberMaterialPropertiesTextField[5].text!) else {            self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            guard let vf12 = Double(fiberMaterialPropertiesTextField[6].text!) else {            self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            guard let vf13 = Double(fiberMaterialPropertiesTextField[7].text!) else {            self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            guard let vf23 = Double(fiberMaterialPropertiesTextField[8].text!) else {            self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            Sf = [1/ef1, -vf12/ef1, -vf13/ef1, 0, 0, 0, -vf12/ef1, 1/ef2, -vf23/ef2, 0, 0, 0, -vf12/ef1, -vf23/ef2, 1/ef3, 0, 0, 0, 0, 0, 0, 1/gf23, 0, 0, 0, 0, 0, 0, 1/gf13, 0, 0, 0, 0, 0, 0, 1/gf12]
            SHf = [ef1, vf12, vf13, 0, 0, 0, -vf12, 1/ef2 - vf12*vf12/ef1, -vf23/ef2 - vf13*vf13/ef1, 0, 0, 0, -vf23, -vf23/ef2 - vf12*vf12/ef1, 1/ef3 - vf13*vf13/ef1, 0, 0, 0, 0, 0, 0, 1/gf23, 0, 0, 0, 0, 0, 0, 1/gf13, 0, 0, 0, 0, 0, 0, 1/gf12]
        }
        
        if matrixMaterialType == .isotropic {
            guard let em1 = Double(matrixMaterialPropertiesTextField[0].text!) else {            self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            guard let em2 = Double(matrixMaterialPropertiesTextField[0].text!) else {            self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            guard let em3 = Double(matrixMaterialPropertiesTextField[0].text!) else {            self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            guard let vm12 = Double(matrixMaterialPropertiesTextField[1].text!) else {            self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            guard let vm13 = Double(matrixMaterialPropertiesTextField[1].text!) else {            self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            guard let vm23 = Double(matrixMaterialPropertiesTextField[1].text!) else {            self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            let gm12 = em1 / (2*(1+vm12))
            let gm13 = em1 / (2*(1+vm12))
            let gm23 = em1 / (2*(1+vm12))
            Sm = [1/em1, -vm12/em1, -vm13/em1, 0, 0, 0, -vm12/em1, 1/em2, -vm23/em2, 0, 0, 0, -vm12/em1, -vm23/em2, 1/em3, 0, 0, 0, 0, 0, 0, 1/gm23, 0, 0, 0, 0, 0, 0, 1/gm13, 0, 0, 0, 0, 0, 0, 1/gm12]
            SHm = [em1, vm12, vm13, 0, 0, 0, -vm12, 1/em2 - vm12*vm12/em1, -vm23/em2 - vm13*vm13/em1, 0, 0, 0, -vm23, -vm23/em2 - vm12*vm12/em1, 1/em3 - vm13*vm13/em1, 0, 0, 0, 0, 0, 0, 1/gm23, 0, 0, 0, 0, 0, 0, 1/gm13, 0, 0, 0, 0, 0, 0, 1/gm12]
            
        } else if matrixMaterialType == .transverselyIsotropic {
            guard let em1 = Double(matrixMaterialPropertiesTextField[0].text!) else {            self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            guard let em2 = Double(matrixMaterialPropertiesTextField[1].text!) else {            self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            guard let em3 = Double(matrixMaterialPropertiesTextField[1].text!) else {            self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            guard let gm12 = Double(matrixMaterialPropertiesTextField[2].text!) else {            self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            guard let gm13 = Double(matrixMaterialPropertiesTextField[2].text!) else {            self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            guard let vm12 = Double(matrixMaterialPropertiesTextField[3].text!) else {            self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            guard let vm13 = Double(matrixMaterialPropertiesTextField[3].text!) else {            self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            guard let vm23 = Double(matrixMaterialPropertiesTextField[4].text!) else {            self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            
            let gm23 = em2 / (2*(1 + vm23))
            Sm = [1/em1, -vm12/em1, -vm13/em1, 0, 0, 0, -vm12/em1, 1/em2, -vm23/em2, 0, 0, 0, -vm12/em1, -vm23/em2, 1/em3, 0, 0, 0, 0, 0, 0, 1/gm23, 0, 0, 0, 0, 0, 0, 1/gm13, 0, 0, 0, 0, 0, 0, 1/gm12]
            SHm = [em1, vm12, vm13, 0, 0, 0, -vm12, 1/em2 - vm12*vm12/em1, -vm23/em2 - vm13*vm13/em1, 0, 0, 0, -vm23, -vm23/em2 - vm12*vm12/em1, 1/em3 - vm13*vm13/em1, 0, 0, 0, 0, 0, 0, 1/gm23, 0, 0, 0, 0, 0, 0, 1/gm13, 0, 0, 0, 0, 0, 0, 1/gm12]
            
        } else if matrixMaterialType == .orthotropic {
            guard let em1 = Double(matrixMaterialPropertiesTextField[0].text!) else {            self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            guard let em2 = Double(matrixMaterialPropertiesTextField[1].text!) else {            self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            guard let em3 = Double(matrixMaterialPropertiesTextField[2].text!) else {            self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            guard let gm12 = Double(matrixMaterialPropertiesTextField[3].text!) else {            self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            guard let gm13 = Double(matrixMaterialPropertiesTextField[4].text!) else {            self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            guard let gm23 = Double(matrixMaterialPropertiesTextField[5].text!) else {            self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            guard let vm12 = Double(matrixMaterialPropertiesTextField[6].text!) else {            self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            guard let vm13 = Double(matrixMaterialPropertiesTextField[7].text!) else {            self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            guard let vm23 = Double(matrixMaterialPropertiesTextField[8].text!) else {            self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            Sm = [1/em1, -vm12/em1, -vm13/em1, 0, 0, 0, -vm12/em1, 1/em2, -vm23/em2, 0, 0, 0, -vm12/em1, -vm23/em2, 1/em3, 0, 0, 0, 0, 0, 0, 1/gm23, 0, 0, 0, 0, 0, 0, 1/gm13, 0, 0, 0, 0, 0, 0, 1/gm12]
            SHm = [em1, vm12, vm13, 0, 0, 0, -vm12, 1/em2 - vm12*vm12/em1, -vm23/em2 - vm13*vm13/em1, 0, 0, 0, -vm23, -vm23/em2 - vm12*vm12/em1, 1/em3 - vm13*vm13/em1, 0, 0, 0, 0, 0, 0, 1/gm23, 0, 0, 0, 0, 0, 0, 1/gm13, 0, 0, 0, 0, 0, 0, 1/gm12]
        }
        
            
        let s = geometryLabel.text!
        
        var Vf = Double(s[s.index(s.endIndex, offsetBy: -4) ..< s.endIndex])!
        var Vm = 1.0 - Vf
        
        var SRs = [Double](repeating: 0, count: 36)
        var SVs = [Double](repeating: 0, count: 36)
        var SHs = [Double](repeating: 0, count: 36)
        
        var Cf = [Double](repeating: 0, count: 36)
        var Cm = [Double](repeating: 0, count: 36)
        var CVs = [Double](repeating: 0, count: 36)
        
        var temp1 = [Double](repeating: 0, count: 36)
        var temp2 = [Double](repeating: 0, count: 36)
        
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
        
        // Voigt results
        let eV1  = 1/SVs[0]
        let eV2  = 1/SVs[7]
        let eV3  = 1/SVs[14]
        let gV12 = 1/SVs[35]
        let gV13 = 1/SVs[28]
        let gV23 = 1/SVs[21]
        let vV12 = -1/SVs[0]*SVs[1]
        let vV13 = -1/SVs[0]*SVs[2]
        let vV23 = -1/SVs[7]*SVs[8]
        
        // Reuss results
        let eR1  = 1/SRs[0]
        let eR2  = 1/SRs[7]
        let eR3  = 1/SRs[14]
        let gR12 = 1/SRs[35]
        let gR13 = -1/SRs[28]
        let gR23 = -1/SRs[21]
        let vR12 = -1/SRs[0]*SRs[1]
        let vR13 = -1/SRs[0]*SRs[2]
        let vR23 = -1/SRs[7]*SRs[8]
        
        
        //Hybird results
        let eH1 = SHs[0]
        
        let vH12 = SHs[1]
        let vH13 = SHs[2]
        
        let gH12 = SHs[35]
        let gH13 = SHs[28]
        let gH23 = SHs[21]
        
        let eH2 = 1 / (SHs[7] + vH12*vH12/eH1)
        let eH3 = 1 / (SHs[14] + vH13*vH13/eH1)
        
        let vH23 = -eH2 * (SHs[8] + vH12*vH12 / eH1)
        
        if fiberMaterialType == .orthotropic || matrixMaterialType == .orthotropic {
            if methodLabelButton.titleLabel?.text == "Voigt Rules of Mixture" {
                engineeringConstantsOrthotropic[0] = eV1
                engineeringConstantsOrthotropic[1] = eV2
                engineeringConstantsOrthotropic[2] = eV3
                engineeringConstantsOrthotropic[3] = gV12
                engineeringConstantsOrthotropic[4] = gV13
                engineeringConstantsOrthotropic[5] = gV23
                engineeringConstantsOrthotropic[6] = vV12
                engineeringConstantsOrthotropic[7] = vV13
                engineeringConstantsOrthotropic[8] = vV23
                
            }
            else if methodLabelButton.titleLabel?.text == "Reuss Rules of Mixture" {
                engineeringConstantsOrthotropic[0] = eR1
                engineeringConstantsOrthotropic[1] = eR2
                engineeringConstantsOrthotropic[2] = eR3
                engineeringConstantsOrthotropic[3] = gR12
                engineeringConstantsOrthotropic[4] = gR13
                engineeringConstantsOrthotropic[5] = gR23
                engineeringConstantsOrthotropic[6] = vR12
                engineeringConstantsOrthotropic[7] = vR13
                engineeringConstantsOrthotropic[8] = vR23
            }
            else if methodLabelButton.titleLabel?.text == "Hybrid Rules of Mixture" {
                engineeringConstantsOrthotropic[0] = eH1
                engineeringConstantsOrthotropic[1] = eH2
                engineeringConstantsOrthotropic[2] = eH3
                engineeringConstantsOrthotropic[3] = gH12
                engineeringConstantsOrthotropic[4] = gH13
                engineeringConstantsOrthotropic[5] = gH23
                engineeringConstantsOrthotropic[6] = vH12
                engineeringConstantsOrthotropic[7] = vH13
                engineeringConstantsOrthotropic[8] = vH23
            }
            
            planeStressReducedCompliance = [1/engineeringConstantsOrthotropic[0], -engineeringConstantsOrthotropic[6]/engineeringConstantsOrthotropic[0], 0, -engineeringConstantsOrthotropic[6]/engineeringConstantsOrthotropic[0], 1/engineeringConstantsOrthotropic[1], 0, 0, 0, 1/engineeringConstantsOrthotropic[3]]
            planeStressReducedStiffness = invert(matrix: planeStressReducedCompliance)
            
        } else {
            if methodLabelButton.titleLabel?.text == "Voigt Rules of Mixture" {
                engineeringConstantsTransverselyIsotropic[0] = eV1
                engineeringConstantsTransverselyIsotropic[1] = eV2
                engineeringConstantsTransverselyIsotropic[2] = gV12
                engineeringConstantsTransverselyIsotropic[3] = vV12
                engineeringConstantsTransverselyIsotropic[4] = vV23
                
            }
            else if methodLabelButton.titleLabel?.text == "Reuss Rules of Mixture" {
                engineeringConstantsTransverselyIsotropic[0] = eR1
                engineeringConstantsTransverselyIsotropic[1] = eR2
                engineeringConstantsTransverselyIsotropic[2] = gR12
                engineeringConstantsTransverselyIsotropic[3] = vR12
                engineeringConstantsTransverselyIsotropic[4] = vR23
                
            }
            else if methodLabelButton.titleLabel?.text == "Hybrid Rules of Mixture" {
                engineeringConstantsTransverselyIsotropic[0] = eH1
                engineeringConstantsTransverselyIsotropic[1] = eH2
                engineeringConstantsTransverselyIsotropic[2] = gH12
                engineeringConstantsTransverselyIsotropic[3] = vH12
                engineeringConstantsTransverselyIsotropic[4] = vH23
            }
            
            planeStressReducedCompliance = [1/engineeringConstantsTransverselyIsotropic[0], -engineeringConstantsTransverselyIsotropic[3]/engineeringConstantsTransverselyIsotropic[0], 0, -engineeringConstantsTransverselyIsotropic[3]/engineeringConstantsTransverselyIsotropic[0], 1/engineeringConstantsTransverselyIsotropic[1], 0, 0, 0, 1/engineeringConstantsTransverselyIsotropic[3]]
            planeStressReducedStiffness = invert(matrix: planeStressReducedCompliance)
            
        }
        
        // CTEs
        
        if typeOfAnalysisLabelButton.titleLabel?.text == "Thermoelastic Analysis" {
            
            let wrongCTEValue = UIAlertController(title: "Wrong CTE Values", message: "Please double check!", preferredStyle: UIAlertController.Style.alert)
            wrongCTEValue.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            var alphaf = [Double](repeating: 0, count: 6)
            var alpham = [Double](repeating: 0, count: 6)
            
            if fiberMaterialType == .isotropic {
                guard let alphaf11 = Double(fiberMaterialPropertiesTextField[2].text!) else {            self.present(wrongCTEValue, animated: true, completion: nil)
                    return false
                }
                
                let alphaf22 = alphaf11
                let alphaf33 = alphaf11
                
                alphaf = [alphaf11, alphaf22, alphaf33, 0, 0, 0]
                
            } else if fiberMaterialType == .transverselyIsotropic {
                guard let alphaf11 = Double(fiberMaterialPropertiesTextField[5].text!) else {            self.present(wrongCTEValue, animated: true, completion: nil)
                    return false
                }
                guard let alphaf22 = Double(fiberMaterialPropertiesTextField[6].text!) else {            self.present(wrongCTEValue, animated: true, completion: nil)
                    return false
                }
                
                let alphaf33 = alphaf22
                
                alphaf = [alphaf11, alphaf22, alphaf33, 0, 0, 0]
                
            } else if fiberMaterialType == .orthotropic {
                guard let alphaf11 = Double(fiberMaterialPropertiesTextField[9].text!) else {            self.present(wrongCTEValue, animated: true, completion: nil)
                    return false
                }
                guard let alphaf22 = Double(fiberMaterialPropertiesTextField[10].text!) else {            self.present(wrongCTEValue, animated: true, completion: nil)
                    return false
                }
                guard let alphaf33 = Double(fiberMaterialPropertiesTextField[11].text!) else {            self.present(wrongCTEValue, animated: true, completion: nil)
                    return false
                }
                
                alphaf = [alphaf11, alphaf22, alphaf33, 0, 0, 0]
                
            }
            
            if matrixMaterialType == .isotropic {
                guard let alpham11 = Double(matrixMaterialPropertiesTextField[2].text!) else {            self.present(wrongCTEValue, animated: true, completion: nil)
                    return false
                }
                
                let alpham22 = alpham11
                let alpham33 = alpham11
                
                alpham = [alpham11, alpham22, alpham33, 0, 0, 0]
                
            } else if matrixMaterialType == .transverselyIsotropic {
                guard let alpham11 = Double(matrixMaterialPropertiesTextField[5].text!) else {            self.present(wrongCTEValue, animated: true, completion: nil)
                    return false
                }
                guard let alpham22 = Double(matrixMaterialPropertiesTextField[6].text!) else {            self.present(wrongCTEValue, animated: true, completion: nil)
                    return false
                }
                
                let alpham33 = alpham22
                
                alpham = [alpham11, alpham22, alpham33, 0, 0, 0]
                
            } else if matrixMaterialType == .orthotropic {
                guard let alpham11 = Double(matrixMaterialPropertiesTextField[9].text!) else {            self.present(wrongCTEValue, animated: true, completion: nil)
                    return false
                }
                guard let alpham22 = Double(matrixMaterialPropertiesTextField[10].text!) else {            self.present(wrongCTEValue, animated: true, completion: nil)
                    return false
                }
                guard let alpham33 = Double(matrixMaterialPropertiesTextField[11].text!) else {            self.present(wrongCTEValue, animated: true, completion: nil)
                    return false
                }
                
                alpham = [alpham11, alpham22, alpham33, 0, 0, 0]
                
            }
            
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
            let alphaH22 = alphaHs[1] - alphaH11 * vH12
            let alphaH33 = alphaHs[2] - alphaH11 * vH13
            
            if fiberMaterialType == .orthotropic || matrixMaterialType == .orthotropic {
                if methodLabelButton.titleLabel?.text == "Voigt Rules of Mixture" {
                    engineeringConstantsOrthotropicThermal[0] = alphaV11
                    engineeringConstantsOrthotropicThermal[1] = alphaV22
                    engineeringConstantsOrthotropicThermal[2] = alphaV33
                }
                else if methodLabelButton.titleLabel?.text == "Reuss Rules of Mixture" {
                    engineeringConstantsOrthotropicThermal[0] = alphaR11
                    engineeringConstantsOrthotropicThermal[1] = alphaR22
                    engineeringConstantsOrthotropicThermal[2] = alphaR33
                    
                }
                else if methodLabelButton.titleLabel?.text == "Hybrid Rules of Mixture" {
                    engineeringConstantsOrthotropicThermal[0] = alphaH11
                    engineeringConstantsOrthotropicThermal[1] = alphaH22
                    engineeringConstantsOrthotropicThermal[2] = alphaH33
                }
            } else {
                if methodLabelButton.titleLabel?.text == "Voigt Rules of Mixture" {
                    engineeringConstantsTransverselyIsotropicThermal[0] = alphaV11
                    engineeringConstantsTransverselyIsotropicThermal[1] = alphaV22
                }
                else if methodLabelButton.titleLabel?.text == "Reuss Rules of Mixture" {
                    engineeringConstantsTransverselyIsotropicThermal[0] = alphaR11
                    engineeringConstantsTransverselyIsotropicThermal[1] = alphaR22
                }
                else if methodLabelButton.titleLabel?.text == "Hybrid Rules of Mixture" {
                    engineeringConstantsTransverselyIsotropicThermal[0] = alphaH11
                    engineeringConstantsTransverselyIsotropicThermal[1] = alphaH22
                }
            }
        }
        
        return true
        
    }
    
    
    // Inverse operation for matrix
    
    func invert(matrix : [Double]) -> [Double] {
        var inMatrix = matrix
        let N = __CLPK_integer(sqrt(Double(matrix.count)))
        var pivots = [__CLPK_integer](repeating: 0, count: Int(N))
        var workspace = [Double](repeating: 0.0, count: Int(N))
        var error : __CLPK_integer = 0
        
        // Mutable copies to circumvent "Simultaneous accesses to var 'N'" error in Swift 4
        var N1 = N, N2 = N, N3 = N
        dgetrf_(&N1, &N2, &inMatrix, &N3, &pivots, &error)
        dgetri_(&N1, &inMatrix, &N2, &pivots, &workspace, &N3, &error)
        return inMatrix
    }

}
