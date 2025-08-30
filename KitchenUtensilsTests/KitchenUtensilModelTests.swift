//
//  KitchenUtensilModelTests.swift
//  KitchenUtensilsTests
//
//  Created by Monica Kennedy on 2025-08-30.
//

import XCTest
@testable import KitchenUtensils

final class KitchenUtensilModelTests: XCTestCase {

    func testModelCreation() {
        let utensil = KitchenUtensilModel(name: "Test Spoon")
        XCTAssertEqual(utensil.name, "Test Spoon")
        XCTAssertNotNil(utensil.id)
        XCTAssertNotNil(utensil.createdAt)
    }

    func testModelWithImage() {
        let imageData = Data() // Empty data for test
        let utensil = KitchenUtensilModel(name: "Test Fork", imageData: imageData)
        XCTAssertEqual(utensil.name, "Test Fork")
        XCTAssertNotNil(utensil.imageData)
    }

    func testImageProperty() {
        let utensil = KitchenUtensilModel(name: "Test Knife")
        XCTAssertNil(utensil.imageData)
    }
}
