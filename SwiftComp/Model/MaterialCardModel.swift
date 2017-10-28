//
//  MaterialCardModel.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 10/27/17.
//  Copyright © 2017 Banghua Zhao. All rights reserved.
//

import Foundation


class MaterialCardModel {
    let materialPropertyName: String
    let materialPropertyPlaceHolder: String
    
    init(name: String, placeHolder: String) {
        self.materialPropertyName = name
        self.materialPropertyPlaceHolder = placeHolder
    }
    
}
