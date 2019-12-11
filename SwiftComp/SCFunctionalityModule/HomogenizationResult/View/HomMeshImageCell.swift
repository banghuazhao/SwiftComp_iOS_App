//
//  HomMeshImageCell.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 12/1/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import UIKit

protocol HomMeshImageCellDelegate: class {
    func shareMeshImage()
}

class HomMeshImageCell: UITableViewCell {
    // MARK: - model

    var homMeshImage: HomMeshImage? {
        didSet {
            guard let homMeshImage = homMeshImage else { return }
            switch homMeshImage.status {
            case .success:
                meshImageView.image = UIImage(data: homMeshImage.imageData)
                meshImageView.backgroundColor = .clear
                failedIndicator.isHidden = true
                indicator.stopAnimating()
            case .failed:
                failedIndicator.isHidden = false
                indicator.stopAnimating()
            case .getting:
                failedIndicator.isHidden = true
                indicator.startAnimating()
            }

        }
    }

    weak var delegate: HomMeshImageCellDelegate?

    private let cellHeight = 16 + 21 + 16 + 256 + 16

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
        label.text = "Mesh Image"
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
    
    private lazy var shareButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "share"), for: .normal)
        button.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var meshImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .SCSeparator
        return imageView
    }()

    var indicator = UIActivityIndicatorView()
    
    private lazy var failedIndicator: UILabel = {
        let label = UILabel()
        label.text = "Failed to get mesh image"
        label.textColor = .red
        return label
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

extension HomMeshImageCell {
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
        cellView.addSubview(shareButton)
        cellView.addSubview(meshImageView)

        titleLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(16)
            make.height.equalTo(21)
        }
        
        explainButton.snp.makeConstraints { (make) in
            make.top.right.equalToSuperview().inset(16)
            make.size.equalTo(21)
        }
        
        shareButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(16)
            make.right.equalToSuperview().inset(16+21+20)
            make.size.equalTo(21)
        }

        meshImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(256)
        }
        
        meshImageView.addSubview(indicator)
        meshImageView.addSubview(failedIndicator)
        
        indicator.snp.makeConstraints { (make) in
            make.size.equalTo(32)
            make.center.equalToSuperview()
        }
        
        if #available(iOS 13.0, *) {
            indicator.style = .medium
        } else {
            indicator.style = .gray
        }
        indicator.hidesWhenStopped = true
        
        failedIndicator.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        failedIndicator.isHidden = true
    }
}

// MARK: - action

extension HomMeshImageCell {
    @objc private func explainButtonTapped() {
        let title = "Mesh Image"
        let attributedTitle = NSAttributedString(string: title, attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .bold),
            NSAttributedString.Key.foregroundColor: UIColor.black])
        
        let message = "The mesh image is generated by Gmsh. The mesh information is used to create input file for SwiftComp."
        let attributedMessage: NSMutableAttributedString = NSMutableAttributedString(string: message)
        let clickHereTange = (attributedMessage.string as NSString).range(of: "Gmsh")
        attributedMessage.addAttribute(NSAttributedString.Key.link, value: "http://gmsh.info/", range: clickHereTange)
        attributedMessage.addAttributes([
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15),
            NSAttributedString.Key.foregroundColor: UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)]
        , range: NSRange(location: 0, length: attributedMessage.string.count))
        
        let popupWindow = SCPopupWindow(title: attributedTitle, message: attributedMessage)
        popupWindow.show(completion: nil)
    }
    
    @objc private func shareButtonTapped() {
        delegate?.shareMeshImage()
    }
}
