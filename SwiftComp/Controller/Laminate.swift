//
//  Laminate.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 10/22/17.
//  Copyright © 2017 Banghua Zhao. All rights reserved.
//

import UIKit
import Accelerate
import CoreData
import JGProgressHUD

class Laminate: UIViewController, UINavigationControllerDelegate, UIPopoverPresentationControllerDelegate, LaminateStackingSequenceDataBaseDelegate, LaminateMaterialDataBaseDelegate {
    
    // Global variables
    
    var typeOfAnalysis : typeOfAnalysis = .elastic
    var structuralModel : structuralModel = . plate
    var laminaMaterialType : materialType = .orthotropic
    
    var materialPropertyName = MaterialPropertyName()
    var materialPropertyPlaceHolder = MaterialPropertyPlaceHolder()
    
    // Transition
    
    let transition = CircleTransitionDesign()
    var touchLocation: CGPoint = CGPoint.zero
    
    // Core data
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var userSavedStackingSequences = [UserStackingSequence]()
    var userSavedLaminaMaterials = [UserLaminaMaterial]()
    
    // layout
    
    var scrollView: UIScrollView = UIScrollView()
    
    // Navigation bar
    
    let calculationButton = UIButton()
    var laminateResultViewController = LaminateResult()
    
    var effective3DPropertiesMonoclinic = [Double](repeating: 0.0, count: 13)
    var effective3DPropertiesMonoclinicThermal = [Double](repeating: 0.0, count: 4)
    
    var effective3DPropertiesAnisotropic = [Double](repeating: 0.0, count: 21)
    var effective3DPropertiesAnisotropicThermal = [Double](repeating: 0.0, count: 6)
    
    var effectiveInplaneProperties = [Double](repeating: 0.0, count: 6)
    var effectiveFlexuralProperties = [Double](repeating: 0.0, count: 6)
    
    // first section: Type of Analysis
    
    var typeOfAnalysisView: UIView = UIView()
    var typeOfAnalysisLabelButton: UIButton = UIButton()
    var typeOfAnalysisDataBaseAlterController : UIAlertController!
    
    // Structural Model
    
    var structuralModelView: UIView = UIView()
    var structuralModelLabelButton: UIButton = UIButton()
    var structuralModelDataBaseAlterController : UIAlertController!
    
    // second section: stacking sequence
    
    var stackingSequenceView: UIView = UIView()
    var stackingSequenceDataBase: UIButton = UIButton()
    var LaminateStackingSequenceDataBaseViewController = LaminateStackingSequenceDataBase()
    var stackingSequenceTextField: UITextField = UITextField()
    var stackingSequenceNameLabel: UITextField = UITextField()
    var stackingSequenceSave: UIButton = UIButton()
    
    // third section: lamina material
    
