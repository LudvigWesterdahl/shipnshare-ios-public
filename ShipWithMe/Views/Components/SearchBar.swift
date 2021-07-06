//
//  SearchBar.swift
//  ShipWithMe
//
//  Created by Ludvig Westerdahl on 2021-03-30.
//

import SwiftUI

struct SearchBar: UIViewRepresentable {
    
    @Binding var text: String
    
    var enabled: Binding<Bool> = Binding.constant(true)
    
    var startWithFocus: Bool = false
    
    var onSearched: () -> Void = {}
    
    class Coordinator: NSObject, UISearchBarDelegate {
        
        @Binding var text: String
        
        var onSearched: () -> Void
        
        init(text: Binding<String>, onSearched: @escaping () -> Void) {
            _text = text
            self.onSearched = onSearched
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            onSearched()
        }
    }
    
    func makeCoordinator() -> SearchBar.Coordinator {
        return Coordinator(text: $text, onSearched: onSearched)
    }
    
    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.searchBarStyle = .minimal
        searchBar.returnKeyType = .go
        
        if startWithFocus {
            searchBar.becomeFirstResponder()
        }
        
        if !enabled.wrappedValue {
            searchBar.searchTextField.clearButtonMode = .never
        }
        
        return searchBar
    }
    
    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
        uiView.isUserInteractionEnabled = enabled.wrappedValue
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            SearchBar(text: .constant("Ågatan 29")) {
                
            }
        }
    }
}
