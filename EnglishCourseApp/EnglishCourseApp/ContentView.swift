//
//  ContentView.swift
//  EnglishCourseApp
//
//  View principal do app - composta por componentes menores
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Módulos do Curso")) {
                    ForEach(courseModules) { module in
                        ModuleRowView(module: module)
                    }
                }
                
                Section(header: Text("Recursos")) {
                    ForEach(menuResources) { resource in
                        ResourceRowView(resource: resource)
                    }
                }
            }
            .navigationTitle("Curso de Inglês")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    ContentView()
}