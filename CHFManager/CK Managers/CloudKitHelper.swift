//
//  CloudKitHelper.swift
//  SwiftUICloudKitDemo
//
//  Created by Alex Nagy on 23/09/2019.
//  Copyright © 2019 Alex Nagy. All rights reserved.
//

import Foundation
import CloudKit
import SwiftUI


// MARK: - notes
// good to read: https://www.hackingwithswift.com/read/33/overview
//
// important setup in CloudKit Dashboard:
//
// https://www.hackingwithswift.com/read/33/4/writing-to-icloud-with-cloudkit-ckrecord-and-ckasset
// https://www.hackingwithswift.com/read/33/5/a-hands-on-guide-to-the-cloudkit-dashboard
//
// On your device (or in the simulator) you should make sure you are logged into iCloud and have iCloud Drive enabled.

struct CloudKitHelper {
    
    // MARK: - record types
    struct RecordType {
        static let Items = "Items"
    }
    
    // MARK: - errors
    enum CloudKitHelperError: Error {
        case recordFailure
        case recordIDFailure
        case castFailure
        case cursorFailure
    }
    
    // MARK: - saving to CloudKit
    static func save(item: DayCellModel, completion: @escaping (Result<DayCellModel, Error>) -> ()) { 
        let itemRecord = CKRecord(recordType: RecordType.Items)
        itemRecord["date"] = item.date as CKRecordValue
        itemRecord["percentage"] = item.percentage as CKRecordValue
        itemRecord["swelling"] = item.swelling as CKRecordValue
        itemRecord["fatigue"] = item.fatigue as CKRecordValue
        itemRecord["dyspnea"] = item.dyspnea as CKRecordValue
        itemRecord["rxComp"] = item.rxComp as CKRecordValue
       
      
        CKContainer.default().publicCloudDatabase.save(itemRecord) { (record, err) in
            DispatchQueue.main.async {
                if let err = err {
                    completion(.failure(err))
                    return
                }
                guard let record = record else {
                    completion(.failure(CloudKitHelperError.recordFailure))
                    return
                }
                guard let date = record["date"] as? Date else {
                    completion(.failure(CloudKitHelperError.castFailure))
                    return
                }
                guard let id = record["id"] as? String else {
                    completion(.failure(CloudKitHelperError.castFailure))
                    return
                }
                guard let percentage = record["percentage"] as? Double else {
                    completion(.failure(CloudKitHelperError.castFailure))
                    return
                }
                guard let swelling = record["swelling"] as? Int else {
                    completion(.failure(CloudKitHelperError.castFailure))
                    return
                }
                guard let fatigue = record["fatigue"] as? Int else {
                    completion(.failure(CloudKitHelperError.castFailure))
                    return
                }
                guard let dyspnea = record["dyspnea"] as? Int else {
                    completion(.failure(CloudKitHelperError.castFailure))
                    return
                }
                guard let rxComp = record["rxComp"] as? Double else {
                    completion(.failure(CloudKitHelperError.castFailure))
                    return
                }
              
             
                let listElement = DayCellModel(date: date, id: id, percentage: percentage, swelling: swelling, fatigue: fatigue, dyspnea: dyspnea, rxComp: rxComp)
                completion(.success(listElement))
            }
        }
    }
    
