//
//  UDFRC.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 10/29/17.
//  Copyright © 2017 Banghua Zhao. All rights reserved.
//

import UIKit
import Accelerate

class UDFRC: UIViewController {
    
    var engineeringConstants = [Double](repeating: 0.0, count: 7)
    var planeStressReducedCompliance = [Double](repeating: 0.0, count: 9)
    var planeStressReducedStiffness = [Double](repeating: 0.0, count: 9)
    
    var materialPropertyName = MaterialPropertyName()
    var materialPropertyLabel = MaterialPropertyLabel()
    var materialPropertyPlaceHolder = MaterialPropertyPlaceHolder()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var userSavedFiberMaterials = [UserFiberMaterial]()
    var userSavedMatrixMaterials = [UserMatrixMaterial]()

    
    // layout
    
    var scrollView: UIScrollView = UIScrollView()
    
    // first section
    
    var methodView: UIView = UIView()
    
    var methodDataBase: UIButton = UIButton()
    
    var methodDataBaseAlterController : UIAlertController!
    
    var methodLabel: UILabel = UILabel()
    
    
    // second section

    var geometryView: UIView = UIView()

    var geometryLabel: UILabel = UILabel()
    
    var volumeFractionSlider: UISlider = UISlider()
    
    
    // third section
   
    var fiberView: UIView = UIView()
    
    var fiberDataBase: UIButton = UIButton()
    
    var fiberMaterialDataBaseAlterController : UIAlertController!
    
    var fiberMaterialCardView: UIView = UIView()
    
    var fiberNameLabel: UILabel = UILabel()
    
    var fiberMaterialPropertiesLabel: [UILabel] = []
    
    var fiberMaterialPropertiesTextField: [UITextField] = []
    
    var saveFiberMaterialButton: UIButton = UIButton()
    
    var deleteFiberMaterialButton: UIButton = UIButton()
    
    
    // fourth section
    
    var matrixView: UIView = UIView()
    
    var matrixDataBase: UIButton = UIButton()
    
    var matrixMaterialDataBaseAlterController : UIAlertController!
    
    var matrixMaterialCardView: UIView = UIView()
    
    var matrixNameLabel: UILabel = UILabel()
    
    var matrixMaterialPropertiesLabel: [UILabel] = []
    
    var matrixMaterialPropertiesTextField: [UITextField] = []
    
    var saveMatrixMaterialButton: UIButton = UIButton()
    
    var deleteMatrixMaterialButton: UIButton = UIButton()
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white

        hideKeyboardWhenTappedAround()
        
        createLayout()
        
        createActionSheet()
        
        changeMaterialDataField()
        
        editNavigationBar()
        
        loadCoreData()
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        createActionSheet()
        
        loadCoreData()
        
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
        scrollView.addSubview(geometryView)
        scrollView.addSubview(fiberView)
        scrollView.addSubview(matrixView)
        
        
        // first section
        
        creatViewCard(viewCard: methodView, title: "Method", aboveConstraint: scrollView.topAnchor, under: scrollView)
        methodView.addSubview(methodDataBase)
        methodView.addSubview(methodLabel)
        
        methodDataBase.setTitle("Method Database", for: UIControlState.normal)
        methodDataBase.addTarget(self, action: #selector(changeMethod(_:)), for: .touchUpInside)
        methodDataBase.dataBaseButtonDesign()
        methodDataBase.heightAnchor.constraint(equalToConstant: 40).isActive = true
        methodDataBase.widthAnchor.constraint(greaterThanOrEqualToConstant: methodDataBase.intrinsicContentSize.width + 40).isActive = true
        methodDataBase.topAnchor.constraint(equalTo: methodView.topAnchor, constant: 40).isActive = true
        methodDataBase.centerXAnchor.constraint(equalTo: methodView.centerXAnchor).isActive = true
        
        methodLabel.translatesAutoresizingMaskIntoConstraints = false
        methodLabel.text = "Voigt Rules of Mixture"
        methodLabel.textAlignment = .center
        methodLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        methodLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: methodDataBase.intrinsicContentSize.width + 20).isActive = true
        methodLabel.topAnchor.constraint(equalTo: methodDataBase.bottomAnchor, constant: 8).isActive = true
        methodLabel.centerXAnchor.constraint(equalTo: methodView.centerXAnchor).isActive = true
        methodLabel.bottomAnchor.constraint(equalTo: methodView.bottomAnchor, constant: -20).isActive = true
        
        
        // second section
        
        creatViewCard(viewCard: geometryView, title: "Geometry", aboveConstraint: methodView.bottomAnchor, under: scrollView)
        geometryView.addSubview(geometryLabel)
        geometryView.addSubview(volumeFractionSlider)
        
