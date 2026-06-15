//
//  FlashcardManager.swift
//  EnglishCourseApp
//
//  Sistema de Flashcards com Repetição Espaçada
//

import Foundation
import SwiftUI

// MARK: - Modelos de Dados

struct Flashcard: Codable, Identifiable {
    var id = UUID()
    var front: String  // Inglês
    var back: String   // Português
    var example: String
    var category: String
    var difficulty: Difficulty = .easy
    var reviewCount: Int = 0
    var correctCount: Int = 0
    var lastReviewed: Date?
    var nextReviewDate: Date?
    var interval: Int = 0 // dias até próxima revisão
    var easeFactor: Double = 2.5 // Fator de facilidade SM-2 (mínimo 1.3)
    
    enum Difficulty: String, Codable {
        case easy = "Fácil"
        case medium = "Médio"
        case hard = "Difícil"
    }
    
    var successRate: Double {
        guard reviewCount > 0 else { return 0 }
        return Double(correctCount) / Double(reviewCount)
    }
}

class FlashcardManager: ObservableObject {
    static let shared = FlashcardManager()
    
    @Published var flashcards: [Flashcard] = []
    @Published var reviewQueue: [Flashcard] = []
    @Published var currentCard: Flashcard?
    @Published var isFlipped: Bool = false
    @Published var showResult: Bool = false
    @Published var sessionStats: SessionStats = SessionStats()
    
    private let saveKey = "FlashcardsData"
    
    init() {
        loadFlashcards()
        if flashcards.isEmpty {
            initializeDefaultFlashcards()
        }
        updateReviewQueue()
    }
    
    func initializeDefaultFlashcards() {
        let defaultCards = [
            Flashcard(front: "Hello", back: "Olá", example: "Hello, how are you?", category: "Saudações"),
            Flashcard(front: "Good morning", back: "Bom dia", example: "Good morning, everyone!", category: "Saudações"),
            Flashcard(front: "Thank you", back: "Obrigado", example: "Thank you for your help.", category: "Expressões"),
            Flashcard(front: "Please", back: "Por favor", example: "Please, sit down.", category: "Expressões"),
            Flashcard(front: "Yes", back: "Sim", example: "Yes, I agree.", category: "Básico"),
            Flashcard(front: "No", back: "Não", example: "No, thank you.", category: "Básico"),
            Flashcard(front: "Water", back: "Água", example: "I need some water.", category: "Alimentos"),
            Flashcard(front: "Food", back: "Comida", example: "The food is delicious.", category: "Alimentos"),
            Flashcard(front: "House", back: "Casa", example: "This is my house.", category: "Lugares"),
            Flashcard(front: "Car", back: "Carro", example: "I have a new car.", category: "Transporte"),
            Flashcard(front: "Friend", back: "Amigo", example: "She is my best friend.", category: "Pessoas"),
            Flashcard(front: "Family", back: "Família", example: "I love my family.", category: "Pessoas"),
            Flashcard(front: "Work", back: "Trabalho", example: "I go to work every day.", category: "Dia a Dia"),
            Flashcard(front: "Study", back: "Estudar", example: "I study English.", category: "Educação"),
            Flashcard(front: "Learn", back: "Aprender", example: "I want to learn more.", category: "Educação"),
            Flashcard(front: "Beautiful", back: "Bonito/Bela", example: "What a beautiful day!", category: "Adjetivos"),
            Flashcard(front: "Important", back: "Importante", example: "This is very important.", category: "Adjetivos"),
            Flashcard(front: "To run", back: "Correr", example: "I like to run in the morning.", category: "Verbos"),
            Flashcard(front: "To eat", back: "Comer", example: "Let's eat together.", category: "Verbos"),
            Flashcard(front: "Tomorrow", back: "Amanhã", example: "See you tomorrow!", category: "Tempo")
        ]
        
        flashcards = defaultCards
        saveFlashcards()
    }
    
    func updateReviewQueue() {
        let now = Date()
        reviewQueue = flashcards.filter { card in
            guard let nextReview = card.nextReviewDate else {
                return true // Nunca revisado
            }
            return nextReview <= now
        }.sorted { card1, card2 in
            guard let date1 = card1.nextReviewDate, let date2 = card2.nextReviewDate else {
                return false
            }
            return date1 < date2
        }
    }
    
    func getNextCard() -> Flashcard? {
        updateReviewQueue()
        guard !reviewQueue.isEmpty else { return nil }
        currentCard = reviewQueue.first
        isFlipped = false
        showResult = false
        return currentCard
    }
    
