//
//  HoneycombSandwich.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 9/19/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import UIKit

class HoneycombSandwichController: SwiftCompTemplateViewController, UITextFieldDelegate {
    var coreLength = 0.0
    var coreThickness = 0.0
    var coreHeight = 0.0
    var layupSequence = [Double]()
    var layerThickness = 0.0

    var (ec1, ec2, ec3, gc12, gc13, gc23, nuc12, nuc13, nuc23) = (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
    var (alphac11, alphac22, alphac33, alphac23, alphac13, alphac12) = (0.0, 0.0, 0.0, 0.0, 0.0, 0.0)

    var (e1, e2, e3, g12, g13, g23, nu12, nu13, nu23) = (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
    var (c11, c12, c13, c14, c15, c16, c22, c23, c24, c25, c26, c33, c34, c35, c36, c44, c45, c46, c55, c56, c66) = (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
    var (alpha11, alpha22, alpha33, alpha23, alpha13, alpha12) = (0.0, 0.0, 0.0, 0.0, 0.0, 0.0)

    // core data

    var userSavedStackingSequences = [UserStackingSequence]()
    var userSavedCoreMaterials = [UserCoreMaterial]()
    var userSavedLaminaMaterials = [UserLaminaMaterial]()

    // core geometry

    var coreGeometryView: UIView = UIView()
    var coreGeometryFigureView: UIView = UIView()
    var coreGeometryOutlineLayer: CAShapeLayer = CAShapeLayer()
    var coreLengthLabel: UILabel = UILabel()
    var coreLengthTextField: UITextField = UITextField()
    var coreThicknessLabel: UILabel = UILabel()
    var coreThicknessTextField: UITextField = UITextField()
    var coreHeightLabel: UILabel = UILabel()
    var coreHeightTextField: UITextField = UITextField()

    // facesheet geometry

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

    // core material

    var coreMaterialType: MaterialType = .isotropic

    var coreMaterialView: UIView = UIView()
    var coreMaterialDataBase: UIButton = UIButton()
    var coreMaterialDataBaseViewController = CoreMaterialDataBase()
    let coreMaterialTypeSegementedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Isotropic", "Transversely", "Orthotropic"])
        sc.selectedSegmentIndex = 0
        sc.apportionsSegmentWidthsByContent = true
        return sc
    }()

    var coreMaterialCard: UIView = UIView()
    var coreMaterialNameLabel: UILabel = UILabel()
    var coreMaterialPropertiesLabel: [UILabel] = []
    var coreMaterialPropertiesTextField: [UITextField] = []
    var saveCoreMaterialButton: UIButton = UIButton()

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

        navigationItem.title = "Honeycomb Sandwich"

        stackingSequenceTextField.delegate = self
        coreLengthTextField.delegate = self
        coreThicknessTextField.delegate = self
        coreHeightTextField.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        loadCoreData()
    }

    override func createLayout() {
        super.createLayout()

        // add new stuff

        typeOfAnalysisView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -40).isActive = false
        scrollView.constraints.filter({ $0.firstAttribute == NSLayoutConstraint.Attribute.bottom }).forEach { $0.isActive = false }

        scrollView.addSubviews(coreGeometryView, stackingSequenceView, coreMaterialView, laminaMaterialView)

        structuralModelLabelButton.setTitle("Plate Model", for: .normal)

        analysisSettings.structuralModel = .plate
        plateSubmodelLabelButton.setTitle("Kirchho-Love Model", for: .normal)
        analysisSettings.structuralSubmodel = .KirchhoffLovePlateShellModel

        beamSubmodelView.isHidden = true
        beamInitialTwistCurvaturesView.isHidden = true
        beamObliqueCrossSectionView.isHidden = true
        plateSubmodelView.isHidden = false
        plateInitialCurvaturesView.isHidden = false

        structuralModelView.constraints.filter({ $0.firstAttribute == NSLayoutConstraint.Attribute.bottom }).forEach { $0.isActive = false }
        structuralModelLabelButton.bottomAnchor.constraint(equalTo: structuralModelView.bottomAnchor, constant: -12).isActive = false
        plateInitialCurvaturesView.bottomAnchor.constraint(equalTo: structuralModelView.bottomAnchor, constant: -12).isActive = true
        beamObliqueCrossSectionView.bottomAnchor.constraint(equalTo: structuralModelView.bottomAnchor, constant: -12).isActive = false
        structuralModelView.constraints.filter({ $0.firstAttribute == NSLayoutConstraint.Attribute.bottom }).forEach { $0.isActive = true }

        // geometry

        var coreGeometryQuestionButton: UIButton = UIButton()

        createViewCardWithTitleHelpButton(viewCard: coreGeometryView, title: "Core Geometry", helpButton: &coreGeometryQuestionButton, aboveConstraint: typeOfAnalysisView.bottomAnchor, under: scrollView)

        coreGeometryQuestionButton.addTarget(self, action: #selector(coreGeometryQuestionExplain), for: .touchUpInside)

        coreGeometryView.addSubviews(coreGeometryFigureView, coreLengthLabel, coreLengthTextField, coreThicknessLabel, coreThicknessTextField, coreHeightLabel, coreHeightTextField)

        coreGeometryFigureView.translatesAutoresizingMaskIntoConstraints = false
        coreGeometryFigureView.heightAnchor.constraint(equalToConstant: 140).isActive = true
        coreGeometryFigureView.widthAnchor.constraint(equalToConstant: 240).isActive = true
        coreGeometryFigureView.centerXAnchor.constraint(equalTo: coreGeometryView.centerXAnchor).isActive = true
        coreGeometryFigureView.topAnchor.constraint(equalTo: coreGeometryView.topAnchor, constant: 36).isActive = true
        coreGeometryFigureView.layer.addSublayer(coreGeometryOutlineLayer)

        let rectPath1 = UIBezierPath()
        rectPath1.move(to: CGPoint(x: coreGeometryFigureView.frame.minX, y: coreGeometryFigureView.frame.minY))
        rectPath1.addLine(to: CGPoint(x: coreGeometryFigureView.frame.minX + 240, y: coreGeometryFigureView.frame.minY))
        rectPath1.addLine(to: CGPoint(x: coreGeometryFigureView.frame.minX + 240, y: coreGeometryFigureView.frame.minY + 140))
        rectPath1.addLine(to: CGPoint(x: coreGeometryFigureView.frame.minX, y: coreGeometryFigureView.frame.minY + 140))
        rectPath1.close()
        coreGeometryOutlineLayer.path = rectPath1.cgPath
        coreGeometryOutlineLayer.fillColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        coreGeometryOutlineLayer.strokeColor = UIColor.blackThemeColor.cgColor

        coreLengthLabel.translatesAutoresizingMaskIntoConstraints = false
        coreLengthLabel.text = "Core Length"
        coreLengthLabel.font = UIFont.systemFont(ofSize: 14)
        coreLengthLabel.topAnchor.constraint(equalTo: coreGeometryFigureView.bottomAnchor, constant: 8).isActive = true
        coreLengthLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        coreLengthLabel.centerXAnchor.constraint(equalTo: coreGeometryView.centerXAnchor, constant: -64).isActive = true
        coreLengthLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true

        coreLengthTextField.translatesAutoresizingMaskIntoConstraints = false
        coreLengthTextField.placeholder = "Core Length"
        coreLengthTextField.text = "3.6"
        coreLengthTextField.keyboardType = UIKeyboardType.numbersAndPunctuation
        coreLengthTextField.borderStyle = .roundedRect
        coreLengthTextField.font = UIFont.systemFont(ofSize: 14)
        coreLengthTextField.heightAnchor.constraint(equalToConstant: 20).isActive = true
        coreLengthTextField.topAnchor.constraint(equalTo: coreGeometryFigureView.bottomAnchor, constant: 8).isActive = true
        coreLengthTextField.centerXAnchor.constraint(equalTo: coreGeometryView.centerXAnchor, constant: 64).isActive = true
        coreLengthTextField.widthAnchor.constraint(equalToConstant: 120).isActive = true

        coreThicknessLabel.translatesAutoresizingMaskIntoConstraints = false
        coreThicknessLabel.text = "Core Thickness"
        coreThicknessLabel.font = UIFont.systemFont(ofSize: 14)
        coreThicknessLabel.topAnchor.constraint(equalTo: coreLengthLabel.bottomAnchor, constant: 8).isActive = true
        coreThicknessLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        coreThicknessLabel.centerXAnchor.constraint(equalTo: coreGeometryView.centerXAnchor, constant: -64).isActive = true
        coreThicknessLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true

        coreThicknessTextField.translatesAutoresizingMaskIntoConstraints = false
        coreThicknessTextField.placeholder = "Core Thickness"
        coreThicknessTextField.text = "0.1"
        coreThicknessTextField.keyboardType = UIKeyboardType.numbersAndPunctuation
        coreThicknessTextField.borderStyle = .roundedRect
        coreThicknessTextField.font = UIFont.systemFont(ofSize: 14)
        coreThicknessTextField.heightAnchor.constraint(equalToConstant: 20).isActive = true
        coreThicknessTextField.topAnchor.constraint(equalTo: coreLengthLabel.bottomAnchor, constant: 8).isActive = true
        coreThicknessTextField.centerXAnchor.constraint(equalTo: coreGeometryView.centerXAnchor, constant: 64).isActive = true
        coreThicknessTextField.widthAnchor.constraint(equalToConstant: 120).isActive = true

        coreHeightLabel.translatesAutoresizingMaskIntoConstraints = false
        coreHeightLabel.text = "Core Height"
        coreHeightLabel.font = UIFont.systemFont(ofSize: 14)
        coreHeightLabel.topAnchor.constraint(equalTo: coreThicknessLabel.bottomAnchor, constant: 8).isActive = true
        coreHeightLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        coreHeightLabel.centerXAnchor.constraint(equalTo: coreGeometryView.centerXAnchor, constant: -64).isActive = true
        coreHeightLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true

        coreHeightTextField.translatesAutoresizingMaskIntoConstraints = false
        coreHeightTextField.placeholder = "Core Height"
        coreHeightTextField.text = "10"
        coreHeightTextField.keyboardType = UIKeyboardType.numbersAndPunctuation
        coreHeightTextField.borderStyle = .roundedRect
        coreHeightTextField.font = UIFont.systemFont(ofSize: 14)
        coreHeightTextField.heightAnchor.constraint(equalToConstant: 20).isActive = true
        coreHeightTextField.topAnchor.constraint(equalTo: coreThicknessLabel.bottomAnchor, constant: 8).isActive = true
        coreHeightTextField.centerXAnchor.constraint(equalTo: coreGeometryView.centerXAnchor, constant: 64).isActive = true
        coreHeightTextField.widthAnchor.constraint(equalToConstant: 120).isActive = true

        generateCoreGeometryFigure()

        coreHeightTextField.bottomAnchor.constraint(equalTo: coreGeometryView.bottomAnchor, constant: -12).isActive = true

        var stackingSequenceQuestionButton: UIButton = UIButton()

        createViewCardWithTitleHelpButtonDatabaseButton(viewCard: stackingSequenceView, title: "Facesheet Geometry", helpButton: &stackingSequenceQuestionButton, databaseButton: &stackingSequenceDataBase, saveDatabaseButton: &stackingSequenceSave, aboveConstraint: coreGeometryView.bottomAnchor, under: scrollView)

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

        stackingSequenceNameLabel.text = "[45/-45]"
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
        laminaThicknessTextField.text = "0.1"
        laminaThicknessTextField.keyboardType = UIKeyboardType.numbersAndPunctuation
        laminaThicknessTextField.borderStyle = .roundedRect
        laminaThicknessTextField.font = UIFont.systemFont(ofSize: 14)
        laminaThicknessTextField.heightAnchor.constraint(equalToConstant: 25).isActive = true
        laminaThicknessTextField.topAnchor.constraint(equalTo: stackingSequenceTextField.bottomAnchor, constant: 8).isActive = true
        laminaThicknessTextField.centerXAnchor.constraint(equalTo: stackingSequenceView.centerXAnchor, constant: 64).isActive = true
        laminaThicknessTextField.widthAnchor.constraint(equalToConstant: 120).isActive = true

        laminaThicknessTextField.bottomAnchor.constraint(equalTo: stackingSequenceView.bottomAnchor, constant: -12).isActive = true

        // core material

        var coreMaterialQuestionButton: UIButton = UIButton()

        createViewCardWithTitleHelpButtonDatabaseButton(viewCard: coreMaterialView, title: "Core Material", helpButton: &coreMaterialQuestionButton, databaseButton: &coreMaterialDataBase, saveDatabaseButton: &saveCoreMaterialButton, aboveConstraint: stackingSequenceView.bottomAnchor, under: scrollView)

        coreMaterialQuestionButton.addTarget(self, action: #selector(coreMaterialQuestionExplain), for: .touchUpInside)
        coreMaterialDataBase.addTarget(self, action: #selector(enterCoreMaterialDataBase), for: .touchUpInside)
        saveCoreMaterialButton.addTarget(self, action: #selector(saveCoreMaterial), for: .touchUpInside)

        coreMaterialView.addSubview(coreMaterialTypeSegementedControl)
        coreMaterialView.addSubview(coreMaterialCard)

        coreMaterialTypeSegementedControl.translatesAutoresizingMaskIntoConstraints = false
        coreMaterialTypeSegementedControl.addTarget(self, action: #selector(changeCoreMaterialType), for: .valueChanged)
        coreMaterialTypeSegementedControl.widthAnchor.constraint(equalToConstant: 310).isActive = true
        coreMaterialTypeSegementedControl.topAnchor.constraint(equalTo: coreMaterialDataBase.bottomAnchor, constant: 8).isActive = true
        coreMaterialTypeSegementedControl.centerXAnchor.constraint(equalTo: coreMaterialView.centerXAnchor).isActive = true

        coreMaterialNameLabel.text = "Nomex"
        createMaterialCard(materialCard: &coreMaterialCard, materialName: coreMaterialNameLabel, label: &coreMaterialPropertiesLabel, value: &coreMaterialPropertiesTextField, aboveConstraint: coreMaterialTypeSegementedControl.bottomAnchor, under: coreMaterialView, typeOfAnalysis: analysisSettings.typeOfAnalysis, materialType: .isotropic)

        changeCoreMaterialDataField()

        coreMaterialCard.bottomAnchor.constraint(equalTo: coreMaterialView.bottomAnchor, constant: -12).isActive = true

        // lamina material

        createViewCard(viewCard: laminaMaterialView, title: "Facesheet Lamina Material", aboveConstraint: coreMaterialView.bottomAnchor, under: scrollView)
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

        changeLaminaMaterialDataField()

        laminaMaterialCard.bottomAnchor.constraint(equalTo: laminaMaterialView.bottomAnchor, constant: -20).isActive = true

        laminaMaterialView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -40).isActive = true

        scrollView.constraints.filter({ $0.firstAttribute == NSLayoutConstraint.Attribute.bottom }).forEach { $0.isActive = true }
    }

    // MARK: question button section

    override func methodQuestionExplain(_ sender: UIButton) {
        let explainDetialView: UIView = UIView()
        explainDetialView.explainDetialViewPureTextDesign(pureText: ExplainModel().methodExplain + "\n\n" + ExplainModel().honeycombSandwichMethodExplain)

        methodExplain.showExplain(boxHeight: 200, title: "Method", explainDetailView: explainDetialView)
    }

    let coreGeometryExplain = ExplainBoxDesign()
    @objc func coreGeometryQuestionExplain(_ sender: UIButton, event: UIEvent) {
        let explainDetialView: UIView = UIView()

        let explainLabel1 = UILabel()

        explainDetialView.addSubview(explainLabel1)

        explainLabel1.translatesAutoresizingMaskIntoConstraints = false
        explainLabel1.numberOfLines = 0
        explainLabel1.lineBreakMode = .byWordWrapping
        explainLabel1.font = UIFont.systemFont(ofSize: 12)
        explainLabel1.topAnchor.constraint(equalTo: explainDetialView.topAnchor, constant: 0).isActive = true
        explainLabel1.leftAnchor.constraint(equalTo: explainDetialView.leftAnchor, constant: 0).isActive = true
        explainLabel1.rightAnchor.constraint(equalTo: explainDetialView.rightAnchor, constant: 0).isActive = true
        explainLabel1.text = """
        The core is made of a regular hexagonal low density solid with double wall thickness. It is used to mainly provide bending stiffness and shear stiffness to the honeycomb sandwich structure. The geometry of the core is determined by three parameters:
        ● Core length l1: Length of the oblique wall
        ● Core thickness tc: thickness of the core wall
        ● Core height hc: distance between top and bottom facesheets
        """

        let explainFigure: UIImageView = UIImageView()

        explainDetialView.addSubview(explainFigure)

        explainFigure.translatesAutoresizingMaskIntoConstraints = false
        explainFigure.topAnchor.constraint(equalTo: explainLabel1.bottomAnchor, constant: 8).isActive = true
        explainFigure.centerXAnchor.constraint(equalTo: explainDetialView.centerXAnchor, constant: 0).isActive = true
        explainFigure.heightAnchor.constraint(equalToConstant: 150).isActive = true
        explainFigure.contentMode = .scaleAspectFit
        explainFigure.clipsToBounds = true
        explainFigure.image = #imageLiteral(resourceName: "honeycomb_core")

        let explainLabel2 = UILabel()

        explainDetialView.addSubview(explainLabel2)

        explainLabel2.translatesAutoresizingMaskIntoConstraints = false
        explainLabel2.numberOfLines = 0
        explainLabel2.lineBreakMode = .byWordWrapping
        explainLabel2.font = UIFont.systemFont(ofSize: 12)
        explainLabel2.topAnchor.constraint(equalTo: explainFigure.bottomAnchor, constant: 8).isActive = true
        explainLabel2.leftAnchor.constraint(equalTo: explainDetialView.leftAnchor, constant: 0).isActive = true
        explainLabel2.rightAnchor.constraint(equalTo: explainDetialView.rightAnchor, constant: 0).isActive = true
        explainLabel2.bottomAnchor.constraint(equalTo: explainDetialView.bottomAnchor, constant: 0).isActive = true
        explainLabel2.text = """
        Note, only a quarter of the core is shown in the figure since the core is symmetric with respect to (wrt) three planes.
        Also, another parameters can be determined since the core is regular hexgonal shape, i.e.
        ● l2 = l1/2
        ● theta = 60 degree
        ● dc/2 = tc+l1*sin(theta)-tc*cos(theta)
        """

        coreGeometryExplain.showExplain(boxHeight: 500, title: "Core Geometry", explainDetailView: explainDetialView)
    }

    let laminaGeometryExplain = ExplainBoxDesign()
    @objc func stackingSequenceQuestionExplain(_ sender: UIButton, event: UIEvent) {
        let explainDetialView: UIView = UIView()
        explainDetialView.explainDetialViewPureTextDesign(pureText: ExplainModel().honeycombSandwichFacesheetGeometryExplain)

        laminaGeometryExplain.showExplain(boxHeight: 400, title: "Facesheet Geometry", explainDetailView: explainDetialView)
    }

    let coreMaterialExplain = ExplainBoxDesign()
    @objc func coreMaterialQuestionExplain(_ sender: UIButton, event: UIEvent) {
        let explainDetialView: UIView = UIView()
        explainDetialView.explainDetialViewPureTextDesign(pureText: ExplainModel().honeycombSandwichCoreMaterialExplain + "\n\n" + ExplainModel().materialExplain)

        coreMaterialExplain.showExplain(boxHeight: 400, title: "Core Material", explainDetailView: explainDetialView)
    }

    let laminaMaterialExplain = ExplainBoxDesign()
    @objc func laminaMaterialQuestionExplain(_ sender: UIButton, event: UIEvent) {
        let explainDetialView: UIView = UIView()
        explainDetialView.explainDetialViewPureTextDesign(pureText: ExplainModel().laminateMaterialExplain + "\n\n" + ExplainModel().materialExplain)

        laminaMaterialExplain.showExplain(boxHeight: 400, title: "Facesheet Lamina Material", explainDetailView: explainDetialView)
    }

    @objc func enterStackingSequenceDataBase(_ sender: UIButton, event: UIEvent) {
        LaminateStackingSequenceDataBaseViewController = StackingSequenceDataBase()

        LaminateStackingSequenceDataBaseViewController.delegate = self

        let navController = SCNavigationController(rootViewController: LaminateStackingSequenceDataBaseViewController)

        present(navController, animated: true, completion: nil)
    }

    // change stacking sequence data field

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

    func textFieldDidEndEditing(_ textField: UITextField) {
        generateLayupFigure()
        generateCoreGeometryFigure()
    }

    //  generate core geometry figure

    func generateCoreGeometryFigure() {
        let wrongCoreGeometryText: UITextView = UITextView()

        coreGeometryFigureView.subviews.forEach({ $0.removeFromSuperview() }) // first remove all subviews
        coreGeometryFigureView.layer.sublayers?.forEach({ $0.removeFromSuperlayer() }) // first remove all sublayers

        coreGeometryFigureView.layer.addSublayer(coreGeometryOutlineLayer)
        coreGeometryOutlineLayer.fillColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        coreGeometryFigureView.addSubview(wrongCoreGeometryText)

        wrongCoreGeometryText.translatesAutoresizingMaskIntoConstraints = false
        wrongCoreGeometryText.text = """
        Wrong Core Geometry!
        Make sure to have:
        2<=l1/tc<=100
        hc/l1<=20
        """
        wrongCoreGeometryText.font = UIFont.systemFont(ofSize: 14)
        wrongCoreGeometryText.isScrollEnabled = false
        wrongCoreGeometryText.centerXAnchor.constraint(equalTo: coreGeometryFigureView.centerXAnchor, constant: 0).isActive = true
        wrongCoreGeometryText.centerYAnchor.constraint(equalTo: coreGeometryFigureView.centerYAnchor, constant: 0).isActive = true
        wrongCoreGeometryText.isHidden = true
        wrongCoreGeometryText.backgroundColor = .clear

        guard let coreLengthGuard = Double(coreLengthTextField.text ?? ""), let coreThicknessGuard = Double(coreThicknessTextField.text ?? ""), let coreHeightGuard = Double(coreHeightTextField.text ?? "") else {
            wrongCoreGeometryText.isHidden = false
            coreGeometryOutlineLayer.fillColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 0.5)
            return
        }

        if coreLengthGuard == 0.0 || coreThicknessGuard == 0.0 || coreHeightGuard == 0.0 {
            wrongCoreGeometryText.isHidden = false
            coreGeometryOutlineLayer.fillColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 0.5)
            return
        }

        let ratio1 = coreLengthGuard / coreThicknessGuard
        let ratio2 = coreHeightGuard / coreLengthGuard

        if ratio1 < 2.0 || ratio1 > 100.0 || ratio2 > 20.0 {
            wrongCoreGeometryText.isHidden = false
            coreGeometryOutlineLayer.fillColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 0.5)
            return
        }

        /* Initialize geometric parameters */
        var l1: Double = 0.0
        var tc: Double = 0.0
        if ratio1 >= 6 {
            l1 = coreLengthGuard / coreLengthGuard * 60
            tc = coreThicknessGuard / coreLengthGuard * 60
        } else {
            l1 = coreLengthGuard / coreThicknessGuard * 10
            tc = coreThicknessGuard / coreThicknessGuard * 10
        }

        /* Define expressions fpr creating coordinates */
        let l2 = l1 / 2
        let theta = Double.pi / 3.0
        let a = l2 + l1 * cos(theta) + tc * sin(theta) + l2
        let b = l2 + l1 * cos(theta) + tc * sin(theta) - tc * tan(0.5 * theta)
        let c = l2 + l1 * cos(theta) + tc * sin(theta)
        let d = l2 + tc * tan(0.5 * theta)
        let m = tc + l1 * sin(theta) - tc * cos(theta)
        let n = 2 * tc + l1 * sin(theta) - tc * cos(theta)

        let coreGeometryFigureLayer: CAShapeLayer = CAShapeLayer()
        coreGeometryFigureView.layer.addSublayer(coreGeometryFigureLayer)

        let myPaths = UIBezierPath()
        let point1 = CGPoint(x: -a + 120, y: 0 + 70)
        let point2 = CGPoint(x: -a + 120, y: tc + 70)
        let point3 = CGPoint(x: -b + 120, y: 0 + 70)
        let point4 = CGPoint(x: -c + 120, y: tc + 70)
        let point5 = CGPoint(x: -l2 + 120, y: m + 70)
        let point6 = CGPoint(x: -d + 120, y: n + 70)
        let point7 = CGPoint(x: a + 120, y: 0 + 70)
        let point8 = CGPoint(x: a + 120, y: tc + 70)
        let point9 = CGPoint(x: b + 120, y: 0 + 70)
        let point10 = CGPoint(x: c + 120, y: tc + 70)
        let point11 = CGPoint(x: l2 + 120, y: m + 70)
        let point12 = CGPoint(x: d + 120, y: n + 70)
        let point13 = CGPoint(x: -a + 120, y: -tc + 70)
        let point14 = CGPoint(x: -c + 120, y: -tc + 70)
        let point15 = CGPoint(x: -l2 + 120, y: -m + 70)
        let point16 = CGPoint(x: -d + 120, y: -n + 70)
        let point17 = CGPoint(x: l2 + 120, y: -m + 70)
        let point18 = CGPoint(x: d + 120, y: -n + 70)
        let point19 = CGPoint(x: c + 120, y: -tc + 70)
        let point20 = CGPoint(x: a + 120, y: -tc + 70)

        let paths = [createPath(beginPoint: point1, endPoint: point3),
                     createPath(beginPoint: point3, endPoint: point4),
                     createPath(beginPoint: point4, endPoint: point2),
                     createPath(beginPoint: point2, endPoint: point1),
                     createPath(beginPoint: point3, endPoint: point5),
                     createPath(beginPoint: point5, endPoint: point6),
                     createPath(beginPoint: point6, endPoint: point4),
                     createPath(beginPoint: point5, endPoint: point11),
                     createPath(beginPoint: point11, endPoint: point12),
                     createPath(beginPoint: point12, endPoint: point6),
                     createPath(beginPoint: point11, endPoint: point9),
                     createPath(beginPoint: point9, endPoint: point10),
                     createPath(beginPoint: point10, endPoint: point12),
                     createPath(beginPoint: point9, endPoint: point7),
                     createPath(beginPoint: point7, endPoint: point8),
                     createPath(beginPoint: point8, endPoint: point10),
                     createPath(beginPoint: point13, endPoint: point14),
                     createPath(beginPoint: point14, endPoint: point3),
                     createPath(beginPoint: point1, endPoint: point13),
                     createPath(beginPoint: point14, endPoint: point16),
                     createPath(beginPoint: point16, endPoint: point15),
                     createPath(beginPoint: point15, endPoint: point3),
                     createPath(beginPoint: point16, endPoint: point18),
                     createPath(beginPoint: point18, endPoint: point17),
                     createPath(beginPoint: point17, endPoint: point15),
                     createPath(beginPoint: point18, endPoint: point19),
                     createPath(beginPoint: point19, endPoint: point9),
                     createPath(beginPoint: point9, endPoint: point17),
                     createPath(beginPoint: point19, endPoint: point20),
                     createPath(beginPoint: point20, endPoint: point7),
        ]

        for path in paths {
            myPaths.append(path) // THIS IS THE IMPORTANT PART
        }

        coreGeometryFigureLayer.path = myPaths.cgPath
        coreGeometryFigureLayer.strokeColor = UIColor.blackThemeColor.cgColor
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

    @objc func enterCoreMaterialDataBase(_ sender: UIButton, event: UIEvent) {
        coreMaterialDataBaseViewController = CoreMaterialDataBase()

        coreMaterialDataBaseViewController.delegate = self

        let navController = SCNavigationController(rootViewController: coreMaterialDataBaseViewController)

        present(navController, animated: true, completion: nil)
    }

    func determineCoreMaterialType() {
        let allMaterials = MaterialBank()

        let materialCurrectName = coreMaterialNameLabel.text!

        for material in allMaterials.list {
            if materialCurrectName == material.materialName {
                coreMaterialType = material.materialType
            }
        }

        for userSaveMaterial in userSavedCoreMaterials {
            if materialCurrectName == userSaveMaterial.name {
                switch userSaveMaterial.type {
                case "Isotropic", "isotropic":
                    coreMaterialType = .isotropic
                    break
                case "Transversely Isotropic", "Transversely isotropic":
                    coreMaterialType = .transverselyIsotropic
                    break
                case "Orthotropic", "orthotropic":
                    coreMaterialType = .orthotropic
                    break
                default:
                    coreMaterialType = .isotropic
                    break
                }
            }
        }

        switch coreMaterialType {
        case .isotropic:
            coreMaterialTypeSegementedControl.selectedSegmentIndex = 0
        case .transverselyIsotropic:
            coreMaterialTypeSegementedControl.selectedSegmentIndex = 1
        case .orthotropic:
            coreMaterialTypeSegementedControl.selectedSegmentIndex = 2
        default:
            break
        }
    }

    @objc func changeCoreMaterialType() {
        switch coreMaterialTypeSegementedControl.selectedSegmentIndex {
        case 0:
            coreMaterialType = .isotropic
        case 1:
            coreMaterialType = .transverselyIsotropic
        case 2:
            coreMaterialType = .orthotropic
        default:
            coreMaterialType = .isotropic
        }

        createMaterialCard(materialCard: &coreMaterialCard, materialName: coreMaterialNameLabel, label: &coreMaterialPropertiesLabel, value: &coreMaterialPropertiesTextField, aboveConstraint: coreMaterialTypeSegementedControl.bottomAnchor, under: coreMaterialView, typeOfAnalysis: analysisSettings.typeOfAnalysis, materialType: coreMaterialType)

        coreMaterialCard.bottomAnchor.constraint(equalTo: coreMaterialView.bottomAnchor, constant: -12).isActive = true

        changeCoreMaterialDataField()
    }

    func changeCoreMaterialDataField() {
        let allMaterials = MaterialBank()

        // change core material card

        let coreMaterialCurrectName = coreMaterialNameLabel.text!

        for material in allMaterials.list {
            if coreMaterialCurrectName == material.materialName {
                if coreMaterialType == .isotropic {
                    for i in 0 ... materialPropertyName.isotropic.count - 1 {
                        if let property = material.materialProperties[materialPropertyName.isotropic[i]] {
                            coreMaterialPropertiesTextField[i].text = String(format: "%.2f", property)
                        } else {
                            coreMaterialPropertiesTextField[i].text = ""
                        }
                    }
                    if analysisSettings.typeOfAnalysis == .thermoElastic {
                        for i in 0 ... materialPropertyName.isotropicThermal.count - 1 {
                            if let property = material.materialProperties[materialPropertyName.isotropicThermal[i]] {
                                coreMaterialPropertiesTextField[i + materialPropertyName.isotropic.count].text = String(format: "%.2f", property)
                            } else {
                                coreMaterialPropertiesTextField[i + materialPropertyName.isotropic.count].text = ""
                            }
                        }
                    }
                } else if coreMaterialType == .transverselyIsotropic {
                    for i in 0 ... materialPropertyName.transverselyIsotropic.count - 1 {
                        if let property = material.materialProperties[materialPropertyName.transverselyIsotropic[i]] {
                            coreMaterialPropertiesTextField[i].text = String(format: "%.2f", property)
                        } else {
                            coreMaterialPropertiesTextField[i].text = ""
                        }
                    }
                    if analysisSettings.typeOfAnalysis == .thermoElastic {
                        for i in 0 ... materialPropertyName.transverselyIsotropicThermal.count - 1 {
                            if let property = material.materialProperties[materialPropertyName.transverselyIsotropicThermal[i]] {
                                coreMaterialPropertiesTextField[i + materialPropertyName.transverselyIsotropic.count].text = String(format: "%.2f", property)
                            } else {
                                coreMaterialPropertiesTextField[i + materialPropertyName.transverselyIsotropic.count].text = ""
                            }
                        }
                    }
                } else if coreMaterialType == .orthotropic {
                    for i in 0 ... materialPropertyName.orthotropic.count - 1 {
                        if let property = material.materialProperties[materialPropertyName.orthotropic[i]] {
                            coreMaterialPropertiesTextField[i].text = String(format: "%.2f", property)
                        } else {
                            coreMaterialPropertiesTextField[i].text = ""
                        }
                    }
                    if analysisSettings.typeOfAnalysis == .thermoElastic {
                        for i in 0 ... materialPropertyName.orthotropicThermal.count - 1 {
                            if let property = material.materialProperties[materialPropertyName.orthotropicThermal[i]] {
                                coreMaterialPropertiesTextField[i + materialPropertyName.orthotropic.count].text = String(format: "%.2f", property)
                            } else {
                                coreMaterialPropertiesTextField[i + materialPropertyName.orthotropic.count].text = ""
                            }
                        }
                    }
                }
            } else if coreMaterialCurrectName == "Empty Material" {
                if coreMaterialType == .isotropic {
                    for i in 0 ... materialPropertyName.isotropic.count - 1 {
                        coreMaterialPropertiesTextField[i].text = ""
                    }
                    if analysisSettings.typeOfAnalysis == .thermoElastic {
                        for i in 0 ... materialPropertyName.isotropicThermal.count - 1 {
                            coreMaterialPropertiesTextField[i + materialPropertyName.isotropic.count].text = ""
                        }
                    }
                } else if coreMaterialType == .transverselyIsotropic {
                    for i in 0 ... materialPropertyName.transverselyIsotropic.count - 1 {
                        coreMaterialPropertiesTextField[i].text = ""
                    }
                    if analysisSettings.typeOfAnalysis == .thermoElastic {
                        for i in 0 ... materialPropertyName.transverselyIsotropicThermal.count - 1 {
                            coreMaterialPropertiesTextField[i + materialPropertyName.transverselyIsotropic.count].text = ""
                        }
                    }
                } else if coreMaterialType == .orthotropic {
                    for i in 0 ... materialPropertyName.orthotropic.count - 1 {
                        coreMaterialPropertiesTextField[i].text = ""
                    }
                    if analysisSettings.typeOfAnalysis == .thermoElastic {
                        for i in 0 ... materialPropertyName.orthotropicThermal.count - 1 {
                            coreMaterialPropertiesTextField[i + materialPropertyName.orthotropic.count].text = ""
                        }
                    }
                }
            }
        }

        for userSaveMaterial in userSavedCoreMaterials {
            if coreMaterialCurrectName == userSaveMaterial.name {
                if coreMaterialType == .isotropic {
                    for i in 0 ... materialPropertyName.isotropic.count - 1 {
                        if let valueDictionary = userSaveMaterial.properties as? [String: Double] {
                            if let value = valueDictionary[materialPropertyName.isotropic[i]] {
                                coreMaterialPropertiesTextField[i].text = String(format: "%.2f", value)
                            } else {
                                coreMaterialPropertiesTextField[i].text = ""
                            }
                        } else {
                            coreMaterialPropertiesTextField[i].text = ""
                        }
                    }
                    if analysisSettings.typeOfAnalysis == .thermoElastic {
                        for i in 0 ... materialPropertyName.isotropicThermal.count - 1 {
                            if let valueDictionary = userSaveMaterial.properties as? [String: Double] {
                                if let value = valueDictionary[materialPropertyName.isotropicThermal[i]] {
                                    coreMaterialPropertiesTextField[i + materialPropertyName.isotropic.count].text = String(format: "%.2f", value)
                                } else {
                                    coreMaterialPropertiesTextField[i + materialPropertyName.isotropic.count].text = ""
                                }
                            } else {
                                coreMaterialPropertiesTextField[i + materialPropertyName.isotropic.count].text = ""
                            }
                        }
                    }
                } else if coreMaterialType == .transverselyIsotropic {
                    for i in 0 ... materialPropertyName.transverselyIsotropic.count - 1 {
                        if let valueDictionary = userSaveMaterial.properties as? [String: Double] {
                            if let value = valueDictionary[materialPropertyName.transverselyIsotropic[i]] {
                                coreMaterialPropertiesTextField[i].text = String(format: "%.2f", value)
                            } else {
                                coreMaterialPropertiesTextField[i].text = ""
                            }
                        } else {
                            coreMaterialPropertiesTextField[i].text = ""
                        }
                    }
                    if analysisSettings.typeOfAnalysis == .thermoElastic {
                        for i in 0 ... materialPropertyName.transverselyIsotropicThermal.count - 1 {
                            if let valueDictionary = userSaveMaterial.properties as? [String: Double] {
                                if let value = valueDictionary[materialPropertyName.transverselyIsotropicThermal[i]] {
                                    coreMaterialPropertiesTextField[i + materialPropertyName.transverselyIsotropic.count].text = String(format: "%.2f", value)
                                } else {
                                    coreMaterialPropertiesTextField[i + materialPropertyName.transverselyIsotropic.count].text = ""
                                }
                            } else {
                                coreMaterialPropertiesTextField[i + materialPropertyName.transverselyIsotropic.count].text = ""
                            }
                        }
                    }
                } else if coreMaterialType == .orthotropic {
                    for i in 0 ... materialPropertyName.orthotropic.count - 1 {
                        if let valueDictionary = userSaveMaterial.properties as? [String: Double] {
                            if let value = valueDictionary[materialPropertyName.orthotropic[i]] {
                                coreMaterialPropertiesTextField[i].text = String(format: "%.2f", value)
                            } else {
                                coreMaterialPropertiesTextField[i].text = ""
                            }
                        } else {
                            coreMaterialPropertiesTextField[i].text = ""
                        }
                    }
                    if analysisSettings.typeOfAnalysis == .thermoElastic {
                        for i in 0 ... materialPropertyName.orthotropicThermal.count - 1 {
                            if let valueDictionary = userSaveMaterial.properties as? [String: Double] {
                                if let value = valueDictionary[materialPropertyName.orthotropicThermal[i]] {
                                    coreMaterialPropertiesTextField[i + materialPropertyName.orthotropic.count].text = String(format: "%.2f", value)
                                } else {
                                    coreMaterialPropertiesTextField[i + materialPropertyName.orthotropic.count].text = ""
                                }
                            } else {
                                coreMaterialPropertiesTextField[i + materialPropertyName.orthotropic.count].text = ""
                            }
                        }
                    }
                }
            }
        }
    }

    @objc func saveCoreMaterial(_ sender: UIButton) {
        let inputAlter = UIAlertController(title: "Save Core Material", message: "Enter the material name.", preferredStyle: UIAlertController.Style.alert)
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

            var userCoreMaterialDictionary: [String: Double] = [:]
            var userCoreMaterialType: String = ""

            let wrongMaterialValueAlter = UIAlertController(title: "Wrong Material Values", message: "Please enter valid values (number) for this material.", preferredStyle: UIAlertController.Style.alert)
            wrongMaterialValueAlter.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

            let emptyMaterialValueAlter = UIAlertController(title: "Empty Material Value", message: "Please enter values (number) for this material.", preferredStyle: UIAlertController.Style.alert)
            emptyMaterialValueAlter.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

            if self.coreMaterialType == .isotropic {
                userCoreMaterialType = "Isotropic"
                for i in 0 ... materialPropertyName.isotropic.count - 1 {
                    if let valueString = self.coreMaterialPropertiesTextField[i].text {
                        if let value = Double(valueString) {
                            userCoreMaterialDictionary[materialPropertyName.isotropic[i]] = value
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
                    for i in 0 ... materialPropertyName.isotropicThermal.count - 1 {
                        if let valueString = self.coreMaterialPropertiesTextField[i + materialPropertyName.isotropic.count].text {
                            if let value = Double(valueString) {
                                userCoreMaterialDictionary[materialPropertyName.isotropicThermal[i]] = value
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
            } else if self.coreMaterialType == .transverselyIsotropic {
                userCoreMaterialType = "Transversely Isotropic"
                for i in 0 ... materialPropertyName.transverselyIsotropic.count - 1 {
                    if let valueString = self.coreMaterialPropertiesTextField[i].text {
                        if let value = Double(valueString) {
                            userCoreMaterialDictionary[materialPropertyName.transverselyIsotropic[i]] = value
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
                        if let valueString = self.coreMaterialPropertiesTextField[i + materialPropertyName.transverselyIsotropic.count].text {
                            if let value = Double(valueString) {
                                userCoreMaterialDictionary[materialPropertyName.transverselyIsotropicThermal[i]] = value
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
            } else if self.coreMaterialType == .orthotropic {
                userCoreMaterialType = "Orthotropic"
                for i in 0 ... materialPropertyName.orthotropic.count - 1 {
                    if let valueString = self.coreMaterialPropertiesTextField[i].text {
                        if let value = Double(valueString) {
                            userCoreMaterialDictionary[materialPropertyName.orthotropic[i]] = value
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
                        if let valueString = self.coreMaterialPropertiesTextField[i + materialPropertyName.orthotropic.count].text {
                            if let value = Double(valueString) {
                                userCoreMaterialDictionary[materialPropertyName.orthotropicThermal[i]] = value
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

            for name in ["Empty Material", "Nomex", "Aluminum", "Steel"] {
                if userMaterialName == name {
                    self.present(sameMaterialNameAlter, animated: true, completion: nil)
                    return
                }
            }

            for userSavedCoreMaterial in self.userSavedCoreMaterials {
                if let name = userSavedCoreMaterial.name {
                    if userMaterialName == name {
                        self.present(sameMaterialNameAlter, animated: true, completion: nil)
                        return
                    }
                }
            }

            let currentUserCoreMaterial = UserCoreMaterial(context: context)
            currentUserCoreMaterial.setValue(userMaterialName, forKey: "name")
            currentUserCoreMaterial.setValue(userCoreMaterialType, forKey: "type")
            currentUserCoreMaterial.setValue(userCoreMaterialDictionary, forKey: "properties")

            do {
                try context.save()
                self.loadCoreData()

                // material card saving animation

                let MaterialCardImage: UIImage = UIImage(named: "user_defined_material_card")!
                let MaterialCardImageView: UIImageView = UIImageView(image: MaterialCardImage)

                self.coreMaterialView.addSubview(MaterialCardImageView)

                MaterialCardImageView.frame.origin.x = self.coreMaterialCard.frame.origin.x + self.coreMaterialCard.frame.width / 2 - MaterialCardImageView.frame.width / 2
                MaterialCardImageView.frame.origin.y = self.coreMaterialCard.frame.origin.y + self.coreMaterialCard.frame.height / 2

                UIView.animate(withDuration: 0.8, animations: {
                    MaterialCardImageView.frame.origin.x = self.coreMaterialDataBase.frame.origin.x + self.coreMaterialDataBase.frame.width / 2 - MaterialCardImageView.frame.width / 2
                    MaterialCardImageView.frame.origin.y = self.coreMaterialDataBase.frame.origin.y + self.coreMaterialDataBase.frame.height / 2
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

        changeLaminaMaterialDataField()
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

    // MARK: Change material data field

    func changeLaminaMaterialDataField() {
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

    // MARK: Create action sheet

    override func createActionSheet() {
        super.createActionSheet()

        let m0 = UIAlertAction(title: "SwiftComp", style: UIAlertAction.Style.default) { [weak self] (_) -> Void in

            guard let self = self else { return }

            self.methodLabelButton.setTitle("SwiftComp", for: .normal)
            self.methodLabelButton.layoutIfNeeded()

            self.analysisSettings.calculationMethod = .SwiftComp
            self.editToolBar()

            if self.analysisSettings.structuralModel == .beam {
                if self.analysisSettings.structuralSubmodel != .EulerBernoulliBeamModel && self.analysisSettings.structuralSubmodel != .TimoshenkoBeamModel {
                    self.analysisSettings.structuralSubmodel = .EulerBernoulliBeamModel
                }

                self.plateSubmodelView.isHidden = true

                self.structuralModelView.constraints.filter({ $0.firstAttribute == NSLayoutConstraint.Attribute.bottom }).forEach { $0.isActive = false }
                self.structuralModelLabelButton.bottomAnchor.constraint(equalTo: self.structuralModelView.bottomAnchor, constant: -12).isActive = false
                self.plateInitialCurvaturesView.bottomAnchor.constraint(equalTo: self.structuralModelView.bottomAnchor, constant: -12).isActive = false
                self.beamObliqueCrossSectionView.bottomAnchor.constraint(equalTo: self.structuralModelView.bottomAnchor, constant: -12).isActive = true
                self.structuralModelView.constraints.filter({ $0.firstAttribute == NSLayoutConstraint.Attribute.bottom }).forEach { $0.isActive = true }

                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.view.layoutIfNeeded()
                }, completion: { _ in
                    self.beamSubmodelView.isHidden = false
                    self.beamInitialTwistCurvaturesView.isHidden = false
                    self.beamObliqueCrossSectionView.isHidden = false
                })

            } else if self.analysisSettings.structuralModel == .plate {
                if self.analysisSettings.structuralSubmodel != .KirchhoffLovePlateShellModel && self.analysisSettings.structuralSubmodel != .ReissnerMindlinPlateShellModel {
                    self.analysisSettings.structuralSubmodel = .KirchhoffLovePlateShellModel
                }

                self.beamSubmodelView.isHidden = true

                self.structuralModelView.constraints.filter({ $0.firstAttribute == NSLayoutConstraint.Attribute.bottom }).forEach { $0.isActive = false }
                self.structuralModelLabelButton.bottomAnchor.constraint(equalTo: self.structuralModelView.bottomAnchor, constant: -12).isActive = false
                self.plateInitialCurvaturesView.bottomAnchor.constraint(equalTo: self.structuralModelView.bottomAnchor, constant: -12).isActive = true
                self.beamObliqueCrossSectionView.bottomAnchor.constraint(equalTo: self.structuralModelView.bottomAnchor, constant: -12).isActive = false
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

        methodDataBaseAlterController.addAction(m0)

        let s0 = UIAlertAction(title: "Beam Model", style: UIAlertAction.Style.default) { [weak self] (_) -> Void in

            guard let self = self else { return }

            self.structuralModelLabelButton.setTitle("Beam Model", for: .normal)
            self.structuralModelLabelButton.layoutIfNeeded()

            self.analysisSettings.structuralModel = .beam
            self.beamSubmodelLabelButton.setTitle("Euler-Bernoulli Model", for: .normal)
            self.analysisSettings.structuralSubmodel = .EulerBernoulliBeamModel

            self.analysisSettings.typeOfAnalysis = .elastic
            self.typeOfAnalysisLabelButton.setTitle("Elastic Analysis", for: .normal)

            self.plateSubmodelView.isHidden = true
            self.plateInitialCurvaturesView.isHidden = true

            self.structuralModelView.constraints.filter({ $0.firstAttribute == NSLayoutConstraint.Attribute.bottom }).forEach { $0.isActive = false }
            self.structuralModelLabelButton.bottomAnchor.constraint(equalTo: self.structuralModelView.bottomAnchor, constant: -12).isActive = false
            self.plateInitialCurvaturesView.bottomAnchor.constraint(equalTo: self.structuralModelView.bottomAnchor, constant: -12).isActive = false
            self.beamObliqueCrossSectionView.bottomAnchor.constraint(equalTo: self.structuralModelView.bottomAnchor, constant: -12).isActive = true
            self.structuralModelView.constraints.filter({ $0.firstAttribute == NSLayoutConstraint.Attribute.bottom }).forEach { $0.isActive = true }

            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: { _ in
                self.beamSubmodelView.isHidden = false
                self.beamInitialTwistCurvaturesView.isHidden = false
                self.beamObliqueCrossSectionView.isHidden = false
            })
        }

        let s1 = UIAlertAction(title: "Plate Model", style: UIAlertAction.Style.default) { [weak self] (_) -> Void in

            guard let self = self else { return }

            self.structuralModelLabelButton.setTitle("Plate Model", for: .normal)
            self.structuralModelLabelButton.layoutIfNeeded()

            self.analysisSettings.structuralModel = .plate
            self.plateSubmodelLabelButton.setTitle("Kirchho-Love Model", for: .normal)
            self.analysisSettings.structuralSubmodel = .KirchhoffLovePlateShellModel

            self.beamSubmodelView.isHidden = true
            self.beamInitialTwistCurvaturesView.isHidden = true
            self.beamObliqueCrossSectionView.isHidden = true

            self.structuralModelView.constraints.filter({ $0.firstAttribute == NSLayoutConstraint.Attribute.bottom }).forEach { $0.isActive = false }
            self.structuralModelLabelButton.bottomAnchor.constraint(equalTo: self.structuralModelView.bottomAnchor, constant: -12).isActive = false
            self.plateInitialCurvaturesView.bottomAnchor.constraint(equalTo: self.structuralModelView.bottomAnchor, constant: -12).isActive = true
            self.beamObliqueCrossSectionView.bottomAnchor.constraint(equalTo: self.structuralModelView.bottomAnchor, constant: -12).isActive = false
            self.structuralModelView.constraints.filter({ $0.firstAttribute == NSLayoutConstraint.Attribute.bottom }).forEach { $0.isActive = true }

            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: { _ in
                self.plateSubmodelView.isHidden = false
                self.plateInitialCurvaturesView.isHidden = false
            })
        }

        let s2 = UIAlertAction(title: "Solid Model", style: UIAlertAction.Style.default) { [weak self] (_) -> Void in

            guard let self = self else { return }

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

                self.structuralModelView.constraints.filter({ $0.firstAttribute == NSLayoutConstraint.Attribute.bottom }).forEach { $0.isActive = false }
                self.structuralModelLabelButton.bottomAnchor.constraint(equalTo: self.structuralModelView.bottomAnchor, constant: -12).isActive = true
                self.plateInitialCurvaturesView.bottomAnchor.constraint(equalTo: self.structuralModelView.bottomAnchor, constant: -12).isActive = false
                self.beamObliqueCrossSectionView.bottomAnchor.constraint(equalTo: self.structuralModelView.bottomAnchor, constant: -12).isActive = false
                self.structuralModelView.constraints.filter({ $0.firstAttribute == NSLayoutConstraint.Attribute.bottom }).forEach { $0.isActive = true }

                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }
        }

        let s2ROM = UIAlertAction(title: "Solid Model", style: UIAlertAction.Style.default) { [weak self] (_) -> Void in

            guard let self = self else { return }

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

                self.structuralModelView.constraints.filter({ $0.firstAttribute == NSLayoutConstraint.Attribute.bottom }).forEach { $0.isActive = false }
                self.structuralModelLabelButton.bottomAnchor.constraint(equalTo: self.structuralModelView.bottomAnchor, constant: -12).isActive = true
                self.plateInitialCurvaturesView.bottomAnchor.constraint(equalTo: self.structuralModelView.bottomAnchor, constant: -12).isActive = false
                self.beamObliqueCrossSectionView.bottomAnchor.constraint(equalTo: self.structuralModelView.bottomAnchor, constant: -12).isActive = false
                self.structuralModelView.constraints.filter({ $0.firstAttribute == NSLayoutConstraint.Attribute.bottom }).forEach { $0.isActive = true }

                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }
        }

        structuralModelDataBaseAlterController.addAction(s0)
        structuralModelDataBaseAlterController.addAction(s1)
        structuralModelDataBaseAlterController.addAction(s2)

        structuralModelDataBaseAlterControllerNonSwiftComp.addAction(s2ROM)

        let subBeam0 = UIAlertAction(title: "Euler-Bernoulli Model", style: UIAlertAction.Style.default) { [weak self] (_) -> Void in
            guard let self = self else { return }
            self.beamSubmodelLabelButton.setTitle("Euler-Bernoulli Model", for: .normal)
            self.analysisSettings.structuralSubmodel = .EulerBernoulliBeamModel
        }

        let subBeam1 = UIAlertAction(title: "Timoshenko Model", style: UIAlertAction.Style.default) { [weak self] (_) -> Void in
            guard let self = self else { return }
            self.beamSubmodelLabelButton.setTitle("Timoshenko Model", for: .normal)
            self.analysisSettings.structuralSubmodel = .TimoshenkoBeamModel
        }

        beamSubmodelDataBaseAlterController.addAction(subBeam0)
        beamSubmodelDataBaseAlterController.addAction(subBeam1)

        let subPlate0 = UIAlertAction(title: "Kirchho-Love Model", style: UIAlertAction.Style.default) { [weak self] (_) -> Void in
            guard let self = self else { return }
            self.plateSubmodelLabelButton.setTitle("Kirchho-Love Model", for: .normal)
            self.analysisSettings.structuralSubmodel = .KirchhoffLovePlateShellModel
        }

        let subPlate1 = UIAlertAction(title: "Reissner-Mindlin Model", style: UIAlertAction.Style.default) { [weak self] (_) -> Void in
            guard let self = self else { return }
            self.plateSubmodelLabelButton.setTitle("Reissner-Mindlin Model", for: .normal)
            self.analysisSettings.structuralSubmodel = .ReissnerMindlinPlateShellModel
        }

        plateSubmodelDataBaseAlterController.addAction(subPlate0)
        plateSubmodelDataBaseAlterController.addAction(subPlate1)

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

        let t0beam = UIAlertAction(title: "Elastic Analysis", style: UIAlertAction.Style.default) { [weak self] (_) -> Void in
            guard let self = self else { return }
            self.typeOfAnalysisLabelButton.setTitle("Elastic Analysis", for: .normal)
            self.analysisSettings.typeOfAnalysis = .elastic
            self.changeTypeOfAnalysis(typeOfAnalysis: .elastic)
        }

        typeOfAnalysisDataBaseAlterControllerBeam.addAction(t0beam)
    }

    func changeTypeOfAnalysis(typeOfAnalysis: TypeOfAnalysis) {
        createMaterialCard(materialCard: &coreMaterialCard, materialName: coreMaterialNameLabel, label: &coreMaterialPropertiesLabel, value: &coreMaterialPropertiesTextField, aboveConstraint: coreMaterialTypeSegementedControl.bottomAnchor, under: coreMaterialView, typeOfAnalysis: typeOfAnalysis, materialType: coreMaterialType)

        coreMaterialCard.bottomAnchor.constraint(equalTo: coreMaterialView.bottomAnchor, constant: -12).isActive = true

        changeCoreMaterialDataField()

        createMaterialCard(materialCard: &laminaMaterialCard, materialName: laminaMaterialNameLabel, label: &laminaMaterialPropertiesLabel, value: &laminaMaterialPropertiesTextField, aboveConstraint: laminaMaterialTypeSegementedControl.bottomAnchor, under: laminaMaterialView, typeOfAnalysis: typeOfAnalysis, materialType: laminaMaterialType)

        laminaMaterialCard.bottomAnchor.constraint(equalTo: laminaMaterialView.bottomAnchor, constant: -12).isActive = true

        changeLaminaMaterialDataField()
    }

    // MARK: Load core data

    func loadCoreData() {
        do {
            userSavedStackingSequences = try context.fetch(UserStackingSequence.fetchRequest())
        } catch {
            print("Could not load stacking sequence data from database \(error.localizedDescription)")
        }

        do {
            userSavedCoreMaterials = try context.fetch(UserCoreMaterial.fetchRequest())
        } catch {
            print("Could not load core material from database \(error.localizedDescription)")
        }

        do {
            userSavedLaminaMaterials = try context.fetch(UserLaminaMaterial.fetchRequest())
        } catch {
            print("Could not load material data from database \(error.localizedDescription)")
        }
    }

    // get parameters

    override func getCalculationParameters() -> GetParametersStatus {
        analysisSettings.compositeModelName = .HoneycombSandwich

        (k12_plate, k21_plate) = (0.0, 0.0)
        (k11_beam, k12_beam, k13_beam) = (0.0, 0.0, 0.0)
        (cos_angle1, cos_angle2) = (1.0, 0.0)

        coreLength = 0.0
        coreThickness = 0.0
        coreHeight = 0.0

        layupSequence = [Double]()
        layerThickness = 0.0

        (ec1, ec2, ec3, gc12, gc13, gc23, nuc12, nuc13, nuc23) = (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
        (alphac11, alphac22, alphac33, alphac23, alphac13, alphac12) = (0.0, 0.0, 0.0, 0.0, 0.0, 0.0)

        (e1, e2, e3, g12, g13, g23, nu12, nu13, nu23) = (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
        (c11, c12, c13, c14, c15, c16, c22, c23, c24, c25, c26, c33, c34, c35, c36, c44, c45, c46, c55, c56, c66) = (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
        (alpha11, alpha22, alpha33, alpha23, alpha13, alpha12) = (0.0, 0.0, 0.0, 0.0, 0.0, 0.0)

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

        // core geometry

        guard let coreLengthGuard = Double(coreLengthTextField.text ?? ""), let coreThicknessGuard = Double(coreThicknessTextField.text ?? ""), let coreHeightGuard = Double(coreHeightTextField.text ?? "") else {
            return .wrongCoreGeometryLength
        }

        if coreLengthGuard == 0.0 || coreThicknessGuard == 0.0 || coreHeightGuard == 0.0 {
            return .wrongCoreGeometryLength
        }

        let ratio1 = coreLengthGuard / coreThicknessGuard
        let ratio2 = coreHeightGuard / coreLengthGuard

        if ratio1 < 2.0 || ratio1 > 100.0 || ratio2 > 20.0 {
            return .wrongCoreGeometryLength
        }

        coreLength = coreLengthGuard
        coreThickness = coreThicknessGuard
        coreHeight = coreHeightGuard

        // laminate geometry

        layupSequence = getlayupSequence(textFieldValue: stackingSequenceTextField.text ?? "")

        if layupSequence == [] {
            return .wrongStackingSequence
        }

        if layupSequence.count > 6 {
            return .tooManyLayers
        }

        guard let tGuard = Double(laminaThicknessTextField.text!) else {
            return .wrongLayerThickness
        }
        if tGuard == 0.0 {
            return .wrongLayerThickness
        }

        layerThickness = tGuard

        if layerThickness >= coreHeight {
            return .wrongLayerThickness
        }

        // core material parameters

        if coreMaterialType == .isotropic {
            guard let ec1Guard = Double(coreMaterialPropertiesTextField[0].text!), let nuc12Guard = Double(coreMaterialPropertiesTextField[1].text!) else {
                return .wrongMaterialValue
            }

            if nuc12Guard == -1 {
                return .wrongNuValue
            }

            (ec1, ec2, ec3, gc12, gc13, gc23, nuc12, nuc13, nuc23) = (ec1Guard, ec1Guard, ec1Guard, ec1Guard / (2 * (1 + nuc12Guard)), ec1Guard / (2 * (1 + nuc12Guard)), ec1Guard / (2 * (1 + nuc12Guard)), nuc12Guard, nuc12Guard, nuc12Guard)

            if analysisSettings.typeOfAnalysis == .thermoElastic {
                guard let alphac11Guard = Double(coreMaterialPropertiesTextField[2].text!) else {
                    return .wrongCTEValue
                }
                (alphac11, alphac22, alphac33, alphac23, alphac13, alphac12) = (alphac11Guard, alphac11Guard, alphac11Guard, 0, 0, 0)
            }

        } else if coreMaterialType == .transverselyIsotropic {
            guard let ec1Guard = Double(coreMaterialPropertiesTextField[0].text!), let ec2Guard = Double(coreMaterialPropertiesTextField[1].text!), let gc12Guard = Double(coreMaterialPropertiesTextField[2].text!), let nuc12Guard = Double(coreMaterialPropertiesTextField[3].text!), let nuc23Guard = Double(coreMaterialPropertiesTextField[4].text!) else {
                return .wrongMaterialValue
            }

            if nuc23Guard == -1 {
                return .wrongNuValue
            }

            let ec3Guard = ec2Guard
            let gc13Guard = gc12Guard
            let gc23Guard = ec2Guard / (2 * (1 + nuc23Guard))
            let nuc13Guard = nuc12Guard

            (ec1, ec2, ec3, gc12, gc13, gc23, nuc12, nuc13, nuc23) = (ec1Guard, ec2Guard, ec3Guard, gc12Guard, gc13Guard, gc23Guard, nuc12Guard, nuc13Guard, nuc23Guard)

            if analysisSettings.typeOfAnalysis == .thermoElastic {
                guard let alphac11Guard = Double(coreMaterialPropertiesTextField[5].text!), let alphac22Guard = Double(coreMaterialPropertiesTextField[6].text!) else {
                    return .wrongCTEValue
                }
                (alphac11, alphac22, alphac33, alphac23, alphac13, alphac12) = (alphac11Guard, alphac22Guard, alphac22Guard, 0, 0, 0)
            }

        } else if coreMaterialType == .orthotropic {
            guard let ec1Guard = Double(coreMaterialPropertiesTextField[0].text!), let ec2Guard = Double(coreMaterialPropertiesTextField[1].text!), let ec3Guard = Double(coreMaterialPropertiesTextField[2].text!), let gc12Guard = Double(coreMaterialPropertiesTextField[3].text!), let gc13Guard = Double(coreMaterialPropertiesTextField[4].text!), let gc23Guard = Double(coreMaterialPropertiesTextField[5].text!), let nuc12Guard = Double(coreMaterialPropertiesTextField[6].text!), let nuc13Guard = Double(coreMaterialPropertiesTextField[7].text!), let nuc23Guard = Double(coreMaterialPropertiesTextField[8].text!) else {
                return .wrongMaterialValue
            }

            (ec1, ec2, ec3, gc12, gc13, gc23, nuc12, nuc13, nuc23) = (ec1Guard, ec2Guard, ec3Guard, gc12Guard, gc13Guard, gc23Guard, nuc12Guard, nuc13Guard, nuc23Guard)

            if analysisSettings.typeOfAnalysis == .thermoElastic {
                guard let alphac11Guard = Double(coreMaterialPropertiesTextField[9].text!), let alphac22Guard = Double(coreMaterialPropertiesTextField[10].text!), let alphac33Guard = Double(coreMaterialPropertiesTextField[11].text!) else {
                    return .wrongCTEValue
                }
                (alphac11, alphac22, alphac33, alphac23, alphac13, alphac12) = (alphac11Guard, alphac22Guard, alphac33Guard, 0, 0, 0)
            }
        }

        // lamina material parameters

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

    // calculate result by SwiftComp

    override func calculateResultBySwiftComp() -> swiftcompCalculationStatus {
        var typeOfAnalysisValue: String = "Elastic"
        var structuralModelValue: String = "Plate"
        var structuralSubmodelValue: String = "KirchhoffLovePlateShellModel"
        var stackingSequenceValue: String = ""
        var coreMaterialTypeValue: String = "Isotropic"
        var coreMaterialPropertiesValue: String = ""
        var laminaMaterialTypeValue: String = "Orthotropic"
        var laminaMaterialPropertiesValue: String = ""

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

        API_URL = "\(Constant.baseURL)/honeycombSandwich/homogenization?typeOfAnalysis=\(typeOfAnalysisValue)&structuralModel=\(structuralModelValue)"

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

        API_URL += "&coreLength=\(coreLength)&coreThickness=\(coreThickness)&coreHeight=\(coreHeight)"

        layupSequence.forEach { angle in
            stackingSequenceValue.append(String(angle) + " ")
        }

        _ = stackingSequenceValue.popLast()

        API_URL += "&stackingSequence=\(stackingSequenceValue)&layerThickness=\(layerThickness)"

        coreMaterialTypeValue = "Orthotropic"

        coreMaterialPropertiesValue = "Ec1=\(ec1)&Ec2=\(ec2)&Ec3=\(ec3)&Gc12=\(gc12)&Gc13=\(gc13)&Gc23=\(gc23)&nuc12=\(nuc12)&nuc13=\(nuc13)&nuc23=\(nuc23)"

        if laminaMaterialType != .anisotropic {
            laminaMaterialTypeValue = "Orthotropic"

            laminaMaterialPropertiesValue = "El1=\(e1)&El2=\(e2)&El3=\(e3)&Gl12=\(g12)&Gl13=\(g13)&Gl23=\(g23)&nul12=\(nu12)&nul13=\(nu13)&nul23=\(nu23)"

        } else {
            laminaMaterialTypeValue = "Anisotropic"

            laminaMaterialPropertiesValue = "Cl11=\(c11)&Cl12=\(c12)&Cl13=\(c13)&Cl14=\(c14)&Cl15=\(c15)&Cl16=\(c16)&Cl22=\(c22)&Cl23=\(c23)&Cl33=\(c23)&Cl24=\(c24)&Cl25=\(c25)&Cl26=\(c26)&Cl33=\(c33)&Cl34=\(c34)&Cl35=\(c35)&Cl36=\(c36)&Cl44=\(c44)&Cl45=\(c45)&Cl46=\(c46)&Cl55=\(c55)&Cl56=\(c56)&Cl66=\(c66)"
        }

        if analysisSettings.typeOfAnalysis == .thermoElastic {
            coreMaterialPropertiesValue += "&alphac11=\(alphac11)&alphac22=\(alphac22)&alphac33=\(alphac33)&alphac23=\(alphac23)&alphac13=\(alphac13)&alphac12=\(alphac12)"
            laminaMaterialPropertiesValue += "&alphal11=\(alpha11)&alphal22=\(alpha22)&alphal33=\(alpha33)&alphal23=\(alpha23)&alphal13=\(alpha13)&alphal12=\(alpha12)"
        }

        API_URL += "&coreMaterialType=\(coreMaterialTypeValue)&\(coreMaterialPropertiesValue)&laminaMaterialType=\(laminaMaterialTypeValue)&\(laminaMaterialPropertiesValue)"

        let group = DispatchGroup()

        group.enter()

        fetchSwiftCompHomogenizationResultJSON(API_URL: API_URL, timeoutIntervalForRequest: 30) { res in
            switch res {
            case let .success(result):

                self.resultData.swiftcompCwd = result.swiftcompCwd

                self.resultData.swiftcompCalculationInfo = result.swiftcompCalculationInfo

                if self.analysisSettings.structuralModel == .beam {
                    self.resultData.effectiveBeamStiffness4by4[0] = Double(result.beamModelResult.effectiveBeamStiffness4by4.S11) ?? 0
                    self.resultData.effectiveBeamStiffness4by4[1] = Double(result.beamModelResult.effectiveBeamStiffness4by4.S12) ?? 0
                    self.resultData.effectiveBeamStiffness4by4[2] = Double(result.beamModelResult.effectiveBeamStiffness4by4.S13) ?? 0
                    self.resultData.effectiveBeamStiffness4by4[3] = Double(result.beamModelResult.effectiveBeamStiffness4by4.S14) ?? 0

                    self.resultData.effectiveBeamStiffness4by4[4] = Double(result.beamModelResult.effectiveBeamStiffness4by4.S12) ?? 0
                    self.resultData.effectiveBeamStiffness4by4[5] = Double(result.beamModelResult.effectiveBeamStiffness4by4.S22) ?? 0
                    self.resultData.effectiveBeamStiffness4by4[6] = Double(result.beamModelResult.effectiveBeamStiffness4by4.S23) ?? 0
                    self.resultData.effectiveBeamStiffness4by4[7] = Double(result.beamModelResult.effectiveBeamStiffness4by4.S24) ?? 0

                    self.resultData.effectiveBeamStiffness4by4[8] = Double(result.beamModelResult.effectiveBeamStiffness4by4.S13) ?? 0
                    self.resultData.effectiveBeamStiffness4by4[9] = Double(result.beamModelResult.effectiveBeamStiffness4by4.S23) ?? 0
                    self.resultData.effectiveBeamStiffness4by4[10] = Double(result.beamModelResult.effectiveBeamStiffness4by4.S33) ?? 0
                    self.resultData.effectiveBeamStiffness4by4[11] = Double(result.beamModelResult.effectiveBeamStiffness4by4.S34) ?? 0

                    self.resultData.effectiveBeamStiffness4by4[12] = Double(result.beamModelResult.effectiveBeamStiffness4by4.S14) ?? 0
                    self.resultData.effectiveBeamStiffness4by4[13] = Double(result.beamModelResult.effectiveBeamStiffness4by4.S24) ?? 0
                    self.resultData.effectiveBeamStiffness4by4[14] = Double(result.beamModelResult.effectiveBeamStiffness4by4.S34) ?? 0
                    self.resultData.effectiveBeamStiffness4by4[15] = Double(result.beamModelResult.effectiveBeamStiffness4by4.S44) ?? 0

                    self.resultData.effectiveBeamStiffness6by6[0] = Double(result.beamModelResult.effectiveBeamStiffness6by6.S11) ?? 0
                    self.resultData.effectiveBeamStiffness6by6[1] = Double(result.beamModelResult.effectiveBeamStiffness6by6.S12) ?? 0
                    self.resultData.effectiveBeamStiffness6by6[2] = Double(result.beamModelResult.effectiveBeamStiffness6by6.S13) ?? 0
                    self.resultData.effectiveBeamStiffness6by6[3] = Double(result.beamModelResult.effectiveBeamStiffness6by6.S14) ?? 0
                    self.resultData.effectiveBeamStiffness6by6[4] = Double(result.beamModelResult.effectiveBeamStiffness6by6.S15) ?? 0
                    self.resultData.effectiveBeamStiffness6by6[5] = Double(result.beamModelResult.effectiveBeamStiffness6by6.S16) ?? 0

                    self.resultData.effectiveBeamStiffness6by6[6] = Double(result.beamModelResult.effectiveBeamStiffness6by6.S12) ?? 0
                    self.resultData.effectiveBeamStiffness6by6[7] = Double(result.beamModelResult.effectiveBeamStiffness6by6.S22) ?? 0
                    self.resultData.effectiveBeamStiffness6by6[8] = Double(result.beamModelResult.effectiveBeamStiffness6by6.S23) ?? 0
                    self.resultData.effectiveBeamStiffness6by6[9] = Double(result.beamModelResult.effectiveBeamStiffness6by6.S24) ?? 0
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

extension HoneycombSandwichController: LaminateStackingSequenceDataBaseDelegate {
    func userTypeStackingSequenceDataBase(stackingSequence: String) {
        stackingSequenceNameLabel.text = stackingSequence
        changeStackingSequenceDataField()
        generateLayupFigure()
    }
}

extension HoneycombSandwichController: CoreMaterialDataBaseDelegate {
    func userTypeCoreMaterialDataBase(materialName: String) {
        coreMaterialNameLabel.text = materialName
        determineCoreMaterialType()
        changeCoreMaterialType()
        changeCoreMaterialDataField()
    }
}

extension HoneycombSandwichController: LaminateMaterialDataBaseDelegate {
    func userTypeLaminaMaterialDataBase(materialName: String) {
        laminaMaterialNameLabel.text = materialName
        determineLaminaMaterialType()
        changeLaminaMaterialType()
        changeLaminaMaterialDataField()
    }
}
