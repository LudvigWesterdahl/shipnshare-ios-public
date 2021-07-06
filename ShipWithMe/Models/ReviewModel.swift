//
//  ReviewModel.swift
//  ShipWithMe
//
//  Created by Ludvig Westerdahl on 2021-05-15.
//

import Foundation

struct ReviewModel: Decodable, Hashable {
    let createdAt: Date
    let rating: Int
    let message: String
    let reviewerUserName: String
    let postId: String
    
    
    static func dummyReview() -> ReviewModel {
        
        return ReviewModel(createdAt: Date().advanced(by: Double.random(in: 0...10000)),
                           rating: Int.random(in: 0...3),
                           message: "Just a review",
                           reviewerUserName: "User123",
                           postId: "12345ABCDE")
    }
}

