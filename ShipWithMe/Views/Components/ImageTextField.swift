//
//  ImageTextField.swift
//  Ship n Share
//
//  Created by Ludvig Westerdahl on 2021-06-19.
//

import SwiftUI

struct ImageTextField: View {
    
    private let systemName: String
    
    private let hint: LocalizedStringKey
    
    @Binding private var text: String
    
    init(systemName: String, hint: LocalizedStringKey, text: Binding<String>) {
        self.systemName = systemName
        self.hint = hint
        self._text = text
    }
    
    var body: some View {
        HStack {
            Image(systemName: systemName)
                .frame(width: 16)
                .padding(.leading, 16)
            
            TextField(hint, text: $text)
                .padding(.vertical, 16)
        }
        .frame(height: 55)
        .background(Color("TextFieldBackground"))
        .cornerRadius(40)
        .shadow(radius: 2)
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}

struct ImageTextField_Previews: PreviewProvider {
    static var previews: some View {
        ImageTextField(systemName: "envelope", hint: "Email", text: .constant(""))
    }
}
