//
//  ReviewRequest.swift
//  ShipWithMe
//
//  Created by Ludvig Westerdahl on 2021-05-30.
//

import Foundation

struct ReviewRequest: Encodable {
    
    let postId: String
    let rating: Int
    let message: String
}
