//
//  productDetailWoring.swift
//  savyaApp
//
//  Created by Yash on 6/8/20.
//  Copyright © 2020 Yash Rathod. All rights reserved.
//

/*
 
 //
 //  productDetails.swift
 //  savyaApp
 //
 //  Created by Yash on 8/30/19.
 //  Copyright © 2019 Yash Rathod. All rights reserved.
 //

 import Foundation
 import UIKit
 import Alamofire
 import SwiftyJSON
 import RealmSwift
 import AVKit

 class productDetailsVC:RootBaseVC,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource {
     
     @IBOutlet weak var tablee:subtableView!
     @IBOutlet weak var collectionImage:UICollectionView!
     @IBOutlet weak var collectionTrending:UICollectionView!
     @IBOutlet weak var pageControl:UIPageControl!
     @IBOutlet weak var priceLbl:UILabel!
     @IBOutlet weak var offerPriceLbl:UILabel!
     @IBOutlet weak var nameLbl:UILabel!
     @IBOutlet weak var favBtn:UIButton!
     @IBOutlet weak var productCode:UILabel!
     @IBOutlet weak var productWeight:UILabel!
     
     
 //    let allWishProduct = try! Realm().objects(WishlistRealm.self)
     var certificate = [[String:Any]]()
     var singleProduct:Product!
     var id = 1
     var sendid = ""
     var imges = [[String:AnyObject]]()
     var trendingProduct = [Prodectnew]()
     var tableData = 0
     var imgurl = ""
     var size = [String]()
     var stonee = [String]()
     var metal:Int?
     var diamond:Int?
     var platinum:Int?
     var stone:Int?
     var silver:Int?
     var defaultSize = ""
     var color = ""
     var manufactured = ""
     var manufactureURL = ""
     var goldArrTemp = [Gold]()
     var diamondTemp = [Diamond]()
     var platinumTemp = [Platinum]()
     var stoneTemp = [Stone]()
     var silverTemp = [Silver]()
     var descr = ""
     var defaultColor = "Rose"
     var colors = ["Rose","Yellow","White"]
     var goldVar:Int!
     var stoneVar:Int!
     var pcode = ""
     var diamondColorTemp = ""
     var diamondClarityTemp = ""
     var weight = ""
     var goldWeight = [String]()
     var allFiles = [Files]()
     var newPrice = [PriceNew]()
     var certis = [Certification]()
     var jwellery_type = ""
     var category = ""
     var productName = ""
     var productType = ""
     var subCategory = ""
     var subSubCategory = ""
     var userid = ""
     var productSize = ""
     
     var newProduct:ProductDetail!
     
     
     override func viewDidLoad() {
         super.viewDidLoad()
         self.tabBarController?.tabBar.isHidden = true
     }
     override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         self.loadAnimation()
         self.getProduct()
         self.addTwoButtons()
         
        
         
     }
     override func viewDidAppear(_ animated: Bool) {
         super.viewDidAppear(animated)
       //  self.checkforFav()
         
     }
     override func viewDidLayoutSubviews() {
         super.viewDidLayoutSubviews()
         DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
             self.tablee.invalidateIntrinsicContentSize()
         }
     }
     override func viewWillDisappear(_ animated: Bool) {
         super.viewWillDisappear(animated)
         self.tabBarController?.tabBar.isHidden = false
     }
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "cart" {
             let dvc = segue.destination as! cartVC
             dvc.wheree = "prodetails"
         }
     }
     @IBAction func favBtn(_ sender:UIButton) {
         
         if WishlistRealm.sharedInstace.getAllId().contains(self.id) {
             self.removeFromWishlist()
         } else {
             self.addToWishList()
         }
     }
     func calculateWeight() {
         var weightGold = 0.0
         var weightDiamond = 0.0
         var weightPlatinum = 0.0
         var weightStone = 0.0
         var weightSilver = 0.0
         
         if self.goldArrTemp.count > 0 {
             weightGold = Double(self.goldArrTemp[self.goldVar].goldweight.floatValue)
         }
         if self.diamondTemp.count > 0 {
             let Diamondw = Double(self.diamondTemp[0].diamondqty.floatValue)
             weightDiamond = Diamondw * 0.2
         }
         
         if self.platinumTemp.count > 0 {
             weightPlatinum = Double(self.platinumTemp[0].platinumQty.floatValue)
         }
         if self.stoneTemp.count > 0 {
             weightStone = Double(self.stoneTemp[0].stoneno.floatValue)
         }
         if self.silverTemp.count > 0 {
             weightSilver = Double(self.silverTemp[0].silverqty.floatValue)
         }
         
         let total = weightGold + weightDiamond + weightStone + weightPlatinum + weightSilver
         self.productWeight.text = "Gross Weight :- " + String(format: "%.3f", total) + " g"
     }
     func addToWishList() {
         APIManager.shareInstance.addwishlist(product_id: "\(self.id)", vc: self) { (response) in
             if response == "success" {
                 self.favBtn.setImage(UIImage(named: "likefilled"), for: .normal)
                 self.addWishlistotrealm()
             } else {
                 self.showAlert(titlee: "Message", message: "Something went wrong")
             }
         }
     }
     func removeFromWishlist() {
         APIManager.shareInstance.addwishlist(product_id: "\(self.id)", vc: self) { (response) in
             if response == "success" {
                 self.favBtn.setImage(UIImage(named: "like"), for: .normal)
                 self.view.makeToast("Product removed from wishlist")
             } else {
                 self.showAlert(titlee: "Message", message: "Something went wrong")
             }
         }
     }
     func addWishlistotrealm() {
         let realm = try! Realm()
         let w1 = WishlistRealm()
         w1.pid = self.id
         try! realm.write {
             realm.add(w1)
         }
     }
     func checkforFav() {
         if WishlistRealm.sharedInstace.getAllId().contains(self.id) {
             self.favBtn.setImage(UIImage(named: "likefilled"), for: .normal)
         } else {
             self.favBtn.setImage(UIImage(named: "like"), for: .normal)
         }
     }
     func addTwoButtons() {
         let theHeight = view.frame.size.height //grabs the height of your view
         
         let btn1 = UIButton(frame: CGRect(x: 0, y: theHeight - 40, width: self.view.frame.width / 2, height: 40))
         let btn2 = UIButton(frame: CGRect(x: self.view.frame.width / 2, y: theHeight - 40, width: self.view.frame.width / 2, height: 40))
         
         btn1.backgroundColor = UIColor.init(red: 25/255, green: 26/255, blue: 125/255, alpha: 1.0)
         btn2.backgroundColor = UIColor.init(red: 187/255, green: 159/255, blue: 97/255, alpha: 1.0)
         
         btn1.setTitle("Add To Cart", for: .normal)
         btn2.setTitle("Buy Now", for: .normal)
         
         btn1.setTitleColor(.white, for: .normal)
         btn2.setTitleColor(.white, for: .normal)
         
         btn1.addTarget(self, action: #selector(addToCart(_:)), for: .touchUpInside)
         btn2.addTarget(self, action: #selector(buyNow(_:)), for: .touchUpInside)
         
         self.view.addSubview(btn1)
         self.view.addSubview(btn2)
         
         
     }
     
     @objc func addToCart(_ sender:UIButton) {
         
         var assetsArr = [[String:Any]]()
         var templist = List<AssetR>()
         if self.goldArrTemp.count > 0 {
             assetsArr.append(["weight" : self.goldArrTemp[self.goldVar].goldweight!,"materialType":self.goldArrTemp[self.goldVar].goldquality!,"makingCharge":self.goldArrTemp[self.goldVar].makingcharge!,"option":self.goldArrTemp[self.goldVar].option!,"metal":"Gold","productId":self.singleProduct.id.toString(),"product_size":self.productSize,"wastage":""])
             
             let a1 = AssetR()
             a1.id = 0
             a1.makingCharge = self.goldArrTemp[self.goldVar].makingcharge!
             a1.materialType = self.goldArrTemp[self.goldVar].goldquality!
             a1.metal = "Gold"
             a1.options = self.goldArrTemp[self.goldVar].option!
             a1.product_id = "1"
             a1.weight = self.goldArrTemp[self.goldVar].goldweight!
             templist.append(a1)
         }
         
         if self.diamondTemp.count > 0 {
             assetsArr.append(["weight" : self.diamondTemp[0].diamondqty!,"materialType":"\(self.diamondColorTemp)/\(self.diamondClarityTemp)","makingCharge":diamondTemp[0].diamondcharge!,"option":"pergram","metal":"Diamond","productId":self.singleProduct.id.toString(),"product_size":self.productSize,"wastage":""])
             
             let a1 = AssetR()
             a1.id = 0
             a1.makingCharge = diamondTemp[0].diamondcharge!
             a1.materialType = "\(self.diamondColorTemp)/\(self.diamondClarityTemp)"
             a1.metal = "Diamond"
             a1.options = "pergram"
             a1.product_id = "1"
             a1.weight = self.diamondTemp[0].diamondqty!
             templist.append(a1)
         }
         
         if self.stoneTemp.count > 0 {
             assetsArr.append(["weight" : self.stoneTemp[0].stoneno,"materialType":self.stoneTemp[self.stoneVar].stonetype,"makingCharge":self.stoneTemp[0].stonecharges,"option":"pergram","metal":"Stone","productId":self.singleProduct.id.toString(),"product_size":self.productSize,"wastage":""])
             
             let a1 = AssetR()
             a1.id = 0
             a1.makingCharge = self.stoneTemp[0].stonecharges
             a1.materialType = self.stoneTemp[self.stoneVar].stonetype
             a1.metal = "Stone"
             a1.options = "pergram"
             a1.product_id = "1"
             a1.weight = self.stoneTemp[0].stoneno
             templist.append(a1)
         }
         if self.platinumTemp.count > 0 {
             assetsArr.append(["weight" : self.platinumTemp[0].platinumQty,"materialType":"Platinum","makingCharge":self.platinumTemp[0].platinumCharge,"option":"pergram","metal":"Platinum","productId":self.singleProduct.id.toString(),"product_size":self.productSize,"wastage":""])
             
             let a1 = AssetR()
             a1.id = 0
             a1.makingCharge = self.platinumTemp[0].platinumCharge
             a1.materialType = "Platinum"
             a1.metal = "Platinum"
             a1.options = "pergram"
             a1.product_id = "1"
             a1.weight = self.platinumTemp[0].platinumQty
             templist.append(a1)
         }
         
         let data = ["count":1,"productId":self.id,"userid":self.userid,"category":self.category,"subCategory":self.subCategory,"subSubCategory":self.subSubCategory,"productCode":self.productCode.text ?? "","productName":self.productName,"description":self.description,"productType":self.productType,"jwellery_type":self.productType,"defaultColor":self.defaultColor,"productId":self.singleProduct.id ?? 0,"assests":assetsArr] as [String : Any]
         
         let realm = try! Realm()
         let c1 = CartR()
         
         c1.category = ""
         c1.id = c1.incrementID()
         c1.productID = String(self.id)
         c1.userID = Mobile.getUid()
         c1.productCode = self.productCode.text!
         c1.productName = self.nameLbl.text!
         c1.count = "1"
         c1.productType = ""
         c1.assets = templist
         c1.welcomeDescription = self.descr
         try! realm.write {
             realm.add(c1)
         }
         APIManager.shareInstance.addToCart(data: [data], vc: self) { (response) in
             print(response)
             self.performSegue(withIdentifier: "cart", sender: self)
         }
     }
     func calculateTotalPrice() -> String {
         var priceGold = 0.0
         var priceDiamond = 0.0
         var pricePlatinum = 0.0
         var priceStone = 0.0
         var priceSilver = 0.0
         if self.goldArrTemp.count > 0 {
             
             var goldRate:Float = 0.0
             var goldValue:Float = 0.0
             var gold24K:Float = 0.0
             
             for i in self.newPrice {
                 print(i.metrialType)
                 print(self.goldArrTemp[self.goldVar].goldquality)
                 if i.type == self.goldArrTemp[self.goldVar].goldquality {
                     goldRate = i.price.floatValue
                 }
                 if i.type == self.goldArrTemp[self.goldVar].goldquality {
                     goldValue = i.valueIn.floatValue
                 }
                 if i.type == "24KT" {
                     gold24K = i.price.floatValue
                 }
             }
             print(self.goldArrTemp[self.goldVar].goldweight.floatValue)
             print(self.goldArrTemp[self.goldVar].makingcharge.floatValue)
             print(goldRate)
             print(goldValue)
             print(gold24K)
             print(self.goldArrTemp[self.goldVar].option)
             let priceForGold = Utils.calculatePrice(type: "Gold", weight: self.goldArrTemp[self.goldVar].goldweight.floatValue, rate: goldRate, makingCharge: self.goldArrTemp[self.goldVar].makingcharge.floatValue, option: self.goldArrTemp[self.goldVar].option, goldValue: goldValue, gold24k: gold24K)
             
          //   let priceForGold = Utils.calculatePrice(type: "Gold", weight: self.goldArrTemp[self.goldVar].goldweight.floatValue, rate: GoldPrice.sharedInstance.getpriceByGoldPrice(gold_type: self.goldArrTemp[self.goldVar].goldquality).floatValue, makingCharge: self.goldArrTemp[self.goldVar].makingcharge.floatValue, option: self.goldArrTemp[self.goldVar].option, goldValue: GoldPrice.sharedInstance.getValueByGoldPrice(gold_type: self.goldArrTemp[self.goldVar].goldquality), gold24k: GoldPrice.sharedInstance.getpriceByGoldPrice(gold_type: "24K").floatValue)
             priceGold = priceForGold
             
             print(priceGold)
         }
         if self.diamondTemp.count > 0 {
             
             var diamondRate:Float = 0.0
             for i in self.newPrice {
                 if i.type == "\(self.diamondColorTemp)/\(self.diamondClarityTemp)" {
                     diamondRate = i.price.floatValue
                 }
             }
             
             let priceForDiamond = Utils.calculatePrice(type: "Diamond", weight: self.diamondTemp[0].diamondqty.floatValue, rate: diamondRate, makingCharge: self.diamondTemp[0].diamondcharge.floatValue, option: self.diamondTemp[0].type, goldValue: 0.0, gold24k: 0.0)
             
            // let priceForDiamond = Utils.calculatePrice(type: "Diamond", weight: self.diamondTemp[0].diamondqty.floatValue, rate: DiamondMaster.sharedInstance.getpriceByDiamondName(name: "\(self.diamondColorTemp)/\(self.diamondClarityTemp)").floatValue, makingCharge: self.diamondTemp[0].diamondcharge.floatValue, option: self.diamondTemp[0].type, goldValue: 0.0, gold24k: 0.0)
             priceDiamond = priceForDiamond
         }
         if self.platinumTemp.count > 0 {
             
             var platinumRate:Float = 0.0
             for i in self.newPrice {
                 if i.metrialType == "Platinum" {
                     platinumRate = i.price.floatValue
                 }
             }
             let priceForPlatinum = Utils.calculatePlatinumPrice(wastage: self.platinumTemp[0].wastage.floatValue, purity: self.platinumTemp[0].purity.floatValue, weight: self.platinumTemp[0].platinumQty.floatValue, rate: platinumRate, makingCharge: self.platinumTemp[0].platinumCharge.floatValue, isPerGram: self.platinumTemp[0].chargeType)
             
           //  let priceForPlatinum = Utils.calculatePlatinumPrice(wastage: self.platinumTemp[0].wastage.floatValue, purity: self.platinumTemp[0].purity.floatValue, weight: self.platinumTemp[0].platinumQty.floatValue, rate: PlatinumPrice.sharedInstance.getpriceByPlatinumName(platinum_type: "Platinum").floatValue, makingCharge: self.platinumTemp[0].platinumCharge.floatValue, isPerGram: self.platinumTemp[0].chargeType)
             
             
             pricePlatinum = Double(priceForPlatinum)
         }
         if self.stoneTemp.count > 0 {
             
             var stoneRate:Float = 0.0
             for i in self.newPrice {
                 if i.metrialType == self.stoneTemp[self.stoneVar].stonetype {
                     stoneRate = i.price.floatValue
                 }
             }
             
             let priceForStone = Utils.calculatePrice(type: "Stone", weight: self.stoneTemp[self.stoneVar].stoneqty.floatValue, rate: stoneRate, makingCharge: self.stoneTemp[self.stoneVar].stonecharges.floatValue, option: self.stoneTemp[self.stoneVar].type, goldValue: 0.0, gold24k: 0.0)
             
           //  let priceForStone = Utils.calculatePrice(type: "Stone", weight: self.stoneTemp[self.stoneVar].stoneqty.floatValue, rate: StonePrice.sharedInstance.getpriceByStoneprice(stone_type: self.stoneTemp[self.stoneVar].stonetype).floatValue, makingCharge: self.stoneTemp[self.stoneVar].stonecharges.floatValue, option: self.stoneTemp[self.stoneVar].type, goldValue: 0.0, gold24k: 0.0)
             priceStone = priceForStone
         }
         if self.silverTemp.count > 0 {
             
             var silverRate:Float = 0.0
             for i in self.newPrice {
                 if i.metrialType == "Silver" {
                     silverRate = i.price.floatValue
                 }
             }
             
             let priceForSilver = Utils.calculatePrice(type: "Silver", weight: self.silverTemp[0].silverqty.floatValue, rate: silverRate, makingCharge: self.silverTemp[0].silvercharges.floatValue, option: self.silverTemp[0].chargeType, goldValue: 0.0, gold24k: 0.0)
             
             //let priceForSilver = Utils.calculatePrice(type: "Silver", weight: self.silverTemp[0].silverqty.floatValue, rate: SilverPrice.sharedInstance.getpriceBySilverPrice(silver_type: "Silver").floatValue, makingCharge: self.silverTemp[0].silvercharges.floatValue, option: self.silverTemp[0].chargeType, goldValue: 0.0, gold24k: 0.0)
             priceSilver = priceForSilver
         }
        // self.priceLbl.text = "₹ \(priceGold + priceDiamond + pricePlatinum + priceStone)"
         let finalPrice = priceGold + priceDiamond + pricePlatinum + priceStone + priceSilver
         
         let rupee = "₹ "
         let price = String(format: "%.2f", finalPrice)
         print(rupee + price)
         return rupee + price
     }
     @objc func buyNow(_ sender:UIButton) {
         
     }
     
     //MARK:- Product Details
     func getProduct() {
         let value = ["product_id":self.id]
         print("product id -  \(self.id)")
         let authorization:HTTPHeaders =  ["Authorization":Token.getLatestToken()]
         AF.request(NewAPI.productDetails + "\(self.id)",method: .put,parameters: value,encoding: JSONEncoding.default,headers: authorization).responseJSON { (responseData) in
             print(responseData)
             print(responseData.request?.url)
             print(responseData.value)
             if responseData.value != nil {
                 let resData = responseData.value as! [String:Any]
                 let res1 = resData["data"] as! [String:Any]
                 let url = resData["url"] as! String
                 let manufacture_url = resData["manufacture_url"] as! String
                 self.nameLbl.text = res1["productname"] as? String
                // let assets = resData["assets"] as! [[String:Any]]
                 self.descr = res1["description"] as? String ?? ""
                 let pcode = res1["productcode"] as! String
                 self.productCode.text = "Product Code:- " + pcode
                 let color = res1["color"] as! String
                 let manufacture = res1["manufacture"] as? String
                 self.manufactured = manufacture ?? ""
                 
                 self.color = color
                 self.pcode = pcode
                 self.defaultSize = res1["default_size"] as? String ?? "6"
                 let strArr = res1["size_type"] as? String
                 self.size = (strArr?.components(separatedBy: ","))!
                 
                 let priceArr = resData["price"] as! [String:Any]
                 if let silverPrice = priceArr["silver"] as? [[String:Any]] {
                     for i in silverPrice {
                         let id = i["id"] as! Int
                         let metrial_type = i["metrial_type"] as? String
                         let user_id = i["user_id"] as? String
                         let type = i["type"] as? String
                         let price = i["price"] as? String
                         let value_in = i["value_in"] as? String
                         
                         let temp = PriceNew.init(id: id, metrialType: metrial_type ?? "" , userID: user_id ?? "", type: type ?? "", price: price ?? "", valueIn: value_in ?? "", createdAt: "", updatedAt: "")
                         
                         self.newPrice.append(temp)
                     }
                 }
                 
                 if let stonePrice = priceArr["stone"] as? [[String:Any]] {
                     for i in stonePrice {
                         let id = i["id"] as! Int
                         let metrial_type = i["metrial_type"] as? String
                         let user_id = i["user_id"] as? String
                         let type = i["type"] as? String
                         let price = i["price"] as? String
                         let value_in = i["value_in"] as? String
                         
                         let temp = PriceNew.init(id: id, metrialType: metrial_type ?? "" , userID: user_id ?? "", type: type ?? "", price: price ?? "", valueIn: value_in ?? "", createdAt: "", updatedAt: "")
                         
                         self.newPrice.append(temp)
                     }
                 }
                 
                 if let platinumPrice = priceArr["platinum"] as? [[String:Any]] {
                     for i in platinumPrice {
                         let id = i["id"] as! Int
                         let metrial_type = i["metrial_type"] as? String
                         let user_id = i["user_id"] as? String
                         let type = i["type"] as? String
                         let price = i["price"] as? String
                         let value_in = i["value_in"] as? String
                         
                         let temp = PriceNew.init(id: id, metrialType: metrial_type ?? "" , userID: user_id ?? "", type: type ?? "", price: price ?? "", valueIn: value_in ?? "", createdAt: "", updatedAt: "")
                         
                         self.newPrice.append(temp)
                     }
                 }
                 
                 if let goldPrice = priceArr["gold"] as? [[String:Any]] {
                     for i in goldPrice {
                         let id = i["id"] as! Int
                         let metrial_type = i["metrial_type"] as? String
                         let user_id = i["user_id"] as? String
                         let type = i["type"] as? String
                         let price = i["price"] as? String
                         let value_in = i["value_in"] as? String
                         
                         let temp = PriceNew.init(id: id, metrialType: metrial_type ?? "" , userID: user_id ?? "", type: type ?? "", price: price ?? "", valueIn: value_in ?? "", createdAt: "", updatedAt: "")
                         
                         self.newPrice.append(temp)
                     }
                 }
                 
                 if let diamond_masterPrice = priceArr["diamond_master"] as? [[String:Any]] {
                     for i in diamond_masterPrice {
                         let id = i["id"] as! Int
                         let metrial_type = i["metrial_type"] as? String
                         let user_id = i["user_id"] as? String
                         let type = i["type"] as? String
                         let price = i["price"] as? String
                         let value_in = i["value_in"] as? String
                         
                         let temp = PriceNew.init(id: id, metrialType: metrial_type ?? "" , userID: user_id ?? "", type: type ?? "", price: price ?? "", valueIn: value_in ?? "", createdAt: "", updatedAt: "")
                         
                         self.newPrice.append(temp)
                     }
                 }
                 
                 let filesArr = resData["files"] as! [[String:Any]]
                 for i in filesArr {
                     let id = i["id"] as? Int
                     let product_id = i["product_id"] as? String
                     let image = i["image"] as? String
                     let type = i["type"] as? Int
                     let finalImg = (image ?? "").replacingOccurrences(of: " ", with: "%20")
                     
                     let temp = Files.init(id: id ?? 0, productID: product_id ?? "", image: url + "/" + finalImg, type: type ?? 0, createdAt: "", updatedAt: "")
                     self.allFiles.append(temp)
                     
                 }
                 self.pageControl.numberOfPages = self.allFiles.count
                 self.collectionImage.reloadData()
                 
                 
                 //Trending Product
                 let res3 = resData["recent_product"] as! [[String:Any]]
                 for i in res3 {
                     let product_id = i["product_id"] as! Int
                     let product_name = i["product_name"] as? String
                     let productcode = i["productcode"] as? String
                     let amount = i["amount"] as? String
                     let image = i["image"] as? String ?? ""
                     let quality = i["quality"] as? String
                     let weight = i["weight"] as? String
                     
                     let temp = Prodectnew.init(productID: product_id, productName: product_name ?? "", productcode: productcode ?? "", amount: amount ?? "", image: url + "/" + image, quality: quality ?? "", weight: weight ?? "")
                     self.trendingProduct.append(temp)
                 }
                 self.collectionTrending.reloadData()
                
                 //MARK: Certification
                 
                 let res4 = resData["Certification"] as! [[String:AnyObject]]
                 
                 
                 for i in res4 {
                     self.certificate.append([ "name": i["certi_name"]!,"image": MainURL.mainurl + "img/certificate/" + (i["image"]! as! String)])
                 }
                 
                 //MARK: Manufacture
                 if let manufacture = resData["manufacture"] as? [String:Any] {
                     self.manufactured = manufacture["company_name"] as? String ?? ""
                     let image = manufacture["logo"] as! String
                     self.manufactureURL = manufacture_url + "/" + image
                 }
                 
                 //MARK: Check for Metals
                 let assetsArr = resData["assets"] as! [[String:Any]]
                 for i in assetsArr {
                     let materialType = i["metrial_type"] as? String
                     if materialType == "Gold" {
                         let goldweight = i["weight"] as? String
                         let goldquality = i["jwellery_size"] as? String
                         let makingcharge = i["making_charge"] as? String
                         let option = i["charges_option"] as? String
                         
                         let tempRes = Gold.init(goldweight: goldweight ?? "", goldquality: goldquality ?? "", makingcharge: makingcharge ?? "", option: option ?? "")
                         self.goldArrTemp.append(tempRes)
                         self.goldWeight.append(goldweight ?? "")
                         if self.goldArrTemp.count > 0 {
                             self.goldVar = 0
                         }
                     } else if materialType == "Diamond" {
                         let diamond = i["metrial_type"] as? String
                         let diamondqty = i["quantity"] as? String
                         let no_diamond = i["weight"] as? String
                         let default_size = i["default_size"] as? String
                         let diamondcolor = i["diamondcolor"] as? String
                         let diamondclarity = i["diamondclarity"] as? String
                         let type = i["jwellery_size"] as? String
                         let diamondcharge = i["diamondcharge"] as? String
                         let defaultSize = (i["default_color_clarity"] as? String)?.components(separatedBy: "/")
                         
                         let tempRes = Diamond.init(diamond: diamond ?? "", diamondqty: diamondqty ?? "", no_diamond: no_diamond ?? "", default_size: default_size ?? "", diamondcolor: diamondcolor ?? "", diamondclarity: diamondclarity ?? "", type: type ?? "", diamondcharge: diamondcharge ?? "")
                         self.diamondTemp.append(tempRes)
                         
                         self.diamondColorTemp = defaultSize![0]
                         self.diamondClarityTemp = defaultSize![1]
                     } else if materialType == "Platinum" {
                         let id = i["id"] as! Int
                         let product_id = i["product_id"] as? String
                         let platinum_type = i["platinum_type"] as? String
                         let platinum_qty = i["quantity"] as? String
                         let wastage = i["wastage"] as? String
                         let purity = i["purity"] as? String
                         let charge_type = i["charges_option"] as? String
                         let platinum_charge = i["making_charge"] as? String
                         
                         
                         let tempsRes = Platinum.init(id: id, productID: product_id ?? "", platinumType: platinum_type ?? "Platinum", platinumQty: platinum_qty ?? "", wastage: wastage ?? "0", purity: purity ?? "0", chargeType: charge_type ?? "", platinumCharge: platinum_charge ?? "")
                         self.platinumTemp.append(tempsRes)
                     } else if materialType == "Stone" {
                         let stone_id = i["product_id"] as? String
                         let id = i["id"] as? Int
                         let product_id = i["product_id"] as? String
                         let stonetype = i["jwellery_size"] as? String
                         let stoneqty = i["quantity"] as? String
                         let stoneno = i["stoneno"] as? String
                         let type = i["charges_option"] as? String
                         let stonecharges = i["making_charge"] as? String
                         let created_at = i["created_at"] as? String
                         let updated_at = i["updated_at"] as? String
                         
                         let tempRes = Stone.init(stoneID:( stone_id ?? "0").toInt(), id: id  ?? 0, productID: product_id  ?? "", stonetype: stonetype  ?? "", stoneqty: stoneqty  ?? "", stoneno: stoneno ?? "", type: type ?? "", stonecharges: stonecharges ?? "", createdAt: created_at ?? "", updatedAt: updated_at ?? "")
                         
                         self.stoneTemp.append(tempRes)
                         if self.stoneTemp.count > 0 {
                             self.stoneVar = 0
                         }
                     } else if materialType == "Silver" {
                         
                     }
                 }
                 
                 
 //                if let goldArr = assetsArr["gold"] as? [[String:AnyObject]] {
 //
 //                    for i in goldArr {
 //                        let goldweight = i["goldweight"] as? String
 //                        let goldquality = i["goldquality"] as? String
 //                        let makingcharge = i["makingcharge"] as? String
 //                        let option = i["option"] as? String
 //
 //                        let tempRes = Gold.init(goldweight: goldweight!, goldquality: goldquality!, makingcharge: makingcharge!, option: option!)
 //                        self.goldArrTemp.append(tempRes)
 //                        self.goldWeight.append(goldweight!)
 //                    }
 //
 //                }
                 
                 
                 
 //                if let diamondArr = assetsArr["diamond"] as? [[String:AnyObject]] {
 //                    for i in diamondArr {
 //                        let diamond = i["diamond"] as? String
 //                        let diamondqty = i["diamondqty"] as? String
 //                        let no_diamond = i["no_diamond"] as? String
 //                        let default_size = i["default_size"] as? String
 //                        let diamondcolor = i["diamondcolor"] as? String
 //                        let diamondclarity = i["diamondclarity"] as? String
 //                        let type = i["type"] as? String
 //                        let diamondcharge = i["diamondcharge"] as? String
 //                        let defaultSize = (i["default_size"] as? String)?.components(separatedBy: ",")
 //
 //                        let tempRes = Diamond.init(diamond: diamond!, diamondqty: diamondqty!, no_diamond: no_diamond!, default_size: default_size!, diamondcolor: diamondcolor!, diamondclarity: diamondclarity!, type: type!, diamondcharge: diamondcharge!)
 //                        self.diamondTemp.append(tempRes)
 //
 //                        self.diamondColorTemp = defaultSize![0]
 //                        self.diamondClarityTemp = defaultSize![1]
 //                    }
 //
 //                }
 //                if let platinumArr = assetsArr["productpaltinum"] as? [String:Any] {
 //
 //                    let id = platinumArr["id"] as! Int
 //                    let product_id = platinumArr["product_id"] as! String
 //                    let platinum_type = platinumArr["platinum_type"] as! String
 //                    let platinum_qty = platinumArr["platinum_qty"] as! String
 //                    let wastage = platinumArr["wastage"] as? String
 //                    let purity = platinumArr["purity"] as? String
 //                    let charge_type = platinumArr["charge_type"] as! String
 //                    let platinum_charge = platinumArr["platinum_charge"] as! String
 //
 //
 //                    let tempsRes = Platinum.init(id: id, productID: product_id, platinumType: platinum_type, platinumQty: platinum_qty, wastage: wastage ?? "0", purity: purity ?? "0", chargeType: charge_type, platinumCharge: platinum_charge)
 //                    self.platinumTemp.append(tempsRes)
 //
 //                }
 //                if let stoneArr = assetsArr["stone"] as? [[String:AnyObject]] {
 //                    for i in stoneArr {
 //                        let stone_id = i["stone_id"] as! Int
 //                        let id = i["id"] as! Int
 //                        let product_id = i["product_id"] as! String
 //                        let stonetype = i["stonetype"] as! String
 //                        let stoneqty = i["stoneqty"] as! String
 //                        let stoneno = i["stoneno"] as! String
 //                        let type = i["type"] as! String
 //                        let stonecharges = i["stonecharges"] as! String
 //                        let created_at = i["created_at"] as! String
 //                        let updated_at = i["updated_at"] as! String
 //
 //                        let tempRes = Stone.init(stoneID: stone_id, id: id, productID: product_id, stonetype: stonetype, stoneqty: stoneqty, stoneno: stoneno, type: type, stonecharges: stonecharges, createdAt: created_at, updatedAt: updated_at)
 //
 //                        self.stoneTemp.append(tempRes)
 //                    }
 //                    if self.stoneTemp.count > 0 {
 //                        self.stoneVar = 0
 //                    }
 //                }
                 self.tablee.invalidateIntrinsicContentSize()
                 self.tablee.reloadData()
                 self.priceLbl.text = self.calculateTotalPrice()
                 self.removeAnimation()
                 self.calculateWeight()
             }
         }
     }
     
     @objc func goldSelect(_ sender:UIButton) {
         if self.goldArrTemp.count > 0 {
             let btnTitle = sender.titleLabel?.text!
             for i in 0 ..< self.goldArrTemp.count {
                 if self.goldArrTemp[i].goldquality == btnTitle {
                     self.goldVar = i
                     
                     
                     var goldRate:Float = 0.0
                     var goldValue:Float = 0.0
                     var gold24K:Float = 0.0
                        
                     for i in self.newPrice {
                         
                         if i.type == self.goldArrTemp[self.goldVar].goldquality {
                             goldRate = i.price.floatValue
                         }
                         if i.type == self.goldArrTemp[self.goldVar].goldquality {
                             goldValue = i.valueIn.floatValue
                         }
                            if i.type == "24KT" {
                                gold24K = i.price.floatValue
                            }
                        }
                        
                        let priceForGold = Utils.calculatePrice(type: "Gold", weight: self.goldArrTemp[self.goldVar].goldweight.floatValue, rate: goldRate, makingCharge: self.goldArrTemp[self.goldVar].makingcharge.floatValue, option: self.goldArrTemp[self.goldVar].option, goldValue: goldValue, gold24k: gold24K)
                        
                     //   let priceForGold = Utils.calculatePrice(type: "Gold", weight: self.goldArrTemp[self.goldVar].goldweight.floatValue, rate: GoldPrice.sharedInstance.getpriceByGoldPrice(gold_type: self.goldArrTemp[self.goldVar].goldquality).floatValue, makingCharge: self.goldArrTemp[self.goldVar].makingcharge.floatValue, option: self.goldArrTemp[self.goldVar].option, goldValue: GoldPrice.sharedInstance.getValueByGoldPrice(gold_type: self.goldArrTemp[self.goldVar].goldquality), gold24k: GoldPrice.sharedInstance.getpriceByGoldPrice(gold_type: "24K").floatValue)
                        
                     
                     
                   //  let priceForGold = Utils.calculatePrice(type: "Gold", weight: Float(self.goldArrTemp[i].goldweight)!, rate: Float(GoldPrice.sharedInstance.getpriceByGoldPrice(gold_type: self.goldArrTemp[i].goldquality))!, makingCharge: Float(self.goldArrTemp[i].makingcharge)!, option: self.goldArrTemp[i].option, goldValue: GoldPrice.sharedInstance.getValueByGoldPrice(gold_type: self.goldArrTemp[i].goldquality), gold24k: GoldPrice.sharedInstance.getpriceByGoldPrice(gold_type: "24K").floatValue)
                     self.priceLbl.text = "₹ \(priceForGold)"
                     self.priceLbl.text = self.calculateTotalPrice()
                     self.calculateWeight()
                     self.tablee.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .automatic)
                 }
             }
         }
     }
     @objc func selectSize(_ sender:UIButton) {
         let actionSheet = UIAlertController(title: "Message", message: "Select Size", preferredStyle: .actionSheet)
         actionSheet.popoverPresentationController?.sourceView = sender
         actionSheet.popoverPresentationController?.sourceRect = sender.bounds
         for i in self.size {
             actionSheet.addAction(UIAlertAction(title: i, style: .default, handler: { (_) in
                 let cell = self.tablee.cellForRow(at: IndexPath(row: 0, section: 0)) as! productSizeCell
                 cell.btnSize.setTitle(i, for: .normal)
                 let intSize = Int(self.defaultSize)
                 let intSelectedSize = Int(i)
                 if intSelectedSize! > intSize! {
                     let subtractedSize = intSelectedSize! - intSize!
                     let calcWeight = Double(subtractedSize) * 0.2
                     let currentWeight = Double(self.goldWeight[self.goldVar])
                     let finalWeight = calcWeight + currentWeight!
                     self.goldArrTemp[self.goldVar].goldweight = String(finalWeight)
                     self.priceLbl.text = self.calculateTotalPrice()
                     self.tablee.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .automatic)
                     
                 } else {
                     let subtractedSize = intSize! - intSelectedSize!
                     let currentWeight = Double(self.goldWeight[self.goldVar])
                     var calcWeight:Double!
                     for _ in 0 ..< subtractedSize {
                         calcWeight = currentWeight! - 0.2
                     }
                    
                     
                     let finalWeight = calcWeight + currentWeight!
                     self.goldArrTemp[self.goldVar].goldweight = String(finalWeight)
                     self.priceLbl.text = self.calculateTotalPrice()
                     self.tablee.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .automatic)
                 }
             }))
         }
         actionSheet.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (_) in
             
         }))
         self.present(actionSheet, animated: true, completion: nil)
         
     }
     @objc func colorSelect(_ sender:UIButton) {
         let cell = self.tablee.cellForRow(at: IndexPath.init(row: 1, section: 0)) as! productColorCell
         if sender.tag == 1 {
             cell.roseBtn.setImage(UIImage.init(named: "icons8-checkmark"), for: .normal)
             cell.goldBtn.setImage(nil, for: .normal)
             cell.whiteBtn.setImage(nil, for: .normal)
         } else if sender.tag == 2 {
             cell.roseBtn.setImage(nil, for: .normal)
             cell.goldBtn.setImage(UIImage.init(named: "icons8-checkmark"), for: .normal)
             cell.whiteBtn.setImage(nil, for: .normal)
         } else if sender.tag == 3 {
             cell.roseBtn.setImage(nil, for: .normal)
             cell.goldBtn.setImage(nil, for: .normal)
             cell.whiteBtn.setImage(UIImage.init(named: "icons8-checkmark"), for: .normal)
         }
     }
     @objc func selectColor(_ sender:UIButton) {
         let actionSheet = UIAlertController(title: "Message", message: "Please select color", preferredStyle: .actionSheet)
         actionSheet.popoverPresentationController?.sourceView = sender
         actionSheet.popoverPresentationController?.sourceRect = sender.bounds
         for i in self.colors {
             actionSheet.addAction(UIAlertAction(title: i, style: .default, handler: { (_) in
                 let cell = self.tablee.cellForRow(at: IndexPath(row: 1, section: 0)) as! productSizeCell
                 cell.btnSize.setTitle(i, for: .normal)
             }))
         }
         actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
             
         }))
         self.present(actionSheet, animated: true, completion: nil)
         
     }
     @objc func diamondTypeBtn(_ sender:UIButton) {
         let actionSheet = UIAlertController(title: "Message", message: "Select Diamond", preferredStyle: .actionSheet)
         actionSheet.popoverPresentationController?.sourceView = sender
         actionSheet.popoverPresentationController?.sourceRect = sender.bounds
         for i in self.diamondTemp {
             actionSheet.addAction(UIAlertAction(title: i.diamond, style: .default, handler: { (_) in
                 let cell = self.tablee.cellForRow(at: IndexPath(row: 3, section: 0)) as! productDiamondCell
                 cell.diamondTypeBtn.setTitle(i.diamond, for: .normal)
             }))
         }
         actionSheet.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (_) in
             
         }))
         self.present(actionSheet, animated: true, completion: nil)
     }
     @objc func selectStone(_ sender:UIButton) {
         let actionSheet = UIAlertController(title: "Message", message: "Select Stone Type", preferredStyle: .actionSheet)
         for i in 0 ..< self.stoneTemp.count {
             actionSheet.addAction(UIAlertAction(title: self.stoneTemp[i].stonetype, style: .default, handler: { (_) in
                 let cell = self.tablee.cellForRow(at: IndexPath(row: 6, section: 0)) as! productStoneCell
                 cell.btnStoneType.setTitle(self.stoneTemp[i].stonetype, for: .normal)
                 self.stoneVar = i
             }))
         }
         actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
             
         }))
         
         actionSheet.popoverPresentationController?.sourceRect = sender.bounds
         actionSheet.popoverPresentationController?.sourceView = sender
         self.present(actionSheet, animated: true, completion: nil)
     }
     @objc func diamondColoBtn(_ sender:UIButton) {
         let diamondPrice = DiamondMaster.sharedInstance.getpriceByDiamondName(name: "\(self.diamondColorTemp)/\(self.diamondClarityTemp)")
         
        // cell.lblDiamondColor.text = "\(self.diamondColorTemp)/\(self.diamondClarityTemp)"
         
         self.diamondColorTemp = sender.titleLabel!.text!
         self.priceLbl.text = self.calculateTotalPrice()
         let cell = self.tablee.cellForRow(at: IndexPath(row: 3, section: 0)) as! productDiamondCell
         cell.lblPrice.text = "₹" + diamondPrice + "/ct"
         self.tablee.reloadRows(at: [IndexPath(row: 3, section: 0)], with: .automatic)
     }
     @objc func diamondClarityBtn(_ sender:UIButton) {
         let diamondPrice = DiamondMaster.sharedInstance.getpriceByDiamondName(name: "\(self.diamondColorTemp)/\(self.diamondClarityTemp)")
         
        // cell.lblDiamondColor.text = "\(self.diamondColorTemp)/\(self.diamondClarityTemp)"
         
         self.diamondClarityTemp = sender.titleLabel!.text!
         self.priceLbl.text = self.calculateTotalPrice()
         let cell = self.tablee.cellForRow(at: IndexPath(row: 3, section: 0)) as! productDiamondCell
         cell.lblPrice.text = "₹" + diamondPrice + "/ct"
         self.tablee.reloadRows(at: [IndexPath(row: 3, section: 0)], with: .automatic)
     }
     @IBAction func back(_ sender:UIButton) {
        // self.navigationController?.popViewController(animated: true)
        // self.dismiss(animated: true, completion: nil)
     }
     
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 //        var tempMetal = self.goldArrTemp.count
 //        var tempDiamond = self.diamondTemp.count
 //        var tempPlatinum = self.platinumTemp.count
 //        var tempStone = self.stoneTemp.count
 //        if self.goldArrTemp.count > 0 {
 //            tempMetal = 1
 //        } else {
 //            tempMetal = 0
 //        }
 //
 //        if self.diamondTemp.count > 0 {
 //            tempDiamond = 1
 //        } else {
 //            tempDiamond = 0
 //        }
 //
 //        if self.platinumTemp.count > 0 {
 //            tempPlatinum = 1
 //        } else {
 //            tempPlatinum = 0
 //        }
 //
 //        if self.stoneTemp.count > 0 {
 //            tempStone = 1
 //        } else {
 //            tempStone = 0
 //        }
 //
 //        let totalSum = tempMetal + tempDiamond + tempStone + tempPlatinum
         return 11
     }
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         if indexPath.row == 0 {
             let cell = tableView.dequeueReusableCell(withIdentifier: "sizecell") as! productSizeCell
             cell.btnSize.addTarget(self, action: #selector(selectSize(_:)), for: .touchUpInside)
             cell.btnSize.setTitle(self.defaultSize, for: .normal)
             cell.lblTitle.text = "Select Size"
             return cell
         } else if indexPath.row == 1 {
             let cell = tableView.dequeueReusableCell(withIdentifier: "colorCell") as! productColorCell
             
             
             cell.roseBtn.titleLabel?.textColor = .black
             cell.goldBtn.titleLabel?.textColor = .black
             cell.whiteBtn.titleLabel?.textColor = .black
             
             cell.goldBtn.layer.cornerRadius = cell.goldBtn.frame.height / 2
             cell.goldBtn.clipsToBounds = true
             
             cell.roseBtn.layer.cornerRadius = cell.roseBtn.frame.height / 2
             cell.roseBtn.clipsToBounds = true
             
             cell.whiteBtn.layer.cornerRadius = cell.whiteBtn.frame.height / 2
             cell.whiteBtn.clipsToBounds = true
             
             cell.roseBtn.tag = 1
             cell.whiteBtn.tag = 3
             cell.goldBtn.tag = 2
             
             cell.goldBtn.addTarget(self, action: #selector(colorSelect(_:)), for: .touchUpInside)
             cell.whiteBtn.addTarget(self, action: #selector(colorSelect(_:)), for: .touchUpInside)
             cell.roseBtn.addTarget(self, action: #selector(colorSelect(_:)), for: .touchUpInside)
             
             if self.color == "Yellow" {
                 
 //                cell.goldBtn.sendActions(for: .touchUpInside)
 //                cell.goldBtn.setNeedsLayout()
             } else if self.color == "Rose" {
                 
 //                cell.roseBtn.setNeedsLayout()
 //                cell.roseBtn.sendActions(for: .touchUpInside)
             } else if self.color == "White" {
                 
 //                cell.whiteBtn.setNeedsLayout()
 //                cell.whiteBtn.sendActions(for: .touchUpInside)
             }
             
             return cell
         } else if indexPath.row == 2 {
             let metalCell = tableView.dequeueReusableCell(withIdentifier: "metalcell") as! productMetalCell
             metalCell.k12Btn.isHidden = true
             metalCell.k18Btn.isHidden = true
             metalCell.k8Btn.isHidden = true
             metalCell.k16Btn.isHidden = true
             let btnArr = [metalCell.k8Btn,metalCell.k12Btn,metalCell.k16Btn,metalCell.k18Btn]
             if self.goldArrTemp.count > 0 {
                 for i in 0 ..< self.goldArrTemp.count {
                     
                     btnArr[i]?.isHidden = false
                     btnArr[i]?.setTitle(self.goldArrTemp[i].goldquality, for: .normal)
                     btnArr[i]?.addTarget(self, action: #selector(goldSelect(_:)), for: .touchUpInside)
                     btnArr[i]?.backgroundColor = UIColor.white
                     btnArr[i]?.setTitleColor(.black, for: .normal)
                 }
                 for i in btnArr {
                     if i?.titleLabel?.text == self.goldArrTemp[self.goldVar].goldquality {
                         i?.backgroundColor = UIColor.init(named: "base_color")
                         i?.setTitleColor(.white, for: .normal)
                     }
                 }
                 metalCell.goldWeightLbl.text = self.goldArrTemp[self.goldVar!].goldweight + " g"
               // metalCell.goldRateLbl.text = GoldPrice.sharedInstance.getpriceByGoldPrice(gold_type: self.goldArrTemp[self.goldVar!].goldquality) + "/g"
                 
                 if self.goldArrTemp[self.goldVar].option == "percentage" {
                     metalCell.goldFineWeightitleLbl.text = "Gold Fine Weight"
                     // metalCell.goldFineWeightLbl.text = "\(Utils.calculateWeight(goldvalue: GoldPrice.sharedInstance.getValueByGoldPrice(gold_type: self.goldArrTemp[self.goldVar].goldquality), weight: self.goldArrTemp[self.goldVar].goldweight.floatValue, makingCharge: self.goldArrTemp[self.goldVar].makingcharge.floatValue))"
                   //  metalCell.goldFineWeightLbl.text = String(format: "%.2f", Utils.calculateWeight(goldvalue: GoldPrice.sharedInstance.getValueByGoldPrice(gold_type: self.goldArrTemp[self.goldVar].goldquality), weight: self.goldArrTemp[self.goldVar].goldweight.floatValue, makingCharge: self.goldArrTemp[self.goldVar].makingcharge.floatValue)) + " g"
               //      print(Utils.calculateWeight(goldvalue: GoldPrice.sharedInstance.getValueByGoldPrice(gold_type: self.goldArrTemp[self.goldVar].goldquality), weight: self.goldArrTemp[self.goldVar].goldweight.floatValue, makingCharge: self.goldArrTemp[self.goldVar].makingcharge.floatValue))
              //       print(GoldPrice.sharedInstance.getValueByGoldPrice(gold_type: "18K"))
                     print(self.goldArrTemp[self.goldVar].goldquality)
                     DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.6) {
                         btnArr[self.goldVar]?.backgroundColor = UIColor.init(named: "base_color")
                         btnArr[self.goldVar]?.setTitleColor(.white, for: .normal)
                     }
                     
                     metalCell.wastageTitleLbl.text = "Wastage"
                     metalCell.wastageLbl.text = self.goldArrTemp[self.goldVar].makingcharge + " %"
                    
                //     metalCell.goldTotalLbl.text = "\(Double(Utils.calculatePrice(type: "Gold", weight: self.goldArrTemp[self.goldVar].goldweight.floatValue, rate: GoldPrice.sharedInstance.getpriceByGoldPrice(gold_type: self.goldArrTemp[self.goldVar].goldquality).floatValue, makingCharge: self.goldArrTemp[self.goldVar].makingcharge.floatValue, option: self.goldArrTemp[self.goldVar].option, goldValue: GoldPrice.sharedInstance.getValueByGoldPrice(gold_type: self.goldArrTemp[self.goldVar].goldquality), gold24k: GoldPrice.sharedInstance.getpriceByGoldPrice(gold_type: "24K").floatValue)))"
                     
                     metalCell.goldRateTitleLbl.text = "Fine Gold Rate"
                     
                 //    metalCell.goldRateLbl.text = "\(GoldPrice.sharedInstance.getpriceByGoldPrice(gold_type: "24K"))/g"
                     
                     //metalCell.goldRateLbl.text = "₹" + String(format: "%.2f", Utils.calculatePrice(type: "Gold", weight: self.goldArrTemp[self.goldVar].goldweight.floatValue, rate: GoldPrice.sharedInstance.getpriceByGoldPrice(gold_type: self.goldArrTemp[self.goldVar].goldquality).floatValue, makingCharge: self.goldArrTemp[self.goldVar].makingcharge.floatValue, option: self.goldArrTemp[self.goldVar].option, goldValue: GoldPrice.sharedInstance.getValueByGoldPrice(gold_type: self.goldArrTemp[self.goldVar].goldquality), gold24k: GoldPrice.sharedInstance.getpriceByGoldPrice(gold_type: "24K").floatValue))
                  //   metalCell.goldRateLbl.text = "\(Utils.calculatePrice(weight: self.goldArrTemp[self.goldVar].goldweight.floatValue, rate: GoldPrice.sharedInstance.getpriceByGoldPrice(gold_type: self.goldArrTemp[self.goldVar].goldquality).floatValue, makingCharge: self.goldArrTemp[self.goldVar].makingcharge.floatValue, option: self.goldArrTemp[self.goldVar].option, goldValue: GoldPrice.sharedInstance.getValueByGoldPrice(gold_type: self.goldArrTemp[self.goldVar].goldquality), gold24k: GoldPrice.sharedInstance.getpriceByGoldPrice(gold_type: "24K").floatValue))"
                 } else {
                     btnArr[self.goldVar]?.backgroundColor = UIColor.init(named: "base_color")
                     btnArr[self.goldVar]?.setTitleColor(.white, for: .normal)
                     metalCell.goldFineWeightitleLbl.text = ""
                     metalCell.wastageTitleLbl.text = "Gold Making Charge"
                     let goldMakingCharge = self.goldArrTemp[self.goldVar].makingcharge.floatValue * self.goldArrTemp[self.goldVar].goldweight.floatValue
                     metalCell.wastageLbl.text = "₹" + "\(goldMakingCharge)"
                     metalCell.goldFineWeightLbl.text = ""
                     metalCell.goldRateTitleLbl.text = "Gold Rate"
                    // metalCell.goldRateLbl.text = "₹" + GoldPrice.sharedInstance.getpriceByGoldPrice(gold_type: self.goldArrTemp[self.goldVar!].goldquality) + "/g"
                    // metalCell.goldTotalLbl.text = "\(Utils.calculatePrice(type: "Gold", weight: self.goldArrTemp[self.goldVar].goldweight.floatValue, rate: GoldPrice.sharedInstance.getpriceByGoldPrice(gold_type: self.goldArrTemp[self.goldVar].goldquality).floatValue, makingCharge: self.goldArrTemp[self.goldVar].makingcharge.floatValue, option: self.goldArrTemp[self.goldVar].option, goldValue: GoldPrice.sharedInstance.getValueByGoldPrice(gold_type: self.goldArrTemp[self.goldVar].goldquality), gold24k: GoldPrice.sharedInstance.getpriceByGoldPrice(gold_type: "24K").floatValue))"
                 }
             }
                 
             metalCell.productCodeLbl.text = self.pcode
             metalCell.k12Btn.layer.borderColor = UIColor.black.cgColor
             metalCell.k12Btn.layer.borderWidth = 1
             metalCell.k12Btn.layer.cornerRadius = metalCell.k12Btn.frame.height / 2
             metalCell.k12Btn.clipsToBounds = true
                 
             metalCell.k18Btn.layer.borderColor = UIColor.black.cgColor
             metalCell.k18Btn.layer.borderWidth = 1
             metalCell.k18Btn.layer.cornerRadius = metalCell.k18Btn.frame.height / 2
             metalCell.k18Btn.clipsToBounds = true
                 
             metalCell.k8Btn.layer.borderColor = UIColor.black.cgColor
             metalCell.k8Btn.layer.borderWidth = 1
             metalCell.k8Btn.layer.cornerRadius = metalCell.k8Btn.frame.height / 2
             metalCell.k8Btn.clipsToBounds = true
                 
             metalCell.k16Btn.layer.borderColor = UIColor.black.cgColor
             metalCell.k16Btn.layer.borderWidth = 1
             metalCell.k16Btn.layer.cornerRadius = metalCell.k16Btn.frame.height / 2
             metalCell.k16Btn.clipsToBounds = true
                 
                 
             return metalCell
             } else if indexPath.row == 3 {
             let diamondCell = tableView.dequeueReusableCell(withIdentifier: "diamondcell") as! productDiamondCell
             diamondCell.d1Btn.isHidden = true
             diamondCell.d2Btn.isHidden = true
             diamondCell.d3Btn.isHidden = true
             diamondCell.d4Btn.isHidden = true
             diamondCell.d5Btn.isHidden = true
             
             diamondCell.d1Btnc.isHidden = true
             diamondCell.d2Btnc.isHidden = true
             diamondCell.d3Btnc.isHidden = true
             diamondCell.d4Btnc.isHidden = true
             diamondCell.d5Btnc.isHidden = true
                 
             let diamondBtn = [diamondCell.d1Btn,diamondCell.d2Btn,diamondCell.d3Btn,diamondCell.d4Btn,diamondCell.d5Btn]
             let diamondBtnC = [diamondCell.d1Btnc,diamondCell.d2Btnc,diamondCell.d3Btnc,diamondCell.d4Btnc,diamondCell.d5Btnc]
                 
             if self.diamondTemp.count > 0 {
                 diamondCell.diamondTypeBtn.setTitle(self.diamondTemp[0].diamond, for: .normal)
                 diamondCell.diamondTypeBtn.addTarget(self, action: #selector(diamondTypeBtn(_:)), for: .touchUpInside)
                 diamondCell.lblName.text = self.diamondTemp[0].diamond
                 diamondCell.lblName.numberOfLines = 0
                 diamondCell.lblWeight.text = self.diamondTemp[0].diamondqty + " ct"
                 diamondCell.lblNoDiamond.text = self.diamondTemp[0].no_diamond + " pc"
                 diamondCell.lblDiamondMakingCharge.text = "₹" + self.diamondTemp[0].diamondcharge
                 
                 let diamondColor = self.diamondTemp[0].diamondcolor.components(separatedBy: ",")
                 for i in  0 ..< diamondColor.count {
                     diamondBtn[i]?.isHidden = false
                     diamondBtn[i]?.setTitle(diamondColor[i], for: .normal)
                     diamondBtn[i]?.addTarget(self, action: #selector(diamondColoBtn(_:)), for: .touchUpInside)
                     diamondBtn[i]?.backgroundColor = UIColor.white
                     diamondBtn[i]?.setTitleColor(.black, for: .normal)
                 }
                 print(self.diamondTemp[0].diamondclarity)
                 let diamondClarity = self.diamondTemp[0].diamondclarity.components(separatedBy: ",")
                 for i in  0 ..< diamondClarity.count {
                     diamondBtnC[i]?.isHidden = false
                     diamondBtnC[i]?.setTitle(diamondClarity[i], for: .normal)
                     diamondBtnC[i]?.addTarget(self, action: #selector(diamondClarityBtn(_:)), for: .touchUpInside)
                     diamondBtnC[i]?.backgroundColor = UIColor.white
                     diamondBtnC[i]?.setTitleColor(.black, for: .normal)
                 }
                 if self.diamondColorTemp == "" && self.diamondClarityTemp == "" {
                     self.diamondColorTemp = diamondColor[0]
                     self.diamondClarityTemp = diamondClarity[0]
                 }
                
              //   diamondCell.lblPrice.text = "₹" + DiamondMaster.sharedInstance.getpriceByDiamondName(name: "\(self.diamondColorTemp)/\(self.diamondClarityTemp)") + "/ct"
                // diamondCell.lblDiamondTotal.text = "₹" + "\(Utils.calculatePrice(type: "Diamond", weight: self.diamondTemp[0].diamondqty.floatValue, rate: DiamondMaster.sharedInstance.getpriceByDiamondName(name: "\(self.diamondColorTemp)/\(self.diamondClarityTemp)").floatValue, makingCharge: self.diamondTemp[0].diamondcharge.floatValue, option: self.diamondTemp[0].type, goldValue: 0.0, gold24k: 0.0))"
                 
                
                 for i in 0 ..< diamondBtn.count {
                     print(diamondBtn[i]?.titleLabel?.text)
                     print(self.diamondColorTemp)
                     
                     if diamondBtn[i]?.titleLabel?.text! == self.diamondColorTemp {
                         
                         diamondBtn[i]?.backgroundColor = UIColor.init(named: "base_color")
                         diamondBtn[i]?.setTitleColor(.white, for: .normal)
                         
                         
                     }
                 }
         
                 for i in 0 ..< diamondBtnC.count {
                     
                     
                     let btnName = diamondBtnC[i]?.titleLabel?.text! ?? ""
                     print(btnName)
                     if btnName == self.diamondClarityTemp {
                         diamondBtnC[i]?.backgroundColor = UIColor.init(named: "base_color")
                         diamondBtnC[i]?.setTitleColor(.white, for: .normal)
                     }
                 }
             }
                 
                 
             diamondCell.d1Btn.layer.borderColor = UIColor.black.cgColor
             diamondCell.d1Btn.layer.borderWidth = 0.5
             diamondCell.d1Btn.layer.cornerRadius = diamondCell.d1Btn.frame.height / 2
             diamondCell.d1Btn.clipsToBounds = true
                 
             diamondCell.d2Btn.layer.borderColor = UIColor.black.cgColor
             diamondCell.d2Btn.layer.borderWidth = 0.5
             diamondCell.d2Btn.layer.cornerRadius = diamondCell.d2Btn.frame.height / 2
             diamondCell.d2Btn.clipsToBounds = true
                 
             diamondCell.d3Btn.layer.borderColor = UIColor.black.cgColor
             diamondCell.d3Btn.layer.borderWidth = 0.5
             diamondCell.d3Btn.layer.cornerRadius = diamondCell.d3Btn.frame.height / 2
             diamondCell.d3Btn.clipsToBounds = true
                 
             diamondCell.d4Btn.layer.borderColor = UIColor.black.cgColor
             diamondCell.d4Btn.layer.borderWidth = 0.5
             diamondCell.d4Btn.layer.cornerRadius = diamondCell.d4Btn.frame.height / 2
             diamondCell.d4Btn.clipsToBounds = true
                 
             diamondCell.d5Btn.layer.borderColor = UIColor.black.cgColor
             diamondCell.d5Btn.layer.borderWidth = 0.5
             diamondCell.d5Btn.layer.cornerRadius = diamondCell.d5Btn.frame.height / 2
             diamondCell.d5Btn.clipsToBounds = true
                 
             diamondCell.d1Btnc.layer.borderColor = UIColor.black.cgColor
             diamondCell.d1Btnc.layer.borderWidth = 0.5
             diamondCell.d1Btnc.layer.cornerRadius = diamondCell.d1Btnc.frame.height / 2
             diamondCell.d1Btnc.clipsToBounds = true
                 
             diamondCell.d2Btnc.layer.borderColor = UIColor.black.cgColor
             diamondCell.d2Btnc.layer.borderWidth = 0.5
             diamondCell.d2Btnc.layer.cornerRadius = diamondCell.d2Btnc.frame.height / 2
             diamondCell.d2Btnc.clipsToBounds = true
                 
             diamondCell.d3Btnc.layer.borderColor = UIColor.black.cgColor
             diamondCell.d3Btnc.layer.borderWidth = 0.5
             diamondCell.d3Btnc.layer.cornerRadius = diamondCell.d3Btnc.frame.height / 2
             diamondCell.d3Btnc.clipsToBounds = true
                 
             diamondCell.d4Btnc.layer.borderColor = UIColor.black.cgColor
             diamondCell.d4Btnc.layer.borderWidth = 0.5
             diamondCell.d4Btnc.layer.cornerRadius = diamondCell.d4Btnc.frame.height / 2
             diamondCell.d4Btnc.clipsToBounds = true
                 
             diamondCell.d5Btnc.layer.borderColor = UIColor.black.cgColor
             diamondCell.d5Btnc.layer.borderWidth = 0.5
             diamondCell.d5Btnc.layer.cornerRadius = diamondCell.d4Btnc.frame.height / 2
             diamondCell.d5Btnc.clipsToBounds = true
             return diamondCell
             
             } else if indexPath.row == 4 {
                 let platinumeCell = tableView.dequeueReusableCell(withIdentifier: "platinumcell") as! productPlatinumCell
                 if self.platinumTemp.count > 0 {
                  //   platinumeCell.lblPlatinumPrice.text = "₹" + PlatinumPrice.sharedInstance.getpriceByPlatinumName(platinum_type: "Platinum") + "/g"
                     platinumeCell.lblWeight.text = self.platinumTemp[0].platinumQty + "g"
                     platinumeCell.lblPlatinumMakingCharge.text = " ₹ \(self.platinumTemp[0].platinumCharge.floatValue * self.platinumTemp[0].platinumQty.floatValue)"
                  //   platinumeCell.lblPlatinumTotal.text = "₹" +  "\(Utils.calculatePlatinumPrice(wastage: self.platinumTemp[0].wastage.floatValue, purity: self.platinumTemp[0].purity.floatValue, weight: self.platinumTemp[0].platinumQty.floatValue, rate: PlatinumPrice.sharedInstance.getpriceByPlatinumName(platinum_type: "Platinum").floatValue, makingCharge: self.platinumTemp[0].platinumCharge.floatValue, isPerGram: self.platinumTemp[0].chargeType))"
                     platinumeCell.lblPlatinumWasteage.text = self.platinumTemp[0].wastage + "%"
                     
                 }
                 return platinumeCell
         } else if indexPath.row == 5 {
             let silverCell = tableView.dequeueReusableCell(withIdentifier: "silvercell") as! productSilverCell
             if self.silverTemp.count > 0 {
                // silverCell.lblSilverPrice.text = "₹" + SilverPrice.sharedInstance.getpriceBySilverPrice(silver_type: "Silver") + "/g"
                 silverCell.lblWeight.text = self.platinumTemp[0].platinumQty + "g"
                 silverCell.lblSilverMakingCharge.text = " ₹ \(self.silverTemp[0].silvercharges.floatValue * self.silverTemp[0].silverqty.floatValue)"
               //  silverCell.lblSilverTotal.text = "₹ " + "\(Utils.calculatePrice(type: "Platinum", weight: self.silverTemp[0].silverqty.floatValue, rate: SilverPrice.sharedInstance.getpriceBySilverPrice(silver_type: "Silver").floatValue, makingCharge: self.silverTemp[0].silvercharges.floatValue, option: self.silverTemp[0].chargeType, goldValue: 0.0, gold24k: 0.0))"
             }
             return silverCell
         } else if indexPath.row == 6 {
             let stoneCell = tableView.dequeueReusableCell(withIdentifier: "stonecell") as! productStoneCell
             stoneCell.btnStoneType.addTarget(self, action: #selector(selectStone(_:)), for: .touchUpInside)
             if self.stoneTemp.count > 0 {
                 stoneCell.lblNoOfStone.text = self.stoneTemp[0].stoneno
              //   stoneCell.lblStonePrice.text = StonePrice.sharedInstance.getpriceByStoneprice(stone_type: self.stoneTemp[self.stoneVar ?? 0].stonetype)
                 stoneCell.lblStoneWeight.text = self.stoneTemp[0].stoneqty
              //   stoneCell.lblStoneTotal.text = "\(Utils.calculatePrice(type: "Stone", weight: self.stoneTemp[self.stoneVar].stoneqty.floatValue, rate: StonePrice.sharedInstance.getpriceByStoneprice(stone_type: self.stoneTemp[self.stoneVar].stonetype).floatValue, makingCharge: self.stoneTemp[self.stoneVar].stonecharges.floatValue, option: self.stoneTemp[self.stoneVar].type, goldValue: 0.0, gold24k: 0.0))"
                 stoneCell.btnStoneType.setTitle(self.stoneTemp[0].stonetype, for: .normal)
                 
             }
             return stoneCell
             
         } else if indexPath.row == 7 {
         let certifiedCell = tableView.dequeueReusableCell(withIdentifier: "certifiedcell") as! productCertifiedByCell
         print(self.certificate)
         if self.certificate.count > 0 {
             certifiedCell.img1.kf.indicatorType = .activity
             certifiedCell.img1.kf.setImage(with: URL(string: self.certificate[0]["image"] as! String),placeholder: nil,options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
                         switch result {
                         case .success(let value):
                             print("Task done for: \(value.source.url?.absoluteString ?? "")")
                                        
                         case .failure(let error):
                             print("Job failed: \(error.localizedDescription)")
                                        
                         }
                     }
                 if self.certificate.count > 1 {
                     certifiedCell.img2.kf.indicatorType = .activity
                     certifiedCell.img2.kf.setImage(with: URL(string: self.certificate[1]["image"] as! String),placeholder: nil,options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
                         switch result {
                         case .success(let value):
                             print("Task done for: \(value.source.url?.absoluteString ?? "")")
                                            
                         case .failure(let error):
                             print("Job failed: \(error.localizedDescription)")
                         }
                     }
                 }
             }
                 
             return certifiedCell
         } else if indexPath.row == 8 {
             let manufacturedCell = tableView.dequeueReusableCell(withIdentifier: "manuCell") as! productManufactureByCell
             manufacturedCell.lbl1.numberOfLines = 0
             manufacturedCell.img.kf.indicatorType = .activity
             print(self.manufactureURL)
             manufacturedCell.img.kf.setImage(with: URL(string: self.manufactureURL),placeholder: nil,options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
                 switch result {
                 case .success(let value):
                     print("Task done for: \(value.source.url?.absoluteString ?? "")")
                                    
                 case .failure(let error):
                     print("Job failed: \(error.localizedDescription)")
                 }
             }
             manufacturedCell.lbl1.text = self.manufactured
             return manufacturedCell
         } else if indexPath.row == 9 {
             let descrCell = tableView.dequeueReusableCell(withIdentifier: "descrcell") as! productOtherDetailsCell
             descrCell.txtDetails.attributedText = self.descr.convertHtml(str: self.descr)
             
             return descrCell
         } else if indexPath.row == 10 {
             let priceCell = tableView.dequeueReusableCell(withIdentifier: "pricecell") as! productPriceCell
             priceCell.lblTotalPrice.text = self.calculateTotalPrice()
             return priceCell
         } else {
             let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
             return cell!
         }
     }
     
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         if indexPath.row == 0 {
             return 54
         } else if indexPath.row == 2 {
             if self.goldArrTemp.count > 0 {
                 return 190
             } else {
                 return 0
             }
         } else if indexPath.row == 3 {
             if self.diamondTemp.count > 0 {
                 return 400
             } else {
                 return 0
             }
             
         } else if indexPath.row == 4 {
             if self.platinumTemp.count > 0 {
                 return 213
             } else {
                 return 0
             }
         } else if indexPath.row == 5 {
             if self.silverTemp.count > 0 {
                 return 213
             } else {
                 return 0
             }
         } else if indexPath.row == 6 {
             if self.stoneTemp.count > 0 {
                 return 213
             } else {
                 return 0
             }
             
         } else if indexPath.row == 7 {
             if self.certificate.count > 0 {
                 return 124
             } else {
                 return 0
             }
         } else if indexPath.row == 8 {
             return 124
         } else if indexPath.row == 9 {
             return UITableView.automaticDimension
         } else if indexPath.row == 10 {
             return 102
         } else {
             return 54
         }
     }
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         if collectionView == self.collectionImage {
             return self.allFiles.count
         } else {
             return self.trendingProduct.count
         }
         
     }
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         if collectionView == self.collectionImage {
             let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! imgCell
             let img = self.allFiles[indexPath.row].image
             if img.contains("mp4") {
                 cell.img.image = self.createThumbnailOfVideoFromRemoteUrl(url: img)
             } else {
                 cell.img.kf.indicatorType = .activity
                 cell.img.kf.setImage(with: URL(string: img),placeholder: nil,options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
                     switch result {
                     case .success(let value):
                         print("Task done for: \(value.source.url?.absoluteString ?? "")")
                         
                     case .failure(let error):
                         print("Job failed: \(error.localizedDescription)")
                         
                     }
                 }
             }
             
             return cell
         } else {
             let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! trendingProCell
             let onePro = self.trendingProduct[indexPath.row]
             
             cell.lblname.text = onePro.weight + "/" + onePro.quality
             cell.priceLbl.isHidden = true
             cell.img.kf.indicatorType = .activity
             cell.img.kf.setImage(with: URL(string: onePro.image),placeholder: nil,options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
                 switch result {
                 case .success(let value):
                     print("Task done for: \(value.source.url?.absoluteString ?? "")")
                     
                 case .failure(let error):
                     print("Job failed: \(error.localizedDescription)")
                     
                 }
             }
             
            
             return cell
         }
        
     }
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         if collectionView == self.collectionImage {
             return CGSize(width: self.collectionImage.frame.width, height: self.collectionImage.frame.height)
         } else {
             return CGSize(width: self.collectionTrending.frame.width / 3, height: self.collectionTrending.frame.height)
         }
     }
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         if collectionView == self.collectionTrending {
             let ind = self.trendingProduct[indexPath.item]
             self.sendid = ind.productID.toString()
             
             let dvc = self.storyboard?.instantiateViewController(withIdentifier: "detail") as! productDetailsVC
             dvc.id = ind.productID
             self.present(dvc, animated: true, completion: nil)
         } else if collectionView == self.collectionImage {
             let ind = self.allFiles[indexPath.item].image
             if ind.contains("mp4") {
                 let url:URL = URL(string: ind)!

                 let player = AVPlayer.init(url: url)
                 let playerVC = AVPlayerViewController()
                 playerVC.player = player
                 self.present(playerVC, animated: true) {
                     playerVC.player?.play()
                 }
             }
         }
     }
     func createThumbnailOfVideoFromRemoteUrl(url: String) -> UIImage? {
         let asset = AVAsset(url: URL(string: url)!)
         let assetImgGenerate = AVAssetImageGenerator(asset: asset)
         assetImgGenerate.appliesPreferredTrackTransform = true
         //Can set this to improve performance if target size is known before hand
         //assetImgGenerate.maximumSize = CGSize(width,height)
         let time = CMTimeMakeWithSeconds(1.0, preferredTimescale: 600)
         do {
             let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
             let thumbnail = UIImage(cgImage: img)
             return thumbnail
         } catch {
           print(error.localizedDescription)
           return nil
         }
     }
 }

 extension String {
     
     func toInt() -> Int {
         return Int(self) ?? 0
     }
 }

 
 */
