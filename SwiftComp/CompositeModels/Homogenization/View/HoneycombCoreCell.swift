//
//  HoneycombCoreCell.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 11/24/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import UIKit

class HoneycombCoreCell: UITableViewCell {
    // MARK: - model

    var honeycombCore: HoneycombCore? {
        didSet {
            coreLengthTextField.text = honeycombCore?.coreLenthText
            coreLengthTextField.textColor = honeycombCore?.coreLength != nil ? .SCTitle : .red
            coreThicknessTextField.text = honeycombCore?.coreThicknessText
            coreThicknessTextField.textColor = honeycombCore?.coreThickness != nil ? .SCTitle : .red
            coreHeightTextField.text = honeycombCore?.coreHeightText
            coreHeightTextField.textColor = honeycombCore?.coreHeight != nil ? .SCTitle : .red
            drawCore()
        }
    }

    struct CellHeight {
        static let layupView = 164
        static let oneSection = 16 + 21 + 16 + layupView + 16 + 21 + 16 + 21 + 16 + 21 + 16
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
        label.text = "Honeycomb Core"
        label.font = .SCTitle
        label.textAlignment = .left
        return label
    }()

    private lazy var coreLengthLabel: UILabel = {
        let label = UILabel()
        label.textColor = .SCTitle
        label.text = "Core Length (l₁)"
        label.font = .SCParameterLabel
        return label
    }()

    private lazy var coreLengthTextField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .right
        textField.textColor = .SCTitle
        textField.placeholder = "Input Value"
        textField.font = .SCParameterLabel
        textField.keyboardType = UIKeyboardType.numbersAndPunctuation
        textField.addTarget(self, action: #selector(coreLengthTextFieldEditingChanged(_:)), for: .editingChanged)
        return textField
    }()
    
    private lazy var coreThicknessLabel: UILabel = {
        let label = UILabel()
        label.textColor = .SCTitle
        label.text = "Core Thickness (tc)"
        label.font = .SCParameterLabel
        return label
    }()

    private lazy var coreThicknessTextField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .right
        textField.textColor = .SCTitle
        textField.placeholder = "Input Value"
        textField.font = .SCParameterLabel
        textField.keyboardType = UIKeyboardType.numbersAndPunctuation
        textField.addTarget(self, action: #selector(coreThicknessTextFieldEditingChanged(_:)), for: .editingChanged)
        return textField
    }()
    
    private lazy var coreHeightLabel: UILabel = {
        let label = UILabel()
        label.textColor = .SCTitle
        label.text = "Core Height (hc)"
        label.font = .SCParameterLabel
        return label
    }()

    private lazy var coreHeightTextField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .right
        textField.textColor = .SCTitle
        textField.placeholder = "Input Value"
        textField.font = .SCParameterLabel
        textField.keyboardType = UIKeyboardType.numbersAndPunctuation
        textField.addTarget(self, action: #selector(coreHeightTextFieldEditingChanged(_:)), for: .editingChanged)
        return textField
    }()

    // MARK: - core figure related

    private lazy var coreView: UIView = {
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
        Wrong Core Geometry
        Make sure to have:
        2<=l₁/tc<=100
        hc/l₁<=20
        """
        return label
    }()
    
    private lazy var coreGeometryFigureView: UIView = {
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

extension HoneycombCoreCell {
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
        cellView.addSubview(coreView)
        cellView.addSubview(coreLengthLabel)
        cellView.addSubview(coreLengthTextField)
        cellView.addSubview(coreThicknessLabel)
        cellView.addSubview(coreThicknessTextField)
        cellView.addSubview(coreHeightLabel)
        cellView.addSubview(coreHeightTextField)

        titleLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(16)
            make.height.equalTo(21)
        }
        coreView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(CellHeight.layupView)
        }
        coreLengthLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.top.equalTo(coreView.snp.bottom).offset(16)
            make.right.equalToSuperview().multipliedBy(0.5).offset(-16)
            make.height.equalTo(21)
        }
        coreLengthTextField.snp.makeConstraints { make in
            make.left.equalTo(coreLengthLabel.snp.right).offset(32)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(coreView.snp.bottom).offset(16)
            make.height.equalTo(21)
        }
        coreThicknessLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.top.equalTo(coreLengthLabel.snp.bottom).offset(16)
            make.right.equalToSuperview().multipliedBy(0.5).offset(-16)
            make.height.equalTo(21)
        }
        coreThicknessTextField.snp.makeConstraints { make in
            make.left.equalTo(coreThicknessLabel.snp.right).offset(32)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(coreLengthLabel.snp.bottom).offset(16)
            make.height.equalTo(21)
        }
        coreHeightLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.top.equalTo(coreThicknessLabel.snp.bottom).offset(16)
            make.right.equalToSuperview().multipliedBy(0.5).offset(-16)
            make.height.equalTo(21)
        }
        coreHeightTextField.snp.makeConstraints { make in
            make.left.equalTo(coreHeightLabel.snp.right).offset(32)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(coreThicknessLabel.snp.bottom).offset(16)
            make.height.equalTo(21)
        }

    }

    // MARK: - darw layup

    private func drawCore() {
        
        coreView.subviews.forEach { $0.removeFromSuperview() }
        
        coreView.addSubview(coreGeometryFigureView)
        coreView.addSubview(wrongLabel)
        coreGeometryFigureView.snp.remakeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.equalTo(140)
            make.width.equalTo(240)
        }
        
        wrongLabel.snp.remakeConstraints { make in
            make.left.right.equalToSuperview().inset(32)
            make.center.equalToSuperview()
        }
        wrongLabel.isHidden = true
        
        coreGeometryFigureView.layer.sublayers?.forEach { $0.removeFromSuperlayer() } // first remove all sublayers

        guard let coreLengthGuard = honeycombCore?.coreLength, let coreThicknessGuard = honeycombCore?.coreThickness, let coreHeightGuard = honeycombCore?.coreHeight else {
            wrongLabel.isHidden = false
            return
        }

        let ratio1 = coreLengthGuard / coreThicknessGuard
        let ratio2 = coreHeightGuard / coreLengthGuard

        if ratio1 < 2.0 || ratio1 > 100.0 || ratio2 > 20.0 {
            wrongLabel.isHidden = false
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
        coreGeometryFigureLayer.strokeColor = UIColor.SCIcon.cgColor
    }
}

// MARK: - actions

extension HoneycombCoreCell {
    @objc private func coreLengthTextFieldEditingChanged(_ textField: UITextField) {
        let text = textField.text ?? ""
        honeycombCore?.coreLenthText = text
        textField.textColor = honeycombCore?.coreLength != nil ? .SCTitle : .red
        drawCore()
    }
    
    @objc private func coreThicknessTextFieldEditingChanged(_ textField: UITextField) {
        let text = textField.text ?? ""
        honeycombCore?.coreThicknessText = text
        textField.textColor = honeycombCore?.coreThickness != nil ? .SCTitle : .red
        drawCore()
    }
    
    @objc private func coreHeightTextFieldEditingChanged(_ textField: UITextField) {
        let text = textField.text ?? ""
        honeycombCore?.coreHeightText = text
        textField.textColor = honeycombCore?.coreHeight != nil ? .SCTitle : .red
        drawCore()
    }
}

