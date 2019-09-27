//
//  HomeUserManual.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 8/30/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import UIKit
import WebKit

class HomeUserManual: UIViewController {
    
    let userManualName = "SwiftComp User Manual"

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .whitebackgroundColor
                
        self.title = userManualName
        
        fetchUserManualFile()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
        
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
