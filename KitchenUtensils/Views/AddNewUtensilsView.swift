//
//  AddNewUtensilsView.swift
//  KitchenUtensils
//
//  Created by Monica Kennedy on 2025-08-30.
//

import SwiftUI
import PhotosUI
import SwiftData

struct AddNewUtensilsView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: AddUtensilViewModel
    
    init(modelContext: ModelContext) {
        _viewModel = StateObject(wrappedValue: AddUtensilViewModel(modelContext: modelContext))
    }
    
    var body: some View {
        NavigationView {
            Form {
                nameSection
                photoSection
            }
            .navigationTitle("Add Utensil")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { toolbarContent }
            .alert("Error", isPresented: $viewModel.showingError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.errorMessage)
            }
        }
    }
    
    private var nameSection: some View {
        Section {
            TextField("Utensil Name", text: $viewModel.name)
                .textInputAutocapitalization(.words)
        } header: {
            Text("Name")
        }
    }
    
    private var photoSection: some View {
        Section {
            PhotosPicker(selection: $viewModel.selectedItem, matching: .images) {
                photoPickerContent
            }
            .onChange(of: viewModel.selectedItem) { oldItem, newItem in
                Task {
                    await viewModel.handlePhotoSelection(newItem)
                }
            }
        } header: {
            Text("Photo")
        }
    }
    
    private var photoPickerContent: some View {
        Group {
            if let selectedImageData = viewModel.selectedImageData,
               let uiImage = UIImage(data: selectedImageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                VStack {
                    Image(systemName: "photo.badge.plus")
                        .font(.system(size: 40))
                        .foregroundColor(.blue)
                    Text("Select Photo")
                        .font(.headline)
                }
                .frame(height: 200)
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }
    
    private var toolbarContent: some ToolbarContent {
        Group {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    saveUtensil()
                }
                .disabled(!viewModel.validateForm())
            }
        }
    }
    
    private func saveUtensil() {
        do {
            try viewModel.saveUtensil()
            dismiss()
        } catch let error as AddUtensilError {
            viewModel.errorMessage = error.errorDescription ?? "Unknown error"
            viewModel.showingError = true
        } catch {
            viewModel.errorMessage = "Failed to save utensil: \(error.localizedDescription)"
            viewModel.showingError = true
        }
    }
}
#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: KitchenUtensilModel.self, configurations: config)
    
    return AddNewUtensilsView(modelContext: container.mainContext)
}
