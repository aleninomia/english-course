//
//  SettingsView.swift
//  EnglishCourseApp
//
//  View de Configurações extraída do ContentView
//

import SwiftUI

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