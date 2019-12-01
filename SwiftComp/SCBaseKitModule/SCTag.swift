//
//  SCTag.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 11/24/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import UIKit


class SCTag: UILabel {
    
    var topInset: CGFloat = 2.0
    var bottomInset: CGFloat = 2.0
    var leftInset: CGFloat = 8.0
    var rightInset: CGFloat = 8.0
        
    init(tagName: String) {
        super.init(frame: .zero)
        text = tagName
        layer.backgroundColor = UIColor(hex: 0xF7F7F7).cgColor
        layer.cornerRadius = 4
        textColor = .SCNumber
        font = UIFont.systemFont(ofSize: 12)        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
}
