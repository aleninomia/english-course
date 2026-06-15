//
//  ProgressManager.swift
//  EnglishCourseApp
//
//  Gerenciador de progresso, estatísticas e conquistas
//

import Foundation
import SwiftUI

// MARK: - Modelos de Dados

struct UserProgress: Codable {
    var totalXP: Int = 0
    var level: Int = 1
    var lessonsCompleted: Int = 0
    var quizzesCompleted: Int = 0
    var pronunciationPractices: Int = 0
    var flashcardsReviewed: Int = 0
    var currentStreak: Int = 0
    var longestStreak: Int = 0
    var lastStudyDate: String?
    var studyHistory: [StudyDay] = []
    var badges: [Badge] = []
    var achievements: [Achievement] = []
    
    mutating func updateStreak() {
        let calendar = Calendar(identifier: .gregorian)
        let today = startOfDay(for: Date())
        let todayString = formatDate(today)
        
        if lastStudyDate == nil {
            currentStreak = 1
            lastStudyDate = todayString
            updateLongestStreak()
            addStudyDay(date: today, xp: 0)
            return
        }
        
        if let lastDateString = lastStudyDate,
           let lastStudyDateObj = parseDate(lastDateString) {
            let lastDay = startOfDay(for: lastStudyDateObj)
            let daysDiff = calendar.dateComponents([.day], from: lastDay, to: today).day ?? 0
            
            if daysDiff == 0 {
                // Mesmo dia, não faz nada
                return
            } else if daysDiff == 1 {
                // Dia consecutivo
                currentStreak += 1
                lastStudyDate = todayString
                updateLongestStreak()
                addStudyDay(date: today, xp: 0)
            } else if daysDiff > 1 {
                // Quebrou o streak
                currentStreak = 1
                lastStudyDate = todayString
                addStudyDay(date: today, xp: 0)
            }
        }
    }
    
    mutating func addXP(_ amount: Int) {
        totalXP += amount
        checkLevelUp()
        updateStreak()
        checkAchievements()
    }
    
    mutating func checkLevelUp() {
        let newLevel = (totalXP / 100) + 1
        if newLevel > level {
            level = newLevel
            // Adicionar badge de nível se necessário
            let levelBadge = Badge(id: "level_\(level)", name: "Nível \(level)", description: "Alcançou o nível \(level)", icon: "star.fill", earnedDate: Date())
            if !badges.contains(where: { $0.id == levelBadge.id }) {
                badges.append(levelBadge)
            }
        }
    }
    
    mutating func addStudyDay(date: Date, xp: Int) {
        let dayString = formatDate(date) ?? ""
        if let index = studyHistory.firstIndex(where: { $0.date == dayString }) {
            studyHistory[index].xp += xp
        } else {
            studyHistory.append(StudyDay(date: dayString, xp: xp))
        }
        // Manter apenas últimos 30 dias
        if studyHistory.count > 30 {
            studyHistory.removeFirst()
        }
    }
    
    mutating func updateLongestStreak() {
        if currentStreak > longestStreak {
            longestStreak = currentStreak
        }
    }
    
    mutating func checkAchievements() {
        let newAchievements = [
            Achievement(id: "first_lesson", name: "Primeiros Passos", description: "Complete sua primeira lição", earned: false, earnedDate: nil),
            Achievement(id: "week_streak", name: "Dedicado", description: "7 dias consecutivos", earned: false, earnedDate: nil),
            Achievement(id: "month_streak", name: "Comprometido", description: "30 dias consecutivos", earned: false, earnedDate: nil),
            Achievement(id: "quiz_master", name: "Mestre do Quiz", description: "Complete 10 quizzes", earned: false, earnedDate: nil),
            Achievement(id: "vocab_builder", name: "Construtor de Vocabulário", description: "Revise 50 flashcards", earned: false, earnedDate: nil),
            Achievement(id: "pronunciation_pro", name: "Pronúncia Perfeita", description: "Pratique pronúncia 20 vezes", earned: false, earnedDate: nil),
            Achievement(id: "level_5", name: "Intermediário", description: "Alcance o nível 5", earned: false, earnedDate: nil),
            Achievement(id: "level_10", name: "Avançado", description: "Alcance o nível 10", earned: false, earnedDate: nil),
            Achievement(id: "xp_1000", name: "Mil XP", description: "Ganhe 1000 XP totais", earned: false, earnedDate: nil)
        ]
        
        for achievement in newAchievements {
            let conditionMet = checkAchievementCondition(achievement.id)
            if !achievements.contains(where: { $0.id == achievement.id }) && conditionMet {
                achievements.append(Achievement(id: achievement.id, name: achievement.name, description: achievement.description, earned: true, earnedDate: Date()))
                
                // Adicionar badge correspondente
                let badge = Badge(id: achievement.id, name: achievement.name, description: achievement.description, icon: getBadgeIcon(for: achievement.id), earnedDate: Date())
                if !badges.contains(where: { $0.id == badge.id }) {
                    badges.append(badge)
                }
            }
        }
    }
    
