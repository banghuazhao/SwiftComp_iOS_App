//
//  UDFRC.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 10/29/17.
//  Copyright © 2017 Banghua Zhao. All rights reserved.
//

import UIKit
import Accelerate

class UDFRC: UITableViewController {
    
    var engineeringConstants = [Double](repeating: 0.0, count: 5)
    var planeStressReducedCompliance = [Double](repeating: 0.0, count: 9)
    var planeStressReducedStiffness = [Double](repeating: 0.0, count: 9)
    
    
    // first section
    
    var methodCell: UITableViewCell = UITableViewCell()
    
    var methodDataBase: UIButton = UIButton()
    
    var methodDataBaseAlterController : UIAlertController!
    
    var methodLabel: UILabel = UILabel()
    
    
    // second section

    var geometryCell: UITableViewCell = UITableViewCell()

    var geometryLabel: UILabel = UILabel()
    
    var volumeFractionSlider: UISlider = UISlider()
    
    
    // third section
   
    var fiberCell: UITableViewCell = UITableViewCell()
    
    var fiberDataBase: UIButton = UIButton()
    
    var fiberMaterialDataBaseAlterController : UIAlertController!
    
    var fiberMaterialCardView: UIView = UIView()
    
    var fiberNameLabel: UILabel = UILabel()
    
    var fiberUnitLabel: UILabel = UILabel()
    
    var fiberMaterialPropertiesLabel: [UILabel] = []
    
    var fiberMaterialPropertiesTextField: [UITextField] = []
    
    
    // fourth section
    
    var matrixCell: UITableViewCell = UITableViewCell()
    
    var matrixDataBase: UIButton = UIButton()
    
    var matrixMaterialDataBaseAlterController : UIAlertController!
    
    var matrixMaterialCardView: UIView = UIView()
    
    var matrixNameLabel: UILabel = UILabel()
    
    var matrixUnitLabel: UILabel = UILabel()
    
    var matrixMaterialPropertiesLabel: [UILabel] = []
    
    var matrixMaterialPropertiesTextField: [UITextField] = []
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(TableHeader.self, forHeaderFooterViewReuseIdentifier: "headerID")
        tableView.tableFooterView = UIView()
        
        createLayout()
        
        createActionSheet()
        
        changeMaterialDataField()
        
        editKeyboard()
        
