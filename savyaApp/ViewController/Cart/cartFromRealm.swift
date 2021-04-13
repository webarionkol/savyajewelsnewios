//
//  cartFromRealm.swift
//  savyaApp
//
//  Created by Yash on 2/12/20.
//  Copyright © 2020 Yash Rathod. All rights reserved.
//

import UIKit
import RealmSwift
import Kingfisher

class cartVC1:RootBaseVC,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView:subtableView!
    
    @IBOutlet weak var totalPriceLbl:UILabel!
    @IBOutlet weak var sgstLbl:UILabel!
    @IBOutlet weak var cgstLbl:UILabel!
    @IBOutlet weak var finalPriceLbl:UILabel!
    @IBOutlet weak var bottomTotalPrice:UILabel!
    @IBOutlet weak var menuBtn:UIButton!
    @IBOutlet weak var act:UIActivityIndicatorView!
    @IBOutlet weak var emptyImg:UIImageView!
    @IBOutlet weak var discountLbl:UILabel!
    @IBOutlet weak var serviceChargeLbl:UILabel!
    @IBOutlet weak var deliveryChargeLbl:UILabel!
    @IBOutlet weak var totalWeight:UILabel!
    @IBOutlet weak var backBtn:UIButton!
    
    let allList = try! Realm().objects(CartR.self)
    var wheree = ""
    var quty = [Int]()
    var carts = [Cart]()
    var allPrices = [Double]()
    var basePrice = [Double]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadAnimation()
        
        self.getAllData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.wheree == "prodetails" {
            self.menuBtn.setImage(UIImage(named: "backblack"), for: .normal)
        } else {
            
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.invalidateIntrinsicContentSize()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "proceed" {
            let dvc = segue.destination as! checkoutVC
            dvc.qty = self.quty
            dvc.cgstLbl = self.cgstLbl.text!
            dvc.sgstLbl = self.sgstLbl.text!
            dvc.totalPriceLbl = self.totalPriceLbl.text!
            dvc.finalPriceLbl = self.finalPriceLbl.text!
            
        }
    }
    @IBAction func back(_ sender:UIButton) {
        if self.menuBtn.imageView?.image == UIImage(named: "backblack") {
            self.dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func checkoutBtn(_ sender:UIButton) {
        var weight = 0.0
        let deliveryCharge = 800.0
        for i in self.carts {
            let count = Int(i.count)
            for j in i.assets {
                let weightt = Double(j.weight)
                weight += weightt! * Double(count!)
            }
        }
        
        print(weight)
        if weight >= 100 {
            if weight > 150 {
                let additinal = weight - 150.0
                let deliveryCalc = additinal * 3.0
                let deliveryTotal = deliveryCharge + deliveryCalc
                self.deliveryChargeLbl.text = "₹ " + "\(deliveryTotal)"
            } else {
                self.deliveryChargeLbl.text = "₹ " + "\(deliveryCharge)"
            }
        } else {
            self.showAlert(titlee: "Message", message: "Your order should be minimum 100 Grams")
        }
       self.performSegue(withIdentifier: "proceed", sender: self)
    }
    @IBAction func applyOCupon(_ sender:UIButton) {
           
        let alert = UIAlertController(title: "Message", message: "Please enter Coupon Code", preferredStyle: .alert)
        alert.addTextField { (txt) in
            txt.placeholder = "Enter Coupon Code"
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
               
            var total = 0.0
            for i in self.allPrices {
                total += i
            }
            self.calculateTotalPriceDiscount(total: self.calculatePriceCode(total: Float(total)))
            
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (_) in
               
        }))
           
        self.present(alert, animated: true, completion: nil)
    }
    func calculatePriceCode(total:Float) -> Float {
        
        
        let discounted = total - 0.2 * total
        return discounted
    }
    func calculateTotalPriceDiscount(total:Float) {
        let allTemp = self.allPrices.uniques
        if allTemp.count == self.carts.count {
            
            self.totalPriceLbl.text = "₹ " + String(format: "%.2f", total)
            
            
            self.sgstLbl.text = "₹ " + String(self.calculateSGST(total: Double(total)).rounded())
            self.cgstLbl.text = "₹ " + String(self.calculateCGST(total: Double(total)).rounded())
            self.finalPriceLbl.text = "₹ " + String(format: "%.2f", self.calculateSGST(total: Double(total)) + self.calculateCGST(total: Double(total)) + Double(total))
            self.bottomTotalPrice.text = "₹ " + String(format: "%.2f", self.calculateSGST(total: Double(total)) + self.calculateCGST(total: Double(total)) + Double(total))
        }
    }
    @objc func saveforlatter(_ sender:UIButton) {
        APIManager.shareInstance.addwishlist(product_id: "\(sender.tag)", vc: self) { (response) in
            if response == "success" {
                self.view.makeToast("Added in wishlist")
            }
        }
    }
    func getAllData() {
        APIManager.shareInstance.viewCart(user_id: Mobile.getUid(), vc: self) { (allPro) in
            if allPro.count == 0 {
                self.emptyImg.isHidden = false
                self.emptyImg.image = UIImage(named:"present")
                self.tableView.isHidden = true
                self.removeAnimation()
            } else {
                self.emptyImg.isHidden = true
                self.tableView.isHidden = false
                self.carts.removeAll()
                self.allPrices.removeAll()
                self.basePrice.removeAll()
                self.carts = allPro
                for _ in 0 ..< self.carts.count {
                    self.quty.append(1)
                }
                self.tableView.reloadData()
                self.tableView.invalidateIntrinsicContentSize()
                self.act.isHidden = true
                self.act.stopAnimating()
                self.removeAnimation()
            }
            
            
        }
    }
    func strToFloat(str:String) -> Float {
        return str.floatValue
    }
    func calculateTotalPrice() {
        let allTemp = self.allPrices.uniques
        
        if allTemp.count == self.allList.count {
            var total = 0.0
            let deilveryCharge = 800.0
            for i in self.allPrices {
                total += i
            }
            let serviceCharge = total / 100
            self.serviceChargeLbl.text = "₹ " + String(format: "%.2f", total / 100)
            self.totalPriceLbl.text = "₹ " + String(format: "%.2f", total)
            self.sgstLbl.text = "₹ " + String(self.calculateSGST(total: total).rounded(toPlaces: 2))
            self.cgstLbl.text = "₹ " + String(self.calculateCGST(total: total).rounded(toPlaces: 2))
            self.finalPriceLbl.text = "₹ " + String(format: "%.2f", self.calculateSGST(total: total) + self.calculateCGST(total: total) + total + serviceCharge + deilveryCharge)
            self.bottomTotalPrice.text = "₹ " + String(format: "%.2f", self.calculateSGST(total: total) + self.calculateCGST(total: total) + total + serviceCharge + deilveryCharge)
            
            var weight = 0.0
            
            for i in 0 ..< self.allList.count {
                let count = self.quty[i]
                for j in self.allList[i].assets {
                    let weightt = Double(j.weight)
                    weight += weightt! * Double(count)
                }
            }
            if weight >= 100 {
                if weight > 150 {
                    let additinal = weight - 150.0
                    let deliveryCalc = additinal * 3.0
                    let deliveryTotal = deilveryCharge + deliveryCalc
                    self.deliveryChargeLbl.text = "₹ " + String(format: "%.2f", deliveryTotal)
                } else {
                    self.deliveryChargeLbl.text = "₹ " + String(format: "%.2f", deilveryCharge)
                }
            } else {
                self.showAlert(titlee: "Message", message: "Your order should be minimum 100 Grams")
            }
           // self.deliveryChargeLbl.text = "₹ " + "\(deilveryCharge)"
            self.totalWeight.text = String(format: "%.2f", weight) + " g"
        }
    }
    func calculateCGST(total:Double) -> Double {
        return total * 1.5 / 100
    }
    func calculateSGST(total:Double) -> Double {
        return total * 1.5 / 100
    }
    func removeFromCart(pid:Int) {
        self.act.isHidden = false
        self.act.startAnimating()
        APIManager.shareInstance.removeCart(productId: self.carts[pid].productID, vc: self) { (response) in
            if response == "success" {
                self.getAllData()
                
            }
        }
    }
    @objc func removeFromArr(_ sender:UIButton) {
       // self.allPrices.remove(at: sender.tag)
     //   self.basePrice.remove(at: sender.tag)
     //   self.carts.remove(at: sender.tag)
        self.removeFromCart(pid: sender.tag)
    }
    @objc func plusBtn(_ sender:UIButton) {
        let cell = self.tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! cartCell
        let price = self.basePrice[sender.tag]
        let cellPrice = self.allPrices[sender.tag]
        let totalNew = Float(cellPrice) + Float(price)
        let quantityLbl = Int(cell.quantityLbl.text!)
        let newQuantity = quantityLbl! + 1
        self.quty[sender.tag] = newQuantity
        cell.quantityLbl.text = String(newQuantity)
        cell.priceLbl.text = "₹ " + String(totalNew)
        self.allPrices[sender.tag] = Double(totalNew)
        
        let realm = try! Realm()
        
        let c1 = CartR()
        c1.count = String(newQuantity)
        
        c1.productType = self.allList[sender.tag].productType
        c1.productName = self.allList[sender.tag].productName
        c1.productID = self.allList[sender.tag].productID
        c1.id = self.allList[sender.tag].id
        c1.category = self.allList[sender.tag].category
        c1.subCategory = self.allList[sender.tag].subCategory
        c1.subSubCategory = self.allList[sender.tag].subSubCategory
        c1.assets = self.allList[sender.tag].assets
        c1.userID = self.allList[sender.tag].userID
        c1.welcomeDescription = self.allList[sender.tag].welcomeDescription
        
        try! realm.write {
            realm.add(c1, update: .all)
        }
        self.calculateTotalPrice()
    }
    @objc func minusBtn(_ sender:UIButton) {
        let cell = self.tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! cartCell
        let quantityLbl = Int(cell.quantityLbl.text!)
        if quantityLbl! != 1 {
            let price = self.basePrice[sender.tag]
            let cellPrice = self.allPrices[sender.tag]
            let totalNew = Float(cellPrice) - Float(price)
            
            let newQuantity = quantityLbl! - 1
            self.quty[sender.tag] = newQuantity
            cell.quantityLbl.text = String(newQuantity)
            cell.priceLbl.text = "₹ " + String(totalNew)
            self.allPrices[sender.tag] = Double(totalNew)
            
            
            let realm = try! Realm()
            let c1 = CartR()
            c1.count = String(newQuantity)
            
            c1.productType = self.allList[sender.tag].productType
            c1.productName = self.allList[sender.tag].productName
            c1.productID = self.allList[sender.tag].productID
            c1.id = self.allList[sender.tag].id
            c1.category = self.allList[sender.tag].category
            c1.subCategory = self.allList[sender.tag].subCategory
            c1.subSubCategory = self.allList[sender.tag].subSubCategory
            c1.assets = self.allList[sender.tag].assets
            c1.userID = self.allList[sender.tag].userID
            c1.welcomeDescription = self.allList[sender.tag].welcomeDescription
            
            try! realm.write {
                realm.add(c1, update: .all)
            }
            
            self.calculateTotalPrice()
        }
        
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! cartCell
        let indCart = self.allList[indexPath.row]
        cell.btnminus.layer.cornerRadius = cell.btnminus.frame.height / 2
        cell.btnminus.clipsToBounds = true
        cell.btnPlus.layer.cornerRadius = cell.btnPlus.frame.height / 2
        cell.btnPlus.clipsToBounds = true
        cell.btnPlus.tag = indexPath.row
        cell.btnminus.tag = indexPath.row
        cell.img.kf.indicatorType = .activity
        cell.img.kf.setImage(with: URL(string: indCart.image),placeholder: nil,options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
                       switch result {
                       case .success(let value):
                           print("Task done for: \(value.source.url?.absoluteString ?? "")")
                           
                       case .failure(let error):
                           print("Job failed: \(error.localizedDescription)")
                           
                       }
                   }
        cell.saveForLatterBtn.tag = Int(indCart.productID)!
        cell.saveForLatterBtn.addTarget(self, action: #selector(saveforlatter(_:)), for: .touchUpInside)
        cell.lblname.text = indCart.productName
        cell.btnPlus.tag = indexPath.row
        cell.btnPlus.addTarget(self, action: #selector(plusBtn(_:)), for: .touchUpInside)
        cell.btnminus.tag = indexPath.row
        cell.btnminus.addTarget(self, action: #selector(minusBtn(_:)), for: .touchUpInside)
        cell.removeBtn.tag = indexPath.row
        cell.removeBtn.addTarget(self, action: #selector(removeFromArr(_:)), for: .touchUpInside)
        if indCart.assets.count == 1 {
            cell.view11.isHidden = false
            cell.view22.isHidden = true
            cell.view33.isHidden = true
            
            if indCart.assets.count > 0 {
                cell.goldLbl1.text = indCart.assets[0].metal
                cell.goldLbl2.text = indCart.assets[0].materialType
                cell.goldLbl3.text = indCart.assets[0].weight + "g"
                           
            }
            
           
            if indCart.assets[0].metal == "Gold" {
                cell.priceLbl.text = "₹ " + String(Utils.calculatePrice(type: "Gold", weight: indCart.assets[0].weight.floatValue, rate: GoldPrice.sharedInstance.getpriceByGoldPrice(gold_type: indCart.assets[0].materialType).floatValue, makingCharge: indCart.assets[0].makingCharge.floatValue, option: indCart.assets[0].options, goldValue: GoldPrice.sharedInstance.getValueByGoldPrice(gold_type: indCart.assets[0].materialType), gold24k: GoldPrice.sharedInstance.getpriceByGoldPrice(gold_type: "24K").floatValue))
               // cell.priceLbl.text = "₹ " + String(Utils.calculatePrice(weight: indCart.assets[0].weight.floatValue, rate: GoldPrice.sharedInstance.getpriceByGoldPrice(gold_type: indCart.assets[0].materialType).floatValue, makingCharge: indCart.assets[0].makingCharge.floatValue, isPerGram: true))
                
                if self.allPrices.count == self.carts.count {
                    
                } else {
                    
                    self.allPrices.append(Utils.calculatePrice(type: "Gold", weight: indCart.assets[0].weight.floatValue, rate: GoldPrice.sharedInstance.getpriceByGoldPrice(gold_type: indCart.assets[0].materialType).floatValue, makingCharge: indCart.assets[0].makingCharge.floatValue, option: indCart.assets[0].options, goldValue: GoldPrice.sharedInstance.getValueByGoldPrice(gold_type: indCart.assets[0].materialType), gold24k: GoldPrice.sharedInstance.getpriceByGoldPrice(gold_type: "24K").floatValue))
                    
                   // self.allPrices.append(Utils.calculatePrice(weight: indCart.assets[0].weight.floatValue, rate: GoldPrice.sharedInstance.getpriceByGoldPrice(gold_type: indCart.assets[0].materialType).floatValue, makingCharge: indCart.assets[0].makingCharge.floatValue, isPerGram: true))
                    
                    self.basePrice.append(Utils.calculatePrice(type: "Gold", weight: indCart.assets[0].weight.floatValue, rate: GoldPrice.sharedInstance.getpriceByGoldPrice(gold_type: indCart.assets[0].materialType).floatValue, makingCharge: indCart.assets[0].makingCharge.floatValue, option: indCart.assets[0].options, goldValue: GoldPrice.sharedInstance.getValueByGoldPrice(gold_type: indCart.assets[0].materialType), gold24k: GoldPrice.sharedInstance.getpriceByGoldPrice(gold_type: "24K").floatValue))
                    
                  //  self.basePrice.append(Utils.calculatePrice(weight: indCart.assets[0].weight.floatValue, rate: GoldPrice.sharedInstance.getpriceByGoldPrice(gold_type: indCart.assets[0].materialType).floatValue, makingCharge: indCart.assets[0].makingCharge.floatValue, isPerGram: true))
                }
                
            } else if indCart.assets[0].metal == "Diamond" {
                
                
                cell.priceLbl.text = "₹ " + String(Utils.calculatePrice(type: "Diamond", weight: indCart.assets[0].weight.floatValue, rate: DiamondMaster.sharedInstance.getpriceByDiamondName(name: indCart.assets[0].materialType,color: indCart.assets[0].materialType).floatValue, makingCharge: indCart.assets[0].makingCharge.floatValue, option: indCart.assets[0].options, goldValue: 0.0, gold24k: 0.0))
                
              //  cell.priceLbl.text = "₹ " + String(Utils.calculatePrice(weight: indCart.assets[0].weight.floatValue, rate: DiamondMaster.sharedInstance.getpriceByDiamondName(name: indCart.assets[0].materialType).floatValue, makingCharge: indCart.assets[0].makingCharge.floatValue, isPerGram: true))
                if self.allPrices.count == self.carts.count {
                    
                } else {
                    
                    self.allPrices.append((Utils.calculatePrice(type: "Diamond", weight: indCart.assets[0].weight.floatValue, rate: DiamondMaster.sharedInstance.getpriceByDiamondName(name: indCart.assets[0].materialType,color: indCart.assets[0].materialType).floatValue, makingCharge: indCart.assets[0].makingCharge.floatValue, option: indCart.assets[0].options, goldValue: 0.0, gold24k: 0.0)))
                    
              //  self.allPrices.append(Utils.calculatePrice(weight: indCart.assets[0].weight.floatValue, rate: DiamondMaster.sharedInstance.getpriceByDiamondName(name: indCart.assets[0].materialType).floatValue, makingCharge: indCart.assets[0].makingCharge.floatValue, isPerGram: true))
                    
                    self.basePrice.append(Utils.calculatePrice(type: "Diamond", weight: indCart.assets[0].weight.floatValue, rate: DiamondMaster.sharedInstance.getpriceByDiamondName(name: indCart.assets[0].materialType,color: indCart.assets[0].materialType).floatValue, makingCharge: indCart.assets[0].makingCharge.floatValue, option: indCart.assets[0].options, goldValue: 0.0, gold24k: 0.0))
                
         //       self.basePrice.append(Utils.calculatePrice(weight: indCart.assets[0].weight.floatValue, rate: DiamondMaster.sharedInstance.getpriceByDiamondName(name: indCart.assets[0].materialType).floatValue, makingCharge: indCart.assets[0].makingCharge.floatValue, isPerGram: true))
                }
            } else if indCart.assets[0].metal == "Stone" {
                cell.priceLbl.text = "₹ " + String(Utils.calculatePrice(type: "Stone", weight: indCart.assets[0].weight.floatValue, rate: StonePrice.sharedInstance.getpriceByStoneprice(stone_type: indCart.assets[0].materialType).floatValue, makingCharge: indCart.assets[0].makingCharge.floatValue, option: indCart.assets[0].options, goldValue: 0.0, gold24k: 0.0))
                if self.allPrices.count == self.carts.count {
                    
                } else {
                    self.allPrices.append(Utils.calculatePrice(type: "Stone", weight: indCart.assets[0].weight.floatValue, rate: StonePrice.sharedInstance.getpriceByStoneprice(stone_type: indCart.assets[0].materialType).floatValue, makingCharge: indCart.assets[0].makingCharge.floatValue, option: indCart.assets[0].options, goldValue: 0.0, gold24k: 0.0))
                
                    self.basePrice.append(Utils.calculatePrice(type: "Stone", weight: indCart.assets[0].weight.floatValue, rate: StonePrice.sharedInstance.getpriceByStoneprice(stone_type: indCart.assets[0].materialType).floatValue, makingCharge: indCart.assets[0].makingCharge.floatValue, option: indCart.assets[0].options, goldValue: 0.0, gold24k: 0.0))
                }
            } else if indCart.assets[0].metal == "Platinum" {
                cell.priceLbl.text = "₹ " + String(Utils.calculatePrice(type: "Platinum", weight: indCart.assets[0].weight.floatValue, rate: PlatinumPrice.sharedInstance.getpriceByPlatinumName(platinum_type: "Platinum").floatValue, makingCharge: indCart.assets[0].makingCharge.floatValue, option: indCart.assets[0].options, goldValue: 0.0, gold24k: 0.0))
                if self.allPrices.count == self.carts.count {
                    
                } else {
                    self.allPrices.append(Utils.calculatePrice(type: "Platinum", weight: indCart.assets[0].weight.floatValue, rate: PlatinumPrice.sharedInstance.getpriceByPlatinumName(platinum_type: "Platinum").floatValue, makingCharge: indCart.assets[0].makingCharge.floatValue, option: indCart.assets[0].options, goldValue: 0.0, gold24k: 0.0))
                
                    self.basePrice.append(Utils.calculatePrice(type: "Platinum", weight: indCart.assets[0].weight.floatValue, rate: PlatinumPrice.sharedInstance.getpriceByPlatinumName(platinum_type: "Platinum").floatValue, makingCharge: indCart.assets[0].makingCharge.floatValue, option: indCart.assets[0].options, goldValue: 0.0, gold24k: 0.0))
                }
            }
            
            
        } else if indCart.assets.count == 2 {
            cell.view11.isHidden = false
            cell.view22.isHidden = false
            cell.view33.isHidden = true
            
            cell.goldLbl1.text = indCart.assets[0].metal
            cell.goldLbl2.text = indCart.assets[0].materialType
            cell.goldLbl3.text = indCart.assets[0].weight + "g"
            
            cell.diamondLbl1.text = indCart.assets[1].metal
            cell.diamondLbl2.text = indCart.assets[1].materialType
            cell.diamondLbl3.text = indCart.assets[1].weight
            
            var finalPrice1 = 0.0
            var finalPrice2 = 0.0
            
            if indCart.assets[0].metal == "Gold" {
                
                cell.priceLbl.text = "₹ " + String(Utils.calculatePrice(type: "Gold", weight: indCart.assets[0].weight.floatValue, rate: GoldPrice.sharedInstance.getpriceByGoldPrice(gold_type: indCart.assets[0].materialType).floatValue, makingCharge: indCart.assets[0].makingCharge.floatValue, option: indCart.assets[0].options, goldValue: GoldPrice.sharedInstance.getValueByGoldPrice(gold_type: indCart.assets[0].materialType), gold24k: GoldPrice.sharedInstance.getpriceByGoldPrice(gold_type: "24K").floatValue))
                
                
             //   cell.priceLbl.text = "₹ " + String(Utils.calculatePrice(weight: indCart.assets[0].weight.floatValue, rate: GoldPrice.sharedInstance.getpriceByGoldPrice(gold_type: indCart.assets[0].materialType).floatValue, makingCharge: indCart.assets[0].makingCharge.floatValue, isPerGram: true))
                
                
                finalPrice1 = Utils.calculatePrice(type: "Gold", weight: indCart.assets[0].weight.floatValue, rate: GoldPrice.sharedInstance.getpriceByGoldPrice(gold_type: indCart.assets[0].materialType).floatValue, makingCharge: indCart.assets[0].makingCharge.floatValue, option: indCart.assets[0].options, goldValue: GoldPrice.sharedInstance.getValueByGoldPrice(gold_type: indCart.assets[0].materialType), gold24k: GoldPrice.sharedInstance.getpriceByGoldPrice(gold_type: "24K").floatValue)
                
                
            } else if indCart.assets[0].metal == "Diamond" {
                cell.priceLbl.text = "₹ " + String(Utils.calculatePrice(type: "Diamond", weight: indCart.assets[0].weight.floatValue, rate: DiamondMaster.sharedInstance.getpriceByDiamondName(name: indCart.assets[0].materialType,color: indCart.assets[0].materialType).floatValue, makingCharge: indCart.assets[0].makingCharge.floatValue, option: indCart.assets[0].options,goldValue: 0.0,gold24k: 0.0))
                
                finalPrice1 = Utils.calculatePrice(type: "Diamond", weight: indCart.assets[0].weight.floatValue, rate: DiamondMaster.sharedInstance.getpriceByDiamondName(name: indCart.assets[0].materialType,color: indCart.assets[0].materialType).floatValue, makingCharge: indCart.assets[0].makingCharge.floatValue, option: indCart.assets[0].options,goldValue: 0.0,gold24k: 0.0)
                
            } else if indCart.assets[0].metal == "Stone" {
                cell.priceLbl.text = "₹ " + String(Utils.calculatePrice(type: "Stone", weight: indCart.assets[0].weight.floatValue, rate: StonePrice.sharedInstance.getpriceByStoneprice(stone_type: indCart.assets[0].materialType).floatValue, makingCharge: indCart.assets[0].makingCharge.floatValue, option: indCart.assets[0].options,goldValue: 0.0,gold24k: 0.0))
                
                finalPrice1 = Utils.calculatePrice(type: "Stone", weight: indCart.assets[0].weight.floatValue, rate: StonePrice.sharedInstance.getpriceByStoneprice(stone_type: indCart.assets[0].materialType).floatValue, makingCharge: indCart.assets[0].makingCharge.floatValue, option: indCart.assets[0].options,goldValue: 0.0,gold24k: 0.0)
                
            } else if indCart.assets[0].metal == "Platinum" {
                cell.priceLbl.text = "₹ " + String(Utils.calculatePrice(type: "Platinum", weight: indCart.assets[0].weight.floatValue, rate: PlatinumPrice.sharedInstance.getpriceByPlatinumName(platinum_type: "Platinum").floatValue, makingCharge: indCart.assets[0].makingCharge.floatValue, option: indCart.assets[0].options,goldValue: 0.0,gold24k: 0.0))
                
                finalPrice1 = Utils.calculatePrice(type: "Platinum", weight: indCart.assets[0].weight.floatValue, rate: PlatinumPrice.sharedInstance.getpriceByPlatinumName(platinum_type: "Platinum").floatValue, makingCharge: indCart.assets[0].makingCharge.floatValue, option: indCart.assets[0].options,goldValue: 0.0,gold24k: 0.0)
            }
            
            
            
            if indCart.assets[1].metal == "Gold" {
                cell.priceLbl.text = "₹ " + String(Utils.calculatePrice(type: "Gold", weight: indCart.assets[1].weight.floatValue, rate: GoldPrice.sharedInstance.getpriceByGoldPrice(gold_type: indCart.assets[1].materialType).floatValue, makingCharge: indCart.assets[1].makingCharge.floatValue, option: indCart.assets[1].options,goldValue: GoldPrice.sharedInstance.getValueByGoldPrice(gold_type: indCart.assets[1].materialType),gold24k: GoldPrice.sharedInstance.getpriceByGoldPrice(gold_type: "24K").floatValue))
                
                finalPrice2 = Utils.calculatePrice(type: "Gold", weight: indCart.assets[1].weight.floatValue, rate: GoldPrice.sharedInstance.getpriceByGoldPrice(gold_type: indCart.assets[1].materialType).floatValue, makingCharge: indCart.assets[1].makingCharge.floatValue, option: indCart.assets[1].options,goldValue: GoldPrice.sharedInstance.getValueByGoldPrice(gold_type: indCart.assets[1].materialType),gold24k: GoldPrice.sharedInstance.getpriceByGoldPrice(gold_type: "24K").floatValue)
                
                if self.allPrices.count == self.carts.count {
                    
                } else {
                self.allPrices.append(finalPrice2 + finalPrice1)
                self.basePrice.append(finalPrice2 + finalPrice1)
                }
                cell.priceLbl.text = "₹ " + String(finalPrice2 + finalPrice1)
            } else if indCart.assets[1].metal == "Diamond" {
                cell.priceLbl.text = "₹ " + String(Utils.calculatePrice(type: "Diamond", weight: indCart.assets[1].weight.floatValue, rate: DiamondMaster.sharedInstance.getpriceByDiamondName(name: indCart.assets[1].materialType,color: indCart.assets[1].materialType).floatValue, makingCharge: indCart.assets[1].makingCharge.floatValue, option: indCart.assets[1].options,goldValue: 0.0,gold24k: 0.0))
                finalPrice2 = Utils.calculatePrice(type: "Diamond", weight: indCart.assets[1].weight.floatValue, rate: DiamondMaster.sharedInstance.getpriceByDiamondName(name: indCart.assets[1].materialType,color: indCart.assets[1].materialType).floatValue, makingCharge: indCart.assets[1].makingCharge.floatValue, option: indCart.assets[1].options,goldValue: 0.0,gold24k: 0.0)
                cell.priceLbl.text = "₹ " + String(finalPrice2 + finalPrice1)
                if self.allPrices.count == self.carts.count {
                    
                } else {
                self.allPrices.append(finalPrice2 + finalPrice1)
                self.basePrice.append(finalPrice2 + finalPrice1)
                }
            } else if indCart.assets[1].metal == "Stone" {
                cell.priceLbl.text = "₹ " + String(Utils.calculatePrice(type: "Stone", weight: indCart.assets[1].weight.floatValue, rate: StonePrice.sharedInstance.getpriceByStoneprice(stone_type: indCart.assets[1].materialType).floatValue, makingCharge: indCart.assets[1].makingCharge.floatValue, option: indCart.assets[1].options,goldValue: 0.0,gold24k: 0.0))
                
                finalPrice2 = Utils.calculatePrice(type: "Stone", weight: indCart.assets[1].weight.floatValue, rate: StonePrice.sharedInstance.getpriceByStoneprice(stone_type: indCart.assets[1].materialType).floatValue, makingCharge: indCart.assets[1].makingCharge.floatValue,option: indCart.assets[1].options,goldValue: 0.0,gold24k: 0.0)
                cell.priceLbl.text = "₹ " + String(finalPrice2 + finalPrice1)
                if self.allPrices.count == self.carts.count {
                    
                } else {
                self.allPrices.append(finalPrice2 + finalPrice1)
                self.basePrice.append(finalPrice2 + finalPrice1)
                }
            } else if indCart.assets[1].metal == "Platinum" {
                cell.priceLbl.text = "₹ " + String(Utils.calculatePrice(type: "Platinum", weight: indCart.assets[1].weight.floatValue, rate: PlatinumPrice.sharedInstance.getpriceByPlatinumName(platinum_type: "Platinum").floatValue, makingCharge: indCart.assets[1].makingCharge.floatValue,option: indCart.assets[1].options,goldValue: 0.0,gold24k: 0.0))
                
                
                finalPrice2 = Utils.calculatePrice(type: "Platinum", weight: indCart.assets[1].weight.floatValue, rate: PlatinumPrice.sharedInstance.getpriceByPlatinumName(platinum_type: "Platinum").floatValue, makingCharge: indCart.assets[1].makingCharge.floatValue,option: indCart.assets[1].options,goldValue: 0.0,gold24k: 0.0)
                cell.priceLbl.text = "₹ " + String(finalPrice2 + finalPrice1)
                if self.allPrices.count == self.carts.count {
                    
                } else {
                self.allPrices.append(finalPrice2 + finalPrice1)
                self.basePrice.append(finalPrice2 + finalPrice1)
                }
            }
            
        } else {
            cell.view11.isHidden = false
            cell.view22.isHidden = false
            cell.view33.isHidden = false
            
            if indCart.assets.count > 0 {
                cell.goldLbl1.text = indCart.assets[0].metal
                cell.goldLbl2.text = indCart.assets[0].materialType
                cell.goldLbl3.text = indCart.assets[0].weight
                           
                cell.diamondLbl1.text = indCart.assets[1].metal
                cell.diamondLbl2.text = indCart.assets[1].materialType
                cell.diamondLbl3.text = indCart.assets[1].weight
                           
                cell.stoneLbl1.text = indCart.assets[2].metal
                cell.stoneLbl2.text = indCart.assets[2].materialType
                cell.stoneLbl3.text = indCart.assets[2].weight
            }
           
            
            var finalPrice1 = 0.0
            var finalPrice2 = 0.0
            var finalPrice3 = 0.0
            
            
            
            if indCart.assets[0].metal == "Gold" {
                cell.priceLbl.text = "₹ " + String(Utils.calculatePrice(type: "Gold", weight: indCart.assets[0].weight.floatValue, rate: GoldPrice.sharedInstance.getpriceByGoldPrice(gold_type: indCart.assets[0].materialType).floatValue, makingCharge: indCart.assets[0].makingCharge.floatValue, option: indCart.assets[0].options,goldValue: GoldPrice.sharedInstance.getValueByGoldPrice(gold_type: indCart.assets[0].materialType),gold24k: GoldPrice.sharedInstance.getpriceByGoldPrice(gold_type: "24K").floatValue))
                
                finalPrice1 = Utils.calculatePrice(type: "Gold", weight: indCart.assets[0].weight.floatValue, rate: GoldPrice.sharedInstance.getpriceByGoldPrice(gold_type: indCart.assets[0].materialType).floatValue, makingCharge: indCart.assets[0].makingCharge.floatValue,  option: indCart.assets[0].options,goldValue: GoldPrice.sharedInstance.getValueByGoldPrice(gold_type: indCart.assets[0].materialType),gold24k: GoldPrice.sharedInstance.getpriceByGoldPrice(gold_type: "24K").floatValue)
                
            } else if indCart.assets[0].metal == "Diamond" {
                cell.priceLbl.text = "₹ " + String(Utils.calculatePrice(type: "Diamond", weight: indCart.assets[0].weight.floatValue, rate: DiamondMaster.sharedInstance.getpriceByDiamondName(name: indCart.assets[0].materialType,color: indCart.assets[0].materialType).floatValue, makingCharge: indCart.assets[0].makingCharge.floatValue,option: indCart.assets[0].options,goldValue: 0.0,gold24k: 0.0))
                finalPrice1 = Utils.calculatePrice(type: "Diamond", weight: indCart.assets[0].weight.floatValue, rate: DiamondMaster.sharedInstance.getpriceByDiamondName(name: indCart.assets[0].materialType,color: indCart.assets[0].materialType).floatValue, makingCharge: indCart.assets[0].makingCharge.floatValue, option: indCart.assets[0].options,goldValue: 0.0,gold24k: 0.0)
            } else if indCart.assets[0].metal == "Stone" {
                cell.priceLbl.text = "₹ " + String(Utils.calculatePrice(type: "Stone", weight: indCart.assets[0].weight.floatValue, rate: StonePrice.sharedInstance.getpriceByStoneprice(stone_type: indCart.assets[0].materialType).floatValue, makingCharge: indCart.assets[0].makingCharge.floatValue, option: indCart.assets[0].options,goldValue: 0.0,gold24k: 0.0))
                finalPrice1 = Utils.calculatePrice(type: "Stone", weight: indCart.assets[0].weight.floatValue, rate: StonePrice.sharedInstance.getpriceByStoneprice(stone_type: indCart.assets[0].materialType).floatValue, makingCharge: indCart.assets[0].makingCharge.floatValue, option: indCart.assets[0].options,goldValue: 0.0,gold24k: 0.0)
            } else if indCart.assets[0].metal == "Platinum" {
                cell.priceLbl.text = "₹ " + String(Utils.calculatePrice(type: "Platinum", weight: indCart.assets[0].weight.floatValue, rate: PlatinumPrice.sharedInstance.getpriceByPlatinumName(platinum_type: "Platinum").floatValue, makingCharge: indCart.assets[0].makingCharge.floatValue, option: indCart.assets[0].options,goldValue: 0.0,gold24k: 0.0))
                finalPrice1 = Utils.calculatePrice(type: "Platinum", weight: indCart.assets[0].weight.floatValue, rate: PlatinumPrice.sharedInstance.getpriceByPlatinumName(platinum_type: "Platinum").floatValue, makingCharge: indCart.assets[0].makingCharge.floatValue, option: indCart.assets[0].options,goldValue: 0.0,gold24k: 0.0)
            }
            
            
            if indCart.assets[1].metal == "Gold" {
                cell.priceLbl.text = "₹ " + String(Utils.calculatePrice(type: "Gold", weight: indCart.assets[1].weight.floatValue, rate: GoldPrice.sharedInstance.getpriceByGoldPrice(gold_type: indCart.assets[1].materialType).floatValue, makingCharge: indCart.assets[1].makingCharge.floatValue, option: indCart.assets[1].options,goldValue: GoldPrice.sharedInstance.getValueByGoldPrice(gold_type: indCart.assets[1].materialType),gold24k: GoldPrice.sharedInstance.getpriceByGoldPrice(gold_type: "24K").floatValue))
                
                finalPrice2 = Utils.calculatePrice(type: "Gold", weight: indCart.assets[1].weight.floatValue, rate: GoldPrice.sharedInstance.getpriceByGoldPrice(gold_type: indCart.assets[1].materialType).floatValue, makingCharge: indCart.assets[1].makingCharge.floatValue, option: indCart.assets[1].options,goldValue: GoldPrice.sharedInstance.getValueByGoldPrice(gold_type: indCart.assets[1].materialType),gold24k: GoldPrice.sharedInstance.getpriceByGoldPrice(gold_type: "24K").floatValue)
                
                cell.priceLbl.text = String(finalPrice2 + finalPrice1)
            } else if indCart.assets[1].metal == "Diamond" {
                cell.priceLbl.text = "₹ " + String(Utils.calculatePrice(type: "Diamond", weight: indCart.assets[1].weight.floatValue, rate: DiamondMaster.sharedInstance.getpriceByDiamondName(name: indCart.assets[1].materialType,color: indCart.assets[1].materialType).floatValue, makingCharge: indCart.assets[1].makingCharge.floatValue,option: indCart.assets[1].options,goldValue: 0.0,gold24k: 0.0))
                finalPrice2 = Utils.calculatePrice(type: "Diamond", weight: indCart.assets[1].weight.floatValue, rate: DiamondMaster.sharedInstance.getpriceByDiamondName(name: indCart.assets[1].materialType,color: indCart.assets[1].materialType).floatValue, makingCharge: indCart.assets[1].makingCharge.floatValue, option: indCart.assets[1].options,goldValue: 0.0,gold24k: 0.0)
                cell.priceLbl.text = String(finalPrice2 + finalPrice1)
            } else if indCart.assets[1].metal == "Stone" {
                cell.priceLbl.text = "₹ " + String(Utils.calculatePrice(type: "Stone", weight: indCart.assets[1].weight.floatValue, rate: StonePrice.sharedInstance.getpriceByStoneprice(stone_type: indCart.assets[1].materialType).floatValue, makingCharge: indCart.assets[1].makingCharge.floatValue, option: indCart.assets[1].options,goldValue: 0.0,gold24k: 0.0))
                
                finalPrice2 = Utils.calculatePrice(type: "Stone", weight: indCart.assets[1].weight.floatValue, rate: StonePrice.sharedInstance.getpriceByStoneprice(stone_type: indCart.assets[1].materialType).floatValue, makingCharge: indCart.assets[1].makingCharge.floatValue, option: indCart.assets[1].options,goldValue: 0.0,gold24k: 0.0)
                
                cell.priceLbl.text = String(finalPrice2 + finalPrice1)
            } else if indCart.assets[1].metal == "Platinum" {
                cell.priceLbl.text = "₹ " + String(Utils.calculatePrice(type: "Platinum", weight: indCart.assets[1].weight.floatValue, rate: PlatinumPrice.sharedInstance.getpriceByPlatinumName(platinum_type: "Platinum").floatValue, makingCharge: indCart.assets[1].makingCharge.floatValue, option: indCart.assets[1].options,goldValue: 0.0,gold24k: 0.0))
                
                finalPrice2 = Utils.calculatePrice(type: "Platinum", weight: indCart.assets[1].weight.floatValue, rate: PlatinumPrice.sharedInstance.getpriceByPlatinumName(platinum_type: "Platinum").floatValue, makingCharge: indCart.assets[1].makingCharge.floatValue,option: indCart.assets[1].options,goldValue: 0.0,gold24k: 0.0)
                
                cell.priceLbl.text = String(finalPrice2 + finalPrice1)
            }
            
            
            if indCart.assets[2].metal == "Gold" {
                cell.priceLbl.text = "₹ " + String(Utils.calculatePrice(type: "Gold", weight: indCart.assets[2].weight.floatValue, rate: GoldPrice.sharedInstance.getpriceByGoldPrice(gold_type: indCart.assets[2].materialType).floatValue, makingCharge: indCart.assets[2].makingCharge.floatValue,  option: indCart.assets[2].options,goldValue: GoldPrice.sharedInstance.getValueByGoldPrice(gold_type: indCart.assets[2].materialType),gold24k: GoldPrice.sharedInstance.getpriceByGoldPrice(gold_type: "24K").floatValue))
                
                
                finalPrice3 = Utils.calculatePrice(type: "Gold", weight: indCart.assets[2].weight.floatValue, rate: GoldPrice.sharedInstance.getpriceByGoldPrice(gold_type: indCart.assets[2].materialType).floatValue, makingCharge: indCart.assets[2].makingCharge.floatValue,  option: indCart.assets[2].options,goldValue: GoldPrice.sharedInstance.getValueByGoldPrice(gold_type: indCart.assets[2].materialType),gold24k: GoldPrice.sharedInstance.getpriceByGoldPrice(gold_type: "24K").floatValue)
                cell.priceLbl.text = "₹ " + String(finalPrice2 + finalPrice1 + finalPrice3)
                if self.allPrices.count == self.carts.count {
                    
                } else {
                self.allPrices.append(finalPrice2 + finalPrice1 + finalPrice3)
                self.basePrice.append(finalPrice2 + finalPrice1 + finalPrice3)
                }
            } else if indCart.assets[2].metal == "Diamond" {
                cell.priceLbl.text = "₹ " + String(Utils.calculatePrice(type: "Diamond", weight: indCart.assets[2].weight.floatValue, rate: DiamondMaster.sharedInstance.getpriceByDiamondName(name: indCart.assets[2].materialType,color: indCart.assets[2].materialType).floatValue, makingCharge: indCart.assets[2].makingCharge.floatValue, option: indCart.assets[2].options,goldValue: 0.0,gold24k: 0.0))
                
                finalPrice3 = Utils.calculatePrice(type: "Diamond", weight: indCart.assets[2].weight.floatValue, rate: DiamondMaster.sharedInstance.getpriceByDiamondName(name: indCart.assets[2].materialType,color: indCart.assets[2].materialType).floatValue, makingCharge: indCart.assets[2].makingCharge.floatValue,option: indCart.assets[2].options,goldValue: 0.0,gold24k: 0.0)
                
                cell.priceLbl.text = "₹ " + String(finalPrice2 + finalPrice1 + finalPrice3)
                if self.allPrices.count == self.carts.count {
                    
                } else {
                self.allPrices.append(finalPrice2 + finalPrice1 + finalPrice3)
                self.basePrice.append(finalPrice2 + finalPrice1 + finalPrice3)
                }
            } else if indCart.assets[2].metal == "Stone" {
                cell.priceLbl.text = "₹ " + String(Utils.calculatePrice(type: "Stone", weight: indCart.assets[2].weight.floatValue, rate: StonePrice.sharedInstance.getpriceByStoneprice(stone_type: indCart.assets[2].materialType).floatValue, makingCharge: indCart.assets[2].makingCharge.floatValue, option: indCart.assets[2].options,goldValue: 0.0,gold24k: 0.0))
                
                finalPrice3 = Utils.calculatePrice(type: "Stone", weight: indCart.assets[2].weight.floatValue, rate: StonePrice.sharedInstance.getpriceByStoneprice(stone_type: indCart.assets[2].materialType).floatValue, makingCharge: indCart.assets[2].makingCharge.floatValue, option: indCart.assets[2].options,goldValue: 0.0,gold24k: 0.0)
                
                cell.priceLbl.text = "₹ " + String(finalPrice2 + finalPrice1 + finalPrice3)
                if self.allPrices.count == self.carts.count {
                    
                } else {
                self.allPrices.append(finalPrice2 + finalPrice1 + finalPrice3)
                self.basePrice.append(finalPrice2 + finalPrice1 + finalPrice3)
                }
            } else if indCart.assets[2].metal == "Platinum" {
                cell.priceLbl.text = "₹ " + String(Utils.calculatePrice(type: "Platinum", weight: indCart.assets[2].weight.floatValue, rate: PlatinumPrice.sharedInstance.getpriceByPlatinumName(platinum_type: "Platinum").floatValue, makingCharge: indCart.assets[2].makingCharge.floatValue,option: indCart.assets[2].options,goldValue: 0.0,gold24k: 0.0))
                
                finalPrice3 = Utils.calculatePrice(type: "Platinum", weight: indCart.assets[2].weight.floatValue, rate: PlatinumPrice.sharedInstance.getpriceByPlatinumName(platinum_type: "Platinum").floatValue, makingCharge: indCart.assets[2].makingCharge.floatValue, option: indCart.assets[2].options,goldValue: 0.0,gold24k: 0.0)
                
                cell.priceLbl.text = "₹ " + String(finalPrice2 + finalPrice1 + finalPrice3)
                if self.allPrices.count == self.carts.count {
                    
                } else {
                self.allPrices.append(finalPrice2 + finalPrice1 + finalPrice3)
                self.basePrice.append(finalPrice2 + finalPrice1 + finalPrice3)
                }
            }
        }
        self.calculateTotalPrice()
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190
    }
}
