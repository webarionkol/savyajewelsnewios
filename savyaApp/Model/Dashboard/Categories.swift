//
//  Categories.swift
//  savyaApp
//
//  Created by Yash on 7/16/20.
//  Copyright © 2020 Yash Rathod. All rights reserved.
//

import Foundation

// MARK: - Categories
class Categories {
    var id: Int
    var category, categoriesDescription, image, menuID: String
    var status, createdAt: String
    var updatedAt,tranding_banner: String

    init(id: Int, category: String, categoriesDescription: String, image: String, menuID: String, status: String, createdAt: String, updatedAt: String,tranding_banner:String) {
        self.id = id
        self.category = category
        self.categoriesDescription = categoriesDescription
        self.image = image
        self.menuID = menuID
        self.status = status
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.tranding_banner = tranding_banner
    }
}

