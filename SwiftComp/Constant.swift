//
//  Constant.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 11/10/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import UIKit

let appID = "1297825946"

let baseURL = "http://128.46.6.100:8888"

let isIPhone : Bool = UIDevice.current.userInterfaceIdiom == .phone

let isIPad : Bool = UIDevice.current.userInterfaceIdiom == .pad

let isMac : Bool = !isIPhone && !isIPad
