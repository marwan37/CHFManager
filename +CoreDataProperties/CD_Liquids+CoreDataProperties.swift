//
//  CD_Liquids+CoreDataProperties.swift
//  CHFManager
//
//  Created by Marwan Zaarab on 2021-01-21.
//
//

import Foundation
import CoreData


extension CD_Liquids {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CD_Liquids> {
        return NSFetchRequest<CD_Liquids>(entityName: "CD_Liquids")
    }

    @NSManaged public var intake: Double
    @NSManaged public var date: Date
    @NSManaged public var limit: Double

}

extension CD_Liquids : Identifiable {

}
