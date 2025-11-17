//
//  CourseRow.swift
//  LearnLog
//
//  Created by Enzo Henrique Botelho Romão on 16/11/25.
//

import SwiftUI

struct CourseRow: View {
    let course: Course
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(course.title)
                    .font(.headline)
                Spacer()
                Text(course.formattedPrice) 
                    .font(.subheadline)
                    .padding(4)
                    .background(course.price == 0 ? Color.green.opacity(0.2) : Color.blue.opacity(0.1))
                    .cornerRadius(4)
            }
            
            Text(course.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(2)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    CourseRow(course: Course(id: "1", title: "SwiftUI Descomplicado", description: "Entenda a base do SwiftUI e aproveite as funcionalidades!", price: 400))
}
