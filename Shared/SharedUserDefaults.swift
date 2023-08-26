//
//  SharedUserDefaults.swift
//  CHFManager
//
//  Created by Marwan Zaarab on 2021-01-10.
//

import Foundation

extension UserDefaults {
    static let appGroup = UserDefaults(suiteName: "group.H97YA8G6R5.com.golgi.CHFManager")!
  
}

extension FileManager {
    static func sharedContainerURL() -> URL {
        return FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.H97YA8G6R5.com.golgi.CHFManager")!
    }
    static let liquidFileName = "LiquidIntake.txt"
    static let liquidLimitFileName = "LiquidLimit.txt"
}

extension UserDefaults {
    enum Keys: String {
        case drank
        case liquidLimit
    }
}

extension UserDefaults {
    func setArray<Element>(_ array: [Element], forKey key: String) where Element: Encodable {
        let data = try? JSONEncoder().encode(array)
        set(data, forKey: key)
    }

    func getArray<Element>(forKey key: String) -> [Element]? where Element: Decodable {
        guard let data = data(forKey: key) else { return nil }
        return try? JSONDecoder().decode([Element].self, from: data)
    }
}
