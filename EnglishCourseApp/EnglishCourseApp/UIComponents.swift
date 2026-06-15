//
//  UIComponents.swift
//  EnglishCourseApp
//
//  Componentes de UI reutilizáveis
//

import SwiftUI

// MARK: - StatBadge
struct StatBadge: View {
    let label: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)
            }
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

// MARK: - StatCard
struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)
            }
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

// MARK: - BadgeCard
struct BadgeCard: View {
    let badge: Badge
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: badge.icon)
                .font(.system(size: 40))
                .foregroundColor(.yellow)
                .frame(width: 60, height: 60)
                .background(Color.yellow.opacity(0.2))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(badge.name)
                    .font(.headline)
                Text(badge.description)
                    .font(.caption)
                    .foregroundColor(.gray)
                
                if let earnedDate = badge.earnedDate {
                    Text("Conquistado em \(formatDate(earnedDate))")
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2)
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}

// MARK: - ResourceRowView
struct ResourceRowView: View {
    let resource: MenuResource
    
    @ViewBuilder
    var destinationView: some View {
        switch resource.viewType {
        case .vocabulary:
            VocabularyView()
        case .quiz:
            QuizView()
        case .pronunciation:
            PronunciationPracticeView()
        case .flashcards:
            FlashcardView()
        case .progress:
            ProgressView()
        case .settings:
            SettingsView()
        }
    }
    
    var body: some View {
        NavigationLink(destination: destinationView) {
            Label(resource.title, systemImage: resource.icon)
        }
    }
}