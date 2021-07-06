//
//  ChatsView.swift
//  ShipWithMe
//
//  Created by Ludvig Westerdahl on 2021-03-29.
//

import SwiftUI


struct ChatsView: View {
    
    @StateObject private var vm: ChatsViewModel = ChatsViewModel()
    
    @State private var selectedChat: ChatPostModel?
    
    @State private var wasChatSelected: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                SheetButton(title: "chat_requests-AC",
                            label: Text("chat_requests-AC")
                                .fontWeight(.medium)
                                .foregroundColor(Color("ButtonBackground")),
                            content: {
                                Spacer()
                                ScrollView {
                                    ForEach(vm.chatRequests, id: \.self.chatRequest.id) { chatRequestPost in
                                        ChatRequestListItem(model: chatRequestPost) { answered in
                                            vm.answerChatRequest(chatRequestId: chatRequestPost.chatRequest.id,
                                                                 accept: answered)
                                        }
                                        .padding(8)
                                    }
                                }
                                Spacer()
                            })
            }
            .padding(.horizontal, 16)
            
            ScrollView {
                ForEach(vm.chats, id: \.self.chat.id) { chatPost in
                    ChatListItem(model: chatPost) {
                        selectedChat = chatPost
                        wasChatSelected = true
                        vm.loadMessages(for: chatPost.chat.id)
                    }
                    .padding(8)
                    
                }
                
                
                if let selectedChat = selectedChat {
                    NavigationLink("", destination: ChatMessagesView(vm: vm, chat: selectedChat), isActive: $wasChatSelected)
                        .labelsHidden()
                        .fixedSize()
                }
                
            }
        }
        .onAppear {
            vm.load()
            vm.stopLoadMessages()
        }
    }
}

struct ChatsView_Previews: PreviewProvider {
    static var previews: some View {
        ChatsView()
    }
}
