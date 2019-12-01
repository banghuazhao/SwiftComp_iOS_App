//
//  HomResultHeaderView.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 11/17/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import UIKit

class HomResultHeaderView: UITableViewHeaderFooterView {

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.SCTitle
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    init(title: String) {
        super.init(reuseIdentifier: nil)
        titleLabel.text = title
        contentView.backgroundColor = .SCGreenHighLight
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
