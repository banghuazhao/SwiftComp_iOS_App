//
//  StackingSequenceCell.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 11/23/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import UIKit

protocol StackingSequenceCellDelegate: AnyObject {
    func importButtonTapped()
    func exportButtonTapped()
}

class StackingSequenceCell: UITableViewCell {
    // MARK: - model
    
    weak var delegate: StackingSequenceCellDelegate?

    var stackingSequence: StackingSequence? {
        didSet {
            titleLabel.text = stackingSequence?.sectionTitle
            stackingSequenceTextField.text = stackingSequence?.stackingSequenceText
            stackingSequenceTextField.textColor = stackingSequence?.stackingSequence != nil ? .SCTitle : .red
            layerThicknessTextField.text = stackingSequence?.layerThicknessText
            layerThicknessTextField.textColor = stackingSequence?.layerThickness != nil ? .SCTitle : .red
            drawLayup()
        }
    }
    
    var structrualModel: StructuralModel? {
        didSet {
            guard let structrualModel = structrualModel else { return }
            switch structrualModel.model {
            case .solid(.cauchyContinuum):
                cellView.snp.updateConstraints { make in
                    make.height.equalTo(CellHeight.withoutLayerThickness)
                }
                hideLayerThickness()
                stackingSequence?.layerThicknessText = "1.0"
                
            default:
                cellView.snp.updateConstraints { make in
                    make.height.equalTo(CellHeight.withLayerThickness)
                }
                showLayerThickness()
            }
            drawLayup()
        }
    }

    struct CellHeight {
        static let layupView = 164
        static let withoutLayerThickness = 16 + 21 + 16 + layupView + 16 + 21 + 16
        static let withLayerThickness = withoutLayerThickness + 21 + 16
    }

    private lazy var spaceView: UIView = {
        let view = UIView()
        return view
    }()

    // MARK: - UI element

    private lazy var cellView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .SCTitle
        label.text = "Stacking Sequence"
        label.font = .SCTitle
        label.textAlignment = .left
        return label
    }()
    
    private lazy var explainButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "explain"), for: .normal)
        button.addTarget(self, action: #selector(explainButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var exportButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "export"), for: .normal)
        button.addTarget(self, action: #selector(exportButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var importButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "import"), for: .normal)
        button.addTarget(self, action: #selector(importButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var stackingSequenceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .SCTitle
        label.text = "Stacking Sequence"
        label.font = .SCParameterLabel
        return label
    }()

    private lazy var stackingSequenceTextField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .right
        textField.textColor = .SCTitle
        textField.placeholder = "[xx/xx/xx/xx/..]msn"
        textField.font = .SCParameterLabel
        textField.keyboardType = UIKeyboardType.numbersAndPunctuation
        textField.addTarget(self, action: #selector(stackingSequenceTextFieldEditingChanged(_:)), for: .editingChanged)
        return textField
    }()
    
    private lazy var layerThicknessLabel: UILabel = {
        let label = UILabel()
        label.textColor = .SCTitle
        label.text = "Layer Thickness"
        label.font = .SCParameterLabel
        return label
    }()

    private lazy var layerThicknessTextField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .right
        textField.textColor = .SCTitle
        textField.placeholder = "Input Number"
        textField.font = .SCParameterLabel
        textField.keyboardType = UIKeyboardType.numbersAndPunctuation
        textField.addTarget(self, action: #selector(layerThicknessTextFieldEditingChanged(_:)), for: .editingChanged)
        return textField
    }()

    // MARK: - layup figure related

    private lazy var layupView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor.SCIcon.cgColor
        return view
    }()

    private lazy var wrongLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .red
        label.font = .SCTitle
        label.numberOfLines = 0
        return label
    }()

    private lazy var layer1: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.SCIcon.cgColor
        label.font = .SCParameterLabel
        return label
    }()

    private lazy var layer2: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.SCIcon.cgColor
        label.font = .SCParameterLabel
        return label
    }()

    private lazy var layer3: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.SCIcon.cgColor
        label.font = .SCParameterLabel
        return label
    }()

    private lazy var layer4: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.SCIcon.cgColor
        label.font = .SCParameterLabel
        return label
    }()

    private lazy var layer5: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.SCIcon.cgColor
        label.font = .SCParameterLabel
        return label
    }()

    private lazy var layer6: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.SCIcon.cgColor
        label.font = .SCParameterLabel
        return label
    }()

    private lazy var layer7: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.SCIcon.cgColor
        label.font = .SCParameterLabel
        return label
    }()

    // MARK: - life cycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - private function

