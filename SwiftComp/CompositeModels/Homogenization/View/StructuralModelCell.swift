//
//  MethodCell.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 11/21/19.
//  Copyright © 2119 Banghua Zhao. All rights reserved.
//

import UIKit

protocol StructuralModelCellDelegate: AnyObject {
    func changeStructuralModel(button: SCAnalysisButton)
    func changeBeamStructuralSubmodel(button: SCAnalysisButton)
    func changePlateStructuralSubmodel(button: SCAnalysisButton)
}

class StructuralModelCell: UITableViewCell {
    // MARK: - model

    var structuralModel: StructuralModel? {
        didSet {
            switch structuralModel?.model {
            case .beam(.eulerBernoulli):
                analysisButton.changeButtonTitle(title: Constant.ModelName.beam)
                beamAnalysisButton.changeButtonTitle(title: Constant.SubmodelName.Beam.eulerBernoulli)
                cellView.snp.updateConstraints { make in
                    make.height.equalTo(CellHeight.fourSection)
                }
                showBeamSubmodel()
            case .beam(.timoshenko):
                analysisButton.changeButtonTitle(title: Constant.ModelName.beam)
                beamAnalysisButton.changeButtonTitle(title: Constant.SubmodelName.Beam.timoshenko)
                cellView.snp.updateConstraints { make in
                    make.height.equalTo(CellHeight.fourSection)
                }
                showBeamSubmodel()
            case .plate(.kirchhoffLove):
                analysisButton.changeButtonTitle(title: Constant.ModelName.plate)
                plateAnalysisButton.changeButtonTitle(title: Constant.SubmodelName.Plate.kirchhoffLove)
                cellView.snp.updateConstraints { make in
                    make.height.equalTo(CellHeight.threeSection)
                }
                showPlateSubmodel()
            case .plate(.reissnerMindlin):
                analysisButton.changeButtonTitle(title: Constant.ModelName.plate)
                plateAnalysisButton.changeButtonTitle(title: Constant.SubmodelName.Plate.reissnerMindlin)
                cellView.snp.updateConstraints { make in
                    make.height.equalTo(CellHeight.threeSection)
                }
                showPlateSubmodel()
            case .solid(.cauchyContinuum):
                analysisButton.changeButtonTitle(title: Constant.ModelName.solid)
                cellView.snp.updateConstraints { make in
                    make.height.equalTo(CellHeight.oneSection)
                }
                hideSubmodel()
            default:
                return
            }
            platek12TextField.text = structuralModel?.plateExtraInput.k12Text
            platek21TextField.text = structuralModel?.plateExtraInput.k21Text
            beamk11TextField.text = structuralModel?.beamExtraInput.k11Text
            beamk12TextField.text = structuralModel?.beamExtraInput.k12Text
            beamk13TextField.text = structuralModel?.beamExtraInput.k13Text
            beamCosAngle1TextField.text = structuralModel?.beamExtraInput.cosAngle1Text
            beamCosAngle2TextField.text = structuralModel?.beamExtraInput.cosAngle2Text
            platek12TextField.textColor = structuralModel?.plateExtraInput.k12 != nil ? .SCTitle : .red
            platek21TextField.textColor = structuralModel?.plateExtraInput.k21 != nil ? .SCTitle : .red
            beamk11TextField.textColor = structuralModel?.beamExtraInput.k11 != nil ? .SCTitle : .red
            beamk12TextField.textColor = structuralModel?.beamExtraInput.k12 != nil ? .SCTitle : .red
            beamk13TextField.textColor = structuralModel?.beamExtraInput.k13 != nil ? .SCTitle : .red
            beamCosAngle1TextField.textColor = structuralModel?.beamExtraInput.cosAngle1 != nil ? .SCTitle : .red
            beamCosAngle2TextField.textColor = structuralModel?.beamExtraInput.cosAngle2 != nil ? .SCTitle : .red
        }
    }

    weak var delegate: StructuralModelCellDelegate?

    private struct CellHeight {
        static let oneSection = 16 + 21 + 16 + 36 + 16
        static let twoSection = oneSection + 1 + oneSection
        static let parameterSection = 16 + 21 + 16 + 21 + 16
        static let threeSection = twoSection + 1 + parameterSection
        static let fourSection = threeSection + 1 + parameterSection
    }

    // MARK: - first section

