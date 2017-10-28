//
//  test.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 10/22/17.
//  Copyright © 2017 Banghua Zhao. All rights reserved.
//

import UIKit

class test: UITableViewController, UITextFieldDelegate, UIPopoverPresentationControllerDelegate {
    
    
    // first cell
    
    var stackingSequenceCell: UITableViewCell = UITableViewCell()
    
    var stackingSequenceLabel: UILabel = UILabel()
    
    var stackingSequenceDataBase: UIButton = UIButton()
    
    var stackingSequenceDataBaseAlterController : UIAlertController!
    
    var stackingSequenceTextField: UITextField = UITextField()
    
    var stackingSequenceExplain : UIButton = UIButton()
    
    
    // second cell
    
    var laminaMaterialCell: UITableViewCell = UITableViewCell()
    
    var laminaMaterialLabel: UILabel = UILabel()
    
    var laminaMaterialDataBase: UIButton = UIButton()
    
    var laminaMaterialDataBaseAlterController : UIAlertController!
    
    var laminaMaterialCard: UITableView = UITableView()
    
    var materialCardModel: [MaterialCardModel] = []
    
    var laminaMaterialNameLabel: UILabel = UILabel()
    var laminaMaterialName : String = "IM7/8552"
    
    var laminaMaterialUnitLabel: UILabel = UILabel()
    var laminaMaterialUnit : String = "GPa"
    
    var E1Label: UILabel = UILabel()
    var E2Label: UILabel = UILabel()
    var E3Label: UILabel = UILabel()
    var G12Label: UILabel = UILabel()
    var G13Label: UILabel = UILabel()
    var G23Label: UILabel = UILabel()
    var v12Label: UILabel = UILabel()
    var v13Label: UILabel = UILabel()
    var v23Label: UILabel = UILabel()

    var E1TextField: UITextField = UITextField()
    var E2TextField: UITextField = UITextField()
    var E3TextField: UITextField = UITextField()
    var G12TextField: UITextField = UITextField()
    var G13TextField: UITextField = UITextField()
    var G23TextField: UITextField = UITextField()
    var v12TextField: UITextField = UITextField()
    var v13TextField: UITextField = UITextField()
    var v23TextField: UITextField = UITextField()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stackingSequenceTextField.delegate = self
        E1TextField.delegate = self
        E2TextField.delegate = self
        E3TextField.delegate = self
        G12TextField.delegate = self
        G13TextField.delegate = self
        G23TextField.delegate = self
        v12TextField.delegate = self
        v13TextField.delegate = self
        v23TextField.delegate = self
        
        stackingSequenceTextField.keyboardType = UIKeyboardType.numbersAndPunctuation
        
        materialCardModel.append(MaterialCardModel(name: "Young's Modulus E1", placeHolder: "E1"))
        materialCardModel.append(MaterialCardModel(name: "Young's Modulus E2", placeHolder: "E2"))
        materialCardModel.append(MaterialCardModel(name: "Young's Modulus E3", placeHolder: "E3"))
        materialCardModel.append(MaterialCardModel(name: "Shear Modulus G12", placeHolder: "G12"))
        materialCardModel.append(MaterialCardModel(name: "Shear Modulus G13", placeHolder: "G13"))
        materialCardModel.append(MaterialCardModel(name: "Shear Modulus G23", placeHolder: "G23"))
        materialCardModel.append(MaterialCardModel(name: "Poisson's Ratio ν12", placeHolder: "ν12"))
        materialCardModel.append(MaterialCardModel(name: "Poisson's Ratio ν13", placeHolder: "ν13"))
        materialCardModel.append(MaterialCardModel(name: "Poisson's Ratio ν23", placeHolder: "ν23"))
        
        navigationItem.title = "Laminate"
        
        createLayout()
        
        createActionSheet()
    
        hideKeyboardWhenTappedAround()
        
        keyboardToolBarForEngineeringConstant()
        
