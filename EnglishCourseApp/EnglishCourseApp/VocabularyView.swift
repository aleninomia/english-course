//
//  VocabularyView.swift
//  EnglishCourseApp
//
//  View de vocabulário extraída do ContentView
//

import SwiftUI

struct VocabularyView: View {
    var body: some View {
        List {
            Section(header: Text("Palavras Comuns")) {
                ForEach(commonVocabulary) { word in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(word.english)
                            .font(.headline)
                        Text(word.portuguese)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .navigationTitle("Vocabulário")
    }
}