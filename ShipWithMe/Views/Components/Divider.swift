//
//  Divider.swift
//  ShipWithMe
//
//  Created by Ludvig Westerdahl on 2021-05-15.
//

import SwiftUI

struct LineDivider: View {
    
    private let padding: CGFloat
    
    init() {
        self.padding = 8
    }
    
    init(padding: CGFloat) {
        self.padding = padding
    }
    
    var body: some View {
        Rectangle()
            .foregroundColor(Color("Divider"))
            .frame(height: 1)
            .padding(.vertical, padding)
    }
}

struct LineDivider_Previews: PreviewProvider {
    static var previews: some View {
        LineDivider()
    }
}
