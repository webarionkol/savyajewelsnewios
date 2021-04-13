//
//  WishListRealm.swift
//  savyaApp
//
//  Created by Yash on 1/5/20.
//  Copyright © 2020 Yash Rathod. All rights reserved.
//

import Foundation
import RealmSwift

class WishlistRealm:Object {
    
   static let sharedInstace = WishlistRealm()
    
    @objc dynamic var pid = 0
    
    func getAllId() -> [Int] {
        let realm = try! Realm()
        var strArr = [Int]()
        let allObj = realm.objects(WishlistRealm.self)
        for i in allObj {
            strArr.append(i.pid)
        }
        return strArr
    }
    
}
