//
//  KitchenUtensilModel.swift
//  KitchenUtensils
//
//  Created by Monica Kennedy on 2025-08-30.
//


import SwiftUI
import SwiftData
import PhotosUI

@Model
final class KitchenUtensilModel {
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
    
    var image: Image? {
        guard let imageData = imageData,
              let uiImage = UIImage(data: imageData) else {
            return nil
        }
        return Image(uiImage: uiImage)
    }
}
