//
//  Prices.swift
//  savyaApp
//
//  Created by Yash on 11/29/19.
//  Copyright © 2019 Yash Rathod. All rights reserved.
//

import Foundation
import RealmSwift

//MARK: Diamond Price
class DiamondPrice:Object {
    
    static let sharedInstance = DiamondPrice()
    
    @objc dynamic var id = 0
    @objc dynamic var diamond_type = ""
    @objc dynamic var price = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    func incremnetID() -> Int {
        return (try! Realm().objects(DiamondPrice.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
     func getpriceByDiamondName(diamondName:String) -> String {
        let realm = try! Realm()
        let diamondPrice: Results<DiamondPrice> = {
            return realm.objects(DiamondPrice.self).filter("diamond_type = '\(diamondName)'")
        }()
        return diamondPrice[0].price
    }
}
extension Results {
    func toArray<T>(ofType: T.Type) -> [T] {
        var array = [T]()
        for i in 0 ..< count {
            if let result = self[i] as? T {
                array.append(result)
            }
        }

        return array
    }
}
//MARK: Gold Price
class GoldPrice:Object {
    
    static let sharedInstance = GoldPrice()
    
    @objc dynamic var id = 0
    @objc dynamic var gold_type = ""
    @objc dynamic var price = ""
    @objc dynamic var valuein = 0.0
    
    func incremnetID() -> Int {
        return (try! Realm().objects(GoldPrice.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
    func getpriceByGoldPrice(gold_type:String) -> String {
        let realm = try! Realm()
      //  let diamondPrice: Results<GoldPrice> = {

            let objects = realm.objects(GoldPrice.self).toArray(ofType : GoldPrice.self) as [GoldPrice]

    
        for obj in 0..<objects.count {
            
            let type = objects[obj].gold_type
            if type == gold_type {
                return objects[obj].price
                break
            }
        }
        return objects[0].price
           // return realm.objects(GoldPrice.self).filter("gold_type = '\(gold_type)'")
       // }()
        //return diamondPrice[0].price
    }
    func getValueByGoldPrice(gold_type:String) -> Float {
        let realm = try! Realm()
//        let diamondPrice: Results<GoldPrice> = 0.
//            return realm.objects(GoldPrice.self).filter("gold_type = '\(gold_type)'")
//        }()
//        return Float(diamondPrice[0].valuein)
        
        let objects = realm.objects(GoldPrice.self).toArray(ofType : GoldPrice.self) as [GoldPrice]
        
        for obj in 0..<objects.count {
            
            let type = objects[obj].gold_type
            if type == gold_type {
                return Float(objects[obj].valuein)
            }
        }
        
        return Float(objects[0].valuein)
    }
    
}

//MARK: Stone Price
class StonePrice:Object {
    
    static let sharedInstance = StonePrice()
    
    @objc dynamic var id = 0
    @objc dynamic var stone_type = ""
    @objc dynamic var price = ""
    
    
    func incremnetID() -> Int {
        return (try! Realm().objects(StonePrice.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
    func getpriceByStoneprice(stone_type:String) -> String {
        let realm = try! Realm()
        
        
        let objects = realm.objects(StonePrice.self).toArray(ofType : StonePrice.self) as [StonePrice]
        
        for obj in 0..<objects.count {
            
            let strname = objects[obj].stone_type
            if stone_type == strname {
                return objects[obj].price
            }
        }
        
        return objects[0].price
        
        
//        let diamondPrice: Results<StonePrice> = {
//            return realm.objects(StonePrice.self).filter("stone_type = '\(stone_type)'")
//        }()
//        return diamondPrice[0].price
    }
    
}

//MARK: Silver Price
class SilverPrice:Object {
    
    static let sharedInstance = SilverPrice()
    
    @objc dynamic var id = 0
    @objc dynamic var silver_type = ""
    @objc dynamic var price = ""
    @objc dynamic var value = ""
    
    func incremnetID() -> Int {
        return (try! Realm().objects(SilverPrice.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
    func getpriceBySilverPrice(silver_type:String) -> String {
        let realm = try! Realm()
//        let diamondPrice: Results<SilverPrice> = {
//            return realm.objects(SilverPrice.self).filter("stone_type = '\(silver_type)'")
//        }()
//        return diamondPrice[0].price
        
        let objects = realm.objects(SilverPrice.self).toArray(ofType : SilverPrice.self) as [SilverPrice]
        
        for obj in 0..<objects.count {
            
            let strname = objects[obj].silver_type
            if silver_type == strname {
                return objects[obj].price
            }
        }
        
        return objects[0].price
    }
    
    func getValueBySilverPrice(silver_type:String) -> Float {
        let realm = try! Realm()
//        let diamondPrice: Results<GoldPrice> = 0.
//            return realm.objects(GoldPrice.self).filter("gold_type = '\(gold_type)'")
//        }()
//        return Float(diamondPrice[0].valuein)
        
        let objects = realm.objects(SilverPrice.self).toArray(ofType : SilverPrice.self) as [SilverPrice]
        
        for obj in 0..<objects.count {
            
            let type = objects[obj].silver_type
            if type == silver_type {
                return Float(objects[obj].value)!
            }
        }
        
        return Float(objects[0].value)!
    }
    
}

//MARK: Diamond Color
class DiamondColor:Object {
    
    static let sharedInstance = DiamondColor()
    
    @objc dynamic var id = 0
    @objc dynamic var color = ""
    @objc dynamic var price = ""
    
    func incremnetID() -> Int {
        return (try! Realm().objects(DiamondColor.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
   func getpriceByDiamondColor(color:String) -> String {
        let realm = try! Realm()
        let diamondPrice: Results<DiamondColor> = {
            return realm.objects(DiamondColor.self).filter("color = '\(color)'")
        }()
        return diamondPrice[0].price
    }
    
}

//MARK: Diamond Clarity
class DiamondClarity:Object {
    
    static let sharedInstance = DiamondClarity()
    
    @objc dynamic var id = 0
    @objc dynamic var clarity = ""
    @objc dynamic var price = ""
    
    func incremnetID() -> Int {
        return (try! Realm().objects(DiamondClarity.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
   func getpriceByDiamondClarity(clarity:String) -> String {
        let realm = try! Realm()
        let diamondPrice: Results<DiamondClarity> = {
            return realm.objects(DiamondClarity.self).filter("clarity = '\(clarity)'")
        }()
        return diamondPrice[0].price
    }
    
}

//MARK: Platinum
class PlatinumPrice:Object {
    
    static let sharedInstance = PlatinumPrice()
    
    @objc dynamic var id = 0
    @objc dynamic var platinum_type = ""
    @objc dynamic var price = ""
    
    func incremnetID() -> Int {
        return (try! Realm().objects(PlatinumPrice.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
    func getpriceByPlatinumName(platinum_type:String) -> String {
        let realm = try! Realm()
        
        let objects = realm.objects(PlatinumPrice.self).toArray(ofType : PlatinumPrice.self) as [PlatinumPrice]
        
        for obj in 0..<objects.count {
            
            let strname = objects[obj].platinum_type
            if platinum_type == strname {
                return objects[obj].price
            }
        }
        
        return objects[0].price
        
        
//        let diamondPrice: Results<PlatinumPrice> = {
//            return realm.objects(PlatinumPrice.self).filter("platinum_type = '\(platinum_type)'")
//        }()
//        return diamondPrice[0].price
    }
    
}

//MARK: Diamond Master
class DiamondMaster:Object {
    
    static let sharedInstance = DiamondMaster()
    
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var price = ""
    @objc dynamic var type = ""
    
    
    func incremnetID() -> Int {
        return (try! Realm().objects(DiamondMaster.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
    func getpriceByDiamondName(name:String,color:String) -> String {
        let realm = try! Realm()
        let objects = realm.objects(DiamondMaster.self).toArray(ofType : DiamondMaster.self) as [DiamondMaster]
        
        for obj in 0..<objects.count {
            
            let strname = objects[obj].name
            if name == strname {
                
                if objects[obj].type == color {
                    return objects[obj].price
                }
            }
        }
        
        return objects[0].price
    
//        let diamondPrice: Results<DiamondMaster> = {
//            return realm.objects(DiamondMaster.self).filter("name = '\(name)'")
//        }()
//        if diamondPrice.count > 0 {
//            return diamondPrice[0].price
//        } else {
//            return "n/a"
//        }
        
    }
    
    
    func getpriceByDiamondNamedetails(name:String) -> String {
        let realm = try! Realm()
        let objects = realm.objects(DiamondMaster.self).toArray(ofType : DiamondMaster.self) as [DiamondMaster]
        
        for obj in 0..<objects.count {
            
            let strname = objects[obj].name
            if name == strname {
                return objects[obj].price
            }
        }
        
        return objects[0].price
        
        
        
//        let diamondPrice: Results<DiamondMaster> = {
//            return realm.objects(DiamondMaster.self).filter("name = '\(name)'")
//        }()
//        if diamondPrice.count > 0 {
//            return diamondPrice[0].price
//        } else {
//            return "n/a"
//        }
        
    }
    
}
