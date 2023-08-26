//
//  UserDefaults.swift
//  Golgi-Splash
//
//  Created by Marwan Zaarab on 2021-01-09.
//

import Foundation
import Combine
import SwiftUI

@propertyWrapper
    struct UserDefault<T: Codable> {
        let key: String
        let defaultValue: T

        init(_ key: String, defaultValue: T) {
            self.key = key
            self.defaultValue = defaultValue
        }

        var wrappedValue: T {
            get {

                if let data = UserDefaults.standard.object(forKey: key) as? Data,
                    let user = try? JSONDecoder().decode(T.self, from: data) {
                    return user

                }

                return  defaultValue
            }
            set {
                if let encoded = try? JSONEncoder().encode(newValue) {
                    UserDefaults.standard.set(encoded, forKey: key)
                }
            }
        }
    }


final class UserSettings: ObservableObject {
    let components = Calendar.current.dateComponents([.hour, .minute], from: Date())

    let objectWillChange = PassthroughSubject<Void, Never>()

    @UserDefault("ShowOnStart", defaultValue: true)
    var showOnStart: Bool {
        willSet {
            objectWillChange.send()
        }
    }
    
    @UserDefault("LiquidLimit", defaultValue: 64)
    var liquidLimit: Double {
        willSet {
            objectWillChange.send()
        }
    }
    
    @UserDefault("Drank", defaultValue: 0)
    var drank: Double {
        willSet {
            objectWillChange.send()
        }
    }
    
    @UserDefault("TimeReset", defaultValue: Date())
    var time: Date {
        willSet {
            objectWillChange.send()
        }
    }
    
    @UserDefault("Name", defaultValue: "")
    var name: String {
        willSet {
            objectWillChange.send()
        }
    }
    
    @UserDefault("Age", defaultValue: "")
    var age: String {
        willSet {
            objectWillChange.send()
        }
    }
    
    @UserDefault("Gender", defaultValue: "")
    var gender: String {
        willSet {
            objectWillChange.send()
        }
    }

}

