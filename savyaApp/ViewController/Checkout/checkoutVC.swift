//
//  checkoutVC.swift
//  savyaApp
//
//  Created by Yash on 1/10/20.
//  Copyright © 2020 Yash Rathod. All rights reserved.
//

import Foundation
import UIKit
//import Razorpay

class checkoutVC:RootBaseVC,UITableViewDataSource,UITableViewDelegate/*,RazorpayPaymentCompletionProtocol,ExternalWalletSelectionProtocol*/ {
    
    @IBOutlet weak var tblHeight: NSLayoutConstraint!
    
  //  var razorpay : Razorpay!
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var totalLbl:UILabel!
    @IBOutlet weak var act:UIActivityIndicatorView!
    var carts = [Cart]()
    var qty = [Int]()
    var quty = [Int]()
    var totalPriceLbl = ""
    var sgstLbl = ""
    var cgstLbl = ""
    var finalPriceLbl = ""
    var bottomTotalPrice = ""
    var surcharge = ""
    var grossWeight = ""
    var discont = ""
    var address = [Address]()
    var allPrices = [Double]()
    var basePrice = [Double]()
    var totalprices = [Double]()
    var delCharge = 800.0
    var isSelected = false
    
    var fname = String()
    var lname = String()
    var add = String()
    var number = String()
    var addid = String()
    var orderid = String()
    var orid = String()
    var sellid = String()
    var buyid = String()
    var compName = String()
    var changeprice = [Double]()
    var relode = 0
    override func viewDidLoad() {
        super.viewDidLoad()
       // razorpay = Razorpay.initWithKey("rzp_test_ihMnIlwn1dMZn5", andDelegate: self)
     //   razorpay?.setExternalWalletSelectionDelegate(self)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotificationPrev(notification:)), name: Notification.Name("address"), object: nil)
        self.loadAnimation()
        self.getAllData()
        
    }
    @objc private func methodOfReceivedNotificationPrev(notification: NSNotification) {
        print(notification)
       
        if let obj = notification.object as? [String:Any] {
            
            isSelected = true
            
            self.fname = obj["fname"] as! String
            self.lname = obj["lname"] as! String
            self.add = obj["address"] as! String
            self.number = obj["number"] as! String
            self.addid = "\(obj["id"] as! Int)"
            self.allPrices.removeAll()
            self.basePrice.removeAll()
            self.totalprices.removeAll()
            tableView.reloadData()
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getAddress()
        //self.act.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
       // self.totalLbl.text = self.finalPriceLbl
    }
    internal func showPaymentForm(total:String){
        let img = UIImage(named: "minilogo")
        let options : Dictionary<String, Any> = ["amount":total, "currency":"INR", "description":"Online Pay", "image":img!, "name":"Savya Jewels Business", "external":["wallets":["paytm"]], "prefill":["email":Mobile.getEmail(), "contact":Mobile.getMobile()], "theme":["color":"#3594E2"]]
        print(options)
        self.showAlert(titlee: "Message", message: "Something went wrong")
      //  razorpay.open(options, display: self)
    
    }
    func onPaymentError(_ code: Int32, description str: String) {
        
    }
    func onExternalWalletSelected(_ walletName: String, withPaymentData paymentData: [AnyHashable : Any]?) {
        
    }
    
    func onPaymentSuccess(_ payment_id: String) {
        self.act.isHidden = false
        self.act.startAnimating()
        self.checkoutCOD(paymentMode: "COD", transaction_id: payment_id)
    }
    
    func getAddress() {
        APIManager.shareInstance.getAllAddress(vc: self) { (addr) in
            self.address = addr
            
            if self.address == [] {
                self.removeAnimation()
                self.performSegue(withIdentifier: "addressbook", sender: self)
            }else {
                self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                
            }
            
           
        }
    }
    @IBAction func back(_ sender:UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func makePayment(_ sender:UIButton) {
        self.checkoutCOD(paymentMode: "Cod", transaction_id: "")
//        let action = UIAlertController(title: "Message", message: "Please select any one", preferredStyle: .actionSheet)
//
//        action.addAction(UIAlertAction(title: "COD", style: .default, handler: { (_) in
//            DispatchQueue.main.async {
//               // self.showAlertWithTextField()
//
//            }
            
//            let newPrice = self.bottomTotalPrice.replacingOccurrences(of: "₹ ", with: "")
//            let intBPrice = Float(newPrice)
//            print(newPrice)
//            let finalTotal = intBPrice! * 100
//            self.showPaymentForm(total: String(finalTotal))
  //      }))
//        action.addAction(UIAlertAction(title: "COD", style: .default, handler: { (_) in
//            self.checkoutCOD(paymentMode: "COD", transaction_id: "")
//        }))
//        action.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (_) in
//
//        }))
//        if let presenter = action.popoverPresentationController {
//            presenter.sourceView = sender
//            presenter.sourceRect = sender.bounds
//        }
//        self.present(action, animated: true, completion: nil)
        
    }
    func showAlertWithTextField() {
        
        let alert = UIAlertController(title: "Message", message: "Please Enter amount to be paid \n Note:- Minimum 10% of amount should be paid.", preferredStyle: .alert)
        alert.addTextField { (txt) in
            let newPrice = self.finalPriceLbl.replacingOccurrences(of: "₹ ", with: "")
            print(newPrice)
            let intBPrice = Float(newPrice)
            let percet = intBPrice! * 10 / 100
            txt.text = String(format: "%.2f", percet)
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            let newPrice = self.finalPriceLbl.replacingOccurrences(of: "₹ ", with: "")
            let intBPrice = Float(newPrice)
            let percet = intBPrice! * 10 / 100
            let txtvlaue = Float(alert.textFields![0].text!)
            if txtvlaue! < percet {
                self.showAlert(titlee: "Message", message: "Please Enter Proper Amount")
            } else {
                self.showPaymentForm(total: String(txtvlaue! * 100))
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func checkoutCOD(paymentMode:String,transaction_id:String) {
        
        
        let cell = self.tableView.cellForRow(at: IndexPath(row: 4, section: 0)) as! checkoutFeedBackCell
        print(cell.txt1.text!)
        self.loadAnimation()
        var products = [[String:Any]]()
        let userid = UserDefaults.standard.string(forKey: "userid") as! String
        for i in 0 ..< self.carts.count {
            var tempAsset = [[String:Any]]()
            
            for ii in 0 ..< self.carts[i].assets.count {
                let asset = ["certification_cost": self.carts[i].assets[ii].certification_cost,"crtcost_option": self.carts[i].assets[ii].crtcost_option,"diamond_index": self.carts[i].assets[ii].diamond_index,"meena_cost": self.carts[i].assets[ii].meena_cost,"meenacost_option": self.carts[i].assets[ii].meenacost_option,"product_size": self.carts[i].assets[ii].product_size,"purity": self.carts[i].assets[ii].purity,"selectedColor": self.carts[i].assets[ii].selectedColor,"stone_index": self.carts[i].assets[ii].stone_index,"stoneType": self.carts[i].assets[ii].stoneType,"weight":self.carts[i].assets[ii].weight,"materialType":self.carts[i].assets[ii].materialType,"makingCharge":self.carts[i].assets[ii].makingCharge,"option":self.carts[i].assets[ii].options,"productId":self.carts[i].assets[ii].product_id,"metal":self.carts[i].assets[ii].metal,"diamondType":self.carts[i].assets[ii].diamondType]
                
                tempAsset.append(asset)
            }
            let product = ["count":self.carts[i].count,"productId":self.carts[i].productID,"userid":userid,"category":self.carts[i].category,"subCategory":self.carts[i].subCategory,"subSubCategory":self.carts[i].subSubCategory,"productCode":self.carts[i].productCode,"productName":self.carts[i].productName,"description":self.carts[i].welcomeDescription,"productType":self.carts[i].productType,"productTotal":self.carts[i].productTotal,"totalMakingCharge":self.carts[i].totalMakingCharge,"product_size":self.carts[i].product_size,"default_size":self.carts[i].default_size,"selectedColor":"Yellow","assests":tempAsset] as [String : Any]
            products.append(product)
        }
        
        let data = ["address_id":self.addid,"userid":userid,"total":self.bottomTotalPrice.replacingOccurrences(of: "₹", with: ""),"sgst":self.sgstLbl.replacingOccurrences(of: "₹", with: ""),"igst":"0","cgst":self.cgstLbl.replacingOccurrences(of: "₹", with: ""),"final_total":self.bottomTotalPrice.replacingOccurrences(of: "₹", with: ""),"sgst_per":"1.5","paymentMode":paymentMode,"transaction_id":transaction_id,"feedback":cell.txt1.text!,"cgst_per":"1.5","igst_per":"","discount_amount":"0","coupanCode":"","data":products] as [String : Any]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
            print(jsonData)
            let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
            // here "decoded" is of type `Any`, decoded from JSON data
            print(decoded)
            // you can now cast it with the right type
            
            
                       
            
        } catch {
            print(error.localizedDescription)
        }
        
        
        
        
        APIManager.shareInstance.checkout(data: data, vc: self) { (response) in
            if response.isEmpty {
                
            }else {
                
                self.view.makeToast("Checkout Successfull")
                
                print(response)
                let Order_id =  String(format: "%@", (response["Order_id"]) as! CVarArg)
                let buyer_id =  String(format: "%@", (response["buyer_id"]) as! CVarArg)
                let seller_id =  String(format: "%@", (response["seller_id"]) as! CVarArg)
                
                self.orid = Order_id
                self.buyid = buyer_id
                self.sellid = seller_id
               
                self.orderid = "SAV\(Order_id)"
                self.compName = self.carts[0].manufacture_name
                self.removeAnimation()
                self.performSegue(withIdentifier: "proceed", sender: self)
                
//                APIManager.shareInstance.getInvoice(order_id: "\(Order_id)", buyer_id: "\(buyer_id)", seller_id: "\(seller_id)", vc: self) { (response) in
//                    if response == "success" {
//                        self.removeAnimation()
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                            self.performSegue(withIdentifier: "proceed", sender: self)
//        //                    let dvc = self.storyboard?.instantiateInitialViewController()
//        //                    self.present(dvc!, animated: true, completion: nil)
//                        }
//                    }
//                }
                

//                }
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "proceed" {
            let destinationVC = segue.destination as! thnakyouVC
            destinationVC.id = self.orderid
            destinationVC.name = self.compName
            destinationVC.orderid = self.orid
            destinationVC.buyid = self.buyid
            destinationVC.sellid = self.sellid
            
        }
        }
        
        
       
    func getAllData() {
        let userid = UserDefaults.standard.string(forKey: "userid") as! String
        APIManager.shareInstance.viewCart(user_id: userid, vc: self) { (allPro) in
            self.carts.removeAll()
            self.allPrices.removeAll()
            self.basePrice.removeAll()
            self.carts = allPro
            self.act.isHidden = true
            for _ in 0 ..< self.carts.count {
                self.quty.append(1)
            }
               
            self.tableView.reloadData()
            let he = 200 * self.carts.count
            self.tblHeight.constant = CGFloat(350 + 300 + he)
            //self.tableView.invalidateIntrinsicContentSize()
            //self.removeAnimation()
               
        }
    }
    func calculation(tag:IndexPath){
        let cell = self.tableView.cellForRow(at: IndexPath(row: tag.row, section: 0)) as! cartCell
        let price = self.basePrice[tag.row]
        let cellPrice = self.allPrices[tag.row]
        let totalNew = Float(cellPrice) + Float(price)
        let quantityLbl = Int(cell.quantityLbl.text!)
        let newQuantity = quantityLbl! + 1
        
        let indCart = self.carts[tag.row]
        
        if indCart.assets.count == 1 {
            
            let weght = Double(indCart.assets[0].weight)
            
            let data = weght! * Double(newQuantity)
            cell.goldLbl3.text = "\(data) g"
        }
        else if indCart.assets.count == 2 {
            
        
            let weght = Double(indCart.assets[0].weight)
            let data = weght! * Double(newQuantity)
            cell.goldLbl3.text = "\(data) g"
        
            let weght1 = Double(indCart.assets[1].weight)
            let data1 = weght1! * Double(newQuantity)
            cell.diamondLbl3.text = "\(data1) g"
            
        }else {
            
            let weght = Double(indCart.assets[0].weight)
            let data = weght! * Double(newQuantity)
            cell.goldLbl3.text = "\(data) g"
        
            let weght1 = Double(indCart.assets[1].weight)
            let data1 = weght1! * Double(newQuantity)
            cell.diamondLbl3.text = "\(data1) g"
            
            
            let weght2 = Double(indCart.assets[2].weight)
            let data2 = weght2! * Double(newQuantity)
            cell.stoneLbl3.text = "\(data2) g"
            

          
        }
        
        
        self.quty[tag.row] = newQuantity
        cell.quantityLbl.text = String(newQuantity)
        cell.priceLbl.text = "₹ " + String(totalNew)
        self.allPrices[tag.row] = Double(totalNew)
        self.calculateTotalPrice()
    }
    func strToFloat(str:String) -> Float {
        return str.floatValue
    }
    func calculateCGST(total:Float) -> Float {
        return total * 1.5 / 100
    }
    func calculateSGST(total:Float) -> Float {
        return total * 1.5 / 100
    }
    func payFromCard() {
        
    }
    func calculateTotalPrice() {
//        let allTemp = self.totalprices.uniques
//        if allTemp.count == self.carts.count {
            var total = 0.0
            for i in self.totalprices {
                total += i
            }
            
            
            let serviceCharge = total / 100
            
            let sgsttotal = total + serviceCharge
             
            self.surcharge = "₹ " + String(format: "%.2f", total / 100)
            
            self.totalPriceLbl = "₹ " + String(format: "%.2f", total)
            self.sgstLbl = "₹ " + String(self.calculateSGST(total: Float(sgsttotal)).rounded())
            self.cgstLbl = "₹ " + String(self.calculateCGST(total: Float(sgsttotal)).rounded())
//            self.finalPriceLbl = "" + String(format: "%.2f", self.calculateCGST(total: Float(sgsttotal) + self.calculateSGST(total: Float(sgsttotal) + Float(total))))
//
//
//            self.bottomTotalPrice = "₹ " + String(format: "%.2f", self.calculateSGST(total: Float(sgsttotal)) + self.calculateCGST(total: Float(sgsttotal)) + Float(total))
            
            
            self.finalPriceLbl = "₹ " + String(format: "%.2f", Double(self.calculateSGST(total: Float(total)) + self.calculateCGST(total: Float(total))) + total + serviceCharge + delCharge)
            
            
            self.bottomTotalPrice = "₹ " + String(format: "%.2f", Double(self.calculateSGST(total: Float(sgsttotal)) + self.calculateCGST(total: Float(sgsttotal))) + total + serviceCharge + delCharge)
        
        
            
            self.totalLbl.text = self.bottomTotalPrice
            
            var weight = 0.0
            
            for i in 0 ..< self.carts.count {
                let qty = Double(self.qty[i])
                let count = self.quty[i]
                for j in self.carts[i].assets {
                    let data = j.metal
                    
                    if data == "Stone"{
                        let weightt = Double(j.weight)!*0.2*qty
                        weight += weightt * Double(count)
                    }else if data == "Diamond"{
                        let weightt = Double(j.weight)!*0.2*qty
                        weight += weightt * Double(count)
                        
                    }
                    else {
                        let weightt = Double(j.weight)!*qty
                        weight += weightt * Double(count)
                    }
                    
                }
            }
            
            self.grossWeight = String(format: "%.3f", weight) + " g"
       // }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.carts.count + 3
    }
    @objc func btn1(_ sender:UIButton){
        
       
        self.performSegue(withIdentifier: "addressbook", sender: self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addrCell") as! checkoutAddrCell
            if self.address.count > 0 {
                cell.btn1.addTarget(self, action: #selector(btn1), for: .touchUpInside)
                if isSelected == false {
                    cell.nameLbl.text = self.address[0].first + " " + self.address[0].last
                    cell.addrTxt.text = self.address[0].address + "\n" + self.address[0].region + " " + self.address[0].city + " " + self.address[0].pincode + "\n" + self.address[0].mobileno
                    self.addid = "\(self.address[0].id)"
                }else {
                    
                    cell.nameLbl.text = fname + " " + lname
                    cell.addrTxt.text = add + "\n" + number
                    
                }
               
            }
           
            
            return cell
        } else if indexPath.row == self.carts.count + 1 {
            let pricCell = tableView.dequeueReusableCell(withIdentifier: "totalCell") as! checkoutLastCell
            pricCell.lblCGST.text = self.cgstLbl
            pricCell.lblSGST.text = self.sgstLbl
            pricCell.lblTotal.text = self.totalPriceLbl
            pricCell.lblTotalPay.text = self.bottomTotalPrice
            
            if discont == "" || discont == "0" {
                discont = "₹ 0.0"
            }else {
                
            }
            pricCell.lblDiscount.text = discont
            pricCell.lblSurCharge.text = surcharge
            pricCell.lblTotalGrossWeight.text = grossWeight
            pricCell.lblDelCharge.text = "\(delCharge)"
            
            
            return pricCell
        } else if indexPath.row == self.carts.count + 2 {
            let feedbackCell = tableView.dequeueReusableCell(withIdentifier: "feedbackcell") as! checkoutFeedBackCell
            feedbackCell.txt1.layer.borderColor = UIColor.lightGray.cgColor
            feedbackCell.txt1.layer.borderWidth = 0.5
            feedbackCell.txt1.layer.cornerRadius = 5
            feedbackCell.txt1.clipsToBounds = true
            return feedbackCell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! cartCell
            let indCart = self.carts[indexPath.row - 1]
            
            cell.quantityLbl.text = "QTY : \(indCart.count)"
            print(indexPath.row)
            cell.img.kf.indicatorType = .activity
            cell.img.kf.setImage(with: URL(string: indCart.image),placeholder: nil,options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
                           switch result {
                           case .success(let value):
                               print("Task done for: \(value.source.url?.absoluteString ?? "")")
                               
                           case .failure(let error):
                               print("Job failed: \(error.localizedDescription)")
                               
                           }
                       }
            
            cell.lblname.text = "\(indCart.productName) Size: (\(indCart.product_size))"
          //  cell.quantityLbl.text = "Qty:- \(self.qty[indexPath.row - 1])"
            var cellprice = [Double]()
            var basearr = [[String:Any]]()
            for j in 0..<indCart.assets.count {
                let one = indCart.assets[j].metal
                let two = indCart.assets[j].materialType
                let three = Double(indCart.assets[j].weight)! * Double(indCart.count)!
               
                let tempdic = ["one":"\(one)","two":"\(two)","three":String(format: "%.3f", three)]
                
               
                basearr.append(tempdic)
              
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
                    cellprice.append(data)
                                   
                                  // self.allPrices.append(Utils.calculatePrice(weight: indCart.assets[j].weight.floatValue, rate: GoldPrice.sharedInstance.getpriceByGoldPrice(gold_type: indCart.assets[j].materialType).floatValue, makingCharge: indCart.assets[j].makingCharge.floatValue, isPerGram: true))
                                   
                                   self.basePrice.append(data)
                                   
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
            
            
            indCart.productTotal = "\(tot)"
            
                
            print(totalprices)
           
            self.relode += 1
            
            if relode  <=  carts.count {
                self.totalprices.append(tot)
                self.changeprice.append(tot)
                self.calculateTotalPrice()
            }
            return cell
        }
           
//            let str = cell.priceLbl.text
//            let replaced = str!.replacingOccurrences(of: "₹", with: "")
//            let trimmed = replaced.trimmingCharacters(in: .whitespacesAndNewlines)
//
//            let dat = Double(trimmed)
//            let tot = dat! * Double(indCart.count)!
//            let doubleStr = String(format: "%.2f", tot)
//            cell.priceLbl.text = "₹ \(doubleStr)"
//
//            indCart.productTotal = doubleStr
//
//            self.totalprices.append(tot)
//
//            self.calculateTotalPrice()
//            return cell
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return UITableView.automaticDimension
        }else if indexPath.row == self.carts.count + 1 {
            return 250
        } else if indexPath.row == self.carts.count + 2{
            return 150
        }
        else {
            return UITableView.automaticDimension
        }
    }
    
}

