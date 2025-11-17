//
//  Lesson.swift
//  LearnLog
//
//  Created by Enzo Henrique Botelho Romão on 16/11/25.
//

import Foundation

struct Lesson: Identifiable, Codable {
    let id: String
    let title: String
    let type: LessonType
    let textContent: String? // Opcional, pois vídeo não tem texto
    let videoURL: String?    // Opcional, pois texto não tem vídeo
    let duration: Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title = "titulo"
        case type = "tipo"
        case textContent = "texto_conteudo"
        case videoURL = "url_video"
        case duration = "duracao_minutos"
    }
}

enum LessonType: String, Codable {
    case video = "VIDEO"
    case text = "TEXTO"
    case quiz = "QUIZ"
}
