//
//  HomeUserManual.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 8/30/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import UIKit
import WebKit

class UserManualController: UIViewController {
    let userManualName = "SwiftComp User Manual"

    var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        return progressView
    }()

    lazy var webView: WKWebView = {
        let webView = WKWebView()
        return webView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .whiteThemeColor

        let button = UIButton(type: .custom)
        button.snp.makeConstraints { make in
            make.size.equalTo(20)
        }
        button.setImage(UIImage(named: "download"), for: .normal)
        button.addTarget(self, action: #selector(download), for: .touchUpInside)

        let barButtonItem = UIBarButtonItem(customView: button)

        navigationItem.rightBarButtonItem = barButtonItem

        navigationItem.title = userManualName

        view.addSubview(webView)

        view.addSubview(progressView)
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        progressView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            } else {
                make.top.equalTo(view.snp.top)
            }
            make.height.equalTo(3)
        }
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)

        if let url = Bundle.main.url(forResource: self.userManualName, withExtension: "pdf") {
            let urlRequest = URLRequest(url: url)
            webView.load(urlRequest)
        }
    }

    @objc func download() {
        if let url = Bundle.main.url(forResource: self.userManualName, withExtension: "pdf") {
            let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            
            if let popoverController = activityVC.popoverPresentationController {
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverController.sourceView = self.view
                popoverController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
            }

            present(activityVC, animated: true, completion: nil)
        }
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
            if Float(webView.estimatedProgress) == 1.0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.progressView.isHidden = true
                }
            }
        }
    }
}
