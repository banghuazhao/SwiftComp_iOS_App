//
//  FiberVolumeFractionCell.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 12/7/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import UIKit

class FiberVolumeFractionCell: UITableViewCell {
    // MARK: - model

    var fiberVolumeFraction: VolumeFraction? {
        didSet {
            volumeFractionSlider.value = Float(fiberVolumeFraction?.value ?? 0.3)
            squareLengthTextField.text = fiberVolumeFraction?.cellLengthText
            squareLengthTextField.textColor = fiberVolumeFraction?.cellLength != nil ? .SCTitle : .red
            drawCell()
        }
    }

    var structrualModel: StructuralModel? {
        didSet {
            guard let structrualModel = structrualModel else { return }
            switch structrualModel.model {
            case .solid(.cauchyContinuum):
                cellView.snp.updateConstraints { make in
                    make.height.equalTo(CellHeight.oneSectionWithoutLegnth)
                }
                squareLengthLabel.isHidden = true
                squareLengthTextField.isHidden = true
                fiberVolumeFraction?.cellLengthText = "1.0"
            default:
                cellView.snp.updateConstraints { make in
                    make.height.equalTo(CellHeight.oneSectionWithLegnth)
                }
                squareLengthLabel.isHidden = false
                squareLengthTextField.isHidden = false
            }
            drawCell()
        }
    }

    struct CellHeight {
        static let geometryView = 164
        static let oneSectionWithoutLegnth = 16 + 21 + 16 + geometryView + 16 + 21 + 16
        static let oneSectionWithLegnth = oneSectionWithoutLegnth + 16 + 21 + 16
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
        label.text = "Fiber Volume Fraction"
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

    private lazy var volumeFractionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .SCTitle
        label.text = "Fiber Volume Fraction"
        label.font = .SCParameterLabel
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    private lazy var volumeFractionSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0.0
        slider.maximumValue = 1.0
        slider.isContinuous = true
        slider.value = 0.3
        slider.addTarget(self, action: #selector(volumeFractionSliderChange(_:)), for: .valueChanged)
        return slider
    }()

