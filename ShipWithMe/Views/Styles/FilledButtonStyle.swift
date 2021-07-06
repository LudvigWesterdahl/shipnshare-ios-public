//
//  FilledButtonStyle.swift
//  ShipWithMe
//
//  Created by Ludvig Westerdahl on 2021-03-20.
//

import SwiftUI

struct FilledButtonStyle: ButtonStyle {
    
    private let cornerRadius: CGFloat
    private let fillColor: Color
    private let pressedFillColor: Color
    
    private var shadow: Bool = true
    
    init() {
        cornerRadius = 0
        fillColor = Color("ButtonBackground")
        pressedFillColor = Color("ButtonPressedBackground")
    }
    
    init(cornerRadius: CGFloat) {
        self.cornerRadius = cornerRadius
        fillColor = Color("ButtonBackground")
        pressedFillColor = Color("ButtonPressedBackground")
    }

    init (cornerRadius: CGFloat, fillColor: Color, pressedFillColor: Color) {
        self.cornerRadius = cornerRadius
        self.fillColor = fillColor
        self.pressedFillColor = pressedFillColor
    }
    
    func disableShadow() -> FilledButtonStyle {
        var style = FilledButtonStyle(cornerRadius: self.cornerRadius,
                                      fillColor: self.fillColor,
                                      pressedFillColor: self.pressedFillColor)
        style.shadow = false
        return style
    }
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .background(configuration.isPressed ? pressedFillColor : fillColor)
            .animation(.easeOut(duration: 0.05), value: configuration.isPressed)
            .cornerRadius(cornerRadius)
            .shadow(radius: configuration.isPressed || !shadow ? 0.0 : 2.0)
    }
}

struct FilledButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        Button(action: {}, label: {
            Text("Button")
                .foregroundColor(.white)
                .padding()
        })
        .buttonStyle(FilledButtonStyle(cornerRadius: 8))
    }
}
