//
//  PriceNew.swift
//  savyaApp
//
//  Created by Yash on 5/5/20.
//  Copyright © 2020 Yash Rathod. All rights reserved.
//


import Foundation

// MARK: - PriceNew
class PriceNew {
    let id: Int
    let metrialType, userID, type, price: String
    let valueIn, createdAt, updatedAt: String

    init(id: Int, metrialType: String, userID: String, type: String, price: String, valueIn: String, createdAt: String, updatedAt: String) {
        self.id = id
        self.metrialType = metrialType
        self.userID = userID
        self.type = type
        self.price = price
        self.valueIn = valueIn
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

