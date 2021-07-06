//
//  DateExtensions.swift
//  ShipWithMe
//
//  Created by Ludvig Westerdahl on 2021-05-08.
//

import Foundation
import SwiftUI

extension Date {
    
    func convert(from: TimeZone, to: TimeZone) -> Date {
        let delta = TimeInterval(to.secondsFromGMT() - from.secondsFromGMT())
        return addingTimeInterval(delta)
    }
    
    func convertFromUtc(to: TimeZone) -> Date {
        return convert(from: TimeZone(identifier: "UTC")!, to: to)
    }
    
    func convertToUtc(from: TimeZone) -> Date {
        return convert(from: from, to: TimeZone(identifier: "UTC")!)
    }
    
    func readableLocalized() -> LocalizedStringKey {
        let dateFormatter = DateFormatter()
        
        if Calendar.current.isDateInToday(self) {
            dateFormatter.dateStyle = .none
            dateFormatter.timeStyle = .short
            return LocalizedStringKey("today_at_{1}-FC \(dateFormatter.string(from: self))")
        }
        
        if Calendar.current.isDateInYesterday(self) {
            dateFormatter.dateStyle = .none
            dateFormatter.timeStyle = .short
            return LocalizedStringKey("yesterday_at_{1}-FC \(dateFormatter.string(from: self))")
        }
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.timeZone = TimeZone.current
        //dateFormatter.dateFormat = DateFormatter.defaultFormat
        return LocalizedStringKey(dateFormatter.string(from: self))
    }
}
