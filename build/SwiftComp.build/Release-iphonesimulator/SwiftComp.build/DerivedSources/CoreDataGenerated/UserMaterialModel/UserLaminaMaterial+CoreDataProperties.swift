//
//  UserLaminaMaterial+CoreDataProperties.swift
//  
//
//  Created by Banghua Zhao on 12/7/17.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension UserLaminaMaterial {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserLaminaMaterial> {
        return NSFetchRequest<UserLaminaMaterial>(entityName: "UserLaminaMaterial")
    }

    @NSManaged public var name: String?
    @NSManaged public var properties: [Double]?

}
