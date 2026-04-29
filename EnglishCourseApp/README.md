# 🇬🇧 English Course App - Curso de Inglês para iOS

Um aplicativo completo e moderno para aprender inglês, desenvolvido em SwiftUI para iOS 15.0+.

## ✨ Funcionalidades Principais

### 📚 Módulos de Aprendizado
- **Lições Estruturadas**: Básico 1, Básico 2 e Intermediário
- **Vocabulário Essencial**: Palavras comuns com tradução
- **Quiz Interativo**: Teste seus conhecimentos com perguntas múltipla escolha

### 🎯 Recursos Avançados

#### 1. 🎤 Pronúncia com Reconhecimento de Voz
- Grave sua voz e receba feedback instantâneo
- Sistema de pontuação baseado na similaridade com a frase correta
- Algoritmo de Distância de Levenshtein para avaliação precisa
- Dicas personalizadas de pronúncia
- **8 frases práticas** para treinar

#### 2. 📊 Sistema de Progresso e Estatísticas
- **Níveis e XP**: Ganhe experiência a cada atividade completada
- **Streak de Estudos**: Acompanhe dias consecutivos de estudo
- **Gráfico Semanal**: Visualize sua atividade dos últimos 7 dias
- **Estatísticas Detalhadas**:
  - Lições completadas
  - Quizzes realizados
  - Práticas de pronúncia
  - Flashcards revisados
- **Sistema de Conquistas**: 9 badges diferentes para desbloquear
  - Primeiros Passos (primeira lição)
  - Dedicado (7 dias consecutivos)
  - Comprometido (30 dias consecutivos)
  - Mestre do Quiz (10 quizzes)
  - Construtor de Vocabulário (50 flashcards)
  - Pronúncia Perfeita (20 práticas)
  - Nível 5 e Nível 10
  - Mil XP

#### 3. 🃏 Flashcards com Repetição Espaçada
- **Algoritmo SM-2 Simplificado**: Revisão inteligente baseada no seu desempenho
- **20 flashcards pré-carregados** com palavras essenciais
- **Crie seus próprios cards**: Adicione palavras personalizadas
- **Sistema de Avaliação**:
  - 🔴 Revisar (novamente)
  - 🟠 Difícil
  - 🔵 Bom
  - 🟢 Fácil
- **Agendamento Automático**: O app calcula quando revisar cada card
- **Estatísticas da Sessão**: Precisão e total revisado
- **Categorias Organizadas**: Saudações, Expressões, Verbos, Adjetivos, etc.

## 🏗️ Estrutura do Projeto

```
EnglishCourseApp/
├── EnglishCourseApp/
│   ├── EnglishCourseAppApp.swift    # Entry point do app
│   ├── ContentView.swift            # Interface principal + todas as views (1012 linhas)
│   ├── SpeechRecognizer.swift       # Reconhecimento de voz (219 linhas)
│   ├── ProgressManager.swift        # Sistema de progresso e conquistas (258 linhas)
│   ├── FlashcardManager.swift       # Flashcards e repetição espaçada (250 linhas)
│   ├── Info.plist                   # Configurações e permissões
│   └── Assets.xcassets/             # Recursos de imagem
└── README.md                        # Esta documentação
```

**Total: 1,756 linhas de código Swift!**

## 🚀 Como Usar

### Pré-requisitos
- macOS com Xcode 14.0 ou superior
- iOS 15.0+
- Dispositivo físico ou simulador com suporte a microfone (para funcionalidade de pronúncia)

### Passo a Passo

1. **Abrir o Projeto no Xcode**
   ```bash
   cd EnglishCourseApp
   open EnglishCourseApp.xcodeproj
   ```
   *Nota: Se o arquivo .xcodeproj não existir, crie um novo projeto no Xcode:*
   - Abra o Xcode → File → New → Project
   - Escolha "iOS" → "App"
   - Nome: `EnglishCourseApp`
   - Interface: SwiftUI
   - Language: Swift
   - Substitua os arquivos gerados pelos arquivos deste repositório

