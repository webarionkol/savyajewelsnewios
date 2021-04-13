//
//  CurrentUser.swift
//  savyaApp
//
//  Created by Yash on 12/29/19.
//  Copyright © 2019 Yash Rathod. All rights reserved.
//

import Foundation
import RealmSwift

class CurrentUser:Object {
    
   static let sharedInstance = CurrentUser()
    
    @objc dynamic var number = ""
    @objc dynamic var password = ""
    
    func getCurrentUserNamePassword() -> (String,String) {
        let realm = try! Realm()
        
        let allObj = realm.objects(CurrentUser.self)
        if allObj.count > 0 {
            return (allObj[0].number,allObj[0].password)
        } else {
            return ("","")
        }
        
    }
    
}
