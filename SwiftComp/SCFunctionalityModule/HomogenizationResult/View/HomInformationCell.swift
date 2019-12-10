//
//  HomInformationCell.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 12/1/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import UIKit

protocol HomInformationCellDelegate: AnyObject {
    func showCalculationDetail()
}

class HomInformationCell: UITableViewCell {
    
    // MARK: - model
    var homInformation: HomInformation? {
        didSet {
            timeValueLabel.text = homInformation?.calculationTimeText
        }
    }
    
    weak var delegate: HomInformationCellDelegate?
    
    private let cellHeight = 16 + 21 + 16 + 21 + 16 + 36 + 16
    
    // MARK: - UI elements

    private lazy var spaceView: UIView = {
        let view = UIView()
        return view
    }()

    private lazy var cellView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .SCTitle
        label.text = "SwiftComp Calculation Information"
        label.font = .SCTitle
        label.textAlignment = .left
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .SCTitle
        label.font = .SCParameterLabel
        label.text = "Calculation time (sec)"
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        return label
    }()

    private lazy var timeValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .SCTitle
        label.font = .SCParameterLabel
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        return label
    }()

    private lazy var detailButton = SCAnalysisButton()
    
    // MARK: - life cycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        detailButton.changeButtonTitle(title: "Show Calculation Detail")
        detailButton.hideToggleImageValue()
        detailButton.addTarget(self, action: #selector(detailButtonTapped(_:)), for: .touchUpInside)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// actions

extension HomInformationCell {
    @objc private func detailButtonTapped(_ sender: UIButton) {
        delegate?.showCalculationDetail()
    }
}

// MARK: - private function

extension HomInformationCell {
    private func setupView() {
        addSubview(spaceView)
        addSubview(cellView)

        spaceView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalToSuperview()
            make.height.equalTo(20)
        }

        cellView.snp.makeConstraints { make in
            make.top.equalTo(spaceView.snp.bottom)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(cellHeight)
            make.bottom.equalToSuperview().priority(999)
        }

        cellView.addSubview(titleLabel)
        cellView.addSubview(timeLabel)
        cellView.addSubview(timeValueLabel)
        cellView.addSubview(detailButton)

        titleLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(16)
            make.height.equalTo(21)
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().multipliedBy(0.5).offset(-8)
            make.height.equalTo(21)
        }
        
        timeValueLabel.snp.makeConstraints { make in
            make.left.equalTo(timeLabel.snp.right).offset(16)
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalTo(timeLabel)
            make.height.equalTo(21)
        }

        detailButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(timeLabel.snp.bottom).offset(16)
        }
    }
}

