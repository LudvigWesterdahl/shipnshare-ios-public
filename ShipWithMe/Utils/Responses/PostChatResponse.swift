//
//  PostChatResponse.swift
//  ShipWithMe
//
//  Created by Ludvig Westerdahl on 2021-05-15.
//

import Foundation

struct PostChatResponse: Decodable {
    
    let id: String?
    let createdAt: Date?
    let postId: String?
    let participants: [String: Bool]?
    let messages: [MessageModel]?
    let closed: Bool?
    
    let errorCode: Int?
    let englishMessage: String?
    
    
    var chat: ChatModel? {
        if let id = id,
           let createdAt = createdAt,
           let postId = postId,
           let participants = participants,
           let messages = messages,
           let closed = closed {
            return ChatModel(id: id,
                             createdAt: createdAt,
                             postId: postId,
                             participants: participants,
                             messages: messages,
                             closed: closed)
        } else {
            return nil
        }
    }
}
