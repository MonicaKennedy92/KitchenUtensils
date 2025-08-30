//
//  UtensilsListViewModel.swift
//  KitchenUtensils
//
//  Created by Monica Kennedy on 2025-08-30.
//
import SwiftUI
import SwiftData

@MainActor
final class UtensilsListViewModel: ObservableObject {
    @Published private(set) var utensils: [KitchenUtensilModel] = []
    @Published var showingAddView = false
    @Published var showingError = false
    @Published var errorMessage = ""
    
    let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchUtensils()
    }
    
    func fetchUtensils() {
        do {
            let descriptor = FetchDescriptor<KitchenUtensilModel>(
                sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
            )
            utensils = try modelContext.fetch(descriptor)
        } catch {
            handleError(error, message: "Failed to fetch utensils")
        }
    }
    
 
    private func saveContextAndRefresh() {
        do {
            try modelContext.save()
            fetchUtensils()
        } catch {
            handleError(error, message: "Failed to save context")
        }
    }
    
    var isEmpty: Bool {
        utensils.isEmpty
    }
    
    private func handleError(_ error: Error, message: String) {
        errorMessage = "\(message): \(error.localizedDescription)"
        showingError = true
    }
}
