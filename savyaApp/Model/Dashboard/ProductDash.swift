//
//  ProductDash.swift
//  savyaApp
//
//  Created by Yash on 7/16/20.
//  Copyright © 2020 Yash Rathod. All rights reserved.
//

import Foundation

// MARK: - Product
class ProductDash {
    var productID: Int
    var productName, productCategory, productcode, amount: String
    var image: String
    var quality, weight: [String:Any]

    init(productID: Int, productName: String, productCategory: String, productcode: String, amount: String, image: String, quality: [String:Any], weight: [String:Any]) {
        self.productID = productID
        self.productName = productName
        self.productCategory = productCategory
        self.productcode = productcode
        self.amount = amount
        self.image = image
        self.quality = quality
        self.weight = weight
    }
}



