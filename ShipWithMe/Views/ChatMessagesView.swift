//
//  ChatMessagesView.swift
//  ShipWithMe
//
//  Created by Ludvig Westerdahl on 2021-05-30.
//

import SwiftUI

struct ChatMessagesView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @ObservedObject var vm: ChatsViewModel
    
    @State private var message: String = ""
    
    @State private var rating: Int = 2
    
    @State private var showLeaveChatAlert: Bool = false
    
    let chat: ChatPostModel
    
    private let userName = StorageManager.userName!
    
    private var otherUserName: String {
        return chat.chat.participants.keys.filter({ $0 != userName }).first!
    }
    
    private func messageView(message: MessageModel) -> some View {
        
        return HStack {
            if message.fromUserName == userName {
                Spacer()
            }
            
            VStack(alignment: message.fromUserName == userName ? .trailing : .leading) {
                Text(message.message)
                    .font(.system(size: 14))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(message.fromUserName == userName
                                    ? Color("ButtonBackground").opacity(0.25)
                                    : Color("ButtonDisabledBackground").opacity(0.25))
                    .clipShape(Capsule())
                
                Text(message.createdAt.readableLocalized())
                    .font(.system(size: 12))
            }
            
            if message.fromUserName != userName {
                Spacer()
            }
        }
    }
    
    var body: some View {
        VStack {
            ScrollViewReader { value in
                ScrollView {
                    ForEach(vm.messages.indices, id: \.self) { index in
                        messageView(message: vm.messages[index])
                            .id(index)
                    }
                    .onChange(of: vm.messages.count) { _ in
                        value.scrollTo(vm.messages.count - 1)
                    }
                }
            }
            .padding(.horizontal, 8)
            .padding(.bottom, -8)
            
            LineDivider(padding: 0)
            
            if chat.chat.closed {
                
                VStack {
                    Text("leave_a_review-FC-E")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Color("ButtonBackground"))
                    
                    Text("describe_your_experience_with_{1}-FC \(otherUserName)")
                        .font(.system(size: 14, weight: .bold))
                        .padding(.bottom, 16)
                    
                    RatingSlider(selectedRating: $rating)
                        .padding(.bottom, 16)
                        .disabled(vm.loading)
                    
                    
                    StarsProgressBar(current: $rating, limit: 3)
                        .font(.system(size: 24))
                        .padding(.bottom, 16)
                    
                    HStack {
                        ZStack {
                            TextField("message-FC", text: $message, onCommit: {
                                message = ""
                            })
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .disabled(vm.loading)
                            .padding(.horizontal, 8)
                        }
                        .padding()
                        .frame(height: 40)
                        .background(Color("TextFieldBackground"))
                        .cornerRadius(40)
                        .shadow(radius: 2)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    .padding(.bottom, 32)
                    
                    Button(action: {
                        vm.sendReview(postId: chat.post.id, rating: rating, message: message) { success in
                            if success {
                                message = ""
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                    }, label: {
                        if vm.loading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: Color("ButtonText")))
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else {
                            Text("send-FC")
                                .fontWeight(.medium)
                                .foregroundColor(Color("ButtonText"))
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                        
                    })
                    .frame(width: 200, height: 55)
                    .disabled(vm.loading)
                    .buttonStyle(FilledButtonStyle(cornerRadius: 40))
                }
                
            } else {
                HStack {
                    ZStack {
                        TextField("message-FC", text: $message, onCommit: {
                            vm.sendMessage(for: chat.chat.id, message: message)
                            message = ""
                        })
                        .padding(.horizontal, 8)
                    }
                    .padding()
                    .frame(height: 40)
                    .background(Color("TextFieldBackground"))
                    .cornerRadius(40)
                    .shadow(radius: 2)
                    
                    Button(action: {
                        vm.sendMessage(for: chat.chat.id, message: message)
                        message = ""
                    }, label: {
                        Image(systemName: "paperplane.fill")
                            .font(.system(size: 24))
                            .foregroundColor(Color("ButtonBackground"))
                    })
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 32)
            }
        }
        .background(Color.white)
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        .onAppear {
            vm.loadMessages(for: chat.chat.id)
        }
        .onDisappear {
            vm.stopLoadMessages()
        }
        .navigationBarTitle(chat.post.offerValueTitle, displayMode: .inline)
        .navigationBarItems(trailing: Group {
            
            if !chat.chat.closed {
                Button(action: {
                    showLeaveChatAlert = true
                }, label: {
                    Text("leave_chat-FC")
                        .fontWeight(.regular)
                })
                .disabled(vm.loading)
            } else {
                EmptyView()
            }
        })
        .alert(isPresented: $showLeaveChatAlert, content: {
            Alert(title: Text("do_you_really_want_to_leave_the_chat-FC-Q"),
                  primaryButton: .default(Text("yes-FC"), action: {
                    vm.leaveChat(chatId: chat.chat.id) {
                        presentationMode.wrappedValue.dismiss()
                    }
                  }),
                  secondaryButton: .cancel(Text("no-FC")))
        })
    }
}

struct ChatMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        ChatMessagesView(vm: ChatsViewModel(), chat: ChatPostModel(chat: ChatModel.dummyChat(), post: PostModel.dummyPost(), canReview: true))
    }
}
