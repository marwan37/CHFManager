//
//  ListElement.swift
//  Golgi-Splash
//
//  Created by Marwan Zaarab on 2020-12-31.
//

import Foundation
import CloudKit


struct DayCellModel : Hashable, Codable, Identifiable {
    var recordID: CKRecord.ID? {
        CKRecord.ID(recordName: id)
    }
    var date: Date
    var id = UUID().uuidString
    var percentage : Double
    var swelling: Int
    var fatigue: Int
    var dyspnea: Int
    var rxComp: Double
//    @DocumentID var id : String?
    
    enum CodingKeys: String, CodingKey{
        case date = "date"
        case percentage = "percentage"
        case swelling = "swelling"
        case fatigue = "fatigue"
        case dyspnea = "dyspnea"
        case rxComp = "rxComp"
        case id = "id"
     
    }
}

