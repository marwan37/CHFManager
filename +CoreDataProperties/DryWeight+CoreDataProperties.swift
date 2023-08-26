//
//  DryWeight+CoreDataProperties.swift
//  CHFManager
//
//  Created by Marwan Zaarab on 2021-01-14.
//
//

import Foundation
import CoreData


extension DryWeight {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DryWeight> {
        return NSFetchRequest<DryWeight>(entityName: "DryWeight")
    }

    @NSManaged public var dryWeight: String
    @NSManaged public var monthYear: String

}

extension DryWeight : Identifiable {

}
