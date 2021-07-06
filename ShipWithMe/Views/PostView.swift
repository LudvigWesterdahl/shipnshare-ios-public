//
//  PostView.swift
//  ShipWithMe
//
//  Created by Ludvig Westerdahl on 2021-04-23.
//

import SwiftUI

struct PostView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @ObservedObject var vm: PostViewModel
    
    @State private var showDeletePostAlert: Bool = false
    
    @State private var post: PostModel
    
    private let publicMode: Bool
    
    @State private var didLoad = false
    
    init(post: PostModel, publicMode: Bool, vm: PostViewModel) {
        self._post = State(initialValue: post)
        self.publicMode = publicMode
        self.vm = vm
    }
    
    var body: some View {
        VStack {
            Group {
                if let imageData = post.imageData {
                    let uiImage = UIImage(data: imageData)!
                    Image(uiImage: uiImage)
                        .interpolation(.none)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: min(uiImage.size.height * uiImage.scale, 200))
                } else {
                    let uiImage = UIImage(named: "Placeholder")!
                    Image(uiImage: uiImage)
                        .interpolation(.none)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: min(uiImage.size.height * uiImage.scale, 200))
                }
                
                HStack {
                    Image(systemName: "mappin")
                        .font(.system(size: 12))
                    Text(post.readableMetersToPickupLocation())
                        .font(.system(size: 14))
                        .fontWeight(.bold)
                        .padding(.trailing, 4)
                    Image(systemName: "seal")
                        .font(.system(size: 12))
                        .padding(.leading, 4)
                    Text(post.readableShippingCost())
                        .font(.system(size: 14))
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                }
                .padding(.vertical, 8)
                
                
                LineDivider()
            }
            
            Group {
                Text(post.description)
                
                HStack {
                    Text(post.createdAt.readableLocalized())
                        .font(.system(size: 12))
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    Spacer()
                }
                .padding(.vertical, 8)
                
                LineDivider()
            }
            
            Text("reviews-FC")
                .font(.system(size: 14))
                .bold()
            
            
            HStack (alignment: .top) {
                    VStack(alignment: .leading) {
                        SheetButton(title: post.ownerUserName,
                                    label: Text(post.ownerUserName)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color("ButtonBackground")),
                                    content: {
                                        Spacer()
                                        
                                        UserReviewsView(userName: post.ownerUserName)
                                        
                                        Spacer()
                                    })
                        
                        
                        HStack {
                            StarsProgressBar(current: vm.userReviews.averageRating, limit: 3)
                            
                            Text("(\(vm.averageRating))")
                        }
                    }
                    
                    Spacer()
                    
                    RatingsExplanation()
                        .padding(.horizontal, 8)
                    
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
            
            Group {
                LineDivider()
      
                if !publicMode {
                    Button(action: {
                        vm.requestToChat(for: post)
                    }, label: {
                        
                        if vm.loading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: Color("ButtonText")))
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else {
                            Text("send_chat_request-FC")
                                .fontWeight(.medium)
                                .foregroundColor(Color("ButtonText"))
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    })
                    .frame(height: 55)
                    .padding(.top, 8)
                    .disabled(!vm.canRequestToChat)
                    .buttonStyle(FilledButtonStyle(cornerRadius: 40,
                                                   fillColor: vm.canRequestToChat ? Color("ButtonBackground") : Color("ButtonDisabledBackground"),
                                                   pressedFillColor: vm.canRequestToChat ? Color("ButtonPressedBackground") : Color("ButtonDisabledBackground")))
                    
                }
            }
            
            
            Spacer()
        }
        .onAppear {
            if !didLoad {
                vm.load(post: post) {
                    vm.loadImage(for: post) { updatedPost in
                        self.post = updatedPost
                    }
                }
            }
            
            didLoad = true
        }
        .padding(8)
        .navigationBarTitle(post.offerValueTitle, displayMode: .inline)
        .navigationBarItems(trailing: Group {
            if !vm.loading && post.ownerUserName == StorageManager.userName {
                Button(action: {
                    showDeletePostAlert = true
                }, label: {
                    Text("Delete")
                        .fontWeight(.regular)
                })
                
            } else {
                EmptyView()
            }
        })
        
        .alert(isPresented: $showDeletePostAlert, content: {
            Alert(title: Text("do_you_really_want_to_delete_the_post-FC-Q"),
                  primaryButton: .default(Text("yes-FC"), action: {
                    vm.delete(post: post) {
                        presentationMode.wrappedValue.dismiss()
                    }
                  }),
                  secondaryButton: .cancel(Text("no-FC")))
        })
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView(post: PostModel.dummyPost(), publicMode: true, vm: PostViewModel())
    }
}
