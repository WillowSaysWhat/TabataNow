//
// UserDefaults.swift
//  TabataNow
//
//  Created by Huw Williams on 16/12/2025.
//

import Foundation

/*  This wrapper sets the layout for the User Defaults needed throught the app.
    It is currently used in:
        * ProfileUserDefaults.swift
 */


@propertyWrapper
struct Default<Value> {
    
    let key: String
    let defaultValue: Value
    let storage: UserDefaults = .standard
    
    
    var wrappedValue: Value {
        get {
            // Special handling for optional Date
            if Value.self == Optional<Date>.self {
                if let date = storage.object(forKey: key) as? Date {
                    return Optional.some(date) as! Value
                }
                return Optional<Date>.none as! Value
            }
            return storage.object(forKey: key) as? Value ?? defaultValue
        } set {
            // Special handling for optional Date
            if let optionalDate = newValue as? Optional<Date> {
                if let date = optionalDate {
                    storage.set(date, forKey: key)
                } else {
                    storage.removeObject(forKey: key)
                }
            } else {
                storage.set(newValue, forKey: key)
            }
        }
    }
}
