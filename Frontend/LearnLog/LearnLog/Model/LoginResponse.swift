//
//  LoginResponse.swift
//  LearnLog
//
//  Created by Enzo Henrique Botelho Romão on 16/11/25.
//

import Foundation

struct LoginResponse: Codable {
    let success: Bool
    let user: User?
    let message: String?
}
