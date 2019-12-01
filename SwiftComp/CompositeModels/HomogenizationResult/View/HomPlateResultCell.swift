//
//  HomPlateResultCell.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 11/30/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import UIKit

class HomPlateResultCell: UITableViewCell {
    // MARK: - model

    var homPlateResult: HomPlateResult? {
        didSet {
            plateStiffnessMatrixCollectionView.reloadData()
            transverseShearStiffnessTableView.reloadData()
            inPlanePropertiesTableView.reloadData()
            flexuralPropertiesTableView.reloadData()
            if homPlateResult?.thermalCoefficients != nil {
                cellView.snp.updateConstraints { make in
                    make.height.equalTo(cellThermoElasticHeight)
                }
                thermalCoefficientsTableView.isHidden = false
                thermalCoefficientsTableView.reloadData()
            } else {
                cellView.snp.updateConstraints { make in
                    make.height.equalTo(cellElasticHeight)
                }
                thermalCoefficientsTableView.isHidden = true
            }
        }
    }
    
    var sixCellWidth: CGFloat = 0 {
        didSet {
            plateStiffnessMatrixCollectionView.collectionViewLayout.invalidateLayout()
        }
    }

    private let tableViewHeaderHeight: CGFloat = 40
    private let tableViewCellHeight: CGFloat = 36
    private let collectionViewCellHeight: CGFloat = 30

    private lazy var plateStiffnessMatrixCollectionViewHeight: CGFloat = tableViewHeaderHeight + collectionViewCellHeight * 6
    private lazy var transverseShearStiffnessTableViewHeight: CGFloat = tableViewHeaderHeight + tableViewCellHeight * 3
    private lazy var inPlanePropertiesTableViewHeight: CGFloat = tableViewHeaderHeight + tableViewCellHeight * 6
    private lazy var flexuralPropertiesTableViewHeight: CGFloat = tableViewHeaderHeight + tableViewCellHeight * 6
    private lazy var thermalCoefficientsTableViewHeight: CGFloat = tableViewHeaderHeight + tableViewCellHeight * 6

    private lazy var cellElasticHeight: CGFloat = 53 + plateStiffnessMatrixCollectionViewHeight + 16 + transverseShearStiffnessTableViewHeight + 16 + inPlanePropertiesTableViewHeight + 16 + flexuralPropertiesTableViewHeight + 16
    private lazy var cellThermoElasticHeight: CGFloat = cellElasticHeight + 16 + thermalCoefficientsTableViewHeight + 16

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
        label.text = "Plate Model Result"
        label.font = .SCTitle
        label.textAlignment = .left
        return label
    }()

    private lazy var plateStiffnessMatrixCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.layer.borderWidth = 1
        collectionView.layer.borderColor = UIColor.SCGreenHighLight.cgColor
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(HomResultCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HomResultCollectionHeaderView")
        collectionView.register(HomResultMatrixCell.self, forCellWithReuseIdentifier: "HomResultMatrix")
        return collectionView
    }()

    private lazy var transverseShearStiffnessTableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = UIColor.SCGreenHighLight.cgColor
        tableView.allowsSelection = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.isScrollEnabled = false
        tableView.register(HomResultPropertyCell.self, forCellReuseIdentifier: "HomResultPropertyCell")
        return tableView
    }()

    private lazy var inPlanePropertiesTableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = UIColor.SCGreenHighLight.cgColor
        tableView.allowsSelection = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.isScrollEnabled = false
        tableView.register(HomResultPropertyCell.self, forCellReuseIdentifier: "HomResultPropertyCell")
        return tableView
    }()

    private lazy var flexuralPropertiesTableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = UIColor.SCGreenHighLight.cgColor
        tableView.allowsSelection = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.isScrollEnabled = false
        tableView.register(HomResultPropertyCell.self, forCellReuseIdentifier: "HomResultPropertyCell")
        return tableView
    }()

    private lazy var thermalCoefficientsTableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = UIColor.SCGreenHighLight.cgColor
        tableView.allowsSelection = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.isScrollEnabled = false
        tableView.register(HomResultPropertyCell.self, forCellReuseIdentifier: "HomResultPropertyCell")
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

