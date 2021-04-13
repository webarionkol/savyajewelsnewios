//
//  Certification.swift
//  savyaApp
//
//  Created by Yash on 5/7/20.
//  Copyright © 2020 Yash Rathod. All rights reserved.
//

import Foundation

// MARK: - PriceNew
class Certification {
    let id: Int
    let certiName, image, createdAt: String
    let updatedAt: NSNull

    init(id: Int, certiName: String, image: String, createdAt: String, updatedAt: NSNull) {
        self.id = id
        self.certiName = certiName
        self.image = image
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

