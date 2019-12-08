//
//  LaminateControllerOld.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 9/14/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import Accelerate
import UIKit

class LaminateControllerOld: SwiftCompTemplateViewController, UITextFieldDelegate {
    // Data

    var layupSequence = [Double]()
    var layerThickness = 0.0
    var (e1, e2, e3, g12, g13, g23, nu12, nu13, nu23) = (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
    var (c11, c12, c13, c14, c15, c16, c22, c23, c24, c25, c26, c33, c34, c35, c36, c44, c45, c46, c55, c56, c66) = (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
    var (alpha11, alpha22, alpha33, alpha23, alpha13, alpha12) = (0.0, 0.0, 0.0, 0.0, 0.0, 0.0)

    // Core data

    var userSavedStackingSequences = [UserStackingSequence]()
    var userSavedLaminaMaterials = [UserLaminaMaterial]()

    // geometry

    var stackingSequenceView: UIView = UIView()
    var stackingSequenceDataBase: UIButton = UIButton()
    var stackingSequenceSave: UIButton = UIButton()
    var LaminateStackingSequenceDataBaseViewController = StackingSequenceDataBase()
    var stackingSequenceFigureView: UIView = UIView()
    var laminateOutlineLayer: CAShapeLayer = CAShapeLayer()
    var stackingSequenceTextField: UITextField = UITextField()
    var stackingSequenceNameLabel: UITextField = UITextField()
    var laminaThicknessLabel: UILabel = UILabel()
    var laminaThicknessTextField: UITextField = UITextField()

    // lamina material

    var laminaMaterialType: MaterialType = .orthotropic

    var laminaMaterialView: UIView = UIView()
    var laminaMateriaQuestionButton: UIButton = UIButton()
    var laminaMaterialDataBase: UIButton = UIButton()
    var laminateLaminaMaterialDataBaseViewController = LaminaMaterialDataBase()
    let laminaMaterialTypeSegementedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Transversely", "Orthotropic", "Anisotropic"])
        sc.selectedSegmentIndex = 1
        sc.apportionsSegmentWidthsByContent = true
        return sc
    }()

    var laminaMaterialCard: UIView = UIView()
    var laminaMaterialNameLabel: UILabel = UILabel()
    var laminaMaterialPropertiesLabel: [UILabel] = []
    var laminaMaterialPropertiesTextField: [UITextField] = []
    var saveLaminaMaterialButton: UIButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Laminate"

        stackingSequenceTextField.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        loadCoreData()
    }

    // MARK: create layout

    override func createLayout() {
        super.createLayout()

        typeOfAnalysisView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -40).isActive = false
        scrollView.constraints.filter({ $0.firstAttribute == NSLayoutConstraint.Attribute.bottom }).forEach { $0.isActive = false }

        scrollView.addSubviews(stackingSequenceView, laminaMaterialView)

        // geometry

        var stackingSequenceQuestionButton: UIButton = UIButton()

        createViewCardWithTitleHelpButtonDatabaseButton(viewCard: stackingSequenceView, title: "Geometry", helpButton: &stackingSequenceQuestionButton, databaseButton: &stackingSequenceDataBase, saveDatabaseButton: &stackingSequenceSave, aboveConstraint: typeOfAnalysisView.bottomAnchor, under: scrollView)

