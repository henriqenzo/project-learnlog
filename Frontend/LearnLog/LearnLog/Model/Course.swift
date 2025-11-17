//
//  Course.swift
//  LearnLog
//
//  Created by Enzo Henrique Botelho Romão on 16/11/25.
//

import Foundation

struct Course: Identifiable, Codable {
    let id: String
    let title: String
    let description: String
    let price: Double
    
    enum CodingKeys: String, CodingKey {
        case id
        case title = "titulo"
        case description = "descricao"
        case price = "preco"
    }
    
    var formattedPrice: String {
        if price == 0 { return "Grátis" }
        return String(format: "R$ %.2f", price)
    }
}
