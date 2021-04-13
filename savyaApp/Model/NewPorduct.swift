//
//  NewPorduct.swift
//  savyaApp
//
//  Created by Yash on 9/13/20.
//  Copyright © 2020 Yash Rathod. All rights reserved.
//
import Foundation

// MARK: - Product
class NewProduct {
    var data: NewDataClass
    var productCategory: String
    var certification: [NewCertification]
    var recentProduct: [NewRecentProduct]
    var manufacture: NewManufacture
    var assets: [Asset]
    var files: [File]
    var price: Price
    var url, manufactureURL: String
    var status: Int

    init(data: NewDataClass, productCategory: String, certification: [NewCertification], recentProduct: [NewRecentProduct], manufacture: NewManufacture, assets: [Asset], files: [File], price: Price, url: String, manufactureURL: String, status: Int) {
        self.data = data
        self.productCategory = productCategory
        self.certification = certification
        self.recentProduct = recentProduct
        self.manufacture = manufacture
        self.assets = assets
        self.files = files
        self.price = price
        self.url = url
        self.manufactureURL = manufactureURL
        self.status = status
    }
}

// MARK: - Asset
class NewAsset {
    var id: Int
    var metrialType: MetrialType
    var productID, jwellerySize: String
    var diamondIndex, stoneIndex: Int?
    var multiWeight, purity: String
    var weight: String
    var wastage: String
    var quantity: String
    var color, clarity, defaultColorClarity: String?
    var makingCharge, chargesOption: String
    var crtcostOption: String?
    var certificationCost: String
    var meenacostOption: String?
    var meenaCost, createdAt, updatedAt: String

    init(id: Int, metrialType: MetrialType, productID: String, jwellerySize: String, diamondIndex: Int?, stoneIndex: Int?, multiWeight: String, purity: String, weight: String, wastage: String, quantity: String, color: String?, clarity: String?, defaultColorClarity: String?, makingCharge: String, chargesOption: String, crtcostOption: String?, certificationCost: String, meenacostOption: String?, meenaCost: String, createdAt: String, updatedAt: String) {
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

enum NewMetrialType {
    case diamond
    case gold
    case platinum
    case silver
    case stone
}

// MARK: - Certification
class NewCertification {
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
class NewDataClass {
    var id: Int
    var categoryID, subcategoryID, subsubcategoryID, productcode: String
    var productname, gender, color, jwelleryType: String
    var defaultSize, sizeType, dataDescription, manufactureID: String
    var manufactureType: Int
    var certifiedID, amount, image: String
    var status, mostSellingStatus: Int
    var createdAt, updatedAt: String

    init(id: Int, categoryID: String, subcategoryID: String, subsubcategoryID: String, productcode: String, productname: String, gender: String, color: String, jwelleryType: String, defaultSize: String, sizeType: String, dataDescription: String, manufactureID: String, manufactureType: Int, certifiedID: String, amount: String, image: String, status: Int, mostSellingStatus: Int, createdAt: String, updatedAt: String) {
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
    }
}

// MARK: - File
class NewFile {
    var id: Int
    var productID, image: String
    var type: Int
    var thumbnail, createdAt, updatedAt: String

    init(id: Int, productID: String, image: String, type: Int, thumbnail: String, createdAt: String, updatedAt: String) {
        self.id = id
        self.productID = productID
        self.image = image
        self.type = type
        self.thumbnail = thumbnail
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

// MARK: - Manufacture
class NewManufacture {
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
class NewPrice {
    var silver, stone: [DiamondMaster]
    var ring: [Ring]
    var chain, bangle: [Bangle]
    var platinum, gold: [DiamondMaster]
    var jwelleryType: [JwelleryTypeElement]
    var diamondcolor, diamondclarity: [Diamondc]
    var diamondMaster: [DiamondMaster]

    init(silver: [DiamondMaster], stone: [DiamondMaster], ring: [Ring], chain: [Bangle], bangle: [Bangle], platinum: [DiamondMaster], gold: [DiamondMaster], jwelleryType: [JwelleryTypeElement], diamondcolor: [Diamondc], diamondclarity: [Diamondc], diamondMaster: [DiamondMaster]) {
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
class NewBangle {
    var id: Int
    var jwelleryType: JwelleryTypeEnum
    var sizes: String
    var bangleSize: String?
    var createdAt: String

    init(id: Int, jwelleryType: JwelleryTypeEnum, sizes: String, bangleSize: String?, createdAt: String) {
        self.id = id
        self.jwelleryType = jwelleryType
        self.sizes = sizes
        self.bangleSize = bangleSize
        self.createdAt = createdAt
    }
}

enum JwelleryTypeEnum {
    case bangles
    case chain
}

// MARK: - DiamondMaster
class NewDiamondMaster {
    var id: Int
    var metrialType: MetrialType
    var userID, type, price, valueIn: String
    var diamondType: Diamond?
    var createdAt, updatedAt: String

    init(id: Int, metrialType: MetrialType, userID: String, type: String, price: String, valueIn: String, diamondType: Diamond?, createdAt: String, updatedAt: String) {
        self.id = id
        self.metrialType = metrialType
        self.userID = userID
        self.type = type
        self.price = price
        self.valueIn = valueIn
        self.diamondType = diamondType
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

enum NewDiamond {
    case cricleDiamond
    case roundCutDiamondExcellent
}

// MARK: - Diamondc
class NewDiamondc {
    var id: Int
    var type: TypeEnum
    var colorOrClarity: String

    init(id: Int, type: TypeEnum, colorOrClarity: String) {
        self.id = id
        self.type = type
        self.colorOrClarity = colorOrClarity
    }
}

enum NewTypeEnum {
    case clarity
    case color
}

// MARK: - JwelleryTypeElement
class JwelleryTypeElement {
    var id: Int
    var jwelleryName: String

    init(id: Int, jwelleryName: String) {
        self.id = id
        self.jwelleryName = jwelleryName
    }
}

// MARK: - Ring
class NewRing {
    var sizes: String

    init(sizes: String) {
        self.sizes = sizes
    }
}

// MARK: - RecentProduct
class NewRecentProduct {
    var productID: Int
    var productName, productCategory, productcode, amount: String
    var image: String
    var quality: Quality
    var weight: Weight

    init(productID: Int, productName: String, productCategory: String, productcode: String, amount: String, image: String, quality: Quality, weight: Weight) {
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

// MARK: - Quality
class Quality {
    var gold0: String
    var diamond1: Diamond
    var stone2: String?

    init(gold0: String, diamond1: Diamond, stone2: String?) {
        self.gold0 = gold0
        self.diamond1 = diamond1
        self.stone2 = stone2
    }
}

// MARK: - Weight
class Weight {
    var gold, diamond: String
    var stone: String?

    init(gold: String, diamond: String, stone: String?) {
        self.gold = gold
        self.diamond = diamond
        self.stone = stone
    }
}
