//
//  Cart.swift
//  savyaApp
//
//  Created by Yash on 12/29/19.
//  Copyright © 2019 Yash Rathod. All rights reserved.
//

import Foundation
import RealmSwift

class Cart:NSObject {
    
    let cartID: Int
    var count, productID, userID, category: String
    let subCategory, subSubCategory, productCode, productName: String
    var welcomeDescription, productType, productTotal, totalMakingCharge: String
    let image: String
    let assets: [Asset]!
    let manufacture_limit : String
    let manufacture_name : String
    let product_size : String
    let default_size : String
    var size: Int = 0
    var color : String = ""
   

    init(cartID: Int, count: String, productID: String, userID: String, category: String, subCategory: String, subSubCategory: String, productCode: String, productName: String, welcomeDescription: String, productType: String, productTotal: String, totalMakingCharge: String, image: String,assets:[Asset],manufacture_limit:String,manufacture_name:String,product_size : String,default_size : String, size: Int = 0, color: String = "") {
        self.cartID = cartID
           self.count = count
           self.productID = productID
           self.userID = userID
           self.category = category
           self.subCategory = subCategory
           self.subSubCategory = subSubCategory
           self.productCode = productCode
           self.productName = productName
           self.welcomeDescription = welcomeDescription
           self.productType = productType
           self.productTotal = productTotal
           self.totalMakingCharge = totalMakingCharge
           self.image = image
            self.assets = assets
        self.manufacture_limit = manufacture_limit
        self.manufacture_name = manufacture_name
        self.default_size = default_size
       self.product_size = product_size
        self.size = size
        self.color = color
       }
    
}


class Asset:NSObject {
    
    var id = 0
    var weight = ""
    var materialType = ""
    var makingCharge = ""
    var options = ""
    var metal = ""
    var product_id = ""
    var product_size = ""
    var cart_id = ""
    var wastage = ""
    var diamondType = ""
    var purity = ""
   var certification_cost = ""
   var crtcost_option = ""
   var diamond_index = ""
   var meena_cost = ""
   var meenacost_option = ""
   var selectedColor = ""
   var stone_index = ""
   var stoneType = ""
    
    
    init(id:Int,weight:String,materialType:String,makingCharge:String,options:String,metal:String,product_id:String,cart_id:String,wastage:String,diamondType:String,purity:String,certification_cost:String,crtcost_option:String,diamond_index:String,meena_cost:String,meenacost_option:String,product_size:String,selectedColor:String,stone_index:String,stoneType:String) {
        self.id = id
        self.weight = weight
        self.materialType = materialType
        self.makingCharge = makingCharge
        self.options = options
        self.metal = metal
        self.product_id = product_id
        self.cart_id = cart_id
        self.wastage = wastage
        self.diamondType = diamondType
        self.purity = purity
        self.certification_cost = certification_cost
        self.crtcost_option = crtcost_option
        self.diamond_index = diamond_index
        self.meena_cost = meena_cost
        self.meenacost_option = meenacost_option
        self.selectedColor = selectedColor
        self.stone_index = stone_index
        self.stoneType = stoneType
        self.product_size = product_size
    }
}


class AssetR:Object {
    
    @objc dynamic var id = 0
    @objc dynamic var weight = ""
    @objc dynamic var materialType = ""
    @objc dynamic var makingCharge = ""
    @objc dynamic var options = ""
    @objc dynamic var metal = ""
    @objc dynamic var product_id = ""
    @objc dynamic var cart_id = ""
    
    
}

class CartR:Object {
    
    @objc dynamic var id = 0
    @objc dynamic var cartID = 0
    @objc dynamic var count = ""
    @objc dynamic var productID = ""
    @objc dynamic var userID = ""
    @objc dynamic var category = ""
    @objc dynamic var subCategory = ""
    @objc dynamic var subSubCategory = ""
    @objc dynamic var productCode = ""
    @objc dynamic var productName = ""
    @objc dynamic var welcomeDescription = ""
    @objc dynamic var productType = ""
    @objc dynamic var productTotal = ""
    @objc dynamic var totalMakingCharge = ""
    @objc dynamic var image = ""
    var assets = RealmSwift.List<AssetR>()

    override static func primaryKey() -> String {
        return "id"
    }
    func incrementID() -> Int {
        let realm = try! Realm()
        return (realm.objects(CartR.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
}