        stackingSequenceQuestionButton.addTarget(self, action: #selector(stackingSequenceQuestionExplain), for: .touchUpInside)

        stackingSequenceDataBase.addTarget(self, action: #selector(enterStackingSequenceDataBase), for: .touchUpInside)

        stackingSequenceSave.addTarget(self, action: #selector(saveStackingSequence), for: .touchUpInside)

        stackingSequenceView.addSubview(stackingSequenceFigureView)
        stackingSequenceView.addSubview(stackingSequenceTextField)

        stackingSequenceFigureView.translatesAutoresizingMaskIntoConstraints = false
        stackingSequenceFigureView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        stackingSequenceFigureView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        stackingSequenceFigureView.topAnchor.constraint(equalTo: stackingSequenceDataBase.bottomAnchor, constant: 8).isActive = true
        stackingSequenceFigureView.centerXAnchor.constraint(equalTo: stackingSequenceView.centerXAnchor).isActive = true
        stackingSequenceFigureView.layer.addSublayer(laminateOutlineLayer)

        let rectPath = UIBezierPath()
        rectPath.move(to: CGPoint(x: stackingSequenceFigureView.frame.minX, y: stackingSequenceFigureView.frame.minY))
        rectPath.addLine(to: CGPoint(x: stackingSequenceFigureView.frame.minX + 200, y: stackingSequenceFigureView.frame.minY))
        rectPath.addLine(to: CGPoint(x: stackingSequenceFigureView.frame.minX + 200, y: stackingSequenceFigureView.frame.minY + 100))
        rectPath.addLine(to: CGPoint(x: stackingSequenceFigureView.frame.minX, y: stackingSequenceFigureView.frame.minY + 100))
        rectPath.close()
        laminateOutlineLayer.path = rectPath.cgPath
        laminateOutlineLayer.fillColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        laminateOutlineLayer.strokeColor = UIColor.blackThemeColor.cgColor

        stackingSequenceNameLabel.text = "[0/90/45/-45]s"
        stackingSequenceTextField.translatesAutoresizingMaskIntoConstraints = false
        stackingSequenceTextField.keyboardType = UIKeyboardType.numbersAndPunctuation
        stackingSequenceTextField.text = stackingSequenceNameLabel.text
        stackingSequenceTextField.borderStyle = .roundedRect
        stackingSequenceTextField.textAlignment = .center
        stackingSequenceTextField.placeholder = "[xx/xx/xx/xx/..]msn"
        stackingSequenceTextField.font = UIFont.systemFont(ofSize: 14)
        stackingSequenceTextField.heightAnchor.constraint(equalToConstant: 25).isActive = true
        stackingSequenceTextField.widthAnchor.constraint(equalToConstant: 310).isActive = true
        stackingSequenceTextField.topAnchor.constraint(equalTo: stackingSequenceFigureView.bottomAnchor, constant: 8).isActive = true
        stackingSequenceTextField.centerXAnchor.constraint(equalTo: stackingSequenceView.centerXAnchor).isActive = true

        stackingSequenceTextField.bottomAnchor.constraint(equalTo: stackingSequenceView.bottomAnchor, constant: -12).isActive = true

        changeStackingSequenceDataField()

        generateLayupFigure()

        stackingSequenceView.addSubview(laminaThicknessLabel)
        stackingSequenceView.addSubview(laminaThicknessTextField)

        laminaThicknessLabel.translatesAutoresizingMaskIntoConstraints = false
        laminaThicknessLabel.text = "Layer Thickness"
        laminaThicknessLabel.font = UIFont.systemFont(ofSize: 14)
        laminaThicknessLabel.topAnchor.constraint(equalTo: stackingSequenceTextField.bottomAnchor, constant: 8).isActive = true
        laminaThicknessLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        laminaThicknessLabel.centerXAnchor.constraint(equalTo: stackingSequenceView.centerXAnchor, constant: -64).isActive = true
        laminaThicknessLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true

        laminaThicknessTextField.translatesAutoresizingMaskIntoConstraints = false
        laminaThicknessTextField.placeholder = "Layer Thickness"
        laminaThicknessTextField.text = "1.0"
        laminaThicknessTextField.keyboardType = UIKeyboardType.numbersAndPunctuation
        laminaThicknessTextField.borderStyle = .roundedRect
        laminaThicknessTextField.font = UIFont.systemFont(ofSize: 14)
        laminaThicknessTextField.heightAnchor.constraint(equalToConstant: 25).isActive = true
        laminaThicknessTextField.topAnchor.constraint(equalTo: stackingSequenceTextField.bottomAnchor, constant: 8).isActive = true
        laminaThicknessTextField.centerXAnchor.constraint(equalTo: stackingSequenceView.centerXAnchor, constant: 64).isActive = true
        laminaThicknessTextField.widthAnchor.constraint(equalToConstant: 120).isActive = true

        laminaThicknessTextField.bottomAnchor.constraint(equalTo: stackingSequenceView.bottomAnchor, constant: -12).isActive = false

        laminaThicknessLabel.isHidden = true
        laminaThicknessTextField.isHidden = true

        // lamina material

        createViewCard(viewCard: laminaMaterialView, title: "Lamina Material", aboveConstraint: stackingSequenceView.bottomAnchor, under: scrollView)
        laminaMaterialView.addSubview(laminaMateriaQuestionButton)
        laminaMaterialView.addSubview(laminaMaterialDataBase)
        laminaMaterialView.addSubview(saveLaminaMaterialButton)
        laminaMaterialView.addSubview(laminaMaterialTypeSegementedControl)
        laminaMaterialView.addSubview(laminaMaterialCard)

        laminaMateriaQuestionButton.questionButtonDesign(under: laminaMaterialView)
        laminaMateriaQuestionButton.addTarget(self, action: #selector(laminaMaterialQuestionExplain), for: .touchUpInside)

        laminaMaterialDataBase.dataBaseButtonDesign(under: laminaMaterialView)
        laminaMaterialDataBase.addTarget(self, action: #selector(enterlaminaMaterialDataBase), for: .touchUpInside)

        saveLaminaMaterialButton.saveButtonDesign(under: laminaMaterialView)
        saveLaminaMaterialButton.addTarget(self, action: #selector(saveLaminaMaterial), for: .touchUpInside)

        laminaMaterialTypeSegementedControl.translatesAutoresizingMaskIntoConstraints = false
        laminaMaterialTypeSegementedControl.addTarget(self, action: #selector(changeLaminaMaterialType), for: .valueChanged)
        laminaMaterialTypeSegementedControl.widthAnchor.constraint(equalToConstant: 310).isActive = true
        laminaMaterialTypeSegementedControl.topAnchor.constraint(equalTo: laminaMaterialDataBase.bottomAnchor, constant: 8).isActive = true
        laminaMaterialTypeSegementedControl.centerXAnchor.constraint(equalTo: laminaMaterialView.centerXAnchor).isActive = true

        laminaMaterialNameLabel.text = "IM7/8552"
        createMaterialCard(materialCard: &laminaMaterialCard, materialName: laminaMaterialNameLabel, label: &laminaMaterialPropertiesLabel, value: &laminaMaterialPropertiesTextField, aboveConstraint: laminaMaterialTypeSegementedControl.bottomAnchor, under: laminaMaterialView, typeOfAnalysis: analysisSettings.typeOfAnalysis, materialType: .orthotropic)

        changeMaterialDataField()

        laminaMaterialCard.bottomAnchor.constraint(equalTo: laminaMaterialView.bottomAnchor, constant: -20).isActive = true

        laminaMaterialView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -40).isActive = true

        scrollView.constraints.filter({ $0.firstAttribute == NSLayoutConstraint.Attribute.bottom }).forEach { $0.isActive = true }
    }

    // MARK: question button section

    override func methodQuestionExplain(_ sender: UIButton) {
        let explainDetialView: UIView = UIView()
        explainDetialView.explainDetialViewPureTextDesign(pureText: ExplainModel().methodExplain + "\n\n" + ExplainModel().laminateMethodExplain)

        methodExplain.showExplain(boxHeight: 300, title: "Method", explainDetailView: explainDetialView)
    }

    override func structuralModelQuestionExplain(_ sender: UIButton) {
        let explainDetialView: UIView = UIView()
        explainDetialView.explainDetialViewPureTextDesign(pureText: ExplainModel().structureModel + "\n\n" + ExplainModel().laminateStructureModel)

        structuralModelExplain.showExplain(boxHeight: 300, title: "Structural Model", explainDetailView: explainDetialView)
    }

    let laminaGeometryExplain = ExplainBoxDesign()
    @objc func stackingSequenceQuestionExplain(_ sender: UIButton, event: UIEvent) {
        let explainDetialView: UIView = UIView()
        explainDetialView.explainDetialViewPureTextDesign(pureText: ExplainModel().laminateGeometryExplain)

        laminaGeometryExplain.showExplain(boxHeight: 400, title: "Geometry", explainDetailView: explainDetialView)
    }

    let laminaMaterialExplain = ExplainBoxDesign()
    @objc func laminaMaterialQuestionExplain(_ sender: UIButton, event: UIEvent) {
        let explainDetialView: UIView = UIView()
        explainDetialView.explainDetialViewPureTextDesign(pureText: ExplainModel().laminateMaterialExplain + "\n\n" + ExplainModel().materialExplain)

        laminaMaterialExplain.showExplain(boxHeight: 400, title: "Lamina Material", explainDetailView: explainDetialView)
    }

    @objc func enterStackingSequenceDataBase(_ sender: UIButton, event: UIEvent) {
        LaminateStackingSequenceDataBaseViewController = StackingSequenceDataBase()

        LaminateStackingSequenceDataBaseViewController.delegate = self

        let navController = SCNavigationController(rootViewController: LaminateStackingSequenceDataBaseViewController)

        present(navController, animated: true, completion: nil)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        generateLayupFigure()
    }

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

    //  generate layup figure

    func generateLayupFigure() {
        let wrongStackingSequenceText: UITextView = UITextView()

        stackingSequenceFigureView.subviews.forEach({ $0.removeFromSuperview() }) // first remove all subviews
        stackingSequenceFigureView.layer.sublayers?.forEach({ $0.removeFromSuperlayer() }) // first remove all sublayers

        stackingSequenceFigureView.layer.addSublayer(laminateOutlineLayer)
        laminateOutlineLayer.fillColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        stackingSequenceFigureView.addSubview(wrongStackingSequenceText)

        wrongStackingSequenceText.translatesAutoresizingMaskIntoConstraints = false
        wrongStackingSequenceText.text = "Wrong Stacking Sequence"
        wrongStackingSequenceText.font = UIFont.systemFont(ofSize: 14)
        wrongStackingSequenceText.isScrollEnabled = false
        wrongStackingSequenceText.centerXAnchor.constraint(equalTo: stackingSequenceFigureView.centerXAnchor, constant: 0).isActive = true
        wrongStackingSequenceText.centerYAnchor.constraint(equalTo: stackingSequenceFigureView.centerYAnchor, constant: 0).isActive = true
        wrongStackingSequenceText.isHidden = true
        wrongStackingSequenceText.backgroundColor = .clear

        let layupSequence = getlayupSequence(textFieldValue: stackingSequenceTextField.text ?? "")

        if layupSequence == [] {
            wrongStackingSequenceText.isHidden = false
            laminateOutlineLayer.fillColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 0.5)
        }

        let nPly = layupSequence.count

        // plot stacking sequence figure

        if nPly == 1 {
            let laminateDividerLayer1: CAShapeLayer = CAShapeLayer()

            var angle1Alpha: CGFloat = 0
            if abs(layupSequence[0]).truncatingRemainder(dividingBy: 90) == 0 && layupSequence[0] != 0.0 {
                angle1Alpha = CGFloat(0)
            } else {
                angle1Alpha = CGFloat(0.9 - abs(layupSequence[0]).truncatingRemainder(dividingBy: 90) / 100)
            }

            let linePath1 = UIBezierPath()
            linePath1.move(to: CGPoint(x: 0, y: 0))
            linePath1.addLine(to: CGPoint(x: 200, y: 0))
            linePath1.addLine(to: CGPoint(x: 200, y: 100))
            linePath1.addLine(to: CGPoint(x: 0, y: 100))
            linePath1.close()
            laminateDividerLayer1.path = linePath1.cgPath
            laminateDividerLayer1.fillColor = UIColor(displayP3Red: 0.6, green: 0.6, blue: 0.6, alpha: angle1Alpha).cgColor
            laminateDividerLayer1.strokeColor = UIColor.blackThemeColor.cgColor

            stackingSequenceFigureView.layer.addSublayer(laminateDividerLayer1)

            let angle1: UITextView = UITextView()

            stackingSequenceFigureView.addSubview(angle1)

            angle1.translatesAutoresizingMaskIntoConstraints = false
            angle1.text = String(format: "%.1f", layupSequence[0])
            angle1.font = UIFont.systemFont(ofSize: 14)
            angle1.isScrollEnabled = false
            angle1.centerXAnchor.constraint(equalTo: stackingSequenceFigureView.centerXAnchor, constant: 0).isActive = true
            angle1.centerYAnchor.constraint(equalTo: stackingSequenceFigureView.centerYAnchor, constant: 0).isActive = true
            angle1.backgroundColor = .clear

        } else if nPly == 2 {
            let laminateDividerLayer1: CAShapeLayer = CAShapeLayer()
            let laminateDividerLayer2: CAShapeLayer = CAShapeLayer()

            var angle1Alpha: CGFloat = 0
            if abs(layupSequence[1]).truncatingRemainder(dividingBy: 90) == 0 && layupSequence[1] != 0.0 {
                angle1Alpha = CGFloat(0)
            } else {
                angle1Alpha = CGFloat(0.9 - abs(layupSequence[1]).truncatingRemainder(dividingBy: 90) / 100)
            }

            var angle2Alpha: CGFloat = 0
            if abs(layupSequence[0]).truncatingRemainder(dividingBy: 90) == 0 && layupSequence[0] != 0.0 {
                angle2Alpha = CGFloat(0)
            } else {
                angle2Alpha = CGFloat(0.9 - abs(layupSequence[0]).truncatingRemainder(dividingBy: 90) / 100)
            }

            let linePath1 = UIBezierPath()
            linePath1.move(to: CGPoint(x: 0, y: 0))
            linePath1.addLine(to: CGPoint(x: 200, y: 0))
            linePath1.addLine(to: CGPoint(x: 200, y: 50))
            linePath1.addLine(to: CGPoint(x: 0, y: 50))
            linePath1.close()
            laminateDividerLayer1.path = linePath1.cgPath
            laminateDividerLayer1.fillColor = UIColor(displayP3Red: 0.6, green: 0.6, blue: 0.6, alpha: angle1Alpha).cgColor
            laminateDividerLayer1.strokeColor = UIColor.blackThemeColor.cgColor

            let linePath2 = UIBezierPath()
            linePath2.move(to: CGPoint(x: 0, y: 50))
            linePath2.addLine(to: CGPoint(x: 200, y: 50))
            linePath2.addLine(to: CGPoint(x: 200, y: 100))
            linePath2.addLine(to: CGPoint(x: 0, y: 100))
            linePath2.close()
            laminateDividerLayer2.path = linePath2.cgPath
            laminateDividerLayer2.fillColor = UIColor(displayP3Red: 0.6, green: 0.6, blue: 0.6, alpha: angle2Alpha).cgColor
            laminateDividerLayer2.strokeColor = UIColor.blackThemeColor.cgColor

            stackingSequenceFigureView.layer.addSublayer(laminateDividerLayer1)
            stackingSequenceFigureView.layer.addSublayer(laminateDividerLayer2)

            let angle1: UITextView = UITextView()
            let angle2: UITextView = UITextView()

            stackingSequenceFigureView.addSubview(angle1)
            stackingSequenceFigureView.addSubview(angle2)

            angle1.translatesAutoresizingMaskIntoConstraints = false
            angle1.text = String(format: "%.1f", layupSequence[1])
            angle1.font = UIFont.systemFont(ofSize: 14)
            angle1.isScrollEnabled = false
            angle1.centerXAnchor.constraint(equalTo: stackingSequenceFigureView.centerXAnchor, constant: 0).isActive = true
            angle1.centerYAnchor.constraint(equalTo: stackingSequenceFigureView.centerYAnchor, constant: -16.6 - 10).isActive = true
            angle1.backgroundColor = .clear

            angle2.translatesAutoresizingMaskIntoConstraints = false
            angle2.text = String(format: "%.1f", layupSequence[0])
            angle2.font = UIFont.systemFont(ofSize: 14)
            angle2.isScrollEnabled = false
            angle2.centerXAnchor.constraint(equalTo: stackingSequenceFigureView.centerXAnchor, constant: 0).isActive = true
            angle2.centerYAnchor.constraint(equalTo: stackingSequenceFigureView.centerYAnchor, constant: 16.6 + 10).isActive = true
            angle2.backgroundColor = .clear

        } else if nPly == 3 {
            var angle1Alpha: CGFloat = 0
            if abs(layupSequence[2]).truncatingRemainder(dividingBy: 90) == 0 && layupSequence[2] != 0.0 {
                angle1Alpha = CGFloat(0)
            } else {
                angle1Alpha = CGFloat(0.9 - abs(layupSequence[2]).truncatingRemainder(dividingBy: 90) / 100)
            }

            var angle2Alpha: CGFloat = 0
            if abs(layupSequence[1]).truncatingRemainder(dividingBy: 90) == 0 && layupSequence[1] != 0.0 {
                angle2Alpha = CGFloat(0)
            } else {
                angle2Alpha = CGFloat(0.9 - abs(layupSequence[1]).truncatingRemainder(dividingBy: 90) / 100)
            }

            var angle3Alpha: CGFloat = 0
            if abs(layupSequence[0]).truncatingRemainder(dividingBy: 90) == 0 && layupSequence[0] != 0.0 {
                angle3Alpha = CGFloat(0)
            } else {
                angle3Alpha = CGFloat(0.9 - abs(layupSequence[0]).truncatingRemainder(dividingBy: 90) / 100)
            }

            let laminateDividerLayer1: CAShapeLayer = CAShapeLayer()
            let laminateDividerLayer2: CAShapeLayer = CAShapeLayer()
            let laminateDividerLayer3: CAShapeLayer = CAShapeLayer()

            stackingSequenceFigureView.layer.addSublayer(laminateDividerLayer1)
            stackingSequenceFigureView.layer.addSublayer(laminateDividerLayer2)
            stackingSequenceFigureView.layer.addSublayer(laminateDividerLayer3)

            let linePath1 = UIBezierPath()
            linePath1.move(to: CGPoint(x: 0, y: 0))
            linePath1.addLine(to: CGPoint(x: 200, y: 0))
            linePath1.addLine(to: CGPoint(x: 200, y: 33.3))
            linePath1.addLine(to: CGPoint(x: 0, y: 33.3))
            linePath1.close()
            laminateDividerLayer1.path = linePath1.cgPath
            laminateDividerLayer1.fillColor = UIColor(displayP3Red: 0.6, green: 0.6, blue: 0.6, alpha: angle1Alpha).cgColor
            laminateDividerLayer1.strokeColor = UIColor.blackThemeColor.cgColor

            let linePath2 = UIBezierPath()
            linePath2.move(to: CGPoint(x: 0, y: 33.3))
            linePath2.addLine(to: CGPoint(x: 200, y: 33.3))
            linePath2.addLine(to: CGPoint(x: 200, y: 66.6))
            linePath2.addLine(to: CGPoint(x: 0, y: 66.6))
            linePath2.close()
            laminateDividerLayer2.path = linePath2.cgPath
            laminateDividerLayer2.fillColor = UIColor(displayP3Red: 0.6, green: 0.6, blue: 0.6, alpha: angle2Alpha).cgColor
            laminateDividerLayer2.strokeColor = UIColor.blackThemeColor.cgColor

            let linePath3 = UIBezierPath()
            linePath3.move(to: CGPoint(x: 0, y: 66.6))
            linePath3.addLine(to: CGPoint(x: 200, y: 66.6))
            linePath3.addLine(to: CGPoint(x: 200, y: 100))
            linePath3.addLine(to: CGPoint(x: 0, y: 100))
            linePath3.close()
            laminateDividerLayer3.path = linePath3.cgPath
            laminateDividerLayer3.fillColor = UIColor(displayP3Red: 0.6, green: 0.6, blue: 0.6, alpha: angle3Alpha).cgColor
            laminateDividerLayer3.strokeColor = UIColor.blackThemeColor.cgColor

            let angle1: UITextView = UITextView()
            let angle2: UITextView = UITextView()
            let angle3: UITextView = UITextView()

            stackingSequenceFigureView.addSubview(angle1)
            stackingSequenceFigureView.addSubview(angle2)
            stackingSequenceFigureView.addSubview(angle3)

            angle1.translatesAutoresizingMaskIntoConstraints = false
            angle1.text = String(format: "%.1f", layupSequence[2])
            angle1.font = UIFont.systemFont(ofSize: 14)
            angle1.isScrollEnabled = false
            angle1.centerXAnchor.constraint(equalTo: stackingSequenceFigureView.centerXAnchor, constant: 0).isActive = true
            angle1.centerYAnchor.constraint(equalTo: stackingSequenceFigureView.centerYAnchor, constant: -25 - 10).isActive = true
            angle1.backgroundColor = .clear

            angle2.translatesAutoresizingMaskIntoConstraints = false
            angle2.text = String(format: "%.1f", layupSequence[1])
            angle2.font = UIFont.systemFont(ofSize: 14)
            angle2.isScrollEnabled = false
            angle2.centerXAnchor.constraint(equalTo: stackingSequenceFigureView.centerXAnchor, constant: 0).isActive = true
            angle2.centerYAnchor.constraint(equalTo: stackingSequenceFigureView.centerYAnchor, constant: 0).isActive = true
            angle2.backgroundColor = .clear

            angle3.translatesAutoresizingMaskIntoConstraints = false
            angle3.text = String(format: "%.1f", layupSequence[0])
            angle3.font = UIFont.systemFont(ofSize: 14)
            angle3.isScrollEnabled = false
            angle3.centerXAnchor.constraint(equalTo: stackingSequenceFigureView.centerXAnchor, constant: 0).isActive = true
            angle3.centerYAnchor.constraint(equalTo: stackingSequenceFigureView.centerYAnchor, constant: 25 + 10).isActive = true
            angle3.backgroundColor = .clear

        } else if nPly == 4 {
            var angle1Alpha: CGFloat = 0
            if abs(layupSequence[3]).truncatingRemainder(dividingBy: 90) == 0 && layupSequence[3] != 0.0 {
                angle1Alpha = CGFloat(0)
            } else {
                angle1Alpha = CGFloat(0.9 - abs(layupSequence[3]).truncatingRemainder(dividingBy: 90) / 100)
            }

            var angle2Alpha: CGFloat = 0
            if abs(layupSequence[2]).truncatingRemainder(dividingBy: 90) == 0 && layupSequence[2] != 0.0 {
                angle2Alpha = CGFloat(0)
            } else {
                angle2Alpha = CGFloat(0.9 - abs(layupSequence[2]).truncatingRemainder(dividingBy: 90) / 100)
            }

            var angle3Alpha: CGFloat = 0
            if abs(layupSequence[1]).truncatingRemainder(dividingBy: 90) == 0 && layupSequence[1] != 0.0 {
                angle3Alpha = CGFloat(0)
            } else {
                angle3Alpha = CGFloat(0.9 - abs(layupSequence[1]).truncatingRemainder(dividingBy: 90) / 100)
            }

            var angle4Alpha: CGFloat = 0
            if abs(layupSequence[0]).truncatingRemainder(dividingBy: 90) == 0 && layupSequence[0] != 0.0 {
                angle4Alpha = CGFloat(0)
            } else {
                angle4Alpha = CGFloat(0.9 - abs(layupSequence[0]).truncatingRemainder(dividingBy: 90) / 100)
            }

            let laminateDividerLayer1: CAShapeLayer = CAShapeLayer()
            let laminateDividerLayer2: CAShapeLayer = CAShapeLayer()
            let laminateDividerLayer3: CAShapeLayer = CAShapeLayer()
            let laminateDividerLayer4: CAShapeLayer = CAShapeLayer()

            stackingSequenceFigureView.layer.addSublayer(laminateDividerLayer1)
            stackingSequenceFigureView.layer.addSublayer(laminateDividerLayer2)
            stackingSequenceFigureView.layer.addSublayer(laminateDividerLayer3)
            stackingSequenceFigureView.layer.addSublayer(laminateDividerLayer4)

            let linePath1 = UIBezierPath()
            linePath1.move(to: CGPoint(x: 0, y: 0))
            linePath1.addLine(to: CGPoint(x: 200, y: 0))
            linePath1.addLine(to: CGPoint(x: 200, y: 25))
            linePath1.addLine(to: CGPoint(x: 0, y: 25))
            linePath1.close()
            laminateDividerLayer1.path = linePath1.cgPath
            laminateDividerLayer1.fillColor = UIColor(displayP3Red: 0.6, green: 0.6, blue: 0.6, alpha: angle1Alpha).cgColor
            laminateDividerLayer1.strokeColor = UIColor.blackThemeColor.cgColor

            let linePath2 = UIBezierPath()
            linePath2.move(to: CGPoint(x: 0, y: 25))
            linePath2.addLine(to: CGPoint(x: 200, y: 25))
            linePath2.addLine(to: CGPoint(x: 200, y: 50))
            linePath2.addLine(to: CGPoint(x: 0, y: 50))
            linePath2.close()
            laminateDividerLayer2.path = linePath2.cgPath
            laminateDividerLayer2.fillColor = UIColor(displayP3Red: 0.6, green: 0.6, blue: 0.6, alpha: angle2Alpha).cgColor
            laminateDividerLayer2.strokeColor = UIColor.blackThemeColor.cgColor

            let linePath3 = UIBezierPath()
            linePath3.move(to: CGPoint(x: 0, y: 50))
            linePath3.addLine(to: CGPoint(x: 200, y: 50))
            linePath3.addLine(to: CGPoint(x: 200, y: 75))
            linePath3.addLine(to: CGPoint(x: 0, y: 75))
            linePath3.close()
            laminateDividerLayer3.path = linePath3.cgPath
            laminateDividerLayer3.fillColor = UIColor(displayP3Red: 0.6, green: 0.6, blue: 0.6, alpha: angle3Alpha).cgColor
            laminateDividerLayer3.strokeColor = UIColor.blackThemeColor.cgColor

            let linePath4 = UIBezierPath()
            linePath4.move(to: CGPoint(x: 0, y: 75))
            linePath4.addLine(to: CGPoint(x: 200, y: 75))
            linePath4.addLine(to: CGPoint(x: 200, y: 100))
            linePath4.addLine(to: CGPoint(x: 0, y: 100))
            linePath4.close()
            laminateDividerLayer4.path = linePath4.cgPath
            laminateDividerLayer4.fillColor = UIColor(displayP3Red: 0.6, green: 0.6, blue: 0.6, alpha: angle4Alpha).cgColor
            laminateDividerLayer4.strokeColor = UIColor.blackThemeColor.cgColor

            let angle1: UITextView = UITextView()
            let angle2: UITextView = UITextView()
            let angle3: UITextView = UITextView()
            let angle4: UITextView = UITextView()

            stackingSequenceFigureView.addSubview(angle1)
            stackingSequenceFigureView.addSubview(angle2)
            stackingSequenceFigureView.addSubview(angle3)
            stackingSequenceFigureView.addSubview(angle4)

            angle1.translatesAutoresizingMaskIntoConstraints = false
            angle1.text = String(format: "%.1f", layupSequence[3])
            angle1.font = UIFont.systemFont(ofSize: 14)
            angle1.isScrollEnabled = false
            angle1.centerXAnchor.constraint(equalTo: stackingSequenceFigureView.centerXAnchor, constant: 0).isActive = true
            angle1.centerYAnchor.constraint(equalTo: stackingSequenceFigureView.centerYAnchor, constant: -38).isActive = true
            angle1.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)

            angle2.translatesAutoresizingMaskIntoConstraints = false
            angle2.text = String(format: "%.1f", layupSequence[2])
            angle2.font = UIFont.systemFont(ofSize: 14)
            angle2.isScrollEnabled = false
            angle2.centerXAnchor.constraint(equalTo: stackingSequenceFigureView.centerXAnchor, constant: 0).isActive = true
            angle2.centerYAnchor.constraint(equalTo: stackingSequenceFigureView.centerYAnchor, constant: -13).isActive = true
            angle2.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)

            angle3.translatesAutoresizingMaskIntoConstraints = false
            angle3.text = String(format: "%.1f", layupSequence[1])
            angle3.font = UIFont.systemFont(ofSize: 14)
            angle3.isScrollEnabled = false
            angle3.centerXAnchor.constraint(equalTo: stackingSequenceFigureView.centerXAnchor, constant: 0).isActive = true
            angle3.centerYAnchor.constraint(equalTo: stackingSequenceFigureView.centerYAnchor, constant: 13).isActive = true
            angle3.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)

            angle4.translatesAutoresizingMaskIntoConstraints = false
            angle4.text = String(format: "%.1f", layupSequence[0])
            angle4.font = UIFont.systemFont(ofSize: 14)
            angle4.isScrollEnabled = false
            angle4.centerXAnchor.constraint(equalTo: stackingSequenceFigureView.centerXAnchor, constant: 0).isActive = true
            angle4.centerYAnchor.constraint(equalTo: stackingSequenceFigureView.centerYAnchor, constant: 38).isActive = true
            angle4.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)

        } else if nPly > 4 {
            var angle1Alpha: CGFloat = 0
            if abs(layupSequence[layupSequence.endIndex - 1]).truncatingRemainder(dividingBy: 90) == 0 && layupSequence[layupSequence.endIndex - 1] != 0.0 {
                angle1Alpha = CGFloat(0)
            } else {
                angle1Alpha = CGFloat(0.9 - abs(layupSequence[layupSequence.endIndex - 1]).truncatingRemainder(dividingBy: 90) / 100)
            }

            var angle2Alpha: CGFloat = 0
            if abs(layupSequence[layupSequence.endIndex - 2]).truncatingRemainder(dividingBy: 90) == 0 && layupSequence[layupSequence.endIndex - 2] != 0.0 {
                angle2Alpha = CGFloat(0)
            } else {
                angle2Alpha = CGFloat(0.9 - abs(layupSequence[layupSequence.endIndex - 2]).truncatingRemainder(dividingBy: 90) / 100)
            }

            var angle3Alpha: CGFloat = 0
            if abs(layupSequence[1]).truncatingRemainder(dividingBy: 90) == 0 && layupSequence[1] != 0.0 {
                angle3Alpha = CGFloat(0)
            } else {
                angle3Alpha = CGFloat(0.9 - abs(layupSequence[1]).truncatingRemainder(dividingBy: 90) / 100)
            }

            var angle4Alpha: CGFloat = 0
            if abs(layupSequence[0]).truncatingRemainder(dividingBy: 90) == 0 && layupSequence[0] != 0.0 {
                angle4Alpha = CGFloat(0)
            } else {
                angle4Alpha = CGFloat(0.9 - abs(layupSequence[0]).truncatingRemainder(dividingBy: 90) / 100)
            }

            let moreAngleAlpha: CGFloat = 0.45

            let laminateDividerLayer1: CAShapeLayer = CAShapeLayer()
            let laminateDividerLayer2: CAShapeLayer = CAShapeLayer()
            let laminateDividerLayer3: CAShapeLayer = CAShapeLayer()
            let laminateDividerLayer4: CAShapeLayer = CAShapeLayer()
            let laminateDividerLayerMore: CAShapeLayer = CAShapeLayer()

            stackingSequenceFigureView.layer.addSublayer(laminateDividerLayer1)
            stackingSequenceFigureView.layer.addSublayer(laminateDividerLayer2)
            stackingSequenceFigureView.layer.addSublayer(laminateDividerLayer3)
            stackingSequenceFigureView.layer.addSublayer(laminateDividerLayer4)
            stackingSequenceFigureView.layer.addSublayer(laminateDividerLayerMore)

            let linePath1 = UIBezierPath()
            linePath1.move(to: CGPoint(x: 0, y: 0))
            linePath1.addLine(to: CGPoint(x: 200, y: 0))
            linePath1.addLine(to: CGPoint(x: 200, y: 20))
            linePath1.addLine(to: CGPoint(x: 0, y: 20))
            linePath1.close()
            laminateDividerLayer1.path = linePath1.cgPath
            laminateDividerLayer1.fillColor = UIColor(displayP3Red: 0.6, green: 0.6, blue: 0.6, alpha: angle1Alpha).cgColor
            laminateDividerLayer1.strokeColor = UIColor.blackThemeColor.cgColor

            let linePath2 = UIBezierPath()
            linePath2.move(to: CGPoint(x: 0, y: 20))
            linePath2.addLine(to: CGPoint(x: 200, y: 20))
            linePath2.addLine(to: CGPoint(x: 200, y: 40))
            linePath2.addLine(to: CGPoint(x: 0, y: 40))
            linePath2.close()
            laminateDividerLayer2.path = linePath2.cgPath
            laminateDividerLayer2.fillColor = UIColor(displayP3Red: 0.6, green: 0.6, blue: 0.6, alpha: angle2Alpha).cgColor
            laminateDividerLayer2.strokeColor = UIColor.blackThemeColor.cgColor

            let linePath3 = UIBezierPath()
            linePath3.move(to: CGPoint(x: 0, y: 60))
            linePath3.addLine(to: CGPoint(x: 200, y: 60))
            linePath3.addLine(to: CGPoint(x: 200, y: 80))
            linePath3.addLine(to: CGPoint(x: 0, y: 80))
            linePath3.close()
            laminateDividerLayer3.path = linePath3.cgPath
            laminateDividerLayer3.fillColor = UIColor(displayP3Red: 0.6, green: 0.6, blue: 0.6, alpha: angle3Alpha).cgColor
            laminateDividerLayer3.strokeColor = UIColor.blackThemeColor.cgColor

            let linePath4 = UIBezierPath()
            linePath4.move(to: CGPoint(x: 0, y: 80))
            linePath4.addLine(to: CGPoint(x: 200, y: 80))
            linePath4.addLine(to: CGPoint(x: 200, y: 100))
            linePath4.addLine(to: CGPoint(x: 0, y: 100))
            linePath4.close()
            laminateDividerLayer4.path = linePath4.cgPath
            laminateDividerLayer4.fillColor = UIColor(displayP3Red: 0.6, green: 0.6, blue: 0.6, alpha: angle4Alpha).cgColor
            laminateDividerLayer4.strokeColor = UIColor.blackThemeColor.cgColor

            let linePathMore = UIBezierPath()
            linePathMore.move(to: CGPoint(x: 0, y: 40))
            linePathMore.addLine(to: CGPoint(x: 200, y: 40))
            linePathMore.addLine(to: CGPoint(x: 200, y: 60))
            linePathMore.addLine(to: CGPoint(x: 0, y: 60))
            linePathMore.close()
            laminateDividerLayerMore.path = linePathMore.cgPath
            laminateDividerLayerMore.fillColor = UIColor(displayP3Red: 0.6, green: 0.6, blue: 0.6, alpha: moreAngleAlpha).cgColor
            laminateDividerLayerMore.strokeColor = UIColor.blackThemeColor.cgColor

            let angle1: UITextView = UITextView()
            let angle2: UITextView = UITextView()
            let angle3: UITextView = UITextView()
            let angle4: UITextView = UITextView()
            let moreAngleText: UITextView = UITextView()

            stackingSequenceFigureView.addSubview(angle1)
            stackingSequenceFigureView.addSubview(angle2)
            stackingSequenceFigureView.addSubview(angle3)
            stackingSequenceFigureView.addSubview(angle4)
            stackingSequenceFigureView.addSubview(moreAngleText)

            angle1.translatesAutoresizingMaskIntoConstraints = false
            angle1.text = String(format: "%.1f", layupSequence[layupSequence.endIndex - 1])
            angle1.font = UIFont.systemFont(ofSize: 12)
            angle1.isScrollEnabled = false
            angle1.centerXAnchor.constraint(equalTo: stackingSequenceFigureView.centerXAnchor, constant: 0).isActive = true
            angle1.centerYAnchor.constraint(equalTo: stackingSequenceFigureView.centerYAnchor, constant: -40).isActive = true
            angle1.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)

            angle2.translatesAutoresizingMaskIntoConstraints = false
            angle2.text = String(format: "%.1f", layupSequence[layupSequence.endIndex - 2])
            angle2.font = UIFont.systemFont(ofSize: 12)
            angle2.isScrollEnabled = false
            angle2.centerXAnchor.constraint(equalTo: stackingSequenceFigureView.centerXAnchor, constant: 0).isActive = true
            angle2.centerYAnchor.constraint(equalTo: stackingSequenceFigureView.centerYAnchor, constant: -20).isActive = true
            angle2.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)

