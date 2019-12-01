//
//  HowResultMatrixCell.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 11/30/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import UIKit

class HomResultMatrixCell: UICollectionViewCell {
    
    var homResultMatrix: HomResultMatrix? {
        didSet {
            titleLabel.text = homResultMatrix?.valueText
            titleLabel.textColor = homResultMatrix?.valueText == "Not available" ? UIColor.SCNumber : UIColor.SCTitle
        }
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .SCTitle
        label.font = .SCParameterLabel
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - private functions
extension HomResultMatrixCell {
    private func setupView() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
