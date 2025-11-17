//
//  CourseDetailViewModel.swift
//  LearnLog
//
//  Created by Enzo Henrique Botelho Romão on 16/11/25.
//

import Foundation
import Combine

class CourseDetailViewModel: ObservableObject {
    @Published var course: CourseDetail?
    @Published var isLoading = false
    
    private let courseId: String
    
    init(courseId: String) {
        self.courseId = courseId
        fetchDetails()
    }
    
    func fetchDetails() {
        self.isLoading = true
        
        CourseService.shared.fetchCourseDetails(courseId: courseId) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let detail):
                    self?.course = detail
                case .failure(let error):
                    print("Erro: \(error)")
                }
            }
        }
    }
}
