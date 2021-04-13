//
//  Category.swift
//  savyaApp
//
//  Created by Yash on 2/1/20.
//  Copyright © 2020 Yash Rathod. All rights reserved.
//

import Foundation

// MARK: - Welcome
class Category {
   let id: Int
    let subcategory, categoryID, subCategoryDescription, image: String
    let status, createdAt, updatedAt: String

    init(id: Int, subcategory: String, categoryID: String, subCategoryDescription: String, image: String, status: String, createdAt: String, updatedAt: String) {
        self.id = id
        self.subcategory = subcategory
        self.categoryID = categoryID
        self.subCategoryDescription = subCategoryDescription
        self.image = image
        self.status = status
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

