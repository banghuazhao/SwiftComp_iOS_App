//
//  CompositeModelCell.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 10/22/17.
//  Copyright © 2017 Banghua Zhao. All rights reserved.
//

import UIKit

class CompositeModelCell: UITableViewCell {
    
    // MARK: - model
    
    var compositeModel: CompositeModel? {
        didSet {
            coverImageView.image = compositeModel?.image
            nameLabel.text = compositeModel?.name
            subnameLabel.text = compositeModel?.subname
            setupTags()
        }
    }

    private lazy var coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .SCTitle
        label.sizeToFit()
        return label
    }()

    private lazy var subnameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .SCIcon
        return label
    }()
    
    lazy var beamTag = SCTag(tagName: "Beam")
    
    lazy var plateTag = SCTag(tagName: "Plate")
    
    lazy var solidTag = SCTag(tagName: "Solid")
    
    // MARK: - life cycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        accessoryType = .disclosureIndicator
        separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - private function

extension CompositeModelCell {
    private func setupView() {
        addSubview(coverImageView)
        addSubview(nameLabel)
        addSubview(subnameLabel)

        coverImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(72)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(coverImageView.snp.right).offset(16)
            make.right.equalToSuperview().offset(-32)
            make.top.equalToSuperview().inset(16)
        }

        subnameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(coverImageView.snp.right).offset(16)
            make.right.equalToSuperview().offset(-32)
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.bottom.equalToSuperview().inset(42)
        }
        
        addSubview(beamTag)
        addSubview(plateTag)
        addSubview(solidTag)
        beamTag.snp.makeConstraints { (make) in
            make.left.equalTo(coverImageView.snp.right).offset(16)
            make.height.equalTo(20)
            make.top.equalTo(subnameLabel.snp.bottom).offset(8)
        }
        
        plateTag.snp.makeConstraints { (make) in
            make.left.equalTo(coverImageView.snp.right).offset(16)
            make.height.equalTo(20)
            make.top.equalTo(subnameLabel.snp.bottom).offset(8)
        }
        
        solidTag.snp.makeConstraints { (make) in
            make.left.equalTo(coverImageView.snp.right).offset(16)
            make.height.equalTo(20)
            make.top.equalTo(subnameLabel.snp.bottom).offset(8)
        }
        beamTag.isHidden = true
        plateTag.isHidden = true
        solidTag.isHidden = true
    }
    
    private func setupTags() {
        if compositeModel?.structrualModels.contains(.beam) ?? false {
            beamTag.isHidden = false
            plateTag.snp.remakeConstraints { (make) in
                make.left.equalTo(beamTag.snp.right).offset(10)
                make.height.equalTo(20)
                make.top.equalTo(subnameLabel.snp.bottom).offset(8)
            }
        }
        
        if compositeModel?.structrualModels.contains(.plate) ?? false {
            plateTag.isHidden = false
            solidTag.snp.remakeConstraints { (make) in
                make.left.equalTo(plateTag.snp.right).offset(10)
                make.height.equalTo(20)
                make.top.equalTo(subnameLabel.snp.bottom).offset(8)
            }
        }
        
        if compositeModel?.structrualModels.contains(.solid) ?? false {
            solidTag.isHidden = false
        }
    }
}
