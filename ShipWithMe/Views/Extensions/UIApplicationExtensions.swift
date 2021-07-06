//
//  UIApplicationExtensions.swift
//  Ship n Share
//
//  Created by Ludvig Westerdahl on 2021-06-24.
//

import Foundation
import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
