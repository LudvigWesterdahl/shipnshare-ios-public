//
//  UserReviewsModel.swift
//  ShipWithMe
//
//  Created by Ludvig Westerdahl on 2021-05-15.
//

import Foundation

struct UserReviewsModel: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case averageRating,
             numberOfReviews,
             numberOfGoodReviews,
             numberOfGoodButReviews,
             numberOfBadButReviews,
             numberOfBadReviews
        
        case reviews = "userReviews"
    }
    
    let averageRating: Double
    let numberOfReviews: Int
    let numberOfGoodReviews: Int
    let numberOfGoodButReviews: Int
    let numberOfBadButReviews: Int
    let numberOfBadReviews: Int
    let reviews: [ReviewModel]
    
    static func empty() -> UserReviewsModel {
        return UserReviewsModel(averageRating: 0,
                                numberOfReviews: 0,
                                numberOfGoodReviews: 0,
                                numberOfGoodButReviews: 0,
                                numberOfBadButReviews: 0,
                                numberOfBadReviews: 0,
                                reviews: [])
    }
    
    static func dummyUserReviews() -> UserReviewsModel {
        let models = (0...100).map { int in
            ReviewModel.dummyReview()
        }

        return UserReviewsModel(averageRating: Double.random(in: 0...3),
                                numberOfReviews: Int.random(in: 0...100),
                                numberOfGoodReviews: Int.random(in: 0...20),
                                numberOfGoodButReviews: Int.random(in: 0...20),
                                numberOfBadButReviews: Int.random(in: 0...20),
                                numberOfBadReviews: Int.random(in: 0...20),
                                reviews: models)
        
    }
}
