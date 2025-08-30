//
//  KitchenUtensilsApp.swift
//  KitchenUtensils
//
//  Created by Monica Kennedy on 2025-08-30.
//

import SwiftUI
import SwiftData

@main
struct KitchenUtensilsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: KitchenUtensilModel.self)
    }
}

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        UtensilListView(modelContext: modelContext)
    }
}
