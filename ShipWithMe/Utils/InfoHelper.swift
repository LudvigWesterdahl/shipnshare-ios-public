//
//  InfoHelper.swift
//  ShipWithMe
//
//  Created by Ludvig Westerdahl on 2021-03-14.
//

import Foundation

struct InfoHelper {
    
    static public let apiUrl: String = get(key: "ENDPOINT_HOST")!
    
    static public let appVersion: String = get(key: "CFBundleVersion")!
    
    static func get(key: String) -> String? {
        return Bundle.main.object(forInfoDictionaryKey: key) as? String
    }
    
    static public var isDebug: Bool {
        #if DEBUG
        return true
        #elseif BETA
        return false
        #else
        return false
        #endif
    }
    
    static public var isBeta: Bool {
        #if DEBUG
        return false
        #elseif BETA
        return true
        #else
        return false
        #endif
    }
    
    static public var isRelease: Bool {
        #if DEBUG
        return false
        #elseif BETA
        return false
        #else
        return true
        #endif
    }
    
    
    static public var buildType: String  {
        #if DEBUG
        return "Debug"
        #elseif BETA
        return "Beta"
        #else
        return "Release"
        #endif
    }
}
