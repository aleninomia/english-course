import SwiftUI
import UIKit

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Módulos do Curso")) {
                    NavigationLink(destination: LessonView(title: "Básico 1", lessons: ["Hello", "Good Morning", "Thank you"])) {
                        HStack {
                            Image(systemName: "book.fill")
                                .foregroundColor(.blue)
                            VStack(alignment: .leading) {
                                Text("Básico 1")
                                    .font(.headline)
                                Text("Saudações e cumprimentos")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    
                    NavigationLink(destination: LessonView(title: "Básico 2", lessons: ["My name is...", "How are you?", "I'm fine"])) {
                        HStack {
                            Image(systemName: "book.fill")
                                .foregroundColor(.green)
                            VStack(alignment: .leading) {
                                Text("Básico 2")
                                    .font(.headline)
                                Text("Apresentações pessoais")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    
                    NavigationLink(destination: LessonView(title: "Intermediário 1", lessons: ["Past Simple", "Present Perfect", "Future Plans"])) {
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.orange)
                            VStack(alignment: .leading) {
                                Text("Intermediário 1")
                                    .font(.headline)
                                Text("Gramática essencial")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                
                Section(header: Text("Recursos")) {
                    NavigationLink(destination: VocabularyView()) {
                        Label("Vocabulário", systemImage: "text.book.closed")
                    }
                    NavigationLink(destination: QuizView()) {
                        Label("Quiz", systemImage: "questionmark.circle")
                    }
                    NavigationLink(destination: PronunciationPracticeView()) {
                        Label("Pronúncia", systemImage: "mic.fill")
                    }
                    NavigationLink(destination: FlashcardView()) {
                        Label("Flashcards", systemImage: "square.stack.3d.up.fill")
                    }
                    NavigationLink(destination: ProgressView()) {
                        Label("Progresso", systemImage: "chart.bar.fill")
                    }
                    NavigationLink(destination: SettingsView()) {
                        Label("Configurações", systemImage: "gear")
                    }
                }
            }
            .navigationTitle("Curso de Inglês")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct LessonView: View {
    let title: String
    let lessons: [String]
    @State private var completedLessons: Set<String> = []
    
    var body: some View {
        List(lessons, id: \.self) { lesson in
            VStack(alignment: .leading, spacing: 12) {
                Text(lesson)
                    .font(.headline)
                Text("Toque para iniciar a lição")
                    .font(.caption)
                    .foregroundColor(.gray)
                Button(completedLessons.contains(lesson) ? "ConcluÃ­da" : "Marcar como concluÃ­da") {
                    completeLesson(lesson)
                }
                .buttonStyle(.borderedProminent)
                .disabled(completedLessons.contains(lesson))
            }
            .padding(.vertical, 6)
        }
        .navigationTitle(title)
    }

    private func completeLesson(_ lesson: String) {
        guard !completedLessons.contains(lesson) else { return }
        completedLessons.insert(lesson)
        ProgressManager.shared.addXP(10, type: .lesson)
    }
}

struct VocabularyView: View {
    var body: some View {
        List {
            Section(header: Text("Palavras Comuns")) {
                ForEach(commonWords, id: \.english) { word in
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
    
    let commonWords = [
        (english: "Hello", portuguese: "Olá"),
        (english: "Good morning", portuguese: "Bom dia"),
        (english: "Thank you", portuguese: "Obrigado"),
        (english: "Please", portuguese: "Por favor"),
        (english: "Yes", portuguese: "Sim"),
        (english: "No", portuguese: "Não"),
        (english: "Water", portuguese: "Água"),
        (english: "Food", portuguese: "Comida")
    ]
}

struct QuizView: View {
    @State private var currentQuestion = 0
    @State private var score = 0
    @State private var showResult = false
    
    let questions = [
        Question(question: "Como se diz 'Olá' em inglês?", options: ["Goodbye", "Hello", "Thanks", "Please"], correct: 1),
        Question(question: "Qual é o passado de 'go'?", options: ["Goed", "Gone", "Went", "Going"], correct: 2),
        Question(question: "Complete: 'She ___ to school every day'", options: ["go", "goes", "going", "gone"], correct: 1)
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            if !showResult {
                Text("Quiz de Inglês")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text(questions[currentQuestion].question)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding()
                
                ForEach(0..<questions[currentQuestion].options.count, id: \.self) { index in
                    Button(action: {
                        checkAnswer(index)
                    }) {
                        Text(questions[currentQuestion].options[index])
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                
                Text("Questão \(currentQuestion + 1) de \(questions.count)")
                    .foregroundColor(.gray)
            } else {
                VStack(spacing: 20) {
                    Text("Resultado")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Você acertou \(score) de \(questions.count)")
                        .font(.headline)
                    
                    Button(action: {
                        currentQuestion = 0
                        score = 0
                        showResult = false
                    }) {
                        Text("Reiniciar Quiz")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
        }
        .padding()
        .navigationTitle("Quiz")
    }
    
    func checkAnswer(_ selected: Int) {
        if selected == questions[currentQuestion].correct {
            score += 1
        }
        
        if currentQuestion < questions.count - 1 {
            currentQuestion += 1
        } else {
            showResult = true
            // Adicionar XP baseado no desempenho
            let xpEarned = score * 10
            ProgressManager.shared.addXP(xpEarned, type: .quiz)
        }
    }
}

struct SettingsView: View {
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    @AppStorage("darkMode") private var darkMode = false
    
    var body: some View {
        Form {
            Section(header: Text("Preferências")) {
                Toggle("Notificações diárias", isOn: $notificationsEnabled)
                Toggle("Modo escuro", isOn: $darkMode)
            }
            
            Section(header: Text("Sobre")) {
                Text("Versão 1.0.0")
                Text("Curso de Inglês para Iniciantes")
            }
        }
        .navigationTitle("Configurações")
    }
}

// MARK: - Pronunciation Practice View
struct PronunciationPracticeView: View {
    @StateObject private var speechRecognizer = SpeechRecognizer()
    @State private var selectedPhrase = ""
    @State private var showingPermissionAlert = false
    @State private var awardedXPForCurrentAttempt = false
    
    let practicePhrases = [
        "Hello",
        "Good morning",
        "Thank you",
        "How are you?",
        "My name is John",
        "Nice to meet you",
        "Where is the bathroom?",
        "I would like water, please"
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                Text("Pratique sua Pronúncia")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Escolha uma frase e fale em inglês")
                    .foregroundColor(.gray)
                
                // Phrase Selection
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 12) {
                    ForEach(practicePhrases, id: \.self) { phrase in
                        Button(action: {
                            selectedPhrase = phrase
                            awardedXPForCurrentAttempt = false
                            speechRecognizer.reset()
                        }) {
                            Text(phrase)
                                .font(.caption)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(selectedPhrase == phrase ? Color.blue : Color.gray.opacity(0.2))
                                .foregroundColor(selectedPhrase == phrase ? .white : .primary)
                                .cornerRadius(8)
                        }
                    }
                }
                
                // Recording Area
                if !selectedPhrase.isEmpty {
                    VStack(spacing: 20) {
                        Divider()
                        
                        Text("Frase selecionada:")
                            .font(.headline)
                        
                        Text(selectedPhrase)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                        
                        // Microphone Button
                        Button(action: {
                            toggleRecording()
                        }) {
                            ZStack {
                                Circle()
                                    .fill(speechRecognizer.isRecording ? Color.red : Color.green)
                                    .frame(width: 80, height: 80)
                                
                                Image(systemName: speechRecognizer.isRecording ? "stop.fill" : "mic.fill")
                                    .font(.system(size: 36))
                                    .foregroundColor(.white)
                            }
                        }
                        .disabled(selectedPhrase.isEmpty)
                        
                        Text(speechRecognizer.isRecording ? "Toque para parar" : "Toque para falar")
                            .foregroundColor(.gray)
                        
                        // Results
                        if !speechRecognizer.transcript.isEmpty {
                            VStack(spacing: 12) {
                                Divider()
                                
                                HStack {
                                    Text("Você disse:")
                                        .fontWeight(.medium)
                                    Spacer()
                                }
                                
                                Text(speechRecognizer.transcript)
                                    .font(.headline)
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(8)
                                
                                // Score Gauge
                                VStack(spacing: 8) {
                                    Text("Pontuação de Pronúncia")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    
                                    // Custom gauge using progress bar
                                    GeometryReader { geometry in
                                        ZStack(alignment: .leading) {
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(Color.gray.opacity(0.3))
                                                .frame(height: 20)
                                            
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(scoreColor(for: speechRecognizer.pronunciationScore))
                                                .frame(width: geometry.size.width * CGFloat(speechRecognizer.pronunciationScore / 100), height: 20)
                                        }
                                    }
                                    .frame(height: 20)
                                    
                                    Text(String(format: "%.0f%%", speechRecognizer.pronunciationScore))
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(scoreColor(for: speechRecognizer.pronunciationScore))
                                }
                                .padding(.top, 8)
                                
                                // Feedback Message
                                Text(speechRecognizer.feedbackMessage)
                                    .font(.headline)
                                    .multilineTextAlignment(.center)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.blue.opacity(0.1))
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 2)
                }
                
                // Instructions
                VStack(alignment: .leading, spacing: 8) {
                    Text("💡 Dicas:")
                        .font(.headline)
                    
                    Text("• Fale claramente e em um ambiente silencioso")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("• Repita as frases quantas vezes precisar")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("• Preste atenção na pronúncia de cada palavra")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.yellow.opacity(0.1))
                .cornerRadius(8)
            }
            .padding()
        }
        .navigationTitle("Pronúncia")
        .onAppear {
            checkPermissions()
        }
        .onChange(of: speechRecognizer.isRecording) { isRecording in
            if !isRecording {
                awardPronunciationXPIfNeeded()
            }
        }
        .alert("Permissão de Microfone Necessária", isPresented: $showingPermissionAlert) {
            Button("Abrir Configurações", action: openSettings)
            Button("Cancelar", role: .cancel) {}
        } message: {
            Text("Este app precisa de acesso ao microfone para avaliar sua pronúncia.")
        }
    }
    
    private func toggleRecording() {
        if speechRecognizer.isRecording {
            speechRecognizer.stopRecording()
        } else {
            Task {
                let authorized = await SpeechRecognizer.requestAuthorization()
                if authorized {
                    awardedXPForCurrentAttempt = false
                    speechRecognizer.startRecording(expectedPhrase: selectedPhrase)
                } else {
                    showingPermissionAlert = true
                }
            }
        }
    }
    
    private func checkPermissions() {
        Task {
            let authorized = await SpeechRecognizer.requestAuthorization()
            if !authorized {
                showingPermissionAlert = true
            }
        }
    }
    
    private func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
    
    private func scoreColor(for score: Double) -> Color {
        if score >= 80 {
            return .green
        } else if score >= 60 {
            return .yellow
        } else {
            return .orange
        }
    }

    private func awardPronunciationXPIfNeeded() {
        guard !awardedXPForCurrentAttempt else { return }
        guard !selectedPhrase.isEmpty, !speechRecognizer.transcript.isEmpty else { return }

        awardedXPForCurrentAttempt = true
        ProgressManager.shared.addXP(5, type: .pronunciation)
    }
}

struct Question {
    let question: String
    let options: [String]
    let correct: Int
}

// MARK: - Flashcard View
struct FlashcardView: View {
    @StateObject private var flashcardManager = FlashcardManager.shared
    @State private var showAddCard = false
    @State private var newFront = ""
    @State private var newBack = ""
    @State private var newExample = ""
    @State private var newCategory = "Geral"
    
    var body: some View {
        NavigationView {
            ZStack {
                if flashcardManager.reviewQueue.isEmpty && flashcardManager.currentCard == nil {
                    emptyStateView
                } else {
                    flashcardContentView
                }
            }
            .navigationTitle("Flashcards")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showAddCard = true }) {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    if !flashcardManager.reviewQueue.isEmpty {
                        Text("\(flashcardManager.reviewQueue.count) para revisar")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                }
            }
            .sheet(isPresented: $showAddCard) {
                addCardSheet
            }
        }
    }
    
    var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.green)
            
            Text("Tudo em dia!")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Não há flashcards para revisar no momento.")
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            
            Button(action: {
                flashcardManager.resetSession()
                flashcardManager.getNextCard()
            }) {
                Text("Revisar Todos")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            
            Spacer()
        }
        .padding()
    }
    
    var flashcardContentView: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Session Stats
                HStack {
                    StatBadge(label: "Revisados", value: "\(flashcardManager.sessionStats.totalReviewed)", icon: "arrow.triangle.2.circlepath")
                    StatBadge(label: "Acertos", value: "\(Int(flashcardManager.sessionStats.accuracy))%", icon: "checkmark.circle")
                }
                
                // Current Card
                if let card = flashcardManager.currentCard {
                    ZStack {
                        // Card front/back with flip animation
                        RoundedRectangle(cornerRadius: 20)
                            .fill(LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .topLeading, endPoint: .bottomRight))
                            .frame(height: 300)
                            .shadow(color: .gray.opacity(0.3), radius: 10, x: 0, y: 5)
                        
                        VStack(spacing: 20) {
                            // Category badge
                            Text(card.category)
                                .font(.caption)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.white.opacity(0.3))
                                .cornerRadius(15)
                            
                            Spacer()
                            
                            if flashcardManager.isFlipped {
                                // Back of card
                                Text(card.back)
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                
                                Text(card.example)
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.9))
                                    .multilineTextAlignment(.center)
                                    .padding(.top, 8)
                            } else {
                                // Front of card
                                Text(card.front)
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                
                                Text("Toque para ver a tradução")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.7))
                                    .padding(.top, 8)
                            }
                            
                            Spacer()
                            
                            // Flip hint
                            Button(action: {
                                flashcardManager.flipCard()
                            }) {
                                Image(systemName: "arrow.left.and.right")
                                    .font(.title2)
                                    .foregroundColor(.white)
                            }
                        }
                        .padding()
                    }
                    .onTapGesture {
                        flashcardManager.flipCard()
                    }
                    
                    // Rating buttons (only show after flipping)
                    if flashcardManager.isFlipped && !flashcardManager.showResult {
                        Text("Como foi sua resposta?")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        HStack(spacing: 12) {
                            ForEach([FlashcardManager.Rating.again, .hard, .good, .easy], id: \.self) { rating in
                                Button(action: {
                                    flashcardManager.rateCard(rating)
                                }) {
                                    VStack {
                                        Image(systemName: rating.icon)
                                            .font(.title2)
                                        Text(rating.label)
                                            .font(.caption)
                                    }
                                    .foregroundColor(rating.color)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(rating.color.opacity(0.15))
                                    .cornerRadius(10)
                                }
                            }
                        }
                    }
                    
                    // Next button after rating
                    if flashcardManager.showResult {
                        Button(action: {
                            flashcardManager.getNextCard()
                        }) {
                            Text("Próximo Cartão")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .cornerRadius(10)
                        }
                    }
                }
                
                // Instructions
                VStack(alignment: .leading, spacing: 8) {
                    Text("💡 Como usar:")
                        .font(.headline)
                    Text("1. Toque no cartão para virar")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("2. Avalie quão bem você lembrava")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("3. O app agenda as revisões automaticamente")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.yellow.opacity(0.1))
                .cornerRadius(8)
            }
            .padding()
        }
    }
    
    var addCardSheet: some View {
        NavigationView {
            Form {
                Section(header: Text("Conteúdo")) {
                    TextField("Palavra/Frase em Inglês", text: $newFront)
                    TextField("Tradução em Português", text: $newBack)
                    TextField("Exemplo de uso (opcional)", text: $newExample)
                    TextField("Categoria", text: $newCategory)
                }
                
                Section {
                    Button(action: {
                        if !newFront.isEmpty && !newBack.isEmpty {
                            flashcardManager.addCustomCard(front: newFront, back: newBack, example: newExample, category: newCategory)
                            newFront = ""
                            newBack = ""
                            newExample = ""
                            newCategory = "Geral"
                            showAddCard = false
                        }
                    }) {
                        Text("Adicionar Flashcard")
                            .fontWeight(.bold)
                    }
                    .disabled(newFront.isEmpty || newBack.isEmpty)
                }
            }
            .navigationTitle("Novo Flashcard")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancelar") {
                        showAddCard = false
                    }
                }
            }
        }
    }
}

extension FlashcardManager.Rating {
    var icon: String {
        switch self {
        case .again: return "arrow.counterclockwise"
        case .hard: return "face.frown"
        case .good: return "face.smiling"
        case .easy: return "star.fill"
        }
    }
}

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

// MARK: - Progress & Statistics View
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

#Preview {
    ContentView()
}
