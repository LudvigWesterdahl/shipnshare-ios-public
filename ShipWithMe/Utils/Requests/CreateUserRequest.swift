//
//  CreateUserRequest.swift
//  Ship n Share
//
//  Created by Ludvig Westerdahl on 2021-06-09.
//

import Foundation

struct CreateUserRequest: Encodable {
    let email: String
    let userName: String
    let password: String
}
