//
//  UserMatrixMaterial+CoreDataProperties.swift
//  
//
//  Created by Banghua Zhao on 12/7/17.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension UserMatrixMaterial {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserMatrixMaterial> {
        return NSFetchRequest<UserMatrixMaterial>(entityName: "UserMatrixMaterial")
    }

    @NSManaged public var name: String?
    @NSManaged public var properties: [Double]?

}