    private lazy var squareLengthLabel: UILabel = {
        let label = UILabel()
        label.textColor = .SCTitle
        label.text = "Square Length"
        label.font = .SCParameterLabel
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    private lazy var squareLengthTextField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .right
        textField.textColor = .SCTitle
        textField.placeholder = "Input Value"
        textField.font = .SCParameterLabel
        textField.keyboardType = UIKeyboardType.numbersAndPunctuation
        textField.addTarget(self, action: #selector(squareLengthTextFieldEditingChanged(_:)), for: .editingChanged)
        return textField
    }()

    // MARK: - core figure related

    private lazy var volumeFractionView: UIView = {
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
        label.text = """
        Wrong Fiber Volume Fraction
        Make sure to have:
        0.0 <= Volume Fraction <= 1.0
        """
        return label
    }()

    private lazy var volumeFractionFigureView: UIView = {
        let view = UIView()
        return view
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

extension FiberVolumeFractionCell {
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
            make.height.equalTo(CellHeight.oneSectionWithLegnth)
            make.bottom.equalToSuperview().priority(999)
        }

        cellView.addSubview(titleLabel)
        cellView.addSubview(explainButton)
        cellView.addSubview(volumeFractionView)
        cellView.addSubview(volumeFractionLabel)
        cellView.addSubview(volumeFractionSlider)
        cellView.addSubview(squareLengthLabel)
        cellView.addSubview(squareLengthTextField)

        titleLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(16)
            make.height.equalTo(21)
        }
        explainButton.snp.makeConstraints { (make) in
             make.top.right.equalToSuperview().inset(16)
             make.size.equalTo(21)
        }
        volumeFractionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(CellHeight.geometryView)
        }
        volumeFractionLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.right.equalTo(cellView.snp.right).multipliedBy(0.5).offset(-8)
            make.top.equalTo(volumeFractionView.snp.bottom).offset(16)
            make.height.equalTo(21)
        }
        volumeFractionSlider.snp.makeConstraints { make in
            make.left.equalTo(cellView.snp.right).multipliedBy(0.5).offset(8)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(volumeFractionView.snp.bottom).offset(16)
            make.height.equalTo(21)
        }
        squareLengthLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.right.equalTo(cellView.snp.right).multipliedBy(0.5).offset(-8)
            make.top.equalTo(volumeFractionSlider.snp.bottom).offset(16)
            make.height.equalTo(21)
        }
        squareLengthTextField.snp.makeConstraints { make in
            make.left.equalTo(cellView.snp.right).multipliedBy(0.5).offset(8)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(volumeFractionSlider.snp.bottom).offset(16)
            make.height.equalTo(21)
        }
        drawCell()
    }

    // MARK: - darw layup

    private func drawCell() {
        volumeFractionFigureView.isHidden = false
        wrongLabel.isHidden = true

        guard let fraction = fiberVolumeFraction?.value else {
            wrongLabel.text = """
            Wrong Fiber Volume Fraction
            Make sure to have:
            0.0 <= Volume Fraction <= 1.0
            """
            volumeFractionFigureView.isHidden = true
            wrongLabel.isHidden = false
            return
        }

        guard fiberVolumeFraction?.cellLength != nil else {
            wrongLabel.text = "Wrong Square Pack Length"
            volumeFractionFigureView.isHidden = true
            wrongLabel.isHidden = false
            return
        }

        volumeFractionView.subviews.forEach { $0.removeFromSuperview() }

        volumeFractionView.addSubview(volumeFractionFigureView)
        volumeFractionView.addSubview(wrongLabel)

        volumeFractionFigureView.snp.remakeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(120)
            make.width.equalTo(240)
        }

        wrongLabel.snp.remakeConstraints { make in
            make.left.right.equalToSuperview().inset(32)
            make.center.equalToSuperview()
        }

        volumeFractionFigureView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }

        let size: CGFloat = 120

        let square = CAShapeLayer()

        let squarePath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: size, height: size))
        square.path = squarePath.cgPath
        square.fillColor = UIColor(red: 216 / 255, green: 216 / 255, blue: 216 / 255, alpha: 1.0).cgColor
        volumeFractionFigureView.layer.addSublayer(square)

        let squareArea = Double(size * size)
        if fraction < 0.78 {
            let radius = CGFloat(sqrt(squareArea * fraction / Double.pi))
            let circle = CAShapeLayer()
            let circlePath = UIBezierPath(arcCenter: CGPoint(x: size / 2, y: size / 2), radius: radius, startAngle: 0, endAngle: 2 * CGFloat(Double.pi), clockwise: true)
            circle.path = circlePath.cgPath
            circle.fillColor = UIColor.black.cgColor
            volumeFractionFigureView.layer.addSublayer(circle)
        } else {
            let length = CGFloat(sqrt(squareArea * fraction))
            let centerX = (size - length) / 2
            let subsquare = CAShapeLayer()
            let subsquarePath = UIBezierPath(rect: CGRect(x: centerX, y: centerX, width: length, height: length))
            subsquare.path = subsquarePath.cgPath
            subsquare.fillColor = UIColor.black.cgColor
            volumeFractionFigureView.layer.addSublayer(subsquare)
        }

        let rightOffset = size + 32

        let fiberFigure = CALayer()
        fiberFigure.frame = CGRect(x: rightOffset, y: 0, width: 20, height: 20)
        fiberFigure.cornerRadius = 4
        fiberFigure.backgroundColor = UIColor.black.cgColor

        let fiberLabel = UILabel(frame: CGRect(x: rightOffset + 28, y: 0, width: 60, height: 20))
        fiberLabel.text = "Fiber"
        fiberLabel.font = UIFont.systemFont(ofSize: 14)
        fiberLabel.textColor = .SCTitle

        let matrixFigure = CALayer()
        matrixFigure.frame = CGRect(x: rightOffset, y: 36, width: 20, height: 20)
        matrixFigure.cornerRadius = 4
        matrixFigure.backgroundColor = UIColor(red: 216 / 255, green: 216 / 255, blue: 216 / 255, alpha: 1.0).cgColor

        let matrixLabel = UILabel(frame: CGRect(x: rightOffset + 28, y: 36, width: 60, height: 20))
        matrixLabel.text = "Matrix"
        matrixLabel.font = UIFont.systemFont(ofSize: 14)
        matrixLabel.textColor = .SCTitle

        let fractionValueLabel = UILabel(frame: CGRect(x: rightOffset, y: 72, width: 60, height: 20))
        fractionValueLabel.text = String(format: "%.3f", fraction)
        fractionValueLabel.font = UIFont.systemFont(ofSize: 14)
        fractionValueLabel.textColor = .SCTitle

        volumeFractionFigureView.layer.addSublayer(fiberFigure)
        volumeFractionFigureView.addSubview(fiberLabel)

        volumeFractionFigureView.layer.addSublayer(matrixFigure)
        volumeFractionFigureView.addSubview(matrixLabel)

        volumeFractionFigureView.addSubview(fractionValueLabel)
    }
}

// MARK: - actions

extension FiberVolumeFractionCell {
    @objc private func volumeFractionSliderChange(_ sender: UISlider) {
        fiberVolumeFraction?.value = Double(sender.value)
        drawCell()
    }

    @objc private func squareLengthTextFieldEditingChanged(_ textField: UITextField) {
        let text = textField.text ?? ""
        fiberVolumeFraction?.cellLengthText = text
        textField.textColor = fiberVolumeFraction?.cellLength != nil ? .SCTitle : .red
        drawCell()
    }

    @objc private func explainButtonTapped() {
        let title = "Fiber Volume Fraction"

        let message = """
        The fiber volume fraction is defined as the fiber volume divided by the total volume of the composite:

        fiber volume fraction = fiber volume / total volume of the composite

        The fiber is the reinforcing phase in a composite. In fiber direction, it is stiff and strong and serves as the main load carrier. The matrix is the supporting phase in a composite, which protects the reinforcing phase and transfers the load to the reinforcing phases.
        """
        let popupWindow = SCPopupWindow(title: title, message: message)
        popupWindow.show(completion: nil)
    }
}
