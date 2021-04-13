//
//  Offer.swift
//  savyaApp
//
//  Created by Yash on 9/4/19.
//  Copyright © 2019 Yash Rathod. All rights reserved.
//

import Foundation

class Offer:NSObject {
    
    var titlee:String!
    var subtitle:String!
    var img:String!
    var code:String!
    var value:String!
    
    init(title:String,subtitle:String,img:String,code:String,value:String) {
        self.titlee = title
        self.subtitle = subtitle
        self.img = img
        self.code = code
        self.value = value
    }
}
