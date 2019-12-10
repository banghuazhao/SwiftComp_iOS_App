//
//  FileManager.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 12/10/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import Foundation

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}
