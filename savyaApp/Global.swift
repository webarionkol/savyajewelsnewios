//
//  Global.swift
//  Kids Deli
//
//  Created by keval dattani on 03/07/19.
//  Copyright © 2019 keval dattani. All rights reserved.
//

import Foundation
import Foundation
import SwiftyJSON

class Global: NSObject
{
    
    static let sharedInstance = Global()
    
    var kyc = String()
    var update = String()
    
    var notificaitonid = String()
    var sub_category_id = String()
    var category_id = String()
    var manufaturer_id = String()
    var isFrom = String()
    var product_id = String()
    var machinery_id = String()
    var location_id = String()
    var bullianID = String()
    
    
    class func setlocation(location_id : String) -> Void {
        sharedInstance.location_id = location_id
    }
    class func getlocation() -> String {
        return sharedInstance.location_id as String
    }
    class func setbullid(bullianID : String) -> Void {
        sharedInstance.bullianID = bullianID
    }
    class func getbullid() -> String {
        return sharedInstance.bullianID as String
    }
    
    class func setproid(product_id : String) -> Void {
        sharedInstance.product_id = product_id
    }
    class func getproid() -> String {
        return sharedInstance.product_id as String
    }
    
    class func setmachine(machinery_id : String) -> Void {
        sharedInstance.machinery_id = machinery_id
    }
    class func getmachine() -> String {
        return sharedInstance.machinery_id as String
    }
    
    
    class func setCateid(category_id : String) -> Void {
        sharedInstance.category_id = category_id
    }
    class func getCateid() -> String {
        return sharedInstance.category_id as String
    }
    
    class func setIsFrom(isFrom : String) -> Void {
        sharedInstance.isFrom = isFrom
    }
    class func getIsfrom() -> String {
        return sharedInstance.isFrom as String
    }
    
    class func setMenuid(manufaturer_id : String) -> Void {
        sharedInstance.manufaturer_id = manufaturer_id
    }
    class func getMenuid() -> String {
        return sharedInstance.manufaturer_id as String
    }
    
    class func setSubid(sub_category_id : String) -> Void {
        sharedInstance.sub_category_id = sub_category_id
    }
    class func getSubid() -> String {
        return sharedInstance.sub_category_id as String
    }
    
    class func setNotiId(notificaitonid : String) -> Void {
        sharedInstance.notificaitonid = notificaitonid
    }
    class func getNotiId() -> String {
        return sharedInstance.notificaitonid as String
    }
    
    class func setKyc(kyc : String) -> Void {
        sharedInstance.kyc = kyc
    }
    class func getKyc() -> String {
        return sharedInstance.kyc as String
    }
    
    class func setUpdate(update : String) -> Void {
        sharedInstance.update = update
    }
    class func getUpdate() -> String {
        return sharedInstance.update as String
    }
    
   
    
}
