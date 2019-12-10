//
//  MethodCell.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 11/20/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import UIKit

protocol TypeOfAnalysisCellDelegate: AnyObject {
    func changeTypeOfAnalysis(button: SCAnalysisButton)
}

class TypeOfAnalysisCell: UITableViewCell {
    var typeOfAnalysis: TypeOfAnalysis? {
        didSet {
            switch typeOfAnalysis {
            case .elastic:
                analysisButton.changeButtonTitle(title: Constant.TypeOfAnalysisName.elastic)
                explain = """
                    • Elastic Analysis:
                    You need to provide elastic properites to do the analysis. The elastic properties are Young's modulus, shear modlulus, Poisson's ratio, or elastic constants (Cij).
                    """
            case .thermoElastic:
                analysisButton.changeButtonTitle(title: Constant.TypeOfAnalysisName.thermoElastic)
                explain = """
                    • Thermoelastic Analysis:
                    In addtional to elastic properties (Young's modulus, shear modlulus, Poisson's ratio, or elastic constants), you also need to provide CTEs (Coefficients of Thermal Expansion) to do the analysis.
                    """
            default:
                return
            }
        }
    }

    weak var delegate: TypeOfAnalysisCellDelegate?
    
    private var explain: String = ""

    private let cellHeight = 16 + 21 + 16 + 36 + 16

    // MARK: - UI element

    lazy var spaceView: UIView = {
        let view = UIView()
        return view
    }()

    lazy var cellView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        return view
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .SCTitle
        label.text = "Type of Analysis"
        label.font = .SCTitle
        label.textAlignment = .left
        return label
    }()

    private lazy var explainButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "explain"), for: .normal)
        button.addTarget(self, action: #selector(explainButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var analysisButton = SCAnalysisButton()

    // MARK: - life cycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        analysisButton.addTarget(self, action: #selector(analysisButtonTapped(button:)), for: .touchUpInside)
        backgroundColor = .clear
        selectionStyle = .none
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - private function

extension TypeOfAnalysisCell {
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
        cellView.addSubview(explainButton)
        cellView.addSubview(analysisButton)

        titleLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(16)
            make.height.equalTo(21)
        }

        explainButton.snp.makeConstraints { (make) in
            make.top.right.equalToSuperview().inset(16)
            make.size.equalTo(21)
        }
        
        analysisButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
        }
    }
}

// MARK: - actions

extension TypeOfAnalysisCell {
    @objc private func analysisButtonTapped(button: SCAnalysisButton) {
        delegate?.changeTypeOfAnalysis(button: button)
    }
    
    @objc private func explainButtonTapped() {
        let title = "Type of Analysis"
        let popupWindow = SCPopupWindow(title: title, message: explain)
        popupWindow.show(completion: nil)
    }
}
