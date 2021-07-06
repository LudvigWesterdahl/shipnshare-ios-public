//
//  UserReviewsViewModel.swift
//  ShipWithMe
//
//  Created by Ludvig Westerdahl on 2021-05-16.
//

import Foundation

class UserReviewsViewModel: ObservableObject {
    
    @Published var loading: Bool = false
    
    @Published var reviews: [ReviewModel] = []
    
    @Published var averageRatingString: String = ""
    
    @Published var userReviews: UserReviewsModel = UserReviewsModel.empty()
    
    init() {
        
    }
    
    func load(for userName: String) {
        
        self.loading = true
        
        ApiManager.shared.getUserReviews(for: userName) { userReviews in
            
            let formatter = NumberFormatter()
            formatter.maximumFractionDigits = 1
            
            if let userReviews = userReviews {
                DispatchQueue.main.async {
                    self.userReviews = userReviews
                    
                    self.reviews = self.userReviews.reviews
                        .sorted(by: { $0.createdAt > $1.createdAt })
                    
                    self.averageRatingString = formatter.string(from: self.userReviews.averageRating as NSNumber)!
                    
                    self.loading = false
                }
            }
        }
    }
    
}
