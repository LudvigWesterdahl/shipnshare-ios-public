//
//  ChatsViewModel.swift
//  ShipWithMe
//
//  Created by Ludvig Westerdahl on 2021-05-18.
//

import Foundation

class ChatsViewModel: ObservableObject {
    
    // The open chats
    @Published var chats: [ChatPostModel] = []
    
    // The received chat requests.
    @Published var chatRequests: [ChatRequestPostModel] = []
    
    // Loaded messages
    @Published var messages: [MessageModel] = []
    
    private let userName = StorageManager.userName ?? ""

    private var timer: Timer?
    
    @Published var loading: Bool = false
    
    init() {
        
    }
    
    private func updateChatPost(chatPost: ChatPostModel) -> Void {
        if let index = chats.firstIndex(where: { $0.chat.id == chatPost.chat.id }) {
            chats.remove(at: index)
            chats.insert(chatPost, at: index)
        } else {
            chats.append(chatPost)
        }
        
        chats.sort { chat1, chat2 in
            guard let chat1LastMessage = chat1.chat.messages.last else {
                return false
            }
            
            guard let chat2LastMessage = chat2.chat.messages.last else {
                return true
            }
            
            return chat1LastMessage.createdAt > chat2LastMessage.createdAt
        }
    }
    
    private func updateChatRequestPost(chatRequestPost: ChatRequestPostModel) -> Void {
        if let index = chatRequests.firstIndex(where: { $0.chatRequest.id == chatRequestPost.chatRequest.id }) {
            chatRequests.remove(at: index)
            chatRequests.insert(chatRequestPost, at: index)
        } else {
            chatRequests.append(chatRequestPost)
        }
    }
    
    func loadImage(chatPost: ChatPostModel) -> Void {
        ApiManager.shared.getPostImage(post: chatPost.post) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let updatedPost):
                    self.updateChatPost(chatPost: ChatPostModel(chat: chatPost.chat, post: updatedPost, canReview: true))
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func loadImage(chatRequestPost: ChatRequestPostModel) -> Void {
        ApiManager.shared.getPostImage(post: chatRequestPost.post) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let updatedPost):
                    self.updateChatRequestPost(chatRequestPost: ChatRequestPostModel(chatRequest: chatRequestPost.chatRequest, post: updatedPost))
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private func loadChats() -> Void {
        DispatchQueue.main.async {
            self.chats = []
        }
        
        ApiManager.shared.getChats(messagesCount: 1) { chats in
            for chat in chats {
                ApiManager.shared.canReview(postId: chat.postId) { canReview in
                    ApiManager.shared.getPostByChatId(chatId: chat.id) { post in
                        if let post = post {
                            if chat.closed && post.ownerUserName == self.userName {
                                return
                            }
                            
                            if post.ownerUserName != self.userName && !canReview {
                                return
                            }

                            let chatPost = ChatPostModel(chat: chat, post: post, canReview: true)

                            DispatchQueue.main.async {
                                self.updateChatPost(chatPost: chatPost)
                                self.loadImage(chatPost: chatPost)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func loadChatRequests() -> Void {
        DispatchQueue.main.async {
            self.chatRequests = []
        }
        
        ApiManager.shared.getChatRequests { chatRequests in
            for request in chatRequests.filter({ $0.fromUserName != self.userName }) {
                ApiManager.shared.getPost(by: request.postId) { post in
                    if let post = post {
                        DispatchQueue.main.async {
                            let chatRequestPost = ChatRequestPostModel(chatRequest: request, post: post)
                            self.updateChatRequestPost(chatRequestPost: chatRequestPost)
                            self.loadImage(chatRequestPost: chatRequestPost)
                        }
                    }
                }
            }
        }
    }
    
    func load() -> Void {
        loadChats()
        loadChatRequests()
    }
    
    private func loadMessagesOnce(for chatId: String) -> Void {
        ApiManager.shared.getChat(chatId: chatId) { chat in
            if let chat = chat {
                DispatchQueue.main.async {
                    self.messages = chat.messages
                }
            }
        }
    }
    
    func loadMessages(for chatId: String) -> Void {
        
        guard timer == nil else {
            return
        }
        
        self.messages = []
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.loadMessagesOnce(for: chatId)
        }
    }
    
    func stopLoadMessages() -> Void {
        timer?.invalidate()
        timer = nil
    }
    
    func sendMessage(for chatId: String, message: String) -> Void {
        
        ApiManager.shared.sendChatMessage(for: chatId, message: message) { success in
            if success {
                self.loadMessagesOnce(for: chatId)
            }
        }
    }
    
    func answerChatRequest(chatRequestId: String, accept: Bool) -> Void {
        guard !loading else {
            return
        }
        
        loading = true
        
        ApiManager.shared.answerChatRequest(for: chatRequestId, accept: accept) { success in
            
            DispatchQueue.main.async {
                self.loading = false
            }
            
            if success {
                self.loadChatRequests()
                self.loadChats()
            }
        }
    }
    
    func sendReview(postId: String, rating: Int, message: String, completion: @escaping (Bool) -> Void) -> Void {
        
        guard !loading else {
            return
        }
        
        loading = true
        
        ApiManager.shared.review(postId: postId, rating: rating, message: message) { success in
            DispatchQueue.main.async {
                self.loading = false
                completion(success)
            }
        }
    }
    
    func leaveChat(chatId: String, completion: @escaping () -> Void) -> Void {
        guard !loading else {
            return
        }
        
        loading = true
        
        ApiManager.shared.leaveChat(chatId: chatId) { success in
            DispatchQueue.main.async {
                self.loading = false
                if success {
                    completion()
                }
            }
        }
    }
}
