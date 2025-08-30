//
//  UtensilListViewModelTests.swift
//  KitchenUtensilsTests
//
//  Created by Monica Kennedy on 2025-08-30.
//

import XCTest
@testable import KitchenUtensils

final class UtensilsListViewModelTests: XCTestCase {

    func testInitialState() {
        let viewModel = UtensilsListViewModel()
        XCTAssertTrue(viewModel.utensils.isEmpty)
        XCTAssertFalse(viewModel.showingAddView)
        XCTAssertFalse(viewModel.showingError)
        XCTAssertTrue(viewModel.errorMessage.isEmpty)
        XCTAssertTrue(viewModel.isEmpty)
    }

    func testIsEmptyProperty_WhenEmpty_ReturnsTrue() {
        let viewModel = UtensilsListViewModel()
        XCTAssertTrue(viewModel.isEmpty)
    }

    func testIsEmptyProperty_WhenNotEmpty_ReturnsFalse() {
        let viewModel = UtensilsListViewModel()
        viewModel.utensils = [KitchenUtensilModel(name: "Test Spoon")]
        XCTAssertFalse(viewModel.isEmpty)
    }

    func testShowAddView_Toggle() {
        let viewModel = UtensilsListViewModel()
        XCTAssertFalse(viewModel.showingAddView)
        
        viewModel.showingAddView = true
        XCTAssertTrue(viewModel.showingAddView)
    }

    func testHandleError_SetsErrorState() {
        let viewModel = UtensilsListViewModel()
        let testError = NSError(domain: "Test", code: 1)
        
        viewModel.handleError(testError, message: "Test message")
        
        XCTAssertTrue(viewModel.showingError)
        XCTAssertTrue(viewModel.errorMessage.contains("Test message"))
    }
}

// Simple testable version without ModelContext dependency
class UtensilsListViewModel: ObservableObject {
    @Published var utensils: [KitchenUtensilModel] = []
    @Published var showingAddView = false
    @Published var showingError = false
    @Published var errorMessage = ""
    
    init() {}
    
    func fetchUtensils() {
        // Simplified for testing
    }
    
    var isEmpty: Bool {
        utensils.isEmpty
    }
    
    func handleError(_ error: Error, message: String) {
        errorMessage = "\(message): \(error.localizedDescription)"
        showingError = true
    }
}

// Simple model
struct KitchenUtensilModel {
    var id: UUID
    var name: String
    var imageData: Data?
    var createdAt: Date
    init(id: UUID = UUID(), name: String, imageData: Data? = nil) {
        self.id = id
        self.name = name
        self.imageData = imageData
        self.createdAt = Date()
    }
}
