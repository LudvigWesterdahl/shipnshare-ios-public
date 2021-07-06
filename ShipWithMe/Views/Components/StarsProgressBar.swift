//
//  Stars.swift
//  ShipWithMe
//
//  Created by Ludvig Westerdahl on 2021-05-16.
//

import SwiftUI

struct StarsProgressBar: View {
    
    @Binding private var current: Double
    
    private let limit: Int
    
    init(current: Binding<Double>, limit: Int) {
        self._current = current
        self.limit = limit
    }
    
    init(current: Binding<Int>, limit: Int) {
        self._current = Binding(get: {
            return Double(current.wrappedValue)
        },
        set: { newValue in
            current.wrappedValue = Int(newValue)
        })
        self.limit = limit
    }
    
    init(current: Double, limit: Int) {
        self.init(current: .constant(current), limit: limit)
    }
    
    var body: some View {
        HStack {
            let currentInt = Int(current)
            ForEach(0..<currentInt, id: \.self) { index in
                Image(systemName: "star.fill")
                    .foregroundColor(Color("ImageSun"))
            }
            
            let halfStar = (current - Double(currentInt)) >= 0.5
            if halfStar {
                Image(systemName: "star.leadinghalf.fill")
                    .foregroundColor(Color("ImageSun"))
            }
            
            let startEmpty = halfStar ? currentInt + 1 : currentInt
            ForEach(startEmpty..<limit, id: \.self) { index in
                Image(systemName: "star")
                    .foregroundColor(Color("ImageSun"))
            }
        }
    }
}

struct StarsProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        StarsProgressBar(current: 1.5, limit: 8)
    }
}