            angle3.translatesAutoresizingMaskIntoConstraints = false
            angle3.text = String(format: "%.1f", layupSequence[1])
            angle3.font = UIFont.systemFont(ofSize: 12)
            angle3.isScrollEnabled = false
            angle3.centerXAnchor.constraint(equalTo: stackingSequenceFigureView.centerXAnchor, constant: 0).isActive = true
            angle3.centerYAnchor.constraint(equalTo: stackingSequenceFigureView.centerYAnchor, constant: 20).isActive = true
            angle3.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)

            angle4.translatesAutoresizingMaskIntoConstraints = false
            angle4.text = String(format: "%.1f", layupSequence[0])
            angle4.font = UIFont.systemFont(ofSize: 12)
            angle4.isScrollEnabled = false
            angle4.centerXAnchor.constraint(equalTo: stackingSequenceFigureView.centerXAnchor, constant: 0).isActive = true
            angle4.centerYAnchor.constraint(equalTo: stackingSequenceFigureView.centerYAnchor, constant: 40).isActive = true
            angle4.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)

            moreAngleText.translatesAutoresizingMaskIntoConstraints = false
            let remainLayerCount = layupSequence.count - 4
            moreAngleText.text = "... omit \(remainLayerCount) layers"
            moreAngleText.font = UIFont.systemFont(ofSize: 12)
            moreAngleText.isScrollEnabled = false
            moreAngleText.centerXAnchor.constraint(equalTo: stackingSequenceFigureView.centerXAnchor, constant: 0).isActive = true
            moreAngleText.centerYAnchor.constraint(equalTo: stackingSequenceFigureView.centerYAnchor, constant: 0).isActive = true
            moreAngleText.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        }
    }

    @objc func saveStackingSequence(_ sender: UIButton) {
        let inputAlter = UIAlertController(title: "Save Stacking Sequence", message: "Enter the stacking sequence name.", preferredStyle: UIAlertController.Style.alert)
        inputAlter.addTextField { (textField: UITextField) in
            textField.placeholder = "Stacking Sequence Name"
            textField.text = self.stackingSequenceTextField.text
        }
        inputAlter.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        inputAlter.addAction(UIAlertAction(title: "Save", style: .default, handler: { (_: UIAlertAction) in

            let stackingSequenceNameTextField = inputAlter.textFields?.first

            // check empty name

            let emptyNameAlter = UIAlertController(title: "Empty Name", message: "Please enter a name for this stacking sequence.", preferredStyle: UIAlertController.Style.alert)
            emptyNameAlter.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

            var userStackingSequenceName: String = ""

            if stackingSequenceNameTextField?.text != "" {
                userStackingSequenceName = (stackingSequenceNameTextField?.text)!
            } else {
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

            let currentUserStackingSequence = UserStackingSequence(context: context)
            currentUserStackingSequence.setValue(userStackingSequenceName, forKey: "name")
            currentUserStackingSequence.setValue(self.stackingSequenceTextField.text, forKey: "stackingSequence")

            do {
                try context.save()
                self.loadCoreData()

                // stacking sequence saving animation

                let stackingSequenceImage: UIImage = UIImage(named: "stacking_sequence")!
                let stackingSequenceImageView: UIImageView = UIImageView(image: stackingSequenceImage)

                self.stackingSequenceView.addSubview(stackingSequenceImageView)

                stackingSequenceImageView.frame.origin.x = self.stackingSequenceTextField.frame.origin.x + self.stackingSequenceTextField.frame.width / 2 - stackingSequenceImageView.frame.width / 2
                stackingSequenceImageView.frame.origin.y = self.stackingSequenceTextField.frame.origin.y + self.stackingSequenceTextField.frame.height / 2

                UIView.animate(withDuration: 0.8, animations: {
                    stackingSequenceImageView.frame.origin.x = self.stackingSequenceDataBase.frame.origin.x + self.stackingSequenceDataBase.frame.width / 2 - stackingSequenceImageView.frame.width / 2
                    stackingSequenceImageView.frame.origin.y = self.stackingSequenceDataBase.frame.origin.y + self.stackingSequenceDataBase.frame.height / 2
                }, completion: { _ in
                    UIView.animate(withDuration: 0.2, animations: {
                        stackingSequenceImageView.removeFromSuperview()
                    })
                })

            } catch {
                print("Could not save data: \(error.localizedDescription)")
            }

        }))

        present(inputAlter, animated: true, completion: nil)
    }

    @objc func enterlaminaMaterialDataBase(_ sender: UIButton, event: UIEvent) {
        laminateLaminaMaterialDataBaseViewController = LaminaMaterialDataBase()

        laminateLaminaMaterialDataBaseViewController.delegate = self

        let navController = SCNavigationController(rootViewController: laminateLaminaMaterialDataBaseViewController)

        present(navController, animated: true, completion: nil)
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
                case "Transversely Isotropic", "Transversely isotropic":
                    laminaMaterialType = .transverselyIsotropic
                    break
                case "Orthotropic", "orthotropic":
                    laminaMaterialType = .orthotropic
                    break
                case "Anisotropic", "anisotropic":
                    laminaMaterialType = .anisotropic
                    break
                default:
                    laminaMaterialType = .orthotropic
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

        createMaterialCard(materialCard: &laminaMaterialCard, materialName: laminaMaterialNameLabel, label: &laminaMaterialPropertiesLabel, value: &laminaMaterialPropertiesTextField, aboveConstraint: laminaMaterialTypeSegementedControl.bottomAnchor, under: laminaMaterialView, typeOfAnalysis: analysisSettings.typeOfAnalysis, materialType: laminaMaterialType)

        laminaMaterialCard.bottomAnchor.constraint(equalTo: laminaMaterialView.bottomAnchor, constant: -20).isActive = true

        changeMaterialDataField()
    }

    @objc func saveLaminaMaterial(_ sender: UIButton) {
        let inputAlter = UIAlertController(title: "Save Lamina Material", message: "Enter the material name.", preferredStyle: UIAlertController.Style.alert)
        inputAlter.addTextField { (textField: UITextField) in
            textField.placeholder = "Material Name"
        }
        inputAlter.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        inputAlter.addAction(UIAlertAction(title: "Save", style: .default, handler: { (_: UIAlertAction) in

            let materialNameTextField = inputAlter.textFields?.first

            // check empty name

            let emptyNameAlter = UIAlertController(title: "Empty Name", message: "Please enter a name for this material.", preferredStyle: UIAlertController.Style.alert)
            emptyNameAlter.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

            var userMaterialName: String = ""

            if materialNameTextField?.text != "" {
                userMaterialName = (materialNameTextField?.text)!
            } else {
                self.present(emptyNameAlter, animated: true, completion: nil)
                return
            }

            // check wrong or empty material value

            var userLaminaMaterialDictionary: [String: Double] = [:]
            var userLaminaMaterialType: String = ""

            let wrongMaterialValueAlter = UIAlertController(title: "Wrong Material Values", message: "Please enter valid values (number) for this material.", preferredStyle: UIAlertController.Style.alert)
            wrongMaterialValueAlter.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

            let emptyMaterialValueAlter = UIAlertController(title: "Empty Material Value", message: "Please enter values (number) for this material.", preferredStyle: UIAlertController.Style.alert)
            emptyMaterialValueAlter.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

            if self.laminaMaterialType == .transverselyIsotropic {
                userLaminaMaterialType = "Transversely Isotropic"
                for i in 0 ... materialPropertyName.transverselyIsotropic.count - 1 {
                    if let valueString = self.laminaMaterialPropertiesTextField[i].text {
                        if let value = Double(valueString) {
                            userLaminaMaterialDictionary[materialPropertyName.transverselyIsotropic[i]] = value
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
                    for i in 0 ... materialPropertyName.transverselyIsotropicThermal.count - 1 {
                        if let valueString = self.laminaMaterialPropertiesTextField[i + materialPropertyName.transverselyIsotropic.count].text {
                            if let value = Double(valueString) {
                                userLaminaMaterialDictionary[materialPropertyName.transverselyIsotropicThermal[i]] = value
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
                userLaminaMaterialType = "Orthotropic"
                for i in 0 ... materialPropertyName.orthotropic.count - 1 {
                    if let valueString = self.laminaMaterialPropertiesTextField[i].text {
                        if let value = Double(valueString) {
                            userLaminaMaterialDictionary[materialPropertyName.orthotropic[i]] = value
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
                    for i in 0 ... materialPropertyName.orthotropicThermal.count - 1 {
                        if let valueString = self.laminaMaterialPropertiesTextField[i + materialPropertyName.orthotropic.count].text {
                            if let value = Double(valueString) {
                                userLaminaMaterialDictionary[materialPropertyName.orthotropicThermal[i]] = value
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
                userLaminaMaterialType = "Anisotropic"
                for i in 0 ... materialPropertyName.anisotropic.count - 1 {
                    if let valueString = self.laminaMaterialPropertiesTextField[i].text {
                        if let value = Double(valueString) {
                            userLaminaMaterialDictionary[materialPropertyName.anisotropic[i]] = value
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
                    for i in 0 ... materialPropertyName.anisotropicThermal.count - 1 {
                        if let valueString = self.laminaMaterialPropertiesTextField[i + materialPropertyName.anisotropic.count].text {
                            if let value = Double(valueString) {
                                userLaminaMaterialDictionary[materialPropertyName.anisotropicThermal[i]] = value
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

            let currentUserLaminaMaterial = UserLaminaMaterial(context: context)
            currentUserLaminaMaterial.setValue(userMaterialName, forKey: "name")
            currentUserLaminaMaterial.setValue(userLaminaMaterialType, forKey: "type")
            currentUserLaminaMaterial.setValue(userLaminaMaterialDictionary, forKey: "properties")

            do {
                try context.save()
                self.loadCoreData()

                // change material card material name

                self.laminaMaterialNameLabel.text = userMaterialName

                // material card saving animation

                let MaterialCardImage: UIImage = UIImage(named: "user_defined_material_card")!
                let MaterialCardImageView: UIImageView = UIImageView(image: MaterialCardImage)

                self.laminaMaterialView.addSubview(MaterialCardImageView)

                MaterialCardImageView.frame.origin.x = self.laminaMaterialCard.frame.origin.x + self.laminaMaterialCard.frame.width / 2 - MaterialCardImageView.frame.width / 2
                MaterialCardImageView.frame.origin.y = self.laminaMaterialCard.frame.origin.y + self.laminaMaterialCard.frame.height / 2

                UIView.animate(withDuration: 0.8, animations: {
                    MaterialCardImageView.frame.origin.x = self.laminaMaterialDataBase.frame.origin.x + self.laminaMaterialDataBase.frame.width / 2 - MaterialCardImageView.frame.width / 2
                    MaterialCardImageView.frame.origin.y = self.laminaMaterialDataBase.frame.origin.y + self.laminaMaterialDataBase.frame.height / 2
                }, completion: { _ in
                    UIView.animate(withDuration: 0.2, animations: {
                        MaterialCardImageView.removeFromSuperview()
                    })
                })

            } catch {
                print("Could not save data: \(error.localizedDescription)")
            }

        }))

        present(inputAlter, animated: true, completion: nil)
    }

    // MARK: create action sheet

    override func createActionSheet() {
        super.createActionSheet()

        let m0 = UIAlertAction(title: "SwiftComp", style: UIAlertAction.Style.default) { [weak self] (_) -> Void in

            guard let self = self else { return }

            self.methodLabelButton.setTitle("SwiftComp", for: .normal)
            self.methodLabelButton.layoutIfNeeded()

            self.analysisSettings.calculationMethod = .SwiftComp

            self.editToolBar()

            if self.analysisSettings.structuralModel == .plate {
                if self.analysisSettings.structuralSubmodel != .KirchhoffLovePlateShellModel && self.analysisSettings.structuralSubmodel != .ReissnerMindlinPlateShellModel {
                    self.analysisSettings.structuralSubmodel = .KirchhoffLovePlateShellModel
                }

                self.structuralModelView.constraints.filter({ $0.firstAttribute == NSLayoutConstraint.Attribute.bottom }).forEach { $0.isActive = false }
                self.structuralModelLabelButton.bottomAnchor.constraint(equalTo: self.structuralModelView.bottomAnchor, constant: -12).isActive = false
                self.plateSubmodelView.bottomAnchor.constraint(equalTo: self.structuralModelView.bottomAnchor, constant: -12).isActive = false
                self.plateInitialCurvaturesView.bottomAnchor.constraint(equalTo: self.structuralModelView.bottomAnchor, constant: -12).isActive = true
                self.structuralModelView.constraints.filter({ $0.firstAttribute == NSLayoutConstraint.Attribute.bottom }).forEach { $0.isActive = true }

                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.view.layoutIfNeeded()
                }, completion: { _ in
                    self.plateSubmodelView.isHidden = false
                    self.plateInitialCurvaturesView.isHidden = false
                })
            } else {
                self.analysisSettings.structuralSubmodel = .CauchyContinuumModel
            }
        }

        let m1 = UIAlertAction(title: "Classical Laminated Plate Theory (CLPT)", style: UIAlertAction.Style.default) { [weak self] (_) -> Void in

            guard let self = self else { return }

            self.methodLabelButton.setTitle("CLPT", for: .normal)
            self.methodLabelButton.layoutIfNeeded()

            self.analysisSettings.calculationMethod = .NonSwiftComp
            self.editToolBar()

            if self.analysisSettings.structuralModel == .plate {
                self.analysisSettings.structuralSubmodel = .KirchhoffLovePlateShellModel
                self.plateSubmodelView.isHidden = false
                self.plateInitialCurvaturesView.isHidden = true

                self.structuralModelView.constraints.filter({ $0.firstAttribute == NSLayoutConstraint.Attribute.bottom }).forEach { $0.isActive = false }
                self.structuralModelLabelButton.bottomAnchor.constraint(equalTo: self.structuralModelView.bottomAnchor, constant: -12).isActive = false
                self.plateSubmodelView.bottomAnchor.constraint(equalTo: self.structuralModelView.bottomAnchor, constant: -12).isActive = true
                self.plateInitialCurvaturesView.bottomAnchor.constraint(equalTo: self.structuralModelView.bottomAnchor, constant: -12).isActive = false
                self.structuralModelView.constraints.filter({ $0.firstAttribute == NSLayoutConstraint.Attribute.bottom }).forEach { $0.isActive = true }

                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.view.layoutIfNeeded()
                }, completion: nil)
            } else {
                self.analysisSettings.structuralSubmodel = .CauchyContinuumModel
            }
        }

        methodDataBaseAlterController.addAction(m0)
        methodDataBaseAlterController.addAction(m1)

        let s0 = UIAlertAction(title: "Plate Model", style: UIAlertAction.Style.default) { [weak self] (_) -> Void in

            guard let self = self else { return }

            self.structuralModelLabelButton.setTitle("Plate Model", for: .normal)
            self.structuralModelLabelButton.layoutIfNeeded()

            self.analysisSettings.structuralModel = .plate
            self.plateSubmodelLabelButton.setTitle("Kirchho-Love Model", for: .normal)
            self.analysisSettings.structuralSubmodel = .KirchhoffLovePlateShellModel

            self.structuralModelView.constraints.filter({ $0.firstAttribute == NSLayoutConstraint.Attribute.bottom }).forEach { $0.isActive = false }
            self.structuralModelLabelButton.bottomAnchor.constraint(equalTo: self.structuralModelView.bottomAnchor, constant: -12).isActive = false
            if self.analysisSettings.calculationMethod == .SwiftComp {
                self.plateSubmodelView.bottomAnchor.constraint(equalTo: self.structuralModelView.bottomAnchor, constant: -12).isActive = false
                self.plateInitialCurvaturesView.bottomAnchor.constraint(equalTo: self.structuralModelView.bottomAnchor, constant: -12).isActive = true
            } else {
                self.plateSubmodelView.bottomAnchor.constraint(equalTo: self.structuralModelView.bottomAnchor, constant: -12).isActive = true
                self.plateInitialCurvaturesView.bottomAnchor.constraint(equalTo: self.structuralModelView.bottomAnchor, constant: -12).isActive = false
            }
            self.structuralModelView.constraints.filter({ $0.firstAttribute == NSLayoutConstraint.Attribute.bottom }).forEach { $0.isActive = true }

            self.stackingSequenceView.constraints.filter({ $0.firstAttribute == NSLayoutConstraint.Attribute.bottom }).forEach { $0.isActive = false }
            self.laminaThicknessTextField.bottomAnchor.constraint(equalTo: self.stackingSequenceView.bottomAnchor, constant: -12).isActive = true
            self.stackingSequenceTextField.bottomAnchor.constraint(equalTo: self.stackingSequenceView.bottomAnchor, constant: -12).isActive = false
            self.stackingSequenceView.constraints.filter({ $0.firstAttribute == NSLayoutConstraint.Attribute.bottom }).forEach { $0.isActive = true }

            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: { _ in
                self.plateSubmodelView.isHidden = false
                self.plateInitialCurvaturesView.isHidden = false
                self.laminaThicknessLabel.isHidden = false
                self.laminaThicknessTextField.isHidden = false
            })
        }

        let s1 = UIAlertAction(title: "Solid Model", style: UIAlertAction.Style.default) { [weak self] (_) -> Void in

            guard let self = self else { return }

            self.structuralModelLabelButton.setTitle("Solid Model", for: .normal)
            self.structuralModelLabelButton.layoutIfNeeded()

            self.analysisSettings.structuralModel = .solid
            self.analysisSettings.structuralSubmodel = .CauchyContinuumModel

            // hide submodel and initial curvatures subsection

            self.plateSubmodelView.isHidden = true
            self.plateInitialCurvaturesView.isHidden = true

            self.structuralModelView.constraints.filter({ $0.firstAttribute == NSLayoutConstraint.Attribute.bottom }).forEach { $0.isActive = false }
            self.structuralModelLabelButton.bottomAnchor.constraint(equalTo: self.structuralModelView.bottomAnchor, constant: -12).isActive = true
            self.plateSubmodelView.bottomAnchor.constraint(equalTo: self.structuralModelView.bottomAnchor, constant: -12).isActive = false
            self.plateInitialCurvaturesView.bottomAnchor.constraint(equalTo: self.structuralModelView.bottomAnchor, constant: -12).isActive = false
            self.structuralModelView.constraints.filter({ $0.firstAttribute == NSLayoutConstraint.Attribute.bottom }).forEach { $0.isActive = true }

            // hide layup thickness field

            self.laminaThicknessLabel.isHidden = true
            self.laminaThicknessTextField.isHidden = true

            self.stackingSequenceView.constraints.filter({ $0.firstAttribute == NSLayoutConstraint.Attribute.bottom }).forEach { $0.isActive = false }
            self.laminaThicknessTextField.bottomAnchor.constraint(equalTo: self.stackingSequenceView.bottomAnchor, constant: -12).isActive = false
            self.stackingSequenceTextField.bottomAnchor.constraint(equalTo: self.stackingSequenceView.bottomAnchor, constant: -12).isActive = true
            self.stackingSequenceView.constraints.filter({ $0.firstAttribute == NSLayoutConstraint.Attribute.bottom }).forEach { $0.isActive = true }

            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }

        let s0NonSwiftComp = UIAlertAction(title: "Plate Model", style: UIAlertAction.Style.default) { [weak self] (_) -> Void in

            guard let self = self else { return }

            self.structuralModelLabelButton.setTitle("Plate Model", for: .normal)
            self.structuralModelLabelButton.layoutIfNeeded()

            self.analysisSettings.structuralModel = .plate
            self.plateSubmodelLabelButton.setTitle("Kirchho-Love Model", for: .normal)
            self.analysisSettings.structuralSubmodel = .KirchhoffLovePlateShellModel

            self.structuralModelView.constraints.filter({ $0.firstAttribute == NSLayoutConstraint.Attribute.bottom }).forEach { $0.isActive = false }
            self.structuralModelLabelButton.bottomAnchor.constraint(equalTo: self.structuralModelView.bottomAnchor, constant: -12).isActive = false
            if self.analysisSettings.calculationMethod == .SwiftComp {
                self.plateSubmodelView.bottomAnchor.constraint(equalTo: self.structuralModelView.bottomAnchor, constant: -12).isActive = false
                self.plateInitialCurvaturesView.bottomAnchor.constraint(equalTo: self.structuralModelView.bottomAnchor, constant: -12).isActive = true
            } else {
                self.plateSubmodelView.bottomAnchor.constraint(equalTo: self.structuralModelView.bottomAnchor, constant: -12).isActive = true
                self.plateInitialCurvaturesView.bottomAnchor.constraint(equalTo: self.structuralModelView.bottomAnchor, constant: -12).isActive = false
            }
            self.structuralModelView.constraints.filter({ $0.firstAttribute == NSLayoutConstraint.Attribute.bottom }).forEach { $0.isActive = true }

            self.stackingSequenceView.constraints.filter({ $0.firstAttribute == NSLayoutConstraint.Attribute.bottom }).forEach { $0.isActive = false }
            self.laminaThicknessTextField.bottomAnchor.constraint(equalTo: self.stackingSequenceView.bottomAnchor, constant: -12).isActive = true
            self.stackingSequenceTextField.bottomAnchor.constraint(equalTo: self.stackingSequenceView.bottomAnchor, constant: -12).isActive = false
            self.stackingSequenceView.constraints.filter({ $0.firstAttribute == NSLayoutConstraint.Attribute.bottom }).forEach { $0.isActive = true }

            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: { _ in
                self.plateSubmodelView.isHidden = false
                self.plateInitialCurvaturesView.isHidden = true
                self.laminaThicknessLabel.isHidden = false
                self.laminaThicknessTextField.isHidden = false
            })
        }

        let s1NonSwiftComp = UIAlertAction(title: "Solid Model", style: UIAlertAction.Style.default) { [weak self] (_) -> Void in

            guard let self = self else { return }

            self.structuralModelLabelButton.setTitle("Solid Model", for: .normal)
            self.structuralModelLabelButton.layoutIfNeeded()

            self.analysisSettings.structuralModel = .solid
            self.analysisSettings.structuralSubmodel = .CauchyContinuumModel

            // hide submodel and initial curvatures subsection

            self.plateSubmodelView.isHidden = true
            self.plateInitialCurvaturesView.isHidden = true

            self.structuralModelView.constraints.filter({ $0.firstAttribute == NSLayoutConstraint.Attribute.bottom }).forEach { $0.isActive = false }
            self.structuralModelLabelButton.bottomAnchor.constraint(equalTo: self.structuralModelView.bottomAnchor, constant: -12).isActive = true
            self.plateSubmodelView.bottomAnchor.constraint(equalTo: self.structuralModelView.bottomAnchor, constant: -12).isActive = false
            self.plateInitialCurvaturesView.bottomAnchor.constraint(equalTo: self.structuralModelView.bottomAnchor, constant: -12).isActive = false
            self.structuralModelView.constraints.filter({ $0.firstAttribute == NSLayoutConstraint.Attribute.bottom }).forEach { $0.isActive = true }

            // hide layup thickness field

            self.laminaThicknessLabel.isHidden = true
            self.laminaThicknessTextField.isHidden = true

            self.stackingSequenceView.constraints.filter({ $0.firstAttribute == NSLayoutConstraint.Attribute.bottom }).forEach { $0.isActive = false }
            self.laminaThicknessTextField.bottomAnchor.constraint(equalTo: self.stackingSequenceView.bottomAnchor, constant: -12).isActive = false
            self.stackingSequenceTextField.bottomAnchor.constraint(equalTo: self.stackingSequenceView.bottomAnchor, constant: -12).isActive = true
            self.stackingSequenceView.constraints.filter({ $0.firstAttribute == NSLayoutConstraint.Attribute.bottom }).forEach { $0.isActive = true }

            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }

        structuralModelDataBaseAlterController.addAction(s0)
        structuralModelDataBaseAlterController.addAction(s1)

        structuralModelDataBaseAlterControllerNonSwiftComp.addAction(s0NonSwiftComp)
        structuralModelDataBaseAlterControllerNonSwiftComp.addAction(s1NonSwiftComp)

        let sub0 = UIAlertAction(title: "Kirchho-Love Model", style: UIAlertAction.Style.default) { [weak self] (_) -> Void in
            guard let self = self else { return }
            self.plateSubmodelLabelButton.setTitle("Kirchho-Love Model", for: .normal)
            self.analysisSettings.structuralSubmodel = .KirchhoffLovePlateShellModel
        }

        let sub1 = UIAlertAction(title: "Reissner-Mindlin Model", style: UIAlertAction.Style.default) { [weak self] (_) -> Void in
            guard let self = self else { return }
            self.plateSubmodelLabelButton.setTitle("Reissner-Mindlin Model", for: .normal)
            self.analysisSettings.structuralSubmodel = .ReissnerMindlinPlateShellModel
        }

        let sub0NonSwiftComp = UIAlertAction(title: "Kirchho-Love Model", style: UIAlertAction.Style.default) { [weak self] (_) -> Void in
            guard let self = self else { return }
            self.plateSubmodelLabelButton.setTitle("Kirchho-Love Model", for: .normal)
            self.analysisSettings.structuralSubmodel = .KirchhoffLovePlateShellModel
        }

        plateSubmodelDataBaseAlterController.addAction(sub0)
        plateSubmodelDataBaseAlterController.addAction(sub1)

        plateSubmodelDataBaseAlterControllerNonSwiftComp.addAction(sub0NonSwiftComp)

        let t0 = UIAlertAction(title: "Elastic Analysis", style: UIAlertAction.Style.default) { [weak self] (_) -> Void in
            guard let self = self else { return }
            self.typeOfAnalysisLabelButton.setTitle("Elastic Analysis", for: .normal)
            self.analysisSettings.typeOfAnalysis = .elastic
            self.changeTypeOfAnalysis(typeOfAnalysis: .elastic)
        }

        let t1 = UIAlertAction(title: "Thermoelastic Analysis", style: UIAlertAction.Style.default) { [weak self] (_) -> Void in
            guard let self = self else { return }
            self.typeOfAnalysisLabelButton.setTitle("Thermoelastic Analysis", for: .normal)
            self.analysisSettings.typeOfAnalysis = .thermoElastic
            self.changeTypeOfAnalysis(typeOfAnalysis: .thermoElastic)
        }

        typeOfAnalysisDataBaseAlterController.addAction(t0)
        typeOfAnalysisDataBaseAlterController.addAction(t1)
    }

    // change type of analysis

    func changeTypeOfAnalysis(typeOfAnalysis: TypeOfAnalysis) {
        createMaterialCard(materialCard: &laminaMaterialCard, materialName: laminaMaterialNameLabel, label: &laminaMaterialPropertiesLabel, value: &laminaMaterialPropertiesTextField, aboveConstraint: laminaMaterialTypeSegementedControl.bottomAnchor, under: laminaMaterialView, typeOfAnalysis: typeOfAnalysis, materialType: laminaMaterialType)

        laminaMaterialCard.bottomAnchor.constraint(equalTo: laminaMaterialView.bottomAnchor, constant: -12).isActive = true

        changeMaterialDataField()
    }

    // MARK: Change material data field

    func changeMaterialDataField() {
        let allMaterials = MaterialBank()

        let materialCurrectName = laminaMaterialNameLabel.text!

        // empty material

        if materialCurrectName == "Empty Material" {
            if laminaMaterialType == .transverselyIsotropic {
                for i in 0 ... materialPropertyName.transverselyIsotropic.count - 1 {
                    laminaMaterialPropertiesTextField[i].text = ""
                }
                if analysisSettings.typeOfAnalysis == .thermoElastic {
                    for i in 0 ... materialPropertyName.transverselyIsotropicThermal.count - 1 {
                        laminaMaterialPropertiesTextField[i + materialPropertyName.transverselyIsotropic.count].text = ""
                    }
                }
            } else if laminaMaterialType == .orthotropic {
                for i in 0 ... materialPropertyName.orthotropic.count - 1 {
                    laminaMaterialPropertiesTextField[i].text = ""
                }
                if analysisSettings.typeOfAnalysis == .thermoElastic {
                    for i in 0 ... materialPropertyName.orthotropicThermal.count - 1 {
                        laminaMaterialPropertiesTextField[i + materialPropertyName.orthotropic.count].text = ""
                    }
                }
            } else if laminaMaterialType == .anisotropic {
                for i in 0 ... materialPropertyName.anisotropic.count - 1 {
                    laminaMaterialPropertiesTextField[i].text = ""
                }
                if analysisSettings.typeOfAnalysis == .thermoElastic {
                    for i in 0 ... materialPropertyName.anisotropicThermal.count - 1 {
                        laminaMaterialPropertiesTextField[i + materialPropertyName.anisotropic.count].text = ""
                    }
                }
            }
            return
        }

        // predefined material

        if let material = allMaterials.list.first(where: { $0.materialName == materialCurrectName }) {
            if laminaMaterialType == .transverselyIsotropic {
                for i in 0 ... materialPropertyName.transverselyIsotropic.count - 1 {
                    if let property = material.materialProperties[materialPropertyName.transverselyIsotropic[i]] {
                        laminaMaterialPropertiesTextField[i].text = String(format: "%.2f", property)
                    } else {
                        laminaMaterialPropertiesTextField[i].text = ""
                    }
                }
                if analysisSettings.typeOfAnalysis == .thermoElastic {
                    for i in 0 ... materialPropertyName.transverselyIsotropicThermal.count - 1 {
                        if let property = material.materialProperties[materialPropertyName.transverselyIsotropicThermal[i]] {
                            laminaMaterialPropertiesTextField[i + materialPropertyName.transverselyIsotropic.count].text = String(format: "%.2f", property)
                        } else {
                            laminaMaterialPropertiesTextField[i + materialPropertyName.transverselyIsotropic.count].text = ""
                        }
                    }
                }
            } else if laminaMaterialType == .orthotropic {
                for i in 0 ... materialPropertyName.orthotropic.count - 1 {
                    if let property = material.materialProperties[materialPropertyName.orthotropic[i]] {
                        laminaMaterialPropertiesTextField[i].text = String(format: "%.2f", property)
                    } else {
                        laminaMaterialPropertiesTextField[i].text = ""
                    }
                }
                if analysisSettings.typeOfAnalysis == .thermoElastic {
                    for i in 0 ... materialPropertyName.orthotropicThermal.count - 1 {
                        if let property = material.materialProperties[materialPropertyName.orthotropicThermal[i]] {
                            laminaMaterialPropertiesTextField[i + materialPropertyName.orthotropic.count].text = String(format: "%.2f", property)
                        } else {
                            laminaMaterialPropertiesTextField[i + materialPropertyName.orthotropic.count].text = ""
                        }
                    }
                }
            } else if laminaMaterialType == .anisotropic {
                for i in 0 ... materialPropertyName.anisotropic.count - 1 {
                    if let property = material.materialProperties[materialPropertyName.anisotropic[i]] {
                        laminaMaterialPropertiesTextField[i].text = String(format: "%.2f", property)
                    } else {
                        laminaMaterialPropertiesTextField[i].text = ""
                    }
                }
                if analysisSettings.typeOfAnalysis == .thermoElastic {
                    for i in 0 ... materialPropertyName.anisotropicThermal.count - 1 {
                        if let property = material.materialProperties[materialPropertyName.anisotropicThermal[i]] {
                            laminaMaterialPropertiesTextField[i + materialPropertyName.anisotropic.count].text = String(format: "%.2f", property)
                        } else {
                            laminaMaterialPropertiesTextField[i + materialPropertyName.anisotropic.count].text = ""
                        }
                    }
                }
            }
            return
        }

        // user defined material

        if let userSaveMaterial = userSavedLaminaMaterials.first(where: { $0.name == materialCurrectName }) {
            if laminaMaterialType == .transverselyIsotropic {
                for i in 0 ... materialPropertyName.transverselyIsotropic.count - 1 {
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
                if analysisSettings.typeOfAnalysis == .thermoElastic {
                    for i in 0 ... materialPropertyName.transverselyIsotropicThermal.count - 1 {
                        if let valueDictionary = userSaveMaterial.properties as? [String: Double] {
                            if let value = valueDictionary[materialPropertyName.transverselyIsotropicThermal[i]] {
                                laminaMaterialPropertiesTextField[i + materialPropertyName.transverselyIsotropic.count].text = String(format: "%.2f", value)
                            } else {
                                laminaMaterialPropertiesTextField[i + materialPropertyName.transverselyIsotropic.count].text = ""
                            }
                        } else {
                            laminaMaterialPropertiesTextField[i + materialPropertyName.transverselyIsotropic.count].text = ""
                        }
                    }
                }
            } else if laminaMaterialType == .orthotropic {
                for i in 0 ... materialPropertyName.orthotropic.count - 1 {
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
                if analysisSettings.typeOfAnalysis == .thermoElastic {
                    for i in 0 ... materialPropertyName.orthotropicThermal.count - 1 {
                        if let valueDictionary = userSaveMaterial.properties as? [String: Double] {
                            if let value = valueDictionary[materialPropertyName.orthotropicThermal[i]] {
                                laminaMaterialPropertiesTextField[i + materialPropertyName.orthotropic.count].text = String(format: "%.2f", value)
                            } else {
                                laminaMaterialPropertiesTextField[i + materialPropertyName.orthotropic.count].text = ""
                            }
                        } else {
                            laminaMaterialPropertiesTextField[i + materialPropertyName.orthotropic.count].text = ""
                        }
                    }
                }
            } else if laminaMaterialType == .anisotropic {
                for i in 0 ... materialPropertyName.anisotropic.count - 1 {
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
                if analysisSettings.typeOfAnalysis == .thermoElastic {
                    for i in 0 ... materialPropertyName.anisotropicThermal.count - 1 {
                        if let valueDictionary = userSaveMaterial.properties as? [String: Double] {
                            if let value = valueDictionary[materialPropertyName.anisotropicThermal[i]] {
                                laminaMaterialPropertiesTextField[i + materialPropertyName.anisotropic.count].text = String(format: "%.2f", value)
                            } else {
                                laminaMaterialPropertiesTextField[i + materialPropertyName.anisotropic.count].text = ""
                            }
                        } else {
                            laminaMaterialPropertiesTextField[i + materialPropertyName.anisotropic.count].text = ""
                        }
                    }
                }
            }
            return
        }
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

    // get calculation parameters

    override func getCalculationParameters() -> GetParametersStatus {
        analysisSettings.compositeModelName = .Laminate

        (k12_plate, k21_plate) = (0.0, 0.0)
        layupSequence = [Double]()
        layerThickness = 0.0
        (e1, e2, e3, g12, g13, g23, nu12, nu13, nu23) = (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
        (c11, c12, c13, c14, c15, c16, c22, c23, c24, c25, c26, c33, c34, c35, c36, c44, c45, c46, c55, c56, c66) = (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
        (alpha11, alpha22, alpha33, alpha23, alpha13, alpha12) = (0.0, 0.0, 0.0, 0.0, 0.0, 0.0)

        if analysisSettings.calculationMethod == .SwiftComp && analysisSettings.structuralModel == .plate {
            guard let k12Guard = Double(plateInitialCurvaturesk12TextField.text!), let k21Guard = Double(plateInitialCurvaturesk21TextField.text!) else {
                return .wrongPlateInitialCurvatures
            }
            (k12_plate, k21_plate) = (k12Guard, k21Guard)
        }

        // create wrong alert controllers

        layupSequence = getlayupSequence(textFieldValue: stackingSequenceTextField.text ?? "")

        if layupSequence == [] {
            return .wrongStackingSequence
        }

        if analysisSettings.structuralModel == .plate {
            guard let tGuard = Double(laminaThicknessTextField.text!) else {
                return .wrongLayerThickness
            }
            if tGuard == 0.0 {
                return .wrongLayerThickness
            }
            layerThickness = tGuard
        } else {
            layerThickness = 1.0
        }

        // Handle material and calculate

        if laminaMaterialType == .transverselyIsotropic {
            guard let e1Guard = Double(laminaMaterialPropertiesTextField[0].text!), let e2Guard = Double(laminaMaterialPropertiesTextField[1].text!), let g12Guard = Double(laminaMaterialPropertiesTextField[2].text!), let nu12Guard = Double(laminaMaterialPropertiesTextField[3].text!), let nu23Guard = Double(laminaMaterialPropertiesTextField[4].text!) else {
                return .wrongMaterialValue
            }

            if nu23Guard == -1.0 {
                return .wrongNuValue
            }

            let e3Guard = e2Guard
            let g13Guard = g12Guard
            let g23Guard = e2Guard / (2 * (1 + nu23Guard))
            let nu13Guard = nu12Guard

            (e1, e2, e3, g12, g13, g23, nu12, nu13, nu23) = (e1Guard, e2Guard, e3Guard, g12Guard, g13Guard, g23Guard, nu12Guard, nu13Guard, nu23Guard)

            if analysisSettings.typeOfAnalysis == .thermoElastic {
                guard let alpha11Guard = Double(laminaMaterialPropertiesTextField[5].text!), let alpha22Guard = Double(laminaMaterialPropertiesTextField[6].text!) else {
                    return .wrongCTEValue
                }
                (alpha11, alpha22, alpha33, alpha23, alpha13, alpha12) = (alpha11Guard, alpha22Guard, alpha22Guard, 0, 0, 0)
            }

        } else if laminaMaterialType == .orthotropic {
            guard let e1Guard = Double(laminaMaterialPropertiesTextField[0].text!), let e2Guard = Double(laminaMaterialPropertiesTextField[1].text!), let e3Guard = Double(laminaMaterialPropertiesTextField[2].text!), let g12Guard = Double(laminaMaterialPropertiesTextField[3].text!), let g13Guard = Double(laminaMaterialPropertiesTextField[4].text!), let g23Guard = Double(laminaMaterialPropertiesTextField[5].text!), let nu12Guard = Double(laminaMaterialPropertiesTextField[6].text!), let nu13Guard = Double(laminaMaterialPropertiesTextField[7].text!), let nu23Guard = Double(laminaMaterialPropertiesTextField[8].text!) else {
                return .wrongMaterialValue
            }

            (e1, e2, e3, g12, g13, g23, nu12, nu13, nu23) = (e1Guard, e2Guard, e3Guard, g12Guard, g13Guard, g23Guard, nu12Guard, nu13Guard, nu23Guard)

            if analysisSettings.typeOfAnalysis == .thermoElastic {
                guard let alpha11Guard = Double(laminaMaterialPropertiesTextField[9].text!), let alpha22Guard = Double(laminaMaterialPropertiesTextField[10].text!), let alpha33Guard = Double(laminaMaterialPropertiesTextField[11].text!) else {
                    return .wrongCTEValue
                }
                (alpha11, alpha22, alpha33, alpha23, alpha13, alpha12) = (alpha11Guard, alpha22Guard, alpha33Guard, 0, 0, 0)
            }

        } else if laminaMaterialType == .anisotropic {
            guard let c11Guard = Double(laminaMaterialPropertiesTextField[0].text!), let c12Guard = Double(laminaMaterialPropertiesTextField[1].text!), let c13Guard = Double(laminaMaterialPropertiesTextField[2].text!), let c14Guard = Double(laminaMaterialPropertiesTextField[3].text!), let c15Guard = Double(laminaMaterialPropertiesTextField[4].text!), let c16Guard = Double(laminaMaterialPropertiesTextField[5].text!), let c22Guard = Double(laminaMaterialPropertiesTextField[6].text!), let c23Guard = Double(laminaMaterialPropertiesTextField[7].text!), let c24Guard = Double(laminaMaterialPropertiesTextField[8].text!), let c25Guard = Double(laminaMaterialPropertiesTextField[9].text!), let c26Guard = Double(laminaMaterialPropertiesTextField[10].text!), let c33Guard = Double(laminaMaterialPropertiesTextField[11].text!), let c34Guard = Double(laminaMaterialPropertiesTextField[12].text!), let c35Guard = Double(laminaMaterialPropertiesTextField[13].text!), let c36Guard = Double(laminaMaterialPropertiesTextField[14].text!), let c44Guard = Double(laminaMaterialPropertiesTextField[15].text!), let c45Guard = Double(laminaMaterialPropertiesTextField[16].text!), let c46Guard = Double(laminaMaterialPropertiesTextField[17].text!), let c55Guard = Double(laminaMaterialPropertiesTextField[18].text!), let c56Guard = Double(laminaMaterialPropertiesTextField[19].text!), let c66Guard = Double(laminaMaterialPropertiesTextField[20].text!) else {
                return .wrongMaterialValue
            }

            (c11, c12, c13, c14, c15, c16, c22, c23, c24, c25, c26, c33, c34, c35, c36, c44, c45, c46, c55, c56, c66) = (c11Guard, c12Guard, c13Guard, c14Guard, c15Guard, c16Guard, c22Guard, c23Guard, c24Guard, c25Guard, c26Guard, c33Guard, c34Guard, c35Guard, c36Guard, c44Guard, c45Guard, c46Guard, c55Guard, c56Guard, c66Guard)

            if analysisSettings.typeOfAnalysis == .thermoElastic {
                guard let alpha11Guard = Double(laminaMaterialPropertiesTextField[21].text!), let alpha22Guard = Double(laminaMaterialPropertiesTextField[22].text!), let alpha33Guard = Double(laminaMaterialPropertiesTextField[23].text!), let alpha23Guard = Double(laminaMaterialPropertiesTextField[24].text!), let alpha13Guard = Double(laminaMaterialPropertiesTextField[25].text!), let alpha12Guard = Double(laminaMaterialPropertiesTextField[26].text!) else {
                    return .wrongCTEValue
                }

                (alpha11, alpha22, alpha33, alpha23, alpha13, alpha12) = (alpha11Guard, alpha22Guard, alpha33Guard, alpha23Guard, alpha13Guard, alpha12Guard)
            }
        }

        return .noError
    }

    // calculate result by CLPT

    override func calculationResultByNonSwiftComp() {
        var bzi = [Double]()
        let nPly = layupSequence.count

        for i in 1 ... nPly {
            bzi.append((-Double(nPly + 1) * layerThickness) / 2 + Double(i) * layerThickness)
        }

        var Cp: [Double] = []
        var Qep: [Double] = []

        if laminaMaterialType != .anisotropic {
            let Sp: [Double] = [1 / e1, -nu12 / e1, -nu13 / e1, 0, 0, 0, -nu12 / e1, 1 / e2, -nu23 / e2, 0, 0, 0, -nu13 / e1, -nu23 / e2, 1 / e3, 0, 0, 0, 0, 0, 0, 1 / g23, 0, 0, 0, 0, 0, 0, 1 / g13, 0, 0, 0, 0, 0, 0, 1 / g12]
            Cp = invert(matrix: Sp)
            let Sep: [Double] = [1 / e1, -nu12 / e1, 0, -nu12 / e1, 1 / e2, 0, 0, 0, 1 / g12]
            Qep = invert(matrix: Sep)

        } else {
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
        for i in 1 ... nPly {
            // Set up
            let c = cos(layupSequence[i - 1] * Double.pi / 180)
            let s = sin(layupSequence[i - 1] * Double.pi / 180)
            let Rsigma = [c * c, s * s, 0, 0, 0, -2 * s * c, s * s, c * c, 0, 0, 0, 2 * s * c, 0, 0, 1, 0, 0, 0, 0, 0, 0, c, s, 0, 0, 0, 0, -s, c, 0, s * c, -s * c, 0, 0, 0, c * c - s * s]
            var RsigmaT = [Double](repeating: 0.0, count: 36)
            vDSP_mtransD(Rsigma, 1, &RsigmaT, 1, 6, 6)

            var C = [Double](repeating: 0.0, count: 36)
            var temp1 = [Double](repeating: 0.0, count: 36)
            vDSP_mmulD(Rsigma, 1, Cp, 1, &temp1, 1, 6, 6, 6)
            vDSP_mmulD(temp1, 1, RsigmaT, 1, &C, 1, 6, 6, 6)

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
            vDSP_mmulD(Cet, 1, CtI, 1, &temp2, 1, 3, 3, 3)
            vDSP_mmulD(temp2, 1, CetT, 1, &temp3, 1, 3, 3, 3)
            vDSP_vsubD(temp3, 1, Ce, 1, &Q, 1, 9)

            // Get tempCts, Qs, tempCets
            vDSP_vaddD(Qs, 1, Q, 1, &Qs, 1, 9)
            vDSP_vaddD(tempCts, 1, CtI, 1, &tempCts, 1, 9)
            var temp4 = [Double](repeating: 0.0, count: 9)
            vDSP_mmulD(Cet, 1, CtI, 1, &temp4, 1, 3, 3, 3)
            vDSP_vaddD(tempCets, 1, temp4, 1, &tempCets, 1, 9)
        }

        // Get average tempCts, Qs, tempCets
        var nPlyD = Double(nPly)
        vDSP_vsdivD(Qs, 1, &nPlyD, &Qs, 1, 9)
        vDSP_vsdivD(tempCts, 1, &nPlyD, &tempCts, 1, 9)
        vDSP_vsdivD(tempCets, 1, &nPlyD, &tempCets, 1, 9)

        // Get Cts, Cets, Cet
        Cts = invert(matrix: tempCts)
        vDSP_mmulD(tempCets, 1, Cts, 1, &Cets, 1, 3, 3, 3)
        let CtsI = invert(matrix: Cts)
        var CetsT = [Double](repeating: 0.0, count: 9)
        vDSP_mtransD(Cets, 1, &CetsT, 1, 3, 3)
        var temp7 = [Double](repeating: 0.0, count: 9)
        vDSP_mmulD(Cets, 1, CtsI, 1, &temp7, 1, 3, 3, 3)
        var temp8 = [Double](repeating: 0.0, count: 9)
        vDSP_mmulD(temp7, 1, CetsT, 1, &temp8, 1, 3, 3, 3)
        vDSP_vaddD(Qs, 1, temp8, 1, &Ces, 1, 9)

        // Get Cs
        let Cs = [Ces[0], Ces[1], Cets[0], Cets[1], Cets[2], Ces[2], Ces[3], Ces[4], Cets[3], Cets[4], Cets[5], Ces[5], Cets[0], Cets[3], Cts[0], Cts[1], Cts[2], Cets[6], Cets[1], Cets[4], Cts[1], Cts[4], Cts[7], Cets[7], Cets[2], Cets[5], Cts[2], Cts[5], Cts[8], Cets[8], Ces[6], Ces[7], Cets[6], Cets[7], Cets[8], Ces[8]]

        let Ss = invert(matrix: Cs)

        // effective solid stiffness

        resultData.effectiveSolidStiffnessMatrix = Cs

        // engineering constants

        resultData.engineeringConstantsOrthotropic[0] = 1 / Ss[0]
        resultData.engineeringConstantsOrthotropic[1] = 1 / Ss[7]
        resultData.engineeringConstantsOrthotropic[2] = 1 / Ss[14]
        resultData.engineeringConstantsOrthotropic[3] = 1 / Ss[35]
        resultData.engineeringConstantsOrthotropic[4] = 1 / Ss[28]
        resultData.engineeringConstantsOrthotropic[5] = 1 / Ss[21]
        resultData.engineeringConstantsOrthotropic[6] = -1 / Ss[0] * Ss[1]
        resultData.engineeringConstantsOrthotropic[7] = -1 / Ss[0] * Ss[2]
        resultData.engineeringConstantsOrthotropic[8] = -1 / Ss[7] * Ss[8]

        // Calculate A, B, and D matrices

        var A = [Double](repeating: 0.0, count: 9)
        var B = [Double](repeating: 0.0, count: 9)
        var D = [Double](repeating: 0.0, count: 9)

        for i in 1 ... nPly {
            let c = cos(layupSequence[i - 1] * Double.pi / 180)
            let s = sin(layupSequence[i - 1] * Double.pi / 180)
            let Rsigmae = [c * c, s * s, -2 * s * c, s * s, c * c, 2 * s * c, s * c, -s * c, c * c - s * s]
            var RsigmaeT = [Double](repeating: 0.0, count: 9)
            vDSP_mtransD(Rsigmae, 1, &RsigmaeT, 1, 3, 3)

            var Qe = [Double](repeating: 0.0, count: 9)
            var Atemp = [Double](repeating: 0.0, count: 9)
            var Btemp = [Double](repeating: 0.0, count: 9)
            var Dtemp = [Double](repeating: 0.0, count: 9)

            var temp1 = [Double](repeating: 0.0, count: 9)
            vDSP_mmulD(Rsigmae, 1, Qep, 1, &temp1, 1, 3, 3, 3)
            vDSP_mmulD(temp1, 1, RsigmaeT, 1, &Qe, 1, 3, 3, 3)

            vDSP_vsmulD(Qe, 1, &layerThickness, &Atemp, 1, 9)

            var temp2 = bzi[i - 1] * layerThickness
            vDSP_vsmulD(Qe, 1, &temp2, &Btemp, 1, 9)

            var temp3 = layerThickness * bzi[i - 1] * bzi[i - 1] + pow(layerThickness, 3.0) / 12
            vDSP_vsmulD(Qe, 1, &temp3, &Dtemp, 1, 9)

            vDSP_vaddD(A, 1, Atemp, 1, &A, 1, 9)
            vDSP_vaddD(B, 1, Btemp, 1, &B, 1, 9)
            vDSP_vaddD(D, 1, Dtemp, 1, &D, 1, 9)
        }

        let ABD = [A[0], A[1], A[2], B[0], B[1], B[2], A[3], A[4], A[5], B[3], B[4], B[5], A[6], A[7], A[8], B[6], B[7], B[8], B[0], B[3], B[6], D[0], D[1], D[2], B[1], B[4], B[7], D[3], D[4], D[5], B[2], B[5], B[8], D[6], D[7], D[8]]

        let abd = invert(matrix: ABD)

        var h = nPlyD * layerThickness

        let AI = [abd[0], abd[1], abd[2], abd[6], abd[7], abd[8], abd[12], abd[13], abd[14]]

        let DI = [abd[21], abd[22], abd[23], abd[27], abd[28], abd[29], abd[33], abd[34], abd[35]]

        var Ses = [Double](repeating: 0.0, count: 9)
        vDSP_vsmulD(AI, 1, &h, &Ses, 1, 9)

        var Sesf = [Double](repeating: 0.0, count: 9)
        var temph = pow(h, 3.0) / 12.0
        vDSP_vsmulD(DI, 1, &temph, &Sesf, 1, 9)

        resultData.AMatrix = A
        resultData.BMatrix = B
        resultData.DMatrix = D

        resultData.effectiveInplaneProperties[0] = 1 / Ses[0]
        resultData.effectiveInplaneProperties[1] = 1 / Ses[4]
        resultData.effectiveInplaneProperties[2] = 1 / Ses[8]
        resultData.effectiveInplaneProperties[3] = -1 / Ses[0] * Ses[1]
        resultData.effectiveInplaneProperties[4] = 1 / Ses[8] * Ses[2]
        resultData.effectiveInplaneProperties[5] = 1 / Ses[8] * Ses[5]

        resultData.effectiveFlexuralProperties[0] = 1 / Sesf[0]
        resultData.effectiveFlexuralProperties[1] = 1 / Sesf[4]
        resultData.effectiveFlexuralProperties[2] = 1 / Sesf[8]
        resultData.effectiveFlexuralProperties[3] = -1 / Sesf[0] * Sesf[1]
        resultData.effectiveFlexuralProperties[4] = 1 / Sesf[8] * Sesf[2]
        resultData.effectiveFlexuralProperties[5] = 1 / Sesf[8] * Sesf[5]

        if analysisSettings.typeOfAnalysis == .thermoElastic {
            let alphap: [Double] = [alpha11, alpha22, alpha33, alpha23, alpha13, alpha12]

            var tempalphaes = [Double](repeating: 0.0, count: 3)
            var tempalphats = [Double](repeating: 0.0, count: 3)

            var tempCts = [Double](repeating: 0.0, count: 9)
            var tempCets = [Double](repeating: 0.0, count: 9)
            var Qs = [Double](repeating: 0.0, count: 9)
            var Cts = [Double](repeating: 0.0, count: 9)
            var Cets = [Double](repeating: 0.0, count: 9)
            var Ces = [Double](repeating: 0.0, count: 9)

            // Calculate effective 3D properties
            for i in 1 ... nPly {
                // Set up
                let c = cos(layupSequence[i - 1] * Double.pi / 180)
                let s = sin(layupSequence[i - 1] * Double.pi / 180)
                let Rsigma = [c * c, s * s, 0, 0, 0, -2 * s * c, s * s, c * c, 0, 0, 0, 2 * s * c, 0, 0, 1, 0, 0, 0, 0, 0, 0, c, s, 0, 0, 0, 0, -s, c, 0, s * c, -s * c, 0, 0, 0, c * c - s * s]
                var RsigmaT = [Double](repeating: 0.0, count: 36)
                vDSP_mtransD(Rsigma, 1, &RsigmaT, 1, 6, 6)
                let Repsilon = invert(matrix: RsigmaT)

                var C = [Double](repeating: 0.0, count: 36)
                var temp1 = [Double](repeating: 0.0, count: 36)
                vDSP_mmulD(Rsigma, 1, Cp, 1, &temp1, 1, 6, 6, 6)
                vDSP_mmulD(temp1, 1, RsigmaT, 1, &C, 1, 6, 6, 6)

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
                vDSP_mmulD(Cet, 1, CtI, 1, &temp2, 1, 3, 3, 3)
                vDSP_mmulD(temp2, 1, CetT, 1, &temp3, 1, 3, 3, 3)
                vDSP_vsubD(temp3, 1, Ce, 1, &Q, 1, 9)

                // Get tempCts, Qs, tempCets
                vDSP_vaddD(Qs, 1, Q, 1, &Qs, 1, 9)
                vDSP_vaddD(tempCts, 1, CtI, 1, &tempCts, 1, 9)
                var temp4 = [Double](repeating: 0.0, count: 9)
                vDSP_mmulD(Cet, 1, CtI, 1, &temp4, 1, 3, 3, 3)
                vDSP_vaddD(tempCets, 1, temp4, 1, &tempCets, 1, 9)

                // Get alphaes

                var alpha = [Double](repeating: 0.0, count: 6)
                vDSP_mmulD(Repsilon, 1, alphap, 1, &alpha, 1, 6, 1, 6)

                let alphae = [alpha[0], alpha[1], alpha[5]]
                let alphat = [alpha[2], alpha[3], alpha[4]]

                // Get tempalphate, tempalphats
                var temp5 = [Double](repeating: 0.0, count: 3)
                vDSP_mmulD(Q, 1, alphae, 1, &temp5, 1, 3, 1, 3)
                vDSP_vaddD(tempalphaes, 1, temp5, 1, &tempalphaes, 1, 3)

                vDSP_mmulD(CtI, 1, CetT, 1, &temp2, 1, 3, 3, 3)
                vDSP_mmulD(temp2, 1, alphae, 1, &temp5, 1, 3, 1, 3)

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
            vDSP_mmulD(tempCets, 1, Cts, 1, &Cets, 1, 3, 3, 3)
            let CtsI = invert(matrix: Cts)
            var CetsT = [Double](repeating: 0.0, count: 9)
            vDSP_mtransD(Cets, 1, &CetsT, 1, 3, 3)
            var temp7 = [Double](repeating: 0.0, count: 9)
            vDSP_mmulD(Cets, 1, CtsI, 1, &temp7, 1, 3, 3, 3)
            var temp8 = [Double](repeating: 0.0, count: 9)
            vDSP_mmulD(temp7, 1, CetsT, 1, &temp8, 1, 3, 3, 3)
            vDSP_vaddD(Qs, 1, temp8, 1, &Ces, 1, 9)

            // Get alphaes, alphats
            vDSP_vsdivD(tempalphaes, 1, &nPlyD, &tempalphaes, 1, 3)
            vDSP_vsdivD(tempalphats, 1, &nPlyD, &tempalphats, 1, 3)

            let QsI = invert(matrix: Qs)
            var alphaes = [Double](repeating: 0.0, count: 3)
            vDSP_mmulD(QsI, 1, tempalphaes, 1, &alphaes, 1, 3, 1, 3)

            var alphats = [Double](repeating: 0.0, count: 3)
            var temp9 = [Double](repeating: 0.0, count: 9)
            var temp10 = [Double](repeating: 0.0, count: 3)
            vDSP_mmulD(CtsI, 1, CetsT, 1, &temp9, 1, 3, 3, 3)
            vDSP_mmulD(temp9, 1, alphaes, 1, &temp10, 1, 3, 1, 3)
            vDSP_vsubD(temp10, 1, tempalphats, 1, &alphats, 1, 3)

            resultData.effectiveThermalCoefficients[0] = alphaes[0]
            resultData.effectiveThermalCoefficients[1] = alphaes[1]
            resultData.effectiveThermalCoefficients[2] = alphats[0]
            resultData.effectiveThermalCoefficients[3] = alphats[1] / 2
            resultData.effectiveThermalCoefficients[4] = alphats[2] / 2
            resultData.effectiveThermalCoefficients[5] = alphaes[2] / 2
        }
    }

    // calculate result by SwiftComp

    override func calculateResultBySwiftComp() -> swiftcompCalculationStatus {
        var typeOfAnalysisValue: String = "Elastic"
        var structuralModelValue: String = "Plate"
        var structuralSubmodelValue: String = "KirchhoffLovePlateShellModel"
        var stackingSequenceValue: String = ""
        var laminaMaterialTypeValue: String = "Orthotropic"
        var materialPropertiesValue: String = ""

        if analysisSettings.typeOfAnalysis == .elastic {
            typeOfAnalysisValue = "Elastic"
        } else if analysisSettings.typeOfAnalysis == .thermoElastic {
            typeOfAnalysisValue = "Thermoelastic"
        }

        if analysisSettings.structuralModel == .plate {
            structuralModelValue = "Plate"
        } else if analysisSettings.structuralModel == .solid {
            structuralModelValue = "Solid"
        }

        API_URL = "\(Constant.baseURL)/Laminate/homogenization?typeOfAnalysis=\(typeOfAnalysisValue)&structuralModel=\(structuralModelValue)"

        if analysisSettings.structuralModel == .plate {
            if analysisSettings.structuralSubmodel == .KirchhoffLovePlateShellModel {
                structuralSubmodelValue = "KirchhoffLovePlateShellModel"
            } else if analysisSettings.structuralSubmodel == .ReissnerMindlinPlateShellModel {
                structuralSubmodelValue = "ReissnerMindlinPlateShellModel"
            }

            API_URL += "&structuralSubmodel=\(structuralSubmodelValue)&k12_plate=\(k12_plate)&k21_plate=\(k21_plate)"
        }

        layupSequence.forEach { angle in
            stackingSequenceValue.append(String(angle) + " ")
        }

        _ = stackingSequenceValue.popLast()

        API_URL += "&stackingSequence=\(stackingSequenceValue)&layerThickness=\(layerThickness)"

        if laminaMaterialType != .anisotropic {
            laminaMaterialTypeValue = "Orthotropic"

            materialPropertiesValue = "E1=\(e1)&E2=\(e2)&E3=\(e3)&G12=\(g12)&G13=\(g13)&G23=\(g23)&nu12=\(nu12)&nu13=\(nu13)&nu23=\(nu23)"

        } else {
            laminaMaterialTypeValue = "Anisotropic"

            materialPropertiesValue = "C11=\(c11)&C12=\(c12)&C13=\(c13)&C14=\(c14)&C15=\(c15)&C16=\(c16)&C22=\(c22)&C23=\(c23)&C33=\(c23)&C24=\(c24)&C25=\(c25)&C26=\(c26)&C33=\(c33)&C34=\(c34)&C35=\(c35)&C36=\(c36)&C44=\(c44)&C45=\(c45)&C46=\(c46)&C55=\(c55)&C56=\(c56)&C66=\(c66)"
        }

        if analysisSettings.typeOfAnalysis == .thermoElastic {
            materialPropertiesValue += "&alpha11=\(alpha11)&alpha22=\(alpha22)&alpha33=\(alpha33)&alpha23=\(alpha23)&alpha13=\(alpha13)&alpha12=\(alpha12)"
        }

        API_URL += "&laminaMaterialType=\(laminaMaterialTypeValue)&\(materialPropertiesValue)"

        let group = DispatchGroup()

        group.enter()

        fetchSwiftCompHomogenizationResultJSON(API_URL: API_URL, timeoutIntervalForRequest: 10) { res in
            switch res {
            case let .success(result):

                self.resultData.swiftcompCwd = result.swiftcompCwd

                self.resultData.swiftcompCalculationInfo = result.swiftcompCalculationInfo

                if self.analysisSettings.structuralModel == .plate {
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

            case let .failure(swiftcompCalculationError):

                print("Failed to fetch courses:", swiftcompCalculationError.localizedDescription)

                self.swiftCompCalculationError = swiftcompCalculationError
            }

            group.leave()
        }

        group.wait()

        if swiftCompCalculationError == .networkError {
            return .networkError
        } else if swiftCompCalculationError == .parseJSONError {
            return .parseJSONError
        } else if swiftCompCalculationError == .timeOutError {
            return .timeOutError
        }

        return .success
    }
}

// MARK: - LaminateStackingSequenceDataBaseDelegate

extension LaminateControllerOld: LaminateStackingSequenceDataBaseDelegate {
    func userTypeStackingSequenceDataBase(stackingSequence: String) {
        stackingSequenceNameLabel.text = stackingSequence
        changeStackingSequenceDataField()
        generateLayupFigure()
    }
}

// MARK: - LaminateStackingSequenceDataBaseDelegate

extension LaminateControllerOld: LaminateMaterialDataBaseDelegate {
    func userTypeLaminaMaterialDataBase(materialName: String) {
        laminaMaterialNameLabel.text = materialName
        determineLaminaMaterialType()
        changeLaminaMaterialType()
        changeMaterialDataField()
    }
}
