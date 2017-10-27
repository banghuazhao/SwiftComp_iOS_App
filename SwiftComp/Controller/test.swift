//
//  test.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 10/22/17.
//  Copyright © 2017 Banghua Zhao. All rights reserved.
//

import UIKit

class test: UIViewController, UITextFieldDelegate, UIPopoverPresentationControllerDelegate {
    
    var scrollView = UIScrollView(frame: UIScreen.main.bounds)
    
    var stackingSequenceSection: UIView = UIView()

    var stackingSequenceDataBase: UIButton = UIButton()
    
    var stackingSequenceDataBaseAlterController : UIAlertController!
    
    var stackingSequenceTextField: UITextField = UITextField()
    
    var stackingSequenceExplain : UIButton = UIButton()
    
    
    var laminaMaterialSection: UIView = UIView()
    
    var laminaMaterialDataBase: UIButton = UIButton()
    
    var laminaMaterialDataBaseAlterController : UIAlertController!
    
    var laminaMaterialCard: UIView = UIView()
    
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
        
        navigationItem.title = "Laminate"
        
        createLayout()
        
        createActionSheet()
    
        stackingSequenceTextField.keyboardType = UIKeyboardType.numbersAndPunctuation
        E1TextField.keyboardType = UIKeyboardType.decimalPad
        E2TextField.keyboardType = UIKeyboardType.decimalPad
        E3TextField.keyboardType = UIKeyboardType.decimalPad
        G12TextField.keyboardType = UIKeyboardType.decimalPad
        G13TextField.keyboardType = UIKeyboardType.decimalPad
        G23TextField.keyboardType = UIKeyboardType.decimalPad
        v12TextField.keyboardType = UIKeyboardType.decimalPad
        v13TextField.keyboardType = UIKeyboardType.decimalPad
        v23TextField.keyboardType = UIKeyboardType.decimalPad

        
        hideKeyboardWhenTappedAround()
        
        keyboardToolBarForEngineeringConstant()
        