    private func checkAchievementCondition(_ id: String) -> Bool {
        switch id {
        case "first_lesson": return lessonsCompleted >= 1
        case "week_streak": return currentStreak >= 7
        case "month_streak": return currentStreak >= 30
        case "quiz_master": return quizzesCompleted >= 10
        case "vocab_builder": return flashcardsReviewed >= 50
        case "pronunciation_pro": return pronunciationPractices >= 20
        case "level_5": return level >= 5
        case "level_10": return level >= 10
        case "xp_1000": return totalXP >= 1000
        default: return false
        }
    }
    
    private func getBadgeIcon(for achievementId: String) -> String {
        switch achievementId {
        case "first_lesson": return "book.fill"
        case "week_streak": return "fire.fill"
        case "month_streak": return "flame.fill"
        case "quiz_master": return "checkmark.circle.fill"
        case "vocab_builder": return "text.book.closed.fill"
        case "pronunciation_pro": return "mic.fill"
        case "level_5", "level_10": return "star.fill"
        case "xp_1000": return "trophy.fill"
        default: return "star.fill"
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: date)
    }
    
    private func parseDate(_ string: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.date(from: string)
    }
    
    /// Retorna o início do dia (00:00) em UTC para comparação consistente
    private func startOfDay(for date: Date) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        return calendar.startOfDay(for: date)
    }
}

struct StudyDay: Codable, Identifiable {
    var id = UUID()
    var date: String
    var xp: Int
}

struct Badge: Codable, Identifiable {
    var id: String
    var name: String
    var description: String
    var icon: String
    var earnedDate: Date
}

struct Achievement: Codable, Identifiable {
    var id: String
    var name: String
    var description: String
    var earned: Bool = false
    var earnedDate: Date?
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, earned, earnedDate
    }
}

// MARK: - Gerenciador Singleton

class ProgressManager: ObservableObject {
    static let shared = ProgressManager()
    
    @Published var progress: UserProgress = UserProgress()
    
    private let saveKey = "UserProgressData"
    
    init() {
        loadProgress()
    }
    
    func addXP(_ amount: Int, type: XPType) {
        switch type {
        case .lesson:
            progress.lessonsCompleted += 1
        case .quiz:
            progress.quizzesCompleted += 1
        case .pronunciation:
            progress.pronunciationPractices += 1
        case .flashcard:
            progress.flashcardsReviewed += 1
        }
        
        progress.addXP(amount)
        saveProgress()
    }
    
    enum XPType {
        case lesson, quiz, pronunciation, flashcard
    }
    
    func saveProgress() {
        if let encoded = try? JSONEncoder().encode(progress) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    
    func loadProgress() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode(UserProgress.self, from: data) {
            progress = decoded
        }
    }
    
    func resetProgress() {
        progress = UserProgress()
        saveProgress()
    }
    
    func getLast7DaysXP() -> [(day: String, xp: Int)] {
        let calendar = Calendar(identifier: .gregorian)
        var result: [(String, Int)] = []
        
        for i in (0..<7).reversed() {
            if let date = calendar.date(byAdding: .day, value: -i, to: Date()) {
                let dayString = progress.formatDate(date)
                if let studyDay = progress.studyHistory.first(where: { $0.date == dayString }) {
                    result.append((progress.formatDateShort(date), studyDay.xp))
                } else {
                    result.append((progress.formatDateShort(date), 0))
                }
            }
        }
        
        return result
    }
    
    func getLast30DaysXP() -> [(day: String, xp: Int)] {
        let calendar = Calendar(identifier: .gregorian)
        var result: [(String, Int)] = []
        
        for i in (0..<30).reversed() {
            if let date = calendar.date(byAdding: .day, value: -i, to: Date()) {
                let dayString = progress.formatDate(date)
                if let studyDay = progress.studyHistory.first(where: { $0.date == dayString }) {
                    result.append((progress.formatDateShort(date), studyDay.xp))
                } else {
                    result.append((progress.formatDateShort(date), 0))
                }
            }
        }
        
        return result
    }
}

extension UserProgress {
    func formatDateShort(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }
}
