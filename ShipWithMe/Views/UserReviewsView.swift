//
//  UserReviewsView.swift
//  ShipWithMe
//
//  Created by Ludvig Westerdahl on 2021-05-16.
//

import SwiftUI

struct UserReviewsView: View {
    
    @StateObject private var vm: UserReviewsViewModel = UserReviewsViewModel()
    
    let userName: String
    
    var body: some View {
        List {
            
            HStack {
                StarsProgressBar(current: vm.userReviews.averageRating, limit: 3)
                
                Text("(\(vm.averageRatingString))")
                
                Spacer()
                
                RatingsExplanation()
                
                VStack(alignment: .leading) {
                    Text("\(vm.userReviews.numberOfGoodReviews)")
                        .font(.system(size: 14))
                    Text("\(vm.userReviews.numberOfGoodButReviews)")
                        .font(.system(size: 14))
                    Text("\(vm.userReviews.numberOfBadButReviews)")
                        .font(.system(size: 14))
                    Text("\(vm.userReviews.numberOfBadReviews)")
                        .font(.system(size: 14))
                }
            }
            
            ForEach(vm.reviews, id: \.self) { review in
                VStack (alignment: .leading) {
                    HStack {
                        Text(review.reviewerUserName)
                            .font(.system(size: 12))
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        RatingsExplanation(for: review.rating)
                    }
                    
                    Text(review.message)
                        .padding(.vertical, 8)
                    
                    Text(review.createdAt.readableLocalized())
                        .font(.system(size: 12))
                        .fontWeight(.bold)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .onAppear {
            vm.load(for: userName)
        }
    }
}

struct UserReviewsView_Previews: PreviewProvider {
    static var previews: some View {
        UserReviewsView(userName: "admin")
    }
}
