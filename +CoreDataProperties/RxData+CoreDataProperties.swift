//
//  RxData+CoreDataProperties.swift
//  CHFManager
//
//  Created by Marwan Zaarab on 2021-01-13.
//
//

import Foundation
import CoreData


extension RxData {

    @nonobjc public class func getRx() -> NSFetchRequest<RxData> {
        let request:NSFetchRequest<RxData> = RxData.fetchRequest() as! NSFetchRequest<RxData>
        
        let sortDescriptor = NSSortDescriptor(key: "gen", ascending: true)
    //        let predicate = NSPredicate(format: "date == %@", "Dec")
    //        request.predicate = predicate
        request.sortDescriptors = [sortDescriptor]
    
        return request

    }
    @NSManaged public var id: String?
    @NSManaged public var gen: String
    @NSManaged public var brand: String
    @NSManaged public var type: String
    @NSManaged public var freq: String
    @NSManaged public var dose: String
    @NSManaged public var qty: Int

 
}
