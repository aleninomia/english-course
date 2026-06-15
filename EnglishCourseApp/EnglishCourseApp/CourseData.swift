//
//  CourseData.swift
//  EnglishCourseApp
//
//  Dados do curso extraídos para facilitar manutenção e localização
//

import Foundation

// MARK: - Estruturas de Dados

struct CourseModule: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let icon: String
    let iconColor: String
    let lessons: [String]
}

struct VocabularyWord: Identifiable {
    let id = UUID()
    let english: String
    let portuguese: String
}

struct QuizQuestion: Identifiable {
    let id = UUID()
    let question: String
    let options: [String]
    let correctIndex: Int
}

struct PracticePhrase: Identifiable {
    let id = UUID()
    let text: String
}

// MARK: - Dados do Curso

let courseModules: [CourseModule] = [
    CourseModule(
        title: "Básico 1",
        subtitle: "Saudações e cumprimentos",
        icon: "book.fill",
        iconColor: "blue",
        lessons: ["Hello", "Good Morning", "Thank you"]
    ),
    CourseModule(
        title: "Básico 2",
        subtitle: "Apresentações pessoais",
        icon: "book.fill",
        iconColor: "green",
        lessons: ["My name is...", "How are you?", "I'm fine"]
    ),
    CourseModule(
        title: "Intermediário 1",
        subtitle: "Gramática essencial",
        icon: "star.fill",
        iconColor: "orange",
        lessons: ["Past Simple", "Present Perfect", "Future Plans"]
    )
]

let commonVocabulary: [VocabularyWord] = [
    VocabularyWord(english: "Hello", portuguese: "Olá"),
    VocabularyWord(english: "Good morning", portuguese: "Bom dia"),
    VocabularyWord(english: "Thank you", portuguese: "Obrigado"),
    VocabularyWord(english: "Please", portuguese: "Por favor"),
    VocabularyWord(english: "Yes", portuguese: "Sim"),
    VocabularyWord(english: "No", portuguese: "Não"),
    VocabularyWord(english: "Water", portuguese: "Água"),
    VocabularyWord(english: "Food", portuguese: "Comida")
]

let quizQuestions: [QuizQuestion] = [
    QuizQuestion(question: "Como se diz 'Olá' em inglês?", options: ["Goodbye", "Hello", "Thanks", "Please"], correctIndex: 1),
    QuizQuestion(question: "Qual é o passado de 'go'?", options: ["Goed", "Gone", "Went", "Going"], correctIndex: 2),
    QuizQuestion(question: "Complete: 'She ___ to school every day'", options: ["go", "goes", "going", "gone"], correctIndex: 1)
]

let practicePhrases: [PracticePhrase] = [
    PracticePhrase(text: "Hello"),
    PracticePhrase(text: "Good morning"),
    PracticePhrase(text: "Thank you"),
    PracticePhrase(text: "How are you?"),
    PracticePhrase(text: "My name is John"),
    PracticePhrase(text: "Nice to meet you"),
    PracticePhrase(text: "Where is the bathroom?"),
    PracticePhrase(text: "I would like water, please")
]

// MARK: - Recursos do Menu

struct MenuResource: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let viewType: ResourceViewType
}

enum ResourceViewType {
    case vocabulary
    case quiz
    case pronunciation
    case flashcards
    case progress
    case settings
}

let menuResources: [MenuResource] = [
    MenuResource(title: "Vocabulário", icon: "text.book.closed", viewType: .vocabulary),
    MenuResource(title: "Quiz", icon: "questionmark.circle", viewType: .quiz),
    MenuResource(title: "Pronúncia", icon: "mic.fill", viewType: .pronunciation),
    MenuResource(title: "Flashcards", icon: "square.stack.3d.up.fill", viewType: .flashcards),
    MenuResource(title: "Progresso", icon: "chart.bar.fill", viewType: .progress),
    MenuResource(title: "Configurações", icon: "gear", viewType: .settings)
]

// MARK: - Dicas de Pronúncia

let pronunciationTips: [String] = [
    "Fale claramente e em um ambiente silencioso",
    "Repita as frases quantas vezes precisar",
    "Preste atenção na pronúncia de cada palavra"
]