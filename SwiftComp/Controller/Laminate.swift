//
//  Laminate.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 10/22/17.
//  Copyright © 2017 Banghua Zhao. All rights reserved.
//

import UIKit
import Accelerate

class Laminate: UITableViewController, UIPopoverPresentationControllerDelegate, UITextFieldDelegate {
    
    var effective3DProperties = [Double](repeating: 0.0, count: 12)
    var effectiveInplaneProperties = [Double](repeating: 0.0, count: 6)
    var effectiveFlexuralProperties = [Double](repeating: 0.0, count: 6)
    
    var  materialPropertyName = MaterialPropertyName()
    var materialPropertyLabel = MaterialPropertyLabel()
    var  materialPropertyPlaceHolder = MaterialPropertyPlaceHolder()
    
    // first section
    
    var stackingSequenceCell: UITableViewCell = UITableViewCell()
    
    var stackingSequenceDataBase: UIButton = UIButton()
    
    var stackingSequenceDataBaseAlterController : UIAlertController!
    
    var stackingSequenceTextField: UITextField = UITextField()
    
    var stackingSequenceExplain : UIButton = UIButton()
    
    
    // second section
    
    var laminaMaterialCell: UITableViewCell = UITableViewCell()
    
    var laminaMaterialDataBase: UIButton = UIButton()
    
    var laminaMaterialDataBaseAlterController : UIAlertController!
    
    var laminaMaterialCard: UIView = UIView()
        
    var laminaMaterialNameLabel: UILabel = UILabel()
    
    var laminaMaterialUnitLabel: UILabel = UILabel()
    
    var laminaMaterialPropertiesLabel: [UILabel] = []
    
    var laminaMaterialPropertiesTextField: [UITextField] = []

    
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
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    
    // MARK: Create layout
    