        changeMaterialDataField()
        

        
    }
    
    
    // Disable tableview auto scroll when editing textfield
    override func viewWillAppear(_ animated: Bool) {

    }
    
    
    func createLayout() {
        
        // first section
        self.view.addSubview(scrollView)
        
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 1000)
        
        scrollView.addSubview(stackingSequenceSection)
       
        stackingSequenceSection.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackingSequenceSection.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1.0),
            stackingSequenceSection.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
            stackingSequenceSection.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
        ])
        
        
        let stackingSequenceSectionTitle = UILabel()
        
        stackingSequenceSection.addSubview(stackingSequenceSectionTitle)
        
        stackingSequenceSectionTitle.translatesAutoresizingMaskIntoConstraints = false
        stackingSequenceSectionTitle.text = "Stacking Sequence"
        stackingSequenceSectionTitle.font = UIFont.boldSystemFont(ofSize: 18)
        
        NSLayoutConstraint.activate([
            stackingSequenceSectionTitle.heightAnchor.constraint(equalToConstant: 40),
            stackingSequenceSectionTitle.widthAnchor.constraint(equalTo: stackingSequenceSection.widthAnchor, multiplier: 1.0),
            stackingSequenceSectionTitle.topAnchor.constraint(equalTo: stackingSequenceSection.topAnchor, constant: 8),
            stackingSequenceSectionTitle.leftAnchor.constraint(equalTo: stackingSequenceSection.leftAnchor, constant: 8),
            stackingSequenceSectionTitle.centerXAnchor.constraint(equalTo: stackingSequenceSection.centerXAnchor)
            ])
        
        
        
        stackingSequenceSection.addSubview(stackingSequenceDataBase)
        
        stackingSequenceDataBase.translatesAutoresizingMaskIntoConstraints = false
        stackingSequenceDataBase.setTitle("Stacking Sequence Database", for: UIControlState.normal)
        stackingSequenceDataBase.titleLabel?.textAlignment = .center
        stackingSequenceDataBase.addTarget(self, action: #selector(changeStackingSequence(_:)), for: .touchUpInside)
        stackingSequenceDataBase.applyDesign()
        
        NSLayoutConstraint.activate([
            stackingSequenceDataBase.heightAnchor.constraint(equalToConstant: 40),
            stackingSequenceDataBase.widthAnchor.constraint(greaterThanOrEqualToConstant: stackingSequenceDataBase.intrinsicContentSize.width + 40),
            stackingSequenceDataBase.topAnchor.constraint(equalTo: stackingSequenceSectionTitle.bottomAnchor, constant: 8),
            stackingSequenceDataBase.centerXAnchor.constraint(equalTo: stackingSequenceSection.centerXAnchor)
        ])
        
        
        
        stackingSequenceSection.addSubview(stackingSequenceTextField)
        
        stackingSequenceTextField.translatesAutoresizingMaskIntoConstraints = false
        stackingSequenceTextField.text = "[0/90/45/-45]s"
        stackingSequenceTextField.borderStyle = .roundedRect
        stackingSequenceTextField.textAlignment = .center
        stackingSequenceTextField.placeholder = "[xx/xx/xx/xx/..]msn"

        NSLayoutConstraint.activate([
            stackingSequenceTextField.heightAnchor.constraint(equalToConstant: 40),
            stackingSequenceTextField.widthAnchor.constraint(equalTo: stackingSequenceSection.widthAnchor, multiplier: 0.8),
            stackingSequenceTextField.topAnchor.constraint(equalTo: stackingSequenceDataBase.bottomAnchor, constant: 8),
            stackingSequenceTextField.centerXAnchor.constraint(equalTo: stackingSequenceSection.centerXAnchor)
        ])
        
        
        stackingSequenceSection.addSubview(stackingSequenceExplain)
        
        stackingSequenceExplain.translatesAutoresizingMaskIntoConstraints = false
        stackingSequenceExplain.setTitle("What is stacking sequence?", for: .normal)
        stackingSequenceExplain.setTitleColor(self.view.tintColor, for: .normal)
        stackingSequenceExplain.titleLabel?.textAlignment = .center
        stackingSequenceExplain.addTarget(self, action: #selector(explainStackingSequence(_:)), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            stackingSequenceExplain.heightAnchor.constraint(equalToConstant: 40),
            stackingSequenceExplain.widthAnchor.constraint(greaterThanOrEqualToConstant: 100),
            stackingSequenceExplain.topAnchor.constraint(equalTo: stackingSequenceTextField.bottomAnchor, constant: 8),
            stackingSequenceExplain.bottomAnchor.constraint(equalTo: stackingSequenceSection.bottomAnchor, constant: -8),
            stackingSequenceExplain.centerXAnchor.constraint(equalTo: stackingSequenceSection.centerXAnchor)
        ])
        
        
        
        
        
        // second section
        
        scrollView.addSubview(laminaMaterialSection)
        
        laminaMaterialSection.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            laminaMaterialSection.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1.0),
            laminaMaterialSection.topAnchor.constraint(equalTo: stackingSequenceSection.bottomAnchor, constant: 20),
            laminaMaterialSection.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
        ])
        
        
        let laminaMaterialSectionTitle = UILabel()
        
        laminaMaterialSection.addSubview(laminaMaterialSectionTitle)
        
        laminaMaterialSectionTitle.translatesAutoresizingMaskIntoConstraints = false
        laminaMaterialSectionTitle.text = "Lamina Material"
        laminaMaterialSectionTitle.font = UIFont.boldSystemFont(ofSize: 18)
        
        NSLayoutConstraint.activate([
            laminaMaterialSectionTitle.heightAnchor.constraint(equalToConstant: 40),
            laminaMaterialSectionTitle.widthAnchor.constraint(equalTo: laminaMaterialSection.widthAnchor, multiplier: 1.0),
            laminaMaterialSectionTitle.topAnchor.constraint(equalTo: laminaMaterialSection.topAnchor, constant: 8),
            laminaMaterialSectionTitle.leftAnchor.constraint(equalTo: laminaMaterialSection.leftAnchor, constant: 8),
            laminaMaterialSectionTitle.centerXAnchor.constraint(equalTo: laminaMaterialSection.centerXAnchor)
            ])
        
        laminaMaterialSection.addSubview(laminaMaterialDataBase)
        
        laminaMaterialDataBase.translatesAutoresizingMaskIntoConstraints = false
        laminaMaterialDataBase.setTitle("Laminate Material Database", for: UIControlState.normal)
        laminaMaterialDataBase.titleLabel?.textAlignment = .center
        laminaMaterialDataBase.addTarget(self, action: #selector(changeLaminateMaterial(_:)), for: .touchUpInside)
        laminaMaterialDataBase.applyDesign()
        
        NSLayoutConstraint.activate([
            laminaMaterialDataBase.heightAnchor.constraint(equalToConstant: 40),
            laminaMaterialDataBase.widthAnchor.constraint(greaterThanOrEqualToConstant: laminaMaterialDataBase.intrinsicContentSize.width + 40),
            laminaMaterialDataBase.topAnchor.constraint(equalTo: laminaMaterialSectionTitle.bottomAnchor, constant: 8),
            laminaMaterialDataBase.centerXAnchor.constraint(equalTo: laminaMaterialSection.centerXAnchor)
        ])
        
        
        laminaMaterialSection.addSubview(laminaMaterialCard)
        
        laminaMaterialCard.translatesAutoresizingMaskIntoConstraints = false
        laminaMaterialCard.cardViewDesign()
        
        NSLayoutConstraint.activate([
            laminaMaterialCard.widthAnchor.constraint(equalTo: laminaMaterialSection.widthAnchor, multiplier: 0.8),
            laminaMaterialCard.topAnchor.constraint(equalTo: laminaMaterialDataBase.bottomAnchor, constant: 8),
            laminaMaterialCard.centerXAnchor.constraint(equalTo: laminaMaterialSection.centerXAnchor),
            laminaMaterialCard.bottomAnchor.constraint(equalTo: laminaMaterialSection.bottomAnchor, constant: -8)
        ])
        
        
        laminaMaterialCard.addSubview(laminaMaterialNameLabel)
        
        laminaMaterialNameLabel.translatesAutoresizingMaskIntoConstraints = false
        laminaMaterialNameLabel.font = UIFont.boldSystemFont(ofSize: 15)
        laminaMaterialNameLabel.textColor = UIColor(red: 155/255, green: 152/255, blue: 140/255, alpha: 1.0)
        laminaMaterialNameLabel.text = "Name: IM7/8552"
        laminaMaterialNameLabel.textAlignment = .center
        laminaMaterialNameLabel.backgroundColor = UIColor(red: 254/255, green: 248/255, blue: 223/255, alpha: 1.0)
        
        NSLayoutConstraint.activate([
            laminaMaterialNameLabel.heightAnchor.constraint(equalToConstant: 40),
            laminaMaterialNameLabel.widthAnchor.constraint(equalTo: laminaMaterialCard.widthAnchor, multiplier: 1.0),
            laminaMaterialNameLabel.centerXAnchor.constraint(equalTo: laminaMaterialCard.centerXAnchor),
            laminaMaterialNameLabel.topAnchor.constraint(equalTo: laminaMaterialCard.topAnchor, constant: 0)
        ])
        
        
        laminaMaterialCard.addSubview(laminaMaterialUnitLabel)
        
        laminaMaterialUnitLabel.translatesAutoresizingMaskIntoConstraints = false
        laminaMaterialUnitLabel.font = UIFont.boldSystemFont(ofSize: 15)
        laminaMaterialUnitLabel.textColor = UIColor(red: 155/255, green: 152/255, blue: 140/255, alpha: 1.0)
        laminaMaterialUnitLabel.text = "Unit: GPa"
        laminaMaterialUnitLabel.textAlignment = .center
        laminaMaterialUnitLabel.backgroundColor = UIColor(red: 254/255, green: 248/255, blue: 223/255, alpha: 1.0)
        
        NSLayoutConstraint.activate([
            laminaMaterialUnitLabel.heightAnchor.constraint(equalToConstant: 40),
            laminaMaterialUnitLabel.widthAnchor.constraint(equalTo: laminaMaterialCard.widthAnchor, multiplier: 1.0),
            laminaMaterialUnitLabel.centerXAnchor.constraint(equalTo: laminaMaterialCard.centerXAnchor),
            laminaMaterialUnitLabel.topAnchor.constraint(equalTo: laminaMaterialNameLabel.bottomAnchor, constant: 0),
        ])
        
        
        laminaMaterialCard.addSubview(E1Label)
        
        E1Label.translatesAutoresizingMaskIntoConstraints = false
        E1Label.text = "Young's Modulus E1"
        E1Label.cardViewDesignForLabel()
        
        NSLayoutConstraint.activate([
            E1Label.heightAnchor.constraint(equalToConstant: 40),
            E1Label.widthAnchor.constraint(equalTo: laminaMaterialCard.widthAnchor, multiplier: 0.6),
            E1Label.topAnchor.constraint(equalTo: laminaMaterialUnitLabel.bottomAnchor, constant: 0),
            E1Label.leftAnchor.constraint(equalTo: laminaMaterialCard.leftAnchor, constant: 8)
        ])
        
        
        laminaMaterialCard.addSubview(E2Label)
        
        E2Label.translatesAutoresizingMaskIntoConstraints = false
        E2Label.text = "Young's Modulus E2"
        E2Label.cardViewDesignForLabel()
        
        NSLayoutConstraint.activate([
            E2Label.heightAnchor.constraint(equalToConstant: 40),
            E2Label.widthAnchor.constraint(equalTo: laminaMaterialCard.widthAnchor, multiplier: 0.6),
            E2Label.topAnchor.constraint(equalTo: E1Label.bottomAnchor, constant: 0),
            E2Label.leftAnchor.constraint(equalTo: laminaMaterialCard.leftAnchor, constant: 8)
        ])
        
        
        laminaMaterialCard.addSubview(E3Label)
        
        E3Label.translatesAutoresizingMaskIntoConstraints = false
        E3Label.text = "Young's Modulus E3"
        E3Label.cardViewDesignForLabel()
        
        NSLayoutConstraint.activate([
            E3Label.heightAnchor.constraint(equalToConstant: 40),
            E3Label.widthAnchor.constraint(equalTo: laminaMaterialCard.widthAnchor, multiplier: 0.6),
            E3Label.topAnchor.constraint(equalTo: E2Label.bottomAnchor, constant: 0),
            E3Label.leftAnchor.constraint(equalTo: laminaMaterialCard.leftAnchor, constant: 8)
        ])
        
        
        laminaMaterialCard.addSubview(G12Label)
        
        G12Label.translatesAutoresizingMaskIntoConstraints = false
        G12Label.text = "Shear Modulus G12"
        G12Label.cardViewDesignForLabel()
        
        NSLayoutConstraint.activate([
            G12Label.heightAnchor.constraint(equalToConstant: 40),
            G12Label.widthAnchor.constraint(equalTo: laminaMaterialCard.widthAnchor, multiplier: 0.6),
            G12Label.topAnchor.constraint(equalTo: E3Label.bottomAnchor, constant: 0),
            G12Label.leftAnchor.constraint(equalTo: laminaMaterialCard.leftAnchor, constant: 8)
        ])
        
        
        laminaMaterialCard.addSubview(G13Label)
        
        G13Label.translatesAutoresizingMaskIntoConstraints = false
        G13Label.text = "Shear Modulus G13"
        G13Label.cardViewDesignForLabel()
        
        NSLayoutConstraint.activate([
            G13Label.heightAnchor.constraint(equalToConstant: 40),
            G13Label.widthAnchor.constraint(equalTo: laminaMaterialCard.widthAnchor, multiplier: 0.6),
            G13Label.topAnchor.constraint(equalTo: G12Label.bottomAnchor, constant: 0),
            G13Label.leftAnchor.constraint(equalTo: laminaMaterialCard.leftAnchor, constant: 8)
        ])
        
        
        laminaMaterialCard.addSubview(G23Label)
        
        G23Label.translatesAutoresizingMaskIntoConstraints = false
        G23Label.text = "Shear Modulus G23"
        G23Label.cardViewDesignForLabel()
        
        NSLayoutConstraint.activate([
            G23Label.heightAnchor.constraint(equalToConstant: 40),
            G23Label.widthAnchor.constraint(equalTo: laminaMaterialCard.widthAnchor, multiplier: 0.6),
            G23Label.topAnchor.constraint(equalTo: G13Label.bottomAnchor, constant: 0),
            G23Label.leftAnchor.constraint(equalTo: laminaMaterialCard.leftAnchor, constant: 8)
        ])
        
        
        laminaMaterialCard.addSubview(v12Label)
        
        v12Label.translatesAutoresizingMaskIntoConstraints = false
        v12Label.text = "Poisson's Ratio ν12"
        v12Label.cardViewDesignForLabel()
        
        NSLayoutConstraint.activate([
            v12Label.heightAnchor.constraint(equalToConstant: 40),
            v12Label.widthAnchor.constraint(equalTo: laminaMaterialCard.widthAnchor, multiplier: 0.6),
            v12Label.topAnchor.constraint(equalTo: G23Label.bottomAnchor, constant: 0),
            v12Label.leftAnchor.constraint(equalTo: laminaMaterialCard.leftAnchor, constant: 8)
        ])
        
        
        laminaMaterialCard.addSubview(v13Label)
        
        v13Label.translatesAutoresizingMaskIntoConstraints = false
        v13Label.text = "Poisson's Ratio ν13"
        v13Label.cardViewDesignForLabel()
        
        NSLayoutConstraint.activate([
            v13Label.heightAnchor.constraint(equalToConstant: 40),
            v13Label.widthAnchor.constraint(equalTo: laminaMaterialCard.widthAnchor, multiplier: 0.6),
            v13Label.topAnchor.constraint(equalTo: v12Label.bottomAnchor, constant: 0),
            v13Label.leftAnchor.constraint(equalTo: laminaMaterialCard.leftAnchor, constant: 8)
        ])
        
        
        laminaMaterialCard.addSubview(v23Label)
        
        v23Label.translatesAutoresizingMaskIntoConstraints = false
        v23Label.text = "Poisson's Ratio ν23"
        v23Label.cardViewDesignForLabel()
        
        NSLayoutConstraint.activate([
            v23Label.widthAnchor.constraint(equalTo: laminaMaterialCard.widthAnchor, multiplier: 0.6),
            v23Label.topAnchor.constraint(equalTo: v13Label.bottomAnchor, constant: 0),
            v23Label.leftAnchor.constraint(equalTo: laminaMaterialCard.leftAnchor, constant: 8),
            v23Label.bottomAnchor.constraint(equalTo: laminaMaterialCard.bottomAnchor, constant: 0)
        ])
        
        
        laminaMaterialCard.addSubview(E1TextField)
        
        E1TextField.translatesAutoresizingMaskIntoConstraints = false
        E1TextField.placeholder = "E1"
        E1TextField.cardViewDesignForTextView()
        
        NSLayoutConstraint.activate([
            E1TextField.centerYAnchor.constraint(equalTo: E1Label.centerYAnchor, constant: 0),
            E1TextField.leftAnchor.constraint(equalTo: E1Label.rightAnchor, constant: 0),
            E1TextField.rightAnchor.constraint(equalTo: laminaMaterialCard.rightAnchor, constant: -8)
        ])
        
        
        laminaMaterialCard.addSubview(E2TextField)
        
        E2TextField.translatesAutoresizingMaskIntoConstraints = false
        E2TextField.placeholder = "E2"
        E2TextField.cardViewDesignForTextView()
        
        NSLayoutConstraint.activate([
            E2TextField.centerYAnchor.constraint(equalTo: E2Label.centerYAnchor, constant: 0),
            E2TextField.leftAnchor.constraint(equalTo: E2Label.rightAnchor, constant: 0),
            E2TextField.rightAnchor.constraint(equalTo: laminaMaterialCard.rightAnchor, constant: -8)
        ])
        
        
        laminaMaterialCard.addSubview(E3TextField)
        
        E3TextField.translatesAutoresizingMaskIntoConstraints = false
        E3TextField.placeholder = "E3"
        E3TextField.cardViewDesignForTextView()
        
        NSLayoutConstraint.activate([
            E3TextField.centerYAnchor.constraint(equalTo: E3Label.centerYAnchor, constant: 0),
            E3TextField.leftAnchor.constraint(equalTo: E3Label.rightAnchor, constant: 0),
            E3TextField.rightAnchor.constraint(equalTo: laminaMaterialCard.rightAnchor, constant: -8)
        ])
        
        
        laminaMaterialCard.addSubview(G12TextField)
        
        G12TextField.translatesAutoresizingMaskIntoConstraints = false
        G12TextField.placeholder = "G12"
        G12TextField.cardViewDesignForTextView()
        
        NSLayoutConstraint.activate([
            G12TextField.centerYAnchor.constraint(equalTo: G12Label.centerYAnchor, constant: 0),
            G12TextField.leftAnchor.constraint(equalTo: G12Label.rightAnchor, constant: 0),
            G12TextField.rightAnchor.constraint(equalTo: laminaMaterialCard.rightAnchor, constant: -8)
        ])
        
        
        laminaMaterialCard.addSubview(G13TextField)
        
        G13TextField.translatesAutoresizingMaskIntoConstraints = false
        G13TextField.placeholder = "G13"
        G13TextField.cardViewDesignForTextView()
        
        NSLayoutConstraint.activate([
            G13TextField.centerYAnchor.constraint(equalTo: G13Label.centerYAnchor, constant: 0),
            G13TextField.leftAnchor.constraint(equalTo: G13Label.rightAnchor, constant: 0),
            G13TextField.rightAnchor.constraint(equalTo: laminaMaterialCard.rightAnchor, constant: -8)
        ])
        
        
        laminaMaterialCard.addSubview(G23TextField)
        
        G23TextField.translatesAutoresizingMaskIntoConstraints = false
        G23TextField.placeholder = "G23"
        G23TextField.cardViewDesignForTextView()
        
        NSLayoutConstraint.activate([
            G23TextField.centerYAnchor.constraint(equalTo: G23Label.centerYAnchor, constant: 0),
            G23TextField.leftAnchor.constraint(equalTo: G23Label.rightAnchor, constant: 0),
            G23TextField.rightAnchor.constraint(equalTo: laminaMaterialCard.rightAnchor, constant: -8)
        ])
        
        
        laminaMaterialCard.addSubview(v12TextField)
        
        v12TextField.translatesAutoresizingMaskIntoConstraints = false
        v12TextField.placeholder = "ν12"
        v12TextField.cardViewDesignForTextView()
        
        NSLayoutConstraint.activate([
            v12TextField.centerYAnchor.constraint(equalTo: v12Label.centerYAnchor, constant: 0),
            v12TextField.leftAnchor.constraint(equalTo: v12Label.rightAnchor, constant: 0),
            v12TextField.rightAnchor.constraint(equalTo: laminaMaterialCard.rightAnchor, constant: -8)
        ])
        
        
        laminaMaterialCard.addSubview(v13TextField)
        
        v13TextField.translatesAutoresizingMaskIntoConstraints = false
        v13TextField.placeholder = "ν13"
        v13TextField.cardViewDesignForTextView()
        
        NSLayoutConstraint.activate([
            v13TextField.centerYAnchor.constraint(equalTo: v13Label.centerYAnchor, constant: 0),
            v13TextField.leftAnchor.constraint(equalTo: v13Label.rightAnchor, constant: 0),
            v13TextField.rightAnchor.constraint(equalTo: laminaMaterialCard.rightAnchor, constant: -8)
        ])
        
        laminaMaterialCard.addSubview(v23TextField)
            
        v23TextField.translatesAutoresizingMaskIntoConstraints = false
        v23TextField.placeholder = "ν23"
        v23TextField.cardViewDesignForTextView()
            
        NSLayoutConstraint.activate([
            v23TextField.centerYAnchor.constraint(equalTo: v23Label.centerYAnchor, constant: 0),
            v23TextField.leftAnchor.constraint(equalTo: v23Label.rightAnchor, constant: 0),
            v23TextField.rightAnchor.constraint(equalTo: laminaMaterialCard.rightAnchor, constant: -8)
        ])
        
        
        
        
    }
    
    
    
    // MARK: UIbottom action functions
    
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

}







