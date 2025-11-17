//
//  LessonCard.swift
//  LearnLog
//
//  Created by Enzo Henrique Botelho Romão on 16/11/25.
//

import SwiftUI

struct LessonCard: View {
    let lesson: Lesson
    
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: iconForType(lesson.type))
                .font(.title)
                .foregroundColor(.blue)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(lesson.title)
                    .font(.headline)
                
                switch lesson.type {
                case .video:
                    if let url = lesson.videoURL {
                        Text("Vídeo: \(lesson.duration ?? 0) min")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Link("Assistir Aula", destination: URL(string: url)!)
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                case .text:
                    Text(lesson.textContent ?? "")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .lineLimit(3)
                case .quiz:
                    Text("Quiz Prático")
                        .font(.caption)
                        .padding(5)
                        .background(Color.orange.opacity(0.2))
                        .cornerRadius(5)
                }
            }
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
    
    func iconForType(_ type: LessonType) -> String {
        switch type {
        case .video: return "play.circle.fill"
        case .text: return "doc.text.fill"
        case .quiz: return "checkmark.circle.fill"
        }
    }
}
