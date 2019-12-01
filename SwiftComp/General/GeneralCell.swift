//
//  GeneralModelCell.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 10/1/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import UIKit

class GeneralCell: UITableViewCell {
    var generalModel: GeneralModel? {
        didSet {
            generalImageView.image = generalModel?.image
            nameLabel.text = generalModel?.name
        }
    }

    let generalImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .blackThemeColor
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .whiteThemeColor

        addSubview(generalImageView)
        addSubview(nameLabel)
        
        generalImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.bottom.equalToSuperview().inset(16).priority(999)
            make.size.equalTo(20)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(generalImageView.snp.right).offset(16)
            make.right.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
