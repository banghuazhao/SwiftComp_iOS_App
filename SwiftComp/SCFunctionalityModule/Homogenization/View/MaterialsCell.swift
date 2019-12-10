//
//  MaterialCell.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 11/25/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import UIKit

protocol MaterialCellDelegate: AnyObject {
    func changeSelectedMaterialType(index: Int, materialTitle: String?)
    func importButtonTapped(sectionTitle: String)
    func exportButtonTapped(sectionTitle: String)
}

class MaterialsCell: UITableViewCell {
    // MARK: - model

    var materials: Materials? {
        didSet {
            titleLabel.text = materials?.sectionTitle
            materialTypeControl.removeAllSegments()
            for (index, material) in materials?.materials.enumerated() ?? [Material]().enumerated() {
                materialTypeControl.insertSegment(withTitle: material.getMaterialTypeText(), at: index, animated: false)
            }
            materialTypeControl.selectedSegmentIndex = materials?.selectedIndex ?? 0
            numberOfMaterialCardRows = (materials?.selectedMaterial.materialProperties.count ?? 0) + 1
            materialCardHeight = CGFloat(numberOfMaterialCardRows) * materialCardCellHeight
            cellView.snp.updateConstraints { make in
                make.height.equalTo(cellHeight)
            }
            materialCard.snp.updateConstraints { (make) in
                make.height.equalTo(materialCardHeight)
            }
            materialCard.reloadData()
        }
    }

    weak var delegate: MaterialCellDelegate?
    
    private var numberOfMaterialCardRows: Int = 0
    
    private let materialCardCellHeight: CGFloat = 40
    
    private var materialCardHeight: CGFloat = 0

    private var cellHeight: CGFloat {
        return 16 + 21 + 16 + 30 + 16 + materialCardHeight + 16
    }

    private lazy var spaceView: UIView = {
        let view = UIView()
        return view
    }()

    // MARK: - UI element

    private lazy var cellView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .SCTitle
        label.text = "Material"
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
    
    private lazy var exportButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "export"), for: .normal)
        button.addTarget(self, action: #selector(exportButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var importButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "import"), for: .normal)
        button.addTarget(self, action: #selector(importButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var materialTypeControl: UISegmentedControl = {
        let sc = UISegmentedControl()
        sc.addTarget(self, action: #selector(materialTypeControlChange(_:)), for: .valueChanged)
        return sc
    }()

    private lazy var materialCard: UITableView = {
        let tableView = UITableView()
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = UIColor.materialCardBorderColor.cgColor
        tableView.allowsSelection = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .materialCardColor
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.isScrollEnabled = false
        tableView.register(MaterialNameCell.self, forCellReuseIdentifier: "MaterialNameCell")
        tableView.register(MaterialPropertyCell.self, forCellReuseIdentifier: "MaterialPropertyCell")
        return tableView
    }()

    // MARK: - life cycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - private function

extension MaterialsCell {
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
        cellView.addSubview(exportButton)
        cellView.addSubview(importButton)
        cellView.addSubview(materialTypeControl)
        cellView.addSubview(materialCard)

        titleLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(16)
            make.height.equalTo(21)
        }
        explainButton.snp.makeConstraints { (make) in
             make.top.right.equalToSuperview().inset(16)
             make.size.equalTo(21)
        }
        importButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(16)
            make.right.equalToSuperview().inset(16+21+20)
            make.size.equalTo(21)
        }
        exportButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(16)
            make.right.equalToSuperview().inset(16+21+20+21+20)
            make.size.equalTo(21)
        }
        materialTypeControl.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.height.equalTo(30)
        }

        materialCard.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(materialTypeControl.snp.bottom).offset(16)
            make.height.equalTo(materialCardHeight)
        }
    }
}


// MARK: - actions

extension MaterialsCell {
    @objc private func materialTypeControlChange(_ sender: UISegmentedControl) {
        materials?.selectedIndex = sender.selectedSegmentIndex
        delegate?.changeSelectedMaterialType(index: sender.selectedSegmentIndex, materialTitle: titleLabel.text)
    }
    
    @objc private func explainButtonTapped() {
        let title = "Material"

        let message = """
            • Isotropic Material:
            Elastic: E, nu
            Thermoelastic: ɑ

            • Transversely Material:
            Elastic: E1, E2, G12, nu12, nu23
            Thermoelastic: ɑ11, ɑ22

            • Orthotropic Material:
            Elastic: E1, E2, E3, G12, G13, G23, nu12, nu13, nu23
            Thermoelastic: ɑ11, ɑ22, ɑ33

            • Anisotropic Material:
            Elastic: C11, C12, C13, C14, C15, C16, C22, C23, C24, C25, C26, C33, C34, C35, C36, C44, C45, C46, C55, C56, C66
            Thermoelastic: ɑ11, ɑ22, ɑ33, ɑ23, ɑ13, ɑ12
            """
        let popupWindow = SCPopupWindow(title: title, message: message)
        popupWindow.show(completion: nil)
    }
    
    @objc private func exportButtonTapped() {
        delegate?.exportButtonTapped(sectionTitle: materials?.sectionTitle ?? "Material")
    }
    
    @objc private func importButtonTapped() {
        delegate?.importButtonTapped(sectionTitle: materials?.sectionTitle ?? "Material")
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension MaterialsCell: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfMaterialCardRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MaterialNameCell") as? MaterialNameCell else { return UITableViewCell() }
           cell.material = materials?.selectedMaterial
           return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MaterialPropertyCell") as? MaterialPropertyCell else { return UITableViewCell() }
            cell.materialProperty = materials?.selectedMaterial.materialProperties[indexPath.row - 1]
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return materialCardCellHeight
    }
}
