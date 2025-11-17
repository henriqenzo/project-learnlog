//
//  CourseDetailView.swift
//  LearnLog
//
//  Created by Enzo Henrique Botelho Romão on 16/11/25.
//

import SwiftUI

struct CourseDetailView: View {
    
    @StateObject var viewModel: CourseDetailViewModel
    
    init(courseId: String) {
        _viewModel = StateObject(wrappedValue: CourseDetailViewModel(courseId: courseId))
    }
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Carregando conteúdo...")
            } else if let course = viewModel.course {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        VStack(alignment: .leading) {
                            Text(course.title)
                                .font(.largeTitle)
                                .bold()
                            Text(course.description)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        
                        Divider()
                        
                        Text("Conteúdo do Curso")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        LazyVStack(spacing: 15) {
                            ForEach(course.lessons) { lesson in
                                LessonCard(lesson: lesson)
                            }
                        }
                        .padding()
                    }
                }
            } else {
                Text("Não foi possível carregar o curso.")
            }
        }
        .navigationTitle("Detalhes")
        .navigationBarTitleDisplayMode(.inline)
    }
}
