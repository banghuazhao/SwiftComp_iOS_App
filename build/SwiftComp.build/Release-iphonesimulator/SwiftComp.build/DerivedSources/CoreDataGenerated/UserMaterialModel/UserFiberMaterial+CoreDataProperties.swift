//
//  UserFiberMaterial+CoreDataProperties.swift
//  
//
//  Created by Banghua Zhao on 12/7/17.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension UserFiberMaterial {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserFiberMaterial> {
        return NSFetchRequest<UserFiberMaterial>(entityName: "UserFiberMaterial")
    }

    @NSManaged public var name: String?
    @NSManaged public var properties: [Double]?

}
