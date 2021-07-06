//
//  PasswordField.swift
//  ShipWithMe
//
//  Created by Ludvig Westerdahl on 2021-03-13.
//

import SwiftUI

struct PasswordField: View {
    
    private let title: String
    
    @Binding private var text: String
    
    @State private var showPassword: Bool = false
    
    @State private var secured: Bool = true
    
    init(_ title: String, text: Binding<String>) {
        self.title = title
        self._text = text
    }
    
    var body: some View {
        HStack {
            Image(systemName: "lock")
                .frame(width: 16)
                .padding(.leading, 16)
            
            if showPassword {
                TextField(LocalizedStringKey(title), text: $text)
                    .keyboardType(UIKeyboardType.alphabet)
                    .disableAutocorrection(true)
            } else {
                SecureField(LocalizedStringKey(title), text: $text)
                    .disableAutocorrection(true)
            }
            
            Image(systemName: showPassword ? "eye" : "eye.slash")
                .onTapGesture {
                    showPassword.toggle()
                }
                .padding(.trailing, 16)
        }
        .frame(height: 55)
        .background(Color("TextFieldBackground"))
        .cornerRadius(40)
        .shadow(radius: 2)
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}

struct PasswordField_Previews: PreviewProvider {
    static var previews: some View {
        PasswordField("Password", text: .constant(""))
    }
}
