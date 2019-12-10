//
//  MaterialDataBaseCell.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 12/9/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import UIKit

class MaterialDataBaseCell: UITableViewCell {
    var material: Material? {
        didSet {
            guard let material = material else { return }
            nameLabel.text = material.name
            typeLabel.text = material.getMaterialTypeText()
        }
    }

    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.font = .SCParameterLabel
        label.textColor = .SCTitle
        return label
    }()

    lazy var typeLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.font = .SCParameterLabel
        label.textColor = .SCNumber
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        addSubview(nameLabel)
        addSubview(typeLabel)

        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8).priority(999)
            make.left.right.equalToSuperview().inset(16)
        }

        typeLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8).priority(999)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(8).priority(999)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