        changeMaterialDataField()
        
    }
    
    
    // Disable tableview auto scroll when editing textfield
    override func viewWillAppear(_ animated: Bool) {

    }
    
    
    func createLayout() {
        
        // first section
        
        stackingSequenceCell.selectionStyle = UITableViewCellSelectionStyle.none
        stackingSequenceCell.addSubview(stackingSequenceLabel)
        stackingSequenceCell.addSubview(stackingSequenceDataBase)
        stackingSequenceCell.addSubview(stackingSequenceTextField)
        stackingSequenceCell.addSubview(stackingSequenceExplain)
        
        stackingSequenceLabel.translatesAutoresizingMaskIntoConstraints = false
        stackingSequenceLabel.font = UIFont.boldSystemFont(ofSize: 18)
        stackingSequenceLabel.text = "Stacking Sequence"
        stackingSequenceLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        stackingSequenceLabel.topAnchor.constraint(equalTo: stackingSequenceCell.topAnchor, constant: 0).isActive = true
        stackingSequenceLabel.leftAnchor.constraint(equalTo: stackingSequenceCell.leftAnchor, constant: 8).isActive = true
        stackingSequenceLabel.rightAnchor.constraint(equalTo: stackingSequenceCell.rightAnchor, constant: -8).isActive = true
        
        stackingSequenceDataBase.translatesAutoresizingMaskIntoConstraints = false
        stackingSequenceDataBase.setTitle("Stacking Sequence Database", for: UIControlState.normal)
        stackingSequenceDataBase.titleLabel?.textAlignment = .center
        stackingSequenceDataBase.addTarget(self, action: #selector(changeStackingSequence(_:)), for: .touchUpInside)
        stackingSequenceDataBase.applyDesign()
        stackingSequenceDataBase.heightAnchor.constraint(equalToConstant: 40).isActive = true
        stackingSequenceDataBase.widthAnchor.constraint(greaterThanOrEqualToConstant: stackingSequenceDataBase.intrinsicContentSize.width + 40).isActive = true
        stackingSequenceDataBase.topAnchor.constraint(equalTo: stackingSequenceLabel.bottomAnchor, constant: 8).isActive = true
        stackingSequenceDataBase.centerXAnchor.constraint(equalTo: stackingSequenceCell.centerXAnchor).isActive = true
        
        stackingSequenceTextField.translatesAutoresizingMaskIntoConstraints = false
        stackingSequenceTextField.text = "[0/90/45/-45]s"
        stackingSequenceTextField.borderStyle = .roundedRect
        stackingSequenceTextField.textAlignment = .center
        stackingSequenceTextField.placeholder = "[xx/xx/xx/xx/..]msn"
        stackingSequenceTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        stackingSequenceTextField.widthAnchor.constraint(equalTo: stackingSequenceCell.widthAnchor, multiplier: 0.8).isActive = true
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
        stackingSequenceExplain.bottomAnchor.constraint(equalTo: stackingSequenceCell.bottomAnchor, constant: -40).isActive = true
        stackingSequenceExplain.centerXAnchor.constraint(equalTo: stackingSequenceCell.centerXAnchor).isActive = true

        
        
        // second section

        laminaMaterialCell.selectionStyle = UITableViewCellSelectionStyle.none
        laminaMaterialCell.addSubview(laminaMaterialLabel)
        laminaMaterialCell.addSubview(laminaMaterialDataBase)
        laminaMaterialCell.addSubview(laminaMaterialCard)
        
        laminaMaterialLabel.translatesAutoresizingMaskIntoConstraints = false
        laminaMaterialLabel.font = UIFont.boldSystemFont(ofSize: 18)
        laminaMaterialLabel.text = "Lamina Material"
        laminaMaterialLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        laminaMaterialLabel.topAnchor.constraint(equalTo: laminaMaterialCell.topAnchor, constant: 0).isActive = true
        laminaMaterialLabel.leftAnchor.constraint(equalTo: laminaMaterialCell.leftAnchor, constant: 8).isActive = true
        laminaMaterialLabel.rightAnchor.constraint(equalTo: laminaMaterialCell.rightAnchor, constant: -8).isActive = true
        
        laminaMaterialDataBase.translatesAutoresizingMaskIntoConstraints = false
        laminaMaterialDataBase.setTitle("Laminate Material Database", for: UIControlState.normal)
        laminaMaterialDataBase.titleLabel?.textAlignment = .center
        laminaMaterialDataBase.addTarget(self, action: #selector(changeLaminateMaterial(_:)), for: .touchUpInside)
        laminaMaterialDataBase.applyDesign()
        laminaMaterialDataBase.heightAnchor.constraint(equalToConstant: 40).isActive = true
        laminaMaterialDataBase.widthAnchor.constraint(greaterThanOrEqualToConstant: laminaMaterialDataBase.intrinsicContentSize.width + 40).isActive = true
        laminaMaterialDataBase.topAnchor.constraint(equalTo: laminaMaterialLabel.bottomAnchor, constant: 8).isActive = true
        laminaMaterialDataBase.centerXAnchor.constraint(equalTo: laminaMaterialCell.centerXAnchor).isActive = true
        
        laminaMaterialCard.translatesAutoresizingMaskIntoConstraints = false
        laminaMaterialCard.cardViewDesign()
        laminaMaterialCard.register(MaterialCardCell1.self, forCellReuseIdentifier: "cell1")
        laminaMaterialCard.delegate = self
        laminaMaterialCard.dataSource = self
        laminaMaterialCard.widthAnchor.constraint(equalTo: laminaMaterialCell.widthAnchor, multiplier: 0.8).isActive = true
        laminaMaterialCard.topAnchor.constraint(equalTo: laminaMaterialDataBase.bottomAnchor, constant: 8).isActive = true
        laminaMaterialCard.centerXAnchor.constraint(equalTo: laminaMaterialCell.centerXAnchor).isActive = true
        laminaMaterialCard.bottomAnchor.constraint(equalTo: laminaMaterialCell.bottomAnchor, constant: -20).isActive = true
        laminaMaterialCard.heightAnchor.constraint(equalToConstant: 700).isActive = true
        
        
    }
    
    
    
    // MARK: UIbottom action functions
    
    @objc func changeStackingSequence(_ sender: UIButton) {
        sender.flash()
        self.present(stackingSequenceDataBaseAlterController, animated: true, completion: nil)
        self.laminaMaterialCard.frame = CGRect(x: laminaMaterialCard.frame.origin.x, y: laminaMaterialCard.frame.origin.y, width: laminaMaterialCard.frame.width, height: laminaMaterialCard.contentSize.height)
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
            self.laminaMaterialName = "User Defined Material"
            self.laminaMaterialNameLabel.text = "User Defined Material"
            self.changeMaterialDataField()
        }
        
        
        let l1 = UIAlertAction(title: "IM7/8552", style: UIAlertActionStyle.default) { (action) -> Void in
            self.laminaMaterialName = "IM7/8552"
            self.laminaMaterialNameLabel.text = "Name: " + self.laminaMaterialName
            self.laminaMaterialUnitLabel.text = "Unit: GPa"
            self.changeMaterialDataField()
        }
        
        let l2 = UIAlertAction(title: "T2C190/F155", style: UIAlertActionStyle.default) { (action) -> Void in
            self.laminaMaterialName = "T2C190/F155"
            self.laminaMaterialNameLabel.text = "Name: " + self.laminaMaterialName
            self.laminaMaterialUnitLabel.text = "Unit: " + "GPa"
            self.changeMaterialDataField()
        }
        
        
        laminaMaterialDataBaseAlterController.addAction(l0)
        laminaMaterialDataBaseAlterController.addAction(l1)
        laminaMaterialDataBaseAlterController.addAction(l2)
        laminaMaterialDataBaseAlterController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        
        
    }
    
    
 
    // MARK: Edit keyboard
    
    func keyboardToolBarForEngineeringConstant() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
        
        toolBar.setItems([flexibleSpace, doneButton], animated: true)
        
        E1TextField.inputAccessoryView = toolBar
        E2TextField.inputAccessoryView = toolBar
        E3TextField.inputAccessoryView = toolBar
        G12TextField.inputAccessoryView = toolBar
        G13TextField.inputAccessoryView = toolBar
        G23TextField.inputAccessoryView = toolBar
        v12TextField.inputAccessoryView = toolBar
        v13TextField.inputAccessoryView = toolBar
        v23TextField.inputAccessoryView = toolBar
        
    }
    
    @objc func doneClicked() {
        view.endEditing(true)
    }
    
    
    
    // MARK: Change material data fields
    
    func changeMaterialDataField() {
        let allMaterials = MaterialBank()
        
        for material in allMaterials.list {
            if laminaMaterialName == material.materialName {
                E1TextField.text = String(format: "%.2f", material.materialProperties["E1"]!)
                E2TextField.text = String(format: "%.2f", material.materialProperties["E2"]!)
                E3TextField.text = String(format: "%.2f", material.materialProperties["E3"]!)
                G12TextField.text = String(format: "%.2f", material.materialProperties["G12"]!)
                G13TextField.text = String(format: "%.2f", material.materialProperties["G13"]!)
                G23TextField.text = String(format: "%.2f", material.materialProperties["G23"]!)
                v12TextField.text = String(format: "%.2f", material.materialProperties["v12"]!)
                v13TextField.text = String(format: "%.2f", material.materialProperties["v13"]!)
                v23TextField.text = String(format: "%.2f", material.materialProperties["v23"]!)
            }
            else if laminaMaterialName == "User Defined Material" {
                E1TextField.text = ""
                E2TextField.text = ""
                E3TextField.text = ""
                G12TextField.text = ""
                G13TextField.text = ""
                G23TextField.text = ""
                v12TextField.text = ""
                v13TextField.text = ""
                v23TextField.text = ""
            }
        }
        
    }
    

    
    

    
    // MARK: Textfield
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: Table view
    

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            return 2
        }
        if tableView == laminaMaterialCard {
            return materialCardModel.count
        }
        fatalError("Unknown row")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableView {
            switch indexPath.row {
            case 0:
                return stackingSequenceCell
            case 1:
                return laminaMaterialCell
            default:
                fatalError("Unknown row")
            }
        }
        if tableView == self.laminaMaterialCard {
            let cell = laminaMaterialCard.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! MaterialCardCell1
            cell.materialpropertyLabel.text = materialCardModel[indexPath.row].materialPropertyName
            cell.materialpropertyTextField.placeholder = materialCardModel[indexPath.row].materialPropertyPlaceHolder
            cell.materialpropertyTextField.keyboardType = UIKeyboardType.decimalPad
            return cell
        }
        fatalError("Unknown row")
    }

}







