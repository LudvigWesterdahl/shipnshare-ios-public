//
//  AuthenticateRequest.swift
//  ShipWithMe
//
//  Created by Ludvig Westerdahl on 2021-03-28.
//

import Foundation

struct AuthenticateRequest: Encodable {
    let email: String
    let password: String
}
