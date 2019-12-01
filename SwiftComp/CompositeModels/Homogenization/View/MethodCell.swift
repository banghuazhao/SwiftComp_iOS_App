//
//  MethodCell.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 11/20/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import UIKit

protocol MethodCellDelegate: AnyObject {
    func changeMethod(button: SCAnalysisButton)
}

class MethodCell: UITableViewCell {
    
    // MARK: - model
    var method: Method? {
        didSet {
            switch method {
            case .swiftComp:
                analysisButton.changeButtonTitle(title: "SwiftComp")
            case .nonSwiftComp(.CLPT):
                analysisButton.changeButtonTitle(title: "Classical Laminated Plate Theory")
            case .nonSwiftComp(.VoigtROM):
                analysisButton.changeButtonTitle(title: "Voigt Rules of Mixture")
            case .nonSwiftComp(.ReussROM):
                analysisButton.changeButtonTitle(title: "Reuss Rules of Mixture")
            case .nonSwiftComp(.HybridROM):
                analysisButton.changeButtonTitle(title: "Hybrid Rules of Mixture")
            default:
                return
            }
        }
    }
    
    weak var delegate: MethodCellDelegate?
    
    private let cellHeight = 16 + 21 + 16 + 36 + 16
    
    // MARK: - UI elements

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
        label.text = "Method"
        label.font = .SCTitle
        label.textAlignment = .left
        return label
    }()

    private lazy var analysisButton = SCAnalysisButton()
    
    // MARK: - life cycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        analysisButton.addTarget(self, action: #selector(analysisButtonTapped(button:)), for: .touchUpInside)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - actions

extension MethodCell {
    @objc private func analysisButtonTapped(button: SCAnalysisButton) {
        delegate?.changeMethod(button: button)
    }
}

// MARK: - private function

extension MethodCell {
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
            make.height.equalTo(cellHeight)
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
}
