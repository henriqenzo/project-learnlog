//
//  CourseDetail.swift
//  LearnLog
//
//  Created by Enzo Henrique Botelho Romão on 16/11/25.
//

import Foundation

struct CourseDetail: Codable {
    let id: String
    let title: String
    let description: String
    let price: Double
    let lessons: [Lesson]
    
    enum CodingKeys: String, CodingKey {
        case id
        case title = "titulo"
        case description = "descricao"
        case lessons = "aulas"
        case price = "preco" 
    }
}
