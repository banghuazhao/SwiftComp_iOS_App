//
//  MethodCell.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 11/20/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import UIKit

protocol MethodCellDelegate: AnyObject {
    func changeMethod(button: SCAnalysisButton)
}

class MethodCell: UITableViewCell {
    
    // MARK: - model
    var method: Method? {
        didSet {
            switch method {
            case .swiftComp:
                analysisButton.changeButtonTitle(title: "SwiftComp")
                explain = """
                    • SwiftComp:
                    General-purpose computational approach for constitutive modeling of composite materials
                    """
            case .nonSwiftComp(.clpt):
                analysisButton.changeButtonTitle(title: "Classical Laminated Plate Theory")
                explain = """
                    • Classical Laminated Plate Theory (CLPT):
                    1. Straight lines normal to the mid-surface remain straight after deformation
                    2. Straight lines normal to the mid-surface remain normal to the mid-surface after deformation
                    3. The thickness of the plate does not change during a deformation
                    """
            case .nonSwiftComp(.voigtROM):
                analysisButton.changeButtonTitle(title: "Voigt Rules of Mixture")
                explain = """
                    • Voigt Rules of Mixture:
                    The strain field within the RVE is constant
                    """
            case .nonSwiftComp(.reussROM):
                analysisButton.changeButtonTitle(title: "Reuss Rules of Mixture")
                explain = """
                    • Reuss Rules of Mixture:
                    The stress field within the RVE is constant
                    """
            case .nonSwiftComp(.hybridROM):
                analysisButton.changeButtonTitle(title: "Hybrid Rules of Mixture")
                explain = """
                    • Hybrid Rules of Mixture:
                    A subset of local stress components (sigma22, sigma33, sigma23, sigma13, sigma12) along with a complementary subset of local strain components (epsilon11) are constant
                    """
            default:
                return
            }
        }
    }
    
    weak var delegate: MethodCellDelegate?
    
    private var explain: String = ""
    
    private let cellHeight = 16 + 21 + 16 + 36 + 16
    
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
        label.text = "Method"
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

    private lazy var analysisButton = SCAnalysisButton()
    
    // MARK: - life cycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        analysisButton.addTarget(self, action: #selector(analysisButtonTapped(button:)), for: .touchUpInside)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - actions

extension MethodCell {
    @objc private func analysisButtonTapped(button: SCAnalysisButton) {
        delegate?.changeMethod(button: button)
    }
    
    @objc private func explainButtonTapped() {
        let title = "Method"
        let popupWindow = SCPopupWindow(title: title, message: explain)
        popupWindow.show(completion: nil)
    }
}

// MARK: - private function

extension MethodCell {
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
