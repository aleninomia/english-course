//
//  ProgressView.swift
//  EnglishCourseApp
//
//  View de Progresso e Estatísticas extraída do ContentView
//

import SwiftUI

struct ProgressView: View {
    @ObservedObject var progressManager = ProgressManager.shared
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Picker for tabs
                Picker("Seção", selection: $selectedTab) {
                    Text("Visão Geral").tag(0)
                    Text("Conquistas").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                if selectedTab == 0 {
                    overviewTab
                } else {
                    achievementsTab
                }
            }
            .navigationTitle("Progresso")
        }
    }
    
    var overviewTab: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Level Card
                levelCard
                
                // Streak Card
                streakCard
                
                // Weekly Activity Chart
                weeklyActivityChart
                
                // Stats Grid
                statsGrid
                
                // XP Progress
                xpProgressCard
            }
            .padding()
        }
    }
    
    var achievementsTab: some View {
        ScrollView {
            VStack(spacing: 16) {
                if progressManager.progress.badges.isEmpty {
                    VStack(spacing: 20) {
                        Spacer().frame(height: 50)
                        Image(systemName: "trophy")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("Nenhuma conquista ainda")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Text("Continue estudando para ganhar badges!")
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                } else {
                    ForEach(progressManager.progress.badges) { badge in
                        BadgeCard(badge: badge)
                    }
                }
            }
            .padding()
        }
    }
    
    var levelCard: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Nível \(progressManager.progress.level)")
                        .font(.title)
                        .fontWeight(.bold)
                    Text("XP Total: \(progressManager.progress.totalXP)")
                        .foregroundColor(.gray)
                }
                Spacer()
                Image(systemName: "star.circle.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.yellow)
            }
        }
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .topLeading, endPoint: .bottomRight))
        .foregroundColor(.white)
        .cornerRadius(15)
        .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 2)
    }
    
    var streakCard: some View {
        HStack(spacing: 20) {
            // Current Streak
            VStack {
                Image(systemName: "flame.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.orange)
                Text("\(progressManager.progress.currentStreak)")
                    .font(.title2)
                    .fontWeight(.bold)
                Text("Dias Atuais")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Divider()
            
            // Longest Streak
            VStack {
                Image(systemName: "trophy.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.yellow)
                Text("\(progressManager.progress.longestStreak)")
                    .font(.title2)
                    .fontWeight(.bold)
                Text("Recorde")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2)
    }
    
    var weeklyActivityChart: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Atividade Semanal")
                .font(.headline)
            
            HStack(alignment: .bottom, spacing: 8) {
                ForEach(progressManager.getLast7DaysXP(), id: \.day) { dayData in
                    VStack {
                        Spacer()
                        RoundedRectangle(cornerRadius: 4)
                            .fill(dayData.xp > 0 ? Color.blue : Color.gray.opacity(0.3))
                            .frame(width: 30, height: max(10, CGFloat(min(dayData.xp, 100)) / 100 * 100))
                        Spacer()
                        Text(dayData.day)
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                    .frame(height: 120)
                }
            }
            .padding(.vertical, 8)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2)
    }
    
    var statsGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            StatCard(title: "Lições", value: "\(progressManager.progress.lessonsCompleted)", icon: "book.fill", color: .blue)
            StatCard(title: "Quizzes", value: "\(progressManager.progress.quizzesCompleted)", icon: "checkmark.circle.fill", color: .green)
            StatCard(title: "Pronúncia", value: "\(progressManager.progress.pronunciationPractices)", icon: "mic.fill", color: .purple)
            StatCard(title: "Flashcards", value: "\(progressManager.progress.flashcardsReviewed)", icon: "square.stack.3d.up.fill", color: .orange)
        }
    }
    
    var xpProgressCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Progresso para Nível \(progressManager.progress.level + 1)")
                    .font(.headline)
                Spacer()
                Text("\(progressManager.progress.totalXP % 100)/100 XP")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 20)
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .leading, endPoint: .trailing))
                        .frame(width: geometry.size.width * CGFloat(progressManager.progress.totalXP % 100) / 100, height: 20)
                }
            }
            .frame(height: 20)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2)
    }
}