//
//  ChatMessageRequest.swift
//  ShipWithMe
//
//  Created by Ludvig Westerdahl on 2021-05-29.
//

import Foundation

struct ChatMessageRequest: Encodable {
    let chatId: String
    let message: String
}
