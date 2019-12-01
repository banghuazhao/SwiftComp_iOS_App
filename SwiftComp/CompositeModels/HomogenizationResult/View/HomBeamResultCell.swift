//
//  HomBeamResultCell.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 11/30/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import UIKit

class HomBeamResultCell: UITableViewCell {
    // MARK: - model

    var homBeamResult: HomBeamResult? {
        didSet {
            effectiveBeamStiffness4by4CollectionView.isHidden = true
            effectiveBeamStiffness6by6CollectionView.isHidden = true
            thermalCoefficientsTableView.isHidden = true

            if homBeamResult?.effectiveBeamStiffness4by4 != nil {
                effectiveBeamStiffness4by4CollectionView.reloadData()
                effectiveBeamStiffness4by4CollectionView.isHidden = false
                if homBeamResult?.thermalCoefficients != nil {
                    cellView.snp.updateConstraints { make in
                        make.top.equalTo(effectiveBeamStiffness4by4CollectionView.snp.bottom).offset(16)
                        make.height.equalTo(cell4by4ThermoElasticHeight)
                    }
                    thermalCoefficientsTableView.isHidden = false
                    thermalCoefficientsTableView.reloadData()
                } else {
                    cellView.snp.updateConstraints { make in
                        make.height.equalTo(cell4by4ElasticHeight)
                    }
                }
            }

            if homBeamResult?.effectiveBeamStiffness6by6 != nil {
                effectiveBeamStiffness6by6CollectionView.reloadData()
                effectiveBeamStiffness6by6CollectionView.isHidden = false
                if homBeamResult?.thermalCoefficients != nil {
                    cellView.snp.updateConstraints { make in
                        make.top.equalTo(effectiveBeamStiffness6by6CollectionView.snp.bottom).offset(16)
                        make.height.equalTo(cell6by6ThermoElasticHeight)
                    }
                    thermalCoefficientsTableView.isHidden = false
                    thermalCoefficientsTableView.reloadData()
                } else {
                    cellView.snp.updateConstraints { make in
                        make.height.equalTo(cell6by6ElasticHeight)
                    }
                }
            }
        }
    }

    var fourCellWidth: CGFloat = 0 {
        didSet {
            effectiveBeamStiffness4by4CollectionView.collectionViewLayout.invalidateLayout()
        }
    }

    var sixCellWidth: CGFloat = 0 {
        didSet {
            effectiveBeamStiffness6by6CollectionView.collectionViewLayout.invalidateLayout()
        }
    }

    private let tableViewHeaderHeight: CGFloat = 40
    private let tableViewCellHeight: CGFloat = 36
    private let collectionViewCellHeight: CGFloat = 30

    private lazy var effectiveBeamStiffness4by4CollectionViewHeight: CGFloat = tableViewHeaderHeight + collectionViewCellHeight * 4
    private lazy var effectiveBeamStiffness6by6CollectionViewHeight: CGFloat = tableViewHeaderHeight + collectionViewCellHeight * 6
    private lazy var thermalCoefficientsTableViewHeight: CGFloat = tableViewHeaderHeight + tableViewCellHeight * 6

