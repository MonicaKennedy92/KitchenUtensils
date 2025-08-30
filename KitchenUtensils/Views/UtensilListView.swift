//
//  UtensilListView.swift
//  KitchenUtensils
//
//  Created by Monica Kennedy on 2025-08-30.
//

import SwiftUI
import SwiftData

struct UtensilListView: View {
    @StateObject private var viewModel: UtensilsListViewModel
    
    init(modelContext: ModelContext) {
        _viewModel = StateObject(wrappedValue: UtensilsListViewModel(modelContext: modelContext))
    }
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isEmpty {
                    emptyStateView
                } else {
                    listView
                }
            }
            .navigationTitle("Kitchen Utensils")
            .toolbar { toolbarContent }
            .sheet(isPresented: $viewModel.showingAddView) {
                AddNewUtensilsView(modelContext: viewModel.modelContext)
                    .onDisappear {
                        viewModel.fetchUtensils()
                    }
            }
            .alert("Error", isPresented: $viewModel.showingError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.errorMessage)
            }
        }
    }
    
    private var emptyStateView: some View {
        ContentUnavailableView(
            "No Utensils",
            systemImage: "fork.knife",
            description: Text("Tap the + button to add your first kitchen utensil")
        )
    }
    
    private var listView: some View {
        List {
            ForEach(viewModel.utensils) { utensil in
                UtensilRowView(utensil: utensil)
            }
        }
    }
    
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                viewModel.showingAddView = true
            } label: {
                Image(systemName: "plus")
            }
        }
    }
}

struct UtensilRowView: View {
    let utensil: KitchenUtensilModel
    
    var body: some View {
        HStack(spacing: 16) {
            if let image = utensil.image {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.gray)
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            Text(utensil.name)
                .font(.headline)
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: KitchenUtensilModel.self, configurations: config)
    
    return UtensilListView(modelContext: container.mainContext)
        .modelContainer(container)
}
