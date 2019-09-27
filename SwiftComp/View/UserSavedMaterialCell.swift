//
//  UserSavedMaterialCell.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 11/4/17.
//  Copyright © 2017 Banghua Zhao. All rights reserved.
//

import UIKit

class UserSavedMaterialCell: UITableViewCell {
    
    let materialCardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let materialTypeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(materialCardImageView)
        materialCardImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        materialCardImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        materialCardImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        materialCardImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        materialCardImageView.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        addSubview(nameLabel)
        nameLabel.leftAnchor.constraint(equalTo: materialCardImageView.rightAnchor, constant: 8).isActive = true
        nameLabel.topAnchor.constraint(equalTo: materialCardImageView.topAnchor, constant: 0).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        addSubview(materialTypeLabel)
        materialTypeLabel.leftAnchor.constraint(equalTo: materialCardImageView.rightAnchor, constant: 8).isActive = true
        materialTypeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 0).isActive = true
        materialTypeLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        materialTypeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        materialTypeLabel.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        materialTypeLabel.font = UIFont.systemFont(ofSize: 12)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

