//
//  StorageManager.swift
//  ShipWithMe
//
//  Created by Ludvig Westerdahl on 2021-03-27.
//

import Foundation
import MapKit

struct AddressCoordinate: Encodable, Decodable, Equatable, Hashable {
    var readableAddress: String
    var latitude: Double
    var longitude: Double
    
    static func from(placemark: MKPlacemark) -> AddressCoordinate {
        return AddressCoordinate(readableAddress: placemark.readableAddress(),
                                 latitude: placemark.coordinate.latitude,
                                 longitude: placemark.coordinate.longitude)
    }
}

final class StorageManager {
    
    private enum StorageKey: String, CaseIterable {
        case token,
             refreshToken,
             userId,
             email,
             userName,
             addressCoordinates
        
    }
    
    private static func get(_ key: StorageKey) -> String? {
        return UserDefaults.standard.string(forKey: key.rawValue)
    }
    
    private static func set(_ key: StorageKey, _ value: String?) -> Void {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    static func reset() -> Void {
        for key in StorageKey.allCases {
            set(key, nil)
        }
    }
    
    static var token: String? {
        get {
            get(.token)
        }
        set {
            set(.token, newValue)
        }
    }
    
    static var refreshToken: String? {
        get {
            get(.refreshToken)
        }
        set {
            set(.refreshToken, newValue)
        }
    }
    
    static var userId: Int64? {
        get {
            if let userId = get(.userId) {
                return Int64(userId)
            } else {
                return nil
            }
        }
        set {
            if let userId = newValue {
                set(.userId, String(userId))
            } else {
                set(.userId, nil)
            }
        }
    }
    
    static var email: String? {
        get {
            get(.email)
        }
        set {
            set(.email, newValue)
        }
    }
    
    static var userName: String? {
        get {
            get(.userName)
        }
        set {
            set(.userName, newValue)
        }
    }
    
    static var addressCoordinates: [AddressCoordinate] {
        get {
            (UserDefaults.standard.array(forKey: StorageKey.addressCoordinates.rawValue) as? [Data] ?? [])
                .map { data in
                    return try! JSONDecoder().decode(AddressCoordinate.self, from: data)
                }
        }
        set {
            UserDefaults.standard.set(newValue.map { addressCoordinate in
                return try! JSONEncoder().encode(addressCoordinate)
            }, forKey: StorageKey.addressCoordinates.rawValue)
        }
    }
}
