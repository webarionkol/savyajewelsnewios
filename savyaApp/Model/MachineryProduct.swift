//
//  MachineryProduct.swift
//  savyaApp
//
//  Created by Yash on 7/2/20.
//  Copyright © 2020 Yash Rathod. All rights reserved.
//

import Foundation


// MARK: - MachineryProduct
class MachineryProduct {
    var productID: Int
    var productName, productcode: String
    var amount: String
    var image: String

    init(productID: Int, productName: String, productcode: String, amount: String, image: String) {
        self.productID = productID
        self.productName = productName
        self.productcode = productcode
        self.amount = amount
        self.image = image
    }
}


// MARK: - MachineryDetail
class MachineryDetail {
    var id: Int
    var categoryID, subcategoryID, productName, productcode: String
    var amount, image, machineryDetailDescription: String
    var status: Int
    var createdAt, updatedAt: String

    init(id: Int, categoryID: String, subcategoryID: String, productName: String, productcode: String, amount: String, image: String, machineryDetailDescription: String, status: Int, createdAt: String, updatedAt: String) {
        self.id = id
        self.categoryID = categoryID
        self.subcategoryID = subcategoryID
        self.productName = productName
        self.productcode = productcode
        self.amount = amount
        self.image = image
        self.machineryDetailDescription = machineryDetailDescription
        self.status = status
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
// MARK: - Manufacturer
class Manufacturer {
    var companyName: String
    var manufactureID: Int
    var logo: String

    init(companyName: String, manufactureID: Int, logo: String) {
        self.companyName = companyName
        self.manufactureID = manufactureID
        self.logo = logo
    }
}
