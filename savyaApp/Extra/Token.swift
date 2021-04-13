
//
//  TOken.swift
//  savyaApp
//
//  Created by Yash on 6/26/19.
//  Copyright © 2019 Yash Rathod. All rights reserved.
//

import Foundation
import RealmSwift

class Token:Object {
    
    @objc dynamic var uid = 0
    @objc dynamic var token = ""
    
    class func getLatestToken() -> String {
        let realm = try! Realm()
        if realm.objects(Token.self).count > 0 {
            print(realm.objects(Token.self)[0].token)
            return realm.objects(Token.self)[0].token
        } else {
            return ""
        }
    }
}
