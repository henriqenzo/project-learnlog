//
//  CourseService.swift
//  LearnLog
//
//  Created by Enzo Henrique Botelho Romão on 16/11/25.
//

import Foundation

class CourseService {
    static let shared = CourseService()
    private let baseURL = "http://localhost:3000/api"
    
    // Funções
    
    func fetchCourses(completion: @escaping (Result<[Course], ApiError>) -> Void) {
        guard let url = URL(string: "\(baseURL)/cursos") else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            guard let data = data else {
                return
            }
            do {
                let courses = try JSONDecoder().decode([Course].self, from: data)
                completion(.success(courses))
            } catch {
                print("Erro ao decodificar: \(error)")
                completion(.failure(.decodingError(error)))
            }
            
        }.resume()
    }
    
    func fetchCourseDetails(courseId: String, completion: @escaping (Result<CourseDetail, ApiError>) -> Void) {
        guard let url = URL(string: "\(baseURL)/cursos/\(courseId)") else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            guard let data = data else { return }
            
            do {
                let courseDetail = try JSONDecoder().decode(CourseDetail.self, from: data)
                completion(.success(courseDetail))
            } catch {
                print("Erro ao decodificar detalhes: \(error)")
                completion(.failure(.decodingError(error)))
            }
        }.resume()
    }
}
