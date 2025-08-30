//
//  UtensilListView.swift
//  KitchenUtensils
//
//  Created by Monica Kennedy on 2025-08-30.
//

import SwiftUI
import SwiftData

struct UtensilListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \KitchenUtensilModel.createdAt, order: .reverse) private var utensils: [KitchenUtensilModel]
    
    @State private var showingAddView = false
    
    var body: some View {
        NavigationView {
            Group {
                if utensils.isEmpty {
                    ContentUnavailableView(
                        "No Utensils",
                        systemImage: "fork.knife",
                        description: Text("Tap the + button to add your first kitchen utensil")
                    )
                } else {
                    List {
                        ForEach(utensils) { utensil in
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
                }
            }
            .navigationTitle("Kitchen Utensils")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddView = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                
            }
            .sheet(isPresented: $showingAddView) {
                AddNewUtensilsView()
            }
        }
    }
    

}
#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: KitchenUtensilModel.self, configurations: config)
    
    let sampleUtensil = KitchenUtensilModel(name: "Sample Utensil")
    container.mainContext.insert(sampleUtensil)
    
    return UtensilListView()
        .modelContainer(container)
}

#Preview("Empty State") {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: KitchenUtensilModel.self, configurations: config)
    
    return UtensilListView()
        .modelContainer(container)
}
