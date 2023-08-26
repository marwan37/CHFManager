//
//  Userdetails+CoreDataProperties.swift
//  CHFManager
//
//  Created by Marwan Zaarab on 2021-01-02.
//
//

import Foundation
import CoreData


extension Userdetails {

    @nonobjc public class func fetchUserData() -> NSFetchRequest<Userdetails> {
        let request:NSFetchRequest<Userdetails> = Userdetails.fetchRequest() as! NSFetchRequest<Userdetails>
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
//        let predicate = NSPredicate(format: "uid == %@", uid as CVarArg)
    //        request.predicate = predicate
        request.sortDescriptors = [sortDescriptor]
//        request.predicate = predicate
        return request
    }

    @NSManaged public var birthDate: String?
    @NSManaged public var email: String?
    @NSManaged public var gender: String?
    @NSManaged public var name: String?
    @NSManaged public var password: String?
    @NSManaged public var uid: String?
    
    @NSManaged public var masterData: NSSet?
    @NSManaged public var score: NSSet?
    @NSManaged public var weight: NSSet?

}

// MARK: Generated accessors for masterData
extension Userdetails {
    
    //add or remove a single daily completion
    @objc(addMasterDataObject:)
    @NSManaged public func addToMasterData(_ value: MasterData)

    @objc(removeMasterDataObject:)
    @NSManaged public func removeFromMasterData(_ value: MasterData)

    //adds or removes multiple daily completions
    @objc(addMasterData:)
    @NSManaged public func addToMasterData(_ values: NSSet)

    @objc(removeMasterData:)
    @NSManaged public func removeFromMasterData(_ values: NSSet)

}

// MARK: Generated accessors for score
extension Userdetails {

    @objc(addScoreObject:)
    @NSManaged public func addToScore(_ value: Score)

    @objc(removeScoreObject:)
    @NSManaged public func removeFromScore(_ value: Score)

    @objc(addScore:)
    @NSManaged public func addToScore(_ values: NSSet)

    @objc(removeScore:)
    @NSManaged public func removeFromScore(_ values: NSSet)

}

// MARK: Generated accessors for weight
extension Userdetails {

    @objc(addWeightObject:)
    @NSManaged public func addToWeight(_ value: Weight)

    @objc(removeWeightObject:)
    @NSManaged public func removeFromWeight(_ value: Weight)

    @objc(addWeight:)
    @NSManaged public func addToWeight(_ values: NSSet)

    @objc(removeWeight:)
    @NSManaged public func removeFromWeight(_ values: NSSet)

}

extension Userdetails : Identifiable {

}
