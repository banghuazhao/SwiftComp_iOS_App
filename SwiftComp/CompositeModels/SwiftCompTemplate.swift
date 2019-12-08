//
//  SwiftCompTemplateViewController.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 9/14/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import UIKit

class SwiftCompTemplateViewController: UIViewController, UINavigationControllerDelegate {
    var calculationButton = SCCalculateButton()

    // Global variables

    var API_URL = ""
    var swiftcompCalculationStatus: swiftcompCalculationStatus = .notStart
    var swiftCompCalculationError: swiftcompCalculationError = .noError

    // Data

    var analysisSettings = AnalysisSettings(compositeModelName: .Laminate, calculationMethod: .SwiftComp, typeOfAnalysis: .elastic, structuralModel: .solid, structuralSubmodel: .KirchhoffLovePlateShellModel)
    var (k12_plate, k21_plate) = (0.0, 0.0)
    var (k11_beam, k12_beam, k13_beam) = (0.0, 0.0, 0.0)
    var (cos_angle1, cos_angle2) = (1.0, 0.0)

    var resultData = ResultData()

    // layout

    var scrollView: UIScrollView = UIScrollView()

    // Method

    var methodView: UIView = UIView()
    var methodLabelButton: UIButton = UIButton()
    var methodDataBaseAlterController: UIAlertController!

    // structrual model

    var structuralModelView: UIView = UIView()
    var structuralModelLabelButton: UIButton = UIButton()
    var structuralModelDataBaseAlterController: UIAlertController!
    var structuralModelDataBaseAlterControllerNonSwiftComp: UIAlertController!

    // submodel: beam

    var beamSubmodelView: UIView = UIView()
    var beamSubmodelLabelButton: UIButton = UIButton()
    var beamSubmodelDataBaseAlterController: UIAlertController!
    var beamSubmodelDataBaseAlterControllerNonSwiftComp: UIAlertController!

    var beamInitialTwistCurvaturesView: UIView = UIView()
    var beamInitialTwistCurvaturesk11Label: UILabel = UILabel()
    var beamInitialTwistCurvaturesk11TextField: UITextField = UITextField()
    var beamInitialTwistCurvaturesk12Label: UILabel = UILabel()
    var beamInitialTwistCurvaturesk12TextField: UITextField = UITextField()
    var beamInitialTwistCurvaturesk13Label: UILabel = UILabel()
    var beamInitialTwistCurvaturesk13TextField: UITextField = UITextField()

    var beamObliqueCrossSectionView: UIView = UIView()
    var beamObliqueCrossSectionCosAngle1Label: UILabel = UILabel()
    var beamObliqueCrossSectionCosAngle1TextField: UITextField = UITextField()
    var beamObliqueCrossSectionCosAngle2Label: UILabel = UILabel()
    var beamObliqueCrossSectionCosAngle2TextField: UITextField = UITextField()

    // submodel: plate

    var plateSubmodelView: UIView = UIView()
    var plateSubmodelLabelButton: UIButton = UIButton()
    var plateSubmodelDataBaseAlterController: UIAlertController!
    var plateSubmodelDataBaseAlterControllerNonSwiftComp: UIAlertController!

    var plateInitialCurvaturesView: UIView = UIView()
    var plateInitialCurvaturesk12Label: UILabel = UILabel()
    var plateInitialCurvaturesk12TextField: UITextField = UITextField()
    var plateInitialCurvaturesk21Label: UILabel = UILabel()
    var plateInitialCurvaturesk21TextField: UITextField = UITextField()

    // Type of Analysis

    var typeOfAnalysisView: UIView = UIView()
    var typeOfAnalysisLabelButton: UIButton = UIButton()
    var typeOfAnalysisDataBaseAlterController: UIAlertController!
    var typeOfAnalysisDataBaseAlterControllerBeam: UIAlertController!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .greybackgroundColor

        navigationItem.title = "SwiftComp Template"

        navigationController?.delegate = self

        createLayout()

        createActionSheet()

