//
//  Bullian.swift
//  savyaApp
//
//  Created by Yash on 5/9/20.
//  Copyright © 2020 Yash Rathod. All rights reserved.
//

import Foundation

// MARK: - Banner
class Bullian {
    let id: Int
    let state, city, shopName, name: String
    let about: String
    let email, mobile, telephone: String
    let facebookLink, instagramLink, address, latitude: String
    let longitude: String
    let coverImage, image: String
    let status: Int
    let createdAt, updatedAt: String

    init(id: Int, state: String, city: String, shopName: String, name: String, about: String, email: String, mobile: String, telephone: String, facebookLink: String, instagramLink: String, address: String, latitude: String, longitude: String, coverImage: String, image: String, status: Int, createdAt: String, updatedAt: String) {
        self.id = id
        self.state = state
        self.city = city
        self.shopName = shopName
        self.name = name
        self.about = about
        self.email = email
        self.mobile = mobile
        self.telephone = telephone
        self.facebookLink = facebookLink
        self.instagramLink = instagramLink
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.coverImage = coverImage
        self.image = image
        self.status = status
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
