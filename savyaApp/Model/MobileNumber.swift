//
//  MobileNumber.swift
//  savyaApp
//
//  Created by Yash on 8/13/19.
//  Copyright © 2019 Yash Rathod. All rights reserved.
//

import Foundation
import RealmSwift

class Mobile:Object {
    
    @objc dynamic var mobile = ""
    @objc dynamic var uid = ""
    @objc dynamic var email = ""
    
    static let sharedInstance = Mobile()
    
    class func getMobile() -> String {
        let realm = try! Realm()
        let r1 = realm.objects(Mobile.self)[0]
        return r1.mobile
    }
    
    class func getUid() -> String {
        let realm = try! Realm()
        let r1 = realm.objects(Mobile.self)[0]
        return r1.uid
    }
    class func getCount() -> Int {
        let realm = try! Realm()
        return realm.objects(Mobile.self).count
    }
    
    class func getEmail() -> String {
        let realm = try! Realm()
        return realm.objects(Mobile.self)[0].email
    }
}
