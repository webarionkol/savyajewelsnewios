//
//  WishListProduct.swift
//  savyaApp
//
//  Created by Yash on 12/30/19.
//  Copyright © 2019 Yash Rathod. All rights reserved.
//

import Foundation
import RealmSwift

class WishListProduct:Object {
    
    static let sharedInstance = WishListProduct()
    
    @objc dynamic var uid = ""
    @objc dynamic var product_id = ""
    
    
    func getAllFromDB() -> Results<WishListProduct> {
        let realm = try! Realm()
        return realm.objects(WishListProduct.self)
    }
}

// MARK: - Wishlist
class Wishlist {
    let wishlistID, productID: Int
    let productname, size, image, quality: String
    let weight: String

    init(wishlistID: Int, productID: Int, productname: String, size: String, image: String, quality: String, weight: String) {
        self.wishlistID = wishlistID
        self.productID = productID
        self.productname = productname
        self.size = size
        self.image = image
        self.quality = quality
        self.weight = weight
    }
}
