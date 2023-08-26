//
//  Patient.swift
//  Golgi-Splash
//
//  Created by Marwan Zaarab on 2020-11-23.
//

import Foundation
import SwiftUI
//import Firebase
//import FirebaseFirestoreSwift
import CoreData
import SharedObjects


class DayData: ObservableObject, Identifiable  {
    
   
    @Published var date = Date()
    @Published var completed = false
    @Published var percentage: Double = 0.0
    @Published var liquids: Double = 0
    @Published var waterIndex = [0,0,0,0,1,1,1,1]
    @Published var monthIndex = [1,2,3,4,5,6,7,8,9,10,11,12]
    @Published var fatigue = 0
    @Published var swelling = 0
    @Published var dyspnea = 0
    @Published var weightGain = 0
    @Published var cough = 0
    @Published var id = UUID().uuidString
    @Published var isNewData = false
    @Published var showPopUp = false
    @Published var rxCount = 0.0
    @Published var dayScore = 0.0
    @Published var daySobScore = 0.0
    @Published var dayFatScore = 0.0
    @Published var howMany: Double = 0
    @Published var masterDate = ""
    @Published var masterMonth = ""
    @Published var items: [DayCellModel] = []
    @Published var isPresented = false
    @Published var rxQty: Double = 0
    @Published var value = "" {
        didSet {
            let filtered = value.filter { $0.isNumber }
            
            if value != filtered {
                value = filtered
            }
        }
    }
   
}



