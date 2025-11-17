//
//  ApiError.swift
//  LearnLog
//
//  Created by Enzo Henrique Botelho Romão on 16/11/25.
//

import Foundation

enum ApiError: Error {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
}
