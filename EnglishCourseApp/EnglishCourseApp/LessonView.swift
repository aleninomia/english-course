//
//  LessonView.swift
//  EnglishCourseApp
//
//  View para exibir lições de um módulo
//

import SwiftUI

struct LessonView: View {
    let title: String
    let lessons: [String]
    
    var body: some View {
        List(lessons, id: \.self) { lesson in
            VStack(alignment: .leading, spacing: 8) {
                Text(lesson)
                    .font(.headline)
                Text("Toque para iniciar a lição")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 4)
        }
        .navigationTitle(title)
    }
}

struct ModuleRowView: View {
    let module: CourseModule
    
    var body: some View {
        NavigationLink(destination: LessonView(title: module.title, lessons: module.lessons)) {
            HStack {
                Image(systemName: module.icon)
                    .foregroundColor(Color(module.iconColor))
                VStack(alignment: .leading) {
                    Text(module.title)
                        .font(.headline)
                    Text(module.subtitle)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
    }
}