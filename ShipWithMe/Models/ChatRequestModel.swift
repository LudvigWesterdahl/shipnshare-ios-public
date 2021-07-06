//
//  ChatRequestModel.swift
//  ShipWithMe
//
//  Created by Ludvig Westerdahl on 2021-05-15.
//

import Foundation

struct ChatRequestModel: Identifiable, Decodable {
    let id: String
    let createdAt: Date
    let chatId: String
    let postId: String
    let fromUserName: String
    let toUserName: String
    let accepted: Bool
    
    static func dummyChatRequest() -> ChatRequestModel {
        return ChatRequestModel(id: "ABC123",
                                createdAt: Date(),
                                chatId: "DEF456",
                                postId: "GHI789",
                                fromUserName: "customer",
                                toUserName: "admin",
                                accepted: false)
    }
}
