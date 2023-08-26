
// Model for Notifications


import SwiftUI
import CoreData

struct News: Identifiable {
    let id = UUID().uuidString
    let title: String
    let subtitle: String
    let date: Date
   
}
