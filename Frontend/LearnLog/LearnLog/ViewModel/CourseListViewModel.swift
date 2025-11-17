//
//  CourseListViewModel.swift
//  LearnLog
//
//  Created by Enzo Henrique Botelho Romão on 16/11/25.
//

import Foundation
import Combine

import Foundation

class CourseListViewModel: ObservableObject {
    @Published var courses: [Course] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    init() {
        fetchCourses()
    }
    
    func fetchCourses() {
        self.isLoading = true
        self.errorMessage = nil
        
        CourseService.shared.fetchCourses { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let fetchedCourses):
                    self?.courses = fetchedCourses
                case .failure(let error):
                    self?.errorMessage = "Erro ao carregar: \(error.localizedDescription)"
                    print(error)
                }
            }
        }
    }
}
