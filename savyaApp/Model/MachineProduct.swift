//
//  MachineProduct.swift
//  savyaApp
//
//  Created by Yash on 2/23/20.
//  Copyright © 2020 Yash Rathod. All rights reserved.
//

import Foundation

// MARK: - Operatives
class MachineProduct {
    let productID: Int
    let productname, amount, size: String
    let defaultSize: String
    let sizeType, image: String

    init(productID: Int, productname: String, amount: String, size: String, defaultSize: String, sizeType: String, image: String) {
        self.productID = productID
        self.productname = productname
        self.amount = amount
        self.size = size
        self.defaultSize = defaultSize
        self.sizeType = sizeType
        self.image = image
    }
}