    func flipCard() {
        withAnimation {
            isFlipped.toggle()
        }
    }
    
    func rateCard(_ rating: Rating) {
        guard var card = currentCard else { return }
        
        sessionStats.totalReviewed += 1
        
        // Atualizar estatísticas do cartão
        card.reviewCount += 1
        if rating != .again {
            card.correctCount += 1
            sessionStats.correctCount += 1
        }
        
        // Calcular próximo intervalo baseado no algoritmo SM-2 correto
        // Referência: https://www.supermemo.com/en/archives1990-2015/english/ol/sm2
        switch rating {
        case .again:
            // Qualidade 0: reset completo
            card.interval = 0
            card.easeFactor = max(1.3, card.easeFactor - 0.2)
            card.nextReviewDate = Date()
            card.difficulty = .hard
            
        case .hard:
            // Qualidade 1: difícil
            if card.reviewCount == 1 {
                card.interval = 1
            } else {
                card.interval = max(1, Int(Double(card.interval) * 1.2))
            }
            card.easeFactor = max(1.3, card.easeFactor - 0.15)
            card.nextReviewDate = Calendar(identifier: .gregorian).date(byAdding: .day, value: card.interval, to: Date())
            card.difficulty = .medium
            
        case .good:
            // Qualidade 2: bom
            if card.reviewCount == 1 {
                card.interval = 1
            } else if card.reviewCount == 2 {
                card.interval = 6
            } else {
                card.interval = Int(Double(card.interval) * card.easeFactor)
            }
            // EF não muda para quality 2
            card.nextReviewDate = Calendar(identifier: .gregorian).date(byAdding: .day, value: card.interval, to: Date())
            card.difficulty = .easy
            
        case .easy:
            // Qualidade 3: fácil
            if card.reviewCount == 1 {
                card.interval = 1
            } else if card.reviewCount == 2 {
                card.interval = 6
            } else {
                card.interval = Int(Double(card.interval) * card.easeFactor * 1.3)
            }
            card.easeFactor = card.easeFactor + 0.15
            card.nextReviewDate = Calendar(identifier: .gregorian).date(byAdding: .day, value: card.interval, to: Date())
            card.difficulty = .easy
        }
        
        card.lastReviewed = Date()
        
        // Atualizar na lista principal
        if let index = flashcards.firstIndex(where: { $0.id == card.id }) {
            flashcards[index] = card
        }
        
        // Remover da fila de revisão
        reviewQueue.removeAll { $0.id == card.id }
        
        // Salvar e preparar próximo cartão
        saveFlashcards()
        showResult = true
        
        // Adicionar XP
        ProgressManager.shared.addXP(rating.xpValue, type: .flashcard)
    }
    
    enum Rating: Int {
        case again = 0  // Errou, revisar agora
        case hard = 1   // Difícil
        case good = 2   // Bom
        case easy = 3   // Fácil
        
        var xpValue: Int {
            switch self {
            case .again: return 1
            case .hard: return 3
            case .good: return 5
            case .easy: return 7
            }
        }
        
        var color: Color {
            switch self {
            case .again: return .red
            case .hard: return .orange
            case .good: return .blue
            case .easy: return .green
            }
        }
        
        var label: String {
            switch self {
            case .again: return "Revisar"
            case .hard: return "Difícil"
            case .good: return "Bom"
            case .easy: return "Fácil"
            }
        }
    }
    
    func resetSession() {
        currentCard = nil
        isFlipped = false
        showResult = false
        sessionStats = SessionStats()
        updateReviewQueue()
    }
    
    func saveFlashcards() {
        if let encoded = try? JSONEncoder().encode(flashcards) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    
    func loadFlashcards() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([Flashcard].self, from: data) {
            flashcards = decoded
        }
    }
    
    func addCustomCard(front: String, back: String, example: String, category: String) {
        let newCard = Flashcard(front: front, back: back, example: example, category: category)
        flashcards.append(newCard)
        saveFlashcards()
    }
    
    func deleteCard(_ card: Flashcard) {
        flashcards.removeAll { $0.id == card.id }
        reviewQueue.removeAll { $0.id == card.id }
        saveFlashcards()
    }
}

struct SessionStats {
    var totalReviewed: Int = 0
    var correctCount: Int = 0
    
    var accuracy: Double {
        guard totalReviewed > 0 else { return 0 }
        return Double(correctCount) / Double(totalReviewed) * 100
    }
}
