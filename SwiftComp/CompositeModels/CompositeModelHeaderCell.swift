//
//  CompositeModelHeaderView.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 11/13/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import UIKit

class CompositeModelHeaderCell: UITableViewHeaderFooterView {
    lazy var spaceView: UIView = {
        let view = UIView()
        return view
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()

    init(title: String) {
        super.init(reuseIdentifier: nil)
        titleLabel.text = title
        setupView()
    }

    private func setupView() {
        addSubview(spaceView)
        addSubview(titleLabel)

        spaceView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalToSuperview()
            make.height.equalTo(20)
        }

        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(spaceView.snp.bottom)
            make.bottom.equalToSuperview().inset(12)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
