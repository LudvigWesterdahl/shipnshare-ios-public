//
//  LoginBrowseTabView.swift
//  Ship n Share
//
//  Created by Ludvig Westerdahl on 2021-06-30.
//

import SwiftUI

struct LoginBrowseTabView: View {
    @State private var selectedTab: Int = 0
    
    private var title: LocalizedStringKey {
        switch selectedTab {
        case 0:
            return "Ship n Share"
        case 1:
            return "browse-FC"
        default:
            return ""
        }
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            LoginView()
                .tabItem {
                    Image(systemName: "lock")
                    Text("sign_in-FC")
                }
                .tag(0)
            
            BrowseView(publicMode: true)
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("browse-FC")
                }
                .tag(1)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle(Text(title), displayMode: .large)
    }
}

struct LoginBrowseTabView_Previews: PreviewProvider {
    static var previews: some View {
        LoginBrowseTabView()
    }
}
