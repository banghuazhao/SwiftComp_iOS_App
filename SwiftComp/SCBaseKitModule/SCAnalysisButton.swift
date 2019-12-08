//
//  SCAnalysisButton.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 11/19/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import UIKit

class SCAnalysisButton: UIButton {
    
    open override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                alpha = 0.2
            } else {
                alpha = 1
            }
        }
    }
    
    private lazy var buttonTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
    }()

    private lazy var toggleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "toggle")
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
        backgroundColor = .SCGreen
        layer.cornerRadius = 6

        snp.makeConstraints { make in
            make.height.equalTo(36)
        }
        
        addSubview(buttonTitleLabel)
        addSubview(toggleImageView)
        
        buttonTitleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(48)
        }
        
        toggleImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(16)
            make.size.equalTo(16)
        }
    }
}

// MARK: - public functions

extension SCAnalysisButton {
    func changeButtonTitle(title: String) {
        buttonTitleLabel.text = title
    }
    
    func hideToggleImageValue() {
        toggleImageView.isHidden = true
    }
    
}
