//
//  UserLaminaMaterial+CoreDataProperties.swift
//  
//
//  Created by Banghua Zhao on 9/16/19.
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
    @NSManaged public var properties: NSObject?
    @NSManaged public var type: String?

}
