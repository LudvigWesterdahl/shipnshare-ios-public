//
//  CreatePostRequest.swift
//  ShipWithMe
//
//  Created by Ludvig Westerdahl on 2021-05-08.
//

import Foundation

/*
 {
 "createdat": "2021-05-08 07:09:01",
 "createdattimezone": "America/New_York",
 "latitudepickuplocation": 59.22,
 "longitudepickuplocation": 18.01,
 "offervaluetitle": "Customer value",
 "description": "Im regular, offering good stuff",
 "storeorproducturi": "https://coolstuff.se",
 "shippingcost": 15,
 "currency": "SEK",
 "tags": [
 "garbage",
 "amazon",
 "clothes",
 "computers"
 ],
 "imagetype": "png",
 "image": {{image_1}}
 }
 
 
 enum CodingKeys: String, CodingKey {
         case title, category, views
         // Map the JSON key "url" to the Swift property name "htmlLink"
         case htmlLink = "url"
     }
 
 */
struct CreatePostRequest: Encodable {
    let createdAt: Date
    let createdAtTimeZone: String
    let latitudePickupLocation: Double
    let longitudePickupLocation: Double
    let offerValueTitle: String
    let description: String
    let storeOrProductUri: URL = URL(string: "https://amazon.com")!
    let shippingCost: Decimal
    let currency: String
    let tags: [String] = []
    let imageType: String?
    let image: String?
    
    static func dummy() -> CreatePostRequest {
        let post = CreatePostRequest(createdAt: Date.init(),
                                     createdAtTimeZone: "Europe/Stockholm",
                                     latitudePickupLocation: 52.0,
                                     longitudePickupLocation: 15.0,
                                     offerValueTitle: "Dummy post title",
                                     description: "Just some dummy description, lorem my ipsum and ipsum my lorem.",
                                     shippingCost: Decimal(15),
                                     currency: "SEK",
                                     imageType: nil,
                                     image: nil )
        
        return post
    }
}
