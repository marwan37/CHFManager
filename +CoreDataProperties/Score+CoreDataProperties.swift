//
//  Score+CoreDataProperties.swift
//  CHFManager
//
//  Created by Marwan Zaarab on 2021-01-02.
//
//

import Foundation
import CoreData


extension Score {

    @nonobjc public class func getScoreData() -> NSFetchRequest<Score> {
        let request:NSFetchRequest<Score> = Score.fetchRequest() as! NSFetchRequest<Score>
    //        let sortDescriptor = NSSortDescriptor(key: "month", ascending: true)
    //        request.sortDescriptors = [sortDescriptor]
        return request
    }

    @NSManaged public var month: String?
    @NSManaged public var score: Int
    @NSManaged public var scoreIndex: Int
    @NSManaged public var ofUser: Userdetails?

}

extension Score : Identifiable {

}
