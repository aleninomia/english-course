//
//  ProgressManager.swift
//  EnglishCourseApp
//
//  Gerenciador de progresso, estatisticas e conquistas
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
        let calendar = Calendar.current
        let today = Date()
        let todayString = formatDate(today)

        guard let lastStudyDate else {
            currentStreak = 1
            self.lastStudyDate = todayString
            updateLongestStreak()
            addStudyDay(date: today, xp: 0)
            return
        }

        guard let lastStudyDateObj = parseDate(lastStudyDate) else {
            currentStreak = 1
            self.lastStudyDate = todayString
            updateLongestStreak()
            addStudyDay(date: today, xp: 0)
            return
        }

        let daysDiff = calendar.dateComponents([.day], from: lastStudyDateObj, to: today).day ?? 0

        if daysDiff == 0 {
            return
        }

        if daysDiff == 1 {
            currentStreak += 1
        } else {
            currentStreak = 1
        }

        self.lastStudyDate = todayString
        updateLongestStreak()
        addStudyDay(date: today, xp: 0)
    }

    mutating func addXP(_ amount: Int) {
        totalXP += amount
        addStudyDay(date: Date(), xp: amount)
        checkLevelUp()
        updateStreak()
        checkAchievements()
    }

    mutating func checkLevelUp() {
        let newLevel = (totalXP / 100) + 1
        if newLevel > level {
            level = newLevel
            let levelBadge = Badge(
                id: "level_\(level)",
                name: "Nivel \(level)",
                description: "Alcancou o nivel \(level)",
                icon: "star.fill",
                earnedDate: Date()
            )

            if !badges.contains(where: { $0.id == levelBadge.id }) {
                badges.append(levelBadge)
            }
        }
    }

    mutating func addStudyDay(date: Date, xp: Int) {
        let dayString = formatDate(date)
        if let index = studyHistory.firstIndex(where: { $0.date == dayString }) {
            studyHistory[index].xp += xp
        } else {
            studyHistory.append(StudyDay(date: dayString, xp: xp))
        }

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
        for definition in AchievementDefinition.allCases {
            if achievements.contains(where: { $0.id == definition.id }) {
                continue
            }

            guard definition.isEarned(by: self) else {
                continue
            }

            achievements.append(
                Achievement(
                    id: definition.id,
                    name: definition.name,
                    description: definition.description,
                    earned: true,
                    earnedDate: Date()
                )
            )

            let badge = Badge(
                id: definition.id,
                name: definition.name,
                description: definition.description,
                icon: getBadgeIcon(for: definition.id),
                earnedDate: Date()
            )

            if !badges.contains(where: { $0.id == badge.id }) {
                badges.append(badge)
            }
        }
    }

    func getBadgeIcon(for achievementId: String) -> String {
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

    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

    private func parseDate(_ string: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: string)
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
    var earnedDate: Date?
}

struct Achievement: Codable, Identifiable {
    var id: String
    var name: String
    var description: String
    var earned: Bool = false
    var earnedDate: Date?
}

enum AchievementDefinition: CaseIterable {
    case firstLesson
    case weekStreak
    case monthStreak
    case quizMaster
    case vocabBuilder
    case pronunciationPro
    case level5
    case level10
    case xp1000

    var id: String {
        switch self {
        case .firstLesson: return "first_lesson"
        case .weekStreak: return "week_streak"
        case .monthStreak: return "month_streak"
        case .quizMaster: return "quiz_master"
        case .vocabBuilder: return "vocab_builder"
        case .pronunciationPro: return "pronunciation_pro"
        case .level5: return "level_5"
        case .level10: return "level_10"
        case .xp1000: return "xp_1000"
        }
    }

    var name: String {
        switch self {
        case .firstLesson: return "Primeiros Passos"
        case .weekStreak: return "Dedicado"
        case .monthStreak: return "Comprometido"
        case .quizMaster: return "Mestre do Quiz"
        case .vocabBuilder: return "Construtor de Vocabulario"
        case .pronunciationPro: return "Pronuncia Perfeita"
        case .level5: return "Intermediario"
        case .level10: return "Avancado"
        case .xp1000: return "Mil XP"
        }
    }

    var description: String {
        switch self {
        case .firstLesson: return "Complete sua primeira licao"
        case .weekStreak: return "7 dias consecutivos"
        case .monthStreak: return "30 dias consecutivos"
        case .quizMaster: return "Complete 10 quizzes"
        case .vocabBuilder: return "Revise 50 flashcards"
        case .pronunciationPro: return "Pratique pronuncia 20 vezes"
        case .level5: return "Alcance o nivel 5"
        case .level10: return "Alcance o nivel 10"
        case .xp1000: return "Ganhe 1000 XP totais"
        }
    }

    func isEarned(by progress: UserProgress) -> Bool {
        switch self {
        case .firstLesson:
            return progress.lessonsCompleted >= 1
        case .weekStreak:
            return progress.currentStreak >= 7
        case .monthStreak:
            return progress.currentStreak >= 30
        case .quizMaster:
            return progress.quizzesCompleted >= 10
        case .vocabBuilder:
            return progress.flashcardsReviewed >= 50
        case .pronunciationPro:
            return progress.pronunciationPractices >= 20
        case .level5:
            return progress.level >= 5
        case .level10:
            return progress.level >= 10
        case .xp1000:
            return progress.totalXP >= 1000
        }
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
        let calendar = Calendar.current
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
}

extension UserProgress {
    func formatDateShort(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }
}
