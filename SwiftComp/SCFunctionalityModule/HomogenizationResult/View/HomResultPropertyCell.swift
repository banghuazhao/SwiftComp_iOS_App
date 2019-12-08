//
//  HomResultPropertyCell.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 11/30/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import UIKit

class HomResultPropertyCell: UITableViewCell {
    // MARK: - model

    var homResultProperty: HomResultProperty? {
        didSet {
            nameLabel.text = homResultProperty?.name
            valueLabel.text = homResultProperty?.valueText
            valueLabel.textColor = valueLabel.text == "Not available" ? .SCNumber : .SCTitle
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
        return label
    }()

    private lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .SCTitle
        label.font = .SCParameterLabel
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        return label
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

extension HomResultPropertyCell {
    private func setupView() {
        addSubview(nameLabel)
        addSubview(valueLabel)

        nameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().multipliedBy(0.5).offset(-8)
            make.centerY.equalToSuperview()
        }

        valueLabel.snp.makeConstraints { make in
            make.left.equalTo(nameLabel.snp.right).offset(16)
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
    }
}
