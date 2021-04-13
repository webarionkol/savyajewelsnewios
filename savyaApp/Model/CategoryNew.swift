//
//  CategoryNew.swift
//  savyaApp
//
//  Created by Yash on 5/8/20.
//  Copyright © 2020 Yash Rathod. All rights reserved.
//

import Foundation

// MARK: - Category
class CategoryNew {
    let id: Int
    let category, categoryDescription, image, menuID: String
    let status, createdAt: String
    

    init(id: Int, category: String, categoryDescription: String, image: String, menuID: String, status: String, createdAt: String) {
        self.id = id
        self.category = category
        self.categoryDescription = categoryDescription
        self.image = image
        self.menuID = menuID
        self.status = status
        self.createdAt = createdAt
        
    }
}
