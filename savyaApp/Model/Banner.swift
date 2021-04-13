//
//  Banner.swift
//  savyaApp
//
//  Created by Yash on 5/8/20.
//  Copyright © 2020 Yash Rathod. All rights reserved.
//

import Foundation


// MARK: - Banner
class Banner {
    let id: Int
    let userID, title, type, place: String
    let startDate, endDate, categoryID, subcategoryID: String
    let subsubcategoryID: String
    let image, status, createdAt, updatedAt: String

    init(id: Int, userID: String, title: String, type: String, place: String, startDate: String, endDate: String, categoryID: String, subcategoryID: String, subsubcategoryID: String, image: String, status: String, createdAt: String, updatedAt: String) {
        self.id = id
        self.userID = userID
        self.title = title
        self.type = type
        self.place = place
        self.startDate = startDate
        self.endDate = endDate
        self.categoryID = categoryID
        self.subcategoryID = subcategoryID
        self.subsubcategoryID = subsubcategoryID
        self.image = image
        self.status = status
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
