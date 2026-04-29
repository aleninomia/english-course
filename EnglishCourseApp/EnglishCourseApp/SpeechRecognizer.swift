import Foundation
import Speech
import AVFoundation

/// Gerenciador de reconhecimento de fala para prática de pronúncia
class SpeechRecognizer: NSObject, ObservableObject {
    enum RecognizerError: Error {
        case nilRecognizer
        case notAuthorizedToRecognize
        case notPermittedToRecord
        case recognizerIsAvailable
        case unknown
    }
    
    @Published var isRecording = false
    @Published var transcript = ""
    @Published var pronunciationScore: Double = 0.0
    @Published var feedbackMessage = ""
    
    private var audioEngine = AVAudioEngine()
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?
    private var recognizer: SFSpeechRecognizer?
    
    init() {
        setupRecognizer()
    }
    
    private func setupRecognizer() {
        // Verifica se o reconhecedor está disponível para português e inglês
        if SFSpeechRecognizer.hasRequiredAuthorizations() {
            recognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
        }
    }
    
    /// Solicita permissões necessárias
    static func requestAuthorization() async -> Bool {
        guard SFSpeechRecognizer.hasRequiredAuthorizations() else {
            return false
        }
        
        let authStatus = SFSpeechRecognizer.authorizationStatus()
        
        switch authStatus {
        case .authorized:
            return true
        case .denied, .restricted, .notDetermined:
            return await withCheckedContinuation { continuation in
                SFSpeechRecognizer.requestAuthorization { status in
                    continuation.resume(returning: status == .authorized)
                }
            }
        @unknown default:
            return false
        }
    }
    
    /// Inicia o reconhecimento de fala
    func startRecording(expectedPhrase: String) {
        guard !isRecording else { return }
        
        // Configura o pedido de reconhecimento
        request = SFSpeechAudioBufferRecognitionRequest()
        
        guard let recognitionRequest = request else {
            fatalError("Unable to create recognition request")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        // Cria a tarefa de reconhecimento
        guard let recognizer = recognizer else {
            DispatchQueue.main.async {
                self.feedbackMessage = "Reconhecedor não disponível"
            }
            return
        }
        
        task = recognizer.recognitionTask(with: recognitionRequest) { result, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Erro no reconhecimento: \(error)")
                    self.stopRecording()
                    self.feedbackMessage = "Erro ao reconhecer fala"
                    return
                }
                
                if let result = result {
                    self.transcript = result.bestTranscription.formattedString
                    
                    // Calcula pontuação de pronúncia
                    self.calculatePronunciationScore(
                        spokenText: self.transcript,
                        expectedText: expectedPhrase
                    )
                    
                    // Finaliza se houver uma transcrição completa
                    if result.isFinal {
                        self.stopRecording()
                    }
                }
            }
        }
        
        // Configura o engine de áudio
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            
            let inputNode = audioEngine.inputNode
            
            inputNode.installTap(
                onBus: 0,
                bufferSize: 1024,
                format: inputNode.outputFormat(forBus: 0)
            ) { buffer, _ in
                self.request?.append(buffer)
            }
            
            audioEngine.prepare()
            try audioEngine.start()
            
            isRecording = true
            feedbackMessage = "Ouvindo... Fale agora!"
            
        } catch {
            stopRecording()
            feedbackMessage = "Erro ao acessar microfone"
        }
    }
    
    /// Para o reconhecimento de fala
    func stopRecording() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        request = nil
        task?.cancel()
        isRecording = false
    }
    
    /// Calcula a pontuação de pronúncia comparando o texto falado com o esperado
    private func calculatePronunciationScore(spokenText: String, expectedText: String) {
        let spokenLower = spokenText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        let expectedLower = expectedText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Remove pontuação para comparação
        let spokenClean = spokenLower.components(separatedBy: CharacterSet.punctuationCharacters).joined()
        let expectedClean = expectedLower.components(separatedBy: CharacterSet.punctuationCharacters).joined()
        
        // Comparação exata
        if spokenClean == expectedClean {
            pronunciationScore = 100.0
            feedbackMessage = "🎉 Perfeito! Pronúncia excelente!"
            return
        }
        
        // Calcula similaridade usando Levenshtein Distance
        let distance = levenshteinDistance(from: spokenClean, to: expectedClean)
        let maxLength = max(spokenClean.count, expectedClean.count)
        
        if maxLength == 0 {
            pronunciationScore = 0
            feedbackMessage = "Tente novamente!"
            return
        }
        
        let similarity = Double(maxLength - distance) / Double(maxLength)
        pronunciationScore = similarity * 100
        
        // Feedback baseado na pontuação
        if similarity >= 0.8 {
            feedbackMessage = "👍 Muito bom! Continue praticando!"
        } else if similarity >= 0.6 {
            feedbackMessage = "👌 Bom, mas pode melhorar!"
        } else if similarity >= 0.4 {
            feedbackMessage = "📚 Continue tentando!"
        } else {
            feedbackMessage = "💪 Não desista! Tente novamente!"
        }
    }
    
    /// Calcula a distância de Levenshtein entre duas strings
    private func levenshteinDistance(from source: String, to target: String) -> Int {
        let empty = Array(repeating: 0, count: target.count + 1)
        var last = Array(0...target.count)
        
        for (i, sourceChar) in source.enumerated() {
            var current = [i + 1] + empty
            
            for (j, targetChar) in target.enumerated() {
                let cost = sourceChar == targetChar ? 0 : 1
                current[j + 1] = min(
                    current[j] + 1,      // Deleção
                    last[j + 1] + 1,     // Inserção
                    last[j] + cost       // Substituição
                )
            }
            
            last = current
        }
        
        return last.last ?? 0
    }
    
    /// Limpa os dados atuais
    func reset() {
        transcript = ""
        pronunciationScore = 0.0
        feedbackMessage = ""
    }
}

// Extension para verificar autorizações
extension SFSpeechRecognizer {
    static func hasRequiredAuthorizations() -> Bool {
        return true // Assume que as permissões serão solicitadas quando necessário
    }
}
