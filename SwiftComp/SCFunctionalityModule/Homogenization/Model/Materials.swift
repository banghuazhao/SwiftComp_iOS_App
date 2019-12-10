//
//  Materials.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 11/26/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import Foundation

class Materials {
    var sectionTitle: String = "Material"
    var materials: [Material]
    var selectedIndex: Int
    var selectedMaterial: Material {
        return materials[selectedIndex]
    }

    init(materials: [Material], selectedIndex: Int) {
        self.materials = materials
        self.selectedIndex = selectedIndex
    }
    
    init(sectionTitle: String, materials: [Material], selectedIndex: Int) {
        self.sectionTitle = sectionTitle
        self.materials = materials
        self.selectedIndex = selectedIndex
    }
    
    func changeSelectedMaterial(newMaterial: Material, newSelectedIndex: Int) {
        materials[newSelectedIndex] = newMaterial
        selectedIndex = newSelectedIndex
    }
}