    func createLayout() {
        
        // first section
        
        stackingSequenceCell.selectionStyle = UITableViewCellSelectionStyle.none
        stackingSequenceCell.addSubview(stackingSequenceDataBase)
        stackingSequenceCell.addSubview(stackingSequenceTextField)
        stackingSequenceCell.addSubview(stackingSequenceExplain)
        
        stackingSequenceDataBase.setTitle("Stacking Sequence Database", for: UIControlState.normal)
        stackingSequenceDataBase.addTarget(self, action: #selector(changeStackingSequence(_:)), for: .touchUpInside)
        stackingSequenceDataBase.dataBaseButtonDesign()
        stackingSequenceDataBase.heightAnchor.constraint(equalToConstant: 40).isActive = true
        stackingSequenceDataBase.widthAnchor.constraint(greaterThanOrEqualToConstant: stackingSequenceDataBase.intrinsicContentSize.width + 40).isActive = true
        stackingSequenceDataBase.topAnchor.constraint(equalTo: stackingSequenceCell.topAnchor, constant: 8).isActive = true
        stackingSequenceDataBase.centerXAnchor.constraint(equalTo: stackingSequenceCell.centerXAnchor).isActive = true
        
        stackingSequenceTextField.translatesAutoresizingMaskIntoConstraints = false
        stackingSequenceTextField.text = "[0/90/45/-45]s"
        stackingSequenceTextField.borderStyle = .roundedRect
        stackingSequenceTextField.textAlignment = .center
        stackingSequenceTextField.placeholder = "[xx/xx/xx/xx/..]msn"
        stackingSequenceTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        stackingSequenceTextField.widthAnchor.constraint(equalTo: stackingSequenceCell.widthAnchor, multiplier: 0.6).isActive = true
        stackingSequenceTextField.topAnchor.constraint(equalTo: stackingSequenceDataBase.bottomAnchor, constant: 8).isActive = true
        stackingSequenceTextField.centerXAnchor.constraint(equalTo: stackingSequenceCell.centerXAnchor).isActive = true
        
        stackingSequenceExplain.translatesAutoresizingMaskIntoConstraints = false
        stackingSequenceExplain.setTitle("What is stacking sequence?", for: .normal)
        stackingSequenceExplain.setTitleColor(self.view.tintColor, for: .normal)
        stackingSequenceExplain.titleLabel?.textAlignment = .center
        stackingSequenceExplain.addTarget(self, action: #selector(explainStackingSequence(_:)), for: .touchUpInside)
        stackingSequenceExplain.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        stackingSequenceExplain.heightAnchor.constraint(equalToConstant: 20).isActive = true
        stackingSequenceExplain.widthAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive = true
        stackingSequenceExplain.topAnchor.constraint(equalTo: stackingSequenceTextField.bottomAnchor, constant: 8).isActive = true
        stackingSequenceExplain.bottomAnchor.constraint(equalTo: stackingSequenceCell.bottomAnchor, constant: -20).isActive = true
        stackingSequenceExplain.centerXAnchor.constraint(equalTo: stackingSequenceCell.centerXAnchor).isActive = true

        
        
        // second section

        laminaMaterialCell.selectionStyle = UITableViewCellSelectionStyle.none
        laminaMaterialCell.addSubview(laminaMaterialDataBase)
        laminaMaterialCell.addSubview(laminaMaterialCard)
        
        laminaMaterialDataBase.setTitle("Laminate Material Database", for: UIControlState.normal)
        laminaMaterialDataBase.addTarget(self, action: #selector(changeLaminateMaterial(_:)), for: .touchUpInside)
        laminaMaterialDataBase.dataBaseButtonDesign()
        laminaMaterialDataBase.heightAnchor.constraint(equalToConstant: 40).isActive = true
        laminaMaterialDataBase.widthAnchor.constraint(greaterThanOrEqualToConstant: laminaMaterialDataBase.intrinsicContentSize.width + 40).isActive = true
        laminaMaterialDataBase.topAnchor.constraint(equalTo: laminaMaterialCell.topAnchor, constant: 8).isActive = true
        laminaMaterialDataBase.centerXAnchor.constraint(equalTo: laminaMaterialCell.centerXAnchor).isActive = true
        
        laminaMaterialCard.materialCardViewDesign()
        laminaMaterialCard.widthAnchor.constraint(equalTo: laminaMaterialCell.widthAnchor, multiplier: 0.8).isActive = true
        laminaMaterialCard.topAnchor.constraint(equalTo: laminaMaterialDataBase.bottomAnchor, constant: 8).isActive = true
        laminaMaterialCard.centerXAnchor.constraint(equalTo: laminaMaterialCell.centerXAnchor).isActive = true
        laminaMaterialCard.bottomAnchor.constraint(equalTo: laminaMaterialCell.bottomAnchor, constant: -20).isActive = true
        laminaMaterialCard.addSubview(laminaMaterialNameLabel)
        laminaMaterialCard.addSubview(laminaMaterialUnitLabel)
        
        laminaMaterialNameLabel.materialCardTitleDesign()
        laminaMaterialNameLabel.text = "Name: IM7/8552"
        laminaMaterialNameLabel.topAnchor.constraint(equalTo: laminaMaterialCard.topAnchor, constant: 8).isActive = true
        laminaMaterialNameLabel.leftAnchor.constraint(equalTo: laminaMaterialCard.leftAnchor, constant: 8).isActive = true
        laminaMaterialNameLabel.rightAnchor.constraint(equalTo: laminaMaterialCard.rightAnchor, constant: -8).isActive = true
        laminaMaterialNameLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        laminaMaterialUnitLabel.materialCardTitleDesign()
        laminaMaterialUnitLabel.text = "Unit: GPa"
        laminaMaterialUnitLabel.topAnchor.constraint(equalTo: laminaMaterialNameLabel.bottomAnchor, constant: 8).isActive = true
        laminaMaterialUnitLabel.leftAnchor.constraint(equalTo: laminaMaterialCard.leftAnchor, constant: 8).isActive = true
        laminaMaterialUnitLabel.rightAnchor.constraint(equalTo: laminaMaterialCard.rightAnchor, constant: -8).isActive = true
        laminaMaterialUnitLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        for i in 0...11 {
            laminaMaterialPropertiesLabel.append(UILabel())
            laminaMaterialCard.addSubview(laminaMaterialPropertiesLabel[i])
            laminaMaterialPropertiesLabel[i].materialCardLabelDesign()
            laminaMaterialPropertiesLabel[i].text = materialPropertyName.orthotropic[i]
            
            laminaMaterialPropertiesLabel[i].leftAnchor.constraint(equalTo: laminaMaterialCard.leftAnchor, constant: 8).isActive = true
            laminaMaterialPropertiesLabel[i].widthAnchor.constraint(equalTo: laminaMaterialCard.widthAnchor, multiplier: 0.55, constant: -16).isActive = true
            laminaMaterialPropertiesLabel[i].heightAnchor.constraint(equalToConstant: 25).isActive = true
            switch i {
            case 0:
                laminaMaterialPropertiesLabel[i].topAnchor.constraint(equalTo: laminaMaterialUnitLabel.bottomAnchor, constant: 8).isActive = true
            case 11:
                laminaMaterialPropertiesLabel[i].topAnchor.constraint(equalTo: laminaMaterialPropertiesLabel[i-1].bottomAnchor, constant: 8).isActive = true
                laminaMaterialPropertiesLabel[i].bottomAnchor.constraint(equalTo: laminaMaterialCard.bottomAnchor, constant: -8).isActive = true
            default:
                laminaMaterialPropertiesLabel[i].topAnchor.constraint(equalTo: laminaMaterialPropertiesLabel[i-1].bottomAnchor, constant: 8).isActive = true
            }
        }
        
        for i in 0...11 {
            laminaMaterialPropertiesTextField.append(UITextField())
            laminaMaterialCard.addSubview(laminaMaterialPropertiesTextField[i])
            laminaMaterialPropertiesTextField[i].materialCardTextFieldDesign()
            laminaMaterialPropertiesTextField[i].placeholder = materialPropertyPlaceHolder.orthotropic[i]
           
            laminaMaterialPropertiesTextField[i].rightAnchor.constraint(equalTo: laminaMaterialCard.rightAnchor, constant: -8).isActive = true
            laminaMaterialPropertiesTextField[i].widthAnchor.constraint(equalTo: laminaMaterialCard.widthAnchor, multiplier: 0.45, constant: -16).isActive = true
            laminaMaterialPropertiesTextField[i].heightAnchor.constraint(equalToConstant: 25).isActive = true
            laminaMaterialPropertiesTextField[i].centerYAnchor.constraint(equalTo: laminaMaterialPropertiesLabel[i].centerYAnchor, constant: 0).isActive = true
        }
        
    }
    
    
    
    // UIbottom action functions
    
    @objc func changeStackingSequence(_ sender: UIButton) {
        sender.flash()
        self.present(stackingSequenceDataBaseAlterController, animated: true, completion: nil)
    }
    
    @objc func explainStackingSequence(_ sender: UIButton) {
        let viewController = UIViewController()
        viewController.modalPresentationStyle = UIModalPresentationStyle.popover
        viewController.preferredContentSize = CGSize(width: 300, height: 300)
        
        let explainUIView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        
        viewController.view.addSubview(explainUIView)
        
        let explainLabel1 = UILabel()
        
        explainUIView.addSubview(explainLabel1)
        
        explainLabel1.translatesAutoresizingMaskIntoConstraints = false
        explainLabel1.text = "Definition"
        explainLabel1.textAlignment = .center
        explainLabel1.font = UIFont.boldSystemFont(ofSize: 15)
        
        explainLabel1.heightAnchor.constraint(equalToConstant: 20).isActive = true
        explainLabel1.widthAnchor.constraint(equalTo: explainUIView.widthAnchor, multiplier: 1.0) .isActive = true
        explainLabel1.topAnchor.constraint(equalTo: explainUIView.topAnchor, constant: 8).isActive = true
        
        let explainLabel2 = UILabel()
        
        explainUIView.addSubview(explainLabel2)
        
        explainLabel2.translatesAutoresizingMaskIntoConstraints = false
        explainLabel2.text = "The layup angles from the bottom surface to the top surface."
        explainLabel2.numberOfLines = -1
        explainLabel2.font = UIFont.systemFont(ofSize: 14)
        
        explainLabel2.heightAnchor.constraint(equalToConstant: 36).isActive = true
        explainLabel2.widthAnchor.constraint(equalTo: explainUIView.widthAnchor, multiplier: 0.9) .isActive = true
        explainLabel2.topAnchor.constraint(equalTo: explainLabel1.bottomAnchor, constant: 0).isActive = true
        explainLabel2.centerXAnchor.constraint(equalTo: explainUIView.centerXAnchor).isActive = true
        
        let explainLabel3 = UILabel()
        
        explainUIView.addSubview(explainLabel3)
        
        explainLabel3.translatesAutoresizingMaskIntoConstraints = false
        explainLabel3.text = "Format"
        explainLabel3.textAlignment = .center
        explainLabel3.font = UIFont.boldSystemFont(ofSize: 15)
        
        explainLabel3.heightAnchor.constraint(equalToConstant: 20).isActive = true
        explainLabel3.widthAnchor.constraint(equalTo: explainUIView.widthAnchor, multiplier: 1.0) .isActive = true
        explainLabel3.topAnchor.constraint(equalTo: explainLabel2.bottomAnchor, constant: 8).isActive = true
        
        let explainLabel4 = UILabel()
        
        explainUIView.addSubview(explainLabel4)
        
        explainLabel4.translatesAutoresizingMaskIntoConstraints = false
        explainLabel4.text = "[xx/xx/xx/xx/..]msn\nxx: Layup angle\nm: Number of repetition before symmetry\ns: Symmetry or not\nn: Number of repetition after symmetry"
        explainLabel4.numberOfLines = -1
        explainLabel4.font = UIFont.systemFont(ofSize: 14)
        
        explainLabel4.heightAnchor.constraint(equalToConstant: 18*5).isActive = true
        explainLabel4.widthAnchor.constraint(equalTo: explainUIView.widthAnchor, multiplier: 0.9) .isActive = true
        explainLabel4.topAnchor.constraint(equalTo: explainLabel3.bottomAnchor, constant: 0).isActive = true
        explainLabel4.centerXAnchor.constraint(equalTo: explainUIView.centerXAnchor).isActive = true
        
        
        let explainLabel5 = UILabel()
        
        explainUIView.addSubview(explainLabel5)
        
        explainLabel5.translatesAutoresizingMaskIntoConstraints = false
        explainLabel5.text = "Examples"
        explainLabel5.textAlignment = .center
        explainLabel5.font = UIFont.boldSystemFont(ofSize: 15)
        
        explainLabel5.heightAnchor.constraint(equalToConstant: 20).isActive = true
        explainLabel5.widthAnchor.constraint(equalTo: explainUIView.widthAnchor, multiplier: 1.0) .isActive = true
        explainLabel5.topAnchor.constraint(equalTo: explainLabel4.bottomAnchor, constant: 8).isActive = true
        
        
        let explainLabel6 = UILabel()
        
        explainUIView.addSubview(explainLabel6)
        
        explainLabel6.translatesAutoresizingMaskIntoConstraints = false
        explainLabel6.text = "Cross-ply laminates: [0/90]\nBalanced laminates: [45/-45]\n[0/90]2 : [0/90/0/90]\n[0/90]s : [0/90/90/0]"
        explainLabel6.numberOfLines = -1
        explainLabel6.font = UIFont.systemFont(ofSize: 14)
        
        explainLabel6.heightAnchor.constraint(equalToConstant: 18*4).isActive = true
        explainLabel6.widthAnchor.constraint(equalTo: explainUIView.widthAnchor, multiplier: 0.9) .isActive = true
        explainLabel6.topAnchor.constraint(equalTo: explainLabel5.bottomAnchor, constant: 0).isActive = true
        explainLabel6.centerXAnchor.constraint(equalTo: explainUIView.centerXAnchor).isActive = true
        

        let popover = viewController.popoverPresentationController
        popover?.delegate = self
        popover?.sourceView = sender
        popover?.sourceRect = sender.bounds
        popover?.permittedArrowDirections = .up
        popover?.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0)
        
        present(viewController, animated: true, completion: nil)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    @objc func changeLaminateMaterial(_ sender: UIButton) {
        sender.flash()
        self.present(laminaMaterialDataBaseAlterController, animated: true, completion: nil)
        
    }
    
    
    
    
    // MARK: Create action sheet
    
    func createActionSheet() {
        
        stackingSequenceDataBaseAlterController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let s0 = UIAlertAction(title: "Define Your Own", style: UIAlertActionStyle.default) { (action) -> Void in
            self.stackingSequenceTextField.text = ""
        }
        
        let s1 = UIAlertAction(title: "[0/90]", style: UIAlertActionStyle.default) { (action) -> Void in
            self.stackingSequenceTextField.text = "[0/90]"
        }
        
        let s2 = UIAlertAction(title: "[45/-45]", style: UIAlertActionStyle.default) { (action) -> Void in
            self.stackingSequenceTextField.text = "[45/-45]"
        }
        
        let s3 = UIAlertAction(title: "[0/30/-30]", style: UIAlertActionStyle.default) { (action) -> Void in
            self.stackingSequenceTextField.text = "[0/30/-30]"
        }
        
        let s4 = UIAlertAction(title: "[0/60/-60]s", style: UIAlertActionStyle.default) { (action) -> Void in
            self.stackingSequenceTextField.text = "[0/60/-60]s"
        }
        
        let s5 = UIAlertAction(title: "[0/90/45/-45]s", style: UIAlertActionStyle.default) { (action) -> Void in
            self.stackingSequenceTextField.text = "[0/90/45/-45]s"

        }
        
        stackingSequenceDataBaseAlterController.addAction(s0)
        stackingSequenceDataBaseAlterController.addAction(s1)
        stackingSequenceDataBaseAlterController.addAction(s2)
        stackingSequenceDataBaseAlterController.addAction(s3)
        stackingSequenceDataBaseAlterController.addAction(s4)
        stackingSequenceDataBaseAlterController.addAction(s5)
        stackingSequenceDataBaseAlterController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        
        laminaMaterialDataBaseAlterController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let l0 = UIAlertAction(title: "Define Your Own", style: UIAlertActionStyle.default) { (action) -> Void in
            self.laminaMaterialNameLabel.text = "User Defined Material"
            self.changeMaterialDataField()
        }
        
        
        let l1 = UIAlertAction(title: "IM7/8552", style: UIAlertActionStyle.default) { (action) -> Void in
            self.laminaMaterialNameLabel.text = "Name: " + "IM7/8552"
            self.laminaMaterialUnitLabel.text = "Unit: " + "GPa"
            self.changeMaterialDataField()
        }
        
        let l2 = UIAlertAction(title: "T2C190/F155", style: UIAlertActionStyle.default) { (action) -> Void in
            self.laminaMaterialNameLabel.text = "Name: " + "T2C190/F155"
            self.laminaMaterialUnitLabel.text = "Unit: " + "GPa"
            self.changeMaterialDataField()
        }
        
        laminaMaterialDataBaseAlterController.addAction(l0)
        laminaMaterialDataBaseAlterController.addAction(l1)
        laminaMaterialDataBaseAlterController.addAction(l2)
        laminaMaterialDataBaseAlterController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
    }
    

    
    
    
    // MARK: Change material data fields
    
    func changeMaterialDataField() {
        let allMaterials = MaterialBank()
        
        for material in allMaterials.list {
            var materialCurrectName = laminaMaterialNameLabel.text!
            let removeRange = materialCurrectName.startIndex ... materialCurrectName.index(materialCurrectName.startIndex, offsetBy: 5)
            materialCurrectName.removeSubrange(removeRange)
            if materialCurrectName == material.materialName {
                for i in 0...11 {
                    laminaMaterialPropertiesTextField[i].text = String(format: "%.2f", material.materialProperties[materialPropertyLabel.orthotropic[i]]!)
                }
            }
            else if materialCurrectName == "efined Material" {
                for i in 0...11 {
                    laminaMaterialPropertiesTextField[i].text = ""
                }
            }
        }
    }
        

    
    
    // MARK: Edit keyborad
    
    func editKeyboard() {
        
        stackingSequenceTextField.keyboardType = UIKeyboardType.numbersAndPunctuation
        
        for i in 0...11 {
            laminaMaterialPropertiesTextField[i].delegate = self
            laminaMaterialPropertiesTextField[i].keyboardType = UIKeyboardType.decimalPad
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
        
        for i in 0...11 {
            laminaMaterialPropertiesTextField[i].inputAccessoryView = toolBar
        }
        
    }
    
    @objc func doneClicked() {
        view.endEditing(true)
    }
    
    
    
    
    
    
    
    // MARK: Edit navigation bar
    
    func editNavigationBar() {
        
        navigationItem.title = "Laminate"
        
        let button = UIButton()
        button.calculateButtonDesign()
        button.addTarget(self, action: #selector(calculate), for: .touchUpInside)
        button.widthAnchor.constraint(equalToConstant: button.intrinsicContentSize.width + 20).isActive = true
        let item = UIBarButtonItem(customView: button)
        self.navigationItem.setRightBarButtonItems([item], animated: true)
    }
    
    @objc func calculate(_ sender: UIButton) {
        
        sender.flash()
        
        let laminateResultViewController = LaminateResult()
        
        if calculateResult() {
            
            for i in 0...11 {
                laminateResultViewController.effective3DProperties[i] = effective3DProperties[i]
            }
            
            for i in 0...5 {
                laminateResultViewController.effectiveInPlaneProperties[i] = effectiveInplaneProperties[i]
                laminateResultViewController.effectiveFlexuralProperties[i] = effectiveFlexuralProperties[i]
            }
            
            self.navigationController?.pushViewController(laminateResultViewController, animated: true)
        }
        
    }
    
    
    
    // Calculate result
    
    func calculateResult() -> Bool {
        
        let alter = UIAlertController(title: "Wrong value", message: "Please double check", preferredStyle: UIAlertControllerStyle.alert)
        alter.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        if let e1 = Double(laminaMaterialPropertiesTextField[0].text!), let e2 = Double(laminaMaterialPropertiesTextField[1].text!), let e3 = Double(laminaMaterialPropertiesTextField[2].text!), let g12 = Double(laminaMaterialPropertiesTextField[3].text!), let g13 = Double(laminaMaterialPropertiesTextField[4].text!), let g23 = Double(laminaMaterialPropertiesTextField[5].text!), let v12 = Double(laminaMaterialPropertiesTextField[6].text!), let v13 = Double(laminaMaterialPropertiesTextField[7].text!), let v23 = Double(laminaMaterialPropertiesTextField[8].text!), let alpha11 = Double(laminaMaterialPropertiesTextField[9].text!), let alpha22 = Double(laminaMaterialPropertiesTextField[10].text!), let alpha33 = Double(laminaMaterialPropertiesTextField[11].text!), let layup = stackingSequenceTextField.text {
            
            if layup != "" {
                
                let str = layup
                var rBefore : Int = 1
                var rAfter : Int = 1
                var symmetry : Int = 1
                var baseLayup : String
                var baseLayupSequence = [Double]()
                var layupSequence = [Double]()
                
                if str.split(separator: "]").count == 2 {
                    baseLayup = str.split(separator: "]")[0].replacingOccurrences(of: "[", with: "")
                    let rsr = str.split(separator: "]")[1]
                    if rsr.split(separator: "s").count == 2 {
                        symmetry = 2
                        if let i = Int(rsr.split(separator: "s")[0]), let j = Int(rsr.split(separator: "s")[1]) {
                            rBefore = i
                            rAfter = j
                        }
                        else {
                            self.present(alter, animated: true, completion: nil)
                            return false
                        }
                    }
                    else if rsr.contains("s") {
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
                                }
                                else {
                                    self.present(alter, animated: true, completion: nil)
                                    return false
                                }
                            }
                            else {
                                self.present(alter, animated: true, completion: nil)
                                return false
                            }
                        }
                        else {
                            rAfter = 1
                            if let i = Int(rsr.split(separator: "s")[0]) {
                                rBefore = i
                            }
                            else {
                                self.present(alter, animated: true, completion: nil)
                                return false
                            }
                        }
                    }
                    else {
                        symmetry = 1
                        rBefore = 1
                        if let i = Int(rsr) {
                            rAfter = i
                        }
                        else {
                            self.present(alter, animated: true, completion: nil)
                            return false
                        }
                    }
                    
                }
                else {
                    baseLayup = str.replacingOccurrences(of: "]", with: "").replacingOccurrences(of: "[", with: "")
                    rBefore = 1
                    rAfter = 1
                    symmetry = 1
                }
                
                for i in baseLayup.components(separatedBy: "/") {
                    if let j = Double(i) {
                        baseLayupSequence.append(j)
                    }
                    else {
                        self.present(alter, animated: true, completion: nil)
                        return false
                    }
                }
                
                let nPly = baseLayupSequence.count * rBefore * symmetry * rAfter
                
                if nPly > 0 {
                    var t : Double = 1.0
                    
                    var bzi = [Double]()
                    
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
                    
                    let Sp : [Double] = [1/e1, -v12/e1, -v13/e1, 0, 0, 0, -v12/e1, 1/e2, -v23/e2, 0, 0, 0, -v13/e1, -v23/e2, 1/e3, 0, 0, 0, 0, 0, 0, 1/g23, 0, 0, 0, 0, 0, 0, 1/g13, 0, 0, 0, 0, 0, 0, 1/g12]
                    let Cp = invert(matrix: Sp)
                    let alphap = [alpha11, alpha22, alpha33, 0, 0, 0]
                    
                    var tempCts = [Double](repeating: 0.0, count: 9)
                    var tempCets = [Double](repeating: 0.0, count: 9)
                    var Qs = [Double](repeating: 0.0, count: 9)
                    var Cts = [Double](repeating: 0.0, count: 9)
                    var Cets = [Double](repeating: 0.0, count: 9)
                    var Ces = [Double](repeating: 0.0, count: 9)
                    
                    var tempalphaes = [Double](repeating: 0.0, count: 3)
                    var tempalphats = [Double](repeating: 0.0, count: 3)
                    
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
                    
                    // Get Cs
                    let Cs = [Ces[0], Ces[1], Cets[0], Cets[1], Cets[2], Ces[2], Ces[3], Ces[4], Cets[3], Cets[4], Cets[5], Ces[5], Cets[0], Cets[3], Cts[0], Cts[1], Cts[2], Cets[6], Cets[1], Cets[4], Cts[1], Cts[4], Cts[7], Cets[7], Cets[2], Cets[5], Cts[2], Cts[5], Cts[8], Cets[8], Ces[6], Ces[7], Cets[6], Cets[7], Cets[8], Ces[8]]
                    
                    let Ss = invert(matrix: Cs)
                    
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
                    
                    
                    // Effective 3D properties
                    effective3DProperties[0] = 1/Ss[0]
                    effective3DProperties[1] = 1/Ss[7]
                    effective3DProperties[2] = 1/Ss[14]
                    effective3DProperties[3] = 1/Ss[21]
                    effective3DProperties[4] = 1/Ss[28]
                    effective3DProperties[5] = 1/Ss[35]
                    effective3DProperties[6] = -1/Ss[0]*Ss[1]
                    effective3DProperties[7] = -1/Ss[0]*Ss[2]
                    effective3DProperties[8] = -1/Ss[7]*Ss[8]
                    effective3DProperties[9] = alphaes[0]
                    effective3DProperties[10] = alphaes[1]
                    effective3DProperties[11] = alphats[0]

                    
                    // Calculate A, B, and D matrices
                    let Sep : [Double] = [1/e1, -v12/e1, 0, -v12/e1, 1/e2, 0, 0, 0, 1/g12]
                    let Qep = invert(matrix: Sep)
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
                    
                }
                else {
                    self.present(alter, animated: true, completion: nil)
                    return false
                }
            }
            else {
                self.present(alter, animated: true, completion: nil)
                return false
            }
        }
        else {
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
        return 2
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
            headerView.headerLabel.text = "Stacking Sequence"
        case 1:
            headerView.headerLabel.text = "Lamina Material"
        default:
            fatalError("Unknown")
        }
        return headerView
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            return stackingSequenceCell
        case 1:
            return laminaMaterialCell
        default:
            fatalError("Unknown")
        }

    }
    
    

}