2. **Configurar Permissões**
   
   O `Info.plist` já inclui as permissões necessárias:
   - `NSSpeechRecognitionUsageDescription`: Para reconhecimento de fala
   - `NSMicrophoneUsageDescription`: Para uso do microfone

3. **Build e Execução**
   - Selecione seu dispositivo ou simulador
   - Pressione `Cmd + R` para rodar

4. **Primeiro Uso**
   - Ao abrir o app pela primeira vez, conceda as permissões de microfone
   - Explore as seções: Módulos, Vocabulário, Quiz, Pronúncia, Flashcards e Progresso

## 📱 Como Funciona Cada Recurso

### Sistema de XP e Níveis
- Cada atividade gera XP:
  - Lição completada: +10 XP
  - Quiz: +10 XP por acerto
  - Flashcard: 1-7 XP dependendo da dificuldade
  - Pronúncia: +5 XP por prática
- A cada 100 XP, você sobe de nível
- Level up automático desbloqueia badges

### Algoritmo de Repetição Espaçada (Flashcards)
O sistema usa uma versão simplificada do algoritmo SM-2:

| Avaliação | Intervalo Próxima Revisão | XP Ganho |
|-----------|--------------------------|----------|
| Revisar   | Imediata                 | 1 XP     |
| Difícil   | Metade do intervalo atual | 3 XP    |
| Bom       | Intervalo × 2.5          | 5 XP     |
| Fácil     | Intervalo × 3.0          | 7 XP     |

**Exemplo:**
- Primeira vez que acerta "Bom": revisa em 1 dia
- Segunda vez "Bom": revisa em 2-3 dias
- Terceira vez "Bom": revisa em 5-7 dias
- E assim por diante...

### Sistema de Streak
- Estuda 1 dia: streak = 1
- Estuda no dia seguinte: streak = 2
- Pula um dia: streak volta para 1
- O recorde (longestStreak) é mantido permanentemente

### Avaliação de Pronúncia
- Usa `SFSpeechRecognizer` da Apple
- Compara texto falado com frase esperada
- Calcula similaridade usando Distância de Levenshtein
- Pontuação:
  - 🟢 80-100%: Excelente
  - 🟡 60-79%: Bom
  - 🟠 <60%: Continue praticando

## 🎨 Design e UX

- **Interface Moderna**: Gradientes, sombras e cantos arredondados
- **Feedback Visual**: Cores indicam desempenho (verde, amarelo, laranja, vermelho)
- **Animações Suaves**: Flip de cards, transições entre telas
- **Ícones SF Symbols**: Ícones nativos do iOS para consistência
- **Responsivo**: Adapta-se a diferentes tamanhos de tela

## 🛠️ Tecnologias Utilizadas

- **SwiftUI**: Framework declarativa para UI
- **SFSpeechRecognizer**: API de reconhecimento de fala
- **AVAudioEngine**: Processamento de áudio
- **UserDefaults**: Persistência local de dados
- **Codable**: Serialização JSON para salvar progresso
- **Combine**: Gerenciamento de estado com @Published e @ObservedObject

## 📈 Próximas Melhorias Sugeridas

- [ ] Modo offline para downloads de lições
- [ ] Sincronização iCloud entre dispositivos
- [ ] Mais exercícios de listening com áudios nativos
- [ ] Chatbot para prática de conversação
- [ ] Modo multiplayer/competitivo
- [ ] Conteúdo intermediário e avançado
- [ ] Estatísticas detalhadas de evolução temporal
- [ ] Notificações push para lembrar de estudar
- [ ] Tema personalizável (cores, fontes)
- [ ] Exportar progresso em PDF

## 📄 Licença

Este projeto é open source e pode ser usado livremente para fins educacionais.

## 👨‍💻 Desenvolvedor

Criado como exemplo de aplicativo educacional completo para iOS usando as melhores práticas de desenvolvimento Swift e SwiftUI.

---

**Divirta-se aprendendo inglês! 🇬🇧🇺🇸**
