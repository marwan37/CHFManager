//
//  Weight+CoreDataProperties.swift
//  CHFManager
//
//  Created by Marwan Zaarab on 2021-01-02.
//
//

import Foundation
import CoreData


extension Weight {

    @nonobjc public class func getWeightData() -> NSFetchRequest<Weight> {
        let request:NSFetchRequest<Weight> = Weight.fetchRequest() as! NSFetchRequest<Weight>
            let sortDescriptor = NSSortDescriptor(key: "weightIndex", ascending: true)
            request.sortDescriptors = [sortDescriptor]
        return request
    }

    @NSManaged public var month: String
    @NSManaged public var weight: Double
    @NSManaged public var weightIndex: Int
    @NSManaged public var ofUser: Userdetails?

}

extension Weight : Identifiable {

}
