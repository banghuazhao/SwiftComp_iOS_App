//
//  HomeUserManual.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 8/30/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import UIKit
import WebKit

class UserManualViewController: UIViewController {
    
    let userManualName = "SwiftComp User Manual"

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .whiteThemeColor
        
        let shareButtonImage = UIImage.fontAwesomeIcon(name: .download, style: .solid, textColor: .white, size: CGSize(width: 30, height: 30))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: shareButtonImage, style: .plain, target: self, action: #selector(download))
                
        self.navigationItem.title = userManualName
        
        fetchUserManualFile()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
        
    }
    
    @objc func download() {
        
        if let url = Bundle.main.url(forResource: self.userManualName, withExtension: "pdf") {
                        
            let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash

            self.present(activityViewController, animated: true, completion: nil)
        }

    }


    func fetchUserManualFile() {
        
        let webView = WKWebView(frame: self.view.frame)
        

        if let url = Bundle.main.url(forResource: self.userManualName, withExtension: "pdf") {
            
            let urlRequest = URLRequest(url: url)
            
            webView.load(urlRequest)
            
            self.view.addSubview(webView)
            
        }
    }

}
