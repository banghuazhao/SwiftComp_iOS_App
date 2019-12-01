//
//  SCColor.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 11/19/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    convenience init(hex: Int) {
        self.init(
            red: (hex >> 16) & 0xFF,
            green: (hex >> 8) & 0xFF,
            blue: hex & 0xFF
        )
    }
    
    static let SCGreenHighLight = UIColor(hex: 0x81C547)
    static let SCTitle = UIColor(hex: 0x333333)
    static let SCSeparator = UIColor(hex: 0xE5E5E5)
    static let SCBlueHighLight = UIColor(hex: 0x556B96)
    static let SCBackground = UIColor(hex: 0xEFEFF4)
    static let SCPlaceholder = UIColor(hex: 0xB3B3B3)
    static let SCNumber = UIColor(hex: 0x878C97)
    static let SCIcon = UIColor(hex: 0x666666)
}


