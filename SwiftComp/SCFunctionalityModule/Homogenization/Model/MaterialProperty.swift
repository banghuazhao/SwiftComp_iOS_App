//
//  MaterialProperty.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 11/26/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import Foundation

class MaterialProperty {
    enum Name: String {
        case E, nu
        case E1, E2, E3, G12, G13, G23, nu12, nu13, nu23
        case eta121, eta122, eta123, eta1323, eta2313
        case C11, C12, C13, C14, C15, C16, C22, C23, C24, C25, C26, C33, C34, C35, C36, C44, C45, C46, C55, C56, C66
        case alpha
        case alpha11, alpha22, alpha33, alpha23, alpha13, alpha12
    }

    let name: Name
    var nameLabel: String {
        switch name {
        case .E:
            return "Young's Modulus E"
        case .nu:
            return "Poisson's Ratio ν"
        case .E1:
            return "Young's Modulus E₁"
        case .E2:
            return "Young's Modulus E₂"
        case .E3:
            return "Young's Modulus E₃"
        case .G12:
            return "Shear Modulus G₁₂"
        case .G13:
            return "Shear Modulus G₁₃"
        case .G23:
            return "Shear Modulus G₂₃"
        case .nu12:
            return "Poisson's Ratio ν₁₂"
        case .nu13:
            return "Poisson's Ratio ν₁₃"
        case .nu23:
            return "Poisson's Ratio ν₂₃"
        case .eta121:
            return "Mutual Influence η₁₂‚₁"
        case .eta122:
            return "Mutual Influencet η₁₂‚₂"
        case .eta123:
            return "Mutual Influence η₁₂‚₃"
        case .eta1323:
            return "Mutual Influence η₁₃‚₂₃"
        case .eta2313:
            return "Mutual Influence η₂₃‚₁₃"
        case .C11:
            return "Material Constant C₁₁"
        case .C12:
            return "Material Constant C₁₂"
        case .C13:
            return "Material Constant C₁₃"
        case .C14:
            return "Material Constant C₁₄"
        case .C15:
            return "Material Constant C₁₅"
        case .C16:
            return "Material Constant C₁₆"
        case .C22:
            return "Material Constant C₂₂"
        case .C23:
            return "Material Constant C₂₃"
        case .C24:
            return "Material Constant C₂₄"
        case .C25:
            return "Material Constant C₂₅"
        case .C26:
            return "Material Constant C₂₆"
        case .C33:
            return "Material Constant C₃₃"
        case .C34:
            return "Material Constant C₃₄"
        case .C35:
            return "Material Constant C₃₅"
        case .C36:
            return "Material Constant C₃₆"
        case .C44:
            return "Material Constant C₄₄"
        case .C45:
            return "Material Constant C₄₅"
        case .C46:
            return "Material Constant C₄₆"
        case .C55:
            return "Material Constant C₅₅"
        case .C56:
            return "Material Constant C₅₆"
        case .C66:
            return "Material Constant C₆₆"
        case .alpha:
            return "CTE α"
        case .alpha11:
            return "CTE α₁₁"
        case .alpha22:
            return "CTE α₂₂"
        case .alpha33:
            return "CTE α₃₃"
        case .alpha23:
            return "CTE α₂₃"
        case .alpha13:
            return "CTE α₁₃"
        case .alpha12:
            return "CTE α₁₂"
        }
    }
    
    var value: Double?
    var valueText: String {
        didSet {
            value = Double(valueText)
        }
    }

    init(name: Name) {
        self.name = name
        value = nil
        valueText = ""
    }

    init(name: Name, value: Double) {
        self.name = name
        self.value = value
        valueText = "\(value)"
    }
}
