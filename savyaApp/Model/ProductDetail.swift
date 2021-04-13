//
//  ProductDetail.swift
//  savyaApp
//
//  Created by Yash on 6/7/20.
//  Copyright © 2020 Yash Rathod. All rights reserved.
//

import Foundation

// MARK: - ProductDetail
class ProductDetail {
    var data: DataClass
    var certification: [pdCertification]
    var recentProduct: [RecentProduct]
    var manufacture: Manufacture
    var assets: [pdAsset]
    var files: [Files]
    var price: Price
    var url, manufactureURL: String
    var status: Int
    var product_category : String

    init(data: DataClass, certification: [pdCertification], recentProduct: [RecentProduct], manufacture: Manufacture, assets: [pdAsset], files: [Files], price: Price, url: String, manufactureURL: String, status: Int,product_category:String) {
        self.data = data
        self.certification = certification
        self.recentProduct = recentProduct
        self.manufacture = manufacture
        self.assets = assets
        self.files = files
        self.price = price
        self.url = url
        self.manufactureURL = manufactureURL
        self.status = status
        self.product_category = product_category
    }
}

// MARK: - Asset
class pdAsset {
    var id: Int
    var metrialType, productID, jwellerySize: String
    var diamondIndex, stoneIndex, multiWeight, purity: String
    var weight: String
    var wastage: String
    var quantity: String
    var color, clarity, defaultColorClarity: String
    var makingCharge, chargesOption: String
    var crtcostOption: String
    var certificationCost, meenacostOption, meenaCost, createdAt: String
    var updatedAt: String

