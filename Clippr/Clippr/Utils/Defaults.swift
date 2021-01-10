//
//  Defaults.swift
//  Clippr
//
//  Created by Viktor Radulov on 5/11/20.
//  Copyright © 2020 Viktor Radulov. All rights reserved.
//

import Foundation

@objc
enum SavingMethod: Int, Codable {
    case preferences = 1
    case file = 2
}

class Preferences: NSObject {
    @DefaultsStored("savingMethod")
    @objc dynamic static var savingMethod = SavingMethod.preferences
}

@propertyWrapper
struct DefaultsStored<T: Codable> {
    let key: String
    let iniatialValue: T

    init(wrappedValue: T, _ key: String) {
        self.key = key
        self.iniatialValue = wrappedValue
    }
    
    var wrappedValue: T {
        get {
            do {
                guard let data = Foundation.UserDefaults.standard.data(forKey: key) else { return iniatialValue }
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                return iniatialValue
            }
        }
        set {
            do {
                Foundation.UserDefaults.standard.set(try JSONEncoder().encode(newValue), forKey: key)
            } catch {
                Foundation.UserDefaults.standard.removeObject(forKey: key)
            }
        }
    }
}

extension DefaultsStored where T: ExpressibleByNilLiteral {
    init(wrappedValue: T = nil, _ key: String) {
        self.key = key
        self.iniatialValue = wrappedValue
    }
}
