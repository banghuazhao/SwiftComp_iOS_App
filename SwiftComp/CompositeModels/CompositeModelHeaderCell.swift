//
//  CompositeModelHeaderView.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 11/13/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import UIKit

class CompositeModelHeaderCell: UITableViewHeaderFooterView {
    lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = .greyFont2Color
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        return label
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        contentView.backgroundColor = .clear

        contentView.addSubview(label)

        label.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
