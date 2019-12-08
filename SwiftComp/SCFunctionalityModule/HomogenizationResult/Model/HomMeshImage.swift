//
//  HomMeshImage.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 12/1/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import Foundation

class HomMeshImage {
    var imageData: Data
    enum Status {
        case failed
        case success
        case getting
    }
    var status: Status = .getting
    
    init(imageData: Data) {
        self.imageData = imageData
    }
}