    private lazy var spaceView: UIView = {
        let view = UIView()
        return view
    }()

    private lazy var cellView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .SCTitle
        label.text = "Structural Model"
        label.font = .SCTitle
        label.textAlignment = .left
        return label
    }()

    private lazy var analysisButton = SCAnalysisButton()

    // MARK: - beam submodel

    private lazy var beamSeparator1: UIView = {
        let view = UIView()
        view.backgroundColor = .SCSeparator
        return view
    }()

    private lazy var beamTitleLabel1: UILabel = {
        let label = UILabel()
        label.textColor = .SCTitle
        label.text = "Beam Submodel"
        label.font = .SCTitle
        label.textAlignment = .left
        return label
    }()

    private lazy var beamAnalysisButton = SCAnalysisButton()

    private lazy var beamSeparator2: UIView = {
        let view = UIView()
        view.backgroundColor = .SCSeparator
        return view
    }()

    private lazy var beamTitleLabel2: UILabel = {
        let label = UILabel()
        label.textColor = .SCTitle
        label.text = "Beam Initial Twist/Curvatures"
        label.font = .SCTitle
        label.textAlignment = .left
        return label
    }()

    private lazy var beamk11Label: UILabel = {
        let label = UILabel()
        label.textColor = .SCTitle
        label.text = "k₁₁"
        label.font = .SCParameterLabel
        return label
    }()

    private lazy var beamk11TextField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .right
        textField.textColor = .SCTitle
        textField.placeholder = "Input"
        textField.font = .SCParameterLabel
        textField.text = "0.0"
        textField.keyboardType = UIKeyboardType.numbersAndPunctuation
        textField.addTarget(self, action: #selector(beamk11TextFieldEditingChanged(_:)), for: .editingChanged)
        return textField
    }()

    lazy var beamVerticalSeparatror1: UIView = {
        let view = UIView()
        view.backgroundColor = .SCSeparator
        return view
    }()

    private lazy var beamk12Label: UILabel = {
        let label = UILabel()
        label.textColor = .SCTitle
        label.text = "k₁₂"
        label.font = .SCParameterLabel
        return label
    }()

    private lazy var beamk12TextField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .right
        textField.textColor = .SCTitle
        textField.placeholder = "Input"
        textField.font = .SCParameterLabel
        textField.text = "0.0"
        textField.keyboardType = UIKeyboardType.numbersAndPunctuation
        textField.addTarget(self, action: #selector(beamk13TextFieldEditingChanged(_:)), for: .editingChanged)

        return textField
    }()

    lazy var beamVerticalSeparatror2: UIView = {
        let view = UIView()
        view.backgroundColor = .SCSeparator
        return view
    }()

    private lazy var beamk13Label: UILabel = {
        let label = UILabel()
        label.textColor = .SCTitle
        label.text = "k₁₃"
        label.font = .SCParameterLabel
        return label
    }()

    private lazy var beamk13TextField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .right
        textField.textColor = .SCTitle
        textField.placeholder = "Input"
        textField.font = .SCParameterLabel
        textField.text = "0.0"
        textField.keyboardType = UIKeyboardType.numbersAndPunctuation
        textField.addTarget(self, action: #selector(beamk13TextFieldEditingChanged(_:)), for: .editingChanged)
        return textField
    }()

    private lazy var beamSeparator3: UIView = {
        let view = UIView()
        view.backgroundColor = .SCSeparator
        return view
    }()

    private lazy var beamTitleLabel3: UILabel = {
        let label = UILabel()
        label.textColor = .SCTitle
        label.text = "Beam Oblique Cross Section"
        label.font = .SCTitle
        label.textAlignment = .left
        return label
    }()

    private lazy var beamCosAngle1Label: UILabel = {
        let label = UILabel()
        label.textColor = .SCTitle
        label.text = "cos(angle1)"
        label.font = .SCParameterLabel
        return label
    }()

    private lazy var beamCosAngle1TextField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .right
        textField.textColor = .SCTitle
        textField.placeholder = "Input"
        textField.font = .SCParameterLabel
        textField.text = "1.0"
        textField.keyboardType = UIKeyboardType.numbersAndPunctuation
        textField.addTarget(self, action: #selector(beamCosAngle1TextFieldEditingChanged(_:)), for: .editingChanged)
        return textField
    }()

    lazy var beamVerticalSeparatror3: UIView = {
        let view = UIView()
        view.backgroundColor = .SCSeparator
        return view
    }()

    private lazy var beamCosAngle2Label: UILabel = {
        let label = UILabel()
        label.textColor = .SCTitle
        label.text = "cos(angle2)"
        label.font = .SCParameterLabel
        return label
    }()

    private lazy var beamCosAngle2TextField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .right
        textField.textColor = .SCTitle
        textField.placeholder = "Input"
        textField.font = .SCParameterLabel
        textField.text = "0.0"
        textField.keyboardType = UIKeyboardType.numbersAndPunctuation
        textField.addTarget(self, action: #selector(beamCosAngle2TextFieldEditingChanged(_:)), for: .editingChanged)
        return textField
    }()

    // MARK: - plate submodel

    private lazy var plateSeparator1: UIView = {
        let view = UIView()
        view.backgroundColor = .SCSeparator
        return view
    }()

    private lazy var plateTitleLabel1: UILabel = {
        let label = UILabel()
        label.textColor = .SCTitle
        label.text = "Plate Submodel"
        label.font = .SCTitle
        label.textAlignment = .left
        return label
    }()

    private lazy var plateAnalysisButton = SCAnalysisButton()

    private lazy var plateSeparator2: UIView = {
        let view = UIView()
        view.backgroundColor = .SCSeparator
        return view
    }()

    private lazy var plateTitleLabel2: UILabel = {
        let label = UILabel()
        label.textColor = .SCTitle
        label.text = "Plate Initial Curvatures"
        label.font = .SCTitle
        label.textAlignment = .left
        return label
    }()

    private lazy var platek12Label: UILabel = {
        let label = UILabel()
        label.textColor = .SCTitle
        label.text = "k₁₂"
        label.font = .SCParameterLabel
        return label
    }()

    private lazy var platek12TextField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .right
        textField.textColor = .SCTitle
        textField.placeholder = "Input Number"
        textField.font = .SCParameterLabel
        textField.text = "0.0"
        textField.keyboardType = UIKeyboardType.numbersAndPunctuation
        textField.addTarget(self, action: #selector(platek12TextFieldEditingChanged(_:)), for: .editingChanged)
        return textField
    }()

    lazy var plateVerticalSeparatror: UIView = {
        let view = UIView()
        view.backgroundColor = .SCSeparator
        return view
    }()

    private lazy var platek21Label: UILabel = {
        let label = UILabel()
        label.textColor = .SCTitle
        label.text = "k₂₁"
        label.font = .SCParameterLabel
        return label
    }()

    private lazy var platek21TextField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .right
        textField.textColor = .SCTitle
        textField.placeholder = "Input Number"
        textField.font = .SCParameterLabel
        textField.text = "0.0"
        textField.keyboardType = UIKeyboardType.numbersAndPunctuation
        textField.addTarget(self, action: #selector(platek21TextFieldEditingChanged(_:)), for: .editingChanged)
        return textField
    }()

    // MARK: - life cycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        analysisButton.addTarget(self, action: #selector(analysisButtonTapped(button:)), for: .touchUpInside)
        backgroundColor = .clear
        selectionStyle = .none
        setupView()
        setupBeamSubmodelView()
        setupPlateSubmodelView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - private functions