    private lazy var cell4by4ElasticHeight: CGFloat = 53 + effectiveBeamStiffness4by4CollectionViewHeight + 16
    private lazy var cell6by6ElasticHeight: CGFloat = 53 + effectiveBeamStiffness6by6CollectionViewHeight + 16
    private lazy var cell4by4ThermoElasticHeight: CGFloat = cell4by4ElasticHeight + 16 + thermalCoefficientsTableViewHeight + 16
    private lazy var cell6by6ThermoElasticHeight: CGFloat = cell6by6ElasticHeight + 16 + thermalCoefficientsTableViewHeight + 16

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
        label.text = "Beam Model Result"
        label.font = .SCTitle
        label.textAlignment = .left
        return label
    }()

    private lazy var effectiveBeamStiffness4by4CollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.layer.borderWidth = 1
        collectionView.layer.borderColor = UIColor.SCGreenHighLight.cgColor
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(HomResultCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HomResultCollectionHeaderView")
        collectionView.register(HomResultMatrixCell.self, forCellWithReuseIdentifier: "effectiveBeamStiffness4by4CollectionViewCell")
        return collectionView
    }()

    private lazy var effectiveBeamStiffness6by6CollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.layer.borderWidth = 1
        collectionView.layer.borderColor = UIColor.SCGreenHighLight.cgColor
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(HomResultCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HomResultCollectionHeaderView")
        collectionView.register(HomResultMatrixCell.self, forCellWithReuseIdentifier: "effectiveBeamStiffness6by6CollectionViewCell")
        return collectionView
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

extension HomBeamResultCell {
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
            make.height.equalTo(cell4by4ElasticHeight)
            make.bottom.equalToSuperview().priority(999)
        }

        cellView.addSubview(titleLabel)
        cellView.addSubview(effectiveBeamStiffness4by4CollectionView)
        cellView.addSubview(effectiveBeamStiffness6by6CollectionView)
        cellView.addSubview(thermalCoefficientsTableView)

        titleLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(16)
            make.height.equalTo(21)
        }

        effectiveBeamStiffness4by4CollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(effectiveBeamStiffness4by4CollectionViewHeight)
        }
        
        effectiveBeamStiffness6by6CollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(effectiveBeamStiffness6by6CollectionViewHeight)
        }

        thermalCoefficientsTableView.snp.makeConstraints { make in
            make.top.equalTo(effectiveBeamStiffness4by4CollectionView.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(thermalCoefficientsTableViewHeight)
        }
    }
}

// MARK: - HomResultControllerDelegate

extension HomBeamResultCell: HomResultControllerDelegate {
    func homResultControllerSizeChange(viewSize: CGFloat) {
        sixCellWidth = (viewSize - 64 - 6 * 7) / 6.0
        fourCellWidth = (viewSize - 64 - 6 * 5) / 4.0
        effectiveBeamStiffness4by4CollectionView.collectionViewLayout.invalidateLayout()
        effectiveBeamStiffness6by6CollectionView.collectionViewLayout.invalidateLayout()
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension HomBeamResultCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case effectiveBeamStiffness4by4CollectionView:
            return CGSize(width: fourCellWidth, height: 30)
        case effectiveBeamStiffness6by6CollectionView:
            return CGSize(width: sixCellWidth, height: 30)
        default:
            return .zero
        }
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
        if kind == UICollectionView.elementKindSectionHeader {
            switch collectionView {
            case effectiveBeamStiffness4by4CollectionView:
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HomResultCollectionHeaderView", for: indexPath) as! HomResultCollectionHeaderView

                headerView.title = "Effective Beam Stiffness Matrix"
                return headerView
            case effectiveBeamStiffness6by6CollectionView:
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HomResultCollectionHeaderView", for: indexPath) as! HomResultCollectionHeaderView

                headerView.title = "Effective Beam Stiffness Matrix (Refined)"
                return headerView
            default:
                break
            }
        }
        return UICollectionReusableView()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case effectiveBeamStiffness4by4CollectionView:
            return homBeamResult?.effectiveBeamStiffness4by4Array.count ?? 0
        case effectiveBeamStiffness6by6CollectionView:
             return homBeamResult?.effectiveBeamStiffness6by6Array.count ?? 0
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case effectiveBeamStiffness4by4CollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "effectiveBeamStiffness4by4CollectionViewCell", for: indexPath) as? HomResultMatrixCell else { return UICollectionViewCell() }
            cell.homResultMatrix = homBeamResult?.effectiveBeamStiffness4by4Array[indexPath.item]
            return cell
        case effectiveBeamStiffness6by6CollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "effectiveBeamStiffness6by6CollectionViewCell", for: indexPath) as? HomResultMatrixCell else { return UICollectionViewCell() }
            cell.homResultMatrix = homBeamResult?.effectiveBeamStiffness6by6Array[indexPath.item]
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension HomBeamResultCell: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch tableView {
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
        case thermalCoefficientsTableView:
            return homBeamResult?.thermalCoefficientsArray.count ?? 0
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case thermalCoefficientsTableView:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomResultPropertyCell") as? HomResultPropertyCell else { return UITableViewCell() }
            cell.homResultProperty = homBeamResult?.thermalCoefficientsArray[indexPath.row]
            return cell
        default:
            return UITableViewCell()
        }
    }
}
