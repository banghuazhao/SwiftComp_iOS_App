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
                break
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
            
            // MARK: - explain related didset
            switch structuralModel?.model {
            case .beam(.eulerBernoulli):
                explain1 = """
                    • Beam Model:
                    The structure is modeled as a beam. The results will give beam stiffness matrix, which can be used for beam element.
                    """
                explainTitle2 = "Beam Submodel"
                explain2 = """
                   • Euler-Bernoulli Model:
                   Euler-Bernoulli model was originally developed based on a set of ad hoc assumptions including the cross section being rigid in plane, perpendicular to the reference line, and uniaxial stress assumption. The result of give 4 by 4 beam stiffenss matrix.
                   """
                explainTitle3 = "Beam Initial Twist/Curvatures"
                explain3 = """
                    k11, k12, and k13 are defined as the initial twist(k11) and curvatures (k12, k13) of the beam.

                    If the structure is initially straight, zeroes should be provided instead.
                    """
                explain4 = """
                    cos(angle1) and cos(angle2) are two real numbers to specify a SG with oblique cross-sections.

                    The first number is cosine of the angle between normal of the oblique section (y1) and beam axis x1. The second number is cosine of the angle between y2 of the oblique section and beam axis (x1).

                    The summation of the square of these two numbers should not be greater than 1.0 in double precision. The inputs including coordinates, material properties, etc. and the outputs including mass matrix, stiness matrix, etc. are given in the oblique system, the yi coordinate system. For normal cross-sections, we provide 1.0 0.0 on this line instead.
                    """
            case .beam(.timoshenko):
                explain1 = """
                    • Beam Model:
                    The structure is modeled as a beam. The results will give beam stiffness matrix, which can be used for beam element.
                    """
                explainTitle2 = "Beam Submodel"
                explain2 = """
                   • Timoshenko Model:
                   The refined model for the plate when the thickness of the panel is not very small with respect to the in-plane dimensions. The result of give 6 by 6 beam stiffenss matrix.
                   """
                explainTitle3 = "Beam Initial Twist/Curvatures"
                explain3 = """
                    k11, k12, and k13 are defined as the initial twist(k11) and curvatures (k12, k13) of the beam.

                    If the structure is initially straight, zeroes should be provided instead.
                    """
                explain4 = """
                    cos(angle1) and cos(angle2) are two real numbers to specify a SG with oblique cross-sections.

                    The first number is cosine of the angle between normal of the oblique section (y1) and beam axis x1. The second number is cosine of the angle between y2 of the oblique section and beam axis (x1).

                    The summation of the square of these two numbers should not be greater than 1.0 in double precision. The inputs including coordinates, material properties, etc. and the outputs including mass matrix, stiness matrix, etc. are given in the oblique system, the yi coordinate system. For normal cross-sections, we provide 1.0 0.0 on this line instead.
                    """
            case .plate(.kirchhoffLove):
                explain1 = """
                    • Plate Model:
                    The structure modeled as a plate. The results will give A, B, D matrices, in-plane properties and flexural properties, which can be used for plate element.
                    """
                explainTitle2 = "Plate Submodel"
                explain2 = """
                   • Kirchho-Love Model:
                   Classical plate model for flat panels based on a set of ad hoc assumptions including the thickness being rigid in the thickness direction, perpendicular to the reference surface, and plane stress assumption. The result will give A, B, and D matrices
                   """
                explainTitle3 = "Plate Initial Curvatures"
                explain3 = """
                    k12 and k21 are defined as the initial curvatures of the plate so that the plate is modeled as a shell.

                    If the structure is initially straight, zeroes should be provided instead.
                    """
            case .plate(.reissnerMindlin):
                explain1 = """
                    • Plate Model:
                    The structure modeled as a plate. The results will give A, B, D matrices, in-plane properties and flexural properties, which can be used for plate element.
                    """
                explainTitle2 = "Plate Submodel"
                explain2 = """
                   • Reissner-Mindlin Model:
                   The refined model for the plate when the thickness of the panel is not very small with respect to the in-plane dimensions. The result will give A, B, and D matrices and transversely sheasr stiffenss matrix.
                   """
                explainTitle3 = "Plate Initial Curvatures"
                explain3 = """
                    k12 and k21 are defined as the initial curvatures of the plate so that the plate is modeled as a shell.

                    If the structure is initially straight, zeroes should be provided instead.
                    """
            case .solid(.cauchyContinuum):
                explain1 = """
                    • Solid Model:
                    The structure is modeled as a solid. The results will give solid stiffness matrix and engineering constants, which can be used for brick element.
                    """
            default:
                break
            }
            
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

    // MARK: - explain related

    private var explain1: String = ""
    private var explain2: String = ""
    private var explainTitle2: String = ""
    private var explain3: String = ""
    private var explainTitle3: String = ""
    private var explain4: String = ""

    private lazy var explainButton1: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "explain"), for: .normal)
        button.addTarget(self, action: #selector(explainButton1Tapped), for: .touchUpInside)
        return button
    }()

    private lazy var explainButton2: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "explain"), for: .normal)
        button.addTarget(self, action: #selector(explainButton2Tapped), for: .touchUpInside)
        return button
    }()

    private lazy var explainButton3: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "explain"), for: .normal)
        button.addTarget(self, action: #selector(explainButton3Tapped), for: .touchUpInside)
        return button
    }()

    private lazy var explainButton4: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "explain"), for: .normal)
        button.addTarget(self, action: #selector(explainButton4Tapped), for: .touchUpInside)
        return button
    }()

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
        textField.addTarget(self, action: #selector(beamk12TextFieldEditingChanged(_:)), for: .editingChanged)

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
        cellView.addSubviews(explainButton1, explainButton2, explainButton3, explainButton4)
        cellView.addSubview(analysisButton)

        titleLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(16)
            make.height.equalTo(21)
        }

        explainButton1.snp.makeConstraints { make in
            make.top.right.equalToSuperview().inset(16)
            make.size.equalTo(21)
        }

        explainButton2.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(CellHeight.oneSection + 17)
            make.right.equalToSuperview().inset(16)
            make.size.equalTo(21)
        }

        explainButton3.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(CellHeight.twoSection + 17)
            make.right.equalToSuperview().inset(16)
            make.size.equalTo(21)
        }

        explainButton4.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(CellHeight.threeSection + 17)
            make.right.equalToSuperview().inset(16)
            make.size.equalTo(21)
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
        explainButton2.isHidden = true
        explainButton3.isHidden = true
        explainButton4.isHidden = true
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
        explainButton2.isHidden = false
        explainButton3.isHidden = false
        explainButton4.isHidden = false
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
        explainButton2.isHidden = false
        explainButton3.isHidden = false
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
        textField.textColor = structuralModel?.beamExtraInput.cosAngle1 != nil ? .SCTitle : .red
    }

    @objc private func beamCosAngle2TextFieldEditingChanged(_ textField: UITextField) {
        let text = textField.text ?? ""
        structuralModel?.beamExtraInput.cosAngle2Text = text
        textField.textColor = structuralModel?.beamExtraInput.cosAngle2 != nil ? .SCTitle : .red
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

    @objc private func explainButton1Tapped() {
        let title = "Structrual Model"
        let popupWindow = SCPopupWindow(title: title, message: explain1)
        popupWindow.show(completion: nil)
    }

    @objc private func explainButton2Tapped() {
        let popupWindow = SCPopupWindow(title: explainTitle2, message: explain2)
        popupWindow.show(completion: nil)
    }

    @objc private func explainButton3Tapped() {
        let popupWindow = SCPopupWindow(title: explainTitle3, message: explain3)
        popupWindow.show(completion: nil)
    }

    @objc private func explainButton4Tapped() {
        let title = "Beam Oblique Cross Section"
        let popupWindow = SCPopupWindow(title: title, message: explain4)
        popupWindow.show(completion: nil)
    }
}
