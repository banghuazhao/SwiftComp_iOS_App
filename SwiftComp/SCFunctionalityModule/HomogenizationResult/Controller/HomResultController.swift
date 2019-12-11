//
//  HomResultController.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 11/26/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import UIKit
import Moya

protocol HomResultControllerDelegate: AnyObject {
    func homResultControllerSizeChange()
}

class HomResultController: UIViewController {
    weak var delegate: HomResultControllerDelegate?

    var homBeamResult: HomBeamResult?
    var homPlateResult: HomPlateResult?
    var homSolidResult: HomSolidResult?
    var homMeshImage: HomMeshImage?
    var homInformation: HomInformation?
    
    lazy private var provider = MoyaProvider<HomResultAPI>()

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .greybackgroundColor
        tableView.register(HomBeamResultCell.self, forCellReuseIdentifier: "HomBeamResultCell")
        tableView.register(HomPlateResultCell.self, forCellReuseIdentifier: "HomPlateResultCell")
        tableView.register(HomSolidResultCell.self, forCellReuseIdentifier: "HomSolidResultCell")
        tableView.register(HomMeshImageCell.self, forCellReuseIdentifier: "HomMeshImageCell")
        tableView.register(HomInformationCell.self, forCellReuseIdentifier: "HomInformationCell")
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setToolbarHidden(true, animated: false)
        navigationItem.title = "Homogenization Result"
        setupView()
        getMeshImage()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        delegate?.homResultControllerSizeChange()
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        if parent == nil {
            guard let homInformation = homInformation else { return }
            provider.request(.delete(homInformation: homInformation)) { result in
                switch result {
                case let .success(moyaResponse):
                    do {
                        _ = try moyaResponse.filterSuccessfulStatusCodes()
                        print("successful deleted \(homInformation.swiftcompCwd)")
                    } catch let error {
                        print(error)
                    }
                case let .failure(error):
                    print(error)
                }
            }
        }
    }
}

// MARK: - private functions

extension HomResultController {
    private func setupView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func getMeshImage() {
        guard let homInformation = homInformation, homMeshImage != nil else { return }
        provider.request(.meshImage(homInformation: homInformation)) { result in
            switch result {
            case let .success(moyaResponse):
                do {
                    _ = try moyaResponse.filterSuccessfulStatusCodes()
                    self.homMeshImage?.imageData = moyaResponse.data
                    self.homMeshImage?.status = .success
                } catch let error {
                    print(error)
                    self.homMeshImage?.status = .failed
                }
            case let .failure(error):
                print(error)
                self.homMeshImage?.status = .failed
            }
            self.tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension HomResultController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return HomogenizationHeaderView(title: "Homogenization Result")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = 1
        if homMeshImage != nil {
            numberOfRows += 1
        }
        if homInformation != nil {
            numberOfRows += 1
        }
        return numberOfRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 && homBeamResult != nil {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomBeamResultCell") as? HomBeamResultCell else { return UITableViewCell() }
            cell.homBeamResult = homBeamResult
            cell.delegate = self
            delegate = cell
            return cell
        } else if indexPath.row == 0 && homPlateResult != nil {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomPlateResultCell") as? HomPlateResultCell else { return UITableViewCell() }
            cell.homPlateResult = homPlateResult
            cell.delegate = self
            delegate = cell
            return cell
        } else if indexPath.row == 0 && homSolidResult != nil {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomSolidResultCell") as? HomSolidResultCell else { return UITableViewCell() }
            cell.homSolidResult = homSolidResult
            cell.delegate = self
            delegate = cell
            return cell
        } else if indexPath.row == 1 && homMeshImage != nil {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomMeshImageCell") as? HomMeshImageCell else { return UITableViewCell() }
            cell.indicator.startAnimating()
            cell.homMeshImage = homMeshImage
            cell.delegate = self
            return cell
        } else if indexPath.row == 1 && homMeshImage == nil && homInformation != nil {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomInformationCell") as? HomInformationCell else { return UITableViewCell() }
            cell.homInformation = homInformation
            cell.delegate = self
            return cell
        } else if indexPath.row == 2 && homMeshImage != nil && homInformation != nil {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomInformationCell") as? HomInformationCell else { return UITableViewCell() }
            cell.homInformation = homInformation
            cell.delegate = self
            return cell
        }
        return UITableViewCell()
    }
}

// MARK: - HomBeamResultCellDelegate

extension HomResultController: HomBeamResultCellDelegate {
    func beamShareButtonTapped() {
        guard let homBeamResult = homBeamResult else { return }
        let shareText: String = homBeamResult.getSharedResultText()
        let file = getDocumentsDirectory().appendingPathComponent("HomogenizationResult.txt")
        do {
            try shareText.write(to: file, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
        }
        let activityVC = UIActivityViewController(activityItems: [file], applicationActivities: nil)
        if let popoverController = activityVC.popoverPresentationController {
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.sourceView = self.view
            popoverController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        }
        present(activityVC, animated: true, completion: nil)
    }
}

// MARK: - HomPlateResultCellDelegate

extension HomResultController: HomPlateResultCellDelegate {
    func plateShareButtonTapped() {
        guard let homPlateResult = homPlateResult else { return }
        let shareText: String = homPlateResult.getSharedResultText()
        let file = getDocumentsDirectory().appendingPathComponent("HomogenizationResult.txt")
        do {
            try shareText.write(to: file, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
        }
        let activityVC = UIActivityViewController(activityItems: [file], applicationActivities: nil)
        if let popoverController = activityVC.popoverPresentationController {
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.sourceView = self.view
            popoverController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        }
        present(activityVC, animated: true, completion: nil)
    }
}

// MARK: - HomSolidResultCellDelegate

extension HomResultController: HomSolidResultCellDelegate {
    func solidShareButtonTapped() {
        guard let homSolidResult = homSolidResult else { return }
        let shareText: String = homSolidResult.getSharedResultText()
        let file = getDocumentsDirectory().appendingPathComponent("HomogenizationResult.txt")
        do {
            try shareText.write(to: file, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
        }
        let activityVC = UIActivityViewController(activityItems: [file], applicationActivities: nil)
        if let popoverController = activityVC.popoverPresentationController {
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.sourceView = self.view
            popoverController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        }
        present(activityVC, animated: true, completion: nil)
    }
}

// MARK: - HomMeshImageCellDelegate

extension HomResultController: HomMeshImageCellDelegate {
    func shareMeshImage() {
        switch homMeshImage?.status {
        case .success:
            guard let imageData = homMeshImage?.imageData else { return }
            guard let meshImage = UIImage(data: imageData) else { return }
            
            // set up activity view controller
            let imageToShare = [meshImage]
            let activityVC = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
            
            if let popoverController = activityVC.popoverPresentationController {
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverController.sourceView = self.view
                popoverController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
            }

            // present the view controller
            present(activityVC, animated: true, completion: nil)
        case .getting:
            let ac = UIAlertController(title: "Image Loading", message: "Please wait", preferredStyle: UIAlertController.Style.alert)
            ac.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            present(ac, animated: true, completion: nil)
        case .failed:
            let ac = UIAlertController(title: "Failed to Load Image", message: "", preferredStyle: UIAlertController.Style.alert)
            ac.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            present(ac, animated: true, completion: nil)
        case .none:
            break
        }
    }
}

// MARK: - HomInformationCellDelegate

extension HomResultController: HomInformationCellDelegate {
    func showCalculationDetail() {
        let detailController = HomCalculationDetailController()
        detailController.calculationDetail = homInformation?.swiftcompCalculationInfo ?? "Not available"
        navigationController?.pushViewController(detailController, animated: true)
    }
}
