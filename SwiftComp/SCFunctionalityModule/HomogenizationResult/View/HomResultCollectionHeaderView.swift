//
//  HomResultHeaderView.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 11/17/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import UIKit

class HomResultCollectionHeaderView: UICollectionReusableView {
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.SCTitle
        label.textColor = .white
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .SCGreen
        setupView()
    }

    private func setupView() {
        addSubview(titleLabel)

        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview()
            make.height.equalTo(40)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
