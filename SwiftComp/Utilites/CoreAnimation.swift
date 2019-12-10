//
//  CoreAnimation.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 12/10/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import UIKit

func createPath(beginPoint: CGPoint, endPoint: CGPoint) -> UIBezierPath {
    let path = UIBezierPath()
    path.move(to: beginPoint)
    path.addLine(to: endPoint)
    return path
}
