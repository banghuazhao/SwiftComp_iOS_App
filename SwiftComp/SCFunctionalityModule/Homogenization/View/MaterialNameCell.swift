//
//  MaterialNameCell.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 11/26/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import UIKit

class MaterialNameCell: UITableViewCell {
    // MARK: - model

    var material: Material? {
        didSet {
            valueTextField.text = material?.name
        }
    }

    // MARK: - UI element

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .SCTitle
        label.font = .SCParameterLabel
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.text = "Material Name"
        return label
    }()

    private lazy var valueTextField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .right
        textField.textColor = .SCTitle
        textField.placeholder = "Input Name"
        textField.font = .SCParameterLabel
        textField.adjustsFontSizeToFitWidth = true
        textField.minimumFontSize = 10
        textField.keyboardType = UIKeyboardType.alphabet
        textField.addTarget(self, action: #selector(valueTextFieldEditingChanged(_:)), for: .editingChanged)
        return textField
    }()

    // MARK: - life cycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - private function

extension MaterialNameCell {
    private func setupView() {
        addSubview(nameLabel)
        addSubview(valueTextField)

        nameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().multipliedBy(0.5).offset(-8)
            make.centerY.equalToSuperview()
        }

        valueTextField.snp.makeConstraints { make in
            make.left.equalTo(nameLabel.snp.right).offset(16)
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
    }
}

// MARK: - actions

extension MaterialNameCell {
    @objc func valueTextFieldEditingChanged(_ sender: UITextField) {
        let text = sender.text ?? ""
        material?.name = text
    }
}
