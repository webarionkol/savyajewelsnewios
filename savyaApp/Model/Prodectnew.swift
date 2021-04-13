//
//  Prodectnew.swift
//  savyaApp
//
//  Created by Yash on 5/8/20.
//  Copyright © 2020 Yash Rathod. All rights reserved.
//

import Foundation


class Prodectnew {
    let productID: Int
    let productName, productcode, amount, image: String
    let quality, weight: String

    init(productID: Int, productName: String, productcode: String, amount: String, image: String, quality: String, weight: String) {
        self.productID = productID
        self.productName = productName
        self.productcode = productcode
        self.amount = amount
        self.image = image
        self.quality = quality
        self.weight = weight
    }
}
