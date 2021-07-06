
import Foundation
import CoreLocation

extension CLPlacemark {
    
    func readableAddress() -> String {
        
        var components: [String] = []
        
        if let name = self.name {
            components.append(name)
        }
        
        if let postalCode = self.postalCode, let city = self.locality {
            components.append("\(postalCode) \(city)")
        }
        
        if let country = self.country {
            components.append(country)
        }

        return components.joined(separator: ", ")
    }
}
