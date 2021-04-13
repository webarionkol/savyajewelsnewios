//
//  Files.swift
//  savyaApp
//
//  Created by Yash on 5/4/20.
//  Copyright © 2020 Yash Rathod. All rights reserved.
//

import Foundation

// MARK: - Files
class Files {
    let id: Int
    let productID, thumbnail:String,image: String
    let type: Int
    let createdAt, updatedAt: String

    init(id: Int, productID: String, image: String, type: Int, createdAt: String, updatedAt: String,thumbnail:String) {
        self.id = id
        self.productID = productID
        self.image = image
        self.type = type
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.thumbnail = thumbnail
    }
}

