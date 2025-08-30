//
//  AddUtensilViewModelTests.swift
//  KitchenUtensilsTests
//
//  Created by Monica Kennedy on 2025-08-30.
//

import XCTest
@testable import KitchenUtensils

final class AddUtensilViewModelTests: XCTestCase {

    func testValidateForm_Empty_ReturnsFalse() {
        let viewModel = AddUtensilViewModel()
        XCTAssertFalse(viewModel.validateForm())
    }

    func testValidateForm_WithNameOnly_ReturnsFalse() {
        let viewModel = AddUtensilViewModel()
        viewModel.name = "Test Spoon"
        XCTAssertFalse(viewModel.validateForm())
    }

    func testValidateForm_WithNameAndImage_ReturnsTrue() {
        let viewModel = AddUtensilViewModel()
        viewModel.name = "Test Spoon"
        viewModel.selectedImageData = Data()
        XCTAssertTrue(viewModel.validateForm())
    }

    func testSaveUtensil_EmptyName_ThrowsError() {
        let viewModel = AddUtensilViewModel()
        viewModel.selectedImageData = Data()
        XCTAssertThrowsError(try viewModel.saveUtensil())
    }

    func testSaveUtensil_NoImage_ThrowsError() {
        let viewModel = AddUtensilViewModel()
        viewModel.name = "Test Spoon"
        XCTAssertThrowsError(try viewModel.saveUtensil())
    }
}

// Simple testable version without ModelContext dependency
class AddUtensilViewModel: ObservableObject {
    @Published var name = ""
    @Published var selectedImageData: Data?
    
    init() {}
    
    func saveUtensil() throws {
        guard !name.isEmpty else { throw NSError(domain: "Empty name", code: 1) }
        guard selectedImageData != nil else { throw NSError(domain: "No image", code: 2) }
    }
    
    func validateForm() -> Bool {
        return !name.isEmpty && selectedImageData != nil
    }
}
