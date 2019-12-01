//
//  SwiftCompCalculationInfo.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 8/29/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import UIKit

class HomCalculationDetailController: UIViewController {
    
    var calculationDetail: String = ""

    lazy var scrollView: UIScrollView = UIScrollView()

    lazy var swiftCompCalculationInfoTextView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.font = UIFont.systemFont(ofSize: 12)
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .whiteThemeColor

        navigationItem.title = "SwiftComp Calculation Detail"

        editLayout()
    }

    func editLayout() {
        let button = UIButton(type: .custom)
        button.snp.makeConstraints { make in
            make.size.equalTo(20)
        }
        button.setImage(UIImage(named: "download"), for: .normal)
        button.addTarget(self, action: #selector(shareCalculationInfo), for: .touchUpInside)

        let barButtonItem = UIBarButtonItem(customView: button)

        navigationItem.rightBarButtonItem = barButtonItem

        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        scrollView.addSubview(swiftCompCalculationInfoTextView)
        swiftCompCalculationInfoTextView.text = calculationDetail
        
        swiftCompCalculationInfoTextView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview().inset(16)
            make.width.equalTo(view).offset(-32)
            make.bottom.equalToSuperview().offset(-40)
        }
        
    }

    @objc func shareCalculationInfo() {
        let file = getDocumentsDirectory().appendingPathComponent("SwiftComp_calculation_info.txt")

        do {
            try calculationDetail.write(to: file, atomically: true, encoding: String.Encoding.utf8)
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