    var laminaMaterialView: UIView = UIView()
    var laminaMaterialDataBase: UIButton = UIButton()
    var laminateLaminaMaterialDataBaseViewController = LaminateLaminaMaterialDataBase()
    let laminaMaterialTypeSegementedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Transversely", "Orthotropic", "Anisotropic"])
        sc.selectedSegmentIndex = 1
        return sc
    }()
    var laminaMaterialCard: UIView = UIView()
    var laminaMaterialNameLabel: UILabel = UILabel()
    var laminaMaterialPropertiesLabel: [UILabel] = []
    var laminaMaterialPropertiesTextField: [UITextField] = []
    var saveLaminaMaterialButton: UIButton = UIButton()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        self.navigationController?.delegate = self
        
        editNavigationBar()
        
        createLayout()
        
        loadCoreData()
        
        createActionSheet()
        
        changeStackingSequenceDataField()
        
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
    
    
    
    // MARk: Add transition animation
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        transition.startingPoint = touchLocation
        
        if operation == .push {
            transition.transitionMode = .present
            switch toVC {
            case LaminateStackingSequenceDataBaseViewController:
                transition.circleColor = stackingSequenceDataBase.backgroundColor!
            case laminateLaminaMaterialDataBaseViewController:
                transition.circleColor = laminaMaterialDataBase.backgroundColor!
            default:
                return nil
            }
        } else {
            transition.transitionMode = .dismiss
            switch fromVC {
            case LaminateStackingSequenceDataBaseViewController:
                transition.circleColor = stackingSequenceDataBase.backgroundColor!
            case laminateLaminaMaterialDataBaseViewController:
                transition.circleColor = laminaMaterialDataBase.backgroundColor!
            default:
                return nil
            }
        }
        
        return transition
        
    }
    
    
    
    // MARK: Edit navigation bar
    
    func editNavigationBar() {
        
        navigationItem.title = "Laminate"
        
        calculationButton.calculateButtonDesign()
        calculationButton.addTarget(self, action: #selector(calculate), for: .touchUpInside)
        calculationButton.widthAnchor.constraint(equalToConstant: calculationButton.intrinsicContentSize.width + 20).isActive = true
        let item = UIBarButtonItem(customView: calculationButton)
        self.navigationItem.setRightBarButtonItems([item], animated: true)
    }
    
    
    
    @objc func calculate(_ sender: UIButton, event: UIEvent) {
        
        sender.flash()
        
        laminateResultViewController = LaminateResult()
        
        let touch = event.touches(for: sender)?.first
        touchLocation = touch?.location(in: self.view) ?? CGPoint.zero
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Calculating"
        hud.show(in: self.view)
        
        let start = DispatchTime.now()
        
        if self.calculateResult() {
                
            laminateResultViewController.typeOfAnalysis = self.typeOfAnalysis
            
            
            if laminaMaterialType == .transverselyIsotropic {
                laminateResultViewController.resultMaterialType = .monoclinic
                for i in 0...effective3DPropertiesMonoclinic.count-1 {
                    laminateResultViewController.effective3DPropertiesMonoclinic[i] = self.effective3DPropertiesMonoclinic[i]
                }
                
                for i in 0...effective3DPropertiesMonoclinicThermal.count-1 {
                    laminateResultViewController.effective3DPropertiesMonoclinicThermal[i] = self.effective3DPropertiesMonoclinicThermal[i]
                }
            } else if laminaMaterialType == .orthotropic {
                laminateResultViewController.resultMaterialType = .monoclinic
                for i in 0...effective3DPropertiesMonoclinic.count-1 {
                    laminateResultViewController.effective3DPropertiesMonoclinic[i] = self.effective3DPropertiesMonoclinic[i]
                }
                
                for i in 0...effective3DPropertiesMonoclinicThermal.count-1 {
                    laminateResultViewController.effective3DPropertiesMonoclinicThermal[i] = self.effective3DPropertiesMonoclinicThermal[i]
                }
            } else if laminaMaterialType == .anisotropic {
                laminateResultViewController.resultMaterialType = .anisotropic
                for i in 0...effective3DPropertiesAnisotropic.count-1 {
                    laminateResultViewController.effective3DPropertiesAnisotropic[i] = self.effective3DPropertiesAnisotropic[i]
                }
                
                for i in 0...effective3DPropertiesAnisotropicThermal.count-1 {
                    laminateResultViewController.effective3DPropertiesAnisotropicThermal[i] = self.effective3DPropertiesAnisotropicThermal[i]
                }
            }
            
            for i in 0...5 {
                laminateResultViewController.effectiveInPlaneProperties[i] = self.effectiveInplaneProperties[i]
                laminateResultViewController.effectiveFlexuralProperties[i] = self.effectiveFlexuralProperties[i]
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
                
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                    
                    self.navigationController?.pushViewController(self.laminateResultViewController, animated: true)
                }
            } else {
                hud.dismiss(afterDelay: 0.0)
                self.navigationController?.pushViewController(self.laminateResultViewController, animated: true)
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
        scrollView.addSubview(typeOfAnalysisView)
        scrollView.addSubview(structuralModelView)
        scrollView.addSubview(stackingSequenceView)
        scrollView.addSubview(laminaMaterialView)
        
        // first section
        
        creatViewCard(viewCard: typeOfAnalysisView, title: "Type of Analysis", aboveConstraint: scrollView.topAnchor, under: scrollView)
        
        typeOfAnalysisView.addSubview(typeOfAnalysisLabelButton)
        
        typeOfAnalysisLabelButton.setTitle("Elastic Analysis", for: UIControl.State.normal)
        typeOfAnalysisLabelButton.addTarget(self, action: #selector(changeTypeOfAnalysisLabel(_:)), for: .touchUpInside)
        typeOfAnalysisLabelButton.methodButtonDesign()
        typeOfAnalysisLabelButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        typeOfAnalysisLabelButton.widthAnchor.constraint(greaterThanOrEqualToConstant: typeOfAnalysisLabelButton.intrinsicContentSize.width + 100).isActive = true
        typeOfAnalysisLabelButton.topAnchor.constraint(equalTo: typeOfAnalysisView.topAnchor, constant: 40).isActive = true
        typeOfAnalysisLabelButton.centerXAnchor.constraint(equalTo: typeOfAnalysisView.centerXAnchor).isActive = true
        typeOfAnalysisLabelButton.bottomAnchor.constraint(equalTo: typeOfAnalysisView.bottomAnchor, constant: -20).isActive = true
        
        // Structural Model
        
        creatViewCard(viewCard: structuralModelView, title: "Structural Model", aboveConstraint: typeOfAnalysisView.bottomAnchor, under: scrollView)
        
        structuralModelView.addSubview(structuralModelLabelButton)
        
        structuralModelLabelButton.setTitle("Plate Model", for: UIControl.State.normal)
        structuralModelLabelButton.addTarget(self, action: #selector(changeStructuralMOdelLabel(_:)), for: .touchUpInside)
        structuralModelLabelButton.methodButtonDesign()
        structuralModelLabelButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        structuralModelLabelButton.widthAnchor.constraint(greaterThanOrEqualToConstant: structuralModelLabelButton.intrinsicContentSize.width + 100).isActive = true
        structuralModelLabelButton.topAnchor.constraint(equalTo: structuralModelView.topAnchor, constant: 40).isActive = true
        structuralModelLabelButton.centerXAnchor.constraint(equalTo: structuralModelView.centerXAnchor).isActive = true
        structuralModelLabelButton.bottomAnchor.constraint(equalTo: structuralModelView.bottomAnchor, constant: -20).isActive = true
        
        
        // geometry

        creatViewCard(viewCard: stackingSequenceView, title: "Geometry", aboveConstraint: structuralModelView.bottomAnchor, under: scrollView)
        stackingSequenceView.addSubview(stackingSequenceDataBase)
        stackingSequenceView.addSubview(stackingSequenceSave)
        stackingSequenceView.addSubview(stackingSequenceTextField)
        
        stackingSequenceDataBase.dataBaseButtonDesign(title: "\u{2630} Database", under: stackingSequenceView)
        stackingSequenceDataBase.addTarget(self, action: #selector(enterStackingSequenceDataBase), for: .touchUpInside)
        
        stackingSequenceSave.saveButtonDesign(title: "\u{21E9} Save", under: stackingSequenceView)
        stackingSequenceSave.addTarget(self, action: #selector(saveStackingSequence), for: .touchUpInside)
        
        stackingSequenceNameLabel.text = "[0/90/45/-45]s"
        stackingSequenceTextField.translatesAutoresizingMaskIntoConstraints = false
        stackingSequenceTextField.keyboardType = UIKeyboardType.numbersAndPunctuation
        stackingSequenceTextField.text = stackingSequenceNameLabel.text
        stackingSequenceTextField.borderStyle = .roundedRect
        stackingSequenceTextField.textAlignment = .center
        stackingSequenceTextField.placeholder = "[xx/xx/xx/xx/..]msn"
        stackingSequenceTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        stackingSequenceTextField.widthAnchor.constraint(equalTo: stackingSequenceView.widthAnchor, multiplier: 0.6).isActive = true
        stackingSequenceTextField.topAnchor.constraint(equalTo: stackingSequenceDataBase.bottomAnchor, constant: 8).isActive = true
        stackingSequenceTextField.centerXAnchor.constraint(equalTo: stackingSequenceView.centerXAnchor).isActive = true


        stackingSequenceTextField.bottomAnchor.constraint(equalTo: stackingSequenceView.bottomAnchor, constant: -20).isActive = true
        
        // lamina material

        creatViewCard(viewCard: laminaMaterialView, title: "Lamina Material", aboveConstraint: stackingSequenceView.bottomAnchor, under: scrollView)
        laminaMaterialView.addSubview(laminaMaterialDataBase)
        laminaMaterialView.addSubview(saveLaminaMaterialButton)
        laminaMaterialView.addSubview(laminaMaterialTypeSegementedControl)
        laminaMaterialView.addSubview(laminaMaterialCard)
        
        laminaMaterialDataBase.dataBaseButtonDesign(title: "\u{2630} Database", under: laminaMaterialView)
        laminaMaterialDataBase.addTarget(self, action: #selector(enterlaminaMaterialDataBase), for: .touchUpInside)
        
        saveLaminaMaterialButton.saveButtonDesign(title: "\u{21E9} Save", under: laminaMaterialView)
        saveLaminaMaterialButton.addTarget(self, action: #selector(saveLaminaMaterial), for: .touchUpInside)
        
        laminaMaterialTypeSegementedControl.translatesAutoresizingMaskIntoConstraints = false
        laminaMaterialTypeSegementedControl.addTarget(self, action: #selector(changeLaminaMaterialType), for: .valueChanged)
        laminaMaterialTypeSegementedControl.widthAnchor.constraint(equalTo: laminaMaterialView.widthAnchor, multiplier: 0.8).isActive = true
        laminaMaterialTypeSegementedControl.topAnchor.constraint(equalTo: laminaMaterialDataBase.bottomAnchor, constant: 8).isActive = true
        laminaMaterialTypeSegementedControl.centerXAnchor.constraint(equalTo: laminaMaterialView.centerXAnchor).isActive = true
        
        laminaMaterialNameLabel.text = "IM7/8552"
        createMaterialCard(materialCard: &laminaMaterialCard, materialName: laminaMaterialNameLabel, label: &laminaMaterialPropertiesLabel, value: &laminaMaterialPropertiesTextField, aboveConstraint: laminaMaterialTypeSegementedControl.bottomAnchor, under: laminaMaterialView, typeOfAnalysis: typeOfAnalysis, materialType: .orthotropic)
        
        laminaMaterialCard.bottomAnchor.constraint(equalTo: laminaMaterialView.bottomAnchor, constant: -20).isActive = true
        
        laminaMaterialView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20).isActive = true
        
    }
    
    
    
    
    // First section
    
    @objc func changeTypeOfAnalysisLabel(_ sender: UIButton) {
        sender.flash()
        self.present(typeOfAnalysisDataBaseAlterController, animated: true, completion: nil)
        
    }
    
    // Structural Model
    
    @objc func changeStructuralMOdelLabel(_ sender: UIButton) {
        sender.flash()
        self.present(structuralModelDataBaseAlterController, animated: true, completion: nil)
    }
    
    
    
    // Second section: Stacking sequence
    
    @objc func enterStackingSequenceDataBase(_ sender: UIButton, event: UIEvent) {
        sender.flash()
        
        let touch = event.touches(for: sender)?.first
        touchLocation = touch?.location(in: self.view) ?? CGPoint.zero
        
        LaminateStackingSequenceDataBaseViewController = LaminateStackingSequenceDataBase()
        
        LaminateStackingSequenceDataBaseViewController.delegate = self
        self.navigationController?.pushViewController(LaminateStackingSequenceDataBaseViewController, animated: true)
    }
    
    
    
    func userTypeStackingSequenceDataBase(stackingSequence: String) {
        self.stackingSequenceNameLabel.text = stackingSequence
        changeStackingSequenceDataField()
    }
    
    
    /*
    @objc func explainStackingSequence(_ sender: UIButton) {
        
        let viewController = stackingSequenceExplainPopover()

        let popover = viewController.popoverPresentationController
        popover?.delegate = self
        popover?.sourceView = sender
        popover?.sourceRect = sender.bounds
        popover?.permittedArrowDirections = .up
        popover?.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0)
        
        present(viewController, animated: true, completion: nil)
    }
    */
    
    
    
    @objc func saveStackingSequence(_ sender: UIButton) {
        sender.flash()
        
        let inputAlter = UIAlertController(title: "Save Stacking Sequence", message: "Enter the stacking sequence name.", preferredStyle: UIAlertController.Style.alert)
        inputAlter.addTextField { (textField: UITextField) in
            textField.placeholder = "Stacking Sequence Name"
            textField.text = self.stackingSequenceTextField.text
        }
        inputAlter.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        inputAlter.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action:UIAlertAction) in
            
            let stackingSequenceNameTextField = inputAlter.textFields?.first
            
            // check empty name
            
            let emptyNameAlter = UIAlertController(title: "Empty Name", message: "Please enter a name for this stacking sequence.", preferredStyle: UIAlertController.Style.alert)
            emptyNameAlter.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            var userStackingSequenceName : String = ""
            
            if stackingSequenceNameTextField?.text != "" {
                userStackingSequenceName = (stackingSequenceNameTextField?.text)!
            }
            else {
                self.present(emptyNameAlter, animated: true, completion: nil)
                return
            }
            
            // check wrong or empty material valuw
            
            let emptyStackingSequenceAlter = UIAlertController(title: "Empty Stacking Sequence", message: "Please enter stacking sequence ([xx/xx/xx/xx/..]msn) for this laminate.", preferredStyle: UIAlertController.Style.alert)
            emptyStackingSequenceAlter.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            if let valueString = self.stackingSequenceTextField.text {
                if valueString == "" {
                    self.present(emptyStackingSequenceAlter, animated: true, completion: nil)
                    return
                }
            } else {
                self.present(emptyStackingSequenceAlter, animated: true, completion: nil)
                return
            }
            
            // check same stacking sequence name
            
            let sameStackingSequenceNameAlter = UIAlertController(title: "Same Stacking Sequence Name", message: "Please enter a differet stacking sequence name.", preferredStyle: UIAlertController.Style.alert)
            sameStackingSequenceNameAlter.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            for name in ["Empty Stacking Sequence", "[0/90]", "[45/-45]", "[0/30/-30]", "[0/60/-60]s", "[0/90/45/-45]s"] {
                if userStackingSequenceName == name {
                    self.present(sameStackingSequenceNameAlter, animated: true, completion: nil)
                    return
                }
            }
            
            for userSavedStackingSequence in self.userSavedStackingSequences {
                if let name = userSavedStackingSequence.name {
                    if userStackingSequenceName == name {
                        self.present(sameStackingSequenceNameAlter, animated: true, completion: nil)
                        return
                    }
                }
            }
            
            let currentUserStackingSequence = UserStackingSequence(context: self.context)
            currentUserStackingSequence.setValue(userStackingSequenceName, forKey: "name")
            currentUserStackingSequence.setValue(self.stackingSequenceTextField.text, forKey: "stackingSequence")
            
            do {
                try self.context.save()
                self.loadCoreData()
            } catch {
                print("Could not save data: \(error.localizedDescription)")
            }
            
        }))
        
        self.present(inputAlter, animated: true, completion: nil)
        
    }
    
    
    
    // Third Section: Lamina material
    
    @objc func enterlaminaMaterialDataBase(_ sender: UIButton, event: UIEvent) {
        sender.flash()
        
        let touch = event.touches(for: sender)?.first
        touchLocation = touch?.location(in: self.view) ?? CGPoint.zero
        
        laminateLaminaMaterialDataBaseViewController = LaminateLaminaMaterialDataBase()
        
        laminateLaminaMaterialDataBaseViewController.delegate = self
        self.navigationController?.pushViewController(laminateLaminaMaterialDataBaseViewController, animated: true)
    }
    
    
    
    func userTypeLaminaMaterialDataBase(materialName: String) {
        self.laminaMaterialNameLabel.text = materialName
        determineLaminaMaterialType()
        changeLaminaMaterialType()
        changeMaterialDataField()
    }
    
    
    
    func determineLaminaMaterialType() {
        let allMaterials = MaterialBank()
        
        let materialCurrectName = laminaMaterialNameLabel.text!
        
        for material in allMaterials.list {
            
            if materialCurrectName == material.materialName {
                laminaMaterialType = material.materialType
            }
        }

        for userSaveMaterial in userSavedLaminaMaterials {
            if materialCurrectName == userSaveMaterial.name {
                switch userSaveMaterial.type {
                case "Transversely Isotropic":
                    laminaMaterialType = .transverselyIsotropic
                case "orthotropic":
                    laminaMaterialType = .orthotropic
                case "anisotropic":
                    laminaMaterialType = .anisotropic
                default:
                    continue
                }
            }
        }
        
        switch laminaMaterialType {
        case .transverselyIsotropic:
            laminaMaterialTypeSegementedControl.selectedSegmentIndex = 0
        case .orthotropic:
            laminaMaterialTypeSegementedControl.selectedSegmentIndex = 1
        case .anisotropic:
            laminaMaterialTypeSegementedControl.selectedSegmentIndex = 2
        default:
            break
        }
    }
    
    
    
    @objc func changeLaminaMaterialType() {
        switch laminaMaterialTypeSegementedControl.selectedSegmentIndex {
        case 0:
            laminaMaterialType = .transverselyIsotropic
        case 1:
            laminaMaterialType = .orthotropic
        case 2:
            laminaMaterialType = .anisotropic
        default:
            laminaMaterialType = .orthotropic
        }
        
        createMaterialCard(materialCard: &self.laminaMaterialCard, materialName: self.laminaMaterialNameLabel, label: &self.laminaMaterialPropertiesLabel, value: &self.laminaMaterialPropertiesTextField, aboveConstraint: self.laminaMaterialTypeSegementedControl.bottomAnchor, under: self.laminaMaterialView, typeOfAnalysis: typeOfAnalysis, materialType: laminaMaterialType)
        
        self.laminaMaterialCard.bottomAnchor.constraint(equalTo: self.laminaMaterialView.bottomAnchor, constant: -20).isActive = true
        
        self.changeMaterialDataField()
        
    }
    
    
    
    @objc func saveLaminaMaterial(_ sender: UIButton) {

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
            
            var userLaminaMaterialDictionary : [String: Double] = [:]
            var userLaminaMaterialType : String = ""
            
            let wrongMaterialValueAlter = UIAlertController(title: "Wrong Material Values", message: "Please enter valid values (number) for this material.", preferredStyle: UIAlertController.Style.alert)
            wrongMaterialValueAlter.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            let emptyMaterialValueAlter = UIAlertController(title: "Empty Material Value", message: "Please enter values (number) for this material.", preferredStyle: UIAlertController.Style.alert)
            emptyMaterialValueAlter.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            if self.laminaMaterialType == .transverselyIsotropic {
                userLaminaMaterialType = "Transversely Isotropic"
                for i in 0...self.materialPropertyName.transverselyIsotropic.count - 1 {
                    if let valueString = self.laminaMaterialPropertiesTextField[i].text {
                        if let value = Double(valueString) {
                            userLaminaMaterialDictionary[self.materialPropertyName.transverselyIsotropic[i]] = value
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
                        if let valueString = self.laminaMaterialPropertiesTextField[i + self.materialPropertyName.transverselyIsotropic.count].text {
                            if let value = Double(valueString) {
                                userLaminaMaterialDictionary[self.materialPropertyName.transverselyIsotropicThermal[i]] = value
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
            } else if self.laminaMaterialType == .orthotropic {
                userLaminaMaterialType = "orthotropic"
                for i in 0...self.materialPropertyName.orthotropic.count - 1 {
                    if let valueString = self.laminaMaterialPropertiesTextField[i].text {
                        if let value = Double(valueString) {
                            userLaminaMaterialDictionary[self.materialPropertyName.orthotropic[i]] = value
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
                        if let valueString = self.laminaMaterialPropertiesTextField[i + self.materialPropertyName.orthotropic.count].text {
                            if let value = Double(valueString) {
                                userLaminaMaterialDictionary[self.materialPropertyName.orthotropicThermal[i]] = value
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
            } else if self.laminaMaterialType == .anisotropic {
                userLaminaMaterialType = "anisotropic"
                for i in 0...self.materialPropertyName.anisotropic.count - 1 {
                    if let valueString = self.laminaMaterialPropertiesTextField[i].text {
                        if let value = Double(valueString) {
                            userLaminaMaterialDictionary[self.materialPropertyName.anisotropic[i]] = value
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
                    for i in 0...self.materialPropertyName.anisotropicThermal.count - 1 {
                        if let valueString = self.laminaMaterialPropertiesTextField[i + self.materialPropertyName.anisotropic.count].text {
                            if let value = Double(valueString) {
                                userLaminaMaterialDictionary[self.materialPropertyName.anisotropicThermal[i]] = value
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
            
            for name in ["Empty Material", "IM7/8552", "T2C190/F155"] {
                if userMaterialName == name {
                    self.present(sameMaterialNameAlter, animated: true, completion: nil)
                    return
                }
            }

            for userSavedLaminaMaterial in self.userSavedLaminaMaterials {
                if let name = userSavedLaminaMaterial.name {
                    if userMaterialName == name {
                        self.present(sameMaterialNameAlter, animated: true, completion: nil)
                        return
                    }
                }
            }
            
            let currentUserLaminaMaterial = UserLaminaMaterial(context: self.context)
            currentUserLaminaMaterial.setValue(userMaterialName, forKey: "name")
            currentUserLaminaMaterial.setValue(userLaminaMaterialType, forKey: "type")
            currentUserLaminaMaterial.setValue(userLaminaMaterialDictionary, forKey: "properties")

            do {
                try self.context.save()
                self.loadCoreData()
                
                // material card saving animation
                
                let MaterialCardImage: UIImage = UIImage(named: "MaterialCardImg")!
                let MaterialCardImageView: UIImageView = UIImageView(image: MaterialCardImage)
                self.laminaMaterialView.addSubview(MaterialCardImageView)
                
                MaterialCardImageView.frame.origin.x = self.laminaMaterialCard.frame.origin.x + self.laminaMaterialCard.frame.width / 2 - MaterialCardImageView.frame.width / 2
                MaterialCardImageView.frame.origin.y = self.laminaMaterialCard.frame.origin.y + self.laminaMaterialCard.frame.height / 2
                
                UIView.animate(withDuration: 0.8, animations: {
                    MaterialCardImageView.frame.origin.x = self.laminaMaterialDataBase.frame.origin.x + self.laminaMaterialDataBase.frame.width / 2 - MaterialCardImageView.frame.width / 2
                    MaterialCardImageView.frame.origin.y = self.laminaMaterialDataBase.frame.origin.y + self.laminaMaterialDataBase.frame.height / 2
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
        do {
            userSavedStackingSequences = try context.fetch(UserStackingSequence.fetchRequest())
        } catch {
            print("Could not load stacking sequence data from database \(error.localizedDescription)")
        }
        
        do {
            userSavedLaminaMaterials = try context.fetch(UserLaminaMaterial.fetchRequest())
        } catch {
            print("Could not load material data from database \(error.localizedDescription)")
        }
        
    }
    
    
    
    // MARK: Create action sheet
    
    func createActionSheet() {
        
        typeOfAnalysisDataBaseAlterController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        let s0 = UIAlertAction(title: "Elastic Analysis", style: UIAlertAction.Style.default) { (action) -> Void in
            self.typeOfAnalysisLabelButton.setTitle("Elastic Analysis", for: UIControl.State.normal)
            self.typeOfAnalysisLabelButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            self.typeOfAnalysis = .elastic
            self.changeTypeOfAnalysis(typeOfAnalysis: .elastic)
        }
        
        let s1 = UIAlertAction(title: "Thermoelastic Analysis", style: UIAlertAction.Style.default) { (action) -> Void in
            self.typeOfAnalysisLabelButton.setTitle("Thermoelastic Analysis", for: UIControl.State.normal)
            self.typeOfAnalysisLabelButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            self.typeOfAnalysis = .thermalElatic
            self.changeTypeOfAnalysis(typeOfAnalysis: .thermalElatic)
        }
        
        typeOfAnalysisDataBaseAlterController.addAction(s0)
        typeOfAnalysisDataBaseAlterController.addAction(s1)
        typeOfAnalysisDataBaseAlterController.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
        structuralModelDataBaseAlterController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        let m0 = UIAlertAction(title: "Plate Model", style: UIAlertAction.Style.default) { (action) -> Void in
            self.structuralModelLabelButton.setTitle("Plate Model", for: UIControl.State.normal)
            self.structuralModelLabelButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            self.structuralModel = .plate
        }
        
        let m1 = UIAlertAction(title: "Solid Model", style: UIAlertAction.Style.default) { (action) -> Void in
            self.structuralModelLabelButton.setTitle("Solid Model", for: UIControl.State.normal)
            self.structuralModelLabelButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            self.structuralModel = .solid
        }
        
        structuralModelDataBaseAlterController.addAction(m0)
        structuralModelDataBaseAlterController.addAction(m1)
        structuralModelDataBaseAlterController.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
    }
    
    
    
    // change type of analysis
    
    func changeTypeOfAnalysis(typeOfAnalysis: typeOfAnalysis) {
    
        createMaterialCard(materialCard: &self.laminaMaterialCard, materialName: self.laminaMaterialNameLabel, label: &self.laminaMaterialPropertiesLabel, value: &self.laminaMaterialPropertiesTextField, aboveConstraint: self.laminaMaterialTypeSegementedControl.bottomAnchor, under: self.laminaMaterialView, typeOfAnalysis: typeOfAnalysis, materialType: laminaMaterialType)
        
        self.changeMaterialDataField()
            

    }
    
    
    
    // MARK: Change stacking sequence data field
    
    func changeStackingSequenceDataField() {
        
        let stackingSequenceCurrectName = stackingSequenceNameLabel.text!
        if stackingSequenceCurrectName == "Empty Stacking Sequence" {
            stackingSequenceTextField.text = ""
        } else if ["[0/90]", "[45/-45]", "[0/30/-30]", "[0/60/-60]s", "[0/90/45/-45]s"].contains(stackingSequenceCurrectName) {
            stackingSequenceTextField.text = stackingSequenceCurrectName
        } else {
            for userSavedStackingSequence in userSavedStackingSequences {
                if stackingSequenceCurrectName == userSavedStackingSequence.name {
                    stackingSequenceTextField.text = userSavedStackingSequence.stackingSequence
                }
            }
        }

    }
    
    
    
    // MARK: Change material data field
    
    func changeMaterialDataField() {
        let allMaterials = MaterialBank()
        
        let materialCurrectName = laminaMaterialNameLabel.text!
        
        for material in allMaterials.list {
            
            if materialCurrectName == material.materialName {
                if laminaMaterialType == .transverselyIsotropic {
                    for i in 0...materialPropertyName.transverselyIsotropic.count - 1 {
                        if let property = material.materialProperties[materialPropertyName.transverselyIsotropic[i]] {
                            laminaMaterialPropertiesTextField[i].text = String(format: "%.2f", property)
                        } else {
                            laminaMaterialPropertiesTextField[i].text = ""
                        }
                    }
                    if typeOfAnalysis == .thermalElatic {
                        for i in 0...materialPropertyName.transverselyIsotropicThermal.count - 1 {
                            if let property = material.materialProperties[materialPropertyName.transverselyIsotropicThermal[i]] {
                                laminaMaterialPropertiesTextField[i+materialPropertyName.transverselyIsotropic.count].text = String(format: "%.2f", property)
                            } else {
                                laminaMaterialPropertiesTextField[i+materialPropertyName.transverselyIsotropic.count].text = ""
                            }
                        }
                    }
                } else if laminaMaterialType == .orthotropic {
                    for i in 0...materialPropertyName.orthotropic.count - 1 {
                        if let property = material.materialProperties[materialPropertyName.orthotropic[i]] {
                            laminaMaterialPropertiesTextField[i].text = String(format: "%.2f", property)
                        } else {
                            laminaMaterialPropertiesTextField[i].text = ""
                        }
                    }
                    if typeOfAnalysis == .thermalElatic {
                        for i in 0...materialPropertyName.orthotropicThermal.count - 1 {
                            if let property = material.materialProperties[materialPropertyName.orthotropicThermal[i]] {
                                laminaMaterialPropertiesTextField[i+materialPropertyName.orthotropic.count].text = String(format: "%.2f", property)
                            } else {
                                laminaMaterialPropertiesTextField[i+materialPropertyName.orthotropic.count].text = ""
                            }
                        }
                    }
                } else if laminaMaterialType == .anisotropic {
                    for i in 0...materialPropertyName.anisotropic.count - 1 {
                        if let property = material.materialProperties[materialPropertyName.anisotropic[i]] {
                            laminaMaterialPropertiesTextField[i].text = String(format: "%.2f", property)
                        } else {
                            laminaMaterialPropertiesTextField[i].text = ""
                        }
                    }
                    if typeOfAnalysis == .thermalElatic {
                        for i in 0...materialPropertyName.anisotropicThermal.count - 1 {
                            if let property = material.materialProperties[materialPropertyName.anisotropicThermal[i]] {
                                laminaMaterialPropertiesTextField[i+materialPropertyName.anisotropic.count].text = String(format: "%.2f", property)
                            } else {
                                laminaMaterialPropertiesTextField[i+materialPropertyName.anisotropic.count].text = ""
                            }
                        }
                    }
                }
            } else if materialCurrectName == "Empty Material" {
                if laminaMaterialType == .transverselyIsotropic {
                    for i in 0...materialPropertyName.transverselyIsotropic.count - 1 {
                        laminaMaterialPropertiesTextField[i].text = ""
                    }
                    if typeOfAnalysis == .thermalElatic {
                        for i in 0...materialPropertyName.transverselyIsotropicThermal.count - 1 {
                            laminaMaterialPropertiesTextField[i+materialPropertyName.transverselyIsotropic.count].text = ""
                        }
                    }
                } else if laminaMaterialType == .orthotropic {
                    for i in 0...materialPropertyName.orthotropic.count - 1 {
                        laminaMaterialPropertiesTextField[i].text = ""
                    }
                    if typeOfAnalysis == .thermalElatic {
                        for i in 0...materialPropertyName.orthotropicThermal.count - 1 {
                            laminaMaterialPropertiesTextField[i+materialPropertyName.orthotropic.count].text = ""
                        }
                    }
                } else if laminaMaterialType == .anisotropic {
                    for i in 0...materialPropertyName.anisotropic.count - 1 {
                        laminaMaterialPropertiesTextField[i].text = ""
                    }
                    if typeOfAnalysis == .thermalElatic {
                        for i in 0...materialPropertyName.anisotropicThermal.count - 1 {
                            laminaMaterialPropertiesTextField[i+materialPropertyName.anisotropic.count].text = ""
                        }
                    }
                }
            }
        }

        for userSaveMaterial in userSavedLaminaMaterials {
            if materialCurrectName == userSaveMaterial.name {
                if laminaMaterialType == .transverselyIsotropic {
                    for i in 0...materialPropertyName.transverselyIsotropic.count - 1 {
                        if let valueDictionary = userSaveMaterial.properties as? [String: Double] {
                            if let value = valueDictionary[materialPropertyName.transverselyIsotropic[i]] {
                                laminaMaterialPropertiesTextField[i].text = String(format: "%.2f", value)
                            } else {
                                laminaMaterialPropertiesTextField[i].text = ""
                            }
                        } else {
                            laminaMaterialPropertiesTextField[i].text = ""
                        }
                    }
                    if typeOfAnalysis == .thermalElatic {
                        for i in 0...materialPropertyName.transverselyIsotropicThermal.count - 1 {
                            if let valueDictionary = userSaveMaterial.properties as? [String: Double] {
                                if let value = valueDictionary[materialPropertyName.transverselyIsotropicThermal[i]] {
                                    laminaMaterialPropertiesTextField[i+materialPropertyName.transverselyIsotropic.count].text = String(format: "%.2f", value)
                                } else {
                                    laminaMaterialPropertiesTextField[i+materialPropertyName.transverselyIsotropic.count].text = ""
                                }
                            } else {
                                laminaMaterialPropertiesTextField[i+materialPropertyName.transverselyIsotropic.count].text = ""
                            }
                        }
                    }
                } else if laminaMaterialType == .orthotropic {
                    for i in 0...materialPropertyName.orthotropic.count - 1 {
                        if let valueDictionary = userSaveMaterial.properties as? [String: Double] {
                            if let value = valueDictionary[materialPropertyName.orthotropic[i]] {
                                laminaMaterialPropertiesTextField[i].text = String(format: "%.2f", value)
                            } else {
                                laminaMaterialPropertiesTextField[i].text = ""
                            }
                        } else {
                            laminaMaterialPropertiesTextField[i].text = ""
                        }
                    }
                    if typeOfAnalysis == .thermalElatic {
                        for i in 0...materialPropertyName.orthotropicThermal.count - 1 {
                            if let valueDictionary = userSaveMaterial.properties as? [String: Double] {
                                if let value = valueDictionary[materialPropertyName.orthotropicThermal[i]] {
                                    laminaMaterialPropertiesTextField[i+materialPropertyName.orthotropic.count].text = String(format: "%.2f", value)
                                } else {
                                    laminaMaterialPropertiesTextField[i+materialPropertyName.orthotropic.count].text = ""
                                }
                            } else {
                                laminaMaterialPropertiesTextField[i+materialPropertyName.orthotropic.count].text = ""
                            }
                        }
                    }
                } else if laminaMaterialType == .anisotropic {
                    for i in 0...materialPropertyName.anisotropic.count - 1 {
                        if let valueDictionary = userSaveMaterial.properties as? [String: Double] {
                            if let value = valueDictionary[materialPropertyName.anisotropic[i]] {
                                laminaMaterialPropertiesTextField[i].text = String(format: "%.2f", value)
                            } else {
                                laminaMaterialPropertiesTextField[i].text = ""
                            }
                        } else {
                            laminaMaterialPropertiesTextField[i].text = ""
                        }
                    }
                    if typeOfAnalysis == .thermalElatic {
                        for i in 0...materialPropertyName.anisotropicThermal.count - 1 {
                            if let valueDictionary = userSaveMaterial.properties as? [String: Double] {
                                if let value = valueDictionary[materialPropertyName.anisotropicThermal[i]] {
                                    laminaMaterialPropertiesTextField[i+materialPropertyName.anisotropic.count].text = String(format: "%.2f", value)
                                } else {
                                    laminaMaterialPropertiesTextField[i+materialPropertyName.anisotropic.count].text = ""
                                }
                            } else {
                                laminaMaterialPropertiesTextField[i+materialPropertyName.anisotropic.count].text = ""
                            }
                        }
                    }
                }
            }
        }
    }
    

    
    
    
    
    // MARK: Calculate result functions
    
    func calculateResult() -> Bool {
        
        let wrongStackingSequence = UIAlertController(title: "Wrong stacking sequence", message: "Please double check", preferredStyle: UIAlertController.Style.alert)
        wrongStackingSequence.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        let emptyStackingSequence = UIAlertController(title: "Empty stacking sequence", message: "Please enter a stacking sequence", preferredStyle: UIAlertController.Style.alert)
        emptyStackingSequence.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        var rBefore : Int = 1
        var rAfter : Int = 1
        var symmetry : Int = 1
        var baseLayup : String
        var baseLayupSequence = [Double]()
        var layupSequence = [Double]()
        var nPly : Int = 0
        var t : Double = 1.0
        var bzi = [Double]()
        
        // Handle stacking sequence
        
        if let layup = stackingSequenceTextField.text {
            
            let str = layup
            
            if str.split(separator: "]").count == 2 {
                baseLayup = str.split(separator: "]")[0].replacingOccurrences(of: "[", with: "")
                let rsr = str.split(separator: "]")[1]
                if rsr.split(separator: "s").count == 2 {
                    symmetry = 2
                    if let i = Int(rsr.split(separator: "s")[0]), let j = Int(rsr.split(separator: "s")[1]) {
                        rBefore = i
                        rAfter = j
                    } else {
                        self.present(wrongStackingSequence, animated: true, completion: nil)
                        return false
                    }
                } else if rsr.contains("s") {
                    symmetry = 2
                    if (rsr[rsr.startIndex] == "s") && (rsr == "s") {
                        rAfter = 1
                        rBefore = 1
                    }
                    else if rsr[rsr.startIndex] == "s"{
                        rBefore = 1
                        if rsr.split(separator: "s") != [] {
                            if let i = Int(rsr.split(separator: "s")[0]) {
                                rAfter = i
                            } else {
                                self.present(wrongStackingSequence, animated: true, completion: nil)
                                return false
                            }
                        } else {
                            self.present(wrongStackingSequence, animated: true, completion: nil)
                            return false
                        }
                    } else {
                        rAfter = 1
                        if let i = Int(rsr.split(separator: "s")[0]) {
                            rBefore = i
                        } else {
                            self.present(wrongStackingSequence, animated: true, completion: nil)
                            return false
                        }
                    }
                } else {
                    symmetry = 1
                    rBefore = 1
                    if let i = Int(rsr) {
                        rAfter = i
                    } else {
                        self.present(wrongStackingSequence, animated: true, completion: nil)
                        return false
                    }
                }
            } else {
                baseLayup = str.replacingOccurrences(of: "]", with: "").replacingOccurrences(of: "[", with: "")
                rBefore = 1
                rAfter = 1
                symmetry = 1
            }
            
            for i in baseLayup.components(separatedBy: "/") {
                if let j = Double(i) {
                    baseLayupSequence.append(j)
                } else {
                    self.present(wrongStackingSequence, animated: true, completion: nil)
                    return false
                }
            }
            
            nPly = baseLayupSequence.count * rBefore * symmetry * rAfter
            
            if nPly > 0 {
                
                for i in 1...nPly {
                    bzi.append((-Double(nPly+1)*t)/2 + Double(i)*t)
                }
                
                for _ in 1...rBefore {
                    for i in baseLayupSequence {
                        layupSequence.append(i)
                    }
                }
                
                baseLayupSequence = layupSequence
                
                if symmetry == 2 {
                    for i in baseLayupSequence.reversed() {
                        layupSequence.append(i)
                    }
                }
                
                baseLayupSequence = layupSequence
                
                if rAfter > 1 {
                    for _ in 2...rAfter {
                        for i in baseLayupSequence {
                            layupSequence.append(i)
                        }
                    }
                }
            } else {
                self.present(wrongStackingSequence, animated: true, completion: nil)
                return false
            }
        } else {
            self.present(emptyStackingSequence, animated: true, completion: nil)
            return false
        }
        
        // Handle material and calculate
        
        let wrongMaterialValue = UIAlertController(title: "Wrong Material Values", message: "Please double check!", preferredStyle: UIAlertController.Style.alert)
        wrongMaterialValue.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        var Cp : [Double] = []
        var Qep : [Double] = []
        
        if laminaMaterialType == .transverselyIsotropic {
            guard let e1 = Double(laminaMaterialPropertiesTextField[0].text!) else {            self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            guard let e2 = Double(laminaMaterialPropertiesTextField[1].text!) else {            self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            guard let g12 = Double(laminaMaterialPropertiesTextField[2].text!) else {            self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            guard let v12 = Double(laminaMaterialPropertiesTextField[3].text!) else {            self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            guard let v23 = Double(laminaMaterialPropertiesTextField[4].text!) else {            self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            
            let Sp : [Double] = [1/e1, -v12/e1, -v12/e1, 0, 0, 0, -v12/e1, 1/e2, -v23/e2, 0, 0, 0, -v12/e1, -v23/e2, 1/e2, 0, 0, 0, 0, 0, 0, 2*(1+v23)/e2, 0, 0, 0, 0, 0, 0, 1/g12, 0, 0, 0, 0, 0, 0, 1/g12]
            Cp = invert(matrix: Sp)
            
            let Sep : [Double] = [1/e1, -v12/e1, 0, -v12/e1, 1/e2, 0, 0, 0, 1/g12]
            Qep = invert(matrix: Sep)
            
        } else if laminaMaterialType == .orthotropic {
            guard let e1 = Double(laminaMaterialPropertiesTextField[0].text!) else {            self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            guard let e2 = Double(laminaMaterialPropertiesTextField[1].text!) else {            self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            guard let e3 = Double(laminaMaterialPropertiesTextField[2].text!) else {            self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            guard let g12 = Double(laminaMaterialPropertiesTextField[3].text!) else {            self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            guard let g13 = Double(laminaMaterialPropertiesTextField[4].text!) else {            self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            guard let g23 = Double(laminaMaterialPropertiesTextField[5].text!) else {            self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            guard let v12 = Double(laminaMaterialPropertiesTextField[6].text!) else {            self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            guard let v13 = Double(laminaMaterialPropertiesTextField[7].text!) else {            self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            guard let v23 = Double(laminaMaterialPropertiesTextField[8].text!) else {            self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            
            let Sp : [Double] = [1/e1, -v12/e1, -v13/e1, 0, 0, 0, -v12/e1, 1/e2, -v23/e2, 0, 0, 0, -v13/e1, -v23/e2, 1/e3, 0, 0, 0, 0, 0, 0, 1/g23, 0, 0, 0, 0, 0, 0, 1/g13, 0, 0, 0, 0, 0, 0, 1/g12]
            Cp = invert(matrix: Sp)
            
            let Sep : [Double] = [1/e1, -v12/e1, 0, -v12/e1, 1/e2, 0, 0, 0, 1/g12]
            Qep = invert(matrix: Sep)
            
        } else if laminaMaterialType == .anisotropic {
            guard let c11 = Double(laminaMaterialPropertiesTextField[0].text!) else {            self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            guard let c12 = Double(laminaMaterialPropertiesTextField[1].text!) else {            self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            guard let c13 = Double(laminaMaterialPropertiesTextField[2].text!) else {            self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            guard let c14 = Double(laminaMaterialPropertiesTextField[3].text!) else {            self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            guard let c15 = Double(laminaMaterialPropertiesTextField[4].text!) else {            self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            guard let c16 = Double(laminaMaterialPropertiesTextField[5].text!) else {            self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            guard let c22 = Double(laminaMaterialPropertiesTextField[6].text!) else {            self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            guard let c23 = Double(laminaMaterialPropertiesTextField[7].text!) else {            self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            guard let c24 = Double(laminaMaterialPropertiesTextField[8].text!) else {            self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            guard let c25 = Double(laminaMaterialPropertiesTextField[9].text!) else {            self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            guard let c26 = Double(laminaMaterialPropertiesTextField[10].text!) else {            self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            guard let c33 = Double(laminaMaterialPropertiesTextField[11].text!) else {            self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            guard let c34 = Double(laminaMaterialPropertiesTextField[12].text!) else {            self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            guard let c35 = Double(laminaMaterialPropertiesTextField[13].text!) else {            self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            guard let c36 = Double(laminaMaterialPropertiesTextField[14].text!) else {            self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            guard let c44 = Double(laminaMaterialPropertiesTextField[15].text!) else {            self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            guard let c45 = Double(laminaMaterialPropertiesTextField[16].text!) else {            self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            guard let c46 = Double(laminaMaterialPropertiesTextField[17].text!) else {            self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            guard let c55 = Double(laminaMaterialPropertiesTextField[18].text!) else {            self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            guard let c56 = Double(laminaMaterialPropertiesTextField[19].text!) else {            self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            guard let c66 = Double(laminaMaterialPropertiesTextField[20].text!) else {            self.present(wrongMaterialValue, animated: true, completion: nil)
                return false
            }
            
            Cp = [c11, c12, c13, c14, c15, c16, c12, c22, c23, c24, c25, c26, c13, c23, c33, c34, c35, c36, c14, c24, c34, c44, c45, c46, c15, c25, c35, c45, c55, c56, c16, c26, c36, c46, c56, c66]
            
            Qep = [c11, c12, c16, c12, c22, c26, c16, c26, c66]
        }
        
        var tempCts = [Double](repeating: 0.0, count: 9)
        var tempCets = [Double](repeating: 0.0, count: 9)
        var Qs = [Double](repeating: 0.0, count: 9)
        var Cts = [Double](repeating: 0.0, count: 9)
        var Cets = [Double](repeating: 0.0, count: 9)
        var Ces = [Double](repeating: 0.0, count: 9)
        
        // Calculate effective 3D properties
        for i in 1...nPly {
            
            // Set up
            let c = cos(layupSequence[i-1] * Double.pi / 180)
            let s = sin(layupSequence[i-1] * Double.pi / 180)
            let Rsigma = [c*c, s*s, 0, 0, 0, -2*s*c, s*s, c*c, 0, 0, 0, 2*s*c, 0, 0, 1, 0, 0, 0, 0, 0, 0, c, s, 0, 0 ,0 ,0, -s, c, 0, s*c, -s*c, 0, 0, 0, c*c-s*s]
            var RsigmaT = [Double](repeating: 0.0, count: 36)
            vDSP_mtransD(Rsigma, 1, &RsigmaT, 1, 6, 6)
            
            var C = [Double](repeating: 0.0, count: 36)
            var temp1 = [Double](repeating: 0.0, count: 36)
            vDSP_mmulD(Rsigma,1,Cp,1,&temp1,1,6,6,6)
            vDSP_mmulD(temp1,1,RsigmaT,1,&C,1,6,6,6)
            
            // Get Ce, Cet, Ct
            let Ce = [C[0], C[1], C[5], C[1], C[7], C[11], C[5], C[11], C[35]]
            let Cet = [C[2], C[3], C[4], C[8], C[9], C[10], C[17], C[23], C[29]]
            let Ct = [C[14], C[15], C[16], C[15], C[21], C[22], C[16], C[22], C[28]]
            
            // Get Q
            var Q = [Double](repeating: 0.0, count: 9)
            let CtI = invert(matrix: Ct)
            var CetT = [Double](repeating: 0.0, count: 9)
            vDSP_mtransD(Cet, 1, &CetT, 1, 3, 3)
            
            var temp2 = [Double](repeating: 0.0, count: 9)
            var temp3 = [Double](repeating: 0.0, count: 9)
            vDSP_mmulD(Cet,1,CtI,1,&temp2,1,3,3,3)
            vDSP_mmulD(temp2,1,CetT,1,&temp3,1,3,3,3)
            vDSP_vsubD(temp3, 1, Ce, 1, &Q, 1, 9)
            
            // Get tempCts, Qs, tempCets
            vDSP_vaddD(Qs, 1, Q, 1, &Qs, 1, 9)
            vDSP_vaddD(tempCts, 1, CtI, 1, &tempCts, 1, 9)
            var temp4 = [Double](repeating: 0.0, count: 9)
            vDSP_mmulD(Cet,1,CtI,1,&temp4,1,3,3,3)
            vDSP_vaddD(tempCets, 1, temp4, 1, &tempCets, 1, 9)
        }
        
        // Get average tempCts, Qs, tempCets
        var nPlyD = Double(nPly)
        vDSP_vsdivD(Qs, 1, &nPlyD, &Qs, 1, 9)
        vDSP_vsdivD(tempCts, 1, &nPlyD, &tempCts, 1, 9)
        vDSP_vsdivD(tempCets, 1, &nPlyD, &tempCets, 1, 9)
        
        
        // Get Cts, Cets, Cet
        Cts = invert(matrix: tempCts)
        vDSP_mmulD(tempCets,1,Cts,1,&Cets,1,3,3,3)
        let CtsI = invert(matrix: Cts)
        var CetsT = [Double](repeating: 0.0, count: 9)
        vDSP_mtransD(Cets, 1, &CetsT, 1, 3, 3)
        var temp7 = [Double](repeating: 0.0, count: 9)
        vDSP_mmulD(Cets,1,CtsI,1,&temp7,1,3,3,3)
        var temp8 = [Double](repeating: 0.0, count: 9)
        vDSP_mmulD(temp7,1,CetsT,1,&temp8,1,3,3,3)
        vDSP_vaddD(Qs, 1, temp8, 1, &Ces, 1, 9)
        
        // Get Cs
        let Cs = [Ces[0], Ces[1], Cets[0], Cets[1], Cets[2], Ces[2], Ces[3], Ces[4], Cets[3], Cets[4], Cets[5], Ces[5], Cets[0], Cets[3], Cts[0], Cts[1], Cts[2], Cets[6], Cets[1], Cets[4], Cts[1], Cts[4], Cts[7], Cets[7], Cets[2], Cets[5], Cts[2], Cts[5], Cts[8], Cets[8], Ces[6], Ces[7], Cets[6], Cets[7], Cets[8], Ces[8]]
        
        let Ss = invert(matrix: Cs)
        
        
        // Effective 3D properties
        if laminaMaterialType == .transverselyIsotropic {
            effective3DPropertiesMonoclinic[0] = 1/Ss[0]
            effective3DPropertiesMonoclinic[1] = 1/Ss[7]
            effective3DPropertiesMonoclinic[2] = 1/Ss[14]
            effective3DPropertiesMonoclinic[3] = 1/Ss[35]
            effective3DPropertiesMonoclinic[4] = 1/Ss[28]
            effective3DPropertiesMonoclinic[5] = 1/Ss[21]
            effective3DPropertiesMonoclinic[6] = -1/Ss[0]*Ss[1]
            effective3DPropertiesMonoclinic[7] = -1/Ss[0]*Ss[2]
            effective3DPropertiesMonoclinic[8] = -1/Ss[7]*Ss[8]
            effective3DPropertiesMonoclinic[9] = -1/Ss[35]*Ss[5]
            effective3DPropertiesMonoclinic[10] = -1/Ss[35]*Ss[11]
            effective3DPropertiesMonoclinic[11] = -1/Ss[35]*Ss[17]
            effective3DPropertiesMonoclinic[12] = -1/Ss[28]*Ss[22]
        } else if laminaMaterialType == .orthotropic {
            effective3DPropertiesMonoclinic[0] = 1/Ss[0]
            effective3DPropertiesMonoclinic[1] = 1/Ss[7]
            effective3DPropertiesMonoclinic[2] = 1/Ss[14]
            effective3DPropertiesMonoclinic[3] = 1/Ss[35]
            effective3DPropertiesMonoclinic[4] = 1/Ss[28]
            effective3DPropertiesMonoclinic[5] = 1/Ss[21]
            effective3DPropertiesMonoclinic[6] = -1/Ss[0]*Ss[1]
            effective3DPropertiesMonoclinic[7] = -1/Ss[0]*Ss[2]
            effective3DPropertiesMonoclinic[8] = -1/Ss[7]*Ss[8]
            effective3DPropertiesMonoclinic[9] = -1/Ss[35]*Ss[5]
            effective3DPropertiesMonoclinic[10] = -1/Ss[35]*Ss[11]
            effective3DPropertiesMonoclinic[11] = -1/Ss[35]*Ss[17]
            effective3DPropertiesMonoclinic[12] = -1/Ss[28]*Ss[22]
        } else if laminaMaterialType == .anisotropic {
            effective3DPropertiesAnisotropic[0]  = Cs[0]
            effective3DPropertiesAnisotropic[1]  = Cs[1]
            effective3DPropertiesAnisotropic[2]  = Cs[2]
            effective3DPropertiesAnisotropic[3]  = Cs[3]
            effective3DPropertiesAnisotropic[4]  = Cs[4]
            effective3DPropertiesAnisotropic[5]  = Cs[5]
            effective3DPropertiesAnisotropic[6]  = Cs[7]
            effective3DPropertiesAnisotropic[7]  = Cs[8]
            effective3DPropertiesAnisotropic[8]  = Cs[9]
            effective3DPropertiesAnisotropic[9]  = Cs[10]
            effective3DPropertiesAnisotropic[10] = Cs[11]
            effective3DPropertiesAnisotropic[11] = Cs[14]
            effective3DPropertiesAnisotropic[12] = Cs[15]
            effective3DPropertiesAnisotropic[13] = Cs[16]
            effective3DPropertiesAnisotropic[14] = Cs[17]
            effective3DPropertiesAnisotropic[15] = Cs[21]
            effective3DPropertiesAnisotropic[16] = Cs[22]
            effective3DPropertiesAnisotropic[17] = Cs[23]
            effective3DPropertiesAnisotropic[18] = Cs[28]
            effective3DPropertiesAnisotropic[19] = Cs[29]
            effective3DPropertiesAnisotropic[20] = Cs[35]
        }
        
        
        // Calculate A, B, and D matrices
        
        var A = [Double](repeating: 0.0, count: 9)
        var B = [Double](repeating: 0.0, count: 9)
        var D = [Double](repeating: 0.0, count: 9)
        for i in 1...nPly {
            let c = cos(layupSequence[i-1] * Double.pi / 180)
            let s = sin(layupSequence[i-1] * Double.pi / 180)
            let Rsigmae = [c*c, s*s, -2*s*c, s*s, c*c, 2*s*c, s*c, -s*c, c*c-s*s]
            var RsigmaeT = [Double](repeating: 0.0, count: 9)
            vDSP_mtransD(Rsigmae, 1, &RsigmaeT, 1, 3, 3)
            
            var Qe = [Double](repeating: 0.0, count: 9)
            var Atemp = [Double](repeating: 0.0, count: 9)
            var Btemp = [Double](repeating: 0.0, count: 9)
            var Dtemp = [Double](repeating: 0.0, count: 9)
            
            var temp1 = [Double](repeating: 0.0, count: 9)
            vDSP_mmulD(Rsigmae,1,Qep,1,&temp1,1,3,3,3)
            vDSP_mmulD(temp1,1,RsigmaeT,1,&Qe,1,3,3,3)
            
            vDSP_vsmulD(Qe, 1, &t, &Atemp, 1, 9)
            
            var temp2 = bzi[i-1]*t
            vDSP_vsmulD(Qe, 1, &temp2, &Btemp, 1, 9)
            
            var temp3 = t*bzi[i-1]*bzi[i-1] + pow(t, 3.0)/12
            vDSP_vsmulD(Qe, 1, &temp3, &Dtemp, 1, 9)
            
            vDSP_vaddD(A, 1, Atemp, 1, &A, 1, 9)
            vDSP_vaddD(B, 1, Btemp, 1, &B, 1, 9)
            vDSP_vaddD(D, 1, Dtemp, 1, &D, 1, 9)
        }
        
        let ABD = [A[0], A[1], A[2], B[0], B[1], B[2], A[3], A[4], A[5], B[3], B[4], B[5], A[6], A[7], A[8], B[6], B[7], B[8], B[0], B[3], B[6], D[0], D[1], D[2], B[1], B[4], B[7], D[3], D[4], D[5], B[2], B[5], B[8], D[6], D[7], D[8]]
        
        var abd = invert(matrix: ABD)
        
        var h = nPlyD * t
        
        let AI = [abd[0], abd[1], abd[2], abd[6], abd[7], abd[8], abd[12], abd[13], abd[14]]
        
        let DI = [abd[21], abd[22], abd[23], abd[27], abd[28], abd[29], abd[33], abd[34], abd[35]]
        
        var Ses = [Double](repeating: 0.0, count: 9)
        vDSP_vsmulD(AI, 1, &h, &Ses, 1, 9)
        
        var Sesf = [Double](repeating: 0.0, count: 9)
        var temph = pow(h, 3.0) / 12.0
        vDSP_vsmulD(DI, 1, &temph, &Sesf, 1, 9)
        
        effectiveInplaneProperties[0] = 1/Ses[0]
        effectiveInplaneProperties[1] = 1/Ses[4]
        effectiveInplaneProperties[2] = 1/Ses[8]
        effectiveInplaneProperties[3] = -1/Ses[0]*Ses[1]
        effectiveInplaneProperties[4] = 1/Ses[8]*Ses[2]
        effectiveInplaneProperties[5] = 1/Ses[8]*Ses[5]
        
        effectiveFlexuralProperties[0] = 1/Sesf[0]
        effectiveFlexuralProperties[1] = 1/Sesf[4]
        effectiveFlexuralProperties[2] = 1/Sesf[8]
        effectiveFlexuralProperties[3] = -1/Sesf[0]*Sesf[1]
        effectiveFlexuralProperties[4] = 1/Sesf[8]*Sesf[2]
        effectiveFlexuralProperties[5] = 1/Sesf[8]*Sesf[5]
        
        
        if typeOfAnalysisLabelButton.titleLabel?.text == "Thermoelastic Analysis" {
            
            let wrongCTEValue = UIAlertController(title: "Wrong CTE Values", message: "Please double check!", preferredStyle: UIAlertController.Style.alert)
            wrongCTEValue.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            var alphap : [Double] = []
            
            if laminaMaterialType == .transverselyIsotropic {
                guard let alpha11 = Double(laminaMaterialPropertiesTextField[5].text!) else {            self.present(wrongCTEValue, animated: true, completion: nil)
                    return false
                }
                guard let alpha22 = Double(laminaMaterialPropertiesTextField[6].text!) else {            self.present(wrongCTEValue, animated: true, completion: nil)
                    return false
                }
                
                alphap = [alpha11, alpha22, alpha22, 0, 0, 0]
                
            } else if laminaMaterialType == .orthotropic {
                guard let alpha11 = Double(laminaMaterialPropertiesTextField[9].text!) else {            self.present(wrongCTEValue, animated: true, completion: nil)
                    return false
                }
                guard let alpha22 = Double(laminaMaterialPropertiesTextField[10].text!) else {            self.present(wrongCTEValue, animated: true, completion: nil)
                    return false
                }
                guard let alpha33 = Double(laminaMaterialPropertiesTextField[11].text!) else {            self.present(wrongCTEValue, animated: true, completion: nil)
                    return false
                }
                
                alphap = [alpha11, alpha22, alpha33, 0, 0, 0]
                
            } else if laminaMaterialType == .anisotropic {
                guard let alpha11 = Double(laminaMaterialPropertiesTextField[21].text!) else {            self.present(wrongCTEValue, animated: true, completion: nil)
                    return false
                }
                guard let alpha22 = Double(laminaMaterialPropertiesTextField[22].text!) else {            self.present(wrongCTEValue, animated: true, completion: nil)
                    return false
                }
                guard let alpha33 = Double(laminaMaterialPropertiesTextField[23].text!) else {            self.present(wrongCTEValue, animated: true, completion: nil)
                    return false
                }
                guard let alpha23 = Double(laminaMaterialPropertiesTextField[24].text!) else {            self.present(wrongCTEValue, animated: true, completion: nil)
                    return false
                }
                guard let alpha13 = Double(laminaMaterialPropertiesTextField[25].text!) else {            self.present(wrongCTEValue, animated: true, completion: nil)
                    return false
                }
                guard let alpha12 = Double(laminaMaterialPropertiesTextField[26].text!) else {            self.present(wrongCTEValue, animated: true, completion: nil)
                    return false
                }
                
                alphap = [alpha11, alpha22, alpha33, alpha23, alpha13, alpha12]
            }
        
        
            var tempalphaes = [Double](repeating: 0.0, count: 3)
            var tempalphats = [Double](repeating: 0.0, count: 3)
        
            var tempCts = [Double](repeating: 0.0, count: 9)
            var tempCets = [Double](repeating: 0.0, count: 9)
            var Qs = [Double](repeating: 0.0, count: 9)
            var Cts = [Double](repeating: 0.0, count: 9)
            var Cets = [Double](repeating: 0.0, count: 9)
            var Ces = [Double](repeating: 0.0, count: 9)
        
            // Calculate effective 3D properties
            for i in 1...nPly {
                
                // Set up
                let c = cos(layupSequence[i-1] * Double.pi / 180)
                let s = sin(layupSequence[i-1] * Double.pi / 180)
                let Rsigma = [c*c, s*s, 0, 0, 0, -2*s*c, s*s, c*c, 0, 0, 0, 2*s*c, 0, 0, 1, 0, 0, 0, 0, 0, 0, c, s, 0, 0 ,0 ,0, -s, c, 0, s*c, -s*c, 0, 0, 0, c*c-s*s]
                var RsigmaT = [Double](repeating: 0.0, count: 36)
                vDSP_mtransD(Rsigma, 1, &RsigmaT, 1, 6, 6)
                let Repsilon = invert(matrix: RsigmaT)
                
                var C = [Double](repeating: 0.0, count: 36)
                var temp1 = [Double](repeating: 0.0, count: 36)
                vDSP_mmulD(Rsigma,1,Cp,1,&temp1,1,6,6,6)
                vDSP_mmulD(temp1,1,RsigmaT,1,&C,1,6,6,6)
                
                // Get Ce, Cet, Ct
                let Ce = [C[0], C[1], C[5], C[1], C[7], C[11], C[5], C[11], C[35]]
                let Cet = [C[2], C[3], C[4], C[8], C[9], C[10], C[17], C[23], C[29]]
                let Ct = [C[14], C[15], C[16], C[15], C[21], C[22], C[16], C[22], C[28]]
                
                // Get Q
                var Q = [Double](repeating: 0.0, count: 9)
                let CtI = invert(matrix: Ct)
                var CetT = [Double](repeating: 0.0, count: 9)
                vDSP_mtransD(Cet, 1, &CetT, 1, 3, 3)
                
                var temp2 = [Double](repeating: 0.0, count: 9)
                var temp3 = [Double](repeating: 0.0, count: 9)
                vDSP_mmulD(Cet,1,CtI,1,&temp2,1,3,3,3)
                vDSP_mmulD(temp2,1,CetT,1,&temp3,1,3,3,3)
                vDSP_vsubD(temp3, 1, Ce, 1, &Q, 1, 9)
                
                // Get tempCts, Qs, tempCets
                vDSP_vaddD(Qs, 1, Q, 1, &Qs, 1, 9)
                vDSP_vaddD(tempCts, 1, CtI, 1, &tempCts, 1, 9)
                var temp4 = [Double](repeating: 0.0, count: 9)
                vDSP_mmulD(Cet,1,CtI,1,&temp4,1,3,3,3)
                vDSP_vaddD(tempCets, 1, temp4, 1, &tempCets, 1, 9)
                
                // Get alphaes
                
                var alpha = [Double](repeating: 0.0, count: 6)
                vDSP_mmulD(Repsilon,1,alphap,1,&alpha,1,6,1,6)
                
                let alphae = [alpha[0], alpha[1], alpha[5]]
                let alphat = [alpha[2], alpha[3], alpha[4]]
                
                // Get tempalphate, tempalphats
                var temp5 = [Double](repeating: 0.0, count: 3)
                vDSP_mmulD(Q,1,alphae,1,&temp5,1,3,1,3)
                vDSP_vaddD(tempalphaes, 1, temp5, 1, &tempalphaes, 1, 3)
                
                vDSP_mmulD(CtI,1,CetT,1,&temp2,1,3,3,3)
                vDSP_mmulD(temp2,1,alphae,1,&temp5,1,3,1,3)
                
                var temp6 = [Double](repeating: 0.0, count: 3)
                vDSP_vaddD(alphat, 1, temp5, 1, &temp6, 1, 3)
                vDSP_vaddD(tempalphats, 1, temp6, 1, &tempalphats, 1, 3)
            }
        
            // Get average tempCts, Qs, tempCets
            var nPlyD = Double(nPly)
            vDSP_vsdivD(Qs, 1, &nPlyD, &Qs, 1, 9)
            vDSP_vsdivD(tempCts, 1, &nPlyD, &tempCts, 1, 9)
            vDSP_vsdivD(tempCets, 1, &nPlyD, &tempCets, 1, 9)
        
        
            // Get Cts, Cets, Cet
            Cts = invert(matrix: tempCts)
            vDSP_mmulD(tempCets,1,Cts,1,&Cets,1,3,3,3)
            let CtsI = invert(matrix: Cts)
            var CetsT = [Double](repeating: 0.0, count: 9)
            vDSP_mtransD(Cets, 1, &CetsT, 1, 3, 3)
            var temp7 = [Double](repeating: 0.0, count: 9)
            vDSP_mmulD(Cets,1,CtsI,1,&temp7,1,3,3,3)
            var temp8 = [Double](repeating: 0.0, count: 9)
            vDSP_mmulD(temp7,1,CetsT,1,&temp8,1,3,3,3)
            vDSP_vaddD(Qs, 1, temp8, 1, &Ces, 1, 9)
        
            // Get alphaes, alphats
            vDSP_vsdivD(tempalphaes, 1, &nPlyD, &tempalphaes, 1, 3)
            vDSP_vsdivD(tempalphats, 1, &nPlyD, &tempalphats, 1, 3)
        
            let QsI = invert(matrix: Qs)
            var alphaes = [Double](repeating: 0.0, count: 3)
            vDSP_mmulD(QsI,1,tempalphaes,1,&alphaes,1,3,1,3)
        
            var alphats = [Double](repeating: 0.0, count: 3)
            var temp9 = [Double](repeating: 0.0, count: 9)
            var temp10 = [Double](repeating: 0.0, count: 3)
            vDSP_mmulD(CtsI,1,CetsT,1,&temp9,1,3,3,3)
            vDSP_mmulD(temp9,1,alphaes,1,&temp10,1,3,1,3)
            vDSP_vsubD(temp10, 1, tempalphats, 1, &alphats, 1, 3)
        
            if laminaMaterialType == .transverselyIsotropic {
                effective3DPropertiesMonoclinicThermal[0] = alphaes[0]
                effective3DPropertiesMonoclinicThermal[1] = alphaes[1]
                effective3DPropertiesMonoclinicThermal[2] = alphats[0]
                effective3DPropertiesMonoclinicThermal[3] = alphaes[2]/2
            } else if laminaMaterialType == .orthotropic {
                effective3DPropertiesMonoclinicThermal[0] = alphaes[0]
                effective3DPropertiesMonoclinicThermal[1] = alphaes[1]
                effective3DPropertiesMonoclinicThermal[2] = alphats[0]
                effective3DPropertiesMonoclinicThermal[3] = alphaes[2]/2
            } else if laminaMaterialType == .anisotropic {
                effective3DPropertiesAnisotropicThermal[0] = alphaes[0]
                effective3DPropertiesAnisotropicThermal[1] = alphaes[1]
                effective3DPropertiesAnisotropicThermal[2] = alphats[0]
                effective3DPropertiesAnisotropicThermal[3] = alphats[1]/2
                effective3DPropertiesAnisotropicThermal[3] = alphats[2]/2
                effective3DPropertiesAnisotropicThermal[3] = alphaes[2]/2
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







