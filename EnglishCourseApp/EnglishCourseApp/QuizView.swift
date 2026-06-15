//
//  QuizView.swift
//  EnglishCourseApp
//
//  View de Quiz extraída do ContentView
//

import SwiftUI

struct QuizView: View {
    @State private var currentQuestion = 0
    @State private var score = 0
    @State private var showResult = false
    
    var body: some View {
        VStack(spacing: 20) {
            if !showResult {
                Text("Quiz de Inglês")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text(quizQuestions[currentQuestion].question)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding()
                
                ForEach(0..<quizQuestions[currentQuestion].options.count, id: \.self) { index in
                    Button(action: {
                        checkAnswer(index)
                    }) {
                        Text(quizQuestions[currentQuestion].options[index])
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                
                Text("Questão \(currentQuestion + 1) de \(quizQuestions.count)")
                    .foregroundColor(.gray)
            } else {
                VStack(spacing: 20) {
                    Text("Resultado")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Você acertou \(score) de \(quizQuestions.count)")
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
        if selected == quizQuestions[currentQuestion].correctIndex {
            score += 1
        }
        
        if currentQuestion < quizQuestions.count - 1 {
            currentQuestion += 1
        } else {
            showResult = true
            // Adicionar XP baseado no desempenho
            let xpEarned = score * 10
            ProgressManager.shared.addXP(xpEarned, type: .quiz)
        }
    }
}