extension StructuralModelCell {
    private func setupView() {
        addSubview(spaceView)
        addSubview(cellView)

        spaceView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalToSuperview()
            make.height.equalTo(20)
        }

        cellView.snp.makeConstraints { make in
            make.top.equalTo(spaceView.snp.bottom)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(CellHeight.oneSection)
            make.bottom.equalToSuperview().priority(999)
        }

        cellView.addSubview(titleLabel)
        cellView.addSubview(analysisButton)

        titleLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(16)
            make.height.equalTo(21)
        }

        analysisButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
        }
    }

    // MARK: - setupBeamSubmodelView

    private func setupBeamSubmodelView() {
        beamAnalysisButton.addTarget(self, action: #selector(beamAnalysisButtonTapped(button:)), for: .touchUpInside)
        cellView.addSubview(beamSeparator1)
        cellView.addSubview(beamTitleLabel1)
        cellView.addSubview(beamAnalysisButton)
        cellView.addSubview(beamSeparator2)
        cellView.addSubview(beamTitleLabel2)
        cellView.addSubview(beamk11Label)
        cellView.addSubview(beamk11TextField)
        cellView.addSubview(beamVerticalSeparatror1)
        cellView.addSubview(beamk12Label)
        cellView.addSubview(beamk12TextField)
        cellView.addSubview(beamVerticalSeparatror2)
        cellView.addSubview(beamk13Label)
        cellView.addSubview(beamk13TextField)
        cellView.addSubview(beamSeparator3)
        cellView.addSubview(beamTitleLabel3)
        cellView.addSubview(beamCosAngle1Label)
        cellView.addSubview(beamCosAngle1TextField)
        cellView.addSubview(beamVerticalSeparatror3)
        cellView.addSubview(beamCosAngle2Label)
        cellView.addSubview(beamCosAngle2TextField)
        beamSeparator1.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(1)
            make.top.equalTo(self.analysisButton.snp.bottom).offset(16)
        }
        beamTitleLabel1.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(self.beamSeparator1.snp.bottom).offset(16)
            make.height.equalTo(21)
        }
        beamAnalysisButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(self.beamTitleLabel1.snp.bottom).offset(16)
        }
        beamSeparator2.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(1)
            make.top.equalTo(self.beamAnalysisButton.snp.bottom).offset(16)
        }
        beamTitleLabel2.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(self.beamSeparator2.snp.bottom).offset(16)
            make.height.equalTo(21)
        }
        beamk11Label.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.top.equalTo(self.beamTitleLabel2.snp.bottom).offset(16)
            make.height.equalTo(21)
            make.width.equalTo(24)
        }
        beamk11TextField.snp.makeConstraints { make in
            make.left.equalTo(beamk11Label.snp.right).offset(8)
            make.right.equalToSuperview().multipliedBy(0.333).offset(-16)
            make.top.equalTo(self.beamTitleLabel2.snp.bottom).offset(16)
            make.height.equalTo(21)
        }
        beamVerticalSeparatror1.snp.makeConstraints { make in
            make.right.equalToSuperview().multipliedBy(0.333).offset(-0.5)
            make.height.equalTo(21)
            make.width.equalTo(1)
            make.top.equalTo(beamk11Label)
        }
        beamk12Label.snp.makeConstraints { make in
            make.left.equalTo(beamk11TextField.snp.right).offset(32)
            make.top.equalTo(self.beamTitleLabel2.snp.bottom).offset(16)
            make.height.equalTo(21)
            make.width.equalTo(24)
        }
        beamk12TextField.snp.makeConstraints { make in
            make.left.equalTo(beamk12Label.snp.right).offset(8)
            make.right.equalToSuperview().multipliedBy(0.666).offset(-16)
            make.top.equalTo(self.beamTitleLabel2.snp.bottom).offset(16)
            make.height.equalTo(21)
        }
        beamVerticalSeparatror2.snp.makeConstraints { make in
            make.right.equalToSuperview().multipliedBy(0.666).offset(-0.5)
            make.height.equalTo(21)
            make.width.equalTo(1)
            make.top.equalTo(beamk11Label)
        }
        beamk13Label.snp.makeConstraints { make in
            make.left.equalTo(beamk12TextField.snp.right).offset(32)
            make.top.equalTo(self.beamTitleLabel2.snp.bottom).offset(16)
            make.height.equalTo(21)
            make.width.equalTo(24)
        }
        beamk13TextField.snp.makeConstraints { make in
            make.left.equalTo(beamk13Label.snp.right).offset(8)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(self.beamTitleLabel2.snp.bottom).offset(16)
            make.height.equalTo(21)
        }
        beamSeparator3.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(1)
            make.top.equalTo(self.beamk13TextField.snp.bottom).offset(16)
        }
        beamTitleLabel3.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(self.beamSeparator3.snp.bottom).offset(16)
            make.height.equalTo(21)
        }
        beamCosAngle1Label.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.top.equalTo(self.beamTitleLabel3.snp.bottom).offset(16)
            make.height.equalTo(21)
            make.width.equalTo(82)
        }
        beamCosAngle1TextField.snp.makeConstraints { make in
            make.left.equalTo(beamCosAngle1Label.snp.right).offset(8)
            make.right.equalToSuperview().multipliedBy(0.5).offset(-16)
            make.top.equalTo(self.beamTitleLabel3.snp.bottom).offset(16)
            make.height.equalTo(21)
        }
        beamVerticalSeparatror3.snp.makeConstraints { make in
            make.right.equalToSuperview().multipliedBy(0.5).offset(-0.5)
            make.height.equalTo(21)
            make.width.equalTo(1)
            make.top.equalTo(beamCosAngle1Label)
        }
        beamCosAngle2Label.snp.makeConstraints { make in
            make.left.equalTo(beamCosAngle1TextField.snp.right).offset(32)
            make.top.equalTo(self.beamTitleLabel3.snp.bottom).offset(16)
            make.height.equalTo(21)
            make.width.equalTo(82)
        }
        beamCosAngle2TextField.snp.makeConstraints { make in
            make.left.equalTo(beamCosAngle2Label.snp.right).offset(8)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(self.beamTitleLabel3.snp.bottom).offset(16)
            make.height.equalTo(21)
        }
    }

    // MARK: - setupPlateSubmodelView

    private func setupPlateSubmodelView() {
        plateAnalysisButton.addTarget(self, action: #selector(plateAnalysisButtonTapped(button:)), for: .touchUpInside)
        cellView.addSubview(plateSeparator1)
        cellView.addSubview(plateTitleLabel1)
        cellView.addSubview(plateAnalysisButton)
        cellView.addSubview(plateSeparator2)
        cellView.addSubview(plateTitleLabel2)
        cellView.addSubview(platek12Label)
        cellView.addSubview(platek12TextField)
        cellView.addSubview(plateVerticalSeparatror)
        cellView.addSubview(platek21Label)
        cellView.addSubview(platek21TextField)
        plateSeparator1.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(1)
            make.top.equalTo(self.analysisButton.snp.bottom).offset(16)
        }
        plateTitleLabel1.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(self.plateSeparator1.snp.bottom).offset(16)
            make.height.equalTo(21)
        }
        plateAnalysisButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(self.plateTitleLabel1.snp.bottom).offset(16)
        }
        plateSeparator2.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(1)
            make.top.equalTo(self.plateAnalysisButton.snp.bottom).offset(16)
        }
        plateTitleLabel2.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(self.plateSeparator2.snp.bottom).offset(16)
            make.height.equalTo(21)
        }
        platek12Label.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.top.equalTo(self.plateTitleLabel2.snp.bottom).offset(16)
            make.height.equalTo(21)
            make.width.equalTo(24)
        }
        platek12TextField.snp.makeConstraints { make in
            make.left.equalTo(platek12Label.snp.right).offset(8)
            make.right.equalToSuperview().multipliedBy(0.5).offset(-16)
            make.top.equalTo(self.plateTitleLabel2.snp.bottom).offset(16)
            make.height.equalTo(21)
        }
        plateVerticalSeparatror.snp.makeConstraints { make in
            make.right.equalToSuperview().multipliedBy(0.5).offset(-0.5)
            make.height.equalTo(21)
            make.width.equalTo(1)
            make.top.equalTo(platek12Label)
        }
        platek21Label.snp.makeConstraints { make in
            make.left.equalTo(platek12TextField.snp.right).offset(32)
            make.top.equalTo(self.plateTitleLabel2.snp.bottom).offset(16)
            make.height.equalTo(21)
            make.width.equalTo(24)
        }
        platek21TextField.snp.makeConstraints { make in
            make.left.equalTo(platek21Label.snp.right).offset(8)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(self.plateTitleLabel2.snp.bottom).offset(16)
            make.height.equalTo(21)
        }
    }

    private func hideSubmodel() {
        beamSeparator1.isHidden = true
        beamTitleLabel1.isHidden = true
        beamAnalysisButton.isHidden = true
        beamSeparator2.isHidden = true
        beamTitleLabel2.isHidden = true
        beamk11Label.isHidden = true
        beamk11TextField.isHidden = true
        beamVerticalSeparatror1.isHidden = true
        beamk12Label.isHidden = true
        beamk12TextField.isHidden = true
        beamVerticalSeparatror2.isHidden = true
        beamk13Label.isHidden = true
        beamk13TextField.isHidden = true
        beamSeparator3.isHidden = true
        beamTitleLabel3.isHidden = true
        beamCosAngle1Label.isHidden = true
        beamCosAngle1TextField.isHidden = true
        beamVerticalSeparatror3.isHidden = true
        beamCosAngle2Label.isHidden = true
        beamCosAngle2TextField.isHidden = true
        plateSeparator1.isHidden = true
        plateTitleLabel1.isHidden = true
        plateAnalysisButton.isHidden = true
        plateSeparator2.isHidden = true
        plateTitleLabel2.isHidden = true
        platek12Label.isHidden = true
        platek12TextField.isHidden = true
        plateVerticalSeparatror.isHidden = true
        platek21Label.isHidden = true
        platek21TextField.isHidden = true
    }

    private func showBeamSubmodel() {
        hideSubmodel()
        beamSeparator1.isHidden = false
        beamTitleLabel1.isHidden = false
        beamAnalysisButton.isHidden = false
        beamSeparator2.isHidden = false
        beamTitleLabel2.isHidden = false
        beamk11Label.isHidden = false
        beamk11TextField.isHidden = false
        beamVerticalSeparatror1.isHidden = false
        beamk12Label.isHidden = false
        beamk12TextField.isHidden = false
        beamVerticalSeparatror2.isHidden = false
        beamk13Label.isHidden = false
        beamk13TextField.isHidden = false
        beamSeparator3.isHidden = false
        beamTitleLabel3.isHidden = false
        beamCosAngle1Label.isHidden = false
        beamCosAngle1TextField.isHidden = false
        beamVerticalSeparatror3.isHidden = false
        beamCosAngle2Label.isHidden = false
        beamCosAngle2TextField.isHidden = false
    }

    private func showPlateSubmodel() {
        hideSubmodel()
        plateSeparator1.isHidden = false
        plateTitleLabel1.isHidden = false
        plateAnalysisButton.isHidden = false
        plateSeparator2.isHidden = false
        plateTitleLabel2.isHidden = false
        platek12Label.isHidden = false
        platek12TextField.isHidden = false
        plateVerticalSeparatror.isHidden = false
        platek21Label.isHidden = false
        platek21TextField.isHidden = false
    }
}

