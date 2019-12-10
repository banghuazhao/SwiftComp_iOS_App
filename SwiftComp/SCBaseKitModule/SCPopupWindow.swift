//
//  SCPopupWindow.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 12/8/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import BZPopupWindow

class SCPopupWindow: BZPopupWindow {
    override var messageAligment: NSTextAlignment {
        get {
            return .left
        }
        set {
            
        }
    }
    
    override var width: CGFloat {
        get {
            return 320
        }
        set {
            
        }
    }
}
