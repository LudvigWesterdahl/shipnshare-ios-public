//
//  RatingsExplanation.swift
//  ShipWithMe
//
//  Created by Ludvig Westerdahl on 2021-05-16.
//

import SwiftUI

struct RatingsExplanation: View {
    
    private static let allRatingToValues: [(String, Double)] = [
        ("good-FC", 3),
        ("good_but-FC", 2),
        ("bad_but-FC", 1),
        ("bad-FC", 0)
    ]
    
    private let ratingToValues: [(String, Double)]
    
    init() {
        ratingToValues = RatingsExplanation.allRatingToValues
    }
    
    init(for rating: Int) {
        if let rating = RatingsExplanation.allRatingToValues.first(where: { $0.1 == Double(rating) }) {
            ratingToValues = [rating]
        } else {
            ratingToValues = []
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(ratingToValues, id: \.self.0) { (name, value) in
                HStack {
                    StarsProgressBar(current: value, limit: 3)
                        .font(.system(size: 14))
                    Text(LocalizedStringKey(name))
                        .font(.system(size: 14))
                }
            }
        }
    }
}

struct RatingsExplanation_Previews: PreviewProvider {
    static var previews: some View {
        RatingsExplanation()
    }
}
