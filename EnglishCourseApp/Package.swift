// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EnglishCourseApp",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "EnglishCourseApp",
            targets: ["EnglishCourseApp"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "EnglishCourseApp",
            dependencies: [],
            path: "EnglishCourseApp",
            sources: [
                "EnglishCourseAppApp.swift",
                "ContentView.swift",
                "LessonView.swift",
                "VocabularyView.swift",
                "QuizView.swift",
                "SettingsView.swift",
                "PronunciationPracticeView.swift",
                "FlashcardView.swift",
                "ProgressView.swift",
                "UIComponents.swift",
                "CourseData.swift",
                "SpeechRecognizer.swift",
                "ProgressManager.swift",
                "FlashcardManager.swift"
            ]
        ),
        .testTarget(
            name: "EnglishCourseAppTests",
            dependencies: ["EnglishCourseApp"],
            path: "Tests"
        )
    ]
)