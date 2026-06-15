//
//  FlashcardView.swift
//  EnglishCourseApp
//
//  View de Flashcards extraída do ContentView
//

import SwiftUI

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