//
//  Product.swift
//  savyaApp
//
//  Created by Yash on 9/19/19.
//  Copyright © 2019 Yash Rathod. All rights reserved.
//

import Foundation
import Alamofire

class Product:NSObject {
    
    var id:Int!
    var imgs:String!
    var name:String!
    var price:String!
    var discountPrice:String!
    var product_category:String
    var size:String!
    var default_size:String!
    var weight:String!
    var quality:String!
    var size_type:String!
    var gold = [Gold]()
    var diamond = [Diamond]()
    var platinum = [Platinum]()
    var stone = [Stone]()
    var silver = [Silver]()
    var details:String!
    var proWeight:[String:Any]
    var proQuality:[String:Any]
    
    init(imgs:String,name:String,price:String,discountPrice:String,size:String,gold:[Gold],diamond:[Diamond],platinum:[Platinum],stone:[Stone],details:String,id:Int,silver:[Silver],weight:String,quality:String,proWeight:[String:Any],proQuality:[String:Any],product_category:String) {
        self.imgs = imgs
        self.name = name
        self.price = price
        self.discountPrice = discountPrice
        self.size = size
        self.gold = gold
        self.diamond = diamond
        self.platinum = platinum
        self.stone = stone
        self.silver = silver
        self.details = details
        self.id = id
        self.weight = weight
        self.quality = quality
        self.proWeight = proWeight
        self.proQuality = proQuality
        self.product_category = product_category
    }
}

 class Gold:NSObject {
    var goldweight:String!
    var goldquality:String!
    var makingcharge:String!
    var option:String!
    
    
    init(goldweight:String,goldquality:String,makingcharge:String,option:String) {
        self.goldweight = goldweight
        self.goldquality = goldquality
        self.makingcharge = makingcharge
        self.option = option
    }
    
}
class Diamond:NSObject {
    var diamond:String!
    var diamondqty:String!
    var no_diamond:String!
    var default_size:String!
    var diamondcolor:String!
    var diamondclarity:String!
    var type:String!
    var diamondcharge:String!
    
    init(diamond:String,diamondqty:String,no_diamond:String,default_size:String,diamondcolor:String,diamondclarity:String,type:String,diamondcharge:String) {
        self.diamond = diamond
        self.diamondqty = diamondqty
        self.no_diamond = no_diamond
        self.default_size = default_size
        self.diamondcolor = diamondcolor
        self.diamondclarity = diamondclarity
        self.type = type
        self.diamondcharge = diamondcharge
    }
    
}
class Platinum:NSObject {
    let id: Int
    let productID, platinumType, platinumQty, wastage: String
    let purity, chargeType, platinumCharge: String

    init(id: Int, productID: String, platinumType: String, platinumQty: String, wastage: String, purity: String, chargeType: String, platinumCharge: String) {
        self.id = id
        self.productID = productID
        self.platinumType = platinumType
        self.platinumQty = platinumQty
        self.wastage = wastage
        self.purity = purity
        self.chargeType = chargeType
        self.platinumCharge = platinumCharge
    }
}

class Stone:NSObject {
    let stoneID, id: Int
    let productID, stonetype, stoneqty, stoneno: String
    let type, stonecharges, createdAt, updatedAt: String

    init(stoneID: Int, id: Int, productID: String, stonetype: String, stoneqty: String, stoneno: String, type: String, stonecharges: String, createdAt: String, updatedAt: String) {
        self.stoneID = stoneID
        self.id = id
        self.productID = productID
        self.stonetype = stonetype
        self.stoneqty = stoneqty
        self.stoneno = stoneno
        self.type = type
        self.stonecharges = stonecharges
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

// MARK: - Welcome
class Silver {
    let id: Int
    let productID, silverType, silverqty, silverno: String
    let chargeType, silvercharges: String

    init(id: Int, productID: String, silverType: String, silverqty: String, silverno: String, chargeType: String, silvercharges: String) {
        self.id = id
        self.productID = productID
        self.silverType = silverType
        self.silverqty = silverqty
        self.silverno = silverno
        self.chargeType = chargeType
        self.silvercharges = silvercharges
    }
}
class productWeight {
    
    var name:String
    var value:String
    
    init(name:String,value:String) {
        self.name = name
        self.value = value
    }
}
class productQuality {
    
    var name:String
    var value:String
    
    init(name:String,value:String) {
        self.name = name
        self.value = value
    }
}
