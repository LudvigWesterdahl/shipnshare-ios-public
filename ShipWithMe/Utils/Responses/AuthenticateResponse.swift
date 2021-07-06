//
//  AuthenticateModel.swift
//  ShipWithMe
//
//  Created by Ludvig Westerdahl on 2021-03-28.
//

import Foundation

struct AuthenticateResponse: Decodable {
    let token: String
    let tokenExpiration: String
    let refreshToken: String
    let refreshTokenExpiration: String
}
