//
//  Method.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 11/23/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import Foundation

enum Method: Equatable {
    case swiftComp
    case nonSwiftComp(NonSwiftComp)
    enum NonSwiftComp {
        case clpt
        case voigtROM
        case reussROM
        case hybridROM
    }
}
