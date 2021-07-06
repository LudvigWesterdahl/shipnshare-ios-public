
import Foundation
import SwiftUI

struct PostModel: Identifiable, Decodable, Hashable {
    let id: String
    let ownerUserName: String
    let createdAt: Date
    let createdAtTimeZone: String
    let latitudePickupLocation: Double
    let longitudePickupLocation: Double
    let offerValueTitle: String
    let description: String
    let storeOrProductUri: URL
    let shippingCost: Decimal
    let currency: String
    let tags: [String]
    let faviconUri: URL
    let metersToPickupLocation: Double?
    let imagePath: String?
    let imageData: Data?
    
    static func dummyPost() -> PostModel {
        let post = PostModel(id: "123",
                             ownerUserName: "admin",
                             createdAt: Date.init(),
                             createdAtTimeZone: "America/New_York",
                             latitudePickupLocation: 52.0,
                             longitudePickupLocation: 15.0,
                             offerValueTitle: "Offer value title",
                             description: "This is a long description, is it alright, it is written by the user.",
                             storeOrProductUri: URL(string: "https://coolstuff.se")!,
                             shippingCost: Decimal(15),
                             currency: "SEK",
                             tags: ["amazon", "clothes", "coolstuff"],
                             faviconUri: URL(string: "https://coolstuff.se/favicon.ico")!,
                             metersToPickupLocation: 928.0,
                             imagePath: nil,
                             imageData: UIImage(named: "Placeholder")!.pngData()!)
        
        return post
    }
    
    /*
    func readableCreatedAt() -> LocalizedStringKey {
        let dateFormatter = DateFormatter()
        
        if Calendar.current.isDateInToday(createdAt) {
            dateFormatter.dateStyle = .none
            dateFormatter.timeStyle = .short
            return LocalizedStringKey("today_at_{1}-FC \(dateFormatter.string(from: createdAt))")
        }
        
        if Calendar.current.isDateInYesterday(createdAt) {
            dateFormatter.dateStyle = .none
            dateFormatter.timeStyle = .short
            return LocalizedStringKey("yesterday_at_{1}-FC \(dateFormatter.string(from: createdAt))")
        }
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.timeZone = TimeZone.current
        //dateFormatter.dateFormat = DateFormatter.defaultFormat
        return LocalizedStringKey(dateFormatter.string(from: createdAt))
    }
     */
    
    func readableMetersToPickupLocation() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 1
        let lengthFormatter = LengthFormatter()
        lengthFormatter.numberFormatter = numberFormatter
        return lengthFormatter.string(fromMeters: metersToPickupLocation!)
    }
    
    func readableShippingCost() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 1
        numberFormatter.numberStyle = .currency
        numberFormatter.currencyCode = currency
        
        return numberFormatter.string(from: shippingCost as NSDecimalNumber)!
    }
}
