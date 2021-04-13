//
//  SearchPoduct.swift
//  savyaApp
//
//  Created by Yash on 1/18/20.
//  Copyright © 2020 Yash Rathod. All rights reserved.
//

import Foundation

// MARK: - Searchproduct
class Searchproduct {
    let productID: Int
    let productname, amount, productCode, jwelleryType: String
    let defaultSize, sizeType, image: String

    init(productID: Int, productname: String, amount: String, productCode: String, jwelleryType: String, defaultSize: String, sizeType: String, image: String) {
        self.productID = productID
        self.productname = productname
        self.amount = amount
        self.productCode = productCode
        self.jwelleryType = jwelleryType
        self.defaultSize = defaultSize
        self.sizeType = sizeType
        self.image = image
    }
}
class SearchSeller {
    let manufacture_id: Int
    let name, email, description, mobile_no: String
    let company_name, logo: String

    init(manufacture_id: Int, name: String, email: String, description: String, mobile_no: String, company_name: String, logo: String) {
        self.manufacture_id = manufacture_id
        self.name = name
        self.email = email
        self.description = description
        self.mobile_no = mobile_no
        self.company_name = company_name
        self.logo = logo
    }
}
