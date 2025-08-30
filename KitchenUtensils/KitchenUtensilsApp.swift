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
            UtensilListView()
                .modelContainer(for: KitchenUtensilModel.self)
        }
    }
}
