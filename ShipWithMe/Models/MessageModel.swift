//
//  MessageModel.swift
//  ShipWithMe
//
//  Created by Ludvig Westerdahl on 2021-05-15.
//

import Foundation

struct MessageModel: Decodable, Hashable {
    
    enum CodingKeys: String, CodingKey {
        case createdAt,
             message

        case fromUserName = "userName"
    }
    
    let fromUserName: String
    let createdAt: Date
    let message: String
}
