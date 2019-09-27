//
//  UserStackingSequence+CoreDataProperties.swift
//  
//
//  Created by Banghua Zhao on 9/16/19.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension UserStackingSequence {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserStackingSequence> {
        return NSFetchRequest<UserStackingSequence>(entityName: "UserStackingSequence")
    }

    @NSManaged public var name: String?
    @NSManaged public var stackingSequence: String?

}
