//
//  cartfromAPIVC.swift
//  savyaApp
//
//  Created by Yash on 2/11/20.
//  Copyright © 2020 Yash Rathod. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import Kingfisher

class cartVC:RootBaseVC,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView:subtableView!
    
    @IBOutlet weak var tblheight: NSLayoutConstraint!
    @IBOutlet weak var btnEidt: UIButton!
    @IBOutlet weak var lblMainTitle: UILabel!
    @IBOutlet weak var btnPlaceorder: UIButton!
    @IBOutlet weak var viewNoData: UIView!
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
    
    @IBOutlet weak var lblPopTitle: UILabel!
    @IBOutlet weak var viewPOpup: UIView!
    var wheree = ""
    var quty = [Int]()
    var qty = [Int]()
    var carts = [Cart]()
    var allPrices = [Double]()
    var basePrice = [Double]()
    var totalprices = [Double]()
    var changeprice = [Double]()
    var displayweight = [Double]()
    var limit = Double()
    var islimit = false
    var indexs = 0
    var isEdit = false
    var changeweight = [[String:Any]]()
    var temparr = [[String:Any]]()
    var proid = 0
    var carid = 0
    var relode = 0
    var tempfile:Files?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadAnimation()
       // self.totalprices.removeAll()
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
    @IBAction func btnContinueShopping(_ sender: Any) {
        self.viewPOpup.isHidden = true
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "proceed" {
            let dvc = segue.destination as! checkoutVC
            dvc.qty = self.quty
            dvc.cgstLbl = self.cgstLbl.text!
            dvc.sgstLbl = self.sgstLbl.text!
            dvc.totalPriceLbl = self.totalPriceLbl.text!
            dvc.finalPriceLbl = self.finalPriceLbl.text!
            
        }else if segue.identifier == "update"{
            let dvc = segue.destination as! productDetailNewVC
            dvc.productId = proid
            dvc.cartid = carid
            dvc.iscame = 1
            dvc.tempFile = self.tempfile
           
        }
    }
    @IBAction func btnEidtClicked(_ sender: Any) {
        if isEdit == false {
            isEdit = true
            btnEidt.setTitle("Done", for: .normal)
        }else {
            isEdit = false
            btnEidt.setTitle("Edit", for: .normal)
        }
        allPrices.removeAll()
        totalprices.removeAll()
        changeprice.removeAll()
        
        tableView.reloadData()
    }
    @IBAction func back(_ sender:UIButton) {
       // if self.menuBtn.imageView?.image == UIImage(named: "backblack") {
            self.dismiss(animated: true, completion: nil)
       // }
    }
    @IBAction func checkoutBtn(_ sender:UIButton) {
        
        if islimit == true {
            
            self.viewPOpup.isHidden = false
            
            
        }else {
            self.viewPOpup.isHidden = true
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
            //if weight >= 100 {
                if weight > 150 {
                    let additinal = weight - 150.0
                    let deliveryCalc = additinal * 3.0
                    let deliveryTotal = deliveryCharge + deliveryCalc
                    self.deliveryChargeLbl.text = "₹ " + "\(deliveryTotal)"
                } else {
                    self.deliveryChargeLbl.text = "₹ " + "\(deliveryCharge)"
                }
           // } else {
           //     self.showAlert(titlee: "Message", message: "Your order should be minimum 100 Grams")
           // }
           self.performSegue(withIdentifier: "proceed", sender: self)
        }
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
        APIManager.shareInstance.addwishlist(product_id: "\(carts[sender.tag].productID)", vc: self) { [self] (response) in
            if response == "success" {
                self.removeFromCart(pid: sender.tag)
                self.view.makeToast("Added in wishlist")
            }else {
                
                let alert = UIAlertController(title: "Alert", message: response, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    func getAllData() {
        APIManager.shareInstance.getCurrentProfile(vc: self) { (pro, kyc,url) in
            
            APIManager.shareInstance.viewCart(user_id: pro.uid, vc: self) { (allPro) in
                if allPro.count == 0 {
                    self.viewNoData.isHidden = false
                    self.emptyImg.isHidden = false
                    self.emptyImg.image = UIImage(named:"present")
                    self.tableView.isHidden = true
                    self.removeAnimation()
                    self.act.isHidden = true
                    self.btnEidt.isHidden = true
                } else {
                    self.btnEidt.isHidden = false
                    self.viewNoData.isHidden = true
                    self.emptyImg.isHidden = true
                    self.tableView.isHidden = false
                    self.carts.removeAll()
                    self.allPrices.removeAll()
                    self.basePrice.removeAll()
                    self.carts = allPro
                    
                    self.limit = Double(allPro[0].manufacture_limit)!
                    self.lblMainTitle.text = self.carts[0].manufacture_name
                    
                    for _ in 0 ..< self.carts.count {
                        self.quty.append(1)
                    }
                    self.tableView.dataSource = self
                    self.tableView.delegate = self
                    self.tableView.reloadData()
                    ///self.tableView.invalidateIntrinsicContentSize()
                    self.act.isHidden = true
                    self.act.stopAnimating()
                   
                    self.removeAnimation()
                    
                    self.tblheight.constant = CGFloat(allPro.count * 300)
                    
                }
            }
        }
    }
    func strToFloat(str:String) -> Float {
        return str.floatValue
    }
    func calculateTotalPrice() {
//        let allTemp = self.allPrices.uniques
//
//        if allTemp.count == self.carts.count {
            var total = 0.0
            let deilveryCharge = 800.0
            for i in self.totalprices {
                print(i)
                total += i
            }
            
            let serviceCharge = total / 100
            
            let sgsttotal = total + serviceCharge
             
            self.serviceChargeLbl.text = "₹ " + String(format: "%.2f", total / 100)
            self.totalPriceLbl.text = "₹ " + String(format: "%.2f", total)
            self.sgstLbl.text = "₹ " + String(self.calculateSGST(total: sgsttotal).rounded(toPlaces: 2))
            self.cgstLbl.text = "₹ " + String(self.calculateCGST(total: sgsttotal).rounded(toPlaces: 2))
            self.finalPriceLbl.text = "₹ " + String(format: "%.2f", self.calculateSGST(total: total) + self.calculateCGST(total: total) + total + serviceCharge + deilveryCharge)
            
            self.bottomTotalPrice.text = "₹ " + String(format: "%.2f", self.calculateSGST(total: sgsttotal) + self.calculateCGST(total: sgsttotal) + total + serviceCharge + deilveryCharge)
            
            
            var tot = (self.calculateSGST(total: sgsttotal) + self.calculateCGST(total: sgsttotal) + total + serviceCharge + deilveryCharge)
            
            if Double(total) > self.limit {
                
                self.btnPlaceorder.backgroundColor = UIColor.orange
                islimit = false
            }else {
               
                let doubleStr = String(format: "%.2f", limit-total)
                self.lblPopTitle.text = "Minimum order should be greater than ₹ \(self.limit), Add ₹ \(doubleStr) materials"
                self.btnPlaceorder.backgroundColor = UIColor.lightGray
                islimit = true
            }
            
            var weight = 0.0
            
            for i in 0 ..< self.carts.count {
                let count = self.quty[i]
                for j in self.carts[i].assets {
                    let data = j.metal
                    
                    if data == "Stone"{
                        let weightt = Double(j.weight)!*0.2
                        weight += weightt * Double(count)
                    }else if data == "Diamond"{
                        let weightt = Double(j.weight)!*0.2
                        weight += weightt * Double(count)
                        
                    }
                    else {
                        let weightt = Double(j.weight)
                        weight += weightt! * Double(count)
                    }
                    
                }
            }
         //   if weight >= 100 {
                if weight > 150 {
                    let additinal = weight - 150.0
                    let deliveryCalc = additinal * 3.0
                    let deliveryTotal = deilveryCharge + deliveryCalc
                    self.deliveryChargeLbl.text = "₹ " + String(format: "%.2f", deliveryTotal)
                } else {
                    self.deliveryChargeLbl.text = "₹ " + String(format: "%.2f", deilveryCharge)
                }
          //  } else {
          //      self.showAlert(titlee: "Message", message: "Your order should be minimum 100 Grams")
          //  }
           // self.deliveryChargeLbl.text = "₹ " + "\(deilveryCharge)"
            self.totalWeight.text = String(format: "%.3f", weight) + " g"
      //  }
        
    }
    func calculateCGST(total:Double) -> Double {
        return total * 1.5 / 100
    }
    func calculateSGST(total:Double) -> Double {
        return total * 1.5 / 100
    }
    func removeFromCart(pid:Int) {
        print(self.carts[pid].cartID)
        self.act.isHidden = false
        self.act.startAnimating()
        APIManager.shareInstance.removeCart(productId: "\(self.carts[pid].cartID)", vc: self) { (response) in
            if response == "success" {
                self.totalprices.removeAll()
                self.allPrices.removeAll()
                self.basePrice.removeAll()
                self.getAllData()
                
            }
        }
    }
    
    @objc func btnEdit(_ sender:UIButton) {
        self.proid = Int(carts[sender.tag].productID)!
        self.carid = carts[sender.tag].cartID
        
        
        let urll = "\(MainURL.mainurl)img/product/"
        let imgurl = self.carts[sender.tag].image
        let finalurl =  imgurl
        
        self.tempfile = Files.init(id: Int(self.carts[sender.tag].productID)!, productID: self.carts[sender.tag].productID, image: finalurl.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!, type: 1, createdAt: "", updatedAt: "", thumbnail: "")
        
        
        
        
        self.performSegue(withIdentifier: "update", sender: self)
    
    }
    @objc func removeFromArr(_ sender:UIButton) {
       // self.allPrices.remove(at: sender.tag)
     //   self.basePrice.remove(at: sender.tag)
     //   self.carts.remove(at: sender.tag)
        self.removeFromCart(pid: sender.tag)
    }
    @objc func plusBtn(_ sender:UIButton) {
        let cell = self.tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! cartCell
        var total = 0.0
//        for i in self.basePrice {
//            total += i
//        }
        
        
        let price = self.changeprice[sender.tag]
//        let cellPrice = self.allPrices[sender.tag]
//        let totalNew = Float(cellPrice) + Float(price)
        let quantityLbl = Int(cell.quantityLbl.text!)
        var newQuantity = quantityLbl! + 1
        let totalNew = Float(price) * Float(newQuantity)
        var indCart = self.carts[sender.tag]
        indCart.count = "\(newQuantity)"
        
        var basearr = [[String:Any]]()
        for j in 0..<indCart.assets.count {
            let one = indCart.assets[j].metal
            let two = indCart.assets[j].materialType
            let three = Double(indCart.assets[j].weight)! * Double(newQuantity)
           
            let tempdic = ["one":"\(one)","two":"\(two)","three":String(format: "%.3f", three)]
    
            basearr.append(tempdic)
            cell.arrData = basearr
            
            
            
        }
        cell.tblInside.reloadData()

        
        self.totalprices.remove(at: sender.tag)
       // self.changeprice.remove(at: sender.tag)
        self.quty[sender.tag] = newQuantity
        cell.quantityLbl.text = String(newQuantity)
        cell.priceLbl.text = "₹ " + String(totalNew)
        //self.changeprice.insert(Double(totalNew), at: sender.tag)
        self.totalprices.insert(Double(totalNew), at: sender.tag)
       
        
        
        print(self.totalprices)
        
        self.calculateTotalPrice()
        APIManager.shareInstance.cartUpdate(productId: "\(self.carts[sender.tag].cartID)", count: "\(newQuantity)",vc: self) { (response) in
            if response == "success" {
        
            }
        }
        //tableView.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .automatic)

    }
    @objc func minusBtn(_ sender:UIButton) {
        let cell = self.tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! cartCell
        let quantityLbl = Int(cell.quantityLbl.text!)
        if quantityLbl! != 1 {
            var total = 0.0
//            for i in self.basePrice {
//                total += i
//            }
            
            
            let price = self.changeprice[sender.tag]
            
            let cellPrice = self.allPrices[sender.tag]
            //let totalNew = Float(cellPrice) - Float(price)
             
            let newQuantity = quantityLbl! - 1
            let totalNew = Float(price) * Float(newQuantity)
            let indCart = self.carts[sender.tag]
            
            var basearr = [[String:Any]]()
            for j in 0..<indCart.assets.count {
                let one = indCart.assets[j].metal
                let two = indCart.assets[j].materialType
                let three = Double(indCart.assets[j].weight)! * Double(newQuantity)
               
                let tempdic = ["one":"\(one)","two":"\(two)","three":String(format: "%.3f", three)]
        
                basearr.append(tempdic)
                cell.arrData = basearr
                
                
                
            }
            cell.tblInside.reloadData()
            
            
            self.totalprices.remove(at: sender.tag)
           // self.changeprice.remove(at: sender.tag)
            self.quty[sender.tag] = newQuantity
            cell.quantityLbl.text = String(newQuantity)
            cell.priceLbl.text = "₹ " + String(totalNew)
            self.allPrices[sender.tag] = Double(totalNew)
           // self.changeprice.insert(Double(totalNew), at: sender.tag)
            self.totalprices.insert(Double(totalNew), at: sender.tag)
            
            
            self.calculateTotalPrice()
            
            APIManager.shareInstance.cartUpdate(productId: "\(self.carts[sender.tag].cartID)", count: "\(newQuantity)",vc: self) { (response) in
                if response == "success" {
                }
            }
        }
        
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.carts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! cartCell
        let indCart = self.carts[indexPath.row]
        cell.btnminus.layer.cornerRadius = cell.btnminus.frame.height / 2
        cell.btnminus.clipsToBounds = true
        cell.btnPlus.layer.cornerRadius = cell.btnPlus.frame.height / 2
        cell.btnPlus.clipsToBounds = true
        cell.img.kf.indicatorType = .activity
        cell.img.kf.setImage(with: URL(string: indCart.image),placeholder: nil,options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
                       switch result {
                       case .success(let value):
                           print("Task done for: \(value.source.url?.absoluteString ?? "")")
                           
                       case .failure(let error):
                           print("Job failed: \(error.localizedDescription)")
                           
                       }
                   }
        cell.quantityLbl.text = "\(indCart.count)"
        cell.saveForLatterBtn.tag = indexPath.row
        cell.saveForLatterBtn.addTarget(self, action: #selector(saveforlatter(_:)), for: .touchUpInside)
        cell.lblname.text = "\(indCart.productName) Size: (\(indCart.product_size))"
        cell.btnPlus.tag = indexPath.row
        cell.btnPlus.addTarget(self, action: #selector(plusBtn(_:)), for: .touchUpInside)
        cell.btnminus.tag = indexPath.row
        cell.btnminus.addTarget(self, action: #selector(minusBtn(_:)), for: .touchUpInside)
        cell.removeBtn.tag = indexPath.row
        cell.removeBtn.addTarget(self, action: #selector(removeFromArr(_:)), for: .touchUpInside)
        
        
        if isEdit == false {
            cell.removeBtn.isHidden = false
            cell.saveForLatterBtn.isHidden = false
            cell.btnEidt.isHidden = true
        }else {
            cell.removeBtn.isHidden = true
            cell.saveForLatterBtn.isHidden = true
            cell.btnEidt.isHidden = false
            
            cell.btnEidt.tag = indexPath.row
            cell.btnEidt.addTarget(self, action: #selector(btnEdit(_:)), for: .touchUpInside)
        }
        var basearr = [[String:Any]]()
        
        var cellprice = [Double]()
        
        for j in 0..<indCart.assets.count {
            let one = indCart.assets[j].metal
            let two = indCart.assets[j].materialType
            let three = Double(indCart.assets[j].weight)! * Double(indCart.count)!
           
            let tempdic = ["one":"\(one)","two":"\(two)","three":String(format: "%.3f", three)]
            
           
            basearr.append(tempdic)
          
            self.changeweight = basearr
            
           
            cell.arrData = basearr
            
            cell.tblInside.reloadData()
            
           
            
            if indCart.assets.count > 3 {
                let height =  20 * indCart.assets.count
                cell.stackheight.constant = CGFloat(height)
            }else {
                cell.stackheight.constant = 77.0
            }
            
            
            if indCart.assets[j].metal == "Gold" {
                           
                           var data = 0.0
                           
                           var rate = GoldPrice.sharedInstance.getpriceByGoldPrice(gold_type: "24KT").floatValue
                           
                           
                           data = Utils.calculatePrice(type: "Gold", weight: indCart.assets[j].weight.floatValue, rate: rate, makingCharge: indCart.assets[j].makingCharge.floatValue, option: indCart.assets[j].options, goldValue: GoldPrice.sharedInstance.getValueByGoldPrice(gold_type: indCart.assets[j].materialType), gold24k: GoldPrice.sharedInstance.getpriceByGoldPrice(gold_type: "24K").floatValue)
                           
                           let wastage = indCart.assets[j].wastage
                           let makingCharge = indCart.assets[j].makingCharge
                           let weight = indCart.assets[j].weight
                           let value = GoldPrice.sharedInstance.getValueByGoldPrice(gold_type: indCart.assets[j].materialType)
                           
                           if Float(wastage) != 0 || value  != 0 {
                               if Float(wastage) != 0 && value  != 0 {
                                   data =   data * (Double(wastage)!+Double(value))/100
                               }else if value != 0 {
                                   data = Double(value)/100 * data
                               }else {
                                   data = Double(wastage)!/100 * data
                               }
                           }
                           
                           let meena = indCart.assets[j].meena_cost
                           if meena != "0" || meena != "<null>" {
                               let meenaopt = indCart.assets[j].meenacost_option
                               let we = indCart.assets[j].weight
                               if meenaopt == "PerGram" {
                                   data = data + Double(Double(we)! * Double(meena)!)
                               }else if meenaopt == "Fixed" {
                                   data = data + Double(meena)!

                               }
                           }
                           data += Double(makingCharge)! * Double(weight)!
                           cell.priceLbl.text = "₹ " + String(data)
                          // cell.priceLbl.text = "₹ " + String(Utils.calculatePrice(weight: indCart.assets[j].weight.floatValue, rate: GoldPrice.sharedInstance.getpriceByGoldPrice(gold_type: indCart.assets[j].materialType).floatValue, makingCharge: indCart.assets[j].makingCharge.floatValue, isPerGram: true))
                           
//                           if self.allPrices.count == self.carts.count {
//
//                           } else {
                               
                               self.allPrices.append(data)
                               
                              // self.allPrices.append(Utils.calculatePrice(weight: indCart.assets[j].weight.floatValue, rate: GoldPrice.sharedInstance.getpriceByGoldPrice(gold_type: indCart.assets[j].materialType).floatValue, makingCharge: indCart.assets[j].makingCharge.floatValue, isPerGram: true))
                               
                               self.basePrice.append(data)
                cellprice.append(data)
                             //  self.basePrice.append(Utils.calculatePrice(weight: indCart.assets[j].weight.floatValue, rate: GoldPrice.sharedInstance.getpriceByGoldPrice(gold_type: indCart.assets[j].materialType).floatValue, makingCharge: indCart.assets[j].makingCharge.floatValue, isPerGram: true))
                           //}
                           
                       } else if indCart.assets[j].metal == "Diamond" {
                           
                           
                           var daidata = 0.0
                           
                           
                           daidata = Utils.calculatePrice(type: "Diamond", weight: indCart.assets[j].weight.floatValue, rate: DiamondMaster.sharedInstance.getpriceByDiamondName(name: indCart.assets[j].diamondType,color: indCart.assets[j].materialType).floatValue, makingCharge: 0.0, option: indCart.assets[j].options, goldValue: 0.0, gold24k: 0.0)
                           
                           let certification_cost = indCart.assets[j].certification_cost
                           if certification_cost != "0" || certification_cost != "<null>" {
                               let meenaopt = indCart.assets[j].crtcost_option
                               let we = indCart.assets[j].weight
                               if meenaopt == "PerCarat" {
                                   daidata = daidata + Double(Double(we)! * Double(certification_cost)!)
                               }else if meenaopt == "Fixed" {
                                   daidata = daidata + Double(certification_cost)!

                               }
                           }
                           
                           
                           cell.priceLbl.text = "₹ " + String(daidata)
                           
                         //  cell.priceLbl.text = "₹ " + String(Utils.calculatePrice(weight: indCart.assets[j].weight.floatValue, rate: DiamondMaster.sharedInstance.getpriceByDiamondName(name: indCart.assets[j].materialType).floatValue, makingCharge: indCart.assets[j].makingCharge.floatValue, isPerGram: true))
//                           if self.allPrices.count == self.carts.count {
//
//                           } else {
                               
                               self.allPrices.append(daidata)
                        cellprice.append(daidata)
                         //  self.allPrices.append(Utils.calculatePrice(weight: indCart.assets[j].weight.floatValue, rate: DiamondMaster.sharedInstance.getpriceByDiamondName(name: indCart.assets[j].materialType).floatValue, makingCharge: indCart.assets[j].makingCharge.floatValue, isPerGram: true))
                               
                               self.basePrice.append(daidata)
                           
                    //       self.basePrice.append(Utils.calculatePrice(weight: indCart.assets[j].weight.floatValue, rate: DiamondMaster.sharedInstance.getpriceByDiamondName(name: indCart.assets[j].materialType).floatValue, makingCharge: indCart.assets[j].makingCharge.floatValue, isPerGram: true))
                         //  }
                       } else if indCart.assets[j].metal == "Stone" {
                           cell.priceLbl.text = "₹ " + String(Utils.calculatePrice(type: "Stone", weight: indCart.assets[j].weight.floatValue, rate: StonePrice.sharedInstance.getpriceByStoneprice(stone_type: indCart.assets[j].materialType).floatValue, makingCharge: indCart.assets[j].makingCharge.floatValue, option: indCart.assets[j].options, goldValue: 0.0, gold24k: 0.0))
//                           if self.allPrices.count == self.carts.count {
//
//                           } else {
                               self.allPrices.append(Utils.calculatePrice(type: "Stone", weight: indCart.assets[j].weight.floatValue, rate: StonePrice.sharedInstance.getpriceByStoneprice(stone_type: indCart.assets[j].materialType).floatValue, makingCharge: indCart.assets[j].makingCharge.floatValue, option: indCart.assets[j].options, goldValue: 0.0, gold24k: 0.0))
                        
                        cellprice.append(Utils.calculatePrice(type: "Stone", weight: indCart.assets[j].weight.floatValue, rate: StonePrice.sharedInstance.getpriceByStoneprice(stone_type: indCart.assets[j].materialType).floatValue, makingCharge: indCart.assets[j].makingCharge.floatValue, option: indCart.assets[j].options, goldValue: 0.0, gold24k: 0.0))
                           
                               self.basePrice.append(Utils.calculatePrice(type: "Stone", weight: indCart.assets[j].weight.floatValue, rate: StonePrice.sharedInstance.getpriceByStoneprice(stone_type: indCart.assets[j].materialType).floatValue, makingCharge: indCart.assets[j].makingCharge.floatValue, option: indCart.assets[j].options, goldValue: 0.0, gold24k: 0.0))
                          // }
                       } else if indCart.assets[j].metal == "Platinum" {
                           
                           
                           var rate = PlatinumPrice.sharedInstance.getpriceByPlatinumName(platinum_type: "Platinum").floatValue
                           
                           let wastage = indCart.assets[j].wastage
                           
                           let value = Float(indCart.assets[j].purity)
                           
                           if Float(wastage) != 0 || value  != 0 {
                               if Float(wastage) != 0 && value  != 0 {
                                   rate = round(((Float(wastage)!+value!)/100) * rate)
                               }else if value != 0 {
                                   rate = value!/100 * rate
                               }else {
                                   rate = Float(wastage)!/100 * rate
                               }
                           }
                           
                           let meena = indCart.assets[j].meena_cost
                           if meena != "0" || meena != "<null>" {
                               let meenaopt = indCart.assets[j].meenacost_option
                               let we = indCart.assets[j].weight
                               if meenaopt == "PerGram" {
                                   rate = rate + Float(Float(we)! * Float(meena)!)
                               }else if meenaopt == "Fixed" {
                                   rate = rate + Float(meena)!
                                
                               }
                           }
                           cell.priceLbl.text = "₹ " + String(Utils.calculatePrice(type: "Platinum", weight: indCart.assets[j].weight.floatValue, rate: rate, makingCharge: indCart.assets[j].makingCharge.floatValue, option: indCart.assets[j].options, goldValue: 0.0, gold24k: 0.0))
//                           if self.allPrices.count == self.carts.count {
//
//                           } else {
                               self.allPrices.append(Utils.calculatePrice(type: "Platinum", weight: indCart.assets[j].weight.floatValue, rate: rate, makingCharge: indCart.assets[j].makingCharge.floatValue, option: indCart.assets[j].options, goldValue: 0.0, gold24k: 0.0))
                        
                        
                        cellprice.append(Utils.calculatePrice(type: "Platinum", weight: indCart.assets[j].weight.floatValue, rate: rate, makingCharge: indCart.assets[j].makingCharge.floatValue, option: indCart.assets[j].options, goldValue: 0.0, gold24k: 0.0))
                           
                               self.basePrice.append(Utils.calculatePrice(type: "Platinum", weight: indCart.assets[j].weight.floatValue, rate: rate, makingCharge: indCart.assets[j].makingCharge.floatValue, option: indCart.assets[j].options, goldValue: 0.0, gold24k: 0.0))
                           //}
                       }else if indCart.assets[j].metal == "Silver" {
                        
                        var data = 0.0
                        
                         var rate = SilverPrice.sharedInstance.getpriceBySilverPrice(silver_type: "1000").toDouble()
                        
                        
                        
                        let wastage = indCart.assets[j].wastage
                        let makingCharge = indCart.assets[j].makingCharge
                        let weight = indCart.assets[j].weight
                        
                        let value = SilverPrice.sharedInstance.getValueBySilverPrice(silver_type: indCart.assets[j].materialType)
                        
                        
                        
                        
                        if Float(wastage) != 0 || value  != 0 {
                            if Float(wastage) != 0 && value  != 0 {
                                rate =   rate * (Double(wastage)!+Double(value))/100
                            }else if value != 0 {
                                rate = Double(value)/100 * rate
                            }else {
                                rate = Double(wastage)!/100 * rate
                            }
                        }
                        
                        let meena = indCart.assets[j].meena_cost
                        if meena != "0" || meena != "<null>" {
                            let meenaopt = indCart.assets[j].meenacost_option
                            let we = indCart.assets[j].weight
                            if meenaopt == "PerGram" {
                                rate = rate + Double(Double(we)! * Double(meena)!)
                            }else if meenaopt == "Fixed" {
                                rate = rate + Double(meena)!

                            }
                        }
                        
                       // data = Utils.calculatePrice(type: Silver, weight: indCart.assets[j].weight.floatValue, rate: rate, makingCharge: indCart.assets[j].makingCharge.floatValue, option: indCart.assets[j].options, goldValue: SilverPrice.sharedInstance.getpriceBySilverPrice(silver_type: indCart.assets[j].mte), gold24k: <#T##Float#>)
                        
                        
                        data = Utils.calculatePrice(type: "Silver", weight: indCart.assets[j].weight.floatValue, rate: Float(rate), makingCharge: indCart.assets[j].makingCharge.floatValue, option: indCart.assets[j].options, goldValue: SilverPrice.sharedInstance.getpriceBySilverPrice(silver_type: indCart.assets[j].materialType).floatValue, gold24k: SilverPrice.sharedInstance.getpriceBySilverPrice(silver_type: "1000").floatValue)
                        
                        
                        
                        
                       
                        
                        
                        data += Double(makingCharge)! * Double(weight)!
                        cell.priceLbl.text = "₹ " + String(data)
                       // cell.priceLbl.text = "₹ " + String(Utils.calculatePrice(weight: indCart.assets[j].weight.floatValue, rate: GoldPrice.sharedInstance.getpriceByGoldPrice(gold_type: indCart.assets[j].materialType).floatValue, makingCharge: indCart.assets[j].makingCharge.floatValue, isPerGram: true))
                        
//                           if self.allPrices.count == self.carts.count {
//
//                           } else {
                            
                            self.allPrices.append(data)
                            
                           // self.allPrices.append(Utils.calculatePrice(weight: indCart.assets[j].weight.floatValue, rate: GoldPrice.sharedInstance.getpriceByGoldPrice(gold_type: indCart.assets[j].materialType).floatValue, makingCharge: indCart.assets[j].makingCharge.floatValue, isPerGram: true))
                            
                            self.basePrice.append(data)
             cellprice.append(data)
                          //  self.basePrice.append(Utils.calculatePrice(weight: indCart.assets[j].weight.floatValue, rate: GoldPrice.sharedInstance.getpriceByGoldPrice(gold_type: indCart.assets[j].materialType).floatValue, makingCharge: indCart.assets[j].makingCharge.floatValue, isPerGram: true))
                        //}
                        
                        
                        
                        
                        
//                        cell.priceLbl.text = "₹ " + String(Utils.calculatePrice(type: "Silver", weight: indCart.assets[j].weight.floatValue, rate: SilverPrice.sharedInstance.getpriceBySilverPrice(silver_type: indCart.assets[j].materialType).floatValue, makingCharge: indCart.assets[j].makingCharge.floatValue, option: indCart.assets[j].options, goldValue: 0.0, gold24k: 0.0))
////                           if self.allPrices.count == self.carts.count {
////
////                           } else {
//                        self.allPrices.append(Utils.calculatePrice(type: "silver_type", weight: indCart.assets[j].weight.floatValue, rate: SilverPrice.sharedInstance.getpriceBySilverPrice(silver_type: indCart.assets[j].materialType).floatValue, makingCharge: indCart.assets[j].makingCharge.floatValue, option: indCart.assets[j].options, goldValue: 0.0, gold24k: 0.0))
//
//                        cellprice.append(Utils.calculatePrice(type: "silver_type", weight: indCart.assets[j].weight.floatValue, rate: SilverPrice.sharedInstance.getpriceBySilverPrice(silver_type: indCart.assets[j].materialType).floatValue, makingCharge: indCart.assets[j].makingCharge.floatValue, option: indCart.assets[j].options, goldValue: 0.0, gold24k: 0.0))
//
//                        self.basePrice.append(Utils.calculatePrice(type: "silver_type", weight: indCart.assets[j].weight.floatValue, rate: SilverPrice.sharedInstance.getpriceBySilverPrice(silver_type: indCart.assets[j].materialType).floatValue, makingCharge: indCart.assets[j].makingCharge.floatValue, option: indCart.assets[j].options, goldValue: 0.0, gold24k: 0.0))
                        
                       }
        }
        

        print(allPrices)
        var total = 0.0
        for i in cellprice {
            
            total += i
        }
        
        cellprice.removeAll()
        let str = "\(total)"
        let replaced = str.replacingOccurrences(of: "₹", with: "")
        let trimmed = replaced.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let dat = Double(trimmed)
        let tot = dat! * Double(indCart.count)!
        let doubleStr = String(format: "%.2f", tot)
        cell.priceLbl.text = "₹ \(doubleStr)"
        
        
            
        print(totalprices)
       
        self.relode += 1
        
        if relode  <=  carts.count {
            self.totalprices.append(tot)
            self.changeprice.append(total)
            self.calculateTotalPrice()
        }
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let indCart = self.carts[indexPath.row]
        var height = 200
        if indCart.assets.count > 3 {
            height +=  20 * indCart.assets.count
            
        }else {
            height += 77
        }
        return CGFloat(height)
    }
}

