//
//  PronunciationPracticeView.swift
//  EnglishCourseApp
//
//  View de Prática de Pronúncia extraída do ContentView
//

import SwiftUI

struct PronunciationPracticeView: View {
    @StateObject private var speechRecognizer = SpeechRecognizer()
    @State private var selectedPhrase = ""
    @State private var showingPermissionAlert = false
    
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
                    ForEach(practicePhrases) { phrase in
                        Button(action: {
                            selectedPhrase = phrase.text
                            speechRecognizer.reset()
                        }) {
                            Text(phrase.text)
                                .font(.caption)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(selectedPhrase == phrase.text ? Color.blue : Color.gray.opacity(0.2))
                                .foregroundColor(selectedPhrase == phrase.text ? .white : .primary)
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
                    
                    ForEach(pronunciationTips, id: \.self) { tip in
                        Text("• \(tip)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
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
}