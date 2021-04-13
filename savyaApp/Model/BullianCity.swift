//
//  BullianCity.swift
//  savyaApp
//
//  Created by Yash on 5/9/20.
//  Copyright © 2020 Yash Rathod. All rights reserved.
//

import Foundation


class BullianCity {
    let id: Int
    let city: String
    let stateID: Int
    let metropolitan, image: String
    let status: Int
    let createdAt, updatedAt: String

    init(id: Int, city: String, stateID: Int, metropolitan: String, image: String, status: Int, createdAt: String, updatedAt: String) {
        self.id = id
        self.city = city
        self.stateID = stateID
        self.metropolitan = metropolitan
        self.image = image
        self.status = status
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
