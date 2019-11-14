//
//  CloundCalculateButton.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 11/12/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import UIKit

class SCCalculateButton: UIButton {
    var style: Style?

    enum Style {
        case local
        case cloud
        case noInternet
    }

    private lazy var title: UILabel = {
        let label = UILabel()
        label.text = "Calculate"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()

    private lazy var cloudImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "cloud")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    init() {
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        layer.cornerRadius = intrinsicContentSize.height / 2
        backgroundColor = .swiftcompLogoColor

        snp.makeConstraints { make in
            make.width.equalTo(260)
            make.height.equalTo(36)
        }

        addSubview(title)

        addSubview(cloudImageView)

        title.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        cloudImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.height.equalTo(20)
        }
    }

    func changeStyle(style: Style) {
        removeTarget(nil, action: nil, for: .allEvents)
        switch style {
        case .cloud:
            backgroundColor = .swiftcompLogoColor
            cloudImageView.isHidden = false
        case .local:
            backgroundColor = .swiftcompLogoColor
            cloudImageView.isHidden = true
        case .noInternet:
            backgroundColor = .gray
            cloudImageView.isHidden = false
        }
    }
}