extension StackingSequenceCell {
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
            make.height.equalTo(CellHeight.withLayerThickness)
            make.bottom.equalToSuperview().priority(999)
        }

        cellView.addSubview(titleLabel)
        cellView.addSubview(explainButton)
        cellView.addSubview(exportButton)
        cellView.addSubview(importButton)
        cellView.addSubview(layupView)
        cellView.addSubview(stackingSequenceLabel)
        cellView.addSubview(stackingSequenceTextField)
        cellView.addSubview(layerThicknessLabel)
        cellView.addSubview(layerThicknessTextField)

        titleLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(16)
            make.height.equalTo(21)
        }
        explainButton.snp.makeConstraints { (make) in
             make.top.right.equalToSuperview().inset(16)
             make.size.equalTo(21)
        }
        importButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(16)
            make.right.equalToSuperview().inset(16+21+20)
            make.size.equalTo(21)
        }
        exportButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(16)
            make.right.equalToSuperview().inset(16+21+20+21+20)
            make.size.equalTo(21)
        }
        layupView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(CellHeight.layupView)
        }
        stackingSequenceLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.top.equalTo(layupView.snp.bottom).offset(16)
            make.right.equalToSuperview().multipliedBy(0.5).offset(-16)
            make.height.equalTo(21)
        }
        stackingSequenceTextField.snp.makeConstraints { make in
            make.left.equalTo(stackingSequenceLabel.snp.right).offset(32)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(layupView.snp.bottom).offset(16)
            make.height.equalTo(21)
        }
        layerThicknessLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.top.equalTo(stackingSequenceLabel.snp.bottom).offset(16)
            make.right.equalToSuperview().multipliedBy(0.5).offset(-16)
            make.height.equalTo(21)
        }
        layerThicknessTextField.snp.makeConstraints { make in
            make.left.equalTo(stackingSequenceLabel.snp.right).offset(32)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(stackingSequenceLabel.snp.bottom).offset(16)
            make.height.equalTo(21)
        }

        layupView.addSubview(wrongLabel)
        layupView.addSubview(layer1)
        layupView.addSubview(layer2)
        layupView.addSubview(layer3)
        layupView.addSubview(layer4)
        layupView.addSubview(layer5)
        layupView.addSubview(layer6)
        layupView.addSubview(layer7)

        wrongLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(32)
            make.center.equalToSuperview()
        }
        layer1.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(32)
            make.height.equalTo(20)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        layer2.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(32)
            make.height.equalTo(20)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        layer3.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(32)
            make.height.equalTo(20)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        layer4.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(32)
            make.height.equalTo(20)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        layer5.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(32)
            make.height.equalTo(20)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        layer6.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(32)
            make.height.equalTo(20)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        layer7.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(32)
            make.height.equalTo(20)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }

    // MARK: - darw layup

    private func drawLayup() {
        let layers: [UILabel] = [layer1, layer2, layer3, layer4, layer5, layer6, layer7]
        layers.forEach { $0.isHidden = true }
        wrongLabel.isHidden = true
        
        guard let stackingSequence = stackingSequence else { return }
        
        guard !stackingSequence.tooManyLayers else {
            wrongLabel.text = """
            Too Many Layers:
            The maximum number of layers is \(stackingSequence.maxNumOfLayers)
            """
            wrongLabel.isHidden = false
            return
        }
        
        guard let layup = stackingSequence.stackingSequence else {
            wrongLabel.text = "Wrong Stacking Sequence"
            wrongLabel.isHidden = false
            return
        }
        
        guard stackingSequence.layerThickness != nil else {
            wrongLabel.text = "Wrong Layer Thickness"
            wrongLabel.isHidden = false
            return
        }

        if layup.count <= 7 {
            for i in 0 ... layup.count - 1 {
                let normalizedAngle = abs(layup[i]).truncatingRemainder(dividingBy: 90)
                let alpha: CGFloat = (normalizedAngle == 0 && layup[i] != 0.0) ?
                    CGFloat(0) : CGFloat(0.9 - normalizedAngle / 100)
                layers[i].backgroundColor = UIColor.SCIcon.withAlphaComponent(alpha)
                layers[i].text = String(format: "%.1f", layup[i])
                layers[i].isHidden = false
            }
        } else {
            for i in 0 ... 2 {
                let normalizedAngle = abs(layup[i]).truncatingRemainder(dividingBy: 90)
                let alpha: CGFloat = (normalizedAngle == 0 && layup[i] != 0.0) ?
                    CGFloat(0) : CGFloat(0.9 - normalizedAngle / 100)
                layers[i].backgroundColor = UIColor.SCIcon.withAlphaComponent(alpha)
                layers[i].text = String(format: "%.1f", layup[i])
                layers[i].isHidden = false
            }
            for i in 0 ... 2 {
                let reverseIndex = layup.endIndex - 1 - i
                let normalizedAngle = abs(layup[reverseIndex]).truncatingRemainder(dividingBy: 90)
                let alpha: CGFloat = (normalizedAngle == 0 && layup[reverseIndex] != 0.0) ?
                    CGFloat(0) : CGFloat(0.9 - normalizedAngle / 100)
                layers[5 - i].backgroundColor = UIColor.SCIcon.withAlphaComponent(alpha)
                layers[5 - i].text = String(format: "%.1f", layup[reverseIndex])
                layers[5 - i].isHidden = false
            }
            layers[6].backgroundColor = .white
            layers[6].text = "... omit \(layup.count - 6) layers"
            layers[6].isHidden = false
        }

        let offset = 0.5
        switch layup.count {
        case 1:
            layer1.snp.updateConstraints { make in
                make.centerY.equalToSuperview()
            }
        case 2:
            layer1.snp.updateConstraints { make in
                make.centerY.equalToSuperview().offset(10 - offset)
            }
            layer2.snp.updateConstraints { make in
                make.centerY.equalToSuperview().offset(-10 + offset)
            }
        case 3:
            layer1.snp.updateConstraints { make in
                make.centerY.equalToSuperview().offset(20 - 2 * offset)
            }
            layer2.snp.updateConstraints { make in
                make.centerY.equalToSuperview().offset(0)
            }
            layer3.snp.updateConstraints { make in
                make.centerY.equalToSuperview().offset(-20 + 2 * offset)
            }
        case 4:
            layer1.snp.updateConstraints { make in
                make.centerY.equalToSuperview().offset(30 - 3 * offset)
            }
            layer2.snp.updateConstraints { make in
                make.centerY.equalToSuperview().offset(10 - offset)
            }
            layer3.snp.updateConstraints { make in
                make.centerY.equalToSuperview().offset(-10 + offset)
            }
            layer4.snp.updateConstraints { make in
                make.centerY.equalToSuperview().offset(-30 + 3 * offset)
            }
        case 5:
            layer1.snp.updateConstraints { make in
                make.centerY.equalToSuperview().offset(40 - 4 * offset)
            }
            layer2.snp.updateConstraints { make in
                make.centerY.equalToSuperview().offset(20 - 2 * offset)
            }
            layer3.snp.updateConstraints { make in
                make.centerY.equalToSuperview().offset(0)
            }
            layer4.snp.updateConstraints { make in
                make.centerY.equalToSuperview().offset(-20 + 2 * offset)
            }
            layer5.snp.updateConstraints { make in
                make.centerY.equalToSuperview().offset(-40 + 4 * offset)
            }
        case 6:
            layer1.snp.updateConstraints { make in
                make.centerY.equalToSuperview().offset(50 - 5 * offset)
            }
            layer2.snp.updateConstraints { make in
                make.centerY.equalToSuperview().offset(30 - 3 * offset)
            }
            layer3.snp.updateConstraints { make in
                make.centerY.equalToSuperview().offset(10 - offset)
            }
            layer4.snp.updateConstraints { make in
                make.centerY.equalToSuperview().offset(-10 + offset)
            }
            layer5.snp.updateConstraints { make in
                make.centerY.equalToSuperview().offset(-30 + 3 * offset)
            }
            layer6.snp.updateConstraints { make in
                make.centerY.equalToSuperview().offset(-50 + 5 * offset)
            }
        case 7:
            layer1.snp.updateConstraints { make in
                make.centerY.equalToSuperview().offset(60 - 6 * offset)
            }
            layer2.snp.updateConstraints { make in
                make.centerY.equalToSuperview().offset(40 - 4 * offset)
            }
            layer3.snp.updateConstraints { make in
                make.centerY.equalToSuperview().offset(20 - 2 * offset)
            }
            layer4.snp.updateConstraints { make in
                make.centerY.equalToSuperview().offset(0)
            }
            layer5.snp.updateConstraints { make in
                make.centerY.equalToSuperview().offset(-20 + 2 * offset)
            }
            layer6.snp.updateConstraints { make in
                make.centerY.equalToSuperview().offset(-40 + 4 * offset)
            }
            layer7.snp.updateConstraints { make in
                make.centerY.equalToSuperview().offset(-60 + 6 * offset)
            }
        default:
            layer1.snp.updateConstraints { make in
                make.centerY.equalToSuperview().offset(60 - 6 * offset)
            }
            layer2.snp.updateConstraints { make in
                make.centerY.equalToSuperview().offset(40 - 4 * offset)
            }
            layer3.snp.updateConstraints { make in
                make.centerY.equalToSuperview().offset(20 - 2 * offset)
            }
            layer4.snp.updateConstraints { make in
                make.centerY.equalToSuperview().offset(-20 + 2 * offset)
            }
            layer5.snp.updateConstraints { make in
                make.centerY.equalToSuperview().offset(-40 + 4 * offset)
            }
            layer6.snp.updateConstraints { make in
                make.centerY.equalToSuperview().offset(-60 + 6 * offset)
            }
            layer7.snp.updateConstraints { make in
                make.centerY.equalToSuperview().offset(0)
            }
        }
    }
    
    private func showLayerThickness() {
        layerThicknessLabel.isHidden = false
        layerThicknessTextField.isHidden = false
    }
    
    private func hideLayerThickness() {
        layerThicknessLabel.isHidden = true
        layerThicknessTextField.isHidden = true
    }
}

