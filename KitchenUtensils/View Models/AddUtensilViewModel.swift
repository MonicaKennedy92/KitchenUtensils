//
//  AddUtensilViewModel.swift
//  KitchenUtensils
//
//  Created by Monica Kennedy on 2025-08-30.
//

import SwiftUI
import PhotosUI
import SwiftData

@MainActor
final class AddUtensilViewModel: ObservableObject {
    @Published var name = ""
    @Published var selectedItem: PhotosPickerItem?
    @Published var selectedImageData: Data?
    @Published var showingError = false
    @Published var errorMessage = ""
    
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func saveUtensil() throws {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedName.isEmpty else {
            throw AddUtensilError.emptyName
        }
        
        guard selectedImageData != nil else {
            throw AddUtensilError.noPhotoSelected
        }
        
        let utensil = KitchenUtensilModel(
            name: trimmedName,
            imageData: selectedImageData
        )
        
        modelContext.insert(utensil)
        try modelContext.save()
    }
    
    func handlePhotoSelection(_ newItem: PhotosPickerItem?) async {
        guard let newItem = newItem else {
            selectedImageData = nil
            return
        }
        
        do {
            if let data = try await newItem.loadTransferable(type: Data.self) {
                await MainActor.run {
                    selectedImageData = data
                }
            }
        } catch {
            await MainActor.run {
                errorMessage = "Failed to load image: \(error.localizedDescription)"
                showingError = true
            }
        }
    }
    
    func validateForm() -> Bool {
        return !name.isEmpty && selectedImageData != nil
    }
}

enum AddUtensilError: LocalizedError {
    case emptyName
    case noPhotoSelected
    
    var errorDescription: String? {
        switch self {
        case .emptyName:
            return "Please enter a name for the utensil"
        case .noPhotoSelected:
            return "Please select a photo"
        }
    }
}
