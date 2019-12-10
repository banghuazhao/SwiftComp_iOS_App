//
//  Math.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 12/10/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import Foundation
import Accelerate

// Inverse operation for matrix

func invert(matrix: [Double]) -> [Double] {
    var inMatrix = matrix
    let N = __CLPK_integer(sqrt(Double(matrix.count)))
    var pivots = [__CLPK_integer](repeating: 0, count: Int(N))
    var workspace = [Double](repeating: 0.0, count: Int(N))
    var error: __CLPK_integer = 0

    // Mutable copies to circumvent "Simultaneous accesses to var 'N'" error in Swift 4
    var N1 = N, N2 = N, N3 = N
    dgetrf_(&N1, &N2, &inMatrix, &N3, &pivots, &error)
    dgetri_(&N1, &inMatrix, &N2, &pivots, &workspace, &N3, &error)
    return inMatrix
}