    // MARK: - fetching from CloudKit
    static func fetch(completion: @escaping (Result<DayCellModel, Error>) -> ()) {
        let pred = NSPredicate(value: true)
        let sort = NSSortDescriptor(key: "creationDate", ascending: false)
        let query = CKQuery(recordType: RecordType.Items, predicate: pred)
        query.sortDescriptors = [sort]

        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = ["text"]
        operation.resultsLimit = 50
        
        operation.recordFetchedBlock = { record in
            DispatchQueue.main.async {
                guard let id = record["id"] as? String else { return }
                guard let date = record["date"] as? Date else { return }
                guard let percentage = record["percentage"] as? Double else {return}
                guard let swelling = record["swelling"] as? Int else {return}
                guard let fatigue = record["fatigue"] as? Int else { return }
                guard let dyspnea = record["dyspnea"] as? Int else {return}
                guard let rxComp = record["rxComp"] as? Double else {return}
        
                let listElement = DayCellModel(date: date, id: id, percentage: percentage, swelling: swelling, fatigue: fatigue, dyspnea: dyspnea, rxComp: rxComp)
                completion(.success(listElement))
            }
        }
        
        operation.queryCompletionBlock = { (/*cursor*/ _, err) in
            DispatchQueue.main.async {
                if let err = err {
                    completion(.failure(err))
                    return
                }
//                guard let cursor = cursor else {
//                    completion(.failure(CloudKitHelperError.cursorFailure))
//                    return
//                }
//                print("Cursor: \(String(describing: cursor))")
            }
            
        }
        
        CKContainer.default().publicCloudDatabase.add(operation)
    }
    
    // MARK: - delete from CloudKit
    static func delete(recordID: CKRecord.ID, completion: @escaping (Result<CKRecord.ID, Error>) -> ()) {
        CKContainer.default().publicCloudDatabase.delete(withRecordID: recordID) { (recordID, err) in
            DispatchQueue.main.async {
                if let err = err {
                    completion(.failure(err))
                    return
                }
                guard let recordID = recordID else {
                    completion(.failure(CloudKitHelperError.recordIDFailure))
                    return
                }
                completion(.success(recordID))
            }
        }
    }
    
    // MARK: - modify in CloudKit
    static func modify(item: DayCellModel, completion: @escaping (Result<DayCellModel, Error>) -> ()) {
        guard let recordID = item.recordID else { return }
        CKContainer.default().publicCloudDatabase.fetch(withRecordID: recordID) { record, err in
            if let err = err {
                DispatchQueue.main.async {
                    completion(.failure(err))
                }
                return
            }
            guard let record = record else {
                DispatchQueue.main.async {
                    completion(.failure(CloudKitHelperError.recordFailure))
                }
                return
            }
            record["date"] = item.date as CKRecordValue
            record["percentage"] = item.percentage as CKRecordValue
            record["swelling"] = item.swelling as CKRecordValue
            record["fatigue"] = item.fatigue as CKRecordValue
            record["dyspnea"] = item.dyspnea as CKRecordValue
            record["rxComp"] = item.rxComp as CKRecordValue
           
            CKContainer.default().publicCloudDatabase.save(record) { (record, err) in
                DispatchQueue.main.async {
                    if let err = err {
                        completion(.failure(err))
                        return
                    }
                    guard let record = record else {
                        completion(.failure(CloudKitHelperError.recordFailure))
                        return
                    }
                    guard let id = record["id"] as? String else {
                        completion(.failure(CloudKitHelperError.castFailure))
                        return
                    }
                    guard let date = record["date"] as? Date else {
                        completion(.failure(CloudKitHelperError.castFailure))
                        return
                    }
                    guard let percentage = record["percentage"] as? Double else {
                        completion(.failure(CloudKitHelperError.castFailure))
                        return
                    }
                    guard let swelling = record["swelling"] as? Int else {
                        completion(.failure(CloudKitHelperError.castFailure))
                        return
                    }
                    guard let fatigue = record["fatigue"] as? Int else {
                        completion(.failure(CloudKitHelperError.castFailure))
                        return
                    }
                    guard let dyspnea = record["dyspnea"] as? Int else {
                        completion(.failure(CloudKitHelperError.castFailure))
                        return
                    }
                    guard let rxComp = record["rxComp"] as? Double else {
                        completion(.failure(CloudKitHelperError.castFailure))
                        return
                    }
                  
                   
                    let listElement = DayCellModel(date: date, id: id, percentage: percentage, swelling: swelling, fatigue: fatigue, dyspnea: dyspnea, rxComp: rxComp)
                    completion(.success(listElement))
                }
            }
        }
        
    }
    
 
}