extension HomPlateResultCell {
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
            make.height.equalTo(cellElasticHeight)
            make.bottom.equalToSuperview().priority(999)
        }

        cellView.addSubview(titleLabel)
        cellView.addSubview(plateStiffnessMatrixCollectionView)
        cellView.addSubview(transverseShearStiffnessTableView)
        cellView.addSubview(inPlanePropertiesTableView)
        cellView.addSubview(flexuralPropertiesTableView)
        cellView.addSubview(thermalCoefficientsTableView)

        titleLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(16)
            make.height.equalTo(21)
        }

        plateStiffnessMatrixCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(plateStiffnessMatrixCollectionViewHeight)
        }

        transverseShearStiffnessTableView.snp.makeConstraints { make in
            make.top.equalTo(plateStiffnessMatrixCollectionView.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(transverseShearStiffnessTableViewHeight)
        }

        inPlanePropertiesTableView.snp.makeConstraints { make in
            make.top.equalTo(transverseShearStiffnessTableView.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(inPlanePropertiesTableViewHeight)
        }

        flexuralPropertiesTableView.snp.makeConstraints { make in
            make.top.equalTo(inPlanePropertiesTableView.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(flexuralPropertiesTableViewHeight)
        }

        thermalCoefficientsTableView.snp.makeConstraints { make in
            make.top.equalTo(flexuralPropertiesTableView.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(thermalCoefficientsTableViewHeight)
        }
    }
}

// MARK: - HomResultControllerDelegate
extension HomPlateResultCell: HomResultControllerDelegate {
    func homResultControllerSizeChange(viewSize: CGFloat) {
        sixCellWidth = (viewSize - 64 - 6 * 7) / 6.0
        plateStiffnessMatrixCollectionView.collectionViewLayout.invalidateLayout()
    }
}


// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension HomPlateResultCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: sixCellWidth, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if (kind == UICollectionView.elementKindSectionHeader) {
            // Create Header
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HomResultCollectionHeaderView", for: indexPath) as! HomResultCollectionHeaderView

            headerView.title = "Effective Plate Stiffness Matrix"
            return headerView
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homPlateResult?.effectivePlateStiffnessArray.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomResultMatrix", for: indexPath) as? HomResultMatrixCell else { return UICollectionViewCell() }
        cell.homResultMatrix = homPlateResult?.effectivePlateStiffnessArray[indexPath.item]
        return cell
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension HomPlateResultCell: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch tableView {
        case transverseShearStiffnessTableView:
            return HomResultHeaderView(title: "Transverse Shear Stiffness")
        case inPlanePropertiesTableView:
            return HomResultHeaderView(title: "In-Plane Properties")
        case flexuralPropertiesTableView:
            return HomResultHeaderView(title: "Flexural Properties")
        case thermalCoefficientsTableView:
            return HomResultHeaderView(title: "Thermal Coefficients")
        default:
            return UIView()
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableViewCellHeight
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case transverseShearStiffnessTableView:
            return homPlateResult?.effectivePlateStiffnessRefinedArray.count ?? 0
        case inPlanePropertiesTableView:
            return homPlateResult?.inPlanePropertiesArray.count ?? 0
        case flexuralPropertiesTableView:
            return homPlateResult?.flexuralPropertiesArray.count ?? 0
        case thermalCoefficientsTableView:
            return homPlateResult?.thermalCoefficientsArray.count ?? 0
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case transverseShearStiffnessTableView:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomResultPropertyCell") as? HomResultPropertyCell else { return UITableViewCell() }
            cell.homResultProperty = homPlateResult?.effectivePlateStiffnessRefinedArray[indexPath.row]
            return cell
        case inPlanePropertiesTableView:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomResultPropertyCell") as? HomResultPropertyCell else { return UITableViewCell() }
            cell.homResultProperty = homPlateResult?.inPlanePropertiesArray[indexPath.row]
            return cell
        case flexuralPropertiesTableView:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomResultPropertyCell") as? HomResultPropertyCell else { return UITableViewCell() }
            cell.homResultProperty = homPlateResult?.flexuralPropertiesArray[indexPath.row]
            return cell
        case thermalCoefficientsTableView:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomResultPropertyCell") as? HomResultPropertyCell else { return UITableViewCell() }
            cell.homResultProperty = homPlateResult?.thermalCoefficientsArray[indexPath.row]
            return cell
        default:
            return UITableViewCell()
        }
    }
}
