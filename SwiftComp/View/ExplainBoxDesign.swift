//
//  ExplainPopovers.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 3/26/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import UIKit

class ExplainBoxDesign: NSObject {
    
    let blackView = UIView()
    
    let explainView: UIView = {
        let v = UIView()
        v.backgroundColor = .systemGray6
        return v
    }()
    
    
    override init() {
        super.init()
        //start doing something here maybe....
    }
    
    func showExplain(boxWidth: CGFloat = 320, boxHeight: CGFloat = 360, title: String, explainDetailView: UIView) {
        //show menu
        
        explainView.subviews.forEach({ $0.removeFromSuperview() }) // first remove all subviews
        
        if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            
            window.addSubview(blackView)
            
            blackView.frame = window.frame
            blackView.alpha = 0
            
            window.addSubview(explainView)
            
            var w: CGFloat = boxWidth
            if boxWidth >= UIScreen.main.bounds.width {
                w = UIScreen.main.bounds.width - 40
            }
            let h: CGFloat = boxHeight
            let x = window.center.x - w / 2
            let y = window.center.y - h / 2
            explainView.frame = CGRect(x: x, y: window.frame.height, width: w, height: h)
            
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.blackView.alpha = 1
                
                self.explainView.frame = CGRect(x: x, y: y, width: self.explainView.frame.width, height: self.explainView.frame.height)
                
            }, completion: nil)
        }

        let titleUIView = UIView()
        let explainScrollView = UIScrollView()
        explainView.addSubview(titleUIView)
        explainView.addSubview(explainScrollView)
        
        titleUIView.translatesAutoresizingMaskIntoConstraints = false
        titleUIView.topAnchor.constraint(equalTo: explainView.topAnchor, constant: 12).isActive = true
        titleUIView.leftAnchor.constraint(equalTo: explainView.leftAnchor, constant: 8).isActive = true
        titleUIView.rightAnchor.constraint(equalTo: explainView.rightAnchor, constant: -8).isActive = true
        
        
        let titleLabel = UILabel()
        titleUIView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.topAnchor.constraint(equalTo: titleUIView.topAnchor, constant: 0).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: titleUIView.centerXAnchor, constant: 0).isActive = true
        titleUIView.heightAnchor.constraint(equalToConstant: titleLabel.intrinsicContentSize.height).isActive = true
        
        explainScrollView.translatesAutoresizingMaskIntoConstraints = false
        explainScrollView.topAnchor.constraint(equalTo: titleUIView.bottomAnchor, constant: 12).isActive = true
        explainScrollView.leftAnchor.constraint(equalTo: explainView.leftAnchor, constant: 16).isActive = true
        explainScrollView.rightAnchor.constraint(equalTo: explainView.rightAnchor, constant: -16).isActive = true
        explainScrollView.bottomAnchor.constraint(equalTo: explainView.bottomAnchor, constant: -16).isActive = true
        
        explainScrollView.addSubview(explainDetailView)
        
        explainDetailView.translatesAutoresizingMaskIntoConstraints = false
        
        explainDetailView.widthAnchor.constraint(equalTo: explainScrollView.widthAnchor, multiplier: 1.0) .isActive = true
        explainDetailView.topAnchor.constraint(equalTo: explainScrollView.topAnchor, constant: 0).isActive = true
        explainDetailView.bottomAnchor.constraint(equalTo: explainScrollView.bottomAnchor, constant: -20).isActive = true
    }
    
    @objc func handleDismiss() {
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            
            if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
                self.explainView.frame = CGRect(x: window.center.x - self.explainView.frame.width / 2, y: window.frame.height, width: self.explainView.frame.width, height: self.explainView.frame.height)
            }
        }
    }
}



extension UIView {

    func explainDetialViewPureTextDesign(pureText: String) {
        
        let explainLabel = UILabel()
        self.addSubview(explainLabel)
        
        explainLabel.translatesAutoresizingMaskIntoConstraints = false
        explainLabel.text = pureText
        explainLabel.numberOfLines = 0
        explainLabel.lineBreakMode = .byWordWrapping
        explainLabel.font = UIFont.systemFont(ofSize: 14)
        explainLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        explainLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        explainLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        explainLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        
    }
    
}
