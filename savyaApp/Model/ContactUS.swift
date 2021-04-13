//
//  ContactUS.swift
//  savyaApp
//
//  Created by Yash on 8/9/19.
//  Copyright © 2019 Yash Rathod. All rights reserved.
//

import Foundation

// MARK: - ContactUS
class ContactUS {
    let id: Int
    let address, mobile, landline, email: String
    let instagram: String
    let facebook: String
    let linkendin: String
    let twitter: String
    let createdAt, updatedAt: String

    init(id: Int, address: String, mobile: String, landline: String, email: String, instagram: String, facebook: String, createdAt: String, updatedAt: String,linkendin:String,twitter:String) {
        self.id = id
        self.address = address
        self.mobile = mobile
        self.landline = landline
        self.email = email
        self.instagram = instagram
        self.facebook = facebook
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.linkendin = linkendin
        self.twitter = twitter
    }
}
