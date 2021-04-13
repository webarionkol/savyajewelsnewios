//
//  Partner.swift
//  savyaApp
//
//  Created by Yash on 6/22/20.
//  Copyright © 2020 Yash Rathod. All rights reserved.
//

import Foundation

// MARK: - Partner
class Partner {
    var id: Int
    var title, image, status, createdAt: String
    var updatedAt: String

    init(id: Int, title: String, image: String, status: String, createdAt: String, updatedAt: String) {
        self.id = id
        self.title = title
        self.image = image
        self.status = status
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