        setupNetworkManager()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        editToolBar()
    }

    deinit {
        print("Composite model view controller deinit succeed!")
    }

    // MARK: Create layout

    func createLayout() {
        hideKeyboardWhenTappedAround()

        editToolBar()

        view.addSubview(scrollView)

        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        scrollView.addSubviews(methodView, structuralModelView, typeOfAnalysisView)

        // method

        var methodQuestionButton = UIButton()

        createViewCardWithTitleHelpButtonMethodButton(viewCard: methodView, title: "Method", helpButton: &methodQuestionButton, methodButton: &methodLabelButton, isSingleMethodButton: true, aboveConstraint: scrollView.topAnchor, under: scrollView)

        methodQuestionButton.addTarget(self, action: #selector(methodQuestionExplain), for: .touchUpInside)

        methodLabelButton.setTitle("SwiftComp", for: UIControl.State.normal)
        methodLabelButton.addTarget(self, action: #selector(changeMethodLabel), for: .touchUpInside)

        // Structural Model

        var structuralModelQuestionButton: UIButton = UIButton()

        createViewCardWithTitleHelpButtonMethodButton(viewCard: structuralModelView, title: "Structural Model", helpButton: &structuralModelQuestionButton, methodButton: &structuralModelLabelButton, isSingleMethodButton: false, aboveConstraint: methodView.bottomAnchor, under: scrollView)

        structuralModelQuestionButton.addTarget(self, action: #selector(structuralModelQuestionExplain), for: .touchUpInside)

        structuralModelLabelButton.setTitle("Solid Model", for: UIControl.State.normal)
        structuralModelLabelButton.addTarget(self, action: #selector(changeStructuralModelLabel), for: .touchUpInside)
        structuralModelLabelButton.bottomAnchor.constraint(equalTo: structuralModelView.bottomAnchor, constant: -12).isActive = true

        structuralModelView.addSubview(beamSubmodelView)
        structuralModelView.addSubview(plateSubmodelView)

        // submodel beam

        var beamSubmodelQuestionButton: UIButton = UIButton()

        createSubviewCardWithDividerTitleHelpButtonMethodButton(viewCard: beamSubmodelView, title: "Beam Submodel", helpButton: &beamSubmodelQuestionButton, methodButton: &beamSubmodelLabelButton, isSingleMethodButton: false, aboveConstraint: structuralModelLabelButton.bottomAnchor, under: structuralModelView)

        beamSubmodelQuestionButton.addTarget(self, action: #selector(beamSubmodelQuestionExplain), for: .touchUpInside)

        beamSubmodelLabelButton.setTitle("Euler-Bernoulli Model", for: UIControl.State.normal)
        beamSubmodelLabelButton.addTarget(self, action: #selector(changeBeamSubmodelLabel), for: .touchUpInside)
        beamSubmodelLabelButton.bottomAnchor.constraint(equalTo: beamSubmodelView.bottomAnchor, constant: 0).isActive = true

        beamSubmodelView.isHidden = true

        // beam initial twist curvatures

        structuralModelView.addSubview(beamInitialTwistCurvaturesView)

        var beamInitialTwistCurvaturesQuestionButton: UIButton = UIButton()

        createSubviewCardWithDividerTitleHelpButton(viewCard: beamInitialTwistCurvaturesView, title: "Beam Initial Twist/Curvatures", helpButton: &beamInitialTwistCurvaturesQuestionButton, aboveConstraint: beamSubmodelLabelButton.bottomAnchor, under: structuralModelView)

        beamInitialTwistCurvaturesQuestionButton.addTarget(self, action: #selector(beamInitialTwistCurvaturesQuestionExplain), for: .touchUpInside)

        beamInitialTwistCurvaturesView.addSubview(beamInitialTwistCurvaturesk11Label)
        beamInitialTwistCurvaturesView.addSubview(beamInitialTwistCurvaturesk11TextField)
        beamInitialTwistCurvaturesView.addSubview(beamInitialTwistCurvaturesk12Label)
        beamInitialTwistCurvaturesView.addSubview(beamInitialTwistCurvaturesk12TextField)
        beamInitialTwistCurvaturesView.addSubview(beamInitialTwistCurvaturesk13Label)
        beamInitialTwistCurvaturesView.addSubview(beamInitialTwistCurvaturesk13TextField)

        beamInitialTwistCurvaturesk11Label.translatesAutoresizingMaskIntoConstraints = false
        beamInitialTwistCurvaturesk11Label.text = "k11"
        beamInitialTwistCurvaturesk11Label.font = UIFont.systemFont(ofSize: 12)
        beamInitialTwistCurvaturesk11Label.topAnchor.constraint(equalTo: beamInitialTwistCurvaturesView.topAnchor, constant: 38).isActive = true
        beamInitialTwistCurvaturesk11Label.heightAnchor.constraint(equalToConstant: 25).isActive = true
        beamInitialTwistCurvaturesk11Label.centerXAnchor.constraint(equalTo: structuralModelView.centerXAnchor, constant: -125).isActive = true
        beamInitialTwistCurvaturesk11Label.widthAnchor.constraint(equalToConstant: 20).isActive = true

        beamInitialTwistCurvaturesk11TextField.translatesAutoresizingMaskIntoConstraints = false
        beamInitialTwistCurvaturesk11TextField.placeholder = "k11"
        beamInitialTwistCurvaturesk11TextField.text = "0.0"
        beamInitialTwistCurvaturesk11TextField.keyboardType = UIKeyboardType.numbersAndPunctuation
        beamInitialTwistCurvaturesk11TextField.borderStyle = .roundedRect
        beamInitialTwistCurvaturesk11TextField.font = UIFont.systemFont(ofSize: 12)
        beamInitialTwistCurvaturesk11TextField.heightAnchor.constraint(equalToConstant: 25).isActive = true
        beamInitialTwistCurvaturesk11TextField.centerYAnchor.constraint(equalTo: beamInitialTwistCurvaturesk11Label.centerYAnchor).isActive = true
        beamInitialTwistCurvaturesk11TextField.centerXAnchor.constraint(equalTo: structuralModelView.centerXAnchor, constant: -80).isActive = true
        beamInitialTwistCurvaturesk11TextField.widthAnchor.constraint(equalToConstant: 60).isActive = true

        beamInitialTwistCurvaturesk12Label.translatesAutoresizingMaskIntoConstraints = false
        beamInitialTwistCurvaturesk12Label.text = "k12"
        beamInitialTwistCurvaturesk12Label.font = UIFont.systemFont(ofSize: 12)
        beamInitialTwistCurvaturesk12Label.topAnchor.constraint(equalTo: beamInitialTwistCurvaturesk11Label.topAnchor).isActive = true
        beamInitialTwistCurvaturesk12Label.heightAnchor.constraint(equalToConstant: 25).isActive = true
        beamInitialTwistCurvaturesk12Label.centerXAnchor.constraint(equalTo: structuralModelView.centerXAnchor, constant: -30).isActive = true
        beamInitialTwistCurvaturesk12Label.widthAnchor.constraint(equalToConstant: 20).isActive = true

        beamInitialTwistCurvaturesk12TextField.translatesAutoresizingMaskIntoConstraints = false
        beamInitialTwistCurvaturesk12TextField.placeholder = "k12"
        beamInitialTwistCurvaturesk12TextField.text = "0.0"
        beamInitialTwistCurvaturesk12TextField.keyboardType = UIKeyboardType.numbersAndPunctuation
        beamInitialTwistCurvaturesk12TextField.borderStyle = .roundedRect
        beamInitialTwistCurvaturesk12TextField.font = UIFont.systemFont(ofSize: 12)
        beamInitialTwistCurvaturesk12TextField.heightAnchor.constraint(equalToConstant: 25).isActive = true
        beamInitialTwistCurvaturesk12TextField.centerYAnchor.constraint(equalTo: beamInitialTwistCurvaturesk11Label.centerYAnchor).isActive = true
        beamInitialTwistCurvaturesk12TextField.centerXAnchor.constraint(equalTo: structuralModelView.centerXAnchor, constant: 15).isActive = true
        beamInitialTwistCurvaturesk12TextField.widthAnchor.constraint(equalToConstant: 60).isActive = true

        beamInitialTwistCurvaturesk13Label.translatesAutoresizingMaskIntoConstraints = false
        beamInitialTwistCurvaturesk13Label.text = "k13"
        beamInitialTwistCurvaturesk13Label.font = UIFont.systemFont(ofSize: 12)
        beamInitialTwistCurvaturesk13Label.topAnchor.constraint(equalTo: beamInitialTwistCurvaturesk11Label.topAnchor).isActive = true
        beamInitialTwistCurvaturesk13Label.heightAnchor.constraint(equalToConstant: 25).isActive = true
        beamInitialTwistCurvaturesk13Label.centerXAnchor.constraint(equalTo: structuralModelView.centerXAnchor, constant: 65).isActive = true
        beamInitialTwistCurvaturesk13Label.widthAnchor.constraint(equalToConstant: 20).isActive = true

        beamInitialTwistCurvaturesk13TextField.translatesAutoresizingMaskIntoConstraints = false
        beamInitialTwistCurvaturesk13TextField.placeholder = "k13"
        beamInitialTwistCurvaturesk13TextField.text = "0.0"
        beamInitialTwistCurvaturesk13TextField.keyboardType = UIKeyboardType.numbersAndPunctuation
        beamInitialTwistCurvaturesk13TextField.borderStyle = .roundedRect
        beamInitialTwistCurvaturesk13TextField.font = UIFont.systemFont(ofSize: 12)
        beamInitialTwistCurvaturesk13TextField.heightAnchor.constraint(equalToConstant: 25).isActive = true
        beamInitialTwistCurvaturesk13TextField.centerYAnchor.constraint(equalTo: beamInitialTwistCurvaturesk11Label.centerYAnchor).isActive = true
        beamInitialTwistCurvaturesk13TextField.centerXAnchor.constraint(equalTo: structuralModelView.centerXAnchor, constant: 110).isActive = true
        beamInitialTwistCurvaturesk13TextField.widthAnchor.constraint(equalToConstant: 60).isActive = true

        beamInitialTwistCurvaturesk13TextField.bottomAnchor.constraint(equalTo: beamInitialTwistCurvaturesView.bottomAnchor).isActive = true

        beamInitialTwistCurvaturesView.isHidden = true

        // beam oblique cross section

        structuralModelView.addSubview(beamObliqueCrossSectionView)

        var beamObliqueCrossSectionQuestionButton: UIButton = UIButton()

        createSubviewCardWithDividerTitleHelpButton(viewCard: beamObliqueCrossSectionView, title: "Beam Oblique Cross Section", helpButton: &beamObliqueCrossSectionQuestionButton, aboveConstraint: beamInitialTwistCurvaturesView.bottomAnchor, under: structuralModelView)

        beamObliqueCrossSectionQuestionButton.addTarget(self, action: #selector(beamObliqueCrossSectionQuestionExplain), for: .touchUpInside)

        beamObliqueCrossSectionView.addSubview(beamObliqueCrossSectionCosAngle1Label)
        beamObliqueCrossSectionView.addSubview(beamObliqueCrossSectionCosAngle1TextField)
        beamObliqueCrossSectionView.addSubview(beamObliqueCrossSectionCosAngle2Label)
        beamObliqueCrossSectionView.addSubview(beamObliqueCrossSectionCosAngle2TextField)

        beamObliqueCrossSectionCosAngle1Label.translatesAutoresizingMaskIntoConstraints = false
        beamObliqueCrossSectionCosAngle1Label.text = "cos(angle1)"
        beamObliqueCrossSectionCosAngle1Label.font = UIFont.systemFont(ofSize: 12)
        beamObliqueCrossSectionCosAngle1Label.topAnchor.constraint(equalTo: beamObliqueCrossSectionView.topAnchor, constant: 38).isActive = true
        beamObliqueCrossSectionCosAngle1Label.heightAnchor.constraint(equalToConstant: 25).isActive = true
        beamObliqueCrossSectionCosAngle1Label.centerXAnchor.constraint(equalTo: structuralModelView.centerXAnchor, constant: -105).isActive = true
        beamObliqueCrossSectionCosAngle1Label.widthAnchor.constraint(equalToConstant: 70).isActive = true

        beamObliqueCrossSectionCosAngle1TextField.translatesAutoresizingMaskIntoConstraints = false
        beamObliqueCrossSectionCosAngle1TextField.placeholder = "cos(angle1)"
        beamObliqueCrossSectionCosAngle1TextField.text = "1.0"
        beamObliqueCrossSectionCosAngle1TextField.keyboardType = UIKeyboardType.numbersAndPunctuation
        beamObliqueCrossSectionCosAngle1TextField.borderStyle = .roundedRect
        beamObliqueCrossSectionCosAngle1TextField.font = UIFont.systemFont(ofSize: 12)
        beamObliqueCrossSectionCosAngle1TextField.heightAnchor.constraint(equalToConstant: 25).isActive = true
        beamObliqueCrossSectionCosAngle1TextField.centerYAnchor.constraint(equalTo: beamObliqueCrossSectionCosAngle1Label.centerYAnchor).isActive = true
        beamObliqueCrossSectionCosAngle1TextField.centerXAnchor.constraint(equalTo: structuralModelView.centerXAnchor, constant: -38).isActive = true
        beamObliqueCrossSectionCosAngle1TextField.widthAnchor.constraint(equalToConstant: 60).isActive = true

        beamObliqueCrossSectionCosAngle2Label.translatesAutoresizingMaskIntoConstraints = false
        beamObliqueCrossSectionCosAngle2Label.text = "cos(angle2)"
        beamObliqueCrossSectionCosAngle2Label.font = UIFont.systemFont(ofSize: 12)
        beamObliqueCrossSectionCosAngle2Label.topAnchor.constraint(equalTo: beamObliqueCrossSectionCosAngle1Label.topAnchor).isActive = true
        beamObliqueCrossSectionCosAngle2Label.heightAnchor.constraint(equalToConstant: 25).isActive = true
        beamObliqueCrossSectionCosAngle2Label.centerXAnchor.constraint(equalTo: structuralModelView.centerXAnchor, constant: 43).isActive = true
        beamObliqueCrossSectionCosAngle2Label.widthAnchor.constraint(equalToConstant: 70).isActive = true

        beamObliqueCrossSectionCosAngle2TextField.translatesAutoresizingMaskIntoConstraints = false
        beamObliqueCrossSectionCosAngle2TextField.placeholder = "cos(angle2)"
        beamObliqueCrossSectionCosAngle2TextField.text = "0.0"
        beamObliqueCrossSectionCosAngle2TextField.keyboardType = UIKeyboardType.numbersAndPunctuation
        beamObliqueCrossSectionCosAngle2TextField.borderStyle = .roundedRect
        beamObliqueCrossSectionCosAngle2TextField.font = UIFont.systemFont(ofSize: 12)
        beamObliqueCrossSectionCosAngle2TextField.heightAnchor.constraint(equalToConstant: 25).isActive = true
        beamObliqueCrossSectionCosAngle2TextField.centerYAnchor.constraint(equalTo: beamObliqueCrossSectionCosAngle1Label.centerYAnchor).isActive = true
        beamObliqueCrossSectionCosAngle2TextField.centerXAnchor.constraint(equalTo: structuralModelView.centerXAnchor, constant: 110).isActive = true
        beamObliqueCrossSectionCosAngle2TextField.widthAnchor.constraint(equalToConstant: 60).isActive = true

        beamObliqueCrossSectionCosAngle2TextField.bottomAnchor.constraint(equalTo: beamObliqueCrossSectionView.bottomAnchor).isActive = true

        beamObliqueCrossSectionView.bottomAnchor.constraint(equalTo: structuralModelView.bottomAnchor, constant: -12).isActive = false

        beamObliqueCrossSectionView.isHidden = true

        // submodel plate

        var plateSubmodelQuestionButton: UIButton = UIButton()

        createSubviewCardWithDividerTitleHelpButtonMethodButton(viewCard: plateSubmodelView, title: "Plate Submodel", helpButton: &plateSubmodelQuestionButton, methodButton: &plateSubmodelLabelButton, isSingleMethodButton: false, aboveConstraint: structuralModelLabelButton.bottomAnchor, under: structuralModelView)

        plateSubmodelQuestionButton.addTarget(self, action: #selector(plateSubmodelQuestionExplain), for: .touchUpInside)

        plateSubmodelLabelButton.setTitle("Kirchho-Love Model", for: UIControl.State.normal)
        plateSubmodelLabelButton.addTarget(self, action: #selector(changePlateSubmodelLabel), for: .touchUpInside)
        plateSubmodelLabelButton.bottomAnchor.constraint(equalTo: plateSubmodelView.bottomAnchor, constant: 0).isActive = true

        plateSubmodelView.isHidden = true

        // plate initial curvatures

        structuralModelView.addSubview(plateInitialCurvaturesView)

        var plateInitialCurvaturesQuestionButton: UIButton = UIButton()

        createSubviewCardWithDividerTitleHelpButton(viewCard: plateInitialCurvaturesView, title: "Plate Initial Curvatures", helpButton: &plateInitialCurvaturesQuestionButton, aboveConstraint: plateSubmodelLabelButton.bottomAnchor, under: structuralModelView)

        plateInitialCurvaturesQuestionButton.addTarget(self, action: #selector(plateInitialCurvaturesQuestionExplain), for: .touchUpInside)

        plateInitialCurvaturesView.addSubview(plateInitialCurvaturesk12Label)
        plateInitialCurvaturesView.addSubview(plateInitialCurvaturesk12TextField)
        plateInitialCurvaturesView.addSubview(plateInitialCurvaturesk21Label)
        plateInitialCurvaturesView.addSubview(plateInitialCurvaturesk21TextField)

        plateInitialCurvaturesk12Label.translatesAutoresizingMaskIntoConstraints = false
        plateInitialCurvaturesk12Label.text = "k12"
        plateInitialCurvaturesk12Label.font = UIFont.systemFont(ofSize: 14)
        plateInitialCurvaturesk12Label.topAnchor.constraint(equalTo: plateInitialCurvaturesView.topAnchor, constant: 38).isActive = true
        plateInitialCurvaturesk12Label.heightAnchor.constraint(equalToConstant: 25).isActive = true
        plateInitialCurvaturesk12Label.centerXAnchor.constraint(equalTo: structuralModelView.centerXAnchor, constant: -105).isActive = true
        plateInitialCurvaturesk12Label.widthAnchor.constraint(equalToConstant: 40).isActive = true

        plateInitialCurvaturesk12TextField.translatesAutoresizingMaskIntoConstraints = false
        plateInitialCurvaturesk12TextField.placeholder = "k12"
        plateInitialCurvaturesk12TextField.text = "0.0"
        plateInitialCurvaturesk12TextField.keyboardType = UIKeyboardType.numbersAndPunctuation
        plateInitialCurvaturesk12TextField.borderStyle = .roundedRect
        plateInitialCurvaturesk12TextField.font = UIFont.systemFont(ofSize: 14)
        plateInitialCurvaturesk12TextField.heightAnchor.constraint(equalToConstant: 25).isActive = true
        plateInitialCurvaturesk12TextField.centerYAnchor.constraint(equalTo: plateInitialCurvaturesk12Label.centerYAnchor).isActive = true
        plateInitialCurvaturesk12TextField.centerXAnchor.constraint(equalTo: structuralModelView.centerXAnchor, constant: -50).isActive = true
        plateInitialCurvaturesk12TextField.widthAnchor.constraint(equalToConstant: 80).isActive = true

        plateInitialCurvaturesk21Label.translatesAutoresizingMaskIntoConstraints = false
        plateInitialCurvaturesk21Label.text = "k21"
        plateInitialCurvaturesk21Label.font = UIFont.systemFont(ofSize: 14)
        plateInitialCurvaturesk21Label.topAnchor.constraint(equalTo: plateInitialCurvaturesk12Label.topAnchor).isActive = true
        plateInitialCurvaturesk21Label.heightAnchor.constraint(equalToConstant: 25).isActive = true
        plateInitialCurvaturesk21Label.centerXAnchor.constraint(equalTo: structuralModelView.centerXAnchor, constant: 35).isActive = true
        plateInitialCurvaturesk21Label.widthAnchor.constraint(equalToConstant: 40).isActive = true

        plateInitialCurvaturesk21TextField.translatesAutoresizingMaskIntoConstraints = false
        plateInitialCurvaturesk21TextField.placeholder = "k21"
        plateInitialCurvaturesk21TextField.text = "0.0"
        plateInitialCurvaturesk21TextField.keyboardType = UIKeyboardType.numbersAndPunctuation
        plateInitialCurvaturesk21TextField.borderStyle = .roundedRect
        plateInitialCurvaturesk21TextField.font = UIFont.systemFont(ofSize: 14)
        plateInitialCurvaturesk21TextField.heightAnchor.constraint(equalToConstant: 25).isActive = true
        plateInitialCurvaturesk21TextField.centerYAnchor.constraint(equalTo: plateInitialCurvaturesk12Label.centerYAnchor).isActive = true
        plateInitialCurvaturesk21TextField.centerXAnchor.constraint(equalTo: structuralModelView.centerXAnchor, constant: 90).isActive = true
        plateInitialCurvaturesk21TextField.widthAnchor.constraint(equalToConstant: 80).isActive = true

        plateInitialCurvaturesk21TextField.bottomAnchor.constraint(equalTo: plateInitialCurvaturesView.bottomAnchor).isActive = true

        plateInitialCurvaturesView.bottomAnchor.constraint(equalTo: structuralModelView.bottomAnchor, constant: -12).isActive = false

        plateInitialCurvaturesView.isHidden = true

        // type of analysis

        var typeOfAnalysisQuestionButton: UIButton = UIButton()

        createViewCardWithTitleHelpButtonMethodButton(viewCard: typeOfAnalysisView, title: "Type of Analysis", helpButton: &typeOfAnalysisQuestionButton, methodButton: &typeOfAnalysisLabelButton, isSingleMethodButton: true, aboveConstraint: structuralModelView.bottomAnchor, under: scrollView)

        typeOfAnalysisQuestionButton.addTarget(self, action: #selector(typeOfAnalysisQuestionExplain), for: .touchUpInside)

        typeOfAnalysisLabelButton.setTitle("Elastic Analysis", for: UIControl.State.normal)
        typeOfAnalysisLabelButton.addTarget(self, action: #selector(changeTypeOfAnalysisLabel), for: .touchUpInside)

        typeOfAnalysisLabelButton.bottomAnchor.constraint(equalTo: typeOfAnalysisView.bottomAnchor, constant: -12).isActive = true

        typeOfAnalysisView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -40).isActive = true
    }

    // method section

    let methodExplain: ExplainBoxDesign = ExplainBoxDesign()
    @objc func methodQuestionExplain(_ sender: UIButton) {
        let explainDetialView: UIView = UIView()
        explainDetialView.explainDetialViewPureTextDesign(pureText: ExplainModel().methodExplain)

        methodExplain.showExplain(boxHeight: 280, title: "Method", explainDetailView: explainDetialView)
    }

    @objc func changeMethodLabel(_ sender: UIButton) {
        methodDataBaseAlterController.popoverPresentationController?.sourceView = sender
        methodDataBaseAlterController.popoverPresentationController?.sourceRect = sender.bounds
        present(methodDataBaseAlterController, animated: true, completion: nil)
    }

    // Structural Model

    let structuralModelExplain = ExplainBoxDesign()
    @objc func structuralModelQuestionExplain(_ sender: UIButton) {
        let explainDetialView: UIView = UIView()
        explainDetialView.explainDetialViewPureTextDesign(pureText: ExplainModel().structureModel)

        structuralModelExplain.showExplain(boxHeight: 300, title: "Structural Model", explainDetailView: explainDetialView)
    }

    @objc func changeStructuralModelLabel(_ sender: UIButton) {
        if analysisSettings.calculationMethod == .SwiftComp {
            structuralModelDataBaseAlterController.popoverPresentationController?.sourceView = sender
            structuralModelDataBaseAlterController.popoverPresentationController?.sourceRect = sender.bounds
            present(structuralModelDataBaseAlterController, animated: true, completion: nil)
        } else {
            structuralModelDataBaseAlterControllerNonSwiftComp.popoverPresentationController?.sourceView = sender
            structuralModelDataBaseAlterControllerNonSwiftComp.popoverPresentationController?.sourceRect = sender.bounds
            present(structuralModelDataBaseAlterControllerNonSwiftComp, animated: true, completion: nil)
        }
    }

    // beam submodel

    @objc func changeBeamSubmodelLabel(_ sender: UIButton) {
        if analysisSettings.calculationMethod == .SwiftComp {
            beamSubmodelDataBaseAlterController.popoverPresentationController?.sourceView = sender
            beamSubmodelDataBaseAlterController.popoverPresentationController?.sourceRect = sender.bounds
            present(beamSubmodelDataBaseAlterController, animated: true, completion: nil)
        } else {
            beamSubmodelDataBaseAlterControllerNonSwiftComp.popoverPresentationController?.sourceView = sender
            beamSubmodelDataBaseAlterControllerNonSwiftComp.popoverPresentationController?.sourceRect = sender.bounds
            present(beamSubmodelDataBaseAlterControllerNonSwiftComp, animated: true, completion: nil)
        }
    }

    let beamSubmodelExplain = ExplainBoxDesign()
    @objc func beamSubmodelQuestionExplain(_ sender: UIButton) {
        let explainDetialView: UIView = UIView()
        explainDetialView.explainDetialViewPureTextDesign(pureText: ExplainModel().beameSubmodel)

        beamSubmodelExplain.showExplain(boxHeight: 300, title: "Beam Submodel", explainDetailView: explainDetialView)
    }

    let beamInitialTwistCurvaturesExplain = ExplainBoxDesign()
    @objc func beamInitialTwistCurvaturesQuestionExplain(_ sender: UIButton) {
        let explainDetialView: UIView = UIView()
        explainDetialView.explainDetialViewPureTextDesign(pureText: ExplainModel().beamInitialTwistCurvatures)

        beamInitialTwistCurvaturesExplain.showExplain(boxHeight: 200, title: "Beam Initial Twist/Curvatures", explainDetailView: explainDetialView)
    }

    // beam oblique cross section

    let beamObliqueCrossSectionExplain = ExplainBoxDesign()
    @objc func beamObliqueCrossSectionQuestionExplain(_ sender: UIButton) {
        let explainDetialView: UIView = UIView()
        explainDetialView.explainDetialViewPureTextDesign(pureText: ExplainModel().beamObliqueCrossSections)

        beamObliqueCrossSectionExplain.showExplain(boxHeight: 300, title: "Beam Oblique Cross Sections", explainDetailView: explainDetialView)
    }

    // plate submodel

    @objc func changePlateSubmodelLabel(_ sender: UIButton) {
        if analysisSettings.calculationMethod == .SwiftComp {
            plateSubmodelDataBaseAlterController.popoverPresentationController?.sourceView = sender
            plateSubmodelDataBaseAlterController.popoverPresentationController?.sourceRect = sender.bounds
            present(plateSubmodelDataBaseAlterController, animated: true, completion: nil)
        } else {
            plateSubmodelDataBaseAlterControllerNonSwiftComp.popoverPresentationController?.sourceView = sender
            plateSubmodelDataBaseAlterControllerNonSwiftComp.popoverPresentationController?.sourceRect = sender.bounds
            present(plateSubmodelDataBaseAlterControllerNonSwiftComp, animated: true, completion: nil)
        }
    }

    let plateSubmodelExplain = ExplainBoxDesign()
    @objc func plateSubmodelQuestionExplain(_ sender: UIButton) {
        let explainDetialView: UIView = UIView()
        explainDetialView.explainDetialViewPureTextDesign(pureText: ExplainModel().plateSubmodel)

        plateSubmodelExplain.showExplain(boxHeight: 300, title: "Plate Submodel", explainDetailView: explainDetialView)
    }

    // plate initial curvatures

    let plateInitialCurvaturesExplain = ExplainBoxDesign()
    @objc func plateInitialCurvaturesQuestionExplain(_ sender: UIButton) {
        let explainDetialView: UIView = UIView()
        explainDetialView.explainDetialViewPureTextDesign(pureText: ExplainModel().plateInitialCurvatures)

        plateInitialCurvaturesExplain.showExplain(boxHeight: 200, title: "Plate Initial Curvatures", explainDetailView: explainDetialView)
    }

    // type of analysis

    let typeOfAnalysisExplain = ExplainBoxDesign()
    @objc func typeOfAnalysisQuestionExplain(_ sender: UIButton) {
        let explainDetialView: UIView = UIView()
        explainDetialView.explainDetialViewPureTextDesign(pureText: ExplainModel().typeOfAnalysisExplainText)

        typeOfAnalysisExplain.showExplain(boxHeight: 250, title: "Type of Analysis", explainDetailView: explainDetialView)
    }

    @objc func changeTypeOfAnalysisLabel(_ sender: UIButton) {
        if analysisSettings.structuralModel != .beam {
            typeOfAnalysisDataBaseAlterController.popoverPresentationController?.sourceView = sender
            typeOfAnalysisDataBaseAlterController.popoverPresentationController?.sourceRect = sender.bounds
            present(typeOfAnalysisDataBaseAlterController, animated: true, completion: nil)
        } else {
            typeOfAnalysisDataBaseAlterControllerBeam.popoverPresentationController?.sourceView = sender
            typeOfAnalysisDataBaseAlterControllerBeam.popoverPresentationController?.sourceRect = sender.bounds
            present(typeOfAnalysisDataBaseAlterControllerBeam, animated: true, completion: nil)
        }
    }

    // MARK: Create action sheet

    func createActionSheet() {
        methodDataBaseAlterController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        methodDataBaseAlterController.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))

        structuralModelDataBaseAlterController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        structuralModelDataBaseAlterController.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))

        structuralModelDataBaseAlterControllerNonSwiftComp = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        structuralModelDataBaseAlterControllerNonSwiftComp.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))

        beamSubmodelDataBaseAlterController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        beamSubmodelDataBaseAlterController.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))

        beamSubmodelDataBaseAlterControllerNonSwiftComp = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        beamSubmodelDataBaseAlterControllerNonSwiftComp.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))

        plateSubmodelDataBaseAlterController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        plateSubmodelDataBaseAlterController.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))

        plateSubmodelDataBaseAlterControllerNonSwiftComp = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        plateSubmodelDataBaseAlterControllerNonSwiftComp.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))

        typeOfAnalysisDataBaseAlterController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        typeOfAnalysisDataBaseAlterController.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))

        typeOfAnalysisDataBaseAlterControllerBeam = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        typeOfAnalysisDataBaseAlterControllerBeam.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
    }

    // MARK: edit tool bar

    func editToolBar() {
        if analysisSettings.calculationMethod == .SwiftComp {
            if NetworkManager.sharedInstance.reachability.connection != .none {
                calculationButton.changeStyle(style: .cloud)
                calculationButton.addTarget(self, action: #selector(calculate), for: .touchUpInside)
            } else {
                calculationButton.changeStyle(style: .noInternet)
                calculationButton.addTarget(self, action: #selector(calculateNoInternet), for: .touchUpInside)
            }
        } else {
            calculationButton.changeStyle(style: .local)
            calculationButton.addTarget(self, action: #selector(calculate), for: .touchUpInside)
        }

        let item = UIBarButtonItem(customView: calculationButton)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        navigationController?.setToolbarHidden(false, animated: false)
        toolbarItems = [flexibleSpace, item, flexibleSpace]
    }

    // calculate
//    var hud = JGProgressHUD(style: .dark)
    var workItem: DispatchWorkItem?
    @objc func calculate(_ sender: UIButton) {
        sender.isEnabled = false

        // get parameters

        let getParametersStatus = getCalculationParameters()

        if getParametersStatus != .noError {
            getParametersErrorHandler(vc: self, getParaemtersStatus: getParametersStatus)
            sender.isEnabled = true
            return
        }

        resultData = ResultData()

        let resultViewController = HomogenizationResultOld()

        // calculate by CLPT

        if analysisSettings.calculationMethod == .NonSwiftComp {
            calculationResultByNonSwiftComp()

            resultViewController.analysisSettings = analysisSettings
            resultViewController.resultData = resultData

            navigationController?.pushViewController(resultViewController, animated: true)
        }

        // calculate by SwiftComp

        if analysisSettings.calculationMethod == .SwiftComp {
            let calculateOperationQueue = OperationQueue()
            let operation = BlockOperation()

//            hud = JGProgressHUD(style: .dark)
//            hud.textLabel.text = "Calculating"
//            hud.detailTextLabel.text = "Tap to cancel"
//            hud.tapOnHUDViewBlock = { _ in
//                operation.cancel()
//                self.hud.dismiss(afterDelay: 0)
//                return
//            }
//            hud.show(in: view, animated: true)
//            hud.backgroundColor = .init(displayP3Red: 0.5, green: 0.5, blue: 0.5, alpha: 0.4)

            operation.addExecutionBlock {
                self.swiftcompCalculationStatus = self.calculateResultBySwiftComp()

                if operation.isCancelled {
                    DispatchQueue.main.async {
                        sender.isEnabled = true
                    }
                    return
                }

                DispatchQueue.main.async {
                    if self.swiftcompCalculationStatus != .success {
//                        self.hud.dismiss(afterDelay: 0.0)

                        swiftcompCalculationErrorHandler(vc: self, swiftcompCalculationStatus: self.swiftcompCalculationStatus)

                        sender.isEnabled = true

                    } else {
                        resultViewController.analysisSettings = self.analysisSettings
                        resultViewController.resultData = self.resultData

                        UIView.animate(withDuration: 0.1, animations: {
//                            self.hud.detailTextLabel.text = ""
//                            self.hud.textLabel.text = "Finished"
//                            self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                        })

                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                            self.hud.dismiss(afterDelay: 0)
                            self.navigationController?.pushViewController(resultViewController, animated: true)
                        }
                    }
                }
            }
            calculateOperationQueue.addOperation(operation)
        }
    }

    // get calculation parameters

    func getCalculationParameters() -> GetParametersStatus {
        preconditionFailure()
    }

    // calculate result by NonSwiftComp

    func calculationResultByNonSwiftComp() {
    }

    // calculate result by SwiftComp

    func calculateResultBySwiftComp() -> swiftcompCalculationStatus {
        preconditionFailure()
    }
}

class CalcuationOperation: Operation {
    override func main() {
    }
}

extension SwiftCompTemplateViewController {
    func setupNetworkManager() {
        NetworkManager.isReachable { [weak self] _ in
            guard let self = self else { return }
            if self.analysisSettings.calculationMethod == .SwiftComp {
                DispatchQueue.main.async {
                    self.calculationButton.changeStyle(style: .cloud)
                    self.calculationButton.addTarget(self, action: #selector(self.calculate), for: .touchUpInside)
                }
            }
        }

        NetworkManager.isUnreachable { [weak self] _ in
            guard let self = self else { return }
            if self.analysisSettings.calculationMethod == .SwiftComp {
                DispatchQueue.main.async {
                    self.calculationButton.changeStyle(style: .noInternet)
                    self.calculationButton.addTarget(self, action: #selector(self.calculateNoInternet), for: .touchUpInside)
                }
            }
        }

        NetworkManager.sharedInstance.reachability.whenReachable = { [weak self] _ in
            guard let self = self else { return }
            if self.analysisSettings.calculationMethod == .SwiftComp {
                DispatchQueue.main.async {
                    self.calculationButton.changeStyle(style: .cloud)
                    self.calculationButton.addTarget(self, action: #selector(self.calculate), for: .touchUpInside)
                }
            }
        }

        NetworkManager.sharedInstance.reachability.whenUnreachable = { [weak self] _ in
            guard let self = self else { return }
            if self.analysisSettings.calculationMethod == .SwiftComp {
                DispatchQueue.main.async {
                    self.calculationButton.changeStyle(style: .noInternet)
                    self.calculationButton.addTarget(self, action: #selector(self.calculateNoInternet), for: .touchUpInside)
                }
            }
        }
    }

    // calculate while no internet

    @objc func calculateNoInternet(_ sender: UIButton) {
        let noNetworkErrorAlter = UIAlertController(title: "No network connection", message: "To run SwiftComp, please connect to internet", preferredStyle: UIAlertController.Style.alert)
        noNetworkErrorAlter.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

        present(noNetworkErrorAlter, animated: true, completion: nil)
    }
}