// MARK: - actions

extension StructuralModelCell {
    @objc private func analysisButtonTapped(button: SCAnalysisButton) {
        delegate?.changeStructuralModel(button: button)
    }

    @objc private func beamAnalysisButtonTapped(button: SCAnalysisButton) {
        delegate?.changeBeamStructuralSubmodel(button: button)
    }

    @objc private func plateAnalysisButtonTapped(button: SCAnalysisButton) {
        delegate?.changePlateStructuralSubmodel(button: button)
    }
}

// MARK: - textfield edit change actions

extension StructuralModelCell {
    @objc private func beamk11TextFieldEditingChanged(_ textField: UITextField) {
        let text = textField.text ?? ""
        structuralModel?.beamExtraInput.k11Text = text
        textField.textColor = Double(text) != nil ? .SCTitle : .red
    }

    @objc private func beamk12TextFieldEditingChanged(_ textField: UITextField) {
        let text = textField.text ?? ""
        structuralModel?.beamExtraInput.k12Text = text
        textField.textColor = Double(text) != nil ? .SCTitle : .red
    }

    @objc private func beamk13TextFieldEditingChanged(_ textField: UITextField) {
        let text = textField.text ?? ""
        structuralModel?.beamExtraInput.k13Text = text
        textField.textColor = Double(text) != nil ? .SCTitle : .red
    }

    @objc private func beamCosAngle1TextFieldEditingChanged(_ textField: UITextField) {
        let text = textField.text ?? ""
        structuralModel?.beamExtraInput.cosAngle1Text = text
        textField.textColor = Double(text) != nil ? .SCTitle : .red
    }

    @objc private func beamCosAngle2TextFieldEditingChanged(_ textField: UITextField) {
        let text = textField.text ?? ""
        structuralModel?.beamExtraInput.cosAngle2Text = text
        textField.textColor = Double(text) != nil ? .SCTitle : .red
    }

    @objc private func platek12TextFieldEditingChanged(_ textField: UITextField) {
        let text = textField.text ?? ""
        structuralModel?.plateExtraInput.k12Text = text
        textField.textColor = Double(text) != nil ? .SCTitle : .red
    }

    @objc private func platek21TextFieldEditingChanged(_ textField: UITextField) {
        let text = textField.text ?? ""
        structuralModel?.plateExtraInput.k21Text = text
        textField.textColor = Double(text) != nil ? .SCTitle : .red
    }
}