    init(id: Int, metrialType: String, productID: String, jwellerySize: String, diamondIndex: String, stoneIndex: String, multiWeight: String, purity: String, weight: String, wastage: String, quantity: String, color: String, clarity: String, defaultColorClarity: String, makingCharge: String, chargesOption: String, crtcostOption: String, certificationCost: String, meenacostOption: String, meenaCost: String, createdAt: String, updatedAt: String) {
        self.id = id
        self.metrialType = metrialType
        self.productID = productID
        self.jwellerySize = jwellerySize
        self.diamondIndex = diamondIndex
        self.stoneIndex = stoneIndex
        self.multiWeight = multiWeight
        self.purity = purity
        self.weight = weight
        self.wastage = wastage
        self.quantity = quantity
        self.color = color
        self.clarity = clarity
        self.defaultColorClarity = defaultColorClarity
        self.makingCharge = makingCharge
        self.chargesOption = chargesOption
        self.crtcostOption = crtcostOption
        self.certificationCost = certificationCost
        self.meenacostOption = meenacostOption
        self.meenaCost = meenaCost
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

enum MetrialType {
    case diamond
    case gold
    case platinum
    case silver
    case stone
}

// MARK: - Certification
class pdCertification {
    var id: Int
    var certiName, image, createdAt: String
    var updatedAt: String

    init(id: Int, certiName: String, image: String, createdAt: String, updatedAt: String) {
        self.id = id
        self.certiName = certiName
        self.image = image
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

// MARK: - DataClass
class DataClass {
    var id: Int
    var categoryID, subcategoryID, subsubcategoryID, productcode: String
    var productname, gender, color, jwelleryType: String
    var defaultSize, sizeType, dataDescription, manufactureID: String
    var manufactureType: Int
    var certifiedID, amount, image: String
    var status, mostSellingStatus: Int
    var createdAt, updatedAt: String
    var delivery_time :String

    init(id: Int, categoryID: String, subcategoryID: String, subsubcategoryID: String, productcode: String, productname: String, gender: String, color: String, jwelleryType: String, defaultSize: String, sizeType: String, dataDescription: String, manufactureID: String, manufactureType: Int, certifiedID: String, amount: String, image: String, status: Int, mostSellingStatus: Int, createdAt: String, updatedAt: String,delivery_time:String) {
        self.id = id
        self.categoryID = categoryID
        self.subcategoryID = subcategoryID
        self.subsubcategoryID = subsubcategoryID
        self.productcode = productcode
        self.productname = productname
        self.gender = gender
        self.color = color
        self.jwelleryType = jwelleryType
        self.defaultSize = defaultSize
        self.sizeType = sizeType
        self.dataDescription = dataDescription
        self.manufactureID = manufactureID
        self.manufactureType = manufactureType
        self.certifiedID = certifiedID
        self.amount = amount
        self.image = image
        self.status = status
        self.mostSellingStatus = mostSellingStatus
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.delivery_time = delivery_time
    }
}

// MARK: - File
class File {
    var id: Int
    var productID, image: String
    var type: Int
    var createdAt, updatedAt: String

    init(id: Int, productID: String, image: String, type: Int, createdAt: String, updatedAt: String) {
        self.id = id
        self.productID = productID
        self.image = image
        self.type = type
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

// MARK: - Manufacture
class Manufacture {
    var companyName: String
    var manufactureID: Int
    var logo: String

    init(companyName: String, manufactureID: Int, logo: String) {
        self.companyName = companyName
        self.manufactureID = manufactureID
        self.logo = logo
    }
}

// MARK: - Price
class Price {
    var silver, stone: [pdDiamondMaster]
    var ring: [Ring]
    var chain: [Chain]
    var bangle: [Bangle]
    var platinum, gold: [pdDiamondMaster]
    var jwelleryType: [JwelleryType]
    var diamondcolor, diamondclarity: [Diamondc]
    var diamondMaster: [pdDiamondMaster]

    init(silver: [pdDiamondMaster], stone: [pdDiamondMaster], ring: [Ring], chain: [Chain], bangle: [Bangle], platinum: [pdDiamondMaster], gold: [pdDiamondMaster], jwelleryType: [JwelleryType], diamondcolor: [Diamondc], diamondclarity: [Diamondc], diamondMaster: [pdDiamondMaster]) {
        self.silver = silver
        self.stone = stone
        self.ring = ring
        self.chain = chain
        self.bangle = bangle
        self.platinum = platinum
        self.gold = gold
        self.jwelleryType = jwelleryType
        self.diamondcolor = diamondcolor
        self.diamondclarity = diamondclarity
        self.diamondMaster = diamondMaster
    }
}

// MARK: - Bangle
class Bangle {
    var id: Int
    var jwelleryType, sizes, bangleSize, createdAt: String

    init(id: Int, jwelleryType: String, sizes: String, bangleSize: String, createdAt: String) {
        self.id = id
        self.jwelleryType = jwelleryType
        self.sizes = sizes
        self.bangleSize = bangleSize
        self.createdAt = createdAt
    }
}

// MARK: - DiamondMaster
class pdDiamondMaster {
    var id: Int
    var metrialType: String
    var userID, type, price, valueIn,diamond_type: String
    var createdAt, updatedAt: String

    init(id: Int, metrialType: String, userID: String, type: String, price: String, valueIn: String, createdAt: String, updatedAt: String,diamond_type:String) {
        self.id = id
        self.metrialType = metrialType
        self.userID = userID
        self.type = type
        self.price = price
        self.valueIn = valueIn
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.diamond_type = diamond_type
    }
}

// MARK: - Diamondc
class Diamondc {
    var id: Int
    var type: String
    var colorOrClarity: String

    init(id: Int, type: String, colorOrClarity: String) {
        self.id = id
        self.type = type
        self.colorOrClarity = colorOrClarity
    }
}

enum TypeEnum {
    case clarity
    case color
}

// MARK: - JwelleryType
class JwelleryType {
    var id: Int
    var jwelleryName: String

    init(id: Int, jwelleryName: String) {
        self.id = id
        self.jwelleryName = jwelleryName
    }
}

// MARK: - Ring
class Ring {
    var sizes: String

    init(sizes: String) {
        self.sizes = sizes
    }
}

// MARK: - RecentProduct
class RecentProduct {
    var productID: Int
    var productName, productcode, amount, image,product_category: String
    var quality, weight: [String:Any]

    init(productID: Int, productName: String, productcode: String, amount: String, image: String, quality: [String:Any], weight: [String:Any],product_category:String) {
        self.productID = productID
        self.productName = productName
        self.productcode = productcode
        self.amount = amount
        self.image = image
        self.quality = quality
        self.weight = weight
        self.product_category = product_category
        
    }
}


class RingSizeClass {
    
    var sizeset:minMax
    var percent:Int
    
    init(sizeset:minMax,percent:Int) {
        self.sizeset = sizeset
        self.percent = percent
    }
}


class minMax {
    
    var minSize:Int
    var maxSize:Int
    
    init(minSize:Int,maxSize:Int) {
        self.minSize = minSize
        self.maxSize = maxSize
    }
}


// MARK: - Chain
class Chain {
    var id: Int
    var jwelleryType, sizes: String
    var bangleSize: String
    var createdAt: String

    init(id: Int, jwelleryType: String, sizes: String, bangleSize: String, createdAt: String) {
        self.id = id
        self.jwelleryType = jwelleryType
        self.sizes = sizes
        self.bangleSize = bangleSize
        self.createdAt = createdAt
    }
}
