//
//  HomSolidResultCell.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 11/30/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import UIKit

class HomSolidResultCell: UITableViewCell {
    // MARK: - model

    var homSolidResult: HomSolidResult? {
        didSet {
            solidStiffnessMatrixCollectionView.reloadData()
            engineeringConstantsTableView.reloadData()
            if homSolidResult?.thermalCoefficients != nil {
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

    private let tableViewHeaderHeight: CGFloat = 40
    private let tableViewCellHeight: CGFloat = 36
    private let collectionViewCellHeight: CGFloat = 30

    private lazy var solidStiffnessMatrixCollectionViewHeight: CGFloat = tableViewHeaderHeight + collectionViewCellHeight * 6
    private lazy var engineeringConstantsTableViewHeight: CGFloat = tableViewHeaderHeight + tableViewCellHeight * 9
    private lazy var thermalCoefficientsTableViewHeight: CGFloat = tableViewHeaderHeight + tableViewCellHeight * 6

    private lazy var cellElasticHeight: CGFloat = 53 + solidStiffnessMatrixCollectionViewHeight + 16 + engineeringConstantsTableViewHeight + 16
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
        label.text = "Solid Model Result"
        label.font = .SCTitle
        label.textAlignment = .left
        return label
    }()

    private lazy var solidStiffnessMatrixCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.layer.borderWidth = 1
        collectionView.layer.borderColor = UIColor.SCGreen.cgColor
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(HomResultCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HomResultCollectionHeaderView")
        collectionView.register(HomResultMatrixCell.self, forCellWithReuseIdentifier: "HomResultMatrix")
        return collectionView
    }()

    private lazy var engineeringConstantsTableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = UIColor.SCGreen.cgColor
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
        tableView.layer.borderColor = UIColor.SCGreen.cgColor
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

// MARK: - actions

extension HomSolidResultCell {
}

// MARK: - private function

extension HomSolidResultCell {
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
        cellView.addSubview(solidStiffnessMatrixCollectionView)
        cellView.addSubview(engineeringConstantsTableView)
        cellView.addSubview(thermalCoefficientsTableView)

        titleLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(16)
            make.height.equalTo(21)
        }

        solidStiffnessMatrixCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(solidStiffnessMatrixCollectionViewHeight)
        }

        engineeringConstantsTableView.snp.makeConstraints { make in
            make.top.equalTo(solidStiffnessMatrixCollectionView.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(engineeringConstantsTableViewHeight)
        }

        thermalCoefficientsTableView.snp.makeConstraints { make in
            make.top.equalTo(engineeringConstantsTableView.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(thermalCoefficientsTableViewHeight)
        }
    }
}

// MARK: - HomResultControllerDelegate

extension HomSolidResultCell: HomResultControllerDelegate {
    func homResultControllerSizeChange() {
        solidStiffnessMatrixCollectionView.collectionViewLayout.invalidateLayout()
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension HomSolidResultCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 7 * 8) / 6.0
        return CGSize(width: width, height: 30)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
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
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HomResultCollectionHeaderView", for: indexPath) as! HomResultCollectionHeaderView

            headerView.title = "Effective Solid Stiffness Matrix"
            return headerView
        }
        return UICollectionReusableView()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homSolidResult?.effectiveSolidStiffnessArray.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomResultMatrix", for: indexPath) as? HomResultMatrixCell else { return UICollectionViewCell() }
        cell.homResultMatrix = homSolidResult?.effectiveSolidStiffnessArray[indexPath.item]
        return cell
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension HomSolidResultCell: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch tableView {
        case engineeringConstantsTableView:
            return HomResultHeaderView(title: "Engineering Constants")
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
        case engineeringConstantsTableView:
            return homSolidResult?.engineeringConstantsArray.count ?? 0
        case thermalCoefficientsTableView:
            return homSolidResult?.thermalCoefficientsArray.count ?? 0
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case engineeringConstantsTableView:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomResultPropertyCell") as? HomResultPropertyCell else { return UITableViewCell() }
            cell.homResultProperty = homSolidResult?.engineeringConstantsArray[indexPath.row]
            return cell
        case thermalCoefficientsTableView:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomResultPropertyCell") as? HomResultPropertyCell else { return UITableViewCell() }
            cell.homResultProperty = homSolidResult?.thermalCoefficientsArray[indexPath.row]
            return cell
        default:
            return UITableViewCell()
        }
    }
}
