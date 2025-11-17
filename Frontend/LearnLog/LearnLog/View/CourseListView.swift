//
//  CourseListView.swift
//  LearnLog
//
//  Created by Enzo Henrique Botelho Romão on 16/11/25.
//

import SwiftUI

struct CourseListView: View {

    @StateObject var viewModel = CourseListViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.isLoading {
                    ProgressView("Carregando cursos...")
                } else if viewModel.courses.isEmpty {
                    Text("Nenhum curso disponível.")
                        .foregroundColor(.gray)
                } else {
                    List(viewModel.courses) { course in
                        NavigationLink(destination: CourseDetailView(courseId: course.id)) {
                            CourseRow(course: course)
                        }
                    }
                }
            }
            .navigationTitle("Meus Cursos")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: ProfileView()) {
                        Image(systemName: "person.circle")
                            .font(.title2)
                    }
                }
            }
            .refreshable {
                viewModel.fetchCourses()
            }
        }
    }
}

#Preview {
    CourseListView()
        .environmentObject(AuthViewModel())
}
