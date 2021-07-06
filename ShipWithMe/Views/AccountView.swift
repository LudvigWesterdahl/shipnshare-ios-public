import SwiftUI

struct AccountView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @StateObject private var vm: AccountViewModel = AccountViewModel()
    
    var body: some View {
        VStack {
            Group {
                Text("posts-FC")
                    .font(.system(size: 14))
                    .bold()
                
                if vm.userPosts.isEmpty {
                    Text("you_have_no_open_posts-FC")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(Color("ButtonBackground"))
                } else {
                    ScrollView(.horizontal, showsIndicators: true) {
                        HStack {
                            ForEach(vm.userPosts, id: \.self.id) { post in
                                PostListItem(post: post) {
                                    vm.delete(post: post) { success in
                                        
                                    }
                                }
                                .padding()
                                .frame(width: UIScreen.main.bounds.width * 0.85)
                            }
                        }
                    }
                }
                
                LineDivider()
            }
            
            Group {
                Text("number_of_created_posts-FC")
                    .font(.system(size: 14))
                    .bold()
                
                CircularProgressBar(progress: $vm.numberOfCreatedPosts,
                                    maxProgress: vm.progressLevel,
                                    color: Color("ButtonBackground")) { progress in
                    return "\(String(format: "%.0f", progress))"
                }
                .frame(height: 120)
                .padding(8)
                
                LineDivider()
            }
            
            Group {
                Text("reviews-FC")
                    .font(.system(size: 14))
                    .bold()
                
                HStack (alignment: .top) {
                    RatingsExplanation()
                        .padding(.horizontal, 8)
                    
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        Text("\(vm.userReviews.numberOfGoodReviews)")
                            .font(.system(size: 14))
                        Text("\(vm.userReviews.numberOfGoodButReviews)")
                            .font(.system(size: 14))
                        Text("\(vm.userReviews.numberOfBadButReviews)")
                            .font(.system(size: 14))
                        Text("\(vm.userReviews.numberOfBadReviews)")
                            .font(.system(size: 14))
                    }
                }
                .padding()
                
                LineDivider()
            }
            
            Spacer()
            
            Group {
                Button(action: {
                    vm.deleteSearches {
                        
                    }
                }, label: {
                    Text("clear_address_searches-FC")
                        .foregroundColor(Color("ButtonBackground"))
                        .bold()
                    
                })
                
                Button(action: {
                    vm.logOut {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }, label: {
                    Text("sign_out-FC")
                        .foregroundColor(Color("InvalidRed"))
                        .bold()
                })
                
                Text(vm.userEmail)
                    .font(.system(size: 12))
            }
        }
        .onAppear {
            vm.load()
        }
        
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AccountView()
            /*
             AccountView()
             .environment(\EnvironmentValues.sizeCategory, ContentSizeCategory.accessibilityExtraExtraExtraLarge)
             */
        }
    }
}
