//
//  App_Banner.swift
//  savyaApp
//
//  Created by Yash on 7/16/20.
//  Copyright © 2020 Yash Rathod. All rights reserved.
//

import Foundation

// MARK: - AppBanner
class AppBannerDash {
    var id: Int
    var bannerFor, stateCode, cityCode, userID: String
    var title, type, place, startDate: String
    var endDate, categoryID: String
    var subcategoryID, subsubcategoryID: String
    var image, status, createdAt, updatedAt: String

    init(id: Int, bannerFor: String, stateCode: String, cityCode: String, userID: String, title: String, type: String, place: String, startDate: String, endDate: String, categoryID: String, subcategoryID: String, subsubcategoryID: String, image: String, status: String, createdAt: String, updatedAt: String) {
        self.id = id
        self.bannerFor = bannerFor
        self.stateCode = stateCode
        self.cityCode = cityCode
        self.userID = userID
        self.title = title
        self.type = type
        self.place = place
        self.startDate = startDate
        self.endDate = endDate
        self.categoryID = categoryID
        self.subcategoryID = subcategoryID
        self.subsubcategoryID = subsubcategoryID
        self.image = image
        self.status = status
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

class kycBanners {
    var id: Int
    var bannerFor: String
    var title: String
   
    var image, status, createdAt, updatedAt: String
    var alt :String
    init(id: Int, bannerFor: String, title: String, image: String, status: String, createdAt: String, updatedAt: String,alt:String) {
        self.id = id
        self.bannerFor = bannerFor
        self.title = title
        self.image = image
        self.status = status
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.alt = alt
    }
}

