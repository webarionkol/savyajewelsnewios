//
//  Address.swift
//  savyaApp
//
//  Created by Yash on 8/13/19.
//  Copyright © 2019 Yash Rathod. All rights reserved.
//

import Foundation

class Address:NSObject {
    
    let id: Int
       var uid, first, last, country: String
       let address, pincode, city, region: String
       let mobileno : String

       init(id: Int, uid: String, first: String, last: String, country: String, address: String, pincode: String, city: String, region: String, mobileno: String) {
           self.id = id
           self.uid = uid
           self.first = first
           self.last = last
           self.country = country
           self.address = address
           self.pincode = pincode
           self.city = city
           self.region = region
           self.mobileno = mobileno
           
       }
}
