//
//  Subcategory.swift
//  savyaApp
//
//  Created by Yash on 2/1/20.
//  Copyright © 2020 Yash Rathod. All rights reserved.
//

import Foundation

// MARK: - Welcome
class SubCategory {
    let id: Int
    let category, subcategory, title, image: String
    let createdAt, updatedAt: String

    init(id: Int, category: String, subcategory: String, title: String, image: String, createdAt: String, updatedAt: String) {
        self.id = id
        self.category = category
        self.subcategory = subcategory
        self.title = title
        self.image = image
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