        geometryLabel.translatesAutoresizingMaskIntoConstraints = false
        geometryLabel.text = "Fiber Volume Fraction: 0.50"
        geometryLabel.textAlignment = .center
        geometryLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        geometryLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: geometryLabel.intrinsicContentSize.width + 20).isActive = true
        geometryLabel.topAnchor.constraint(equalTo: geometryView.topAnchor, constant: 40).isActive = true
        geometryLabel.centerXAnchor.constraint(equalTo: geometryView.centerXAnchor).isActive = true
        
        volumeFractionSlider.minimumValue = 0
        volumeFractionSlider.maximumValue = 1.00
        volumeFractionSlider.isContinuous = true
        volumeFractionSlider.value = 0.50
        volumeFractionSlider.addTarget(self, action: #selector(changeVolumeFraction), for: .valueChanged)
        volumeFractionSlider.translatesAutoresizingMaskIntoConstraints = false
        volumeFractionSlider.topAnchor.constraint(equalTo: geometryLabel.bottomAnchor, constant: 0).isActive = true
        volumeFractionSlider.widthAnchor.constraint(equalTo: geometryView.widthAnchor, multiplier: 0.8).isActive = true
        volumeFractionSlider.centerXAnchor.constraint(equalTo: geometryView.centerXAnchor, constant: 0).isActive = true
        volumeFractionSlider.heightAnchor.constraint(equalToConstant: 30).isActive = true
        volumeFractionSlider.bottomAnchor.constraint(equalTo: geometryView.bottomAnchor, constant: -20).isActive = true

        
        // third secion
        
        creatViewCard(viewCard: fiberView, title: "Fiber Material", aboveConstraint: geometryView.bottomAnchor, under: scrollView)
        fiberView.addSubview(fiberDataBase)
        fiberView.addSubview(fiberMaterialCardView)
        fiberView.addSubview(saveFiberMaterialButton)
        fiberView.addSubview(deleteFiberMaterialButton)

        
        fiberDataBase.setTitle("Fiber Material Database", for: UIControlState.normal)
        fiberDataBase.addTarget(self, action: #selector(changeFiberMaterial(_:)), for: .touchUpInside)
        fiberDataBase.dataBaseButtonDesign()
        fiberDataBase.heightAnchor.constraint(equalToConstant: 40).isActive = true
        fiberDataBase.widthAnchor.constraint(greaterThanOrEqualToConstant: fiberDataBase.intrinsicContentSize.width + 40).isActive = true
        fiberDataBase.topAnchor.constraint(equalTo: fiberView.topAnchor, constant: 40).isActive = true
        fiberDataBase.centerXAnchor.constraint(equalTo: fiberView.centerXAnchor).isActive = true
        
        
        fiberNameLabel.text = "E-Glass"
        for i in 0...6 {
            fiberMaterialPropertiesLabel.append(UILabel())
            fiberMaterialPropertiesLabel[i].text = materialPropertyName.transverseIsotropic[i]
            
            fiberMaterialPropertiesTextField.append(UITextField())
            fiberMaterialPropertiesTextField[i].placeholder = materialPropertyPlaceHolder.orthotropic[i]
            fiberMaterialPropertiesTextField[i].keyboardType = UIKeyboardType.decimalPad
        }
        
        createMaterialCard(materialCard: fiberMaterialCardView, materialName: fiberNameLabel, label: fiberMaterialPropertiesLabel, value: fiberMaterialPropertiesTextField, aboveConstraint: fiberDataBase.bottomAnchor, under: fiberView)
        
        saveFiberMaterialButton.addTarget(self, action: #selector(saveFiberMaterial), for: .touchUpInside)
        saveFiberMaterialButton.saveMaterialButtonDesign()
        saveFiberMaterialButton.topAnchor.constraint(equalTo: fiberMaterialCardView.bottomAnchor, constant: 8).isActive = true
        saveFiberMaterialButton.centerXAnchor.constraint(equalTo: fiberMaterialCardView.centerXAnchor).isActive = true
        
        deleteFiberMaterialButton.addTarget(self, action: #selector(deleteFiberMaterial), for: .touchUpInside)
        deleteFiberMaterialButton.deleteMaterialButtonDesign()
        deleteFiberMaterialButton.topAnchor.constraint(equalTo: saveFiberMaterialButton.bottomAnchor, constant: 8).isActive = true
        deleteFiberMaterialButton.centerXAnchor.constraint(equalTo: saveFiberMaterialButton.centerXAnchor).isActive = true
        deleteFiberMaterialButton.bottomAnchor.constraint(equalTo: fiberView.bottomAnchor, constant: -20).isActive = true
        
        
        // fourth secion
        
        creatViewCard(viewCard: matrixView, title: "Matrix Material", aboveConstraint: fiberView.bottomAnchor, under: scrollView)
        matrixView.addSubview(matrixDataBase)
        matrixView.addSubview(matrixMaterialCardView)
        matrixView.addSubview(saveMatrixMaterialButton)
        matrixView.addSubview(deleteMatrixMaterialButton)
        
        matrixDataBase.setTitle("Matrix Material Database", for: UIControlState.normal)
        matrixDataBase.addTarget(self, action: #selector(changeMatrixMaterial(_:)), for: .touchUpInside)
        matrixDataBase.dataBaseButtonDesign()
        matrixDataBase.heightAnchor.constraint(equalToConstant: 40).isActive = true
        matrixDataBase.widthAnchor.constraint(greaterThanOrEqualToConstant: matrixDataBase.intrinsicContentSize.width + 40).isActive = true
        matrixDataBase.topAnchor.constraint(equalTo: matrixView.topAnchor, constant: 40).isActive = true
        matrixDataBase.centerXAnchor.constraint(equalTo: matrixView.centerXAnchor).isActive = true
        
        matrixNameLabel.text = "Epoxy"
        for i in 0...2 {
            matrixMaterialPropertiesLabel.append(UILabel())
            matrixMaterialPropertiesLabel[i].text = materialPropertyName.isotropic[i]
            
            matrixMaterialPropertiesTextField.append(UITextField())
            matrixMaterialPropertiesTextField[i].placeholder = materialPropertyPlaceHolder.orthotropic[i]
            matrixMaterialPropertiesTextField[i].keyboardType = UIKeyboardType.decimalPad
            
        }
        
        createMaterialCard(materialCard: matrixMaterialCardView, materialName: matrixNameLabel, label: matrixMaterialPropertiesLabel, value: matrixMaterialPropertiesTextField, aboveConstraint: matrixDataBase.bottomAnchor, under: matrixView)
        
        
        saveMatrixMaterialButton.addTarget(self, action: #selector(saveMatrixMaterial), for: .touchUpInside)
        saveMatrixMaterialButton.saveMaterialButtonDesign()
        saveMatrixMaterialButton.topAnchor.constraint(equalTo: matrixMaterialCardView.bottomAnchor, constant: 8).isActive = true
        saveMatrixMaterialButton.centerXAnchor.constraint(equalTo: matrixMaterialCardView.centerXAnchor).isActive = true
        
        deleteMatrixMaterialButton.addTarget(self, action: #selector(deleteMatrixMaterial), for: .touchUpInside)
        deleteMatrixMaterialButton.deleteMaterialButtonDesign()
        deleteMatrixMaterialButton.topAnchor.constraint(equalTo: saveMatrixMaterialButton.bottomAnchor, constant: 8).isActive = true
        deleteMatrixMaterialButton.centerXAnchor.constraint(equalTo: saveMatrixMaterialButton.centerXAnchor).isActive = true
        deleteMatrixMaterialButton.bottomAnchor.constraint(equalTo: matrixView.bottomAnchor, constant: -20).isActive = true
        
        matrixView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20).isActive = true
        
    }
    
    
    // UIbutton action functions
    
    @objc func changeMethod(_ sender: UIButton) {
        sender.flash()
        self.present(methodDataBaseAlterController, animated: true, completion: nil)
    }
    
    @objc func changeVolumeFraction(_ sender: UISlider) {
        geometryLabel.text = "Fiber Volume Fraction: " + String(format: "%.2f", sender.value)
    }
    
    @objc func changeFiberMaterial(_ sender: UIButton) {
        sender.flash()
        self.present(fiberMaterialDataBaseAlterController, animated: true, completion: nil)
    }
    @objc func changeMatrixMaterial(_ sender: UIButton) {
        sender.flash()
        self.present(matrixMaterialDataBaseAlterController, animated: true, completion: nil)
    }
    
    @objc func saveFiberMaterial(_ sender: UIButton) {
        sender.flash()
        
        let inputAlter = UIAlertController(title: "Save Material", message: "Enter the material name.", preferredStyle: UIAlertControllerStyle.alert)
        inputAlter.addTextField { (textField: UITextField) in
            textField.placeholder = "Material Name"
        }
        inputAlter.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        inputAlter.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action:UIAlertAction) in
            
            let materialNameTextField = inputAlter.textFields?.first
            
            // check empty name
            
            let emptyNameAlter = UIAlertController(title: "Empty Name", message: "Please enter a name for this material.", preferredStyle: UIAlertControllerStyle.alert)
            emptyNameAlter.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            var userMaterialName : String = ""
            
            if materialNameTextField?.text != "" {
                userMaterialName = (materialNameTextField?.text)!
            }
            else {
                self.present(emptyNameAlter, animated: true, completion: nil)
                return
            }
            
            // check wrong or empty material valuw
            
            var  fiberMaterialArray : [Double] = []
            
            let wrongMaterialValueAlter = UIAlertController(title: "Wrong Material Values", message: "Please enter valid values (number) for this material.", preferredStyle: UIAlertControllerStyle.alert)
            wrongMaterialValueAlter.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            let emptyMaterialValueAlter = UIAlertController(title: "Empty Material Value", message: "Please enter values (number) for this material.", preferredStyle: UIAlertControllerStyle.alert)
            emptyMaterialValueAlter.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            for i in 0...6 {
                if let valueString = self.fiberMaterialPropertiesTextField[i].text {
                    if let value = Double(valueString) {
                        fiberMaterialArray.append(value)
                    }
                    else {
                        self.present(wrongMaterialValueAlter, animated: true, completion: nil)
                        return
                    }
                }
                else {
                    self.present(emptyMaterialValueAlter, animated: true, completion: nil)
                    return
                }
            }
            
            print(fiberMaterialArray)
            
            // check same material name
            
            let sameMaterialNameAlter = UIAlertController(title: "Same Material Name", message: "Please enter a differet material name.", preferredStyle: UIAlertControllerStyle.alert)
            sameMaterialNameAlter.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            for name in ["User Defined Material", "E-Glass", "S-Glass", "Carbon (IM)", "Carbon (HM)", "Boron", "Kelvar-49"] {
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
            currentUserFiberMaterial.setValue(fiberMaterialArray, forKey: "properties")
            
            do {
                try self.context.save()
                self.loadCoreData()
            } catch {
                print("Could not save data: \(error.localizedDescription)")
            }
            
        }))
        
        self.present(inputAlter, animated: true, completion: nil)
        
    }
    
    @objc func deleteFiberMaterial(_ sender: UIButton) {
        sender.flash()
        let userSavedFiberViewController = UserSavedFiberMaterial()
        self.navigationController?.pushViewController(userSavedFiberViewController, animated: true)
    }
    
    
    @objc func saveMatrixMaterial(_ sender: UIButton) {
        sender.flash()
        
        let inputAlter = UIAlertController(title: "Save Material", message: "Enter the material name.", preferredStyle: UIAlertControllerStyle.alert)
        inputAlter.addTextField { (textField: UITextField) in
            textField.placeholder = "Material Name"
        }
        inputAlter.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        inputAlter.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action:UIAlertAction) in
            
            let materialNameTextField = inputAlter.textFields?.first
            
            // check empty name
            
            let emptyNameAlter = UIAlertController(title: "Empty Name", message: "Please enter a name for this material.", preferredStyle: UIAlertControllerStyle.alert)
            emptyNameAlter.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            var userMaterialName : String = ""
            
            if materialNameTextField?.text != "" {
                userMaterialName = (materialNameTextField?.text)!
            }
            else {
                self.present(emptyNameAlter, animated: true, completion: nil)
                return
            }
            
            // check wrong or empty material valuw
            
            var  matrixMaterialArray : [Double] = []
            
            let wrongMaterialValueAlter = UIAlertController(title: "Wrong Material Values", message: "Please enter valid values (number) for this material.", preferredStyle: UIAlertControllerStyle.alert)
            wrongMaterialValueAlter.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            let emptyMaterialValueAlter = UIAlertController(title: "Empty Material Value", message: "Please enter values (number) for this material.", preferredStyle: UIAlertControllerStyle.alert)
            emptyMaterialValueAlter.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            for i in 0...2 {
                if let valueString = self.matrixMaterialPropertiesTextField[i].text {
                    if let value = Double(valueString) {
                        matrixMaterialArray.append(value)
                    }
                    else {
                        self.present(wrongMaterialValueAlter, animated: true, completion: nil)
                        return
                    }
                }
                else {
                    self.present(emptyMaterialValueAlter, animated: true, completion: nil)
                    return
                }
            }
            
            // check same material name
            
            let sameMaterialNameAlter = UIAlertController(title: "Same Material Name", message: "Please enter a differet material name.", preferredStyle: UIAlertControllerStyle.alert)
            sameMaterialNameAlter.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            for name in ["User Defined Material", "Epoxy", "Polyester", "Polyimide", "PEEK", "Copper", "Silicon Carbide"] {
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
            currentUserMatrixMaterial.setValue(matrixMaterialArray, forKey: "properties")
            
            do {
                try self.context.save()
                self.loadCoreData()
            } catch {
                print("Could not save data: \(error.localizedDescription)")
            }
            
        }))
        
        self.present(inputAlter, animated: true, completion: nil)
        
    }
    
    
    
    @objc func deleteMatrixMaterial(_ sender: UIButton) {
        sender.flash()
        let userSavedMatrixViewController = UserSavedMatrixMaterial()
        self.navigationController?.pushViewController(userSavedMatrixViewController, animated: true)
    }
    
    
    // MARK: Create action sheet
    
    func createActionSheet() {
        
        methodDataBaseAlterController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let s0 = UIAlertAction(title: "Voigt Rules of Mixture", style: UIAlertActionStyle.default) { (action) -> Void in
            self.methodLabel.text = "Voigt Rules of Mixture"
        }
        
        let s1 = UIAlertAction(title: "Reuss Rules of Mixture", style: UIAlertActionStyle.default) { (action) -> Void in
            self.methodLabel.text = "Reuss Rules of Mixture"
        }
        
        let s2 = UIAlertAction(title: "Hybrid Rules of Mixture", style: UIAlertActionStyle.default) { (action) -> Void in
            self.methodLabel.text = "Hybrid Rules of Mixture"
        }
  
        methodDataBaseAlterController.addAction(s0)
        methodDataBaseAlterController.addAction(s1)
        methodDataBaseAlterController.addAction(s2)
        methodDataBaseAlterController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        
        // Action sheet for fiber material
        fiberMaterialDataBaseAlterController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let f0 = UIAlertAction(title: "Define Your Own", style: UIAlertActionStyle.default) { (action) -> Void in
            self.fiberNameLabel.text = "User Defined Material"
            self.changeMaterialDataField()
        }
        let f1 = UIAlertAction(title: "E-Glass", style: UIAlertActionStyle.default) { (action) -> Void in
            self.fiberNameLabel.text = "E-Glass"
            self.changeMaterialDataField()
        }
        let f2 = UIAlertAction(title: "S-Glass", style: UIAlertActionStyle.default) { (action) -> Void in
            self.fiberNameLabel.text = "S-Glass"
            self.changeMaterialDataField()
        }
        let f3 = UIAlertAction(title: "Carbon (IM)", style: UIAlertActionStyle.default) { (action) -> Void in
            self.fiberNameLabel.text = "Carbon (IM)"
            self.changeMaterialDataField()
        }
        let f4 = UIAlertAction(title: "Carbon (HM)", style: UIAlertActionStyle.default) { (action) -> Void in
            self.fiberNameLabel.text = "Carbon (HM)"
            self.changeMaterialDataField()
        }
        let f5 = UIAlertAction(title: "Boron", style: UIAlertActionStyle.default) { (action) -> Void in
            self.fiberNameLabel.text = "Boron"
            self.changeMaterialDataField()
        }
        let f6 = UIAlertAction(title: "Kelvar-49", style: UIAlertActionStyle.default) { (action) -> Void in
            self.fiberNameLabel.text = "Kelvar-49"
            self.changeMaterialDataField()
        }
        
        fiberMaterialDataBaseAlterController.addAction(f0)
        fiberMaterialDataBaseAlterController.addAction(f1)
        fiberMaterialDataBaseAlterController.addAction(f2)
        fiberMaterialDataBaseAlterController.addAction(f3)
        fiberMaterialDataBaseAlterController.addAction(f4)
        fiberMaterialDataBaseAlterController.addAction(f5)
        fiberMaterialDataBaseAlterController.addAction(f6)
        fiberMaterialDataBaseAlterController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        
        
        // Action sheet for matrix material
        matrixMaterialDataBaseAlterController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let m0 = UIAlertAction(title: "Define Your Own", style: UIAlertActionStyle.default) { (action) -> Void in
            self.matrixNameLabel.text = "User Defined Material"
            self.changeMaterialDataField()
        }
        let m1 = UIAlertAction(title: "Epoxy", style: UIAlertActionStyle.default) { (action) -> Void in
            self.matrixNameLabel.text = "Epoxy"
            self.changeMaterialDataField()
        }
        let m2 = UIAlertAction(title: "Polyester", style: UIAlertActionStyle.default) { (action) -> Void in
            self.matrixNameLabel.text = "Polyester"
            self.changeMaterialDataField()
        }
        let m3 = UIAlertAction(title: "Polyimide", style: UIAlertActionStyle.default) { (action) -> Void in
            self.matrixNameLabel.text = "Polyimide"
            self.changeMaterialDataField()
        }
        let m4 = UIAlertAction(title: "PEEK", style: UIAlertActionStyle.default) { (action) -> Void in
            self.matrixNameLabel.text = "PEEK"
            self.changeMaterialDataField()
        }
        let m5 = UIAlertAction(title: "Copper", style: UIAlertActionStyle.default) { (action) -> Void in
            self.matrixNameLabel.text = "Copper"
            self.changeMaterialDataField()
        }
        let m6 = UIAlertAction(title: "Silicon Carbide", style: UIAlertActionStyle.default) { (action) -> Void in
            self.matrixNameLabel.text = "Silicon Carbide"
            self.changeMaterialDataField()
        }
        
        matrixMaterialDataBaseAlterController.addAction(m0)
        matrixMaterialDataBaseAlterController.addAction(m1)
        matrixMaterialDataBaseAlterController.addAction(m2)
        matrixMaterialDataBaseAlterController.addAction(m3)
        matrixMaterialDataBaseAlterController.addAction(m4)
        matrixMaterialDataBaseAlterController.addAction(m5)
        matrixMaterialDataBaseAlterController.addAction(m6)
        matrixMaterialDataBaseAlterController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
    
    }
    
    
    
    
    // MARK: Change material data fields
    
    func changeMaterialDataField() {
        let allMaterials = MaterialBank()
        
        for material in allMaterials.list {
            
            // change fiber material card
            
            let fiberMaterialCurrectName = fiberNameLabel.text!
            
            if fiberMaterialCurrectName == material.materialName {
                for i in 0...6 {
                    fiberMaterialPropertiesTextField[i].text = String(format: "%.2f", material.materialProperties[materialPropertyLabel.transverseIsotropic[i]]!)
                }
            }
            else if fiberMaterialCurrectName == "User Defined Material" {
                for i in 0...6 {
                    fiberMaterialPropertiesTextField[i].text = ""
                }
            }
            else {
                for userSaveMaterial in userSavedFiberMaterials {
                    if fiberMaterialCurrectName == userSaveMaterial.name {
                        if let property = userSaveMaterial.properties {
                            for i in 0...6 {
                                fiberMaterialPropertiesTextField[i].text = String(format: "%.2f", property[i])
                            }
                        }
                    }
                }
            }
            
            // change matrix material card
            
            let matrixMaterialCurrectName = matrixNameLabel.text!
            
            if matrixMaterialCurrectName == material.materialName {
                for i in 0...2 {
                    matrixMaterialPropertiesTextField[i].text = String(format: "%.2f", material.materialProperties[materialPropertyLabel.isotropic[i]]!)
                }
            }
            else if matrixMaterialCurrectName == "User Defined Material" {
                for i in 0...2 {
                    matrixMaterialPropertiesTextField[i].text = ""
                }
            }
            else {
                for userSaveMaterial in userSavedMatrixMaterials {
                    if matrixMaterialCurrectName == userSaveMaterial.name {
                        if let property = userSaveMaterial.properties {
                            for i in 0...2 {
                                matrixMaterialPropertiesTextField[i].text = String(format: "%.2f", property[i])
                            }
                        }
                    }
                }
            }
            
        }
        
    }
    
    
    // MARK: Edit navigation bar
    
    func editNavigationBar() {
        
        navigationItem.title = "UDFRC"
        
        let button = UIButton()
        button.calculateButtonDesign()
        button.addTarget(self, action: #selector(calculate), for: .touchUpInside)
        button.widthAnchor.constraint(equalToConstant: button.intrinsicContentSize.width + 20).isActive = true
        let item = UIBarButtonItem(customView: button)
        self.navigationItem.setRightBarButtonItems([item], animated: true)
    }
    
    @objc func calculate(_ sender: UIButton) {
        
        sender.flash()
        
        let UDFRCResultViewController = UDFRCResult()
        
        if calculateResult() {
            
            for i in 0...6 {
                UDFRCResultViewController.engineeringConstants[i] = engineeringConstants[i]
            }
            
            for i in 0...8 {
                UDFRCResultViewController.planeStressReducedCompliance[i] = planeStressReducedCompliance[i]
            }
            
            for i in 0...8 {
                UDFRCResultViewController.planeStressReducedStiffness[i] = planeStressReducedStiffness[i]
            }

            self.navigationController?.pushViewController(UDFRCResultViewController, animated: true)
        }
        
    }
    
    
    
    // MARK: Calculate result
    
    func calculateResult() -> Bool {
        
        if let ef1 = Double(fiberMaterialPropertiesTextField[0].text!), let ef2 = Double(fiberMaterialPropertiesTextField[1].text!), let gf12 = Double(fiberMaterialPropertiesTextField[2].text!), let vf12 = Double(fiberMaterialPropertiesTextField[3].text!), let vf23 = Double(fiberMaterialPropertiesTextField[4].text!), let alphaf11 = Double(fiberMaterialPropertiesTextField[5].text!), let alphaf22 = Double(fiberMaterialPropertiesTextField[6].text!), let em = Double(matrixMaterialPropertiesTextField[0].text!), let vm = Double(matrixMaterialPropertiesTextField[1].text!), let alpham = Double(matrixMaterialPropertiesTextField[2].text!) {
            
            let s = geometryLabel.text!
            
            var Vf = Double(s[s.index(s.endIndex, offsetBy: -4) ..< s.endIndex])!
            var Vm = 1.0 - Vf
            
            let Sf : [Double] = [1/ef1, -vf12/ef1, -vf12/ef1, 0, 0, 0, -vf12/ef1, 1/ef2, -vf23/ef2, 0, 0, 0, -vf12/ef1, -vf23/ef2, 1/ef1, 0, 0, 0, 0, 0, 0, 2*(1+vf23)/ef2, 0, 0, 0, 0, 0, 0, 1/gf12, 0, 0, 0, 0, 0, 0, 1/gf12]
            let Sm : [Double] = [1/em, -vm/em, -vm/em, 0, 0, 0, -vm/em, 1/em, -vm/em, 0, 0, 0, -vm/em, -vm/em, 1/em, 0, 0, 0, 0, 0, 0, 2*(1+vm)/em, 0, 0, 0, 0, 0, 0, 2*(1+vm)/em, 0, 0, 0, 0, 0, 0, 2*(1+vm)/em]
            var SRs = [Double](repeating: 0, count: 36)
            var SVs = [Double](repeating: 0, count: 36)
            
            var Cf = [Double](repeating: 0, count: 36)
            var Cm = [Double](repeating: 0, count: 36)
            var CVs = [Double](repeating: 0, count: 36)
            
            
            var temp1 = [Double](repeating: 0, count: 36)
            var temp2 = [Double](repeating: 0, count: 36)
            
            vDSP_vsmulD(Sf, 1, &Vf, &temp1, 1, 36)
            vDSP_vsmulD(Sm, 1, &Vm, &temp2, 1, 36)
            vDSP_vaddD(temp1, 1, temp2, 1, &SRs, 1, 36)
            
            Cf = invert(matrix : Sf)
            Cm = invert(matrix : Sm)
            
            vDSP_vsmulD(Cf, 1, &Vf, &temp1, 1, 36)
            vDSP_vsmulD(Cm, 1, &Vm, &temp2, 1, 36)
            vDSP_vaddD(temp1, 1, temp2, 1, &CVs, 1, 36)
            
            SVs = invert(matrix: CVs)
            
            //CTEs
            
            let alphaFiber : [Double] = [alphaf11 , alphaf22, alphaf22 ,0 ,0 ,0]
            let alphaMatrix : [Double] = [alpham , alpham, alpham ,0 ,0 ,0]

            var temp3 = [Double](repeating: 0, count: 6)
            var temp4 = [Double](repeating: 0, count: 6)
            vDSP_mmulD(Cf, 1, alphaFiber, 1, &temp3, 1, 6, 1, 6)
            vDSP_mmulD(Cm, 1, alphaMatrix, 1, &temp4, 1, 6, 1, 6)
            
            var temp5 = [Double](repeating: 0, count: 6)
            vDSP_vsmulD(temp3, 1, &Vf, &temp1, 1, 6)
            vDSP_vsmulD(temp4, 1, &Vm, &temp2, 1, 6)
            vDSP_vaddD(temp1, 1, temp2, 1, &temp5, 1, 6)
            
            var alphamVs = [Double](repeating: 0, count: 6)
            vDSP_mmulD(SVs, 1, temp5, 1, &alphamVs, 1, 6, 1, 6)
            
            let alphamRs : [Double] =  [Vf*alphaf11+Vm*alpham,  Vf*alphaf22+Vm*alpham, Vf*alphaf22+Vm*alpham, 0 ,0 ,0]

            
            // Voigt results
            let eV1 = 1/SVs[0]
            let eV2 = 1/SVs[7]
            let gV12 = 1/SVs[35]
            let vV12 = -eV1*SVs[1]
            let vV23 = -eV2*SVs[8]
            let alphaV11 = alphamVs[0]
            let alphaV22 = alphamVs[1]

            
            // Reuss results
            let eR1 = 1/SRs[0]
            let eR2 = 1/SRs[7]
            let gR12 = 1/SRs[35]
            let vR12 = -eR1*SRs[1]
            let vR23 = -eR2*SRs[8]
            let alphaR11 = alphamRs[0]
            let alphaR22 = alphamRs[1]
            
            //Hybird results
            let gf12 = ef1/(2*(1+vf12))
            let gm = em/(2*(1+vm))
            let eH1 = Vf*ef1 + Vm*em
            let vH12 = Vf*vf12 + Vm*vm
            let eH2 = 1 / (Vf/ef2 + Vm/em - (Vf*Vm*pow(em*vf12-ef1*vm, 2)) / (ef1*em*(ef1*Vf+em*Vm)) )
            let vH23 = eH2 * (Vf*(vf23/ef2+vf12*vf12/ef1) + Vm*vm*(1+vm)/em - vH12*vH12/eH1)
            let gH12 = 1 / (Vf/gf12 + Vm/gm)
            let alphaH11 = (Vf*ef1+alphaf11 + Vm*em*alpham) / eH1
            let alphaH22 = Vf * (alphaf11*vf12 + alphaf22) + Vm * alpham * (1 + Vm) - alphaH11*vH12
            
            if methodLabel.text! == "Voigt Rules of Mixture" {
                engineeringConstants[0] = eV1
                engineeringConstants[1] = eV2
                engineeringConstants[2] = gV12
                engineeringConstants[3] = vV12
                engineeringConstants[4] = vV23
                engineeringConstants[5] = alphaV11
                engineeringConstants[6] = alphaV22
            }
            else if methodLabel.text! == "Reuss Rules of Mixture" {
                engineeringConstants[0] = eR1
                engineeringConstants[1] = eR2
                engineeringConstants[2] = gR12
                engineeringConstants[3] = vR12
                engineeringConstants[4] = vR23
                engineeringConstants[5] = alphaR11
                engineeringConstants[6] = alphaR22
            }
            else if methodLabel.text! == "Hybrid Rules of Mixture" {
                engineeringConstants[0] = eH1
                engineeringConstants[1] = eH2
                engineeringConstants[2] = gH12
                engineeringConstants[3] = vH12
                engineeringConstants[4] = vH23
                engineeringConstants[5] = alphaH11
                engineeringConstants[6] = alphaH22
            }
            
            planeStressReducedCompliance = [1/engineeringConstants[0], -engineeringConstants[3]/engineeringConstants[0], 0, -engineeringConstants[3]/engineeringConstants[0], 1/engineeringConstants[1], 0, 0, 0, 1/engineeringConstants[3]]
            planeStressReducedStiffness = invert(matrix: planeStressReducedCompliance)
        }
        else {
            let alter = UIAlertController(title: "Wrong value for material properties", message: "Please double check", preferredStyle: UIAlertControllerStyle.alert)
            alter.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alter, animated: true, completion: nil)
            return false
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
    
    
    
    // MARK: Load core data
    
    func loadCoreData() {
        
        // add fiber material
        
        do {
            userSavedFiberMaterials = try context.fetch(UserFiberMaterial.fetchRequest())
            
            for userSavedFiberMaterial in userSavedFiberMaterials {
                
                // check add action sheet or not
                
                var add = true
                
                if let name = userSavedFiberMaterial.name {
                    for fiberMaterialActionSheet in fiberMaterialDataBaseAlterController.actions {
                        if name == fiberMaterialActionSheet.title {
                            add = false
                        }
                    }
                    
                    if add {
                        let action  = UIAlertAction(title: name, style: UIAlertActionStyle.default) { (action) -> Void in
                            self.fiberNameLabel.text = name
                            self.changeMaterialDataField()
                        }
                        fiberMaterialDataBaseAlterController.addAction(action)
                        
                    }
                }
            }
            
        } catch {
            print("Could not load data from database \(error.localizedDescription)")
        }
        
        
        // add matrix material
        
        do {
            userSavedMatrixMaterials = try context.fetch(UserMatrixMaterial.fetchRequest())
            
            for userSavedMatrixMaterial in userSavedMatrixMaterials {
                
                // check add action sheet or not
                
                var add = true
                
                if let name = userSavedMatrixMaterial.name {
                    for matrixMaterialActionSheet in matrixMaterialDataBaseAlterController.actions {
                        if name == matrixMaterialActionSheet.title {
                            add = false
                        }
                    }
                    
                    if add {
                        let action  = UIAlertAction(title: name, style: UIAlertActionStyle.default) { (action) -> Void in
                            self.matrixNameLabel.text = name
                            self.changeMaterialDataField()
                        }
                        matrixMaterialDataBaseAlterController.addAction(action)
                        
                    }
                }
            }
            
        } catch {
            print("Could not load data from database \(error.localizedDescription)")
        }
        
    }
    

}
