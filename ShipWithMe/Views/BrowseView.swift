
import SwiftUI
import MapKit

struct BrowseView: View {
    
    @StateObject var vm: BrowseViewModel = BrowseViewModel()
    
    @StateObject var postViewModel: PostViewModel = PostViewModel()
    
    @Namespace private var name
    
    @State private var selectedPost: PostModel?
    
    @State private var wasPostSelected: Bool = false
    
    let publicMode: Bool
    
    private func setDistanceIndex(_ index: Int) -> Void {
        vm.distanceIndex = index
        vm.loadPostsFromStorage()
    }
    
    var body: some View {
        VStack {
            AddressSearchBar(searchResultString: $vm.searchResultString) {
                vm.loadPostsFromStorage()
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 8)
            
            HStack (spacing: 0) {
                Button(action: {
                    withAnimation(.spring()) {
                        setDistanceIndex(0)
                    }
                }, label: {
                    VStack {
                        Text("100m")
                            .font(.system(size: 14))
                            .fontWeight(.bold)
                            .foregroundColor(vm.distanceIndex == 0 ? .black : .gray)
                        
                        ZStack {
                            Rectangle()
                                .opacity(0)
                                .frame(height: 4)
                            
                            if vm.distanceIndex == 0 {
                                Rectangle()
                                    .fill(Color("ButtonBackground"))
                                    .frame(height: 4)
                                    .matchedGeometryEffect(id: "Tab", in: name)
                            }
                        }
                    }
                })
                .frame(width: UIScreen.main.bounds.width / 3)
                
                Button(action: {
                    withAnimation(.spring()) {
                        setDistanceIndex(1)
                    }
                }, label: {
                    VStack {
                        Text("500m")
                            .font(.system(size: 14))
                            .fontWeight(.bold)
                            .foregroundColor(vm.distanceIndex == 1 ? .black : .gray)
                        
                        ZStack {
                            Rectangle()
                                .opacity(0)
                                .frame(height: 4)
                            
                            if vm.distanceIndex == 1 {
                                Rectangle()
                                    .fill(Color("ButtonBackground"))
                                    .frame(height: 4)
                                    .matchedGeometryEffect(id: "Tab", in: name)
                            }
                        }
                    }
                })
                .frame(width: UIScreen.main.bounds.width / 3)
                
                Button(action: {
                    withAnimation(.spring()) {
                        setDistanceIndex(2)
                    }
                }, label: {
                    VStack {
                        Text("1km")
                            .font(.system(size: 14))
                            .fontWeight(.bold)
                            .foregroundColor(vm.distanceIndex == 2 ? .black : .gray)
                        
                        ZStack {
                            Rectangle()
                                .opacity(0)
                                .frame(height: 4)
                            
                            if vm.distanceIndex == 2 {
                                Rectangle()
                                    .fill(Color("ButtonBackground"))
                                    .frame(height: 4)
                                    .matchedGeometryEffect(id: "Tab", in: name)
                            }
                        }
                    }
                })
                .frame(width: UIScreen.main.bounds.width / 3)
            }
            
            if vm.posts.isEmpty {
                HStack (spacing: 0) {
                    
                    Image(systemName: "cloud")
                        .font(.system(size: 30, weight: Font.Weight.regular))
                        .padding(.bottom, 32)
                        .foregroundColor(Color("ImageCloud"))
                    
                    Spacer()
                    
                    Image(systemName: "cloud")
                        .font(.system(size: 120, weight: Font.Weight.regular))
                        .foregroundColor(Color("ImageCloud"))
                    /*
                    Image(systemName: "cloud")
                        .font(.system(size: 30, weight: Font.Weight.regular))
                        .padding(.bottom, 32)
                        .foregroundColor(Color("ImageCloud"))
                    */
                    //Image(systemName: "cloud.sun")
                    Image(systemName: "sun.max")
                        .font(.system(size: 100, weight: Font.Weight.regular))
                        .padding(.leading, 8)
                        .foregroundColor(Color("ImageSun"))
                }
                .padding(.top, 16)
                .padding(.horizontal, 8)
                
                HStack (alignment: .top) {
                    VStack(alignment: .leading) {
                        Image(systemName: "bubble.left")
                            .font(.system(size: 120, weight: Font.Weight.thin))
                            .overlay(Text("tower_left-DESC")
                                        .font(.system(size: 16, weight: .medium))
                                        .padding(.bottom, 16)
                                        .padding(.horizontal, 16)
                                        .foregroundColor(.black))
                            .padding(.trailing, 16)
                            .padding(.bottom, 4)
                            .padding(.leading, 8)
                        
                        Image(systemName: "building.2")
                            .font(.system(size: 80, weight: Font.Weight.thin))
                            .padding(.leading, 16)
                    }
                    
                    Spacer()
                    
                    VStack (alignment: .trailing) {
                        Image(systemName: "bubble.right")
                            .font(.system(size: 120, weight: Font.Weight.thin))
                            .overlay(Text("tower_right-DESC")
                                        .font(.system(size: 16, weight: .medium))
                                        .padding(.bottom, 16)
                                        .padding(.horizontal, 16))
                            .padding(.trailing, 16)
                            .padding(.bottom, 4)
                        
                        Image(systemName: "building")
                            .font(.system(size: 80, weight: Font.Weight.thin))
                            .padding(.trailing, 16)
                    }
                    .padding(.top, 20)
                }
                .padding(16)
                
                Text("neighbours_thinking-DESC")
                    .font(.system(size: 16, weight: .regular))
                
                HStack {
                    Text("Ship n Share")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(Color("ButtonBackground"))
                    
                    Text("today-NC-E")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(Color("ButtonBackground"))
                }
                
                Spacer()
            } else {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(vm.posts, id: \.self.id) { post in
                            /*
                            NavigationLink(destination: PostView(post: post,
                                                                 publicMode: publicMode,
                                                                 vm: postViewModel),
                                           tag: post,
                                           selection: $selectedPost) {
                                PostGridItem(post: post) {
                                 selectedPost = post
                                 wasPostSelected = true
                                 print("Post selected")
                             }
                            }
                                .labelsHidden()
                                .fixedSize()
                                .padding(8)
 */
                            
                            
                            PostGridItem(post: post) {
                                selectedPost = post
                                wasPostSelected = true
                                print("Post selected")
                            }
                            .padding(8)
                            /*

                            NavigationLink("test",
                                           destination: PostView(post: post,
                                                                 publicMode: publicMode,
                                                                 vm: postViewModel),
                                           tag: post,
                                           selection: $selectedPost)
                                .labelsHidden()
                                .fixedSize()
                                .frame(width: 0, height: 0)
                             */
                             
                            
                        }
                    }
                    
                    
                    if let selectedPost = selectedPost {
                        NavigationLink("", destination: PostView(post: selectedPost, publicMode: publicMode, vm: postViewModel), isActive: $wasPostSelected)
                            .labelsHidden()
                            .fixedSize()
                    }
                     
                }
            }
        }
        .onAppear {
            print("BrowseView: onAppear")
            vm.loadPostsFromStorage()
        }
    }
    
    struct BrowseView_Previews: PreviewProvider {
        static var previews: some View {
            BrowseView(publicMode: true)//.previewDevice("iPhone 11")
        }
    }
}
