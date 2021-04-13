//
//  Profile.swift
//  savyaApp
//
//  Created by Yash on 7/29/19.
//  Copyright © 2019 Yash Rathod. All rights reserved.
//

import Foundation

class Profile:NSObject {
    
    var name:String!
    var uid:String!
    var register_type:String!
    var company_name:String!
    var gst_no:String!
    var pan_no:String!
    var email:String!
    var mobile_no:String!
    var address:String!
    var city:String!
    var pincode:String!
    var state:String!
    var image:String!
    var document_verified:Int!
    init(name:String,uid:String,register_type:String,company_name:String,gst_no:String,pan_no:String,email:String,mobile_no:String,address:String,city:String,pincode:String,state:String,image:String,document_verified:Int) {
        self.name = name
        self.uid = uid
        self.register_type = register_type
        self.company_name = company_name
        self.gst_no = gst_no
        self.pan_no = pan_no
        self.email = email
        self.mobile_no = mobile_no
        self.address = address
        self.city = city
        self.pincode = pincode
        self.state = state
        self.image = image
        self.document_verified = document_verified
    }
}
