//
//  ChatModel.swift
//  ShipWithMe
//
//  Created by Ludvig Westerdahl on 2021-05-15.
//

import Foundation

struct ChatModel: Identifiable, Decodable {
    let id: String
    let createdAt: Date
    let postId: String
    let participants: [String: Bool]
    let messages: [MessageModel]
    let closed: Bool
    
    static func dummyChat() -> ChatModel {
        return ChatModel(id: "ABC123",
                         createdAt: Date(),
                         postId: "DEF456",
                         participants: ["admin": true, "customer": true],
                         messages: [MessageModel(fromUserName: "admin", createdAt: Date(), message: "Hello sir")],
                         closed: false)
    }
}