        editNavigationBar()
    
        
    }
    
    
    
    // MARK: Create layout
    
    func createLayout() {
        
        // first section
        
        methodCell.selectionStyle = UITableViewCellSelectionStyle.none
        methodCell.addSubview(methodDataBase)
        methodCell.addSubview(methodLabel)
        
        methodDataBase.setTitle("Method Database", for: UIControlState.normal)
        methodDataBase.addTarget(self, action: #selector(changeMethod(_:)), for: .touchUpInside)
        methodDataBase.dataBaseButtonDesign()
        methodDataBase.heightAnchor.constraint(equalToConstant: 40).isActive = true
        methodDataBase.widthAnchor.constraint(greaterThanOrEqualToConstant: methodDataBase.intrinsicContentSize.width + 40).isActive = true
        methodDataBase.topAnchor.constraint(equalTo: methodCell.topAnchor, constant: 8).isActive = true
        methodDataBase.centerXAnchor.constraint(equalTo: methodCell.centerXAnchor).isActive = true
        
        methodLabel.translatesAutoresizingMaskIntoConstraints = false
        methodLabel.text = "Voigt Rules of Mixture"
        methodLabel.textAlignment = .center
        methodLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        methodLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: methodDataBase.intrinsicContentSize.width + 20).isActive = true
        methodLabel.topAnchor.constraint(equalTo: methodDataBase.bottomAnchor, constant: 8).isActive = true
        methodLabel.centerXAnchor.constraint(equalTo: methodCell.centerXAnchor).isActive = true
        methodLabel.bottomAnchor.constraint(equalTo: methodCell.bottomAnchor, constant: -20).isActive = true
        
        
        // second section
        
        geometryCell.selectionStyle = UITableViewCellSelectionStyle.none
        geometryCell.addSubview(geometryLabel)
        geometryCell.addSubview(volumeFractionSlider)
        
        geometryLabel.translatesAutoresizingMaskIntoConstraints = false
        geometryLabel.text = "Fiber Volume Fraction: 0.50"
        geometryLabel.textAlignment = .center
        geometryLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        geometryLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: geometryLabel.intrinsicContentSize.width + 20).isActive = true
        geometryLabel.topAnchor.constraint(equalTo: geometryCell.topAnchor, constant: 8).isActive = true
        geometryLabel.centerXAnchor.constraint(equalTo: geometryCell.centerXAnchor).isActive = true
        
        volumeFractionSlider.minimumValue = 0
        volumeFractionSlider.maximumValue = 1.00
        volumeFractionSlider.isContinuous = true
        volumeFractionSlider.value = 0.50
        volumeFractionSlider.addTarget(self, action: #selector(changeVolumeFraction), for: .valueChanged)
        volumeFractionSlider.translatesAutoresizingMaskIntoConstraints = false
        volumeFractionSlider.topAnchor.constraint(equalTo: geometryLabel.bottomAnchor, constant: 8).isActive = true
        volumeFractionSlider.widthAnchor.constraint(equalTo: geometryCell.widthAnchor, multiplier: 0.8).isActive = true
        volumeFractionSlider.centerXAnchor.constraint(equalTo: geometryCell.centerXAnchor, constant: 0).isActive = true
        volumeFractionSlider.bottomAnchor.constraint(equalTo: geometryCell.bottomAnchor, constant: -20).isActive = true

        
        // third secion
        
        fiberCell.selectionStyle = UITableViewCellSelectionStyle.none
        fiberCell.addSubview(fiberDataBase)
        fiberCell.addSubview(fiberMaterialCardView)
        
        
        fiberDataBase.setTitle("Fiber Material Database", for: UIControlState.normal)
        fiberDataBase.addTarget(self, action: #selector(changeFiberMaterial(_:)), for: .touchUpInside)
        fiberDataBase.dataBaseButtonDesign()
        fiberDataBase.heightAnchor.constraint(equalToConstant: 40).isActive = true
        fiberDataBase.widthAnchor.constraint(greaterThanOrEqualToConstant: fiberDataBase.intrinsicContentSize.width + 40).isActive = true
        fiberDataBase.topAnchor.constraint(equalTo: fiberCell.topAnchor, constant: 8).isActive = true
        fiberDataBase.centerXAnchor.constraint(equalTo: fiberCell.centerXAnchor).isActive = true
        
        fiberMaterialCardView.materialCardViewDesign()
        fiberMaterialCardView.widthAnchor.constraint(equalTo: fiberCell.widthAnchor, multiplier: 0.8).isActive = true
        fiberMaterialCardView.topAnchor.constraint(equalTo: fiberDataBase.bottomAnchor, constant: 8).isActive = true
        fiberMaterialCardView.centerXAnchor.constraint(equalTo: fiberCell.centerXAnchor).isActive = true
        fiberMaterialCardView.bottomAnchor.constraint(equalTo: fiberCell.bottomAnchor, constant: -20).isActive = true
        fiberMaterialCardView.addSubview(fiberNameLabel)
        fiberMaterialCardView.addSubview(fiberUnitLabel)
        
        fiberNameLabel.materialCardTitleDesign()
        fiberNameLabel.text = "Name: E-Glass"
        fiberNameLabel.topAnchor.constraint(equalTo: fiberMaterialCardView.topAnchor, constant: 8).isActive = true
        fiberNameLabel.leftAnchor.constraint(equalTo: fiberMaterialCardView.leftAnchor, constant: 8).isActive = true
        fiberNameLabel.rightAnchor.constraint(equalTo: fiberMaterialCardView.rightAnchor, constant: -8).isActive = true
        fiberNameLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        fiberUnitLabel.materialCardTitleDesign()
        fiberUnitLabel.text = "Unit: GPa"
        fiberUnitLabel.topAnchor.constraint(equalTo: fiberNameLabel.bottomAnchor, constant: 8).isActive = true
        fiberUnitLabel.leftAnchor.constraint(equalTo: fiberMaterialCardView.leftAnchor, constant: 8).isActive = true
        fiberUnitLabel.rightAnchor.constraint(equalTo: fiberMaterialCardView.rightAnchor, constant: -8).isActive = true
        fiberUnitLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        
        for i in 0...4 {
            fiberMaterialPropertiesLabel.append(UILabel())
            fiberMaterialCardView.addSubview(fiberMaterialPropertiesLabel[i])
            fiberMaterialPropertiesLabel[i].materialCardLabelDesign()
            switch i {
            case 0:
                fiberMaterialPropertiesLabel[i].text = "Young's Modulus E1"
            case 1:
                fiberMaterialPropertiesLabel[i].text = "Young's Modulus E2"
            case 2:
                fiberMaterialPropertiesLabel[i].text = "Shear Modulus G12"
            case 3:
                fiberMaterialPropertiesLabel[i].text = "Poisson's Ratio ν12"
            case 4:
                fiberMaterialPropertiesLabel[i].text = "Poisson's Ratio ν23"
            default:
                break
            }
            fiberMaterialPropertiesLabel[i].leftAnchor.constraint(equalTo: fiberMaterialCardView.leftAnchor, constant: 8).isActive = true
            fiberMaterialPropertiesLabel[i].widthAnchor.constraint(equalTo: fiberMaterialCardView.widthAnchor, multiplier: 0.55, constant: -16).isActive = true
            fiberMaterialPropertiesLabel[i].heightAnchor.constraint(equalToConstant: 25).isActive = true
            switch i {
            case 0:
                fiberMaterialPropertiesLabel[i].topAnchor.constraint(equalTo: fiberUnitLabel.bottomAnchor, constant: 8).isActive = true
            case 4:
                fiberMaterialPropertiesLabel[i].topAnchor.constraint(equalTo: fiberMaterialPropertiesLabel[i-1].bottomAnchor, constant: 8).isActive = true
                fiberMaterialPropertiesLabel[i].bottomAnchor.constraint(equalTo: fiberMaterialCardView.bottomAnchor, constant: -8).isActive = true
            default:
                fiberMaterialPropertiesLabel[i].topAnchor.constraint(equalTo: fiberMaterialPropertiesLabel[i-1].bottomAnchor, constant: 8).isActive = true
            }
        }
        
        for i in 0...4 {
            fiberMaterialPropertiesTextField.append(UITextField())
            fiberMaterialCardView.addSubview(fiberMaterialPropertiesTextField[i])
            fiberMaterialPropertiesTextField[i].materialCardTextFieldDesign()
            switch i {
            case 0:
                fiberMaterialPropertiesTextField[i].placeholder = "E1"
            case 1:
                fiberMaterialPropertiesTextField[i].placeholder = "E2"
            case 2:
                fiberMaterialPropertiesTextField[i].placeholder = "G12"
            case 3:
                fiberMaterialPropertiesTextField[i].placeholder = "ν12"
            case 4:
                fiberMaterialPropertiesTextField[i].placeholder = "ν23"
            default:
                break
            }
            fiberMaterialPropertiesTextField[i].rightAnchor.constraint(equalTo: fiberMaterialCardView.rightAnchor, constant: -8).isActive = true
            fiberMaterialPropertiesTextField[i].widthAnchor.constraint(equalTo: fiberMaterialCardView.widthAnchor, multiplier: 0.45, constant: -16).isActive = true
            fiberMaterialPropertiesTextField[i].heightAnchor.constraint(equalToConstant: 25).isActive = true
            fiberMaterialPropertiesTextField[i].centerYAnchor.constraint(equalTo: fiberMaterialPropertiesLabel[i].centerYAnchor, constant: 0).isActive = true
        }
        
        
        
        // fourth secion
        
        matrixCell.selectionStyle = UITableViewCellSelectionStyle.none
        matrixCell.addSubview(matrixDataBase)
        matrixCell.addSubview(matrixMaterialCardView)
        
        
        matrixDataBase.setTitle("Matrix Material Database", for: UIControlState.normal)
        matrixDataBase.addTarget(self, action: #selector(changeMatrixMaterial(_:)), for: .touchUpInside)
        matrixDataBase.dataBaseButtonDesign()
        matrixDataBase.heightAnchor.constraint(equalToConstant: 40).isActive = true
        matrixDataBase.widthAnchor.constraint(greaterThanOrEqualToConstant: matrixDataBase.intrinsicContentSize.width + 40).isActive = true
        matrixDataBase.topAnchor.constraint(equalTo: matrixCell.topAnchor, constant: 8).isActive = true
        matrixDataBase.centerXAnchor.constraint(equalTo: matrixCell.centerXAnchor).isActive = true
        
        matrixMaterialCardView.materialCardViewDesign()
        matrixMaterialCardView.widthAnchor.constraint(equalTo: matrixCell.widthAnchor, multiplier: 0.8).isActive = true
        matrixMaterialCardView.topAnchor.constraint(equalTo: matrixDataBase.bottomAnchor, constant: 8).isActive = true
        matrixMaterialCardView.centerXAnchor.constraint(equalTo: matrixCell.centerXAnchor).isActive = true
        matrixMaterialCardView.bottomAnchor.constraint(equalTo: matrixCell.bottomAnchor, constant: -20).isActive = true
        matrixMaterialCardView.addSubview(matrixNameLabel)
        matrixMaterialCardView.addSubview(matrixUnitLabel)
        
        matrixNameLabel.materialCardTitleDesign()
        matrixNameLabel.text = "Name: Epoxy"
        matrixNameLabel.topAnchor.constraint(equalTo: matrixMaterialCardView.topAnchor, constant: 8).isActive = true
        matrixNameLabel.leftAnchor.constraint(equalTo: matrixMaterialCardView.leftAnchor, constant: 8).isActive = true
        matrixNameLabel.rightAnchor.constraint(equalTo: matrixMaterialCardView.rightAnchor, constant: -8).isActive = true
        matrixNameLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        matrixUnitLabel.materialCardTitleDesign()
        matrixUnitLabel.text = "Unit: GPa"
        matrixUnitLabel.topAnchor.constraint(equalTo: matrixNameLabel.bottomAnchor, constant: 8).isActive = true
        matrixUnitLabel.leftAnchor.constraint(equalTo: matrixMaterialCardView.leftAnchor, constant: 8).isActive = true
        matrixUnitLabel.rightAnchor.constraint(equalTo: matrixMaterialCardView.rightAnchor, constant: -8).isActive = true
        matrixUnitLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        
        for i in 0...1 {
            matrixMaterialPropertiesLabel.append(UILabel())
            matrixMaterialCardView.addSubview(matrixMaterialPropertiesLabel[i])
            matrixMaterialPropertiesLabel[i].materialCardLabelDesign()
            switch i {
            case 0:
                matrixMaterialPropertiesLabel[i].text = "Young's Modulus E"
            case 1:
                matrixMaterialPropertiesLabel[i].text = "Poisson's Ratio ν"
            default:
                break
            }
            matrixMaterialPropertiesLabel[i].leftAnchor.constraint(equalTo: matrixMaterialCardView.leftAnchor, constant: 8).isActive = true
            matrixMaterialPropertiesLabel[i].widthAnchor.constraint(equalTo: matrixMaterialCardView.widthAnchor, multiplier: 0.55, constant: -16).isActive = true
            matrixMaterialPropertiesLabel[i].heightAnchor.constraint(equalToConstant: 25).isActive = true
            switch i {
            case 0:
                matrixMaterialPropertiesLabel[i].topAnchor.constraint(equalTo: matrixUnitLabel.bottomAnchor, constant: 8).isActive = true
            case 1:
                matrixMaterialPropertiesLabel[i].topAnchor.constraint(equalTo: matrixMaterialPropertiesLabel[i-1].bottomAnchor, constant: 8).isActive = true
                matrixMaterialPropertiesLabel[i].bottomAnchor.constraint(equalTo: matrixMaterialCardView.bottomAnchor, constant: -8).isActive = true
            default:
                break
            }
        }
        
        for i in 0...1 {
            matrixMaterialPropertiesTextField.append(UITextField())
            matrixMaterialCardView.addSubview(matrixMaterialPropertiesTextField[i])
            matrixMaterialPropertiesTextField[i].materialCardTextFieldDesign()
            switch i {
            case 0:
                matrixMaterialPropertiesTextField[i].placeholder = "E"
            case 1:
                matrixMaterialPropertiesTextField[i].placeholder = "ν"
            default:
                break
            }
            matrixMaterialPropertiesTextField[i].rightAnchor.constraint(equalTo: matrixMaterialCardView.rightAnchor, constant: -8).isActive = true
            matrixMaterialPropertiesTextField[i].widthAnchor.constraint(equalTo: matrixMaterialCardView.widthAnchor, multiplier: 0.45, constant: -16).isActive = true
            matrixMaterialPropertiesTextField[i].heightAnchor.constraint(equalToConstant: 25).isActive = true
            matrixMaterialPropertiesTextField[i].centerYAnchor.constraint(equalTo: matrixMaterialPropertiesLabel[i].centerYAnchor, constant: 0).isActive = true
        }
        
        
        
    }
    
    
    // UIbottom action functions
    
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
            self.fiberNameLabel.text = "Name: E-Glass"
            self.changeMaterialDataField()
        }
        let f2 = UIAlertAction(title: "S-Glass", style: UIAlertActionStyle.default) { (action) -> Void in
            self.fiberNameLabel.text = "Name: S-Glass"
            self.changeMaterialDataField()
        }
        let f3 = UIAlertAction(title: "Carbon (IM)", style: UIAlertActionStyle.default) { (action) -> Void in
            self.fiberNameLabel.text = "Name: Carbon (IM)"
            self.changeMaterialDataField()
        }
        let f4 = UIAlertAction(title: "Carbon (HM)", style: UIAlertActionStyle.default) { (action) -> Void in
            self.fiberNameLabel.text = "Name: Carbon (HM)"
            self.changeMaterialDataField()
        }
        let f5 = UIAlertAction(title: "Boron", style: UIAlertActionStyle.default) { (action) -> Void in
            self.fiberNameLabel.text = "Name: Boron"
            self.changeMaterialDataField()
        }
        let f6 = UIAlertAction(title: "Kelvar-49", style: UIAlertActionStyle.default) { (action) -> Void in
            self.fiberNameLabel.text = "Name: Kelvar-49"
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
            self.matrixNameLabel.text = "Name: Epoxy"
            self.changeMaterialDataField()
        }
        let m2 = UIAlertAction(title: "Polyester", style: UIAlertActionStyle.default) { (action) -> Void in
            self.matrixNameLabel.text = "Name: S-Glass"
            self.changeMaterialDataField()
        }
        let m3 = UIAlertAction(title: "Polyester", style: UIAlertActionStyle.default) { (action) -> Void in
            self.matrixNameLabel.text = "Name: Polyester"
            self.changeMaterialDataField()
        }
        let m4 = UIAlertAction(title: "Polyimide", style: UIAlertActionStyle.default) { (action) -> Void in
            self.matrixNameLabel.text = "Name: Polyimide"
            self.changeMaterialDataField()
        }
        let m5 = UIAlertAction(title: "PEEK", style: UIAlertActionStyle.default) { (action) -> Void in
            self.matrixNameLabel.text = "Name: PEEK"
            self.changeMaterialDataField()
        }
        let m6 = UIAlertAction(title: "Copper", style: UIAlertActionStyle.default) { (action) -> Void in
            self.matrixNameLabel.text = "Name: Copper"
            self.changeMaterialDataField()
        }
        let m7 = UIAlertAction(title: "Silicon Carbide", style: UIAlertActionStyle.default) { (action) -> Void in
            self.matrixNameLabel.text = "Name: Silicon Carbide"
            self.changeMaterialDataField()
        }
        
        matrixMaterialDataBaseAlterController.addAction(m0)
        matrixMaterialDataBaseAlterController.addAction(m1)
        matrixMaterialDataBaseAlterController.addAction(m2)
        matrixMaterialDataBaseAlterController.addAction(m3)
        matrixMaterialDataBaseAlterController.addAction(m4)
        matrixMaterialDataBaseAlterController.addAction(m5)
        matrixMaterialDataBaseAlterController.addAction(m6)
        matrixMaterialDataBaseAlterController.addAction(m7)
        matrixMaterialDataBaseAlterController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
    
    }
    
    
    
    
    // MARK: Change material data fields
    
    func changeMaterialDataField() {
        let allMaterials = MaterialBank()
        
        for material in allMaterials.list {
            
            // change fiber material card
            
            var fiberMaterialCurrectName = fiberNameLabel.text!
            
            let removeFiberRange = fiberMaterialCurrectName.startIndex ... fiberMaterialCurrectName.index(fiberMaterialCurrectName.startIndex, offsetBy: 5)
            
            fiberMaterialCurrectName.removeSubrange(removeFiberRange)
            
            if fiberMaterialCurrectName == material.materialName {
                fiberMaterialPropertiesTextField[0].text = String(format: "%.2f", material.materialProperties["E1"]!)
                fiberMaterialPropertiesTextField[1].text = String(format: "%.2f", material.materialProperties["E2"]!)
                fiberMaterialPropertiesTextField[2].text = String(format: "%.2f", material.materialProperties["G12"]!)
                fiberMaterialPropertiesTextField[3].text = String(format: "%.2f", material.materialProperties["v12"]!)
                fiberMaterialPropertiesTextField[4].text = String(format: "%.2f", material.materialProperties["v23"]!)
            }
            else if fiberMaterialCurrectName == "efined Material" {
                fiberMaterialPropertiesTextField[0].text = ""
                fiberMaterialPropertiesTextField[1].text = ""
                fiberMaterialPropertiesTextField[2].text = ""
                fiberMaterialPropertiesTextField[3].text = ""
                fiberMaterialPropertiesTextField[4].text = ""
            }
            
            // change matrix material card
            
            var matrixMaterialCurrectName = matrixNameLabel.text!
            
            let removeMatrixRange = matrixMaterialCurrectName.startIndex ... matrixMaterialCurrectName.index(matrixMaterialCurrectName.startIndex, offsetBy: 5)

            matrixMaterialCurrectName.removeSubrange(removeMatrixRange)
            
            if matrixMaterialCurrectName == material.materialName {
                matrixMaterialPropertiesTextField[0].text = String(format: "%.2f", material.materialProperties["E1"]!)
                matrixMaterialPropertiesTextField[1].text = String(format: "%.2f", material.materialProperties["v12"]!)
            }
            else if matrixMaterialCurrectName == "efined Material" {
                matrixMaterialPropertiesTextField[0].text = ""
                matrixMaterialPropertiesTextField[1].text = ""
            }
            
        }
        
    }
    

    

    
    
    // MARK: Edit keyborad
    
    func editKeyboard() {
        
        for i in 0...4 {
            fiberMaterialPropertiesTextField[i].keyboardType = UIKeyboardType.decimalPad
        }
        
        for i in 0...1 {
            matrixMaterialPropertiesTextField[i].keyboardType = UIKeyboardType.decimalPad
        }
        
        hideKeyboardWhenTappedAround()
        
        keyboardToolBarForEngineeringConstant()
        
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        tableView.setContentOffset(CGPoint.init(x: 0, y: textField.frame.origin.y - 100), animated: true)
    }
    
    
    
    // Add done button to keyboard
    
    func keyboardToolBarForEngineeringConstant() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
        
        toolBar.setItems([flexibleSpace, doneButton], animated: true)
        
        for i in 0...4 {
            fiberMaterialPropertiesTextField[i].inputAccessoryView = toolBar
        }
        
        for i in 0...1 {
            matrixMaterialPropertiesTextField[i].inputAccessoryView = toolBar
        }
        
    }
    
    @objc func doneClicked() {
        view.endEditing(true)
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
            
            for i in 0...4 {
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
        
        if let ef1 = Double(fiberMaterialPropertiesTextField[0].text!), let ef2 = Double(fiberMaterialPropertiesTextField[1].text!), let gf12 = Double(fiberMaterialPropertiesTextField[2].text!), let vf12 = Double(fiberMaterialPropertiesTextField[3].text!), let vf23 = Double(fiberMaterialPropertiesTextField[4].text!), let em = Double(matrixMaterialPropertiesTextField[0].text!), let vm = Double(matrixMaterialPropertiesTextField[1].text!) {
            
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
            
            // Voigt results
            let eV1 = 1/SVs[0]
            let eV2 = 1/SVs[7]
            let gV12 = 1/SVs[35]
            let vV12 = -eV1*SVs[1]
            let vV23 = -eV2*SVs[8]
            
            // Reuss results
            let eR1 = 1/SRs[0]
            let eR2 = 1/SRs[7]
            let gR12 = 1/SRs[35]
            let vR12 = -eR1*SRs[1]
            let vR23 = -eR2*SRs[8]
            
            //Hybird results
            let gf12 = ef1/(2*(1+vf12))
            let gm = em/(2*(1+vm))
            let eH1 = Vf*ef1 + Vm*em
            let vH12 = Vf*vf12 + Vm*vm
            let eH2 = 1 / (Vf/ef2 + Vm/em - (Vf*Vm*pow(em*vf12-ef1*vm, 2)) / (ef1*em*(ef1*Vf+em*Vm)) )
            let vH23 = eH2 * (Vf*(vf23/ef2+vf12*vf12/ef1) + Vm*vm*(1+vm)/em - vH12*vH12/eH1)
            let gH12 = 1 / (Vf/gf12 + Vm/gm)
            
            if methodLabel.text! == "Voigt Rules of Mixture" {
                engineeringConstants[0] = eV1
                engineeringConstants[1] = eV2
                engineeringConstants[2] = gV12
                engineeringConstants[3] = vV12
                engineeringConstants[4] = vV23
            }
            else if methodLabel.text! == "Reuss Rules of Mixture" {
                engineeringConstants[0] = eR1
                engineeringConstants[1] = eR2
                engineeringConstants[2] = gR12
                engineeringConstants[3] = vR12
                engineeringConstants[4] = vR23
            }
            else if methodLabel.text! == "Hybrid Rules of Mixture" {
                engineeringConstants[0] = eH1
                engineeringConstants[1] = eH2
                engineeringConstants[2] = gH12
                engineeringConstants[3] = vH12
                engineeringConstants[4] = vH23
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
    
    
    
    
    
    
    
    
    // MARK: Table view
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "headerID") as! TableHeader
        switch section {
        case 0:
            headerView.headerLabel.text = "Method"
        case 1:
            headerView.headerLabel.text = "Geometry"
        case 2:
            headerView.headerLabel.text = "Fiber Material"
        case 3:
            headerView.headerLabel.text = "Matrix Material"
        default:
            fatalError("Unknown")
        }
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            return methodCell
        case 1:
            return geometryCell
        case 2:
            return fiberCell
        case 3:
            return matrixCell
        default:
            fatalError("Unknown")
        }
        
    }
    
    
        

}