// MARK: - public function

extension StackingSequenceCell {
    func changeTitle(newTitle: String) {
        titleLabel.text = newTitle
    }
}

// MARK: - actions

extension StackingSequenceCell {
    @objc private func stackingSequenceTextFieldEditingChanged(_ textField: UITextField) {
        let text = textField.text ?? ""
        stackingSequence?.stackingSequenceText = text
        textField.textColor = stackingSequence?.stackingSequence != nil ? .SCTitle : .red
        drawLayup()
    }
    
    @objc private func layerThicknessTextFieldEditingChanged(_ textField: UITextField) {
        let text = textField.text ?? ""
        stackingSequence?.layerThicknessText = text
        textField.textColor = stackingSequence?.layerThickness != nil ? .SCTitle : .red
        drawLayup()
    }
    
    @objc private func explainButtonTapped() {
        let title = "Stacking Sequence"
        let message = """
        The stacking sequence is the layup angles from the bottom surface to the top surface.

        The format of stacking sequence is [xx/xx/xx/xx/..]msn
        xx: Layup angle
        m: Number of repetition before symmetry
        s: Symmetry or not
        n: Number of repetition after symmetry

        • Examples:
        Cross-ply laminates: [0/90]
        Balanced laminates: [45/-45]
        [0/90]2 : [0/90/0/90]
        [0/90]s : [0/90/90/0]
        [30/-30]2s : [30/-30/30/-30/-30/30/-30/30]
        [30/-30]s2 : [30/-30/-30/30/30/-30/-30/30]

        The layer thickness is the thickness for each lamina. Note, it doesn't need layer thickness information for solid model.
        """
        let popupWindow = SCPopupWindow(title: title, message: message)
        popupWindow.show(completion: nil)
    }
    
    @objc private func exportButtonTapped() {
        delegate?.exportButtonTapped()
    }
    
    @objc private func importButtonTapped() {
        delegate?.importButtonTapped()
    }

}
