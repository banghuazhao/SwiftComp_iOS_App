//
//  CompositeModelCell.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 10/22/17.
//  Copyright © 2017 Banghua Zhao. All rights reserved.
//

import UIKit

class CompositeModelCell: UITableViewCell {
    var compositeModel: CompositeModel? {
        didSet {
            coverImageView.image = compositeModel?.image
            nameLabel.text = compositeModel?.name
            subnameLabel.text = compositeModel?.subname
        }
    }

    let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .blackThemeColor
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    let subnameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .greyFontColor
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .whiteThemeColor
        self.accessoryType = .disclosureIndicator

        addSubview(coverImageView)
        coverImageView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview().inset(8)
            make.left.equalToSuperview().inset(12)
            make.size.equalTo(70)
        }

        addSubview(nameLabel)
        nameLabel.leftAnchor.constraint(equalTo: coverImageView.rightAnchor, constant: 8).isActive = true
        nameLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -120).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -14).isActive = true

        addSubview(subnameLabel)
        subnameLabel.leftAnchor.constraint(equalTo: coverImageView.rightAnchor, constant: 8).isActive = true
        subnameLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -120).isActive = true
        subnameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        subnameLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 16).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
