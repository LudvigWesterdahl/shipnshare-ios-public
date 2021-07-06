import SwiftUI

struct ContentView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    //self.presentationMode.wrappedValue.dismiss() to POP the view
    
    @State private var selectedTab: Int = 0
    
    private var title: LocalizedStringKey {
        switch selectedTab {
        case 0:
            return "browse-FC"
        case 1:
            return "post-FC"
        case 2:
            return "chats-FC"
        case 3:
            return "profile-FC"
        default:
            return ""
        }
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            BrowseView(publicMode: false)
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("browse-FC")
                }
                .tag(0)
            
            CreatePostView()
                .tabItem {
                    Image(systemName: "plus")
                    Text("post-FC")
                }
                .tag(1)
            
            ChatsView()
                .tabItem {
                    Image(systemName: "message")
                    Text("chats-FC")
                }
                .tag(2)
            
            AccountView()
                .tabItem {
                    Image(systemName: "person")
                    Text("profile-FC")
                }
                .tag(3)
            
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle(Text(title), displayMode: .large)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
