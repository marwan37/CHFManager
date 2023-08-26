//
//  MasterData+CoreDataProperties.swift
//  CHFManager
//
//  Created by Marwan Zaarab on 2021-01-02.
//
//

import Foundation
import CoreData

extension MasterData {

    @nonobjc public class func getDayData() -> NSFetchRequest<MasterData> {
        let request:NSFetchRequest<MasterData> = MasterData.fetchRequest() as! NSFetchRequest<MasterData>
        
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
    //        let predicate = NSPredicate(format: "date == %@", "Dec")
    //        request.predicate = predicate
        request.sortDescriptors = [sortDescriptor]
    
        return request

    }

    @NSManaged public var date: Date?
    @NSManaged public var dyspnea: Int
    @NSManaged public var fatigue: Int
    @NSManaged public var id: String?
    @NSManaged public var liquids: Double
    @NSManaged public var percentage: Double
    @NSManaged public var rxComp: Double
    @NSManaged public var swelling: Int
    @NSManaged public var ofUser: Userdetails?

}

extension MasterData : Identifiable {

}
