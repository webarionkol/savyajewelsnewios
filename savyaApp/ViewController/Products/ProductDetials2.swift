//
//  productDetailNewVC.swift
//  savyaApp
//
//  Created by Yash on 9/13/20.
//  Copyright © 2020 Yash Rathod. All rights reserved.
//

import UIKit
import Kingfisher
import AVKit
import Foundation
class ProductDetials2: RootBaseVC {

  
    @IBOutlet weak var imgCollectionview:UICollectionView!
    @IBOutlet weak var productDetailTableView:subtableView!
    @IBOutlet weak var recentCollectionView:UICollectionView!
    @IBOutlet weak var pageControl:UIPageControl!
    @IBOutlet weak var priceLbl:UILabel!
    @IBOutlet weak var grossWeightLbl:UILabel!
    @IBOutlet weak var nameLbl:UILabel!
    @IBOutlet weak var favBtn:UIButton!
    @IBOutlet weak var productCode:UILabel!
    @IBOutlet weak var productWeight:UILabel!
    var selectedimage = ""
    @IBOutlet weak var viewPopup: UIView!
    
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var lblPopTitle: UILabel!
    var gentsSize = [RingSizeClass]()
    var ladiesSize = [RingSizeClass]()
    
    var goldAsset = [pdAsset]()
    var diamondAsset = [pdAsset]()
    var stoneAsset = [pdAsset]()
    var platinumAsset = [pdAsset]()
    var silverAsset = [pdAsset]()
    
    var selectedIndGold = 0
    var selectedIndDiamong = 0
    var selectedIndStone = 0
    var selectedIndPlatinum = 0
    var selectedIndSilver = 0
    var selectedgoldtype = ""
    var selectedsilvertype = ""
    
    var product:ProductDetail?
    var productId = 0
    var iscame = 0
    
    var trendingProduct = [RecentProduct]()
    
    var defaultSize = ""
    var color = ""
    var manufactured = ""
    var manufactureURL = ""
    
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
    var tempFile:Files?
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
    var originalWeight = ""
    var originalDefaultWeight = ""
    var originalWeightplat = ""
    var originalWeightsilver = ""
    var originalWeightsone = ""
    var originalWeightDiamond = ""
    var defaultSizeBangle = ""
    var newProduct:ProductDetail?
    var gender = ""
    var qty = 1
    var mycolor = ""
    var prodType = ""
    var deliverytime = ""
    var limit = Double()
    var allPrices = [Double]()
    var basePrice = [Double]()
    var totalprices = [Double]()
    var quty = [Int]()
    var carts = [Cart]()
    var ischange = false
   
    var stoneArr = [[String:Any]]()
    var stoneinside = [[String:Any]]()
    var stoneoutside = [[String:Any]]()
    var stonedout = [[String:Any]]()
    var arrFinalStone = [[String:Any]]()
    var mainID = Int()
    var arrStoneName = [String]()
    var cartid = Int()
    var nextproid = Int()
    var ispr = false
    var tempfile:Files?
    var selectedBangleSize = ""
    var selectedsizeindex = 0
    var selectedtype = ""
    var defualttype = ""
    var issizechanged = "0"
    var goldweightchange = [Double]()
    var goldweightnochange = [Double]()
    
    
    var diaType = ""
    var colorarray = NSMutableArray()
    var newcolorarray = [[String:Any]]()
    var clarArr = NSMutableArray()
    
    
    var newClarityarray = [[String:Any]]()
    
    var selectedClr = ""
    var selectedClarity = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        
        self.imgCollectionview.delegate = self
        self.imgCollectionview.dataSource = self
        
        self.recentCollectionView.delegate = self
        self.recentCollectionView.dataSource = self
        
        self.getProduct()
        
        if isKeyPresentInUserDefaults(key: "price") {
            if UserDefaults.standard.string(forKey: "price") == "1" {
              ispr = false
            }else {
                ispr = true
            }
        }else{
            ispr = true
        }
        
    }
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.sizeAdd()
      //  self.loadAnimation()
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
      //  self.checkforFav()
        self.addTwoButtons()
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.productDetailTableView.invalidateIntrinsicContentSize()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    @IBAction func backNav(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK:- Get Product
    func getProduct() {
        self.loadAnimation()
        APIManager.shareInstance.getProduct(vc: self, product_id: self.productId) { (product) in
            self.product = product
            self.nameLbl.text = product.data.productname
            self.allFiles = product.files
            self.gender = product.data.gender
            self.prodType = product.product_category
            self.deliverytime = product.data.delivery_time
            self.productDetailTableView.delegate = self
            self.productDetailTableView.dataSource = self
            for i in product.assets {
                if i.metrialType == "Gold" {
                   // self.goldAsset.removeAll()
                    self.goldAsset.append(i)
                    self.goldweightchange.append(i.weight.toDouble())
                    self.goldweightnochange.append(i.weight.toDouble())
                    self.originalWeight = self.goldAsset[0].weight
                    self.originalDefaultWeight = self.goldAsset[0].weight
                } else if i.metrialType == "Diamond" {
                  //  self.diamondAsset.removeAll()
                    self.diamondAsset.append(i)
                    self.diamondColorTemp = i.defaultColorClarity.components(separatedBy: "/")[0]
                    self.diamondClarityTemp = i.defaultColorClarity.components(separatedBy: "/")[1]
                    
                    print(self.diamondClarityTemp)
                    print(self.diamondColorTemp)
                } else if i.metrialType == "Stone" {
                  //  self.stoneAsset.removeAll()
                
                    self.stoneAsset.append(i)
                    
                } else if i.metrialType == "Platinum" {
                  //  self.platinumAsset.removeAll()
                    self.platinumAsset.append(i)
                    self.originalWeightplat = self.platinumAsset[0].weight
                    //self.originalWeight = self.platinumAsset[0].weight
                } else if i.metrialType == "Silver" {
                 //   self.silverAsset.removeAll()
                    self.silverAsset.append(i)
                    self.originalWeightsilver = self.silverAsset[0].weight

                    
                }
            }
            
           // if self.stoneAsset.count > 1 {
                
                for obj in 0..<self.stoneAsset.count {
                    let stoneIndex = "\(self.stoneAsset[obj].stoneIndex)"
                    let name = self.stoneAsset[obj].jwellerySize
                   
    
                    
                    let id =  "\(self.stoneAsset[obj].id)"
                    let metrialType =  "\(self.stoneAsset[obj].metrialType)"
                    let productID =  "\(self.stoneAsset[obj].productID)"
                    let jwellerySize =  "\(self.stoneAsset[obj].jwellerySize)"
                    
                
                    let diamondIndex =  "\(self.stoneAsset[obj].diamondIndex)"
                    let multiWeight =  "\(self.stoneAsset[obj].multiWeight)"
                    let purity =  "\(self.stoneAsset[obj].purity)"
                    let weight =  "\(self.stoneAsset[obj].weight)"
                    let wastage =  "\(self.stoneAsset[obj].wastage)"
                    
                    let quantity =  "\(self.stoneAsset[obj].quantity)"
                    let color =  "\(self.stoneAsset[obj].color)"
                    let clarity =  "\(self.stoneAsset[obj].clarity)"
                    let defaultColorClarity =  "\(self.stoneAsset[obj].defaultColorClarity)"
                    let chargesOption =  "\(self.stoneAsset[obj].chargesOption)"
                    let crtcostOption =  "\(self.stoneAsset[obj].crtcostOption)"
                    let certificationCost =  "\(self.stoneAsset[obj].certificationCost)"
                    let meenacostOption =  "\(self.stoneAsset[obj].meenacostOption)"
                    let meenaCost =  "\(self.stoneAsset[obj].meenaCost)"
                    let makingCharge =  "\(self.stoneAsset[obj].makingCharge)"
                    
                    let createdAt =  "\(self.stoneAsset[obj].createdAt)"
                    let updatedAt =  "\(self.stoneAsset[obj].updatedAt)"
                    
                    let tempdic = ["stoneIndex":stoneIndex,"id":id,"metrialType":metrialType,"productID":productID,"jwellerySize":jwellerySize,"diamondIndex":diamondIndex,"multiWeight":multiWeight,"purity":purity,"weight":weight,"wastage":wastage,"quantity":quantity,"color":color,"clarity":clarity,"defaultColorClarity":defaultColorClarity,"chargesOption":chargesOption,"crtcostOption":crtcostOption,"certificationCost":certificationCost,"meenacostOption":meenacostOption,"meenaCost":meenaCost,"makingCharge":makingCharge,"createdAt":createdAt,"updatedAt":updatedAt] as [String : Any]
                  
                    
                    self.stoneArr.append(tempdic)
                }
           // }
            
            var names = [String]()
            var result = [[String:Any]]()
            
            
            for item in 0..<self.stoneArr.count {
                let name = self.stoneArr[item]["stoneIndex"] as! String
                if !names.contains(name) {
                    names.append(name)
                    result.append(self.stoneArr[item])
                }else {
                    self.stoneinside.append(self.stoneArr[item])
                }
            }

            print(result)
            print(self.stoneinside)
            
            for obj in 0..<result.count {

                let objid = result[obj]["stoneIndex"] as! String

                for j in 0..<self.stoneinside.count {
                    let mainid = self.stoneinside[j]["stoneIndex"] as! String
                    if mainid == objid {
                        
                        self.stonedout.append(result[obj])
                        self.stonedout.append(self.stoneinside[j])
                        
                    }else{
                        self.stoneoutside.append(self.stoneArr[j])
                    }
                }
                
            }
            print(self.stoneinside)
            print(self.stonedout)
            var answerArray = [[String:Any]]()

            for i in 0..<self.stonedout.count
            {
                let name1 = self.stonedout[i]["jwellerySize"]
                if(i == 0){
                    answerArray.append(self.stonedout[i])
                }else{
                    var doesExist = false
                    for j in 0..<answerArray.count
                    {
                        let name2:String = answerArray[j]["jwellerySize"]! as! String
                        if name1 as! String == name2 {
                            doesExist = true
                        }
                    }
                    if(!doesExist){
                        answerArray.append(self.stonedout[i])
                    }
                }
            }
            
            
            
            
            
            for A in 0..<answerArray.count {
                let jwellerySize = answerArray[A]["jwellerySize"] as! String
                self.arrStoneName.append(jwellerySize)
            }
    
            if self.stoneoutside.count > 0 {
                for j in 0..<self.stoneoutside.count {
                    self.arrFinalStone.append(self.stoneoutside[j])
                }
            }

            if answerArray.count > 0 {
                let tempdic = ["stoneInside":answerArray] as [String:Any]
                self.arrFinalStone.append(tempdic)
            }
//
            print(self.arrFinalStone)
            if self.stonedout.count == 0 {
                
                self.arrFinalStone.removeAll()
                for obj in 0..<result.count {

                    self.arrFinalStone.append(result[obj])
                }
            }
            
            self.productDetailTableView.reloadData()
            //let img = self.allFiles[indexPath.row].image
            self.allFiles.insert(Files.init(id: self.tempFile?.id ?? 0, productID: self.tempFile?.productID ?? "", image: self.tempFile?.image ?? "", type: 1, createdAt: "", updatedAt: "", thumbnail: ""), at: 0)
            self.pageControl.numberOfPages = self.allFiles.count
            self.imgCollectionview.reloadData()
            
            self.trendingProduct = product.recentProduct
            self.recentCollectionView.reloadData()
        }
    }
    
    //MARK:- Size Add
    func sizeAdd() {
        self.ladiesSize.append(RingSizeClass.init(sizeset: minMax.init(minSize: 6, maxSize: 10), percent: -5))
        self.ladiesSize.append(RingSizeClass.init(sizeset: minMax.init(minSize: 11, maxSize: 14), percent: 5))
        self.ladiesSize.append(RingSizeClass.init(sizeset: minMax.init(minSize: 15, maxSize: 18), percent: 7))
        self.ladiesSize.append(RingSizeClass.init(sizeset: minMax.init(minSize: 19, maxSize: 22), percent: 10))
        
        
        self.gentsSize.append(RingSizeClass.init(sizeset: minMax.init(minSize: 14, maxSize: 17), percent: -5))
        self.gentsSize.append(RingSizeClass.init(sizeset: minMax.init(minSize: 18, maxSize: 21), percent: 5))
        self.gentsSize.append(RingSizeClass.init(sizeset: minMax.init(minSize: 22, maxSize: 25), percent: 8))
        self.gentsSize.append(RingSizeClass.init(sizeset: minMax.init(minSize: 26, maxSize: 30), percent: 12))
        self.gentsSize.append(RingSizeClass.init(sizeset: minMax.init(minSize: 31, maxSize: 34), percent: 15))
    }
    
    //MARK:- Add buttons
    func addTwoButtons() {
        
        if iscame == 0 {
            let theHeight = view.frame.size.height //grabs the height of your view
            
            let btn1 = UIButton(frame: CGRect(x: 0, y: theHeight - 60, width: self.view.frame.width / 2, height: 60))
            let btn2 = UIButton(frame: CGRect(x: self.view.frame.width / 2, y: theHeight - 60, width: self.view.frame.width / 2, height: 60))
            
            btn1.backgroundColor = UIColor.init(red: 25/255, green: 26/255, blue: 125/255, alpha: 1.0)
            btn2.backgroundColor = UIColor.init(named: "base_color")
            
            btn1.setTitle("Add To Cart", for: .normal)
            btn2.setTitle("Go To Cart", for: .normal)
            
            btn1.setTitleColor(.white, for: .normal)
            btn2.setTitleColor(.white, for: .normal)
            
            btn1.addTarget(self, action: #selector(addToCart(_:)), for: .touchUpInside)
            btn2.addTarget(self, action: #selector(buyNow(_:)), for: .touchUpInside)
            
            self.view.addSubview(btn1)
            self.view.addSubview(btn2)
        }else {
            
            let theHeight = view.frame.size.height //grabs the height of your view
            
            let btn1 = UIButton(frame: CGRect(x: 0, y: theHeight - 60, width: self.view.frame.width, height: 60))
           
            
            btn1.backgroundColor = UIColor.systemBlue
           
            
            btn1.setTitle("Update", for: .normal)
            
            
            btn1.setTitleColor(.white, for: .normal)
          
            
            btn1.addTarget(self, action: #selector(updatecart(_:)), for: .touchUpInside)
           
            
            self.view.addSubview(btn1)
            
        }
        
       
    }
    @objc func updatecart(_ sender:UIButton) {
        print(self.cartid)
        self.removeFromCart(pid:self.cartid)
    }
    func removeFromCart(pid:Int) {
        print(pid)
        APIManager.shareInstance.removeCart(productId: "\(pid)", vc: self) { (response) in
            if response == "success" {
                self.addUpdatetocart()
                
            }
        }
    }
    @IBAction func btnAddClicked(_ sender: Any) {
       addtocart()
    }
    @IBAction func btnContinueClicked(_ sender: Any) {
        self.viewPopup.isHidden = true
    }
    
    func addtocart() {
        var assetsArr = [[String:Any]]()
        
        if self.platinumAsset.count > 0 {
            
            var was = "0"
            if self.platinumAsset[0].wastage == "<null>" {
                was = "0"
            }else {
                was = self.platinumAsset[0].wastage
            }
            
            assetsArr.append(["meenacost_option":self.platinumAsset[0].meenacostOption,"meena_cost":self.platinumAsset[0].meenaCost,"option":self.platinumAsset[0].chargesOption,"weight":self.platinumAsset[0].weight,"materialType":"Platinum","wastage":was,"stone_index":"1","purity":self.platinumAsset[0].purity,"productId":self.platinumAsset[0].productID,"metal":"Platinum","makingCharge":self.platinumAsset[0].makingCharge])
            
        }
        if self.goldAsset.count > 0 {
             
            var wastage = self.goldAsset[0].wastage
            
            if wastage == "<null>"
            {
                wastage = "0"
                
            }
            
            assetsArr.append(["meenacost_option":self.goldAsset[self.selectedIndGold].meenacostOption,"meena_cost":self.goldAsset[self.selectedIndGold].meenaCost,"option":self.goldAsset[self.selectedIndGold].chargesOption,"weight":self.goldAsset[self.selectedIndGold].weight,"materialType":self.selectedgoldtype,"wastage":wastage,"stone_index":"1","productId":self.goldAsset[self.selectedIndGold].productID,"metal":"Gold","makingCharge":self.goldAsset[self.selectedIndGold].makingCharge])
            
        }

        if self.silverAsset.count > 0 {
            
            
           var wastage = self.silverAsset[0].wastage
           
           if wastage == "<null>"
           {
               wastage = "0"
               
           }
            
            assetsArr.append(["meenacost_option":self.silverAsset[0].meenacostOption,"meena_cost":self.silverAsset[0].meenaCost,"option":self.silverAsset[0].chargesOption,"weight":self.silverAsset[0].weight,"materialType":"Silver","wastage":wastage,"stone_index":"1","purity":self.silverAsset[0].purity,"productId":self.silverAsset[0].productID,"metal":"Silver","makingCharge":self.silverAsset[0].makingCharge])
            
        }
        
        
        if self.diamondAsset.count > 0 {
            
            for i in 0..<diamondAsset.count {
                
                
               var wastage = diamondAsset[i].wastage
                
                if wastage == "<null>"
                {
                    wastage = "0"
                    
                }
                
                assetsArr.append(["diamondType":diamondAsset[i].jwellerySize,"crtcost_option":diamondAsset[i].crtcostOption,"certification_cost":diamondAsset[i].certificationCost,"meenacost_option":diamondAsset[i].meenacostOption,"meena_cost":diamondAsset[i].meenaCost,"option":"PerGram","weight":diamondAsset[i].weight,"materialType":"\(diamondColorTemp)/\(diamondClarityTemp)","wastage":wastage,"diamond_index":(i+1).toString(),"stone_index":(i+1).toString(),"productId":diamondAsset[i].productID,"metal":"Diamond","makingCharge":diamondAsset[i].makingCharge])
                
            }
            
          
            
        }
        
        if self.stoneAsset.count > 0 {
            
            
            if self.stoneAsset.count > 1 {
                for i in 0..<self.arrFinalStone.count {
                    
                    
                    if self.arrFinalStone[i]["stoneInside"] == nil {
                        
                        var wastage = self.arrFinalStone[i]["wastage"] as! String
                        
                        if wastage == "<null>"
                        {
                            wastage = "0"
                            
                        }
                        
                        assetsArr.append(["option":"PerGram","weight":self.arrFinalStone[i]["weight"] as Any,"materialType":self.arrFinalStone[i]  ["jwellerySize"] as Any,"wastage":wastage,"stone_index":(i+1).toString(),"productId":self.arrFinalStone[i]["productID"] as Any,"metal":"Stone","makingCharge":self.arrFinalStone[i]["makingCharge"] as Any])
                    }else {
                        
                        let temparr = self.arrFinalStone[i]["stoneInside"] as! [[String:Any]]
                        
                        var wastage = temparr[0]["wastage"] as! String
                        
                        if wastage == "<null>"
                        {
                            wastage = "0"
                            
                        }
                        
                        assetsArr.append(["option":"PerGram","weight":temparr[0]["weight"] as Any,"materialType":temparr[0]  ["jwellerySize"] as Any,"wastage":wastage,"stone_index":(i+1).toString(),"productId":temparr[0]["productID"] as Any,"metal":"Stone","makingCharge":temparr[0]["makingCharge"] as Any])
                        
                    }
                    
                    
                }
                
                
            }else {
                for i in 0..<stoneAsset.count {
                    
                    var wastage = self.stoneAsset[i].wastage
                    
                    if wastage == "<null>"
                    {
                        wastage = "0"
                        
                    }
                    
                    assetsArr.append(["option":"PerGram","weight":stoneAsset[i].weight,"materialType":stoneAsset[i].jwellerySize,"wastage":wastage,"stone_index":(i+1).toString(),"productId":stoneAsset[i].productID,"metal":"Stone","makingCharge":stoneAsset[i].makingCharge])
                }
            }
            
            
        
            
        }
        let cell = self.productDetailTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! productSizeCell
        let descell = self.productDetailTableView.cellForRow(at: IndexPath(row: 0, section: 8)) as! productOtherDetailsCell
         
            
        var tempdic = [String:Any]()
        tempdic = ["assests":assetsArr,
                   "flag": "2",
                   "count": self.qty,
        "description": descell.txtDetails.text!,
        
        "jwellery_type": self.product?.data.jwelleryType as! String,
        "product_size": self.productSize,
        "productCode": self.product?.data.productcode as! String,
        "productId": self.product?.data.id.toString() as Any,
        "productName": self.product?.data.productname as! String,
        "productType": self.product?.data.jwelleryType as! String,
        "selectedColor": self.mycolor,
        "userid":  UserDefaults.standard.string(forKey: "userid") as! String]
        
        print(tempdic)
        var temparr = [[String:Any]]()
        temparr.append(tempdic)
        
        let data = ["data":temparr] as! [String:Any]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
            print(jsonData)
            let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
            // here "decoded" is of type `Any`, decoded from JSON data
            print(decoded)
            // you can now cast it with the right type
            
            
                        APIManager.shareInstance.addToCart(data: temparr, vc: self) { (response) in
                            print(response)
                            let status = response["status"] as! Int
                            
                            if status == 200 {
                                self.viewPopup.isHidden = true
                                self.performSegue(withIdentifier: "cart", sender: self)
                            }
                            else {
                               
                                let status = response["message"] as! String
                                self.view.makeToast(status)
                            }
                            
                            
                            //self.performSegue(withIdentifier: "cart", sender: self)
                        }
            
        } catch {
            print(error.localizedDescription)
        }
    }
    func addUpdatetocart() {
        var assetsArr = [[String:Any]]()
        
        if self.platinumAsset.count > 0 {
            
            var was = "0"
            if self.platinumAsset[0].wastage == "<null>" {
                was = "0"
            }else {
                was = self.platinumAsset[0].wastage
            }
            
            assetsArr.append(["meenacost_option":self.platinumAsset[0].meenacostOption,"meena_cost":self.platinumAsset[0].meenaCost,"option":self.platinumAsset[0].chargesOption,"weight":self.platinumAsset[0].weight,"materialType":"Platinum","wastage":was,"stone_index":"1","purity":self.platinumAsset[0].purity,"productId":self.platinumAsset[0].productID,"metal":"Platinum","makingCharge":self.platinumAsset[0].makingCharge])
            
        }
        if self.goldAsset.count > 0 {
             
            var wastage = self.goldAsset[0].wastage
            
            if wastage == "<null>"
            {
                wastage = "0"
                
            }
            
            assetsArr.append(["meenacost_option":self.goldAsset[0].meenacostOption,"meena_cost":self.goldAsset[0].meenaCost,"option":self.goldAsset[0].chargesOption,"weight":self.goldAsset[0].weight,"materialType":self.selectedgoldtype,"wastage":wastage,"stone_index":"1","productId":self.goldAsset[0].productID,"metal":"Gold","makingCharge":self.goldAsset[0].makingCharge])
            
        }

        if self.silverAsset.count > 0 {
    
            assetsArr.append(["meenacost_option":self.silverAsset[self.selectedIndSilver].meenacostOption,"meena_cost":self.silverAsset[self.selectedIndSilver].meenaCost,"option":self.silverAsset[self.selectedIndSilver].chargesOption,"weight":self.silverAsset[self.selectedIndSilver].weight,"materialType":self.selectedsilvertype,"wastage":self.silverAsset[self.selectedIndSilver].wastage,"stone_index":"1","purity":self.silverAsset[self.selectedIndSilver].purity,"productId":self.silverAsset[0].productID,"metal":"Silver","makingCharge":self.silverAsset[self.selectedIndSilver].makingCharge])
            
        }
        
        
        if self.diamondAsset.count > 0 {
            
            for i in 0..<diamondAsset.count {
                
                
               var wastage = diamondAsset[i].wastage
                
                if wastage == "<null>"
                {
                    wastage = "0"
                    
                }
                
                assetsArr.append(["diamondType":diamondAsset[i].jwellerySize,"crtcost_option":diamondAsset[i].crtcostOption,"certification_cost":diamondAsset[i].certificationCost,"meenacost_option":diamondAsset[i].meenacostOption,"meena_cost":diamondAsset[i].meenaCost,"option":"PerGram","weight":diamondAsset[i].weight,"materialType":"\(diamondColorTemp)/\(diamondClarityTemp)","wastage":wastage,"diamond_index":(i+1).toString(),"stone_index":(i+1).toString(),"productId":diamondAsset[i].productID,"metal":"Diamond","makingCharge":diamondAsset[i].makingCharge])
                
            }
            
          
            
        }
        
        if self.stoneAsset.count > 0 {
            
            
            if self.stoneAsset.count > 1 {
                for i in 0..<self.arrFinalStone.count {
                    
                    
                    if self.arrFinalStone[i]["stoneInside"] == nil {
                        
                        var wastage = self.arrFinalStone[i]["wastage"] as! String
                        
                        if wastage == "<null>"
                        {
                            wastage = "0"
                            
                        }
                        
                        assetsArr.append(["option":"PerGram","weight":self.arrFinalStone[i]["weight"] as Any,"materialType":self.arrFinalStone[i]  ["jwellerySize"] as Any,"wastage":wastage,"stone_index":(i+1).toString(),"productId":self.arrFinalStone[i]["productID"] as Any,"metal":"Stone","makingCharge":self.arrFinalStone[i]["makingCharge"] as Any])
                    }else {
                        
                        let temparr = self.arrFinalStone[i]["stoneInside"] as! [[String:Any]]
                        
                        var wastage = temparr[0]["wastage"] as! String
                        
                        if wastage == "<null>"
                        {
                            wastage = "0"
                            
                        }
                        
                        assetsArr.append(["option":"PerGram","weight":temparr[0]["weight"] as Any,"materialType":temparr[0]  ["jwellerySize"] as Any,"wastage":wastage,"stone_index":(i+1).toString(),"productId":temparr[0]["productID"] as Any,"metal":"Stone","makingCharge":temparr[0]["makingCharge"] as Any])
                        
                    }
                    
                    
                }
                
                
            }else {
                for i in 0..<stoneAsset.count {
                    
                    var wastage = self.stoneAsset[i].wastage
                    
                    if wastage == "<null>"
                    {
                        wastage = "0"
                        
                    }
                    
                    assetsArr.append(["option":"PerGram","weight":stoneAsset[i].weight,"materialType":stoneAsset[i].jwellerySize,"wastage":wastage,"stone_index":(i+1).toString(),"productId":stoneAsset[i].productID,"metal":"Stone","makingCharge":stoneAsset[i].makingCharge])
                }
            }
            
            
        
            
        }
        let cell = self.productDetailTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! productSizeCell
        let descell = self.productDetailTableView.cellForRow(at: IndexPath(row: 0, section: 8)) as! productOtherDetailsCell
         
            
        var tempdic = [String:Any]()
        tempdic = ["assests":assetsArr,
                   "flag": "1",
                   "count": self.qty,
        "description": descell.txtDetails.text!,
        
        "jwellery_type": self.product?.data.jwelleryType as! String,
        "product_size": self.productSize,
        "productCode": self.product?.data.productcode as! String,
        "productId": self.product?.data.id.toString() as Any,
        "productName": self.product?.data.productname as! String,
        "productType": self.product?.data.jwelleryType as! String,
        "selectedColor": self.mycolor,
        "userid":  UserDefaults.standard.string(forKey: "userid") as! String]
        
        print(tempdic)
        var temparr = [[String:Any]]()
        temparr.append(tempdic)
        
        let data = ["data":temparr] as! [String:Any]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
            print(jsonData)
            let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
            // here "decoded" is of type `Any`, decoded from JSON data
            print(decoded)
            // you can now cast it with the right type
            
            
                        APIManager.shareInstance.addToCart(data: temparr, vc: self) { (response) in
                            print(response)
                            let status = response["status"] as! Int
                            
                            if status == 200 {
                                self.viewPopup.isHidden = true
                                self.performSegue(withIdentifier: "cart", sender: self)
                            }
                            else {
                               
                                let status = response["message"] as! String
                                self.view.makeToast(status)
                            }
                            
                            
                            //self.performSegue(withIdentifier: "cart", sender: self)
                        }
            
        } catch {
            print(error.localizedDescription)
        }
    }
    @objc func addToCart(_ sender:UIButton) {
//      let data =   ["data":[["assests":[],"category":"2","count":1,"description":"<p>Diamond Ladies Ring</p>","jwellery_type":"Ring","productCode":"JMBJ-DLR11","productId":27,"productName":"Diamond Ladies Ring","productType":"Ring","product_size":"12","selectedColor":"Yellow","subCategory":"2","subSubCategory":"27","userid":"11"]]]
        var assetsArr = [[String:Any]]()
        
        if self.platinumAsset.count > 0 {
            
            var was = "0"
            if self.platinumAsset[0].wastage == "<null>" {
                was = "0"
            }else {
                was = self.platinumAsset[0].wastage
            }
            
            assetsArr.append(["meenacost_option":self.platinumAsset[0].meenacostOption,"meena_cost":self.platinumAsset[0].meenaCost,"option":self.platinumAsset[0].chargesOption,"weight":self.platinumAsset[0].weight,"materialType":"Platinum","wastage":was,"stone_index":"1","purity":self.platinumAsset[0].purity,"productId":self.platinumAsset[0].productID,"metal":"Platinum","makingCharge":self.platinumAsset[0].makingCharge])
            
        }
        
        if self.goldAsset.count > 0 {
             
            var wastage = self.goldAsset[0].wastage
            
            if wastage == "<null>"
            {
                wastage = "0"
                
            }
            
            assetsArr.append(["meenacost_option":self.goldAsset[self.selectedIndGold].meenacostOption,"meena_cost":self.goldAsset[self.selectedIndGold].meenaCost,"option":self.goldAsset[self.selectedIndGold].chargesOption,"weight":self.goldAsset[self.selectedIndGold].weight,"materialType":self.selectedgoldtype,"wastage":wastage,"stone_index":"1","productId":self.goldAsset[self.selectedIndGold].productID,"metal":"Gold","makingCharge":self.goldAsset[self.selectedIndGold].makingCharge])
            
        }

        if self.silverAsset.count > 0 {
    
            assetsArr.append(["meenacost_option":self.silverAsset[self.selectedIndSilver].meenacostOption,"meena_cost":self.silverAsset[self.selectedIndSilver].meenaCost,"option":self.silverAsset[self.selectedIndSilver].chargesOption,"weight":self.silverAsset[self.selectedIndSilver].weight,"materialType":self.selectedsilvertype,"wastage":self.silverAsset[self.selectedIndSilver].wastage,"stone_index":"1","purity":self.silverAsset[self.selectedIndSilver].purity,"productId":self.silverAsset[0].productID,"metal":"Silver","makingCharge":self.silverAsset[self.selectedIndSilver].makingCharge])
            
        }
        
        
        if self.diamondAsset.count > 0 {
            
            for i in 0..<diamondAsset.count {
                
                
               var wastage = diamondAsset[i].wastage
                
                if wastage == "<null>"
                {
                    wastage = "0"
                    
                }
                
                assetsArr.append(["diamondType":diamondAsset[i].jwellerySize,"crtcost_option":diamondAsset[i].crtcostOption,"certification_cost":diamondAsset[i].certificationCost,"meenacost_option":diamondAsset[i].meenacostOption,"meena_cost":diamondAsset[i].meenaCost,"option":"PerGram","weight":diamondAsset[i].weight,"materialType":"\(diamondColorTemp)/\(diamondClarityTemp)","wastage":wastage,"diamond_index":(i+1).toString(),"stone_index":(i+1).toString(),"productId":diamondAsset[i].productID,"metal":"Diamond","makingCharge":diamondAsset[i].makingCharge])
                
            }
            
          
            
        }
        
        if self.stoneAsset.count > 0 {
            
            
            if self.stoneAsset.count > 1 {
                for i in 0..<self.arrFinalStone.count {
                    
                    
                    if self.arrFinalStone[i]["stoneInside"] == nil {
                        
                        var wastage = self.arrFinalStone[i]["wastage"] as! String
                        
                        if wastage == "<null>"
                        {
                            wastage = "0"
                            
                        }
                        
                        assetsArr.append(["option":"PerGram","weight":self.arrFinalStone[i]["weight"] as Any,"materialType":self.arrFinalStone[i]  ["jwellerySize"] as Any,"wastage":wastage,"stone_index":(i+1).toString(),"productId":self.arrFinalStone[i]["productID"] as Any,"metal":"Stone","makingCharge":self.arrFinalStone[i]["makingCharge"] as Any])
                    }else {
                        
                        let temparr = self.arrFinalStone[i]["stoneInside"] as! [[String:Any]]
                        
                        var wastage = temparr[0]["wastage"] as! String
                        
                        if wastage == "<null>"
                        {
                            wastage = "0"
                            
                        }
                        
                        assetsArr.append(["option":"PerGram","weight":temparr[0]["weight"] as Any,"materialType":temparr[0]  ["jwellerySize"] as Any,"wastage":wastage,"stone_index":(i+1).toString(),"productId":temparr[0]["productID"] as Any,"metal":"Stone","makingCharge":temparr[0]["makingCharge"] as Any])
                        
                    }
                    
                    
                }
                
                
            }else {
                for i in 0..<stoneAsset.count {
                    
                    var wastage = self.stoneAsset[i].wastage
                    
                    if wastage == "<null>"
                    {
                        wastage = "0"
                        
                    }
                    
                    assetsArr.append(["option":"PerGram","weight":stoneAsset[i].weight,"materialType":stoneAsset[i].jwellerySize,"wastage":wastage,"stone_index":(i+1).toString(),"productId":stoneAsset[i].productID,"metal":"Stone","makingCharge":stoneAsset[i].makingCharge])
                }
            }
            
            
        
            
        }
        let cell = self.productDetailTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! productSizeCell
        let descell = self.productDetailTableView.cellForRow(at: IndexPath(row: 0, section: 8)) as! productOtherDetailsCell
         
            
        var tempdic = [String:Any]()
        tempdic = ["assests":assetsArr,
                   "flag": "1",
                   "count": self.qty,
        "description": descell.txtDetails.text!,
        
        "jwellery_type": self.product?.data.jwelleryType as! String,
        "product_size": self.productSize,
        "productCode": self.product?.data.productcode as! String,
        "productId": self.product?.data.id.toString() as Any,
        "productName": self.product?.data.productname as! String,
        "productType": self.product?.data.jwelleryType as! String,
        "selectedColor": self.mycolor,
        "userid":  UserDefaults.standard.string(forKey: "userid") as! String]
        
        print(tempdic)
        var temparr = [[String:Any]]()
        temparr.append(tempdic)
        
        let data = ["data":temparr] as! [String:Any]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
            print(jsonData)
            let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
            // here "decoded" is of type `Any`, decoded from JSON data
            print(decoded)
            // you can now cast it with the right type
            
            
                        APIManager.shareInstance.addToCart(data: temparr, vc: self) { (response) in
                            print(response)
                            
                            let status = response["status"] as! Int
                            
                            if status == 200 {
                                self.getAllData()
                            }else if status == 206 {
                                
                                self.viewPopup.isHidden = false
                                let manufacture_name = response["manufacture_name"] as! String
                                self.btnContinue.setTitle("Continue Shopping \(manufacture_name)", for: .normal)
                                self.btnAdd.setTitle("Add To Cart \(self.product?.manufacture.companyName as! String)", for: .normal)
                                
                                self.lblPopTitle.text = "Your cart has existing item from \(manufacture_name) Do you want clear it and add item from \(self.product?.manufacture.companyName as! String)"
                            }
                            else {
                               
                                let status = response["message"] as! String
                                self.view.makeToast(status)
                            }
            
                            //self.performSegue(withIdentifier: "cart", sender: self)
                        }
            
        } catch {
            print(error.localizedDescription)
        }
            

        }
    
    
    @objc func buyNow(_ sender:UIButton) {
        var assetsArr = [[String:Any]]()
        
        if self.platinumAsset.count > 0 {
            
            assetsArr.append(["meenacost_option":self.platinumAsset[0].meenacostOption,"meena_cost":self.platinumAsset[0].meenaCost,"option":self.platinumAsset[0].chargesOption,"weight":self.platinumAsset[0].weight,"materialType":"Platinum","wastage":self.platinumAsset[0].wastage,"stone_index":"1","purity":self.platinumAsset[0].purity,"productId":self.platinumAsset[0].productID,"metal":"Platinum","makingCharge":self.platinumAsset[0].makingCharge])
            
        }
        
        if self.goldAsset.count > 0 {
             
            var wastage = self.goldAsset[0].wastage
            
            if wastage == "<null>"
            {
                wastage = "0"
                
            }
            
            assetsArr.append(["meenacost_option":self.goldAsset[0].meenacostOption,"meena_cost":self.goldAsset[0].meenaCost,"option":self.goldAsset[0].chargesOption,"weight":self.goldAsset[0].weight,"materialType":self.goldAsset[0].jwellerySize,"wastage":wastage,"stone_index":"1","productId":self.goldAsset[0].productID,"metal":"Gold","makingCharge":self.goldAsset[0].makingCharge])
            
        }

        if self.silverAsset.count > 0 {
    
            assetsArr.append(["meenacost_option":self.silverAsset[self.selectedIndSilver].meenacostOption,"meena_cost":self.silverAsset[self.selectedIndSilver].meenaCost,"option":self.silverAsset[self.selectedIndSilver].chargesOption,"weight":self.silverAsset[self.selectedIndSilver].weight,"materialType":self.selectedsilvertype,"wastage":self.silverAsset[self.selectedIndSilver].wastage,"stone_index":"1","purity":self.silverAsset[self.selectedIndSilver].purity,"productId":self.silverAsset[0].productID,"metal":"Silver","makingCharge":self.silverAsset[self.selectedIndSilver].makingCharge])
            
        }
        
        
        if self.diamondAsset.count > 0 {
            
            for i in 0..<diamondAsset.count {
                
                
               var wastage = diamondAsset[i].wastage
                
                if wastage == "<null>"
                {
                    wastage = "0"
                    
                }
                
                assetsArr.append(["diamondType":diamondAsset[i].jwellerySize,"crtcost_option":diamondAsset[i].crtcostOption,"certification_cost":diamondAsset[i].certificationCost,"meenacost_option":diamondAsset[i].meenacostOption,"meena_cost":diamondAsset[i].meenaCost,"option":"PerGram","weight":diamondAsset[i].weight,"materialType":"\(diamondColorTemp)/\(diamondClarityTemp)","wastage":wastage,"diamond_index":(i+1).toString(),"stone_index":(i+1).toString(),"productId":diamondAsset[i].productID,"metal":"Diamond","makingCharge":diamondAsset[i].makingCharge])
                
            }
            
          
            
        }
        
        if self.stoneAsset.count > 0 {
            
            
            if self.stoneAsset.count > 1 {
                for i in 0..<self.arrFinalStone.count {
                    
                    
                    if self.arrFinalStone[i]["stoneInside"] == nil {
                        
                        var wastage = self.arrFinalStone[i]["wastage"] as! String
                        
                        if wastage == "<null>"
                        {
                            wastage = "0"
                            
                        }
                        
                        assetsArr.append(["option":"PerGram","weight":self.arrFinalStone[i]["weight"] as Any,"materialType":self.arrFinalStone[i]  ["jwellerySize"] as Any,"wastage":wastage,"stone_index":(i+1).toString(),"productId":self.arrFinalStone[i]["productID"] as Any,"metal":"Stone","makingCharge":self.arrFinalStone[i]["makingCharge"] as Any])
                    }else {
                        
                        let temparr = self.arrFinalStone[i]["stoneInside"] as! [[String:Any]]
                        
                        var wastage = temparr[0]["wastage"] as! String
                        
                        if wastage == "<null>"
                        {
                            wastage = "0"
                            
                        }
                        
                        assetsArr.append(["option":"PerGram","weight":temparr[0]["weight"] as Any,"materialType":temparr[0]  ["jwellerySize"] as Any,"wastage":wastage,"stone_index":(i+1).toString(),"productId":temparr[0]["productID"] as Any,"metal":"Stone","makingCharge":temparr[0]["makingCharge"] as Any])
                        
                    }
                    
                    
                }
                
                
            }else {
                for i in 0..<stoneAsset.count {
                    
                    var wastage = self.stoneAsset[i].wastage
                    
                    if wastage == "<null>"
                    {
                        wastage = "0"
                        
                    }
                    
                    assetsArr.append(["option":"PerGram","weight":stoneAsset[i].weight,"materialType":stoneAsset[i].jwellerySize,"wastage":wastage,"stone_index":(i+1).toString(),"productId":stoneAsset[i].productID,"metal":"Stone","makingCharge":stoneAsset[i].makingCharge])
                }
            }
            
            
        
            
        }
        let cell = self.productDetailTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! productSizeCell
        let descell = self.productDetailTableView.cellForRow(at: IndexPath(row: 0, section: 8)) as! productOtherDetailsCell
         
            
        var tempdic = [String:Any]()
        tempdic = ["assests":assetsArr,
                   "flag": "1",
                   "count": self.qty,
        "description": descell.txtDetails.text!,
        
        "jwellery_type": self.product?.data.jwelleryType as! String,
        "product_size": self.productSize,
        "productCode": self.product?.data.productcode as! String,
        "productId": self.product?.data.id.toString() as Any,
        "productName": self.product?.data.productname as! String,
        "productType": self.product?.data.jwelleryType as! String,
        "selectedColor": self.mycolor,
        "userid":  UserDefaults.standard.string(forKey: "userid") as! String]
        
        print(tempdic)
        var temparr = [[String:Any]]()
        temparr.append(tempdic)
        
        let data = ["data":temparr] as! [String:Any]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
            print(jsonData)
            let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
            // here "decoded" is of type `Any`, decoded from JSON data
            print(decoded)
            // you can now cast it with the right type
            
            
                        APIManager.shareInstance.addToCart(data: temparr, vc: self) { (response) in
                            print(response)
                            
                            let status = response["status"] as! Int
                            
                            if status == 200 || status == 401{
                                self.performSegue(withIdentifier: "cart", sender: self)
                            }else if status == 206 {
                                
                                self.viewPopup.isHidden = false
                                let manufacture_name = response["manufacture_name"] as! String
                                self.btnContinue.setTitle("Continue Shopping \(manufacture_name)", for: .normal)
                                self.btnAdd.setTitle("Add To Cart \(self.product?.manufacture.companyName as! String)", for: .normal)
                                
                                self.lblPopTitle.text = "Your cart has existing item from \(manufacture_name) Do you want clear it and add item from \(self.product?.manufacture.companyName as! String)"
                            }
                            else {
                               
                                let status = response["message"] as! String
                                self.view.makeToast(status)
                            }
            
                            //self.performSegue(withIdentifier: "cart", sender: self)
                        }
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    //MARK:-Color Action
    @objc func colorSelect(_ sender:UIButton) {
        let cell = self.productDetailTableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! productColorCell
        if sender.tag == 1 {
            cell.roseBtn.setImage(UIImage.init(named: "icons8-checkmark"), for: .normal)
            cell.goldBtn.setImage(nil, for: .normal)
            cell.whiteBtn.setImage(nil, for: .normal)
            self.mycolor = "Rose"
        } else if sender.tag == 2 {
            cell.roseBtn.setImage(nil, for: .normal)
            cell.goldBtn.setImage(UIImage.init(named: "icons8-checkmark"), for: .normal)
            cell.whiteBtn.setImage(nil, for: .normal)
            self.mycolor = "Gold"
        } else if sender.tag == 3 {
            cell.roseBtn.setImage(nil, for: .normal)
            cell.goldBtn.setImage(nil, for: .normal)
            cell.whiteBtn.setImage(UIImage.init(named: "icons8-checkmark"), for: .normal)
            self.mycolor = "White"
        }
    }
    
    //MARK:- Size Actions
    @objc func selectSizeBangle(_ sender:UIButton) {
        let actionSheet = UIAlertController(title: "Message", message: "Select Size", preferredStyle: .actionSheet)
        actionSheet.popoverPresentationController?.sourceView = sender
        actionSheet.popoverPresentationController?.sourceRect = sender.bounds
        
        for i in 0 ..< self.product!.price.bangle.count {
            actionSheet.addAction(UIAlertAction.init(title: self.product?.price.bangle[i].bangleSize, style: .default, handler: { (_) in
                for ii in self.product!.price.bangle {
                    if ii.bangleSize == self.product?.price.bangle[i].bangleSize {
                        self.changeSize(index: ii.sizes.toInt(), selectedTxt: (self.product?.price.bangle[i].bangleSize)!)
                    }
                }
            }))
        }
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (_) in
            
        }))
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    //MARK:- Change Size
    func changeSize(index:Int,selectedTxt:String) {
        
        self.selectedsizeindex = index
        if self.prodType == "GOLD JEWELLERY" {
            
            let tempwieght = self.originalWeight
           // self.originalWeight = self.goldAsset[self.selectedIndGold].weight
            let defaultSize = self.product?.data.defaultSize.toInt()
            
            self.selectedBangleSize = selectedTxt
            self.issizechanged = "1"
            if selectedTxt == self.defaultSizeBangle {
                
                self.priceLbl.text = self.calculateTotalPrice()
                let cell = self.productDetailTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! productSizeCell
                cell.btnSize.setTitle(selectedTxt, for: .normal)
                self.productSize = selectedTxt
                
                
                if self.originalWeight != "" {
                    
                    
                    for i in 0..<goldweightnochange.count {
                        
                        let finalWeight = goldweightnochange[i]
                        self.originalDefaultWeight = finalWeight.toString()
                      //  self.goldAsset[self.selectedIndGold].weight = finalWeight.toString()
                        self.goldAsset[i].weight = finalWeight.toString()
                        
                        self.priceLbl.text = self.calculateTotalPrice()
                        
                        //self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 1),IndexPath.init(row: 0, section: 9)], with: .automatic)
                    }
                    
                    
                    
                    
                    //self.goldAsset[self.selectedIndGold].weight = tempwieght
                    self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 1),IndexPath.init(row: 0, section: 9)], with: .automatic)
                }
                if self.originalWeightsilver != "" {
    
                    self.silverAsset[0].weight = originalWeightsilver
                    self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 6),IndexPath.init(row: 0, section: 9)], with: .automatic)
                }
                if self.originalWeightplat != "" {
                    
                    self.platinumAsset[0].weight = originalWeightplat
                 self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 4),IndexPath.init(row: 0, section: 4)], with: .automatic)
                }
                
                self.calculateWeight()
            } else if selectedTxt != self.defaultSizeBangle {
                self.selectedBangleSize = selectedTxt
                let calc1 = index - defaultSize!
                var calc2 = 1.0
                
                if calc1 > 0 {
                    for i in 0..<calc1 {
                        calc2 += Double(calc2)*0.05
                    }
                }else if calc1 < 0 {
                    let c = removeSpecialCharsFromString(text: "\(calc1)")
                    let cal = Int(c)
                    for i in 0..<cal! {
                        calc2 -= Double(calc2)*0.05
                    }
                }
                if self.originalWeight != "" {

                    for i in 0..<goldweightchange.count {
                        
                        let finalWeight = calc2 * goldweightchange[i]
                        self.originalDefaultWeight = finalWeight.toString()
                      //  self.goldAsset[self.selectedIndGold].weight = finalWeight.toString()
                        self.goldAsset[i].weight = finalWeight.toString()
                        
                        self.priceLbl.text = self.calculateTotalPrice()
                        
                        
                    }
                    self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 1),IndexPath.init(row: 0, section: 9)], with: .automatic)
                    
                }
    
                if self.originalWeightsilver != "" {
    
                    let finalWeight = calc2 * self.originalWeightsilver.toDouble()
                   
                    self.silverAsset[0].weight = finalWeight.toString()
                    self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 6),IndexPath.init(row: 0, section: 6)], with: .automatic)
                }
                
                if self.originalWeightplat != "" {
                    
                    let finalWeight = calc2 * self.originalWeightplat.toDouble()
                    self.platinumAsset[0].weight = finalWeight.toString()
                 self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 4),IndexPath.init(row: 0, section: 4)], with: .automatic)
                }
                
                
               // let percent = calc2 / 100
                
                
                
                
                let cell = self.productDetailTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! productSizeCell
               // let cell = self.productDetailTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! productSizeCell
                cell.btnSize.setTitle(selectedTxt, for: .normal)
              //  self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 1),IndexPath.init(row: 0, section: 9)], with: .automatic)
                self.calculateWeight()
                
                self.productSize = selectedTxt
            }
        }
        else if self.prodType == "DIAMOND JEWELLERY" {
            
            let tempwieght = self.originalWeight
            
            let defaultSize = self.product?.data.defaultSize.toInt()
            
            
            if selectedTxt == self.defaultSizeBangle {
                
                
                self.priceLbl.text = self.calculateTotalPrice()
                let cell = self.productDetailTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! productSizeCell
                cell.btnSize.setTitle(selectedTxt, for: .normal)
                self.productSize = selectedTxt
                
                
                if self.originalWeight != "" {
                    for i in 0..<goldweightnochange.count {
                        
                        let finalWeight = goldweightnochange[i]
                        self.originalDefaultWeight = finalWeight.toString()
                      //  self.goldAsset[self.selectedIndGold].weight = finalWeight.toString()
                        self.goldAsset[i].weight = finalWeight.toString()
                        
                        self.priceLbl.text = self.calculateTotalPrice()
                        
                        //self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 1),IndexPath.init(row: 0, section: 9)], with: .automatic)
                    }
                    self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 2),IndexPath.init(row: 0, section: 9)], with: .automatic)
                }
                if self.originalWeightsilver != "" {
    
                    self.silverAsset[0].weight = originalWeightsilver
                    self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 6),IndexPath.init(row: 0, section: 9)], with: .automatic)
                }
                if self.originalWeightplat != "" {
                    
                    self.platinumAsset[0].weight = originalWeightplat
                 self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 4),IndexPath.init(row: 0, section: 4)], with: .automatic)
                }
                
                self.calculateWeight()
            } else if selectedTxt != self.defaultSizeBangle {
                let calc1 = index - defaultSize!
                var calc2 = 1.0
                
                if calc1 > 0 {
                    for i in 0..<calc1 {
                        calc2 += Double(calc2)*0.05
                    }
                }else if calc1 < 0 {
                    let c = removeSpecialCharsFromString(text: "\(calc1)")
                    let cal = Int(c)
                    for i in 0..<cal! {
                        calc2 -= Double(calc2)*0.05
                    }
                }
                if self.originalWeight != "" {
                    for i in 0..<goldweightchange.count {
                        
                        let finalWeight = calc2 * goldweightchange[i]
                        self.originalDefaultWeight = finalWeight.toString()
                      //  self.goldAsset[self.selectedIndGold].weight = finalWeight.toString()
                        self.goldAsset[i].weight = finalWeight.toString()
                        
                        self.priceLbl.text = self.calculateTotalPrice()
                        
                        
                    }
                    
                    self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 2),IndexPath.init(row: 0, section: 9)], with: .automatic)
                }
    
                if self.originalWeightsilver != "" {
    
                    let finalWeight = calc2 * self.originalWeightsilver.toDouble()
                   
                    self.silverAsset[0].weight = finalWeight.toString()
                    self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 6),IndexPath.init(row: 0, section: 6)], with: .automatic)
                }
                
                if self.originalWeightplat != "" {
                    
                    let finalWeight = calc2 * self.originalWeightplat.toDouble()
                    self.platinumAsset[0].weight = finalWeight.toString()
                 self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 4),IndexPath.init(row: 0, section: 4)], with: .automatic)
                }
                
                
               // let percent = calc2 / 100
                
                
                
                
                let cell = self.productDetailTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! productSizeCell
               // let cell = self.productDetailTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! productSizeCell
                cell.btnSize.setTitle(selectedTxt, for: .normal)
              //  self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 1),IndexPath.init(row: 0, section: 9)], with: .automatic)
                self.calculateWeight()
                
                self.productSize = selectedTxt
            }
        }
        else if self.prodType == "PLATINUM JEWELLERY"
        {
            
            let tempwieght = self.originalWeight
            
            let defaultSize = self.product?.data.defaultSize.toInt()
            
            
            if selectedTxt == self.defaultSizeBangle {
                
                
                self.priceLbl.text = self.calculateTotalPrice()
                let cell = self.productDetailTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! productSizeCell
                cell.btnSize.setTitle(selectedTxt, for: .normal)
                self.productSize = selectedTxt
                
                
                if self.originalWeight != "" {
                    for i in 0..<goldweightnochange.count {
                        
                        let finalWeight = goldweightnochange[i]
                        self.originalDefaultWeight = finalWeight.toString()
                      //  self.goldAsset[self.selectedIndGold].weight = finalWeight.toString()
                        self.goldAsset[i].weight = finalWeight.toString()
                        
                        self.priceLbl.text = self.calculateTotalPrice()
                        
                        //self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 1),IndexPath.init(row: 0, section: 9)], with: .automatic)
                    }
                    self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 4),IndexPath.init(row: 0, section: 9)], with: .automatic)
                }
                if self.originalWeightsilver != "" {
    
                    self.silverAsset[0].weight = originalWeightsilver
                    self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 6),IndexPath.init(row: 0, section: 9)], with: .automatic)
                }
                if self.originalWeightplat != "" {
                    
                    self.platinumAsset[0].weight = originalWeightplat
                 self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 1),IndexPath.init(row: 0, section: 4)], with: .automatic)
                }
                
                self.calculateWeight()
            } else if selectedTxt != self.defaultSizeBangle {
                let calc1 = index - defaultSize!
                var calc2 = 1.0
                
                if calc1 > 0 {
                    for i in 0..<calc1 {
                        calc2 += Double(calc2)*0.05
                    }
                }else if calc1 < 0 {
                    let c = removeSpecialCharsFromString(text: "\(calc1)")
                    let cal = Int(c)
                    for i in 0..<cal! {
                        calc2 -= Double(calc2)*0.05
                    }
                }
                if self.originalWeight != "" {
                    for i in 0..<goldweightchange.count {
                        
                        let finalWeight = calc2 * goldweightchange[i]
                        self.originalDefaultWeight = finalWeight.toString()
                      //  self.goldAsset[self.selectedIndGold].weight = finalWeight.toString()
                        self.goldAsset[i].weight = finalWeight.toString()
                        
                        self.priceLbl.text = self.calculateTotalPrice()
                        
                        
                    }
                    
                    self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 4),IndexPath.init(row: 0, section: 9)], with: .automatic)
                }
    
                if self.originalWeightsilver != "" {
    
                    let finalWeight = calc2 * self.originalWeightsilver.toDouble()
                   
                    self.silverAsset[0].weight = finalWeight.toString()
                    self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 6),IndexPath.init(row: 0, section: 6)], with: .automatic)
                }
                
                if self.originalWeightplat != "" {
                    
                    let finalWeight = calc2 * self.originalWeightplat.toDouble()
                    self.platinumAsset[0].weight = finalWeight.toString()
                 self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 1),IndexPath.init(row: 0, section: 4)], with: .automatic)
                }
                
                
               // let percent = calc2 / 100
                
                
                
                
                let cell = self.productDetailTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! productSizeCell
               // let cell = self.productDetailTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! productSizeCell
                cell.btnSize.setTitle(selectedTxt, for: .normal)
              //  self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 1),IndexPath.init(row: 0, section: 9)], with: .automatic)
                self.calculateWeight()
                
                self.productSize = selectedTxt
            }
            
        }
        else if self.prodType == "SILVER JEWELLERY"
        {
            
            let tempwieght = self.originalWeight
            
            let defaultSize = self.product?.data.defaultSize.toInt()
            
            
            if selectedTxt == self.defaultSizeBangle {
                
                
                self.priceLbl.text = self.calculateTotalPrice()
                let cell = self.productDetailTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! productSizeCell
                cell.btnSize.setTitle(selectedTxt, for: .normal)
                self.productSize = selectedTxt
                
                
                if self.originalWeight != "" {
                    for i in 0..<goldweightnochange.count {
                        
                        let finalWeight = goldweightnochange[i]
                        self.originalDefaultWeight = finalWeight.toString()
                      //  self.goldAsset[self.selectedIndGold].weight = finalWeight.toString()
                        self.goldAsset[i].weight = finalWeight.toString()
                        
                        self.priceLbl.text = self.calculateTotalPrice()
                        
                        //self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 1),IndexPath.init(row: 0, section: 9)], with: .automatic)
                    }
                    self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 5),IndexPath.init(row: 0, section: 5)], with: .automatic)
                }
                if self.originalWeightsilver != "" {
    
                    self.silverAsset[0].weight = originalWeightsilver
                    self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 1),IndexPath.init(row: 0, section: 9)], with: .automatic)
                }
                if self.originalWeightplat != "" {
                    
                    self.platinumAsset[0].weight = originalWeightplat
                 self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 4),IndexPath.init(row: 0, section: 4)], with: .automatic)
                }
                
                self.calculateWeight()
            } else if selectedTxt != self.defaultSizeBangle {
                let calc1 = index - defaultSize!
                var calc2 = 1.0
                
                if calc1 > 0 {
                    for i in 0..<calc1 {
                        calc2 += Double(calc2)*0.05
                    }
                }else if calc1 < 0 {
                    let c = removeSpecialCharsFromString(text: "\(calc1)")
                    let cal = Int(c)
                    for i in 0..<cal! {
                        calc2 -= Double(calc2)*0.05
                    }
                }
                if self.originalWeight != "" {
                    for i in 0..<goldweightchange.count {
                        
                        let finalWeight = calc2 * goldweightchange[i]
                        self.originalDefaultWeight = finalWeight.toString()
                      //  self.goldAsset[self.selectedIndGold].weight = finalWeight.toString()
                        self.goldAsset[i].weight = finalWeight.toString()
                        
                        self.priceLbl.text = self.calculateTotalPrice()
                        
                        
                    }
                    
                    self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 5),IndexPath.init(row: 0, section: 5)], with: .automatic)
                }
    
                if self.originalWeightsilver != "" {
    
                    let finalWeight = calc2 * self.originalWeightsilver.toDouble()
                   
                    self.silverAsset[0].weight = finalWeight.toString()
                    self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 1),IndexPath.init(row: 0, section: 9)], with: .automatic)
                }
                
                if self.originalWeightplat != "" {
                    
                    let finalWeight = calc2 * self.originalWeightplat.toDouble()
                    self.platinumAsset[0].weight = finalWeight.toString()
                 self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 4),IndexPath.init(row: 0, section: 4)], with: .automatic)
                }
                
                
               // let percent = calc2 / 100
                
                
                
                
                let cell = self.productDetailTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! productSizeCell
               // let cell = self.productDetailTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! productSizeCell
                cell.btnSize.setTitle(selectedTxt, for: .normal)
              //  self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 1),IndexPath.init(row: 0, section: 9)], with: .automatic)
                self.calculateWeight()
                
                self.productSize = selectedTxt
            }
            
        }else {
            
            let tempwieght = self.originalWeight
            
            let defaultSize = self.product?.data.defaultSize.toInt()
            
            
            if selectedTxt == self.defaultSizeBangle {
                
                
                self.priceLbl.text = self.calculateTotalPrice()
                let cell = self.productDetailTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! productSizeCell
                cell.btnSize.setTitle(selectedTxt, for: .normal)
                self.productSize = selectedTxt
                
                
                if self.originalWeight != "" {
                    for i in 0..<goldweightnochange.count {
                        
                        let finalWeight = goldweightnochange[i]
                        self.originalDefaultWeight = finalWeight.toString()
                      //  self.goldAsset[self.selectedIndGold].weight = finalWeight.toString()
                        self.goldAsset[i].weight = finalWeight.toString()
                        
                        self.priceLbl.text = self.calculateTotalPrice()
                        
                        //self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 1),IndexPath.init(row: 0, section: 9)], with: .automatic)
                    }
                    self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 1),IndexPath.init(row: 0, section: 9)], with: .automatic)
                }
                if self.originalWeightsilver != "" {
    
                    self.silverAsset[0].weight = originalWeightsilver
                    self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 6),IndexPath.init(row: 0, section: 9)], with: .automatic)
                }
                if self.originalWeightplat != "" {
                    
                    self.platinumAsset[0].weight = originalWeightplat
                 self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 4),IndexPath.init(row: 0, section: 4)], with: .automatic)
                }
                
                self.calculateWeight()
            } else if selectedTxt != self.defaultSizeBangle {
                let calc1 = index - defaultSize!
                var calc2 = 1.0
                
                if calc1 > 0 {
                    for i in 0..<calc1 {
                        calc2 += Double(calc2)*0.05
                    }
                }else if calc1 < 0 {
                    let c = removeSpecialCharsFromString(text: "\(calc1)")
                    let cal = Int(c)
                    for i in 0..<cal! {
                        calc2 -= Double(calc2)*0.05
                    }
                }
                if self.originalWeight != "" {
                    for i in 0..<goldweightchange.count {
                        
                        let finalWeight = calc2 * goldweightchange[i]
                        self.originalDefaultWeight = finalWeight.toString()
                      //  self.goldAsset[self.selectedIndGold].weight = finalWeight.toString()
                        self.goldAsset[i].weight = finalWeight.toString()
                        
                        self.priceLbl.text = self.calculateTotalPrice()
                        
                        
                    }
                    
                    self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 1),IndexPath.init(row: 0, section: 9)], with: .automatic)
                }
    
                if self.originalWeightsilver != "" {
    
                    let finalWeight = calc2 * self.originalWeightsilver.toDouble()
                   
                    self.silverAsset[0].weight = finalWeight.toString()
                    self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 6),IndexPath.init(row: 0, section: 6)], with: .automatic)
                }
                
                if self.originalWeightplat != "" {
                    
                    let finalWeight = calc2 * self.originalWeightplat.toDouble()
                    self.platinumAsset[0].weight = finalWeight.toString()
                 self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 4),IndexPath.init(row: 0, section: 4)], with: .automatic)
                }
                
                
               // let percent = calc2 / 100
                
                
                
                
                let cell = self.productDetailTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! productSizeCell
               // let cell = self.productDetailTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! productSizeCell
                cell.btnSize.setTitle(selectedTxt, for: .normal)
              //  self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 1),IndexPath.init(row: 0, section: 9)], with: .automatic)
                self.calculateWeight()
                
                self.productSize = selectedTxt
            }
        }
        
      
    }
    
    @objc func selectSizeRing(_ sender:UIButton) {
        let actionSheet = UIAlertController(title: "Message", message: "Select Size", preferredStyle: .actionSheet)
        actionSheet.popoverPresentationController?.sourceView = sender
        actionSheet.popoverPresentationController?.sourceRect = sender.bounds
        for i in self.product!.price.ring {
            print(i.sizes)
            actionSheet.addAction(UIAlertAction.init(title: i.sizes, style: .default, handler: { (_) in
                let cell = self.productDetailTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! productSizeCell
                cell.btnSize.setTitle(i.sizes, for: .normal)
                self.productSize = i.sizes
                self.sizeForRing(selectedSize: i.sizes.toInt())
            }))
        }
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (_) in
            
        }))
        self.present(actionSheet, animated: true, completion: nil)
    }
    @objc func selectStone(_ sender:UIButton) {
        let actionSheet = UIAlertController(title: "Message", message: "Select Stone", preferredStyle: .actionSheet)
        actionSheet.popoverPresentationController?.sourceView = sender
        actionSheet.popoverPresentationController?.sourceRect = sender.bounds
        
        for i in self.arrStoneName {
            print(i)
            actionSheet.addAction(UIAlertAction.init(title: i, style: .default, handler: { (action) in
                let cell = self.productDetailTableView.cellForRow(at: IndexPath(row: sender.tag, section: 3)) as! productStoneCell
                
                print(self.stonedout)
                if self.stonedout.count > 0 {
                    for j in 0..<self.stonedout.count {
                        let name = self.stonedout[j]["jwellerySize"] as! String
                        if name == action.title {
                            cell.btnStoneType.setTitle(name, for: .normal)
                            self.stonedout.insert(self.stonedout[j], at: 0)
                            self.stonedout.remove(at: j+1)
                            
                        }else {
                            
                        }
                        print(self.stonedout)
                    }
                }

                self.arrFinalStone.removeAll()
                if self.stoneoutside.count > 0 {
                    for j in 0..<self.stoneoutside.count {
                        self.arrFinalStone.append(self.stoneoutside[j])
                    }
                }

                if self.stonedout.count > 0 {
                    let tempdic = ["stoneInside":self.stonedout] as [String:Any]
                    self.arrFinalStone.append(tempdic)
                }
                self.productDetailTableView.reloadRows(at: [IndexPath.init(row: sender.tag, section: 3),IndexPath.init(row: sender.tag, section: 3)], with: .automatic)
                
                self.calculateWeight()
                self.calculateTotalPrice()
                
            }))
        }
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (_) in
            
        }))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func sizeCalculation(selectedSize:Int,weight:Double) -> Double {
        
        let total = Double()
        
        if self.gender ==  "FeMale" {
            if(selectedSize >= 6 && selectedSize <= 10) {
                let doubleStr = String(format: "%.3f", weight*0.95)
                return Double(doubleStr)!
            }
            else if(selectedSize >= 15 && selectedSize <= 18) {
                let doubleStr = String(format: "%.3f", weight*1.07)
                return Double(doubleStr)!
            }
            else if(selectedSize >= 19 && selectedSize <= 22) {
                let doubleStr = String(format: "%.3f", weight*1.1)
                return Double(doubleStr)!
            }else {
                let doubleStr = String(format: "%.3f", weight)
                return Double(doubleStr)!
            }
        }
        else if self.gender ==  "Male" {
            if(selectedSize >= 14 && selectedSize <= 17) {
                let doubleStr = String(format: "%.3f", weight*0.95)
                return Double(doubleStr)!
            }
            else if(selectedSize >= 22 && selectedSize <= 25) {
                let doubleStr = String(format: "%.3f", weight*1.08)
                return Double(doubleStr)!
            }
            else if(selectedSize >= 26 && selectedSize <= 30) {
                let doubleStr = String(format: "%.3f", weight*1.12)
                return Double(doubleStr)!
            }
            else if(selectedSize >= 31 && selectedSize <= 34) {
                let doubleStr = String(format: "%.3f", weight*1.15)
                return Double(doubleStr)!
            }else {
                let doubleStr = String(format: "%.3f", weight)
                return Double(doubleStr)!
            }
        }
        return total
    }
    
    func sizeForRing(selectedSize:Int) {
        
        
        if self.prodType == "GOLD JEWELLERY" || self.prodType == "GOLD CHAINS"{
            
            let tempWeight = self.originalWeight.toDouble()
            print(selectedSize)
            self.productSize = "\(selectedSize)"
            self.ischange = true
            if self.gender == "FeMale" {
                if selectedSize >= self.ladiesSize[0].sizeset.minSize && selectedSize <= self.ladiesSize[0].sizeset.maxSize {
                    // -5 % logic
                    
                    
                    let percent = Double(5.0 / 100)
                    let weight = percent * tempWeight
                    let finalWeight = tempWeight - weight
                    
                    if self.originalWeight != "" {
                        
                        for i in 0..<goldweightchange.count {
                            
                            let percent = Double(5.0 / 100)
                            let weight = percent * goldweightchange[i]
                            let finalWeight = goldweightchange[i] * 0.95
                        
                            self.goldAsset[i].weight = finalWeight.toString()
                            
                            //self.priceLbl.text = self.calculateTotalPrice()
                            
                            
                        }
                        
                        //self.goldAsset[0].weight = finalWeight.toString()
                        
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 1),IndexPath.init(row: 0, section: 9)], with: .automatic)
                    }
                    
                    
                    

                    if self.originalWeightsilver != "" {
                        let weightsil =  percent * self.originalWeightsilver.toDouble()
                        let finalWeightsil = self.originalWeightsilver.toDouble() - weightsil
                        self.silverAsset[0].weight = finalWeightsil.toString()
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 1),IndexPath.init(row: 0, section: 6)], with: .automatic)
                    }
                    
                    if self.originalWeightplat != "" {
                        
                        let weightplat =  percent * self.originalWeightplat.toDouble()
                        let finalWeightplat = self.originalWeightplat.toDouble() - weightplat
                        self.platinumAsset[0].weight = finalWeightplat.toString()
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 4),IndexPath.init(row: 0, section: 4)], with: .automatic)
                    }
                
                    
                    
                    self.calculateWeight()
                } else if selectedSize >= self.ladiesSize[1].sizeset.minSize && selectedSize <= self.ladiesSize[1].sizeset.maxSize {
                    // No changes or switch to default wieght
                    
                    for i in 0..<goldweightchange.count {
                        
                        let percent = Double(5.0 / 100)
                        let weight = percent * goldweightchange[i]
                        let finalWeight = goldweightchange[i] * 1.00
                    
                        self.goldAsset[i].weight = finalWeight.toString()
                        
                        //self.priceLbl.text = self.calculateTotalPrice()
                        
                        
                    }
                    self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 1),IndexPath.init(row: 0, section: 9)], with: .automatic)
                    self.calculateWeight()
                } else if selectedSize >= self.ladiesSize[2].sizeset.minSize && selectedSize <= self.ladiesSize[2].sizeset.maxSize {
                    // +7 Logic
                    
                    let percent = Double(7.0 / 100)
                    let weight =  percent * tempWeight
                    let finalWeight = tempWeight + weight
                    
                    if self.originalWeight != "" {
                        for i in 0..<goldweightchange.count {
                            
                            let percent = Double(7.0 / 100)
                            let weight = percent * goldweightchange[i]
                            let finalWeight = goldweightchange[i] * 1.07
                        
                            self.goldAsset[i].weight = finalWeight.toString()
                            
                            //self.priceLbl.text = self.calculateTotalPrice()
                            
                            
                        }
                        
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 1),IndexPath.init(row: 0, section: 9)], with: .automatic)
                    }
                    
                    
                    
                    if self.originalWeightsilver != "" {
                        let weightsil =  percent * self.originalWeightsilver.toDouble()
                        let finalWeightsil = self.originalWeightsilver.toDouble() + weightsil
                        self.silverAsset[0].weight = finalWeightsil.toString()
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 1),IndexPath.init(row: 0, section: 6)], with: .automatic)
                    }
                    if self.originalWeightplat != "" {
                        
                        let weightplat =  percent * self.originalWeightplat.toDouble()
                        let finalWeightplat = self.originalWeightplat.toDouble() + weightplat
                        
                        self.platinumAsset[0].weight = finalWeightplat.toString()
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 4),IndexPath.init(row: 0, section: 4)], with: .automatic)
                    }
                    
                   // self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 1),IndexPath.init(row: 0, section: 9)], with: .automatic)
                    
                    self.calculateWeight()
                } else if selectedSize >= self.ladiesSize[3].sizeset.minSize && selectedSize <= self.ladiesSize[3].sizeset.maxSize {
                    // +10 logic
                    let percent = Double(10.0 / 100)
                    let weight = percent * tempWeight
                    let finalWeight = tempWeight + weight
                    
                    
                    if self.originalWeight != "" {
                        for i in 0..<goldweightchange.count {
                            
                            let percent = Double(10.0 / 100)
                            let weight = percent * goldweightchange[i]
                            let finalWeight = goldweightchange[i] * 1.1
                        
                            self.goldAsset[i].weight = finalWeight.toString()
                            
                            //self.priceLbl.text = self.calculateTotalPrice()
                            
                            
                        }
                        
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 1),IndexPath.init(row: 0, section: 9)], with: .automatic)
                    }
                    
                    
                    
                    
                    
                    if self.originalWeightsilver != "" {
                        let weightsil =  percent * self.originalWeightsilver.toDouble()
                        let finalWeightsil = self.originalWeightsilver.toDouble() + weightsil
                        self.silverAsset[0].weight = finalWeightsil.toString()
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 1),IndexPath.init(row: 0, section: 6)], with: .automatic)
                    }
                    if self.originalWeightplat != "" {
                        
                        let weightplat =  percent * self.originalWeightplat.toDouble()
                        let finalWeightplat = self.originalWeightplat.toDouble() + weightplat
                        
                        self.platinumAsset[0].weight = finalWeightplat.toString()
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 4),IndexPath.init(row: 0, section: 4)], with: .automatic)
                    }
                    
                    
                   // self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 9),IndexPath.init(row: 0, section: 9)], with: .automatic)
                    self.calculateWeight()
                }
            } else if self.gender == "Male" {
                if selectedSize >= self.gentsSize[0].sizeset.minSize || selectedSize <= self.gentsSize[0].sizeset.maxSize {
                    // -5 % logic
                    let percent = Double(5.0 / 100)
                    let weight = percent * tempWeight
                    let finalWeight = tempWeight - weight
                    
                    if self.originalWeight != "" {
                        for i in 0..<goldweightchange.count {
                            
                            let percent = Double(5.0 / 100)
                            let weight = percent * goldweightchange[i]
                            let finalWeight = goldweightchange[i] * 0.95
                        
                            self.goldAsset[i].weight = finalWeight.toString()
                            
                            //self.priceLbl.text = self.calculateTotalPrice()
                            
                            
                        }
                        
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 1),IndexPath.init(row: 0, section: 9)], with: .automatic)
                    }
                    
                    
                    
                    
                    if self.originalWeightsilver != "" {
                        let weightsil =  percent * self.originalWeightsilver.toDouble()
                        let finalWeightsil = self.originalWeightsilver.toDouble() - weightsil
                        self.silverAsset[0].weight = finalWeightsil.toString()
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 1),IndexPath.init(row: 0, section: 6)], with: .automatic)
                    }
                    
                    if self.originalWeightplat != "" {
                        
                        let weightplat =  percent * self.originalWeightplat.toDouble()
                        let finalWeightplat = self.originalWeightplat.toDouble() - weightplat
                        self.platinumAsset[0].weight = finalWeightplat.toString()
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 4),IndexPath.init(row: 0, section: 4)], with: .automatic)
                    }
                    
                    
                   // self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 1),IndexPath.init(row: 0, section: 9)], with: .automatic)
                    self.calculateWeight()
                } else if selectedSize >= self.gentsSize[1].sizeset.minSize || selectedSize <= self.gentsSize[1].sizeset.maxSize {
                    // No changes or switch to default wieght
                    for i in 0..<goldweightchange.count {
                        
                        let percent = Double(5.0 / 100)
                        let weight = percent * goldweightchange[i]
                        let finalWeight = goldweightchange[i] * 1.00
                    
                        self.goldAsset[i].weight = finalWeight.toString()
                        
                        //self.priceLbl.text = self.calculateTotalPrice()
                        
                        
                    }
                    self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 1),IndexPath.init(row: 0, section: 9)], with: .automatic)
                    self.calculateWeight()
                } else if selectedSize >= self.gentsSize[2].sizeset.minSize || selectedSize <= self.gentsSize[2].sizeset.maxSize {
                    // +8 Logic
                    let percent = Double(8.0 / 100)
                    let weight = percent * tempWeight
                    let finalWeight = tempWeight + weight
                    
                    if self.originalWeightsilver != "" {
                        let weightsil =  percent * self.originalWeightsilver.toDouble()
                        let finalWeightsil = self.originalWeightsilver.toDouble() + weightsil
                        self.silverAsset[0].weight = finalWeightsil.toString()
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 1),IndexPath.init(row: 0, section: 6)], with: .automatic)
                    }
                    if self.originalWeightplat != "" {
                        
                        let weightplat =  percent * self.originalWeightplat.toDouble()
                        let finalWeightplat = self.originalWeightplat.toDouble() + weightplat
                        
                        self.platinumAsset[0].weight = finalWeightplat.toString()
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 4),IndexPath.init(row: 0, section: 4)], with: .automatic)
                    }
                    
                    if self.originalWeight != "" {
                        for i in 0..<goldweightchange.count {
                            
                            let percent = Double(8.0 / 100)
                            let weight = percent * goldweightchange[i]
                            let finalWeight = goldweightchange[i] * 1.08
                        
                            self.goldAsset[i].weight = finalWeight.toString()
                            
                            //self.priceLbl.text = self.calculateTotalPrice()
                            
                            
                        }
                        
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 1),IndexPath.init(row: 0, section: 9)], with: .automatic)
                    }
                    
                    self.calculateWeight()
                } else if selectedSize >= self.gentsSize[3].sizeset.minSize || selectedSize <= self.gentsSize[3].sizeset.maxSize {
                    // +12 logic
                    let percent = Double(12.0 / 100)
                    let weight = percent * tempWeight
                    let finalWeight = tempWeight + weight
                    
                    if self.originalWeightsilver != "" {
                        let weightsil =  percent * self.originalWeightsilver.toDouble()
                        let finalWeightsil = self.originalWeightsilver.toDouble() + weightsil
                        self.silverAsset[0].weight = finalWeightsil.toString()
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 1),IndexPath.init(row: 0, section: 6)], with: .automatic)
                    }
                    if self.originalWeightplat != "" {
                        
                        let weightplat =  percent * self.originalWeightplat.toDouble()
                        let finalWeightplat = self.originalWeightplat.toDouble() + weightplat
                        
                        self.platinumAsset[0].weight = finalWeightplat.toString()
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 4),IndexPath.init(row: 0, section: 4)], with: .automatic)
                    }
                   
                    if self.originalWeight != "" {
                        for i in 0..<goldweightchange.count {
                            
                            let percent = Double(12.0 / 100)
                            let weight = percent * goldweightchange[i]
                            let finalWeight = goldweightchange[i] * 1.12
                        
                            self.goldAsset[i].weight = finalWeight.toString()
                            
                            //self.priceLbl.text = self.calculateTotalPrice()
                            
                            
                        }
                        
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 1),IndexPath.init(row: 0, section: 9)], with: .automatic)
                    }
                    
                    self.calculateWeight()
                } else if selectedSize >= self.gentsSize[4].sizeset.minSize || selectedSize <= self.gentsSize[4].sizeset.maxSize {
                    // +15 logic
                    let percent = Double(15.0 / 100)
                    let weight = percent * tempWeight
                    let finalWeight = tempWeight + weight
                    
                    if self.originalWeightsilver != "" {
                        let weightsil =  percent * self.originalWeightsilver.toDouble()
                        let finalWeightsil = self.originalWeightsilver.toDouble() + weightsil
                        self.silverAsset[0].weight = finalWeightsil.toString()
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 1),IndexPath.init(row: 0, section: 6)], with: .automatic)
                    }
                    if self.originalWeightplat != "" {
                        
                        let weightplat =  percent * self.originalWeightplat.toDouble()
                        let finalWeightplat = self.originalWeightplat.toDouble() + weightplat
                        
                        self.platinumAsset[0].weight = finalWeightplat.toString()
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 4),IndexPath.init(row: 0, section: 4)], with: .automatic)
                    }
                    
                    if self.originalWeight != "" {
                        for i in 0..<goldweightchange.count {
                            
                            let percent = Double(15.0 / 100)
                            let weight = percent * goldweightchange[i]
                            let finalWeight = goldweightchange[i] * 1.15
                        
                            self.goldAsset[i].weight = finalWeight.toString()
                            
                            //self.priceLbl.text = self.calculateTotalPrice()
                            
                            
                        }
                        
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 1),IndexPath.init(row: 0, section: 9)], with: .automatic)
                    }
                    
                    self.calculateWeight()
                }
            }
            
            if self.product?.data.jwelleryType == "Chain" {
                let defaultSize = self.product?.data.defaultSize.toDouble()
                let data = Double(selectedSize) - defaultSize!
                let wr = Double(tempWeight) / defaultSize!
                let final = wr * data
                let finalweight = Double(tempWeight)+final
                
                
                
                if self.originalWeight != "" {
                    
                    
                    
                    for i in 0..<goldweightchange.count {
                        
                        let defaultSize = self.product?.data.defaultSize.toDouble()
                        let data = Double(selectedSize) - defaultSize!
                        let wr = Double(goldweightchange[i]) / defaultSize!
                        let final = wr * data
                        let finalweight = Double(goldweightchange[i])+final
                        
                       
                    
                        self.goldAsset[i].weight = finalweight.toString()
                        
                        //self.priceLbl.text = self.calculateTotalPrice()
                        
                        
                    }
                    
                    
                    self.goldAsset[0].weight = finalweight.toString()
                    
                    self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 1),IndexPath.init(row: 0, section: 9)], with: .automatic)
                }
                
                
                
                if self.originalWeightsilver != "" {
                    let defaultSize = self.product?.data.defaultSize.toDouble()
                    let data = Double(selectedSize) - defaultSize!
                    let wr = Double(self.originalWeightsilver)! / defaultSize!
                    let final = wr * data
                    let finalweight = Double(self.originalWeightsilver)!+final
                    self.silverAsset[0].weight = finalweight.toString()
                    self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 1),IndexPath.init(row: 0, section: 6)], with: .automatic)
                }
                if self.originalWeightplat != "" {
                    
                    let defaultSize = self.product?.data.defaultSize.toDouble()
                    let data = Double(selectedSize) - defaultSize!
                    let wr = Double(self.originalWeightplat)! / defaultSize!
                    let final = wr * data
                    let finalweight = Double(self.originalWeightplat)!+final
                    
                    self.platinumAsset[0].weight = finalweight.toString()
                    self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 4),IndexPath.init(row: 0, section: 4)], with: .automatic)
                }
               // self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 1),IndexPath.init(row: 0, section: 9)], with: .automatic)
                
                self.calculateWeight()
                
                
                
            }
            self.calculateTotalPrice()
            
            
        }
        else if self.prodType == "DIAMOND JEWELLERY" {
            
            let tempWeight = self.originalWeight.toDouble()
            print(selectedSize)
            self.productSize = "\(selectedSize)"
            self.ischange = true
            if self.gender == "FeMale" {
                if selectedSize >= self.ladiesSize[0].sizeset.minSize && selectedSize <= self.ladiesSize[0].sizeset.maxSize {
                    // -5 % logic
                    
                    
                    let percent = Double(5.0 / 100)
                    let weight = percent * tempWeight
                    let finalWeight = tempWeight - weight
                    
                    if self.originalWeight != "" {
                        for i in 0..<goldweightchange.count {
                            
                            let percent = Double(5.0 / 100)
                            let weight = percent * goldweightchange[i]
                            let finalWeight = goldweightchange[i] * 0.95
                        
                            self.goldAsset[i].weight = finalWeight.toString()
                            
                            //self.priceLbl.text = self.calculateTotalPrice()
                            
                            
                        }
                        
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 2),IndexPath.init(row: 0, section: 9)], with: .automatic)
                    }
                    
                    
                    

                    if self.originalWeightsilver != "" {
                        let weightsil =  percent * self.originalWeightsilver.toDouble()
                        let finalWeightsil = self.originalWeightsilver.toDouble() - weightsil
                        self.silverAsset[0].weight = finalWeightsil.toString()
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 6),IndexPath.init(row: 0, section: 6)], with: .automatic)
                    }
                    
                    if self.originalWeightplat != "" {
                        
                        let weightplat =  percent * self.originalWeightplat.toDouble()
                        let finalWeightplat = self.originalWeightplat.toDouble() - weightplat
                        self.platinumAsset[0].weight = finalWeightplat.toString()
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 4),IndexPath.init(row: 0, section: 4)], with: .automatic)
                    }
                
                    
                    
                    self.calculateWeight()
                } else if selectedSize >= self.ladiesSize[1].sizeset.minSize && selectedSize <= self.ladiesSize[1].sizeset.maxSize {
                    // No changes or switch to default wieght
                    
                    for i in 0..<goldweightchange.count {
                        
                        let percent = Double(5.0 / 100)
                        let weight = percent * goldweightchange[i]
                        let finalWeight = goldweightchange[i] * 1.00
                    
                        self.goldAsset[i].weight = finalWeight.toString()
                        
                        //self.priceLbl.text = self.calculateTotalPrice()
                        
                        
                    }
                    self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 2),IndexPath.init(row: 0, section: 9)], with: .automatic)
                    self.calculateWeight()
                } else if selectedSize >= self.ladiesSize[2].sizeset.minSize && selectedSize <= self.ladiesSize[2].sizeset.maxSize {
                    // +7 Logic
                    
                    let percent = Double(7.0 / 100)
                    let weight =  percent * tempWeight
                    let finalWeight = tempWeight + weight
                    
                    if self.originalWeight != "" {
                        for i in 0..<goldweightchange.count {
                            
                            let percent = Double(7.0 / 100)
                            let weight = percent * goldweightchange[i]
                            let finalWeight = goldweightchange[i] * 1.07
                        
                            self.goldAsset[i].weight = finalWeight.toString()
                            
                            //self.priceLbl.text = self.calculateTotalPrice()
                            
                            
                        }
                        
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 2),IndexPath.init(row: 0, section: 9)], with: .automatic)
                    }
                    
                    
                    
                    if self.originalWeightsilver != "" {
                        let weightsil =  percent * self.originalWeightsilver.toDouble()
                        let finalWeightsil = self.originalWeightsilver.toDouble() + weightsil
                        self.silverAsset[0].weight = finalWeightsil.toString()
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 6),IndexPath.init(row: 0, section: 6)], with: .automatic)
                    }
                    if self.originalWeightplat != "" {
                        
                        let weightplat =  percent * self.originalWeightplat.toDouble()
                        let finalWeightplat = self.originalWeightplat.toDouble() + weightplat
                        
                        self.platinumAsset[0].weight = finalWeightplat.toString()
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 4),IndexPath.init(row: 0, section: 4)], with: .automatic)
                    }
                    
                   // self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 1),IndexPath.init(row: 0, section: 9)], with: .automatic)
                    
                    self.calculateWeight()
                } else if selectedSize >= self.ladiesSize[3].sizeset.minSize && selectedSize <= self.ladiesSize[3].sizeset.maxSize {
                    // +10 logic
                    let percent = Double(10.0 / 100)
                    let weight = percent * tempWeight
                    let finalWeight = tempWeight + weight
                    
                    
                    if self.originalWeight != "" {
                        for i in 0..<goldweightchange.count {
                            
                            let percent = Double(10.0 / 100)
                            let weight = percent * goldweightchange[i]
                            let finalWeight = goldweightchange[i] * 1.1
                        
                            self.goldAsset[i].weight = finalWeight.toString()
                            
                            //self.priceLbl.text = self.calculateTotalPrice()
                            
                            
                        }
                        
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 2),IndexPath.init(row: 0, section: 9)], with: .automatic)
                    }
                    
                    
                    
                    
                    
                    if self.originalWeightsilver != "" {
                        let weightsil =  percent * self.originalWeightsilver.toDouble()
                        let finalWeightsil = self.originalWeightsilver.toDouble() + weightsil
                        self.silverAsset[0].weight = finalWeightsil.toString()
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 6),IndexPath.init(row: 0, section: 6)], with: .automatic)
                    }
                    if self.originalWeightplat != "" {
                        
                        let weightplat =  percent * self.originalWeightplat.toDouble()
                        let finalWeightplat = self.originalWeightplat.toDouble() + weightplat
                        
                        self.platinumAsset[0].weight = finalWeightplat.toString()
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 4),IndexPath.init(row: 0, section: 4)], with: .automatic)
                    }
                    
                    
                   // self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 9),IndexPath.init(row: 0, section: 9)], with: .automatic)
                    self.calculateWeight()
                }
            } else if self.gender == "Male" {
                if selectedSize >= self.gentsSize[0].sizeset.minSize || selectedSize <= self.gentsSize[0].sizeset.maxSize {
                    // -5 % logic
                    let percent = Double(5.0 / 100)
                    let weight = percent * tempWeight
                    let finalWeight = tempWeight - weight
                    
                    if self.originalWeight != "" {
                        for i in 0..<goldweightchange.count {
                            
                            let percent = Double(5.0 / 100)
                            let weight = percent * goldweightchange[i]
                            let finalWeight = goldweightchange[i] * 0.95
                        
                            self.goldAsset[i].weight = finalWeight.toString()
                            
                            //self.priceLbl.text = self.calculateTotalPrice()
                            
                            
                        }
                        
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 2),IndexPath.init(row: 0, section: 9)], with: .automatic)
                    }
                    
                    
                    
                    
                    if self.originalWeightsilver != "" {
                        let weightsil =  percent * self.originalWeightsilver.toDouble()
                        let finalWeightsil = self.originalWeightsilver.toDouble() - weightsil
                        self.silverAsset[0].weight = finalWeightsil.toString()
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 6),IndexPath.init(row: 0, section: 6)], with: .automatic)
                    }
                    
                    if self.originalWeightplat != "" {
                        
                        let weightplat =  percent * self.originalWeightplat.toDouble()
                        let finalWeightplat = self.originalWeightplat.toDouble() - weightplat
                        self.platinumAsset[0].weight = finalWeightplat.toString()
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 4),IndexPath.init(row: 0, section: 4)], with: .automatic)
                    }
                    
                    
                   // self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 1),IndexPath.init(row: 0, section: 9)], with: .automatic)
                    self.calculateWeight()
                } else if selectedSize >= self.gentsSize[1].sizeset.minSize || selectedSize <= self.gentsSize[1].sizeset.maxSize {
                    // No changes or switch to default wieght
                    for i in 0..<goldweightchange.count {
                        
                        let percent = Double(5.0 / 100)
                        let weight = percent * goldweightchange[i]
                        let finalWeight = goldweightchange[i] * 1.00
                    
                        self.goldAsset[i].weight = finalWeight.toString()
                        
                        //self.priceLbl.text = self.calculateTotalPrice()
                        
                        
                    }
                    self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 2),IndexPath.init(row: 0, section: 9)], with: .automatic)
                    self.calculateWeight()
                } else if selectedSize >= self.gentsSize[2].sizeset.minSize || selectedSize <= self.gentsSize[2].sizeset.maxSize {
                    // +8 Logic
                    let percent = Double(8.0 / 100)
                    let weight = percent * tempWeight
                    let finalWeight = tempWeight + weight
                    
                    if self.originalWeightsilver != "" {
                        let weightsil =  percent * self.originalWeightsilver.toDouble()
                        let finalWeightsil = self.originalWeightsilver.toDouble() + weightsil
                        self.silverAsset[0].weight = finalWeightsil.toString()
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 6),IndexPath.init(row: 0, section: 6)], with: .automatic)
                    }
                    if self.originalWeightplat != "" {
                        
                        let weightplat =  percent * self.originalWeightplat.toDouble()
                        let finalWeightplat = self.originalWeightplat.toDouble() + weightplat
                        
                        self.platinumAsset[0].weight = finalWeightplat.toString()
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 4),IndexPath.init(row: 0, section: 4)], with: .automatic)
                    }
                    
                    if self.originalWeight != "" {
                        for i in 0..<goldweightchange.count {
                            
                            let percent = Double(8.0 / 100)
                            let weight = percent * goldweightchange[i]
                            let finalWeight = goldweightchange[i] * 1.08
                        
                            self.goldAsset[i].weight = finalWeight.toString()
                            
                            //self.priceLbl.text = self.calculateTotalPrice()
                            
                            
                        }
                        
                        
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 2),IndexPath.init(row: 0, section: 9)], with: .automatic)
                    }
                    
                    self.calculateWeight()
                } else if selectedSize >= self.gentsSize[3].sizeset.minSize || selectedSize <= self.gentsSize[3].sizeset.maxSize {
                    // +12 logic
                    let percent = Double(12.0 / 100)
                    let weight = percent * tempWeight
                    let finalWeight = tempWeight + weight
                    
                    if self.originalWeightsilver != "" {
                        let weightsil =  percent * self.originalWeightsilver.toDouble()
                        let finalWeightsil = self.originalWeightsilver.toDouble() + weightsil
                        self.silverAsset[0].weight = finalWeightsil.toString()
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 6),IndexPath.init(row: 0, section: 6)], with: .automatic)
                    }
                    if self.originalWeightplat != "" {
                        
                        let weightplat =  percent * self.originalWeightplat.toDouble()
                        let finalWeightplat = self.originalWeightplat.toDouble() + weightplat
                        
                        self.platinumAsset[0].weight = finalWeightplat.toString()
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 4),IndexPath.init(row: 0, section: 4)], with: .automatic)
                    }
                   
                    if self.originalWeight != "" {
                        for i in 0..<goldweightchange.count {
                            
                            let percent = Double(12.0 / 100)
                            let weight = percent * goldweightchange[i]
                            let finalWeight = goldweightchange[i] * 1.12
                        
                            self.goldAsset[i].weight = finalWeight.toString()
                            
                            //self.priceLbl.text = self.calculateTotalPrice()
                            
                            
                        }
                        
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 2),IndexPath.init(row: 0, section: 9)], with: .automatic)
                    }
                    
                    self.calculateWeight()
                } else if selectedSize >= self.gentsSize[4].sizeset.minSize || selectedSize <= self.gentsSize[4].sizeset.maxSize {
                    // +15 logic
                    let percent = Double(15.0 / 100)
                    let weight = percent * tempWeight
                    let finalWeight = tempWeight + weight
                    
                    if self.originalWeightsilver != "" {
                        let weightsil =  percent * self.originalWeightsilver.toDouble()
                        let finalWeightsil = self.originalWeightsilver.toDouble() + weightsil
                        self.silverAsset[0].weight = finalWeightsil.toString()
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 6),IndexPath.init(row: 0, section: 6)], with: .automatic)
                    }
                    if self.originalWeightplat != "" {
                        
                        let weightplat =  percent * self.originalWeightplat.toDouble()
                        let finalWeightplat = self.originalWeightplat.toDouble() + weightplat
                        
                        self.platinumAsset[0].weight = finalWeightplat.toString()
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 4),IndexPath.init(row: 0, section: 4)], with: .automatic)
                    }
                    
                    if self.originalWeight != "" {
                        for i in 0..<goldweightchange.count {
                            
                            let percent = Double(15.0 / 100)
                            let weight = percent * goldweightchange[i]
                            let finalWeight = goldweightchange[i] * 1.15
                        
                            self.goldAsset[i].weight = finalWeight.toString()
                            
                            //self.priceLbl.text = self.calculateTotalPrice()
                            
                            
                        }
                        
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 2),IndexPath.init(row: 0, section: 9)], with: .automatic)
                    }
                    
                    self.calculateWeight()
                }
            }
            
            if self.product?.data.jwelleryType == "Chain" {
                let defaultSize = self.product?.data.defaultSize.toDouble()
                let data = Double(selectedSize) - defaultSize!
                let wr = Double(tempWeight) / defaultSize!
                let final = wr * data
                let finalweight = Double(tempWeight)+final
                
                
                
                if self.originalWeight != "" {
                    self.goldAsset[0].weight = finalweight.toString()
                    
                    self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 2),IndexPath.init(row: 0, section: 9)], with: .automatic)
                }
                
                
                
                if self.originalWeightsilver != "" {
                    let defaultSize = self.product?.data.defaultSize.toDouble()
                    let data = Double(selectedSize) - defaultSize!
                    let wr = Double(self.originalWeightsilver)! / defaultSize!
                    let final = wr * data
                    let finalweight = Double(self.originalWeightsilver)!+final
                    self.silverAsset[0].weight = finalweight.toString()
                    self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 6),IndexPath.init(row: 0, section: 6)], with: .automatic)
                }
                if self.originalWeightplat != "" {
                    
                    let defaultSize = self.product?.data.defaultSize.toDouble()
                    let data = Double(selectedSize) - defaultSize!
                    let wr = Double(self.originalWeightplat)! / defaultSize!
                    let final = wr * data
                    let finalweight = Double(self.originalWeightplat)!+final
                    
                    self.platinumAsset[0].weight = finalweight.toString()
                    self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 4),IndexPath.init(row: 0, section: 4)], with: .automatic)
                }
               // self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 1),IndexPath.init(row: 0, section: 9)], with: .automatic)
                
                self.calculateWeight()
                
                
                
            }
            self.calculateTotalPrice()
            
        }
        else if self.prodType == "PLATINUM JEWELLERY"
        {
                    
                    let tempWeight = self.originalWeight.toDouble()
                    print(selectedSize)
                    self.productSize = "\(selectedSize)"
                    self.ischange = true
                    if self.gender == "FeMale" {
                        if selectedSize >= self.ladiesSize[0].sizeset.minSize && selectedSize <= self.ladiesSize[0].sizeset.maxSize {
                            // -5 % logic
                            
                            
                            let percent = Double(5.0 / 100)
                            let weight = percent * tempWeight
                            let finalWeight = tempWeight - weight
                            
                            if self.originalWeight != "" {
                                for i in 0..<goldweightchange.count {
                                    
                                    let percent = Double(5.0 / 100)
                                    let weight = percent * goldweightchange[i]
                                    let finalWeight = goldweightchange[i] * 0.95
                                
                                    self.goldAsset[i].weight = finalWeight.toString()
                                    
                                    //self.priceLbl.text = self.calculateTotalPrice()
                                    
                                    
                                }
                                
                                self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 4),IndexPath.init(row: 0, section: 9)], with: .automatic)
                            }
                            
                            
                            

                            if self.originalWeightsilver != "" {
                                let weightsil =  percent * self.originalWeightsilver.toDouble()
                                let finalWeightsil = self.originalWeightsilver.toDouble() - weightsil
                                self.silverAsset[0].weight = finalWeightsil.toString()
                                self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 6),IndexPath.init(row: 0, section: 9)], with: .automatic)
                            }
                            
                            if self.originalWeightplat != "" {
                                
                                let weightplat =  percent * self.originalWeightplat.toDouble()
                                let finalWeightplat = self.originalWeightplat.toDouble() - weightplat
                                self.platinumAsset[0].weight = finalWeightplat.toString()
                                self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 1),IndexPath.init(row: 0, section: 4)], with: .automatic)
                            }
                        
                            
                            
                            self.calculateWeight()
                        } else if selectedSize >= self.ladiesSize[1].sizeset.minSize && selectedSize <= self.ladiesSize[1].sizeset.maxSize {
                            // No changes or switch to default wieght
                            
                            for i in 0..<goldweightchange.count {
                                
                                let percent = Double(5.0 / 100)
                                let weight = percent * goldweightchange[i]
                                let finalWeight = goldweightchange[i] * 1.00
                            
                                self.goldAsset[i].weight = finalWeight.toString()
                                
                                //self.priceLbl.text = self.calculateTotalPrice()
                                
                                
                            }
                            self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 4),IndexPath.init(row: 0, section: 9)], with: .automatic)
                            self.calculateWeight()
                        } else if selectedSize >= self.ladiesSize[2].sizeset.minSize && selectedSize <= self.ladiesSize[2].sizeset.maxSize {
                            // +7 Logic
                            
                            let percent = Double(7.0 / 100)
                            let weight =  percent * tempWeight
                            let finalWeight = tempWeight + weight
                            
                            if self.originalWeight != "" {
                                for i in 0..<goldweightchange.count {
                                    
                                    let percent = Double(7.0 / 100)
                                    let weight = percent * goldweightchange[i]
                                    let finalWeight = goldweightchange[i] * 1.07
                                
                                    self.goldAsset[i].weight = finalWeight.toString()
                                    
                                    //self.priceLbl.text = self.calculateTotalPrice()
                                    
                                    
                                }
                                
                                self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 4),IndexPath.init(row: 0, section: 9)], with: .automatic)
                            }
                            
                            
                            
                            if self.originalWeightsilver != "" {
                                let weightsil =  percent * self.originalWeightsilver.toDouble()
                                let finalWeightsil = self.originalWeightsilver.toDouble() + weightsil
                                self.silverAsset[0].weight = finalWeightsil.toString()
                                self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 6),IndexPath.init(row: 0, section: 6)], with: .automatic)
                            }
                            if self.originalWeightplat != "" {
                                
                                let weightplat =  percent * self.originalWeightplat.toDouble()
                                let finalWeightplat = self.originalWeightplat.toDouble() + weightplat
                                
                                self.platinumAsset[0].weight = finalWeightplat.toString()
                                self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 4),IndexPath.init(row: 0, section: 9)], with: .automatic)
                            }
                            
                           // self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 1),IndexPath.init(row: 0, section: 9)], with: .automatic)
                            
                            self.calculateWeight()
                        } else if selectedSize >= self.ladiesSize[3].sizeset.minSize && selectedSize <= self.ladiesSize[3].sizeset.maxSize {
                            // +10 logic
                            let percent = Double(10.0 / 100)
                            let weight = percent * tempWeight
                            let finalWeight = tempWeight + weight
                            
                            
                            if self.originalWeight != "" {
                                for i in 0..<goldweightchange.count {
                                    
                                    let percent = Double(10.0 / 100)
                                    let weight = percent * goldweightchange[i]
                                    let finalWeight = goldweightchange[i] * 1.1
                                
                                    self.goldAsset[i].weight = finalWeight.toString()
                                    
                                    //self.priceLbl.text = self.calculateTotalPrice()
                                    
                                    
                                }
                                
                                self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 4),IndexPath.init(row: 0, section: 9)], with: .automatic)
                            }
                            
                            
                            
                            
                            
                            if self.originalWeightsilver != "" {
                                let weightsil =  percent * self.originalWeightsilver.toDouble()
                                let finalWeightsil = self.originalWeightsilver.toDouble() + weightsil
                                self.silverAsset[0].weight = finalWeightsil.toString()
                                self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 6),IndexPath.init(row: 0, section: 6)], with: .automatic)
                            }
                            if self.originalWeightplat != "" {
                                
                                let weightplat =  percent * self.originalWeightplat.toDouble()
                                let finalWeightplat = self.originalWeightplat.toDouble() + weightplat
                                
                                self.platinumAsset[0].weight = finalWeightplat.toString()
                                self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 4),IndexPath.init(row: 0, section: 4)], with: .automatic)
                            }
                            
                            
                           // self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 9),IndexPath.init(row: 0, section: 9)], with: .automatic)
                            self.calculateWeight()
                        }
                    } else if self.gender == "Male" {
                        if selectedSize >= self.gentsSize[0].sizeset.minSize || selectedSize <= self.gentsSize[0].sizeset.maxSize {
                            // -5 % logic
                            let percent = Double(5.0 / 100)
                            let weight = percent * tempWeight
                            let finalWeight = tempWeight - weight
                            
                            if self.originalWeight != "" {
                                for i in 0..<goldweightchange.count {
                                    
                                    let percent = Double(5.0 / 100)
                                    let weight = percent * goldweightchange[i]
                                    let finalWeight = goldweightchange[i] * 0.95
                                
                                    self.goldAsset[i].weight = finalWeight.toString()
                                    
                                    //self.priceLbl.text = self.calculateTotalPrice()
                                    
                                    
                                }
                                
                                self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 4),IndexPath.init(row: 0, section: 9)], with: .automatic)
                            }
                            
                            
                            
                            
                            if self.originalWeightsilver != "" {
                                let weightsil =  percent * self.originalWeightsilver.toDouble()
                                let finalWeightsil = self.originalWeightsilver.toDouble() - weightsil
                                self.silverAsset[0].weight = finalWeightsil.toString()
                                self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 6),IndexPath.init(row: 0, section: 6)], with: .automatic)
                            }
                            
                            if self.originalWeightplat != "" {
                                
                                let weightplat =  percent * self.originalWeightplat.toDouble()
                                let finalWeightplat = self.originalWeightplat.toDouble() - weightplat
                                self.platinumAsset[0].weight = finalWeightplat.toString()
                                self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 4),IndexPath.init(row: 0, section: 4)], with: .automatic)
                            }
                            
                            
                           // self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 1),IndexPath.init(row: 0, section: 9)], with: .automatic)
                            self.calculateWeight()
                        } else if selectedSize >= self.gentsSize[1].sizeset.minSize || selectedSize <= self.gentsSize[1].sizeset.maxSize {
                            // No changes or switch to default wieght
                            for i in 0..<goldweightchange.count {
                                
                                let percent = Double(5.0 / 100)
                                let weight = percent * goldweightchange[i]
                                let finalWeight = goldweightchange[i] * 1.00
                            
                                self.goldAsset[i].weight = finalWeight.toString()
                                
                                //self.priceLbl.text = self.calculateTotalPrice()
                                
                                
                            }
                            self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 4),IndexPath.init(row: 0, section: 9)], with: .automatic)
                            self.calculateWeight()
                        } else if selectedSize >= self.gentsSize[2].sizeset.minSize || selectedSize <= self.gentsSize[2].sizeset.maxSize {
                            // +8 Logic
                            let percent = Double(8.0 / 100)
                            let weight = percent * tempWeight
                            let finalWeight = tempWeight + weight
                            
                            if self.originalWeightsilver != "" {
                                let weightsil =  percent * self.originalWeightsilver.toDouble()
                                let finalWeightsil = self.originalWeightsilver.toDouble() + weightsil
                                self.silverAsset[0].weight = finalWeightsil.toString()
                                self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 6),IndexPath.init(row: 0, section: 6)], with: .automatic)
                            }
                            if self.originalWeightplat != "" {
                                
                                let weightplat =  percent * self.originalWeightplat.toDouble()
                                let finalWeightplat = self.originalWeightplat.toDouble() + weightplat
                                
                                self.platinumAsset[0].weight = finalWeightplat.toString()
                                self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 4),IndexPath.init(row: 0, section: 4)], with: .automatic)
                            }
                            
                            if self.originalWeight != "" {
                                for i in 0..<goldweightchange.count {
                                    
                                    let percent = Double(8.0 / 100)
                                    let weight = percent * goldweightchange[i]
                                    let finalWeight = goldweightchange[i] * 1.08
                                
                                    self.goldAsset[i].weight = finalWeight.toString()
                                    
                                    //self.priceLbl.text = self.calculateTotalPrice()
                                    
                                    
                                }
                                
                                self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 4),IndexPath.init(row: 0, section: 9)], with: .automatic)
                            }
                            
                            self.calculateWeight()
                        } else if selectedSize >= self.gentsSize[3].sizeset.minSize || selectedSize <= self.gentsSize[3].sizeset.maxSize {
                            // +12 logic
                            let percent = Double(12.0 / 100)
                            let weight = percent * tempWeight
                            let finalWeight = tempWeight + weight
                            
                            if self.originalWeightsilver != "" {
                                let weightsil =  percent * self.originalWeightsilver.toDouble()
                                let finalWeightsil = self.originalWeightsilver.toDouble() + weightsil
                                self.silverAsset[0].weight = finalWeightsil.toString()
                                self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 6),IndexPath.init(row: 0, section: 6)], with: .automatic)
                            }
                            if self.originalWeightplat != "" {
                                
                                let weightplat =  percent * self.originalWeightplat.toDouble()
                                let finalWeightplat = self.originalWeightplat.toDouble() + weightplat
                                
                                self.platinumAsset[0].weight = finalWeightplat.toString()
                                self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 4),IndexPath.init(row: 0, section: 4)], with: .automatic)
                            }
                           
                            if self.originalWeight != "" {
                                for i in 0..<goldweightchange.count {
                                    
                                    let percent = Double(12.0 / 100)
                                    let weight = percent * goldweightchange[i]
                                    let finalWeight = goldweightchange[i] * 1.12
                                
                                    self.goldAsset[i].weight = finalWeight.toString()
                                    
                                    //self.priceLbl.text = self.calculateTotalPrice()
                                    
                                    
                                }
                                
                                self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 4),IndexPath.init(row: 0, section: 9)], with: .automatic)
                            }
                            
                            self.calculateWeight()
                        } else if selectedSize >= self.gentsSize[4].sizeset.minSize || selectedSize <= self.gentsSize[4].sizeset.maxSize {
                            // +15 logic
                            let percent = Double(15.0 / 100)
                            let weight = percent * tempWeight
                            let finalWeight = tempWeight + weight
                            
                            if self.originalWeightsilver != "" {
                                let weightsil =  percent * self.originalWeightsilver.toDouble()
                                let finalWeightsil = self.originalWeightsilver.toDouble() + weightsil
                                self.silverAsset[0].weight = finalWeightsil.toString()
                                self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 6),IndexPath.init(row: 0, section: 6)], with: .automatic)
                            }
                            if self.originalWeightplat != "" {
                                
                                let weightplat =  percent * self.originalWeightplat.toDouble()
                                let finalWeightplat = self.originalWeightplat.toDouble() + weightplat
                                
                                self.platinumAsset[0].weight = finalWeightplat.toString()
                                self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 4),IndexPath.init(row: 0, section: 4)], with: .automatic)
                            }
                            
                            if self.originalWeight != "" {
                                for i in 0..<goldweightchange.count {
                                    
                                    let percent = Double(15.0 / 100)
                                    let weight = percent * goldweightchange[i]
                                    let finalWeight = goldweightchange[i] * 1.15
                                
                                    self.goldAsset[i].weight = finalWeight.toString()
                                    
                                    //self.priceLbl.text = self.calculateTotalPrice()
                                    
                                    
                                }
                                
                                self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 4),IndexPath.init(row: 0, section: 9)], with: .automatic)
                            }
                            
                            self.calculateWeight()
                        }
                    }
                    
                    if self.product?.data.jwelleryType == "Chain" {
                        let defaultSize = self.product?.data.defaultSize.toDouble()
                        let data = Double(selectedSize) - defaultSize!
                        let wr = Double(tempWeight) / defaultSize!
                        let final = wr * data
                        let finalweight = Double(tempWeight)+final
                        
                        
                        
                        if self.originalWeight != "" {
                            self.goldAsset[0].weight = finalweight.toString()
                            
                            self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 4),IndexPath.init(row: 0, section: 9)], with: .automatic)
                        }
                        
                        
                        
                        if self.originalWeightsilver != "" {
                            let defaultSize = self.product?.data.defaultSize.toDouble()
                            let data = Double(selectedSize) - defaultSize!
                            let wr = Double(self.originalWeightsilver)! / defaultSize!
                            let final = wr * data
                            let finalweight = Double(self.originalWeightsilver)!+final
                            self.silverAsset[0].weight = finalweight.toString()
                            self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 6),IndexPath.init(row: 0, section: 6)], with: .automatic)
                        }
                        if self.originalWeightplat != "" {
                            
                            let defaultSize = self.product?.data.defaultSize.toDouble()
                            let data = Double(selectedSize) - defaultSize!
                            let wr = Double(self.originalWeightplat)! / defaultSize!
                            let final = wr * data
                            let finalweight = Double(self.originalWeightplat)!+final
                            
                            self.platinumAsset[0].weight = finalweight.toString()
                            self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 4),IndexPath.init(row: 0, section: 4)], with: .automatic)
                        }
                       // self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 1),IndexPath.init(row: 0, section: 9)], with: .automatic)
                        
                        self.calculateWeight()
                        
                        
                        
                    }
                    self.calculateTotalPrice()
                    
                }
        else if self.prodType == "SILVER JEWELLERY" {
            
            let tempWeight = self.originalWeight.toDouble()
            print(selectedSize)
            self.productSize = "\(selectedSize)"
            self.ischange = true
            if self.gender == "FeMale" {
                if selectedSize >= self.ladiesSize[0].sizeset.minSize && selectedSize <= self.ladiesSize[0].sizeset.maxSize {
                    // -5 % logic
                    
                    
                    let percent = Double(5.0 / 100)
                    let weight = percent * tempWeight
                    let finalWeight = tempWeight - weight
                    
                    if self.originalWeight != "" {
                        for i in 0..<goldweightchange.count {
                            
                            let percent = Double(5.0 / 100)
                            let weight = percent * goldweightchange[i]
                            let finalWeight = goldweightchange[i] * 0.95
                        
                            self.goldAsset[i].weight = finalWeight.toString()
                            
                            //self.priceLbl.text = self.calculateTotalPrice()
                            
                            
                        }
                        
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 5),IndexPath.init(row: 0, section: 9)], with: .automatic)
                    }
                    
                    
                    

                    if self.originalWeightsilver != "" {
                        let weightsil =  percent * self.originalWeightsilver.toDouble()
                        let finalWeightsil = self.originalWeightsilver.toDouble() - weightsil
                        self.silverAsset[0].weight = finalWeightsil.toString()
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 6),IndexPath.init(row: 0, section: 6)], with: .automatic)
                    }
                    
                    if self.originalWeightplat != "" {
                        
                        let weightplat =  percent * self.originalWeightplat.toDouble()
                        let finalWeightplat = self.originalWeightplat.toDouble() - weightplat
                        self.platinumAsset[0].weight = finalWeightplat.toString()
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 5),IndexPath.init(row: 0, section: 5)], with: .automatic)
                    }
                
                    
                    
                    self.calculateWeight()
                } else if selectedSize >= self.ladiesSize[1].sizeset.minSize && selectedSize <= self.ladiesSize[1].sizeset.maxSize {
                    // No changes or switch to default wieght
                    
                    for i in 0..<goldweightchange.count {
                        
                        let percent = Double(5.0 / 100)
                        let weight = percent * goldweightchange[i]
                        let finalWeight = goldweightchange[i] * 1.00
                    
                        self.goldAsset[i].weight = finalWeight.toString()
                        
                        //self.priceLbl.text = self.calculateTotalPrice()
                        
                        
                    }
                    self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 5),IndexPath.init(row: 0, section: 9)], with: .automatic)
                    self.calculateWeight()
                } else if selectedSize >= self.ladiesSize[2].sizeset.minSize && selectedSize <= self.ladiesSize[2].sizeset.maxSize {
                    // +7 Logic
                    
                    let percent = Double(7.0 / 100)
                    let weight =  percent * tempWeight
                    let finalWeight = tempWeight + weight
                    
                    if self.originalWeight != "" {
                        for i in 0..<goldweightchange.count {
                            
                            let percent = Double(7.0 / 100)
                            let weight = percent * goldweightchange[i]
                            let finalWeight = goldweightchange[i] * 1.07
                        
                            self.goldAsset[i].weight = finalWeight.toString()
                            
                            //self.priceLbl.text = self.calculateTotalPrice()
                            
                            
                        }
                        
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 5),IndexPath.init(row: 0, section: 9)], with: .automatic)
                    }
                    
                    
                    
                    if self.originalWeightsilver != "" {
                        let weightsil =  percent * self.originalWeightsilver.toDouble()
                        let finalWeightsil = self.originalWeightsilver.toDouble() + weightsil
                        self.silverAsset[0].weight = finalWeightsil.toString()
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 6),IndexPath.init(row: 0, section: 6)], with: .automatic)
                    }
                    if self.originalWeightplat != "" {
                        
                        let weightplat =  percent * self.originalWeightplat.toDouble()
                        let finalWeightplat = self.originalWeightplat.toDouble() + weightplat
                        
                        self.platinumAsset[0].weight = finalWeightplat.toString()
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 5),IndexPath.init(row: 0, section: 5)], with: .automatic)
                    }
                    
                   // self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 1),IndexPath.init(row: 0, section: 9)], with: .automatic)
                    
                    self.calculateWeight()
                } else if selectedSize >= self.ladiesSize[3].sizeset.minSize && selectedSize <= self.ladiesSize[3].sizeset.maxSize {
                    // +10 logic
                    let percent = Double(10.0 / 100)
                    let weight = percent * tempWeight
                    let finalWeight = tempWeight + weight
                    
                    
                    if self.originalWeight != "" {
                        for i in 0..<goldweightchange.count {
                            
                            let percent = Double(10.0 / 100)
                            let weight = percent * goldweightchange[i]
                            let finalWeight = goldweightchange[i] * 1.1
                        
                            self.goldAsset[i].weight = finalWeight.toString()
                            
                            //self.priceLbl.text = self.calculateTotalPrice()
                            
                            
                        }
                        
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 5),IndexPath.init(row: 0, section: 9)], with: .automatic)
                    }
                    
                    
                    
                    
                    
                    if self.originalWeightsilver != "" {
                        let weightsil =  percent * self.originalWeightsilver.toDouble()
                        let finalWeightsil = self.originalWeightsilver.toDouble() + weightsil
                        self.silverAsset[0].weight = finalWeightsil.toString()
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 6),IndexPath.init(row: 0, section: 6)], with: .automatic)
                    }
                    if self.originalWeightplat != "" {
                        
                        let weightplat =  percent * self.originalWeightplat.toDouble()
                        let finalWeightplat = self.originalWeightplat.toDouble() + weightplat
                        
                        self.platinumAsset[0].weight = finalWeightplat.toString()
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 5),IndexPath.init(row: 0, section: 5)], with: .automatic)
                    }
                    
                    
                   // self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 9),IndexPath.init(row: 0, section: 9)], with: .automatic)
                    self.calculateWeight()
                }
            } else if self.gender == "Male" {
                if selectedSize >= self.gentsSize[0].sizeset.minSize || selectedSize <= self.gentsSize[0].sizeset.maxSize {
                    // -5 % logic
                    let percent = Double(5.0 / 100)
                    let weight = percent * tempWeight
                    let finalWeight = tempWeight - weight
                    
                    if self.originalWeight != "" {
                        for i in 0..<goldweightchange.count {
                            
                            let percent = Double(5.0 / 100)
                            let weight = percent * goldweightchange[i]
                            let finalWeight = goldweightchange[i] * 0.95
                        
                            self.goldAsset[i].weight = finalWeight.toString()
                            
                            //self.priceLbl.text = self.calculateTotalPrice()
                            
                            
                        }
                        
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 6),IndexPath.init(row: 0, section: 9)], with: .automatic)
                    }
                    
                    
                    
                    
                    if self.originalWeightsilver != "" {
                        let weightsil =  percent * self.originalWeightsilver.toDouble()
                        let finalWeightsil = self.originalWeightsilver.toDouble() - weightsil
                       // self.silverAsset[0].weight = finalWeightsil.toString()
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 1),IndexPath.init(row: 0, section: 9)], with: .automatic)
                    }
                    
                    if self.originalWeightplat != "" {
                        
                        let weightplat =  percent * self.originalWeightplat.toDouble()
                        let finalWeightplat = self.originalWeightplat.toDouble() - weightplat
                        self.platinumAsset[0].weight = finalWeightplat.toString()
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 5),IndexPath.init(row: 0, section: 5)], with: .automatic)
                    }
                    
                    
                   // self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 1),IndexPath.init(row: 0, section: 9)], with: .automatic)
                    self.calculateWeight()
                } else if selectedSize >= self.gentsSize[1].sizeset.minSize || selectedSize <= self.gentsSize[1].sizeset.maxSize {
                    // No changes or switch to default wieght
                    for i in 0..<goldweightchange.count {
                        
                        let percent = Double(5.0 / 100)
                        let weight = percent * goldweightchange[i]
                        let finalWeight = goldweightchange[i] * 1.00
                    
                        self.goldAsset[i].weight = finalWeight.toString()
                        
                        //self.priceLbl.text = self.calculateTotalPrice()
                        
                        
                    }
                    self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 5),IndexPath.init(row: 0, section: 9)], with: .automatic)
                    self.calculateWeight()
                } else if selectedSize >= self.gentsSize[2].sizeset.minSize || selectedSize <= self.gentsSize[2].sizeset.maxSize {
                    // +8 Logic
                    let percent = Double(8.0 / 100)
                    let weight = percent * tempWeight
                    let finalWeight = tempWeight + weight
                    
                    if self.originalWeightsilver != "" {
                        let weightsil =  percent * self.originalWeightsilver.toDouble()
                        let finalWeightsil = self.originalWeightsilver.toDouble() + weightsil
                        self.silverAsset[0].weight = finalWeightsil.toString()
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 6),IndexPath.init(row: 0, section: 6)], with: .automatic)
                    }
                    if self.originalWeightplat != "" {
                        
                        let weightplat =  percent * self.originalWeightplat.toDouble()
                        let finalWeightplat = self.originalWeightplat.toDouble() + weightplat
                        
                        self.platinumAsset[0].weight = finalWeightplat.toString()
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 5),IndexPath.init(row: 0, section: 5)], with: .automatic)
                    }
                    
                    if self.originalWeight != "" {
                        for i in 0..<goldweightchange.count {
                            
                            let percent = Double(8.0 / 100)
                            let weight = percent * goldweightchange[i]
                            let finalWeight = goldweightchange[i] * 1.08
                        
                            self.goldAsset[i].weight = finalWeight.toString()
                            
                            //self.priceLbl.text = self.calculateTotalPrice()
                            
                            
                        }
                        
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 5),IndexPath.init(row: 0, section: 9)], with: .automatic)
                    }
                    
                    self.calculateWeight()
                } else if selectedSize >= self.gentsSize[3].sizeset.minSize || selectedSize <= self.gentsSize[3].sizeset.maxSize {
                    // +12 logic
                    let percent = Double(12.0 / 100)
                    let weight = percent * tempWeight
                    let finalWeight = tempWeight + weight
                    
                    if self.originalWeightsilver != "" {
                        let weightsil =  percent * self.originalWeightsilver.toDouble()
                        let finalWeightsil = self.originalWeightsilver.toDouble() + weightsil
                        self.silverAsset[0].weight = finalWeightsil.toString()
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 6),IndexPath.init(row: 0, section: 6)], with: .automatic)
                    }
                    if self.originalWeightplat != "" {
                        
                        let weightplat =  percent * self.originalWeightplat.toDouble()
                        let finalWeightplat = self.originalWeightplat.toDouble() + weightplat
                        
                        self.platinumAsset[0].weight = finalWeightplat.toString()
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 5),IndexPath.init(row: 0, section: 5)], with: .automatic)
                    }
                   
                    if self.originalWeight != "" {
                        for i in 0..<goldweightchange.count {
                            
                            let percent = Double(12.0 / 100)
                            let weight = percent * goldweightchange[i]
                            let finalWeight = goldweightchange[i] * 1.12
                        
                            self.goldAsset[i].weight = finalWeight.toString()
                            
                            //self.priceLbl.text = self.calculateTotalPrice()
                            
                            
                        }
                        
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 5),IndexPath.init(row: 0, section: 9)], with: .automatic)
                    }
                    
                    self.calculateWeight()
                } else if selectedSize >= self.gentsSize[4].sizeset.minSize || selectedSize <= self.gentsSize[4].sizeset.maxSize {
                    // +15 logic
                    let percent = Double(15.0 / 100)
                    let weight = percent * tempWeight
                    let finalWeight = tempWeight + weight
                    
                    if self.originalWeightsilver != "" {
                        let weightsil =  percent * self.originalWeightsilver.toDouble()
                        let finalWeightsil = self.originalWeightsilver.toDouble() + weightsil
                        self.silverAsset[0].weight = finalWeightsil.toString()
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 6),IndexPath.init(row: 0, section: 6)], with: .automatic)
                    }
                    if self.originalWeightplat != "" {
                        
                        let weightplat =  percent * self.originalWeightplat.toDouble()
                        let finalWeightplat = self.originalWeightplat.toDouble() + weightplat
                        
                        self.platinumAsset[0].weight = finalWeightplat.toString()
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 5),IndexPath.init(row: 0, section: 5)], with: .automatic)
                    }
                    
                    if self.originalWeight != "" {
                        for i in 0..<goldweightchange.count {
                            
                            let percent = Double(15.0 / 100)
                            let weight = percent * goldweightchange[i]
                            let finalWeight = goldweightchange[i] * 1.15
                        
                            self.goldAsset[i].weight = finalWeight.toString()
                            
                            //self.priceLbl.text = self.calculateTotalPrice()
                            
                            
                        }
                        
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 5),IndexPath.init(row: 0, section: 9)], with: .automatic)
                    }
                    
                    self.calculateWeight()
                }
            }
            
            if self.product?.data.jwelleryType == "Chain" {
                let defaultSize = self.product?.data.defaultSize.toDouble()
                let data = Double(selectedSize) - defaultSize!
                let wr = Double(tempWeight) / defaultSize!
                let final = wr * data
                let finalweight = Double(tempWeight)+final
                
                
                
                if self.originalWeight != "" {
                    self.goldAsset[0].weight = finalweight.toString()
                    
                    self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 5),IndexPath.init(row: 0, section: 9)], with: .automatic)
                }
                
                
                
                if self.originalWeightsilver != "" {
                    let defaultSize = self.product?.data.defaultSize.toDouble()
                    let data = Double(selectedSize) - defaultSize!
                    let wr = Double(self.originalWeightsilver)! / defaultSize!
                    let final = wr * data
                    let finalweight = Double(self.originalWeightsilver)!+final
                    self.silverAsset[0].weight = finalweight.toString()
                    self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 6),IndexPath.init(row: 0, section: 6)], with: .automatic)
                }
                if self.originalWeightplat != "" {
                    
                    let defaultSize = self.product?.data.defaultSize.toDouble()
                    let data = Double(selectedSize) - defaultSize!
                    let wr = Double(self.originalWeightplat)! / defaultSize!
                    let final = wr * data
                    let finalweight = Double(self.originalWeightplat)!+final
                    
                    self.platinumAsset[0].weight = finalweight.toString()
                    self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 5),IndexPath.init(row: 0, section: 5)], with: .automatic)
                }
               // self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 1),IndexPath.init(row: 0, section: 9)], with: .automatic)
                
                self.calculateWeight()
                
                
                
            }
            self.calculateTotalPrice()
            
        }else {
            
            let tempWeight = self.originalWeight.toDouble()
            print(selectedSize)
            self.productSize = "\(selectedSize)"
            self.ischange = true
            if self.gender == "FeMale" {
                if selectedSize >= self.ladiesSize[0].sizeset.minSize && selectedSize <= self.ladiesSize[0].sizeset.maxSize {
                    // -5 % logic
                    
                    
                    let percent = Double(5.0 / 100)
                    let weight = percent * tempWeight
                    let finalWeight = tempWeight - weight
                    
                    if self.originalWeight != "" {
                        
                        for i in 0..<goldweightchange.count {
                            
                            let percent = Double(5.0 / 100)
                            let weight = percent * goldweightchange[i]
                            let finalWeight = goldweightchange[i] * 0.95
                        
                            self.goldAsset[i].weight = finalWeight.toString()
                            
                            //self.priceLbl.text = self.calculateTotalPrice()
                            
                            
                        }
                        
                        //self.goldAsset[0].weight = finalWeight.toString()
                        
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 1),IndexPath.init(row: 0, section: 9)], with: .automatic)
                    }
                    
                    
                    

                    if self.originalWeightsilver != "" {
                        let weightsil =  percent * self.originalWeightsilver.toDouble()
                        let finalWeightsil = self.originalWeightsilver.toDouble() - weightsil
                        self.silverAsset[0].weight = finalWeightsil.toString()
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 6),IndexPath.init(row: 0, section: 6)], with: .automatic)
                    }
                    
                    if self.originalWeightplat != "" {
                        
                        let weightplat =  percent * self.originalWeightplat.toDouble()
                        let finalWeightplat = self.originalWeightplat.toDouble() - weightplat
                        self.platinumAsset[0].weight = finalWeightplat.toString()
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 4),IndexPath.init(row: 0, section: 4)], with: .automatic)
                    }
                
                    
                    
                    self.calculateWeight()
                } else if selectedSize >= self.ladiesSize[1].sizeset.minSize && selectedSize <= self.ladiesSize[1].sizeset.maxSize {
                    // No changes or switch to default wieght
                    
                    for i in 0..<goldweightchange.count {
                        
                        let percent = Double(5.0 / 100)
                        let weight = percent * goldweightchange[i]
                        let finalWeight = goldweightchange[i] * 1.00
                    
                        self.goldAsset[i].weight = finalWeight.toString()
                        
                        //self.priceLbl.text = self.calculateTotalPrice()
                        
                        
                    }
                    self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 1),IndexPath.init(row: 0, section: 9)], with: .automatic)
                    self.calculateWeight()
                } else if selectedSize >= self.ladiesSize[2].sizeset.minSize && selectedSize <= self.ladiesSize[2].sizeset.maxSize {
                    // +7 Logic
                    
                    let percent = Double(7.0 / 100)
                    let weight =  percent * tempWeight
                    let finalWeight = tempWeight + weight
                    
                    if self.originalWeight != "" {
                        for i in 0..<goldweightchange.count {
                            
                            let percent = Double(7.0 / 100)
                            let weight = percent * goldweightchange[i]
                            let finalWeight = goldweightchange[i] * 1.07
                        
                            self.goldAsset[i].weight = finalWeight.toString()
                            
                            //self.priceLbl.text = self.calculateTotalPrice()
                            
                            
                        }
                        
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 1),IndexPath.init(row: 0, section: 9)], with: .automatic)
                    }
                    
                    
                    
                    if self.originalWeightsilver != "" {
                        let weightsil =  percent * self.originalWeightsilver.toDouble()
                        let finalWeightsil = self.originalWeightsilver.toDouble() + weightsil
                        self.silverAsset[0].weight = finalWeightsil.toString()
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 6),IndexPath.init(row: 0, section: 6)], with: .automatic)
                    }
                    if self.originalWeightplat != "" {
                        
                        let weightplat =  percent * self.originalWeightplat.toDouble()
                        let finalWeightplat = self.originalWeightplat.toDouble() + weightplat
                        
                        self.platinumAsset[0].weight = finalWeightplat.toString()
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 4),IndexPath.init(row: 0, section: 4)], with: .automatic)
                    }
                    
                   // self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 1),IndexPath.init(row: 0, section: 9)], with: .automatic)
                    
                    self.calculateWeight()
                } else if selectedSize >= self.ladiesSize[3].sizeset.minSize && selectedSize <= self.ladiesSize[3].sizeset.maxSize {
                    // +10 logic
                    let percent = Double(10.0 / 100)
                    let weight = percent * tempWeight
                    let finalWeight = tempWeight + weight
                    
                    
                    if self.originalWeight != "" {
                        for i in 0..<goldweightchange.count {
                            
                            let percent = Double(10.0 / 100)
                            let weight = percent * goldweightchange[i]
                            let finalWeight = goldweightchange[i] * 1.1
                        
                            self.goldAsset[i].weight = finalWeight.toString()
                            
                            //self.priceLbl.text = self.calculateTotalPrice()
                            
                            
                        }
                        
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 1),IndexPath.init(row: 0, section: 9)], with: .automatic)
                    }
                    
                    
                    
                    
                    
                    if self.originalWeightsilver != "" {
                        let weightsil =  percent * self.originalWeightsilver.toDouble()
                        let finalWeightsil = self.originalWeightsilver.toDouble() + weightsil
                        self.silverAsset[0].weight = finalWeightsil.toString()
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 6),IndexPath.init(row: 0, section: 6)], with: .automatic)
                    }
                    if self.originalWeightplat != "" {
                        
                        let weightplat =  percent * self.originalWeightplat.toDouble()
                        let finalWeightplat = self.originalWeightplat.toDouble() + weightplat
                        
                        self.platinumAsset[0].weight = finalWeightplat.toString()
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 4),IndexPath.init(row: 0, section: 4)], with: .automatic)
                    }
                    
                    
                   // self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 9),IndexPath.init(row: 0, section: 9)], with: .automatic)
                    self.calculateWeight()
                }
            } else if self.gender == "Male" {
                if selectedSize >= self.gentsSize[0].sizeset.minSize || selectedSize <= self.gentsSize[0].sizeset.maxSize {
                    // -5 % logic
                    let percent = Double(5.0 / 100)
                    let weight = percent * tempWeight
                    let finalWeight = tempWeight - weight
                    
                    if self.originalWeight != "" {
                        for i in 0..<goldweightchange.count {
                            
                            let percent = Double(5.0 / 100)
                            let weight = percent * goldweightchange[i]
                            let finalWeight = goldweightchange[i] * 0.95
                        
                            self.goldAsset[i].weight = finalWeight.toString()
                            
                            //self.priceLbl.text = self.calculateTotalPrice()
                            
                            
                        }
                        
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 1),IndexPath.init(row: 0, section: 9)], with: .automatic)
                    }
                    
                    
                    
                    
                    if self.originalWeightsilver != "" {
                        let weightsil =  percent * self.originalWeightsilver.toDouble()
                        let finalWeightsil = self.originalWeightsilver.toDouble() - weightsil
                        self.silverAsset[0].weight = finalWeightsil.toString()
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 6),IndexPath.init(row: 0, section: 6)], with: .automatic)
                    }
                    
                    if self.originalWeightplat != "" {
                        
                        let weightplat =  percent * self.originalWeightplat.toDouble()
                        let finalWeightplat = self.originalWeightplat.toDouble() - weightplat
                        self.platinumAsset[0].weight = finalWeightplat.toString()
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 4),IndexPath.init(row: 0, section: 4)], with: .automatic)
                    }
                    
                    
                   // self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 1),IndexPath.init(row: 0, section: 9)], with: .automatic)
                    self.calculateWeight()
                } else if selectedSize >= self.gentsSize[1].sizeset.minSize || selectedSize <= self.gentsSize[1].sizeset.maxSize {
                    // No changes or switch to default wieght
                    for i in 0..<goldweightchange.count {
                        
                        let percent = Double(5.0 / 100)
                        let weight = percent * goldweightchange[i]
                        let finalWeight = goldweightchange[i] * 1.00
                    
                        self.goldAsset[i].weight = finalWeight.toString()
                        
                        //self.priceLbl.text = self.calculateTotalPrice()
                        
                        
                    }
                    self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 1),IndexPath.init(row: 0, section: 9)], with: .automatic)
                    self.calculateWeight()
                } else if selectedSize >= self.gentsSize[2].sizeset.minSize || selectedSize <= self.gentsSize[2].sizeset.maxSize {
                    // +8 Logic
                    let percent = Double(8.0 / 100)
                    let weight = percent * tempWeight
                    let finalWeight = tempWeight + weight
                    
                    if self.originalWeightsilver != "" {
                        let weightsil =  percent * self.originalWeightsilver.toDouble()
                        let finalWeightsil = self.originalWeightsilver.toDouble() + weightsil
                        self.silverAsset[0].weight = finalWeightsil.toString()
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 6),IndexPath.init(row: 0, section: 6)], with: .automatic)
                    }
                    if self.originalWeightplat != "" {
                        
                        let weightplat =  percent * self.originalWeightplat.toDouble()
                        let finalWeightplat = self.originalWeightplat.toDouble() + weightplat
                        
                        self.platinumAsset[0].weight = finalWeightplat.toString()
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 4),IndexPath.init(row: 0, section: 4)], with: .automatic)
                    }
                    
                    if self.originalWeight != "" {
                        for i in 0..<goldweightchange.count {
                            
                            let percent = Double(8.0 / 100)
                            let weight = percent * goldweightchange[i]
                            let finalWeight = goldweightchange[i] * 1.08
                        
                            self.goldAsset[i].weight = finalWeight.toString()
                            
                            //self.priceLbl.text = self.calculateTotalPrice()
                            
                            
                        }
                        
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 1),IndexPath.init(row: 0, section: 9)], with: .automatic)
                    }
                    
                    self.calculateWeight()
                } else if selectedSize >= self.gentsSize[3].sizeset.minSize || selectedSize <= self.gentsSize[3].sizeset.maxSize {
                    // +12 logic
                    let percent = Double(12.0 / 100)
                    let weight = percent * tempWeight
                    let finalWeight = tempWeight + weight
                    
                    if self.originalWeightsilver != "" {
                        let weightsil =  percent * self.originalWeightsilver.toDouble()
                        let finalWeightsil = self.originalWeightsilver.toDouble() + weightsil
                        self.silverAsset[0].weight = finalWeightsil.toString()
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 6),IndexPath.init(row: 0, section: 6)], with: .automatic)
                    }
                    if self.originalWeightplat != "" {
                        
                        let weightplat =  percent * self.originalWeightplat.toDouble()
                        let finalWeightplat = self.originalWeightplat.toDouble() + weightplat
                        
                        self.platinumAsset[0].weight = finalWeightplat.toString()
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 4),IndexPath.init(row: 0, section: 4)], with: .automatic)
                    }
                   
                    if self.originalWeight != "" {
                        for i in 0..<goldweightchange.count {
                            
                            let percent = Double(12.0 / 100)
                            let weight = percent * goldweightchange[i]
                            let finalWeight = goldweightchange[i] * 1.12
                        
                            self.goldAsset[i].weight = finalWeight.toString()
                            
                            //self.priceLbl.text = self.calculateTotalPrice()
                            
                            
                        }
                        
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 1),IndexPath.init(row: 0, section: 9)], with: .automatic)
                    }
                    
                    self.calculateWeight()
                } else if selectedSize >= self.gentsSize[4].sizeset.minSize || selectedSize <= self.gentsSize[4].sizeset.maxSize {
                    // +15 logic
                    let percent = Double(15.0 / 100)
                    let weight = percent * tempWeight
                    let finalWeight = tempWeight + weight
                    
                    if self.originalWeightsilver != "" {
                        let weightsil =  percent * self.originalWeightsilver.toDouble()
                        let finalWeightsil = self.originalWeightsilver.toDouble() + weightsil
                        self.silverAsset[0].weight = finalWeightsil.toString()
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 6),IndexPath.init(row: 0, section: 6)], with: .automatic)
                    }
                    if self.originalWeightplat != "" {
                        
                        let weightplat =  percent * self.originalWeightplat.toDouble()
                        let finalWeightplat = self.originalWeightplat.toDouble() + weightplat
                        
                        self.platinumAsset[0].weight = finalWeightplat.toString()
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 4),IndexPath.init(row: 0, section: 4)], with: .automatic)
                    }
                    
                    if self.originalWeight != "" {
                        for i in 0..<goldweightchange.count {
                            
                            let percent = Double(15.0 / 100)
                            let weight = percent * goldweightchange[i]
                            let finalWeight = goldweightchange[i] * 1.15
                        
                            self.goldAsset[i].weight = finalWeight.toString()
                            
                            //self.priceLbl.text = self.calculateTotalPrice()
                            
                            
                        }
                        
                        self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 1),IndexPath.init(row: 0, section: 9)], with: .automatic)
                    }
                    
                    self.calculateWeight()
                }
            }
            
            if self.product?.data.jwelleryType == "Chain" {
                let defaultSize = self.product?.data.defaultSize.toDouble()
                let data = Double(selectedSize) - defaultSize!
                let wr = Double(tempWeight) / defaultSize!
                let final = wr * data
                let finalweight = Double(tempWeight)+final
                
                
                
                if self.originalWeight != "" {
                    
                    
                    
                    for i in 0..<goldweightchange.count {
                        
                        let defaultSize = self.product?.data.defaultSize.toDouble()
                        let data = Double(selectedSize) - defaultSize!
                        let wr = Double(goldweightchange[i]) / defaultSize!
                        let final = wr * data
                        let finalweight = Double(goldweightchange[i])+final
                        
                       
                    
                        self.goldAsset[i].weight = finalweight.toString()
                        
                        //self.priceLbl.text = self.calculateTotalPrice()
                        
                        
                    }
                    
                    
                    self.goldAsset[0].weight = finalweight.toString()
                    
                    self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 1),IndexPath.init(row: 0, section: 9)], with: .automatic)
                }
                
                
                
                if self.originalWeightsilver != "" {
                    let defaultSize = self.product?.data.defaultSize.toDouble()
                    let data = Double(selectedSize) - defaultSize!
                    let wr = Double(self.originalWeightsilver)! / defaultSize!
                    let final = wr * data
                    let finalweight = Double(self.originalWeightsilver)!+final
                    self.silverAsset[0].weight = finalweight.toString()
                    self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 6),IndexPath.init(row: 0, section: 6)], with: .automatic)
                }
                if self.originalWeightplat != "" {
                    
                    let defaultSize = self.product?.data.defaultSize.toDouble()
                    let data = Double(selectedSize) - defaultSize!
                    let wr = Double(self.originalWeightplat)! / defaultSize!
                    let final = wr * data
                    let finalweight = Double(self.originalWeightplat)!+final
                    
                    self.platinumAsset[0].weight = finalweight.toString()
                    self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 4),IndexPath.init(row: 0, section: 4)], with: .automatic)
                }
               // self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 1),IndexPath.init(row: 0, section: 9)], with: .automatic)
                
                self.calculateWeight()
                
                
                
            }
            self.calculateTotalPrice()
            
            
        }
        
        
        
        
       
        
    }
    
    func calculateWeight() {
        var gold = 0.0
        var diamond = 0.0
        var stone = 0.0
        var platinum = 0.0
        var silver = 0.0
        
        if self.prodType == "GOLD JEWELLERY" {
            
            if self.goldAsset.count > 0 {
                let cell = self.productDetailTableView.cellForRow(at: IndexPath.init(row: 0, section: 1)) as! GoldDetailCell
                let total = cell.netGoldWeightLbl.text?.replacingOccurrences(of: " g", with: "").toDouble()
                gold = total ?? 0.0
                print(gold)
            }
            
            if self.diamondAsset.count > 0 {
                for i in 0 ..< diamondAsset.count {
                    if self.diamondAsset[i].certificationCost == "" {
                        let cell = self.productDetailTableView.cellForRow(at: IndexPath.init(row: i, section: 2)) as! productDiamondCell
                        let diamondWeight = cell.lblWeight.text?.replacingOccurrences(of: " Ct", with: "").toDouble() ?? 0.0
                        let temp = diamondWeight * 0.2
                        diamond += temp
                        print(diamond)
                    } else {
                        let cell = self.productDetailTableView.cellForRow(at: IndexPath.init(row: i, section: 2)) as! productDiamondCellCertified
                        let diamondWeight = cell.lblWeight.text?.replacingOccurrences(of: " Ct", with: "").toDouble() ?? 0.0
                        let temp = diamondWeight * 0.2
                        diamond += temp
                        print(diamond)
                   }
                    
                }
            }
            
            if self.stoneAsset.count > 0 {
                for i in 0 ..< self.arrFinalStone.count {
                    let cell = self.productDetailTableView.cellForRow(at: IndexPath.init(row: i, section: 3)) as! productStoneCell
                    let total = cell.lblStoneWeight.text?.replacingOccurrences(of: " Ct", with: "").toDouble() ?? 0.0
                    let temp = total * 0.2
                    stone += temp
                    print(stone)
                }
            }
            
            if self.platinumAsset.count > 0 {
                let cell = self.productDetailTableView.cellForRow(at: IndexPath.init(row: 0, section: 4)) as! productPlatinumCell
                let total = cell.lblPlatinumWeight.text?.replacingOccurrences(of: " g", with: "")
                let trimmed = total!.trimmingCharacters(in: .whitespacesAndNewlines)
                //let tot = Double(trimmed)! * 0.2
                let tottot = String(format: "%.1f", (trimmed))
                platinum = Double(trimmed)!
                print(platinum)
                
            }
            
            
            if self.silverAsset.count > 0 {
                
                let cell = self.productDetailTableView.cellForRow(at: IndexPath.init(row: 0, section: 6)) as! productSilverCell
                let total = cell.lblWeight.text?.replacingOccurrences(of: " g", with: "")
                let trimmed = total!.trimmingCharacters(in: .whitespacesAndNewlines)
                let tot = Double(trimmed)
                silver += tot ?? 0.0
                
            }
            
            let total = gold + diamond + stone + platinum + silver
            let netgoldy = String(format: "%.3f", total)
            
            
            if self.deliverytime == "" {
                self.grossWeightLbl.text = ""
            }else {
                self.grossWeightLbl.text = "Usually Delivery Time: \(self.deliverytime)"
            }
            
            
            self.productCode.text = "Gross weight : " + netgoldy + " g"
            
            
          
        } else if self.prodType == "DIAMOND JEWELLERY" {
            
            if self.goldAsset.count > 0 {
                let cell = self.productDetailTableView.cellForRow(at: IndexPath.init(row: 0, section: 2)) as! GoldDetailCell
                let total = cell.netGoldWeightLbl.text?.replacingOccurrences(of: " g", with: "").toDouble()
                gold = total ?? 0.0
                print(gold)
            }
            
            if self.diamondAsset.count > 0 {
                for i in 0 ..< diamondAsset.count {
                    if self.diamondAsset[i].certificationCost == "" || self.diamondAsset[i].certificationCost == "0"{
                        let cell = self.productDetailTableView.cellForRow(at: IndexPath.init(row: i, section: 1)) as! productDiamondCell
                        let diamondWeight = cell.lblWeight.text?.replacingOccurrences(of: " Ct", with: "").toDouble() ?? 0.0
                        let temp = diamondWeight * 0.2
                        diamond += temp
                        print(diamond)
                    } else {
                        let cell = self.productDetailTableView.cellForRow(at: IndexPath.init(row: i, section: 1)) as! productDiamondCellCertified
                        let diamondWeight = cell.lblWeight.text?.replacingOccurrences(of: " Ct", with: "").toDouble() ?? 0.0
                        let temp = diamondWeight * 0.2
                        diamond += temp
                        print(diamond)
                   }
                    
                }
            }
            
            if self.stoneAsset.count > 0 {
                for i in 0 ..< self.arrFinalStone.count {
                    let cell = self.productDetailTableView.cellForRow(at: IndexPath.init(row: i, section: 3)) as! productStoneCell
                    let total = cell.lblStoneWeight.text?.replacingOccurrences(of: " Ct", with: "").toDouble() ?? 0.0
                    let temp = total * 0.2
                    stone += temp
                    print(stone)
                }
            }
            
            if self.platinumAsset.count > 0 {
                let cell = self.productDetailTableView.cellForRow(at: IndexPath.init(row: 0, section: 4)) as! productPlatinumCell
                let total = cell.lblPlatinumWeight.text?.replacingOccurrences(of: " g", with: "")
                let trimmed = total!.trimmingCharacters(in: .whitespacesAndNewlines)
                //let tot = Double(trimmed)! * 0.2
                let tottot = String(format: "%.1f", (trimmed))
                platinum = Double(trimmed)!
                print(platinum)
                
            }
            
            
            if self.silverAsset.count > 0 {
                
                let cell = self.productDetailTableView.cellForRow(at: IndexPath.init(row: 0, section: 5)) as! productSilverCell
                let total = cell.lblWeight.text?.replacingOccurrences(of: " g", with: "")
                let trimmed = total!.trimmingCharacters(in: .whitespacesAndNewlines)
                let tot = Double(trimmed)
                silver += tot ?? 0.0
                
            }
            
            let total = gold + diamond + stone + platinum + silver
            let netgoldy = String(format: "%.3f", total)
            
            if self.deliverytime == "" {
                self.grossWeightLbl.text = ""
            }else {
                self.grossWeightLbl.text = "Usually Delivery Time: \(self.deliverytime)"
            }
            self.productCode.text = "Gross weight : " + netgoldy + " g"
         
            
            
        }  else if self.prodType == "PLATINUM JEWELLERY" {
            
            if self.goldAsset.count > 0 {
                let cell = self.productDetailTableView.cellForRow(at: IndexPath.init(row: 0, section: 4)) as! GoldDetailCell
                let total = cell.netGoldWeightLbl.text?.replacingOccurrences(of: " g", with: "").toDouble()
                gold = total ?? 0.0
                print(gold)
            }
            
            if self.diamondAsset.count > 0 {
                for i in 0 ..< diamondAsset.count {
                    if self.diamondAsset[i].certificationCost == "" {
                        let cell = self.productDetailTableView.cellForRow(at: IndexPath.init(row: i, section: 2)) as! productDiamondCell
                        let diamondWeight = cell.lblWeight.text?.replacingOccurrences(of: " Ct", with: "").toDouble() ?? 0.0
                        let temp = diamondWeight * 0.2
                        diamond += temp
                        print(diamond)
                    } else {
                        let cell = self.productDetailTableView.cellForRow(at: IndexPath.init(row: i, section: 2)) as! productDiamondCellCertified
                        let diamondWeight = cell.lblWeight.text?.replacingOccurrences(of: " Ct", with: "").toDouble() ?? 0.0
                        let temp = diamondWeight * 0.2
                        diamond += temp
                        print(diamond)
                   }
                    
                }
            }
            
            if self.stoneAsset.count > 0 {
                for i in 0 ..< self.arrFinalStone.count {
                    let cell = self.productDetailTableView.cellForRow(at: IndexPath.init(row: i, section: 3)) as! productStoneCell
                    let total = cell.lblStoneWeight.text?.replacingOccurrences(of: " Ct", with: "").toDouble() ?? 0.0
                    let temp = total * 0.2
                    stone += temp
                    print(stone)
                }
            }
            
            if self.platinumAsset.count > 0 {
                let cell = self.productDetailTableView.cellForRow(at: IndexPath.init(row: 0, section: 1)) as! productPlatinumCell
                let total = cell.lblPlatinumWeight.text?.replacingOccurrences(of: " g", with: "")
                let trimmed = total!.trimmingCharacters(in: .whitespacesAndNewlines)
                //let tot = Double(trimmed)! * 0.2
                let tottot = String(format: "%.1f", (trimmed))
                platinum = Double(trimmed)!
                print(platinum)
                
            }
            
            
            if self.silverAsset.count > 0 {
                
                let cell = self.productDetailTableView.cellForRow(at: IndexPath.init(row: 0, section: 5)) as! productSilverCell
                let total = cell.lblWeight.text?.replacingOccurrences(of: " g", with: "")
                let trimmed = total!.trimmingCharacters(in: .whitespacesAndNewlines)
                let tot = Double(trimmed)
                silver += tot ?? 0.0
                
            }
            
            let total = gold + diamond + stone + platinum + silver
            let netgoldy = String(format: "%.3f", total)
            
            if self.deliverytime == "" {
                self.grossWeightLbl.text = ""
            }else {
                self.grossWeightLbl.text = "Usually Delivery Time: \(self.deliverytime)"
            }
            self.productCode.text = "Gross weight : " + netgoldy + " g"
          
          
        } else if self.prodType == "SILVER JEWELLERY" {
            
          
            if self.goldAsset.count > 0 {
                let cell = self.productDetailTableView.cellForRow(at: IndexPath.init(row: 0, section: 5)) as! GoldDetailCell
                let total = cell.netGoldWeightLbl.text?.replacingOccurrences(of: " g", with: "").toDouble()
                gold = total ?? 0.0
                print(gold)
            }
            
            if self.diamondAsset.count > 0 {
                for i in 0 ..< diamondAsset.count {
                    if self.diamondAsset[i].certificationCost == "" {
                        let cell = self.productDetailTableView.cellForRow(at: IndexPath.init(row: i, section: 2)) as! productDiamondCell
                        let diamondWeight = cell.lblWeight.text?.replacingOccurrences(of: " Ct", with: "").toDouble() ?? 0.0
                        let temp = diamondWeight * 0.2
                        diamond += temp
                        print(diamond)
                    } else {
                        let cell = self.productDetailTableView.cellForRow(at: IndexPath.init(row: i, section: 2)) as! productDiamondCellCertified
                        let diamondWeight = cell.lblWeight.text?.replacingOccurrences(of: " Ct", with: "").toDouble() ?? 0.0
                        let temp = diamondWeight * 0.2
                        diamond += temp
                        print(diamond)
                   }
                    
                }
            }
            
            if self.stoneAsset.count > 0 {
                for i in 0 ..< self.arrFinalStone.count {
                    let cell = self.productDetailTableView.cellForRow(at: IndexPath.init(row: i, section: 3)) as! productStoneCell
                    let total = cell.lblStoneWeight.text?.replacingOccurrences(of: " Ct", with: "").toDouble() ?? 0.0
                    let temp = total * 0.2
                    stone += temp
                    print(stone)
                }
            }
            
            if self.platinumAsset.count > 0 {
                let cell = self.productDetailTableView.cellForRow(at: IndexPath.init(row: 0, section: 4)) as! productPlatinumCell
                let total = cell.lblPlatinumWeight.text?.replacingOccurrences(of: " g", with: "")
                let trimmed = total!.trimmingCharacters(in: .whitespacesAndNewlines)
                //let tot = Double(trimmed)! * 0.2
                let tottot = String(format: "%.1f", (trimmed))
                platinum = Double(trimmed)!
                print(platinum)
                
            }
            
            
            if self.silverAsset.count > 0 {
                
                let cell = self.productDetailTableView.cellForRow(at: IndexPath.init(row: 0, section: 1)) as! productSilverCell
                let total = cell.lblWeight.text?.replacingOccurrences(of: " g", with: "")
                let trimmed = total!.trimmingCharacters(in: .whitespacesAndNewlines)
                let tot = Double(trimmed)
                silver += tot ?? 0.0
                
            }
            
            let total = gold + diamond + stone + platinum + silver
            let netgoldy = String(format: "%.3f", total)
            
            if self.deliverytime == "" {
                self.grossWeightLbl.text = ""
            }else {
                self.grossWeightLbl.text = "Usually Delivery Time: \(self.deliverytime)"
            }
            self.productCode.text = "Gross weight : " + netgoldy + " g"
          
          
        }else {
            
            if self.goldAsset.count > 0 {
                let cell = self.productDetailTableView.cellForRow(at: IndexPath.init(row: 0, section: 1)) as! GoldDetailCell
                let total = cell.netGoldWeightLbl.text?.replacingOccurrences(of: " g", with: "").toDouble()
                gold = total ?? 0.0
                print(gold)
            }
            
            if self.diamondAsset.count > 0 {
                for i in 0 ..< diamondAsset.count {
                    if self.diamondAsset[i].certificationCost == "" {
                        let cell = self.productDetailTableView.cellForRow(at: IndexPath.init(row: i, section: 2)) as! productDiamondCell
                        let diamondWeight = cell.lblWeight.text?.replacingOccurrences(of: " Ct", with: "").toDouble() ?? 0.0
                        let temp = diamondWeight * 0.2
                        diamond += temp
                        print(diamond)
                    } else {
                        let cell = self.productDetailTableView.cellForRow(at: IndexPath.init(row: i, section: 2)) as! productDiamondCellCertified
                        let diamondWeight = cell.lblWeight.text?.replacingOccurrences(of: " Ct", with: "").toDouble() ?? 0.0
                        let temp = diamondWeight * 0.2
                        diamond += temp
                        print(diamond)
                   }
                    
                }
            }
            
            if self.stoneAsset.count > 0 {
                for i in 0 ..< self.arrFinalStone.count {
                    let cell = self.productDetailTableView.cellForRow(at: IndexPath.init(row: i, section: 3)) as! productStoneCell
                    let total = cell.lblStoneWeight.text?.replacingOccurrences(of: " Ct", with: "").toDouble() ?? 0.0
                    let temp = total * 0.2
                    stone += temp
                    print(stone)
                }
            }
            
            if self.platinumAsset.count > 0 {
                let cell = self.productDetailTableView.cellForRow(at: IndexPath.init(row: 0, section: 4)) as! productPlatinumCell
                let total = cell.lblPlatinumWeight.text?.replacingOccurrences(of: " g", with: "")
                let trimmed = total!.trimmingCharacters(in: .whitespacesAndNewlines)
                //let tot = Double(trimmed)! * 0.2
                let tottot = String(format: "%.1f", (trimmed))
                platinum = Double(trimmed)!
                print(platinum)
                
            }
            
            
            if self.silverAsset.count > 0 {
                
                let cell = self.productDetailTableView.cellForRow(at: IndexPath.init(row: 0, section: 5)) as! productSilverCell
                let total = cell.lblWeight.text?.replacingOccurrences(of: " g", with: "")
                let trimmed = total!.trimmingCharacters(in: .whitespacesAndNewlines)
                let tot = Double(trimmed)
                silver += tot ?? 0.0
                
            }
            
            let total = gold + diamond + stone + platinum + silver
            let netgoldy = String(format: "%.3f", total)
            
            if self.deliverytime == "" {
                self.grossWeightLbl.text = ""
            }else {
                self.grossWeightLbl.text = "Usually Delivery Time: \(self.deliverytime)"
            }
            self.productCode.text = "Gross weight : " + netgoldy + " g"
          
        }
        
      
        
        
       
        //self.grossWeightLbl.text =
    }
    
    func calculateTotalPrice() -> String {
        
        
        
        var gold = 0.0
        var diamond = 0.0
        var stone = 0.0
        var platinum = 0.0
        var silver = 0.0
        
        
        if self.prodType == "GOLD JEWELLERY" {
            
            if self.goldAsset.count > 0 {
                let cell = self.productDetailTableView.cellForRow(at: IndexPath.init(row: 0, section: 1)) as! GoldDetailCell
                let total = Double((cell.totalAmount.text?.replacingOccurrences(of: "₹ ", with: ""))!)
                gold = total ?? 0.0
                
                
            }
            
            if self.diamondAsset.count > 0 {
                for i in 0 ..< diamondAsset.count {
                    if self.diamondAsset[i].certificationCost == "" {
                        let cell = self.productDetailTableView.cellForRow(at: IndexPath.init(row: i, section: 2)) as! productDiamondCell
                        let total = cell.lblDiamondTotal.text?.replacingOccurrences(of: "₹ ", with: "").toDouble()
                        diamond += total ?? 0.0
                        
                    } else {
                        let cell = self.productDetailTableView.cellForRow(at: IndexPath.init(row: i, section: 2)) as! productDiamondCellCertified
                        let total = cell.lblDiamondTotal.text?.replacingOccurrences(of: "₹ ", with: "").toDouble()
                        diamond += total ?? 0.0
                        
                    }
                    
                }
            }
            
            if self.stoneAsset.count > 0 {
                for i in 0 ..< self.arrFinalStone.count {
                    let cell = self.productDetailTableView.cellForRow(at: IndexPath.init(row: i, section: 3)) as! productStoneCell
                    let total = cell.lblStoneTotal.text?.replacingOccurrences(of: "₹", with: "")
                    let trimmed = total!.trimmingCharacters(in: .whitespacesAndNewlines)
                    let tot = Double(trimmed)
                    print(tot!)
                    stone += tot ?? 0.0
                    
                }
            }
            
            if self.platinumAsset.count > 0 {
                let cell = self.productDetailTableView.cellForRow(at: IndexPath.init(row: 0, section: 4)) as! productPlatinumCell
                let total = cell.lblPlatinumTotal.text?.replacingOccurrences(of: "₹ ", with: "")
                let trimmed = total!.trimmingCharacters(in: .whitespacesAndNewlines)
                let tot = Double(trimmed)
                platinum += tot ?? 0.0
                
            }
            
            if self.silverAsset.count > 0 {
                
                let cell = self.productDetailTableView.cellForRow(at: IndexPath.init(row: 0, section: 5)) as! productSilverCell
                let total = cell.lblSilverTotal.text?.replacingOccurrences(of: "₹ ", with: "")
                let trimmed = total!.trimmingCharacters(in: .whitespacesAndNewlines)
                let tot = Double(trimmed)
                silver += tot ?? 0.0
                
            }
            
            let totalCost = gold + diamond + stone + platinum + silver
          //  self.priceLbl.text = "₹ " + totalCost.rounded(toPlaces: 3).toString() + " (\(goldAsset[0].jwellerySize))"
            let netgoldy = String(format: "%.2f", totalCost)
            
            if goldAsset.count != 0 {
                
                
                if ispr == true {
                    self.priceLbl.text = "" + "(\(goldAsset[0].jwellerySize))"
                }else {
                    self.priceLbl.text = "₹ " + netgoldy + " (\(goldAsset[0].jwellerySize))"
                }
                
                
            }
            else if diamondAsset.count != 0 {
                if ispr == true {
                    self.priceLbl.text = "" + "(\(diamondAsset[0].jwellerySize))"
                }else {
                    self.priceLbl.text = "₹ " + netgoldy + " (\(diamondAsset[0].jwellerySize))"
                }
            }
            else if silverAsset.count != 0 {
                
                if ispr == true {
                    self.priceLbl.isHidden = true
                    self.priceLbl.text = "₹ " + netgoldy
                }else {
                    self.priceLbl.isHidden = false
                    self.priceLbl.text = "₹ " + netgoldy
                }
                
            }
            else if platinumAsset.count != 0 {
                if product?.data.jwelleryType == "Bangles" {
                    if ispr == true {
                        self.priceLbl.text = ""
                    }else {
                        self.priceLbl.text = "₹ " + netgoldy
                    }
                }else {
                    if ispr == true {
                        self.priceLbl.text = "" + "(\(goldAsset[0].jwellerySize))"
                    }else {
                        self.priceLbl.text = "₹ " + netgoldy + " (\(goldAsset[0].jwellerySize))"
                    }
                }
            }
            
            self.calculateWeight()
            self.removeAnimation()
            return totalCost.toString()
            
          
          
        } else if self.prodType == "DIAMOND JEWELLERY" {
            
          
            if self.goldAsset.count > 0 {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    let cell = self.productDetailTableView.cellForRow(at: IndexPath.init(row: 0, section: 2)) as! GoldDetailCell
                    let total = Double((cell.totalAmount.text?.replacingOccurrences(of: "₹ ", with: ""))!)
                    gold = total ?? 0.0
                }
                
               
                
                
            }
            
            if self.diamondAsset.count > 0 {
                for i in 0 ..< diamondAsset.count {
                    if self.diamondAsset[i].certificationCost == "" || self.diamondAsset[i].certificationCost == "0"{
                        let cell = self.productDetailTableView.cellForRow(at: IndexPath.init(row: i, section: 1)) as! productDiamondCell
                        let total = cell.lblDiamondTotal.text?.replacingOccurrences(of: "₹ ", with: "").toDouble()
                        diamond += total ?? 0.0
                        
                    } else {
                        let cell = self.productDetailTableView.cellForRow(at: IndexPath.init(row: i, section: 1)) as! productDiamondCellCertified
                        let total = cell.lblDiamondTotal.text?.replacingOccurrences(of: "₹ ", with: "").toDouble()
                        diamond += total ?? 0.0
                        
                    }
                    
                }
            }
            
            if self.stoneAsset.count > 0 {
                for i in 0 ..< self.arrFinalStone.count {
                    let cell = self.productDetailTableView.cellForRow(at: IndexPath.init(row: i, section: 3)) as! productStoneCell
                    let total = cell.lblStoneTotal.text?.replacingOccurrences(of: "₹", with: "")
                    let trimmed = total!.trimmingCharacters(in: .whitespacesAndNewlines)
                    let tot = Double(trimmed)
                    print(tot!)
                    stone += tot ?? 0.0
                    
                }
            }
            
            if self.platinumAsset.count > 0 {
                let cell = self.productDetailTableView.cellForRow(at: IndexPath.init(row: 0, section: 4)) as! productPlatinumCell
                let total = cell.lblPlatinumTotal.text?.replacingOccurrences(of: "₹ ", with: "")
                let trimmed = total!.trimmingCharacters(in: .whitespacesAndNewlines)
                let tot = Double(trimmed)
                platinum += tot ?? 0.0
                
            }
            
            if self.silverAsset.count > 0 {
                
                let cell = self.productDetailTableView.cellForRow(at: IndexPath.init(row: 0, section: 5)) as! productSilverCell
                let total = cell.lblSilverTotal.text?.replacingOccurrences(of: "₹ ", with: "")
                let trimmed = total!.trimmingCharacters(in: .whitespacesAndNewlines)
                let tot = Double(trimmed)
                silver += tot ?? 0.0
                
            }
            
            let totalCost = gold + diamond + stone + platinum + silver
          //  self.priceLbl.text = "₹ " + totalCost.rounded(toPlaces: 3).toString() + " (\(goldAsset[0].jwellerySize))"
            let netgoldy = String(format: "%.2f", totalCost)
            
            if goldAsset.count != 0 {
                
                
                if ispr == true {
                    self.priceLbl.text = "" + "(\(goldAsset[0].jwellerySize))"
                }else {
                    self.priceLbl.text = "₹ " + netgoldy + " (\(goldAsset[0].jwellerySize))"
                }
                
                
            }
            else if diamondAsset.count != 0 {
                if ispr == true {
                    self.priceLbl.text = "" + "(\(diamondAsset[0].jwellerySize))"
                }else {
                    self.priceLbl.text = "₹ " + netgoldy + " (\(diamondAsset[0].jwellerySize))"
                }
            }
            else if silverAsset.count != 0 {
                
                if ispr == true {
                    self.priceLbl.isHidden = true
                    self.priceLbl.text = "₹ " + netgoldy
                }else {
                    self.priceLbl.isHidden = false
                    self.priceLbl.text = "₹ " + netgoldy
                }
                
            }
            else if platinumAsset.count != 0 {
                if product?.data.jwelleryType == "Bangles" {
                    if ispr == true {
                        self.priceLbl.text = ""
                    }else {
                        self.priceLbl.text = "₹ " + netgoldy
                    }
                }else {
                    if ispr == true {
                        self.priceLbl.text = "" + "(\(goldAsset[0].jwellerySize))"
                    }else {
                        self.priceLbl.text = "₹ " + netgoldy + " (\(goldAsset[0].jwellerySize))"
                    }
                }
            }
            
            self.calculateWeight()
            self.removeAnimation()
            return totalCost.toString()
            
            
            
        }  else if self.prodType == "PLATINUM JEWELLERY" {
            
            if self.goldAsset.count > 0 {
                let cell = self.productDetailTableView.cellForRow(at: IndexPath.init(row: 0, section: 4)) as! GoldDetailCell
                let total = Double((cell.totalAmount.text?.replacingOccurrences(of: "₹ ", with: ""))!)
                gold = total ?? 0.0
                
                
            }
            
            if self.diamondAsset.count > 0 {
                for i in 0 ..< diamondAsset.count {
                    if self.diamondAsset[i].certificationCost == "" {
                        let cell = self.productDetailTableView.cellForRow(at: IndexPath.init(row: i, section: 2)) as! productDiamondCell
                        let total = cell.lblDiamondTotal.text?.replacingOccurrences(of: "₹ ", with: "").toDouble()
                        diamond += total ?? 0.0
                        
                    } else {
                        let cell = self.productDetailTableView.cellForRow(at: IndexPath.init(row: i, section: 2)) as! productDiamondCellCertified
                        let total = cell.lblDiamondTotal.text?.replacingOccurrences(of: "₹ ", with: "").toDouble()
                        diamond += total ?? 0.0
                        
                    }
                    
                }
            }
            
            if self.stoneAsset.count > 0 {
                for i in 0 ..< self.arrFinalStone.count {
                    let cell = self.productDetailTableView.cellForRow(at: IndexPath.init(row: i, section: 3)) as! productStoneCell
                    let total = cell.lblStoneTotal.text?.replacingOccurrences(of: "₹", with: "")
                    let trimmed = total!.trimmingCharacters(in: .whitespacesAndNewlines)
                    let tot = Double(trimmed)
                    print(tot!)
                    stone += tot ?? 0.0
                    
                }
            }
            
            if self.platinumAsset.count > 0 {
                let cell = self.productDetailTableView.cellForRow(at: IndexPath.init(row: 0, section: 1)) as! productPlatinumCell
                let total = cell.lblPlatinumTotal.text?.replacingOccurrences(of: "₹ ", with: "")
                let trimmed = total!.trimmingCharacters(in: .whitespacesAndNewlines)
                let tot = Double(trimmed)
                platinum += tot ?? 0.0
                
            }
            
            if self.silverAsset.count > 0 {
                
                let cell = self.productDetailTableView.cellForRow(at: IndexPath.init(row: 0, section: 5)) as! productSilverCell
                let total = cell.lblSilverTotal.text?.replacingOccurrences(of: "₹ ", with: "")
                let trimmed = total!.trimmingCharacters(in: .whitespacesAndNewlines)
                let tot = Double(trimmed)
                silver += tot ?? 0.0
                
            }
            
            let totalCost = gold + diamond + stone + platinum + silver
          //  self.priceLbl.text = "₹ " + totalCost.rounded(toPlaces: 3).toString() + " (\(goldAsset[0].jwellerySize))"
            let netgoldy = String(format: "%.2f", totalCost)
            
            if goldAsset.count != 0 {
                
                
                
                if ispr == true {
                    self.priceLbl.text = "" + "(\(goldAsset[0].jwellerySize))"
                }else {
                    self.priceLbl.text = "₹ " + netgoldy + " (\(goldAsset[0].jwellerySize))"
                }
                
                
            }
            else if diamondAsset.count != 0 {
                if product?.data.jwelleryType == "Bangles" {
                    if ispr == true {
                        self.priceLbl.text = ""
                    }else {
                        self.priceLbl.text = "₹ " + netgoldy
                    }
                }else {
                    if ispr == true {
                        self.priceLbl.text = "" + "(\(diamondAsset[0].jwellerySize))"
                    }else {
                        self.priceLbl.text = "₹ " + netgoldy + " (\(diamondAsset[0].jwellerySize))"
                    }
                }
            }
            else if silverAsset.count != 0 {
                
                if ispr == true {
                    self.priceLbl.isHidden = true
                    self.priceLbl.text = "₹ " + netgoldy
                }else {
                    self.priceLbl.isHidden = false
                    self.priceLbl.text = "₹ " + netgoldy
                }
                
            }
            else if platinumAsset.count != 0 {
                if product?.data.jwelleryType == "Bangles" {
                    if ispr == true {
                        self.priceLbl.text = ""
                    }else {
                        self.priceLbl.text = "₹ " + netgoldy
                    }
                }else {
                    if ispr == true {
                        self.priceLbl.text = "" + "(\(platinumAsset[0].jwellerySize))"
                    }else {
                        self.priceLbl.text = "₹ " + netgoldy + " (\(platinumAsset[0].jwellerySize))"
                    }
                }
            }
            
            self.calculateWeight()
            self.removeAnimation()
            return totalCost.toString()
            
          
          
        } else if self.prodType == "SILVER JEWELLERY" {
            
            if self.goldAsset.count > 0 {
                let cell = self.productDetailTableView.cellForRow(at: IndexPath.init(row: 0, section: 5)) as! GoldDetailCell
                let total = Double((cell.totalAmount.text?.replacingOccurrences(of: "₹ ", with: ""))!)
                gold = total ?? 0.0
                
                
            }
            
            if self.diamondAsset.count > 0 {
                for i in 0 ..< diamondAsset.count {
                    if self.diamondAsset[i].certificationCost == "" {
                        let cell = self.productDetailTableView.cellForRow(at: IndexPath.init(row: i, section: 2)) as! productDiamondCell
                        let total = cell.lblDiamondTotal.text?.replacingOccurrences(of: "₹ ", with: "").toDouble()
                        diamond += total ?? 0.0
                        
                    } else {
                        let cell = self.productDetailTableView.cellForRow(at: IndexPath.init(row: i, section: 2)) as! productDiamondCellCertified
                        let total = cell.lblDiamondTotal.text?.replacingOccurrences(of: "₹ ", with: "").toDouble()
                        diamond += total ?? 0.0
                        
                    }
                    
                }
            }
            
            if self.stoneAsset.count > 0 {
                for i in 0 ..< self.arrFinalStone.count {
                    let cell = self.productDetailTableView.cellForRow(at: IndexPath.init(row: i, section: 3)) as! productStoneCell
                    let total = cell.lblStoneTotal.text?.replacingOccurrences(of: "₹", with: "")
                    let trimmed = total!.trimmingCharacters(in: .whitespacesAndNewlines)
                    let tot = Double(trimmed)
                    print(tot!)
                    stone += tot ?? 0.0
                    
                }
            }
            
            if self.platinumAsset.count > 0 {
                let cell = self.productDetailTableView.cellForRow(at: IndexPath.init(row: 0, section: 4)) as! productPlatinumCell
                let total = cell.lblPlatinumTotal.text?.replacingOccurrences(of: "₹ ", with: "")
                let trimmed = total!.trimmingCharacters(in: .whitespacesAndNewlines)
                let tot = Double(trimmed)
                platinum += tot ?? 0.0
                
            }
            
            if self.silverAsset.count > 0 {
                
                let cell = self.productDetailTableView.cellForRow(at: IndexPath.init(row: 0, section: 1)) as! productSilverCell
                let total = cell.lblSilverTotal.text?.replacingOccurrences(of: "₹ ", with: "")
                let trimmed = total!.trimmingCharacters(in: .whitespacesAndNewlines)
                let tot = Double(trimmed)
                silver += tot ?? 0.0
                
            }
            
            let totalCost = gold + diamond + stone + platinum + silver
          //  self.priceLbl.text = "₹ " + totalCost.rounded(toPlaces: 3).toString() + " (\(goldAsset[0].jwellerySize))"
            let netgoldy = String(format: "%.2f", totalCost)
            
            if goldAsset.count != 0 {
                
                
                if ispr == true {
                    self.priceLbl.text = "" + "(\(goldAsset[0].jwellerySize))"
                }else {
                    self.priceLbl.text = "₹ " + netgoldy + " (\(goldAsset[0].jwellerySize))"
                }
                
                
            }
            else if diamondAsset.count != 0 {
                if ispr == true {
                    self.priceLbl.text = "" + "(\(diamondAsset[0].jwellerySize))"
                }else {
                    self.priceLbl.text = "₹ " + netgoldy + " (\(diamondAsset[0].jwellerySize))"
                }
            }
            else if silverAsset.count != 0 {
                
                if ispr == true {
                    self.priceLbl.isHidden = true
                    self.priceLbl.text = "₹ " + netgoldy
                }else {
                    self.priceLbl.isHidden = false
                    self.priceLbl.text = "₹ " + netgoldy
                }
                
            }
            else if platinumAsset.count != 0 {
                if product?.data.jwelleryType == "Bangles" {
                    if ispr == true {
                        self.priceLbl.text = ""
                    }else {
                        self.priceLbl.text = "₹ " + netgoldy
                    }
                }else {
                    if ispr == true {
                        self.priceLbl.text = "" + "(\(goldAsset[0].jwellerySize))"
                    }else {
                        self.priceLbl.text = "₹ " + netgoldy + " (\(goldAsset[0].jwellerySize))"
                    }
                }
            }
            
            self.calculateWeight()
            self.removeAnimation()
            return totalCost.toString()
            
          
          
        }else {
            
            if self.goldAsset.count > 0 {
                let cell = self.productDetailTableView.cellForRow(at: IndexPath.init(row: 0, section: 1)) as! GoldDetailCell
                let total = Double((cell.totalAmount.text?.replacingOccurrences(of: "₹ ", with: ""))!)
                gold = total ?? 0.0
                
                
            }
            
            if self.diamondAsset.count > 0 {
                for i in 0 ..< diamondAsset.count {
                    if self.diamondAsset[i].certificationCost == "" {
                        let cell = self.productDetailTableView.cellForRow(at: IndexPath.init(row: i, section: 2)) as! productDiamondCell
                        let total = cell.lblDiamondTotal.text?.replacingOccurrences(of: "₹ ", with: "").toDouble()
                        diamond += total ?? 0.0
                        
                    } else {
                        let cell = self.productDetailTableView.cellForRow(at: IndexPath.init(row: i, section: 2)) as! productDiamondCellCertified
                        let total = cell.lblDiamondTotal.text?.replacingOccurrences(of: "₹ ", with: "").toDouble()
                        diamond += total ?? 0.0
                        
                    }
                    
                }
            }
            
            if self.stoneAsset.count > 0 {
                for i in 0 ..< self.arrFinalStone.count {
                    let cell = self.productDetailTableView.cellForRow(at: IndexPath.init(row: i, section: 3)) as! productStoneCell
                    let total = cell.lblStoneTotal.text?.replacingOccurrences(of: "₹", with: "")
                    let trimmed = total!.trimmingCharacters(in: .whitespacesAndNewlines)
                    let tot = Double(trimmed)
                    print(tot!)
                    stone += tot ?? 0.0
                    
                }
            }
            
            if self.platinumAsset.count > 0 {
                let cell = self.productDetailTableView.cellForRow(at: IndexPath.init(row: 0, section: 4)) as! productPlatinumCell
                let total = cell.lblPlatinumTotal.text?.replacingOccurrences(of: "₹ ", with: "")
                let trimmed = total!.trimmingCharacters(in: .whitespacesAndNewlines)
                let tot = Double(trimmed)
                platinum += tot ?? 0.0
                
            }
            
            if self.silverAsset.count > 0 {
                
                let cell = self.productDetailTableView.cellForRow(at: IndexPath.init(row: 0, section: 5)) as! productSilverCell
                let total = cell.lblSilverTotal.text?.replacingOccurrences(of: "₹ ", with: "")
                let trimmed = total!.trimmingCharacters(in: .whitespacesAndNewlines)
                let tot = Double(trimmed)
                silver += tot ?? 0.0
                
            }
            
            let totalCost = gold + diamond + stone + platinum + silver
          //  self.priceLbl.text = "₹ " + totalCost.rounded(toPlaces: 3).toString() + " (\(goldAsset[0].jwellerySize))"
            let netgoldy = String(format: "%.2f", totalCost)
            
            if goldAsset.count != 0 {
                
                
                if ispr == true {
                    self.priceLbl.text = "" + "(\(goldAsset[0].jwellerySize))"
                }else {
                    self.priceLbl.text = "₹ " + netgoldy + " (\(goldAsset[0].jwellerySize))"
                }
                
                
            }
            else if diamondAsset.count != 0 {
                if ispr == true {
                    self.priceLbl.text = "" + "(\(diamondAsset[0].jwellerySize))"
                }else {
                    self.priceLbl.text = "₹ " + netgoldy + " (\(diamondAsset[0].jwellerySize))"
                }
            }
            else if silverAsset.count != 0 {
                
                if ispr == true {
                    self.priceLbl.isHidden = true
                    self.priceLbl.text = "₹ " + netgoldy
                }else {
                    self.priceLbl.isHidden = false
                    self.priceLbl.text = "₹ " + netgoldy
                }
                
            }
            else if platinumAsset.count != 0 {
                if product?.data.jwelleryType == "Bangles" {
                    if ispr == true {
                        self.priceLbl.text = ""
                    }else {
                        self.priceLbl.text = "₹ " + netgoldy
                    }
                }else {
                    if ispr == true {
                        self.priceLbl.text = "" + "(\(goldAsset[0].jwellerySize))"
                    }else {
                        self.priceLbl.text = "₹ " + netgoldy + " (\(goldAsset[0].jwellerySize))"
                    }
                }
            }
            
            self.calculateWeight()
            self.removeAnimation()
            return totalCost.toString()
            
          
          
        }
        
      
        
       
    }
    
    @objc func goldSelect(_ sender:UIButton) {
        
//       // let cell = self.productDetailTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! GoldDetailCell
//        let btnTitle = sender.titleLabel?.text!
//        let type = goldAsset[0].jwellerySize
//        var ass = 0
//        if type == btnTitle {
//            ass = 0
//        }else {
//            ass = 1
//
//        }
//        let tempwieght = self.originalDefaultWeight
//
//        let defaultSize = self.product?.data.defaultSize.toInt()
//
//        var calc2 = 1.0
//        //if self.defaultSizeBangle != self.selectedBangleSize {
//
//            let calc1 =
//                self.selectedsizeindex - defaultSize!
//
//
//                                    if calc1 >= 0 {
//                                        for i in 0..<calc1 {
//                                            calc2 += Double(calc2)*0.05
//                                        }
//                                    }else if calc1 < 0 {
//                                        let c = removeSpecialCharsFromString(text: "\(calc1)")
//                                        let cal = Int(c)
//                                        for i in 0..<cal! {
//                                            calc2 -= Double(calc2)*0.05
//                                        }
//                                    }
      //  }
      //  let cell = self.productDetailTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! GoldDetailCell
        
        
//            if self.goldAsset.count > 0 {
//
//                for i in 0 ..< self.goldAsset.count {
//                    if self.goldAsset[i].jwellerySize == btnTitle {
//                        self.selectedIndGold = i
//                      //  self.goldAsset[i].metrialType = btnTitle!
//
//                       // let asssets = self.productCode.text!.replacingOccurrences(of: "Gross weight : ", with: "")
//                      //  self.goldAsset[i].weight = asssets
//                   //     self.originalWeight = asssets
//                        self.selectedgoldtype = btnTitle!
//                        self.goldAsset[i].jwellerySize = btnTitle!
//
//
//
//                        if self.originalWeight != "" {
//
//                            if self.issizechanged == "1" {
//                                if ass != 0 {
//                                    let finalWeight = calc2 * self.goldAsset[i].weight.toDouble()
//                            //        self.goldAsset[i].weight = finalWeight.toString()
//                                    self.priceLbl.text = self.calculateTotalPrice()
//                                    self.selectedIndGold = i
//                                    self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 1),IndexPath.init(row: 0, section: 9)], with: .automatic)
//
//                                  //  self.originalWeight = finalWeight.t
//                                }else {
//                                    let finalWeight = self.goldAsset[i].weight
//                              //      self.goldAsset[i].weight = finalWeight
//                                    self.priceLbl.text = self.calculateTotalPrice()
//                                    self.selectedIndGold = i
//                                    self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 1),IndexPath.init(row: 0, section: 9)], with: .automatic)
//
//                                    self.originalWeight = finalWeight
//                                }
//                            }else {
//                                let finalWeight = self.goldAsset[i].weight
//                             //   self.goldAsset[i].weight = finalWeight
//                                self.priceLbl.text = self.calculateTotalPrice()
//                                self.selectedIndGold = i
//
//                                self.productDetailTableView.reloadRows(at: [IndexPath.init(row: 0, section: 1),IndexPath.init(row: 0, section: 9)], with: .automatic)
//
//                                self.originalWeight = finalWeight
//                            }
//
//
//
//
//                        }
//
//                      //  self.productDetailTableView.reloadRows(at: [IndexPath(row: 0, section: 1),IndexPath.init(row: 0, section: 9)], with: .automatic)
//                    }
//                }
//            }
        if self.prodType == "GOLD JEWELLERY" || self.prodType == "GOLD CHAINS"{
            if self.goldAsset.count > 0 {
                let btnTitle = sender.titleLabel?.text!
                for i in 0 ..< self.goldAsset.count {
                    if self.goldAsset[i].jwellerySize == btnTitle {
                        self.selectedIndGold = i
                        self.productDetailTableView.reloadRows(at: [IndexPath(row: 0, section: 1),IndexPath.init(row: 0, section: 9)], with: .automatic)
                    }
                }
            }
                 
               } else if self.prodType == "DIAMOND JEWELLERY" {
                
                if self.goldAsset.count > 0 {
                    let btnTitle = sender.titleLabel?.text!
                    for i in 0 ..< self.goldAsset.count {
                        if self.goldAsset[i].jwellerySize == btnTitle {
                            self.selectedIndGold = i
                          //  self.goldAsset[i].metrialType = btnTitle!
                            self.selectedgoldtype = btnTitle!
                         //   self.goldAsset[i].jwellerySize = btnTitle!
                            self.productDetailTableView.reloadRows(at: [IndexPath(row: 0, section: 2),IndexPath.init(row: 0, section: 9)], with: .automatic)
                        }
                    }
                }
                 
               }  else if self.prodType == "PLATINUM JEWELLERY" {
                
                if self.goldAsset.count > 0 {
                    let btnTitle = sender.titleLabel?.text!
                    for i in 0 ..< self.goldAsset.count {
                        if self.goldAsset[i].jwellerySize == btnTitle {
                            self.selectedIndGold = i
                          //  self.goldAsset[i].metrialType = btnTitle!
                            self.selectedgoldtype = btnTitle!
                          //  self.goldAsset[i].jwellerySize = btnTitle!
                            self.productDetailTableView.reloadRows(at: [IndexPath(row: 0, section: 4),IndexPath.init(row: 0, section: 9)], with: .automatic)
                        }
                    }
                }
                   
                   
                 
               } else if self.prodType == "SILVER JEWELLERY" {
                if self.silverAsset.count > 0 {
                    let btnTitle = sender.titleLabel?.text!
                    for i in 0 ..< self.silverAsset.count {
                        if self.silverAsset[i].jwellerySize == btnTitle {
                            self.selectedIndSilver = i
                          //  self.goldAsset[i].metrialType = btnTitle!
                            self.selectedsilvertype = btnTitle!
                          //  self.goldAsset[i].jwellerySize = btnTitle!
                            self.productDetailTableView.reloadRows(at: [IndexPath(row: 0, section: 1),IndexPath.init(row: 0, section: 9)], with: .automatic)
                        }
                    }
                }
                  
               }else {
                if self.goldAsset.count > 0 {
                    let btnTitle = sender.titleLabel?.text!
                    for i in 0 ..< self.goldAsset.count {
                        if self.goldAsset[i].jwellerySize == btnTitle {
                            self.selectedIndGold = i
                          //  self.goldAsset[i].metrialType = btnTitle!
                            self.selectedgoldtype = btnTitle!
                           // self.goldAsset[i].jwellerySize = btnTitle!
                            self.productDetailTableView.reloadRows(at: [IndexPath(row: 0, section: 1),IndexPath.init(row: 0, section: 9)], with: .automatic)
                        }
                    }
                }
                  
                 
               }
        
        
        
        
        
    }
    
    @objc func diamondColoBtn(_ sender:UIButton) {
        let llmain = sender.titleLabel!.text!
        
        var isChagne = 0
        
        let position = sender.convert(CGPoint.zero, to: productDetailTableView)
        let indexpath = productDetailTableView.indexPathForRow(at: position)
        
     //   let cell = productDetailTableView.cellForRow(at: indexpath!) as! productDiamondCell
        
        
        
        var isSame = false
        
        
        let diamondColor = self.diamondAsset[indexpath!.row].clarity.components(separatedBy: ",")
        let diaty = self.diamondAsset[indexpath!.row].jwellerySize
        
        
        
        for obj in 0..<self.newcolorarray.count {
            if diaty == (self.newcolorarray[obj] as! NSDictionary).value(forKey: "name") as! String
            {
                let value = (self.newcolorarray[obj] as! NSDictionary).value(forKey: "value") as! [[String:Any]]
                
                for i in 0..<value.count {
                    let title = value[i]["name"] as! String
                    if title == llmain {
                        if value[i]["value"] as! String == "1" {
                            isSame = true
                            break
                        }
                        
                    }
                }
            }
        }
        
        for obj in 0..<diamondColor.count {
            
            //let value = (diamondColor[obj] as AnyObject).value(forKey: "value") as! String
            //if value == "1" {
                let sname = (diamondColor[obj])
            let main = "\(llmain)/\(sname)"
            
            for i in 0..<(self.product?.price.diamondMaster.count)! {
                let name = self.product?.price.diamondMaster[i].diamond_type
               
                if name == diaty {
                    let type = self.product?.price.diamondMaster[i].type
                    
                    if type == main {
                        print("Go")
                        isChagne = 1
                        break
                        
                    }else{
                        isChagne = 0
                        print("not")
                        
                    }
                }
    
            //}
            
        }
        
        
    }
       
      //  let master = self.product?.price.diamondMaster
        
        
        
        print(isChagne)
        
        
        if isSame == false {
            if isChagne == 1 {
                self.diamondColorTemp = llmain
                self.diamondAsset[sender.tag].defaultColorClarity = "\(self.diamondColorTemp)/\(self.diamondClarityTemp)"
                if self.prodType == "GOLD JEWELLERY" {
                    
                    self.productDetailTableView.reloadRows(at: [IndexPath(row: sender.tag, section: 2),IndexPath.init(row: 0, section: 9)], with: .automatic)
                    
            
                } else if self.prodType == "DIAMOND JEWELLERY" {
                    self.productDetailTableView.reloadRows(at: [IndexPath(row: sender.tag, section: 1),IndexPath.init(row: 0, section: 9)], with: .automatic)
                    
                    
                }  else if self.prodType == "PLATINUM JEWELLERY" {
                    
                    self.productDetailTableView.reloadRows(at: [IndexPath(row: sender.tag, section: 2),IndexPath.init(row: 0, section: 9)], with: .automatic)
                 
                } else if self.prodType == "SILVER JEWELLERY" {
                 
                    self.productDetailTableView.reloadRows(at: [IndexPath(row: sender.tag, section: 2),IndexPath.init(row: 0, section: 9)], with: .automatic)
                }else {
                    self.productDetailTableView.reloadRows(at: [IndexPath(row: sender.tag, section: 2),IndexPath.init(row: 0, section: 9)], with: .automatic)
                }
            }else {
                self.view.makeToast("Combination not available")
            }
        }
        
        
        
       
    }
    @objc func diamondClarityBtn(_ sender:UIButton) {
        let llmain =  sender.titleLabel!.text!
        
        var isSame = false
        
        
        
        let position = sender.convert(CGPoint.zero, to: productDetailTableView)
        let indexpath = productDetailTableView.indexPathForRow(at: position)
       
        
        let diamondColor = self.diamondAsset[indexpath!.row].color.components(separatedBy: ",")
        let diaty = self.diamondAsset[indexpath!.row].jwellerySize
        
        
        for obj in 0..<self.newClarityarray.count {
            if diaty == (self.newClarityarray[obj] as! NSDictionary).value(forKey: "name") as! String
            {
                let value = (self.newClarityarray[obj] as! NSDictionary).value(forKey: "value") as! [[String:Any]]
                
                for i in 0..<value.count {
                    let title = value[i]["name"] as! String
                    if title == llmain {
                        if value[i]["value"] as! String == "1" {
                            isSame = true
                            break
                        }
                        
                    }
                }
            }
        }
        
        
    
        var isChagne = 0
        for obj in 0..<diamondColor.count {
            
//            let value = (diamondColor[obj] as AnyObject).value(forKey: "value") as! String
//            if value == "1" {
                let sname = (diamondColor[obj])
            let main = "\(sname)/\(llmain)"
            
            for i in 0..<(self.product?.price.diamondMaster.count)! {
                let name = self.product?.price.diamondMaster[i].diamond_type
                
                if name == diaty {
                    let type = self.product?.price.diamondMaster[i].type
                    if type == main {
                        print("Go")
                        isChagne = 1
                        break
                        
                    }else{
                        isChagne = 0
                        print("not")
                        
                    }
                }
    
           // }
            
        }
        
        
    }
        
        if isSame == false {
            
        
        if isChagne == 1 {
            self.diamondClarityTemp = llmain
            self.diamondAsset[sender.tag].defaultColorClarity = "\(self.diamondColorTemp)/\(self.diamondClarityTemp)"
            if self.prodType == "GOLD JEWELLERY" {
                
                self.productDetailTableView.reloadRows(at: [IndexPath(row: sender.tag, section: 2),IndexPath.init(row: 0, section: 9)], with: .automatic)
                
        
            } else if self.prodType == "DIAMOND JEWELLERY" {
                self.productDetailTableView.reloadRows(at: [IndexPath(row: sender.tag, section: 1),IndexPath.init(row: 0, section: 9)], with: .automatic)
                
                
            }  else if self.prodType == "PLATINUM JEWELLERY" {
                
                self.productDetailTableView.reloadRows(at: [IndexPath(row: sender.tag, section: 2),IndexPath.init(row: 0, section: 9)], with: .automatic)
             
            } else if self.prodType == "SILVER JEWELLERY" {
             
                self.productDetailTableView.reloadRows(at: [IndexPath(row: sender.tag, section: 2),IndexPath.init(row: 0, section: 9)], with: .automatic)
            }else {
                self.productDetailTableView.reloadRows(at: [IndexPath(row: sender.tag, section: 2),IndexPath.init(row: 0, section: 9)], with: .automatic)
            }
        }else {
            self.view.makeToast("Combination not available")
        }
        }
    }
}

//MARK:- UITableView Delegate
extension ProductDetials2: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.prodType == "GOLD JEWELLERY" {
            
            if section == 0 {
                if self.product?.data.jwelleryType == "PENDANT SET" {
                    return 1
                }else if self.product?.data.jwelleryType == "Chain" {
                    return 4
                }
                return 3
            } else if section == 1 {
                if goldAsset.count == 0 {
                    return goldAsset.count
                }
                return 1
            } else if section == 2 {
                return self.diamondAsset.count
            } else if section == 3 {
                return self.arrFinalStone.count
            } else if section == 4 {
                return self.platinumAsset.count
            } else if section == 5 {
                if silverAsset.count > 0 {
                    return 1
                }
                return silverAsset.count
            } else if section == 6 {
                return 1
            } else if section == 7 {
                return 1
            } else if section == 8 {
                return 1
            } else if section == 9 {
                return 1
            }
            return 1
          
        } else if self.prodType == "DIAMOND JEWELLERY" {
            
            if section == 0 {
                if self.product?.data.jwelleryType == "PENDANT SET" {
                    return 1
                }else if self.product?.data.jwelleryType == "Chain" {
                    return 4
                }
                return 3
            } else if section == 1 {
                
                return self.diamondAsset.count
                
            } else if section == 2 {
                
                if goldAsset.count == 0 {
                    return goldAsset.count
                }
                return 1
               
            } else if section == 3 {
                return self.arrFinalStone.count
            } else if section == 4 {
                return self.platinumAsset.count
            } else if section == 5 {
                if silverAsset.count > 0 {
                    return 1
                }
                return silverAsset.count
            } else if section == 6 {
                return 1
            } else if section == 7 {
                return 1
            } else if section == 8 {
                return 1
            } else if section == 9 {
                return 1
            }
            return 1
      
            
        }  else if self.prodType == "PLATINUM JEWELLERY" {
            
            if section == 0 {
                if self.product?.data.jwelleryType == "PENDANT SET" {
                    return 1
                }else if self.product?.data.jwelleryType == "Chain" {
                    return 4
                }
                return 3
            } else if section == 1 {
                return self.platinumAsset.count
               
                
            } else if section == 2 {
                
                return self.diamondAsset.count
               
            } else if section == 3 {
                return self.arrFinalStone.count
            } else if section == 4 {
                if goldAsset.count == 0 {
                    return goldAsset.count
                }
                return 1
                
            } else if section == 5 {
                if silverAsset.count > 0 {
                    return 1
                }
                return silverAsset.count
            } else if section == 6 {
                return 1
            } else if section == 7 {
                return 1
            } else if section == 8 {
                return 1
            } else if section == 9 {
                return 1
            }
            return 1
         
        } else if self.prodType == "SILVER JEWELLERY" {
         
            if section == 0 {
                if self.product?.data.jwelleryType == "PENDANT SET" {
                    return 1
                }else if self.product?.data.jwelleryType == "Chain" {
                    return 4
                }
                return 3
            } else if section == 1 {
                if silverAsset.count > 0 {
                    return 1
                }
                return silverAsset.count
            } else if section == 2 {
                return self.diamondAsset.count
            } else if section == 3 {
                return self.arrFinalStone.count
            } else if section == 4 {
                return self.platinumAsset.count
            } else if section == 5 {
                if goldAsset.count == 0 {
                    return goldAsset.count
                }
                return 1
              
            } else if section == 6 {
                return 1
            } else if section == 7 {
                return 1
            } else if section == 8 {
                return 1
            } else if section == 9 {
                return 1
            }
            return 1
        }else {
            if section == 0 {
                if self.product?.data.jwelleryType == "PENDANT SET" {
                    return 1
                }else if self.product?.data.jwelleryType == "Chain" {
                    return 4
                }
                return 3
            } else if section == 1 {
                if goldAsset.count == 0 {
                    return goldAsset.count
                }
                return 1
            } else if section == 2 {
                return self.diamondAsset.count
            } else if section == 3 {
                return self.arrFinalStone.count
            } else if section == 4 {
                return self.platinumAsset.count
            } else if section == 5 {
                if silverAsset.count > 0 {
                    return 1
                }
                return silverAsset.count
            } else if section == 6 {
                return 1
            } else if section == 7 {
                return 1
            } else if section == 8 {
                return 1
            } else if section == 9 {
                return 1
            }
            return 1
        }
        
       
        
       
    }
    @objc func plusBtn(_ sender:UIButton){
        
        
        let position = sender.convert(CGPoint.zero, to: productDetailTableView)
        let indexpath = productDetailTableView.indexPathForRow(at: position)
        
      
        
        
        qty = qty+1
        
      
        productDetailTableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .automatic)
        
    }
    @objc func minusBtn(_ sender:UIButton){
        
        
        let position = sender.convert(CGPoint.zero, to: productDetailTableView)
        let indexpath = productDetailTableView.indexPathForRow(at: position)
        
    
        
        if qty > 1 {
            qty = qty-1
        }
    
        productDetailTableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .automatic)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if self.prodType == "GOLD JEWELLERY" {
            if indexPath.section == 0 {
                if indexPath.row == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "colorCell") as! productColorCell
                    cell.roseBtn.isHidden = true
                    cell.goldBtn.isHidden = true
                    cell.whiteBtn.isHidden = true
                    if self.product?.data.color.contains("Yellow") ?? false {
                        cell.goldBtn.isHidden = false
                        self.mycolor = "Yellow"
                    }
                    if self.product?.data.color.contains("Rose") ?? false {
                        cell.roseBtn.isHidden = false
                        self.mycolor = "Rose"
                    }
                    if self.product?.data.color.contains("White") ?? false {
                        cell.whiteBtn.isHidden = false
                        self.mycolor = "White"
                    }
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
                                        
                    return cell
                }
                
                
                else if indexPath.row == 1 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "sizecell") as! productSizeCell
                    
                    if self.product?.data.jwelleryType.lowercased() == "bangles" {
                        cell.lblTitle.text = "Select Size"
                        let defaultSize = self.product?.data.defaultSize
                        var size = 0
                        for i in self.product!.price.bangle {
                            size += 1
                            
                            if i.sizes == defaultSize {
                                cell.btnSize.setTitle(i.bangleSize, for: .normal)
                                self.productSize = i.bangleSize
                                self.defaultSize = i.bangleSize
                                self.defaultSizeBangle = i.bangleSize
                                self.selectedBangleSize = i.bangleSize
                                
                                self.selectedsizeindex = size
                            }
                        }
                        cell.btnSize.layer.borderColor = UIColor.lightGray.cgColor
                        cell.btnSize.layer.borderWidth = 0.6
                        cell.btnSize.addTarget(self, action: #selector(selectSizeBangle(_:)), for: .touchUpInside)
                    } else if self.product?.data.jwelleryType == "Ring" {
                        cell.lblTitle.text = "Select Size"
                        cell.btnSize.setTitle(self.product?.data.defaultSize, for: .normal)
                        self.productSize = (self.product?.data.defaultSize)!
                        cell.btnSize.addTarget(self, action: #selector(selectSizeRing(_:)), for: .touchUpInside)
                    } else if self.product?.data.jwelleryType == "Chain" {
                        cell.lblTitle.text = "Select Length"
                        
                        cell.btnSize.setTitle(self.product?.data.defaultSize, for: .normal)
                        self.productSize = (self.product?.data.defaultSize)!
                        cell.btnSize.addTarget(self, action: #selector(selectSizeRing(_:)), for: .touchUpInside)
                        
                    }else {
                       
                        cell.isHidden = true
                    }
                    
                   
                    return cell
                }
                else if indexPath.row == 2 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "codecell") as! codecell
                    
                    cell.lblCode.text = self.product?.data.productcode
                    return cell
                }
                else if indexPath.row == 3 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "quantityCell") as! quantityCell
                    
                    cell.qtyLbl.text = "\(qty)"
                    cell.plusBtn.addTarget(self, action: #selector(plusBtn), for: .touchUpInside)
                    cell.minusBtn.addTarget(self, action: #selector(minusBtn), for: .touchUpInside)
                    
                    return cell
                }
            } else if indexPath.section == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "goldCell") as! GoldDetailCell
                cell.k12Btn.isHidden = true
                cell.k18Btn.isHidden = true
                cell.k8Btn.isHidden = true
                cell.k16Btn.isHidden = true
                let btnArr = [cell.k8Btn,cell.k12Btn,cell.k16Btn,cell.k18Btn]
                
                for i in 0 ..< self.goldAsset.count {
                    
                    btnArr[i]?.isHidden = false
                    btnArr[i]?.setTitle(self.goldAsset[i].jwellerySize, for: .normal)
                    btnArr[i]?.addTarget(self, action: #selector(goldSelect(_:)), for: .touchUpInside)
                    btnArr[i]?.backgroundColor = UIColor.white
                    btnArr[i]?.setTitleColor(.black, for: .normal)
                }
                if self.goldAsset.count > 0 {
                    for i in btnArr {
                        if i?.titleLabel?.text == self.goldAsset[self.selectedIndGold].jwellerySize {
                            i?.backgroundColor = UIColor.init(named: "base_color")
                            i?.setTitleColor(.white, for: .normal)
                            self.selectedgoldtype = (i?.titleLabel?.text)!
                            //self.defualttype = (0.titleLabel?.text)!
                        }
                    }
                }
                
                cell.k12Btn.layer.borderColor = UIColor.black.cgColor
                cell.k12Btn.layer.borderWidth = 1
                cell.k12Btn.layer.cornerRadius = cell.k12Btn.frame.height / 2
                cell.k12Btn.clipsToBounds = true
                    
                cell.k18Btn.layer.borderColor = UIColor.black.cgColor
                cell.k18Btn.layer.borderWidth = 1
                cell.k18Btn.layer.cornerRadius = cell.k18Btn.frame.height / 2
                cell.k18Btn.clipsToBounds = true
                    
                cell.k8Btn.layer.borderColor = UIColor.black.cgColor
                cell.k8Btn.layer.borderWidth = 1
                cell.k8Btn.layer.cornerRadius = cell.k8Btn.frame.height / 2
                cell.k8Btn.clipsToBounds = true
                    
                cell.k16Btn.layer.borderColor = UIColor.black.cgColor
                cell.k16Btn.layer.borderWidth = 1
                cell.k16Btn.layer.cornerRadius = cell.k16Btn.frame.height / 2
                cell.k16Btn.clipsToBounds = true
                
                
                cell.producCodeLbl.text = self.product?.data.productcode
                
                //MARK:- Value In Calc
                var valueIn = ""
                
                print(self.goldAsset.count)
                if self.goldAsset.count > 0 {
                    let goldType = self.goldAsset[self.selectedIndGold].jwellerySize
                    for i in self.product!.price.gold {
                        if goldType == i.type {
                            print(i.valueIn)
                            let type = String(format: "%.2f", i.valueIn.toDouble())
                            cell.goldPurityLbl.text = type + "%"
                            valueIn = i.valueIn
                        }
                    }
                }
                    
                
                
               
                
                //MARK:- Net Gold Weight
                let netgold = Double(self.goldAsset[self.selectedIndGold].weight)
                
                let netgoldy = String(format: "%.3f", netgold!)
                cell.netGoldWeightLbl.text = netgoldy + " g"
                
                if ispr == true {
                    
                    cell.viewNetGoldWeight.isHidden = true
                }else {
                    cell.viewNetGoldWeight.isHidden = false
                }
                
                //MARK:- Gold Making Charge
                
                let Making = Double(self.goldAsset[self.selectedIndGold].makingCharge)
                
                if Making != 0 {
                    cell.viewMakingCharge.isHidden = false
                     cell.viewTotalMakingCharge.isHidden = false
                    let Makingy = String(format: "%.1f", Making!)
                    cell.goldMakingChargeLbl.text = "₹ " + Makingy + "/ g"
                    
                    if ispr == true {
                        
                        cell.viewMakingCharge.isHidden = true
                    }else {
                        cell.viewMakingCharge.isHidden = false
                    }
                    
                }else {
                    cell.viewTotalMakingCharge.isHidden = true
                    cell.viewMakingCharge.isHidden = true
                }
                
                var  wastage = Double(self.goldAsset[self.selectedIndGold].wastage)
                if wastage == nil {
                    wastage = 0
                }
                if wastage != 0 {
                    cell.viewGoldWastage.isHidden = false
                    let wastagey = String(format: "%.1f", wastage!)
                    cell.lblWastage.text = wastagey + " %"
                    
                    if ispr == true {
                        
                        cell.viewGoldWastage.isHidden = true
                    }else {
                        cell.viewGoldWastage.isHidden = false
                    }
                    
                }else {
                    cell.viewGoldWastage.isHidden = true
                }
                
                let value = valueIn.toDouble()
                let mainweight = netgoldy.toDouble()
                var was = wastage
                
                if self.goldAsset[self.selectedIndGold].chargesOption == "Percentage" {
                    was = self.goldAsset[self.selectedIndGold].makingCharge.toDouble()
                    cell.goldMakingChargeLbl.text = "\(was!)" + "%"
                    
                }
                
                
                
                let fineWeight = mainweight * (value+was!) / 100
                //MARK:- Fine Gold Weight
            //    let purity = fineWeight.toDouble() / 100
                let finew = String(format: "%.3f", fineWeight)
                cell.fineGoldWeightlbl.text = finew + " g"
                
                //MARK:- Fine Gold Rate
                var goldRate = 0.0
                var mainrate = 0.0
                for i in self.product!.price.gold {
                    print(i.price)
                    if i.type == "24KT" {
                        print(i.price)
                        let rate = String(format: "%.2f", i.price.toDouble())
                        cell.fineGoldRateLbl.text = "₹ " + rate + " / g"
                        mainrate = rate.toDouble()
                        goldRate = i.price.toDouble()
                    }
                }
                
                //MARK:- Meena Cost
                var finalMeenaCost = 0.0
                if self.goldAsset[self.selectedIndGold].meenacostOption == "PerGram" {
                    let meenaCost = PriceCalculation.shared.MeenaCost(meenaRate: self.goldAsset[self.selectedIndGold].meenaCost.toDouble(), weight: self.goldAsset[self.selectedIndGold].weight.toDouble(), isPergram: true)
                    finalMeenaCost = meenaCost
                } else if self.goldAsset[self.selectedIndGold].meenacostOption == "Fixed" {
                    let meenaCost = PriceCalculation.shared.MeenaCost(meenaRate: self.goldAsset[self.selectedIndGold].meenaCost.toDouble(), weight: self.goldAsset[self.selectedIndGold].weight.toDouble(), isPergram: false)
                    finalMeenaCost = meenaCost
                }
                
                //MARK:- MakingCharges
                var makingCharge = 0.0
                if self.goldAsset[self.selectedIndGold].chargesOption == "PerGram" {
                   makingCharge = PriceCalculation.shared.goldMakingCharge(goldWeight: self.goldAsset[self.selectedIndGold].weight.toDouble(), makingTypeFixed: false, makingChargeRate: self.goldAsset[self.selectedIndGold].makingCharge.toDouble())
                    cell.viewTotalMakingCharge.isHidden = false
                } else if self.goldAsset[self.selectedIndGold].chargesOption == "Fixed" {
                    makingCharge = PriceCalculation.shared.goldMakingCharge(goldWeight: self.goldAsset[self.selectedIndGold].weight.toDouble(), makingTypeFixed: true, makingChargeRate: self.goldAsset[self.selectedIndGold].makingCharge.toDouble())
                    cell.viewTotalMakingCharge.isHidden = false
                }else {
                    
                    let value = valueIn.toDouble()
                    let mainweight = netgoldy.toDouble()
                    let was = self.goldAsset[self.selectedIndGold].makingCharge.toDouble()
                    makingCharge = mainweight * (value+was) / 100
                    cell.viewTotalMakingCharge.isHidden = true
                    cell.lblMakingTitle.text = "Gold wastage"
                    
                }
                
                //MARK:- Total Making Charge
                let totalMakingCharge = self.goldAsset[self.selectedIndGold].makingCharge.toDouble() * self.goldAsset[self.selectedIndGold].weight.toDouble()
                let maintotalMakingCharge = String(format: "%.2f", totalMakingCharge)
                
                cell.totalMakingChargelbl.text = "₹ " + maintotalMakingCharge
                
                if totalMakingCharge == 0 {
                    cell.viewTotalMakingCharge.isHidden = true
                }
                
                //MARK:- Total Amount
                var totalmain = Double()
                
                if self.goldAsset[self.selectedIndGold].chargesOption == "Percentage" {
                    totalmain = (PriceCalculation.shared.goldPrice(goldRate: mainrate, goldweight: netgoldy.toDouble(), goldPurity: valueIn.toDouble(), goldWastage: was!) + finalMeenaCost)
                }else {
                    totalmain = (PriceCalculation.shared.goldPrice(goldRate: mainrate, goldweight: netgoldy.toDouble(), goldPurity: valueIn.toDouble(), goldWastage: was!) + finalMeenaCost + makingCharge)
                }

                
                
                 
                let stotalmain = String(format: "%.3f", totalmain)
                
                let numberFormatter = NumberFormatter()
                numberFormatter.minimumFractionDigits = 2
                numberFormatter.maximumFractionDigits = 2
                numberFormatter.roundingMode = .down
                let str = numberFormatter.string(from: NSNumber(value: totalmain))
               // let str2 = numberFormatter.string(from: NSNumber(value: num2))
                
                
                cell.totalAmount.text = "₹ " + str!
                
                if ispr == true {
                    
                    cell.viewTotalAmount.isHidden = true
              
                    cell.viewPurity.isHidden = true
                    cell.viewFineGoldRate.isHidden = true
                    cell.viewFineGoldWeight.isHidden = true
                }else {
                    cell.viewTotalAmount.isHidden = false
                   
                    cell.viewPurity.isHidden = false
                    cell.viewFineGoldRate.isHidden = false
                    cell.viewFineGoldWeight.isHidden = false
                }
                
                
                
                return cell
            } else if indexPath.section == 2 {
                
                if self.diamondAsset[indexPath.row].certificationCost == "" || self.diamondAsset[indexPath.row].certificationCost == "0"{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "diamondCell") as! productDiamondCell
                    cell.d1Btn.isHidden = true
                    cell.d2Btn.isHidden = true
                    cell.d3Btn.isHidden = true
                    cell.d4Btn.isHidden = true
                    cell.d5Btn.isHidden = true
                    cell.d6BtnC.isHidden = true
                    
                    cell.d1Btnc.isHidden = true
                    cell.d2Btnc.isHidden = true
                    cell.d3Btnc.isHidden = true
                    cell.d4Btnc.isHidden = true
                    cell.d5Btnc.isHidden = true
                    
                    cell.diamondTypeBtn.setTitle(self.diamondAsset[indexPath.row].jwellerySize, for: .normal)
                    
                    let diamondBtn = [cell.d1Btn,cell.d2Btn,cell.d3Btn,cell.d4Btn,cell.d5Btn,cell.d6BtnC]
                    let diamondBtnC = [cell.d1Btnc,cell.d2Btnc,cell.d3Btnc,cell.d4Btnc,cell.d5Btnc]
                    
                    let diamondColor = self.diamondAsset[indexPath.row].color.components(separatedBy: ",")
                    for i in  0 ..< diamondColor.count {
                        diamondBtn[i]?.tag = indexPath.row
                        diamondBtn[i]?.isHidden = false
                        diamondBtn[i]?.setTitle(diamondColor[i], for: .normal)
                       // self.diamondColorTemp = diamondColor[i]
                        diamondBtn[i]?.addTarget(self, action: #selector(diamondColoBtn(_:)), for: .touchUpInside)
                        diamondBtn[i]?.backgroundColor = UIColor.white
                        diamondBtn[i]?.setTitleColor(.black, for: .normal)
                    }
                       
                    let diamondClarity = self.diamondAsset[indexPath.row].clarity.components(separatedBy: ",")
                    for i in  0 ..< diamondClarity.count {
                        diamondBtnC[i]?.tag = indexPath.row
                        diamondBtnC[i]?.isHidden = false
                        diamondBtnC[i]?.setTitle(diamondClarity[i], for: .normal)
                        //self.diamondClarityTemp = diamondClarity[i]
                        diamondBtnC[i]?.addTarget(self, action: #selector(diamondClarityBtn(_:)), for: .touchUpInside)
                        diamondBtnC[i]?.backgroundColor = UIColor.white
                        diamondBtnC[i]?.setTitleColor(.black, for: .normal)
                    }
                    
                    let clrTemp = NSMutableArray()
                for i in 0 ..< diamondBtn.count {
                    print(diamondBtn[i]?.titleLabel?.text ?? "")
                    print(self.diamondColorTemp)
                            
                    if diamondBtn[i]?.titleLabel?.text! == self.diamondColorTemp {
                        diamondBtn[i]?.backgroundColor = UIColor.init(named: "base_color")
                        diamondBtn[i]?.setTitleColor(.white, for: .normal)
                        
                        let tempdic = ["name":diamondBtn[i]?.titleLabel?.text!,"value":"1"]
                        
                        clrTemp.add(tempdic)
                    }else {
                        let tempdic = ["name":diamondBtn[i]?.titleLabel?.text!,"value":"0"]
                        clrTemp.add(tempdic)
                    }
                }
                    
                   
                        
                    let tempdic = ["name":self.diamondAsset[indexPath.row].jwellerySize,"value":clrTemp] as [String : Any]
                    
                    if self.newcolorarray.count != 0 {
                        for i in 0..<self.newcolorarray.count {
                            let name = self.newcolorarray[i]["name"] as! String
                            if name == self.diamondAsset[indexPath.row].jwellerySize {
                                self.newcolorarray.remove(at: i)
                                self.newcolorarray.insert(tempdic, at: i)
                                break
                            }
                        }
                        
                    }else {
                        self.newcolorarray.append(tempdic)
                    }
                    
                     
                    
                    
                    
                    let clarityTemp = NSMutableArray()
                    
                    
                    
                    self.clarArr = []
                    for i in 0 ..< diamondBtnC.count {
                        let btnName = diamondBtnC[i]?.titleLabel?.text! ?? ""
                        if btnName == self.diamondClarityTemp {
                            
                            diamondBtnC[i]?.backgroundColor = UIColor.init(named: "base_color")
                            diamondBtnC[i]?.setTitleColor(.white, for: .normal)
                            let tempdic = ["name":btnName,"value":"1"]
                            clarityTemp.add(tempdic)
                        }else {
                            let tempdic = ["name":btnName,"value":"0"]
                            clarityTemp.add(tempdic)
                        }
                    }
                        if self.diamondColorTemp == "" && self.diamondClarityTemp == "" {
                            self.diamondColorTemp = diamondColor[0]
                            self.diamondClarityTemp = diamondClarity[0]
                        }
                    
                    
                    
                    let tempdic1 = ["name":self.diamondAsset[indexPath.row].jwellerySize,"value":clarityTemp] as [String : Any]
                    
                    if self.newClarityarray.count != 0 {
                        for i in 0..<self.newClarityarray.count {
                            let name = self.newClarityarray[i]["name"] as! String
                            if name == self.diamondAsset[indexPath.row].jwellerySize {
                                self.newClarityarray.remove(at: i)
                                self.newClarityarray.insert(tempdic1, at: i)
                                break
                            }
                        }
                        
                    }else {
                        self.newClarityarray.append(tempdic1)
                    }
                       
                        //MARK:- Name label
                        cell.lblName.text = self.diamondAsset[indexPath.row].jwellerySize
                    self.diaType = self.diamondAsset[indexPath.row].jwellerySize
                        //MARK:- Weight Label
                    let weight = self.diamondAsset[indexPath.row].weight.toDouble()
                    let we = String(format: "%.3f", weight)
                        cell.lblWeight.text = we + " Ct"
                        
                        //MARK:- Daimond Price
                        var diamondPrice = ""
                        for i in self.product!.price.diamondMaster {
                            if i.type == self.diamondAsset[indexPath.row].defaultColorClarity {
                                if i.diamond_type == self.diamondAsset[indexPath.row].jwellerySize {
                                    diamondPrice = i.price
                                    
                                }
                            }
                        }
                    let daimondpr = diamondPrice.toDouble()
                    let wedaimondpr = String(format: "%.1f", daimondpr)
                        cell.lblPrice.text = "₹ " + wedaimondpr + "/ ct"
                        
                        //MARK:- No of Diamond
                    cell.lblNoDiamond.text = self.diamondAsset[indexPath.row].quantity + " pc"
                   
                        
                        //MARK:- Total Diamond
                    
                    let daitotal = PriceCalculation.shared.diamondPrice(diamondWeight: self.diamondAsset[indexPath.row].weight.toDouble(), diamondRate: diamondPrice.toDouble())
                    
                    let rateTotal = String(format: "%.2f", daitotal)
                    cell.lblDiamondTotal.text = "₹ " + rateTotal
                        
                        //MARK:- Diamond Color Clarity
                        cell.lblDiamondColorClarity.text = self.diamondAsset[indexPath.row].defaultColorClarity
                        
                        
                        cell.d1Btn.layer.borderColor = UIColor.black.cgColor
                        cell.d1Btn.layer.borderWidth = 0.5
                        cell.d1Btn.layer.cornerRadius = cell.d1Btn.frame.height / 2
                        cell.d1Btn.clipsToBounds = true
                                
                        cell.d2Btn.layer.borderColor = UIColor.black.cgColor
                        cell.d2Btn.layer.borderWidth = 0.5
                        cell.d2Btn.layer.cornerRadius = cell.d2Btn.frame.height / 2
                        cell.d2Btn.clipsToBounds = true
                                
                        cell.d3Btn.layer.borderColor = UIColor.black.cgColor
                        cell.d3Btn.layer.borderWidth = 0.5
                        cell.d3Btn.layer.cornerRadius = cell.d3Btn.frame.height / 2
                        cell.d3Btn.clipsToBounds = true
                                
                        cell.d4Btn.layer.borderColor = UIColor.black.cgColor
                        cell.d4Btn.layer.borderWidth = 0.5
                        cell.d4Btn.layer.cornerRadius = cell.d4Btn.frame.height / 2
                        cell.d4Btn.clipsToBounds = true
                                
                        cell.d5Btn.layer.borderColor = UIColor.black.cgColor
                        cell.d5Btn.layer.borderWidth = 0.5
                        cell.d5Btn.layer.cornerRadius = cell.d5Btn.frame.height / 2
                        cell.d5Btn.clipsToBounds = true
                    
                    cell.d6BtnC.layer.borderColor = UIColor.black.cgColor
                    cell.d6BtnC.layer.borderWidth = 0.5
                    cell.d6BtnC.layer.cornerRadius = cell.d5Btn.frame.height / 2
                    cell.d6BtnC.clipsToBounds = true
                            
                        cell.d1Btnc.layer.borderColor = UIColor.black.cgColor
                        cell.d1Btnc.layer.borderWidth = 0.5
                        cell.d1Btnc.layer.cornerRadius = cell.d1Btnc.frame.height / 2
                        cell.d1Btnc.clipsToBounds = true
                            
                        cell.d2Btnc.layer.borderColor = UIColor.black.cgColor
                        cell.d2Btnc.layer.borderWidth = 0.5
                        cell.d2Btnc.layer.cornerRadius = cell.d2Btnc.frame.height / 2
                        cell.d2Btnc.clipsToBounds = true
                            
                        cell.d3Btnc.layer.borderColor = UIColor.black.cgColor
                        cell.d3Btnc.layer.borderWidth = 0.5
                        cell.d3Btnc.layer.cornerRadius = cell.d3Btnc.frame.height / 2
                        cell.d3Btnc.clipsToBounds = true
                            
                        cell.d4Btnc.layer.borderColor = UIColor.black.cgColor
                        cell.d4Btnc.layer.borderWidth = 0.5
                        cell.d4Btnc.layer.cornerRadius = cell.d4Btnc.frame.height / 2
                        cell.d4Btnc.clipsToBounds = true
                            
                        cell.d5Btnc.layer.borderColor = UIColor.black.cgColor
                        cell.d5Btnc.layer.borderWidth = 0.5
                        cell.d5Btnc.layer.cornerRadius = cell.d4Btnc.frame.height / 2
                        cell.d5Btnc.clipsToBounds = true
                    
                    
                    if ispr == true {
                        
                        cell.viewPrice.isHidden = true
                        cell.viewDiaNo.isHidden = true
                        cell.viewDiaTotal.isHidden = true
                        cell.viewColCla.isHidden = true
                       
                    }else {
                        cell.viewPrice.isHidden = false
                        if self.diamondAsset[indexPath.row].quantity != "0" {
                            cell.viewDiaNo.isHidden = false
                            
                              
                        }
                        else {
                            cell.viewDiaNo.isHidden = true
                        }
                        cell.viewDiaTotal.isHidden = false
                        cell.viewColCla.isHidden = false
                    }
                    
                    return cell
                }
                let cell = tableView.dequeueReusableCell(withIdentifier: "diamondCellCertified") as! productDiamondCellCertified
                cell.d1Btn.isHidden = true
                cell.d2Btn.isHidden = true
                cell.d3Btn.isHidden = true
                cell.d4Btn.isHidden = true
                cell.d5Btn.isHidden = true
                
                cell.d1Btnc.isHidden = true
                cell.d2Btnc.isHidden = true
                cell.d3Btnc.isHidden = true
                cell.d4Btnc.isHidden = true
                cell.d5Btnc.isHidden = true
                
                let diamondBtn = [cell.d1Btn,cell.d2Btn,cell.d3Btn,cell.d4Btn,cell.d5Btn]
                let diamondBtnC = [cell.d1Btnc,cell.d2Btnc,cell.d3Btnc,cell.d4Btnc,cell.d5Btnc]
                
                
                
                cell.diamondTypeBtn.setTitle(self.diamondAsset[indexPath.row].jwellerySize, for: .normal)
            let diamondColor = self.diamondAsset[indexPath.row].color.components(separatedBy: ",")
            for i in  0 ..< diamondColor.count {
                diamondBtn[i]?.tag = indexPath.row
                diamondBtn[i]?.isHidden = false
                diamondBtn[i]?.setTitle(diamondColor[i], for: .normal)
                diamondBtn[i]?.addTarget(self, action: #selector(diamondColoBtn(_:)), for: .touchUpInside)
                diamondBtn[i]?.backgroundColor = UIColor.white
                diamondBtn[i]?.setTitleColor(.black, for: .normal)
            }
               
                let diamondClarity = self.diamondAsset[indexPath.row].clarity.components(separatedBy: ",")
                    for i in  0 ..< diamondClarity.count {
                    diamondBtnC[i]?.tag = indexPath.row
                    diamondBtnC[i]?.isHidden = false
                    diamondBtnC[i]?.setTitle(diamondClarity[i], for: .normal)
                    diamondBtnC[i]?.addTarget(self, action: #selector(diamondClarityBtn(_:)), for: .touchUpInside)
                    diamondBtnC[i]?.backgroundColor = UIColor.white
                    diamondBtnC[i]?.setTitleColor(.black, for: .normal)
                }
               
                let clrTemp = NSMutableArray()
            for i in 0 ..< diamondBtn.count {
                print(diamondBtn[i]?.titleLabel?.text ?? "")
                print(self.diamondColorTemp)
                        
                if diamondBtn[i]?.titleLabel?.text! == self.diamondColorTemp {
                    diamondBtn[i]?.backgroundColor = UIColor.init(named: "base_color")
                    diamondBtn[i]?.setTitleColor(.white, for: .normal)
                    
                    let tempdic = ["name":diamondBtn[i]?.titleLabel?.text!,"value":"1"]
                    
                    clrTemp.add(tempdic)
                }else {
                    let tempdic = ["name":diamondBtn[i]?.titleLabel?.text!,"value":"0"]
                    clrTemp.add(tempdic)
                }
            }
                
               
                    
                let tempdic = ["name":self.diamondAsset[indexPath.row].jwellerySize,"value":clrTemp] as [String : Any]
                
                if self.newcolorarray.count != 0 {
                    for i in 0..<self.newcolorarray.count {
                        let name = self.newcolorarray[i]["name"] as! String
                        if name == self.diamondAsset[indexPath.row].jwellerySize {
                            self.newcolorarray.remove(at: i)
                            self.newcolorarray.insert(tempdic, at: i)
                            break
                        }
                    }
                    
                }else {
                    self.newcolorarray.append(tempdic)
                }
                
                 
                
                
                
                let clarityTemp = NSMutableArray()
                
                
                
                self.clarArr = []
                for i in 0 ..< diamondBtnC.count {
                    let btnName = diamondBtnC[i]?.titleLabel?.text! ?? ""
                    if btnName == self.diamondClarityTemp {
                        
                        diamondBtnC[i]?.backgroundColor = UIColor.init(named: "base_color")
                        diamondBtnC[i]?.setTitleColor(.white, for: .normal)
                        let tempdic = ["name":btnName,"value":"1"]
                        clarityTemp.add(tempdic)
                    }else {
                        let tempdic = ["name":btnName,"value":"0"]
                        clarityTemp.add(tempdic)
                    }
                }
                   
                
                
                let tempdic1 = ["name":self.diamondAsset[indexPath.row].jwellerySize,"value":clarityTemp] as [String : Any]
                
                if self.newClarityarray.count != 0 {
                    for i in 0..<self.newClarityarray.count {
                        let name = self.newClarityarray[i]["name"] as! String
                        if name == self.diamondAsset[indexPath.row].jwellerySize {
                            self.newClarityarray.remove(at: i)
                            self.newClarityarray.insert(tempdic1, at: i)
                            break
                        }
                    }
                    
                }else {
                    self.newClarityarray.append(tempdic1)
                }
                
                
    //            for i in 0 ..< diamondBtn.count {
    //                print(diamondBtn[i]?.titleLabel?.text ?? "")
    //                print(self.diamondColorTemp)
    //
    //                if diamondBtn[i]?.titleLabel?.text! == self.diamondColorTemp {
    //                    diamondBtn[i]?.backgroundColor = UIColor.init(named: "base_color")
    //                    diamondBtn[i]?.setTitleColor(.white, for: .normal)
    //                }
    //            }
    //            if self.diamondColorTemp == "" && self.diamondClarityTemp == "" {
    //                self.diamondColorTemp = diamondColor[0]
    //                self.diamondClarityTemp = diamondClarity[0]
    //            }
    //
    //            for i in 0 ..< diamondBtnC.count {
    //                let btnName = diamondBtnC[i]?.titleLabel?.text! ?? ""
    //                print(btnName)
    //                if btnName == self.diamondClarityTemp {
    //                    diamondBtnC[i]?.backgroundColor = UIColor.init(named: "base_color")
    //                    diamondBtnC[i]?.setTitleColor(.white, for: .normal)
    //                }
    //            }
    //                if self.diamondColorTemp == "" && self.diamondClarityTemp == "" {
    //                    self.diamondColorTemp = diamondColor[0]
    //                    self.diamondClarityTemp = diamondClarity[0]
    //                }
               
                //MARK:- Name label
                cell.lblName.text = self.diamondAsset[indexPath.row].jwellerySize
                self.diaType = self.diamondAsset[indexPath.row].jwellerySize
                //MARK:- Weight Label
                cell.lblWeight.text = self.diamondAsset[indexPath.row].weight + " Ct"
                
                //MARK:- Daimond Price
                var diamondPrice = ""
                for i in self.product!.price.diamondMaster {
                    
                    if i.diamond_type == self.diamondAsset[indexPath.row].jwellerySize {
                        if i.type == self.diamondAsset[indexPath.row].defaultColorClarity {
                            if i.diamond_type == self.diamondAsset[indexPath.row].jwellerySize {
                                diamondPrice = i.price
                                
                            }
                        }
                    }
                    
                    
                }
                cell.lblPrice.text = "₹" + diamondPrice + "/ Ct"
                
                //MARK:- No of Diamond
                cell.lblNoDiamond.text = self.diamondAsset[indexPath.row].quantity + " Pc"
                
                
                //MARK:- Diamond Color Clarity
                cell.lblDiamondColorClarity.text = self.diamondAsset[indexPath.row].defaultColorClarity
                
                //MARK:- Certificate charge
                cell.lblCertificateCharges.text = self.diamondAsset[indexPath.row].certificationCost
                
                
                var certCost = 0.0
                if self.diamondAsset[indexPath.row].crtcostOption == "PerCarat" {
                    //MARK:- Certificate charge
                    cell.lblCertificateCharges.text = "₹" + self.diamondAsset[indexPath.row].certificationCost + " /Ct"
                    
                    
                    certCost = self.diamondAsset[indexPath.row].weight.toDouble() * self.diamondAsset[indexPath.row].certificationCost.toDouble()
                } else if self.diamondAsset[indexPath.row].crtcostOption == "Fixed" {
                    //MARK:- Certificate charge
                    cell.lblCertificateCharges.text = "₹" + self.diamondAsset[indexPath.row].certificationCost
                    
                    certCost = self.diamondAsset[indexPath.row].certificationCost.toDouble()
                }
                
                //MARK:- Total Certification Charge
                cell.lblTotalCertificateCharges.text = "₹ " + certCost.toString()
                
                //MARK:- Total Diamond
                cell.lblDiamondTotal.text = "₹ " + (PriceCalculation.shared.diamondPrice(diamondWeight: self.diamondAsset[indexPath.row].weight.toDouble(), diamondRate: diamondPrice.toDouble()) + certCost).toString()
                
                cell.d1Btn.layer.borderColor = UIColor.black.cgColor
                cell.d1Btn.layer.borderWidth = 0.5
                cell.d1Btn.layer.cornerRadius = cell.d1Btn.frame.height / 2
                cell.d1Btn.clipsToBounds = true
                        
                cell.d2Btn.layer.borderColor = UIColor.black.cgColor
                cell.d2Btn.layer.borderWidth = 0.5
                cell.d2Btn.layer.cornerRadius = cell.d2Btn.frame.height / 2
                cell.d2Btn.clipsToBounds = true
                        
                cell.d3Btn.layer.borderColor = UIColor.black.cgColor
                cell.d3Btn.layer.borderWidth = 0.5
                cell.d3Btn.layer.cornerRadius = cell.d3Btn.frame.height / 2
                cell.d3Btn.clipsToBounds = true
                        
                cell.d4Btn.layer.borderColor = UIColor.black.cgColor
                cell.d4Btn.layer.borderWidth = 0.5
                cell.d4Btn.layer.cornerRadius = cell.d4Btn.frame.height / 2
                cell.d4Btn.clipsToBounds = true
                        
                cell.d5Btn.layer.borderColor = UIColor.black.cgColor
                cell.d5Btn.layer.borderWidth = 0.5
                cell.d5Btn.layer.cornerRadius = cell.d5Btn.frame.height / 2
                cell.d5Btn.clipsToBounds = true
                    
                cell.d1Btnc.layer.borderColor = UIColor.black.cgColor
                cell.d1Btnc.layer.borderWidth = 0.5
                cell.d1Btnc.layer.cornerRadius = cell.d1Btnc.frame.height / 2
                cell.d1Btnc.clipsToBounds = true
                    
                cell.d2Btnc.layer.borderColor = UIColor.black.cgColor
                cell.d2Btnc.layer.borderWidth = 0.5
                cell.d2Btnc.layer.cornerRadius = cell.d2Btnc.frame.height / 2
                cell.d2Btnc.clipsToBounds = true
                    
                cell.d3Btnc.layer.borderColor = UIColor.black.cgColor
                cell.d3Btnc.layer.borderWidth = 0.5
                cell.d3Btnc.layer.cornerRadius = cell.d3Btnc.frame.height / 2
                cell.d3Btnc.clipsToBounds = true
                    
                cell.d4Btnc.layer.borderColor = UIColor.black.cgColor
                cell.d4Btnc.layer.borderWidth = 0.5
                cell.d4Btnc.layer.cornerRadius = cell.d4Btnc.frame.height / 2
                cell.d4Btnc.clipsToBounds = true
                    
                cell.d5Btnc.layer.borderColor = UIColor.black.cgColor
                cell.d5Btnc.layer.borderWidth = 0.5
                cell.d5Btnc.layer.cornerRadius = cell.d4Btnc.frame.height / 2
                cell.d5Btnc.clipsToBounds = true
                
                if ispr == true {
                    
                    cell.viewPrice.isHidden = true
                    cell.viewDiaNo.isHidden = true
                    cell.viewDiaTotal.isHidden = true
                    cell.viewColcla.isHidden = true
                    cell.viewCertTotal.isHidden = true
                    cell.viewCertCharge.isHidden = true
                   
                }else {
                    cell.viewPrice.isHidden = false
                    cell.viewDiaNo.isHidden = false
                    cell.viewDiaTotal.isHidden = false
                    cell.viewColcla.isHidden = false
                    cell.viewCertTotal.isHidden = false
                    cell.viewCertCharge.isHidden = false
                }
                
                
                return cell
            } else if indexPath.section == 3 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "stoneCell") as! productStoneCell
                
                
                if self.arrFinalStone[indexPath.row]["stoneInside"] == nil {
                    cell.downArrow.isHidden  = true
                    cell.btnStoneType.isUserInteractionEnabled = false
                    cell.btnStoneType.layer.borderWidth = 1.0
                    cell.btnStoneType.layer.borderColor = UIColor.darkGray.cgColor
                    cell.btnStoneType.setTitle(self.arrFinalStone[indexPath.row]["jwellerySize"] as! String, for: .normal)
                    
                    
                    if self.arrFinalStone[indexPath.row]["quantity"] as! String == "0" ||  self.arrFinalStone[indexPath.row]["quantity"] as! String == "" {
                        cell.viewMain.isHidden = true
                        
                    }else {
                        cell.viewMain.isHidden = false
                    }
                    
                    cell.lblNoOfStone.text = self.arrFinalStone[indexPath.row]["quantity"] as! String + " Pc"
                    let we = self.arrFinalStone[indexPath.row]["weight"] as! String
                    let ston = String(format: "%.3f", we.toDouble())
                               cell.lblStoneWeight.text = ston + " Ct"
                   
                               var stonRate = ""
                               for i in self.product!.price.stone {
                                   if i.type == (self.arrFinalStone[indexPath.row]["jwellerySize"] as! String).uppercased() {
                                       stonRate = i.price
                                   }
                               }
                               let stonrat = String(format: "%.1f", stonRate.toDouble())
                               cell.lblStonePrice.text = stonrat + "/ Ct"
                               stonRate = stonrat
                   
                                
                               let stonratotal = String(format: "%.2f", (stonRate.toDouble() * we.toDouble()))
                   
                   
                               cell.lblStoneTotal.text = "₹ " + stonratotal
                    
                    
                    
                }else {
                    cell.downArrow.isHidden  = false
                    cell.btnStoneType.tag = indexPath.row
                    cell.btnStoneType.isUserInteractionEnabled = true
                    cell.btnStoneType.addTarget(self, action: #selector(selectStone(_:)), for: .touchUpInside)
                    let arrmain = self.arrFinalStone[indexPath.row]["stoneInside"] as! [[String:Any]]
                    
                    cell.btnStoneType.setTitle(arrmain[0]["jwellerySize"] as! String, for: .normal)
                    if self.arrFinalStone[indexPath.row]["quantity"] as! String == "0" ||  self.arrFinalStone[indexPath.row]["quantity"] as! String == "" {
                        cell.viewMain.isHidden = true
                        
                    }else {
                        cell.viewMain.isHidden = false
                    }
                    cell.lblNoOfStone.text = arrmain[0]["quantity"] as! String + " Pc"
                    let we = arrmain[0]["weight"] as! String
                    let ston = String(format: "%.3f", we.toDouble())
                               cell.lblStoneWeight.text = ston + " Ct"
                   
                               var stonRate = ""
                               for i in self.product!.price.stone {
                                   if i.type == (arrmain[0]["jwellerySize"] as! String).uppercased() {
                                       stonRate = i.price
                                   }
                               }
                               let stonrat = String(format: "%.1f", stonRate.toDouble())
                               cell.lblStonePrice.text = stonrat + "/ Ct"
                               stonRate = stonrat
                   
                                
                               let stonratotal = String(format: "%.2f", (stonRate.toDouble() * we.toDouble()))
                   
                   
                               cell.lblStoneTotal.text = "₹ " + stonratotal
                    
                }
                
                
                if ispr == true {
                    
                    cell.viewRate.isHidden = true
                    cell.viewTot.isHidden = true
                    
                   
                }else {
                    cell.viewRate.isHidden = false
                    cell.viewTot.isHidden = false
                }
    //            cell.btnStoneType.setTitle(self.stoneAsset[indexPath.row].jwellerySize, for: .normal)
    //
    //
    //            cell.lblNoOfStone.text = self.stoneAsset[indexPath.row].quantity + " Pc"
    //
    //            let ston = String(format: "%.3f", self.stoneAsset[indexPath.row].weight.toDouble())
    //            cell.lblStoneWeight.text = ston + " Ct"
    //
    //            var stonRate = ""
    //            for i in self.product!.price.stone {
    //                if i.type == self.stoneAsset[indexPath.row].jwellerySize.uppercased() {
    //                    stonRate = i.price
    //                }
    //            }
    //            let stonrat = String(format: "%.1f", stonRate.toDouble())
    //            cell.lblStonePrice.text = stonrat + "/ Ct"
    //            stonRate = stonrat
    //
    //
    //            let stonratotal = String(format: "%.2f", (stonRate.toDouble() * self.stoneAsset[indexPath.row].weight.toDouble()))
    //
    //
    //            cell.lblStoneTotal.text = "₹ " + stonratotal
                return cell
            } else if indexPath.section == 4 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "platinumCell") as! productPlatinumCell
                
                //MARK:- Product Code
                cell.lblProdcutCode.text = "  " + (self.product?.data.productcode)!
                
                //MARK:- Platinum Price
                let price = self.product?.price.platinum[0].price
                let pricetot = String(format: "%.2f", price?.toDouble() as! CVarArg)
                cell.lblPlatinumPrice.text = "  " + "₹ " + pricetot + " /g"
                
                //MARK:- Platinum weight
                let weight = self.platinumAsset[indexPath.row].weight
                let weighttot = String(format: "%.3f", weight.toDouble() as! CVarArg)
                cell.lblPlatinumWeight.text = "  " + weighttot + " g"
                
                //MARK:- Platinum Purity
                cell.lblPlatinumPurity.text = "  " + self.platinumAsset[indexPath.row].purity + "%"
                
                //MARK:- Platinum Wastage
                
                
                let wastage = self.platinumAsset[indexPath.row].wastage
                
                if wastage == "" || wastage == "<null>"{
                    cell.viewastage.isHidden = true
                }else {
                    cell.viewastage.isHidden = false
                    cell.lblPlatinumWasteage.text = "  " + self.platinumAsset[indexPath.row].wastage + "%"
                    
                    if self.ispr == true {
                        cell.viewastage.isHidden = true
                    }else {
                        cell.viewastage.isHidden = false
                    }
                }
                
                
                //MARK:- Platinum Makig Charge
                let smakingCharge = self.platinumAsset[indexPath.row].makingCharge
                let smakingChargetot = String(format: "%.2f", smakingCharge.toDouble() as! CVarArg)
                cell.lblPlatinumMakingCharge.text = "  " + "₹ " + smakingChargetot + " /g"
                
                //MARK:- Total Making Charge
                var makingCharge = 0.0
                var totalweight = 0.0
                if ischange == false {
                     totalweight = sizeCalculation(selectedSize: Int((self.product?.data.defaultSize)!)!, weight: self.platinumAsset[indexPath.row].weight.toDouble())
                }else {
                    totalweight = self.platinumAsset[indexPath.row].weight.toDouble()
                }
                
                
                
                if self.platinumAsset[indexPath.row].chargesOption == "PerGram" {
                    makingCharge = PriceCalculation.shared.platinumMaking(weight: totalweight, rate: self.platinumAsset[indexPath.row].makingCharge.toDouble(), isPerGram: true)
                } else if self.platinumAsset[indexPath.row].chargesOption == "Fixed" || self.platinumAsset[indexPath.row].chargesOption == "PerPiece" {
                    makingCharge = PriceCalculation.shared.platinumMaking(weight: self.platinumAsset[indexPath.row].weight.toDouble(), rate: self.platinumAsset[indexPath.row].makingCharge.toDouble(), isPerGram: false)
                }
                
                //MARK:- Meena Cost
                var finalMeenaCost = 0.0
                if self.platinumAsset[indexPath.row].meenacostOption == "PerGram" {
                    let meenaCost = PriceCalculation.shared.MeenaCost(meenaRate: self.platinumAsset[indexPath.row].meenaCost.toDouble(), weight: self.platinumAsset[indexPath.row].weight.toDouble(), isPergram: true)
                    finalMeenaCost = meenaCost
                } else if self.platinumAsset[indexPath.row].meenacostOption == "Fixed" {
                    let meenaCost = PriceCalculation.shared.MeenaCost(meenaRate: self.platinumAsset[indexPath.row].meenaCost.toDouble(), weight: self.platinumAsset[indexPath.row].weight.toDouble(), isPergram: false)
                    finalMeenaCost = meenaCost
                }
                
                cell.lblTotalMakingCharge.text = "  " + "₹ " + makingCharge.toString()
                
                //MARK:- Platinum Total
                let tot = (PriceCalculation.shared.platinumPrice(weight: totalweight, rate: (self.product?.price.platinum[0].price.toDouble())!, wastage: self.platinumAsset[indexPath.row].wastage.toDouble(), purity: self.platinumAsset[indexPath.row].purity.toDouble())) + makingCharge + finalMeenaCost
                let plate = String(format: "%.2f", tot)
               
                
                cell.lblPlatinumTotal.text = "  " + "₹ " + plate
                
                if self.ispr == true {
                    cell.viewPrice.isHidden = true
                    cell.viewPurity.isHidden = true
                    cell.viewWeigh.isHidden = true
                    cell.viewMaking.isHidden = true
                    cell.viewTotalMakingCharge.isHidden = true
                    cell.viewMakingCharge.isHidden = true
                }else {
                    cell.viewPrice.isHidden = false
                    
                    cell.viewPurity.isHidden = false
                    cell.viewWeigh.isHidden = false
                    cell.viewMaking.isHidden = false
                    cell.viewTotalMakingCharge.isHidden = false
                    cell.viewMakingCharge.isHidden = false
                }
                
                
                return cell
            } else if indexPath.section == 5 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "silverCell") as! productSilverCell
                
                
                
                cell.btn1.isHidden = true
                cell.btn2.isHidden = true
                cell.btn3.isHidden = true
                cell.btn4.isHidden = true
                let btnArr = [cell.btn1,cell.btn2,cell.btn3,cell.btn4]
                
                for i in 0 ..< self.silverAsset.count {
                    
                    btnArr[i]?.isHidden = false
                    btnArr[i]?.setTitle(self.silverAsset[i].jwellerySize, for: .normal)
                    btnArr[i]?.addTarget(self, action: #selector(goldSelect(_:)), for: .touchUpInside)
                    btnArr[i]?.backgroundColor = UIColor.white
                    btnArr[i]?.setTitleColor(.black, for: .normal)
                }
                if self.silverAsset.count > 0 {
                    for i in btnArr {
                        if i?.titleLabel?.text == self.silverAsset[self.selectedIndSilver].jwellerySize {
                            i?.backgroundColor = UIColor.init(named: "base_color")
                            i?.setTitleColor(.white, for: .normal)
                            self.selectedsilvertype = (i?.titleLabel?.text)!
                            //self.defualttype = (0.titleLabel?.text)!
                        }
                    }
                }
                
                cell.btn1.layer.borderColor = UIColor.black.cgColor
                cell.btn1.layer.borderWidth = 1
                cell.btn1.layer.cornerRadius = cell.btn1.frame.height / 2
                cell.btn1.clipsToBounds = true
                    
                cell.btn2.layer.borderColor = UIColor.black.cgColor
                cell.btn2.layer.borderWidth = 1
                cell.btn2.layer.cornerRadius = cell.btn2.frame.height / 2
                cell.btn2.clipsToBounds = true
                    
                cell.btn3.layer.borderColor = UIColor.black.cgColor
                cell.btn3.layer.borderWidth = 1
                cell.btn3.layer.cornerRadius = cell.btn3.frame.height / 2
                cell.btn3.clipsToBounds = true
                    
                cell.btn4.layer.borderColor = UIColor.black.cgColor
                cell.btn4.layer.borderWidth = 1
                cell.btn4.layer.cornerRadius = cell.btn4.frame.height / 2
                cell.btn4.clipsToBounds = true
                
                
                cell.lblProductCode.text = "  " + (self.product?.data.productcode)!
                cell.viewCode.isHidden = true
                
                let price = self.product?.price.silver[0].price
                let pricetot = String(format: "%.2f", price?.toDouble() as! CVarArg)
                cell.lblRate.text =  "₹ " + pricetot + " /g"
                                
                                //MARK:- Value In Calc
                                var valueIn = ""
                                
                                print(self.silverAsset.count)
                                if self.silverAsset.count > 0 {
                                    let goldType = self.silverAsset[self.selectedIndSilver].jwellerySize
                                    for i in self.product!.price.silver {
                                        if goldType == i.type {
                                            print(i.valueIn)
                                            let type = String(format: "%.2f", i.valueIn.toDouble())
                                            cell.lblPurity.text = type + "%"
                                            valueIn = i.valueIn
                                        }
                                    }
                                }
                                    
                                
                                
                               
                                
                                //MARK:- Net Gold Weight
                                let netgold = Double(self.silverAsset[self.selectedIndSilver].weight)
                                
                                let netgoldy = String(format: "%.3f", netgold!)
                                cell.lblWeight.text = netgoldy + " g"
                                
                                if ispr == true {
                                    
                                    cell.viewWeight.isHidden = true
                                }else {
                                    cell.viewWeight.isHidden = false
                                }
                                
                                //MARK:- Gold Making Charge
                                
                                let Making = Double(self.silverAsset[self.selectedIndSilver].makingCharge)
                                
                                if Making != 0 {
                                    cell.viewMaking.isHidden = false
                                     cell.viewTotalMaking.isHidden = false
                                    let Makingy = String(format: "%.1f", Making!)
                                    cell.lblSilverMakingCharge.text = "₹ " + Makingy + "/ g"
                                    
                                    if ispr == true {
                                        
                                        cell.viewMaking.isHidden = true
                                    }else {
                                        cell.viewMaking.isHidden = false
                                    }
                                    
                                }else {
                                    cell.viewTotalMaking.isHidden = true
                                    cell.viewMaking.isHidden = true
                                }
                                
                                var  wastage = Double(self.silverAsset[self.selectedIndSilver].wastage)
                                if wastage == nil {
                                    wastage = 0
                                }
                                if wastage != 0 {
                                    cell.viewWastage.isHidden = false
                                    let wastagey = String(format: "%.1f", wastage!)
                                    cell.lblWastage.text = wastagey + " %"
                                    
                                    if ispr == true {
                                        
                                        cell.viewWastage.isHidden = true
                                    }else {
                                        cell.viewWastage.isHidden = false
                                    }
                                    
                                }else {
                                    cell.viewWastage.isHidden = true
                                }
                                
                                let value = valueIn.toDouble()
                                let mainweight = netgoldy.toDouble()
                                let was = wastage
                                let fineWeight = mainweight * (value+was!) / 100
                                //MARK:- Fine Gold Weight
                            //    let purity = fineWeight.toDouble() / 100
                                let finew = String(format: "%.3f", fineWeight)
                                cell.lblFineSilverWeight.text = finew + " g"
                                
                                //MARK:- Fine Gold Rate
                                var goldRate = 0.0
                                var mainrate = 0.0
                                for i in self.product!.price.silver {
                                    print(i.price)
                                    if i.type == "1000" {
                                        print(i.price)
                                        let rate = String(format: "%.2f", i.price.toDouble())
                                        cell.lblFineSilverRate.text = "₹ " + rate + " / g"
                                        mainrate = rate.toDouble()
                                        goldRate = i.price.toDouble()
                                    }
                                }
                                
                                //MARK:- Meena Cost
                                var finalMeenaCost = 0.0
                                if self.silverAsset[self.selectedIndSilver].meenacostOption == "PerGram" {
                                    cell.lblChargeType.text = "PerGram"
                                    let meenaCost = PriceCalculation.shared.MeenaCost(meenaRate: self.silverAsset[self.selectedIndSilver].meenaCost.toDouble(), weight: self.silverAsset[self.selectedIndSilver].weight.toDouble(), isPergram: true)
                                    finalMeenaCost = meenaCost
                                } else if self.silverAsset[self.selectedIndSilver].meenacostOption == "Fixed" {
                                    cell.lblChargeType.text = "Fixed"
                                    let meenaCost = PriceCalculation.shared.MeenaCost(meenaRate: self.silverAsset[self.selectedIndSilver].meenaCost.toDouble(), weight: self.silverAsset[self.selectedIndSilver].weight.toDouble(), isPergram: false)
                                    finalMeenaCost = meenaCost
                                }
                                
                                //MARK:- MakingCharges
                                var makingCharge = 0.0
                
                                if self.silverAsset[self.selectedIndSilver].chargesOption == "PerGram" {
                                    
                                    makingCharge = PriceCalculation.shared.silverMaking(weight: self.silverAsset[self.selectedIndSilver].weight.toDouble(), rate: self.silverAsset[self.selectedIndSilver].makingCharge.toDouble(), isPergram: true)
                                    
                        
                                } else if self.silverAsset[self.selectedIndSilver].chargesOption == "Fixed" {
                                    
                                    makingCharge = PriceCalculation.shared.silverMaking(weight: self.silverAsset[self.selectedIndSilver].weight.toDouble(), rate: self.silverAsset[self.selectedIndSilver].makingCharge.toDouble(), isPergram: false)
                                    
                                   
                                }
                                
                                //MARK:- Total Making Charge
                let totalMakingCharge = self.silverAsset[self.selectedIndSilver].makingCharge.toDouble() * netgoldy.toDouble()
                                let maintotalMakingCharge = String(format: "%.2f", totalMakingCharge)
                                
                                cell.lblSilverPrice.text = "₹ " + maintotalMakingCharge
                                
                                //MARK:- Total Amount
                
                
                let totalmain = (PriceCalculation.shared.silverPrice(weight: netgoldy.toDouble(), rate: mainrate, wastage: self.silverAsset[self.selectedIndSilver].wastage.toDouble() + finalMeenaCost, purity: valueIn.toDouble()))
                
                
                                
                                
                                let stotalmain = String(format: "%.3f", totalmain + totalMakingCharge)
                                
                                let numberFormatter = NumberFormatter()
                                numberFormatter.minimumFractionDigits = 2
                                numberFormatter.maximumFractionDigits = 2
                                numberFormatter.roundingMode = .down
                               // let str = numberFormatter.string(from: NSNumber(value: stotalmain))
                               // let str2 = numberFormatter.string(from: NSNumber(value: num2))
                                
                                
                cell.lblSilverTotal.text = "₹ " + stotalmain
                
                
                
                if self.ispr == true {
                    cell.viewMaking.isHidden = true
                    cell.viewPurity.isHidden = true
                    cell.viewRate.isHidden = true
                    cell.viewTotalMaking.isHidden = true
                    cell.viewWeight.isHidden = true
                    cell.viewTotal.isHidden = true
                    
                    
                    cell.viewFineSilverWeight.isHidden = true
                    cell.viewFineSIlverRate.isHidden = true
                }else {
                    cell.viewMaking.isHidden = false
                    cell.viewPurity.isHidden = false
                    cell.viewRate.isHidden = false
                    cell.viewTotalMaking.isHidden = false
                    cell.viewWeight.isHidden = false
                    cell.viewTotal.isHidden = false
                    
                    cell.viewFineSilverWeight.isHidden = false
                    cell.viewFineSIlverRate.isHidden = false
                }
                cell.viewPurity.isHidden = true
                cell.viewFineSIlverRate.isHidden = true
                
                return cell
                
                
            
            } else if indexPath.section == 6 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "certifiedByCell") as! productCertifiedByCell
                cell.img1.isHidden = true
                cell.img2.isHidden = true
                cell.img3.isHidden = true
                
                var imgArr = [cell.img1,cell.img2,cell.img3]
                for i in 0 ..< self.product!.certification.count {
                    imgArr[i]?.isHidden = false
                    imgArr[i]?.kf.indicatorType = .activity
                    imgArr[i]?.kf.setImage(with: URL(string: self.product!.certification[i].image),placeholder: nil,options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
                        switch result {
                        case .success(let value):
                            print("Task done for: \(value.source.url?.absoluteString ?? "")")
                            
                        case .failure(let error):
                            print("Job failed: \(error.localizedDescription)")
                            
                        }
                    }
                }
                return cell
            } else if indexPath.section == 7 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "manufactureCell") as! productManufactureByCell
                cell.lbl1.numberOfLines = 0
                cell.img.kf.indicatorType = .activity
                print(self.manufactureURL)
                
                var urlString = self.product?.manufacture.logo.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                cell.img.kf.setImage(with: URL(string: (urlString)!),placeholder: nil,options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
                    switch result {
                    case .success(let value):
                        print("Task done for: \(value.source.url?.absoluteString ?? "")")
                                       
                    case .failure(let error):
                        print("Job failed: \(error.localizedDescription)")
                    }
                }
                cell.lbl1.text = self.product?.manufacture.companyName
                return cell
            } else if indexPath.section == 8 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "descriptionCell") as! productOtherDetailsCell
                cell.txtDetails.attributedText = self.product?.data.dataDescription.convertHtml(str: (self.product?.data.dataDescription)!)
                return cell
            } else if indexPath.section == 9 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "priceCell") as! productPriceCell
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    cell.lblTotalPrice.text = "₹ " + self.calculateTotalPrice()
                    var sentence = self.productCode.text
                    let wordToRemove = "Gross weight :"
                    if let range = sentence!.range(of: wordToRemove) {
                        sentence!.removeSubrange(range)
                        cell.lblGrossWe.text = sentence
                    }

                    
                }
                
                if ispr == true {
                   // cell.lblToTtitle.isHidden = true
                    cell.lblTotalPrice.isHidden = true
                }else {
                   // cell.lblToTtitle.isHidden = false
                    cell.lblTotalPrice.isHidden = false
                }
                
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            return cell!
        }else if self.prodType == "DIAMOND JEWELLERY" {
            
            if indexPath.section == 0 {
                if indexPath.row == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "colorCell") as! productColorCell
                    cell.roseBtn.isHidden = true
                    cell.goldBtn.isHidden = true
                    cell.whiteBtn.isHidden = true
                    if self.product?.data.color.contains("Yellow") ?? false {
                        cell.goldBtn.isHidden = false
                        self.mycolor = "Yellow"
                    }
                    if self.product?.data.color.contains("Rose") ?? false {
                        cell.roseBtn.isHidden = false
                        self.mycolor = "Rose"
                    }
                    if self.product?.data.color.contains("White") ?? false {
                        cell.whiteBtn.isHidden = false
                        self.mycolor = "White"
                    }
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
                                        
                    return cell
                } else if indexPath.row == 1 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "sizecell") as! productSizeCell
                    
                    if self.product?.data.jwelleryType.lowercased() == "bangles" {
                        cell.lblTitle.text = "Select Size"
                        let defaultSize = self.product?.data.defaultSize
                        for i in self.product!.price.bangle {
                            if i.sizes == defaultSize {
                                cell.btnSize.setTitle(i.bangleSize, for: .normal)
                                self.productSize = i.bangleSize
                                self.defaultSize = i.bangleSize
                                self.defaultSizeBangle = i.bangleSize
                            }
                        }
                        cell.btnSize.layer.borderColor = UIColor.lightGray.cgColor
                        cell.btnSize.layer.borderWidth = 0.6
                        cell.btnSize.addTarget(self, action: #selector(selectSizeBangle(_:)), for: .touchUpInside)
                    } else if self.product?.data.jwelleryType == "Ring" {
                        cell.lblTitle.text = "Select Size"
                        cell.btnSize.setTitle(self.product?.data.defaultSize, for: .normal)
                        self.productSize = (self.product?.data.defaultSize)!
                        cell.btnSize.addTarget(self, action: #selector(selectSizeRing(_:)), for: .touchUpInside)
                    } else if self.product?.data.jwelleryType == "Chain" {
                        cell.lblTitle.text = "Select Length"
                        
                        cell.btnSize.setTitle(self.product?.data.defaultSize, for: .normal)
                        self.productSize = (self.product?.data.defaultSize)!
                        cell.btnSize.addTarget(self, action: #selector(selectSizeRing(_:)), for: .touchUpInside)
                        
                    }else {
                       
                        cell.isHidden = true
                    }
                    
                   
                    return cell
                }
                else if indexPath.row == 2 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "codecell") as! codecell
                    
                    cell.lblCode.text = self.product?.data.productcode
                    return cell
                }
                else if indexPath.row == 3 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "quantityCell") as! quantityCell
                    
                    cell.qtyLbl.text = "\(qty)"
                    cell.plusBtn.addTarget(self, action: #selector(plusBtn), for: .touchUpInside)
                    cell.minusBtn.addTarget(self, action: #selector(minusBtn), for: .touchUpInside)
                    
                    return cell
                }
            } else if indexPath.section == 1 {
               
                if self.diamondAsset[indexPath.row].certificationCost == "" || self.diamondAsset[indexPath.row].certificationCost == "0"{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "diamondCell") as! productDiamondCell
                    cell.d1Btn.isHidden = true
                    cell.d2Btn.isHidden = true
                    cell.d3Btn.isHidden = true
                    cell.d4Btn.isHidden = true
                    cell.d5Btn.isHidden = true
                    cell.d6BtnC.isHidden = true
                    
                    cell.d1Btnc.isHidden = true
                    cell.d2Btnc.isHidden = true
                    cell.d3Btnc.isHidden = true
                    cell.d4Btnc.isHidden = true
                    cell.d5Btnc.isHidden = true
                    
                    cell.diamondTypeBtn.setTitle(self.diamondAsset[indexPath.row].jwellerySize, for: .normal)
                    
                    let diamondBtn = [cell.d1Btn,cell.d2Btn,cell.d3Btn,cell.d4Btn,cell.d5Btn,cell.d6BtnC]
                    let diamondBtnC = [cell.d1Btnc,cell.d2Btnc,cell.d3Btnc,cell.d4Btnc,cell.d5Btnc]
                    
                    let diamondColor = self.diamondAsset[indexPath.row].color.components(separatedBy: ",")
                    for i in  0 ..< diamondColor.count {
                        diamondBtn[i]?.tag = indexPath.row
                        diamondBtn[i]?.isHidden = false
                        diamondBtn[i]?.setTitle(diamondColor[i], for: .normal)
                       // self.diamondColorTemp = diamondColor[i]
                        diamondBtn[i]?.addTarget(self, action: #selector(diamondColoBtn(_:)), for: .touchUpInside)
                        diamondBtn[i]?.backgroundColor = UIColor.white
                        diamondBtn[i]?.setTitleColor(.black, for: .normal)
                    }
                       
                    let diamondClarity = self.diamondAsset[indexPath.row].clarity.components(separatedBy: ",")
                    for i in  0 ..< diamondClarity.count {
                        diamondBtnC[i]?.tag = indexPath.row
                        diamondBtnC[i]?.isHidden = false
                        diamondBtnC[i]?.setTitle(diamondClarity[i], for: .normal)
                        
                        //self.diamondClarityTemp = diamondClarity[i]
                        diamondBtnC[i]?.addTarget(self, action: #selector(diamondClarityBtn(_:)), for: .touchUpInside)
                        diamondBtnC[i]?.backgroundColor = UIColor.white
                        diamondBtnC[i]?.setTitleColor(.black, for: .normal)
                    }
                    
                    //self.colorarray = []
                    let clrTemp = NSMutableArray()
                for i in 0 ..< diamondBtn.count {
                    print(diamondBtn[i]?.titleLabel?.text ?? "")
                    print(self.diamondColorTemp)
                            
                    if diamondBtn[i]?.titleLabel?.text! == self.diamondColorTemp {
                        diamondBtn[i]?.backgroundColor = UIColor.init(named: "base_color")
                        diamondBtn[i]?.setTitleColor(.white, for: .normal)
                        
                        let tempdic = ["name":diamondBtn[i]?.titleLabel?.text!,"value":"1"]
                        
                        clrTemp.add(tempdic)
                    }else {
                        let tempdic = ["name":diamondBtn[i]?.titleLabel?.text!,"value":"0"]
                        clrTemp.add(tempdic)
                    }
                }
                    
                   
                        
                    let tempdic = ["name":self.diamondAsset[indexPath.row].jwellerySize,"value":clrTemp] as [String : Any]
                    
                    if self.newcolorarray.count != 0 {
                        for i in 0..<self.newcolorarray.count {
                            let name = self.newcolorarray[i]["name"] as! String
                            if name == self.diamondAsset[indexPath.row].jwellerySize {
                                self.newcolorarray.remove(at: i)
                                self.newcolorarray.insert(tempdic, at: i)
                                break
                            }
                        }
                        
                    }else {
                        self.newcolorarray.append(tempdic)
                    }
                    
                     
                    
                    
                    
                    let clarityTemp = NSMutableArray()
                    
                    
                    
                    self.clarArr = []
                    for i in 0 ..< diamondBtnC.count {
                        let btnName = diamondBtnC[i]?.titleLabel?.text! ?? ""
                        if btnName == self.diamondClarityTemp {
                            
                            diamondBtnC[i]?.backgroundColor = UIColor.init(named: "base_color")
                            diamondBtnC[i]?.setTitleColor(.white, for: .normal)
                            let tempdic = ["name":btnName,"value":"1"]
                            clarityTemp.add(tempdic)
                        }else {
                            let tempdic = ["name":btnName,"value":"0"]
                            clarityTemp.add(tempdic)
                        }
                    }
                        if self.diamondColorTemp == "" && self.diamondClarityTemp == "" {
                            self.diamondColorTemp = diamondColor[0]
                            self.diamondClarityTemp = diamondClarity[0]
                        }
                    
                    
                    
                    let tempdic1 = ["name":self.diamondAsset[indexPath.row].jwellerySize,"value":clarityTemp] as [String : Any]
                    
                    if self.newClarityarray.count != 0 {
                        for i in 0..<self.newClarityarray.count {
                            let name = self.newClarityarray[i]["name"] as! String
                            if name == self.diamondAsset[indexPath.row].jwellerySize {
                                self.newClarityarray.remove(at: i)
                                self.newClarityarray.insert(tempdic1, at: i)
                                break
                            }
                        }
                        
                    }else {
                        self.newClarityarray.append(tempdic1)
                    }
                       
                        //MARK:- Name label
                        cell.lblName.text = self.diamondAsset[indexPath.row].jwellerySize
                    self.diaType = self.diamondAsset[indexPath.row].jwellerySize
                        //MARK:- Weight Label
                    let weight = self.diamondAsset[indexPath.row].weight.toDouble()
                    let we = String(format: "%.3f", weight)
                        cell.lblWeight.text = we + " Ct"
                        
                        //MARK:- Daimond Price
                        var diamondPrice = ""
                        for i in self.product!.price.diamondMaster {
                            if i.type == self.diamondAsset[indexPath.row].defaultColorClarity {
                                
                                if i.diamond_type == self.diamondAsset[indexPath.row].jwellerySize {
                                    diamondPrice = i.price
                                    
                                }
                                
                              
                            }
                        }
                    let daimondpr = diamondPrice.toDouble()
                    let wedaimondpr = String(format: "%.1f", daimondpr)
                        cell.lblPrice.text = "₹ " + wedaimondpr + "/ ct"
                        
                        //MARK:- No of Diamond
                    cell.lblNoDiamond.text = self.diamondAsset[indexPath.row].quantity + " pc"
                   
                        
                        //MARK:- Total Diamond
                    
                    let daitotal = PriceCalculation.shared.diamondPrice(diamondWeight: self.diamondAsset[indexPath.row].weight.toDouble(), diamondRate: diamondPrice.toDouble())
                    
                    let rateTotal = String(format: "%.2f", daitotal)
                    cell.lblDiamondTotal.text = "₹ " + rateTotal
                        
                        //MARK:- Diamond Color Clarity
                        cell.lblDiamondColorClarity.text = self.diamondAsset[indexPath.row].defaultColorClarity
                        
                        
                        cell.d1Btn.layer.borderColor = UIColor.black.cgColor
                        cell.d1Btn.layer.borderWidth = 0.5
                        cell.d1Btn.layer.cornerRadius = cell.d1Btn.frame.height / 2
                        cell.d1Btn.clipsToBounds = true
                                
                        cell.d2Btn.layer.borderColor = UIColor.black.cgColor
                        cell.d2Btn.layer.borderWidth = 0.5
                        cell.d2Btn.layer.cornerRadius = cell.d2Btn.frame.height / 2
                        cell.d2Btn.clipsToBounds = true
                                
                        cell.d3Btn.layer.borderColor = UIColor.black.cgColor
                        cell.d3Btn.layer.borderWidth = 0.5
                        cell.d3Btn.layer.cornerRadius = cell.d3Btn.frame.height / 2
                        cell.d3Btn.clipsToBounds = true
                                
                        cell.d4Btn.layer.borderColor = UIColor.black.cgColor
                        cell.d4Btn.layer.borderWidth = 0.5
                        cell.d4Btn.layer.cornerRadius = cell.d4Btn.frame.height / 2
                        cell.d4Btn.clipsToBounds = true
                                
                        cell.d5Btn.layer.borderColor = UIColor.black.cgColor
                        cell.d5Btn.layer.borderWidth = 0.5
                        cell.d5Btn.layer.cornerRadius = cell.d5Btn.frame.height / 2
                        cell.d5Btn.clipsToBounds = true
                    
                    cell.d6BtnC.layer.borderColor = UIColor.black.cgColor
                    cell.d6BtnC.layer.borderWidth = 0.5
                    cell.d6BtnC.layer.cornerRadius = cell.d5Btn.frame.height / 2
                    cell.d6BtnC.clipsToBounds = true
                            
                        cell.d1Btnc.layer.borderColor = UIColor.black.cgColor
                        cell.d1Btnc.layer.borderWidth = 0.5
                        cell.d1Btnc.layer.cornerRadius = cell.d1Btnc.frame.height / 2
                        cell.d1Btnc.clipsToBounds = true
                            
                        cell.d2Btnc.layer.borderColor = UIColor.black.cgColor
                        cell.d2Btnc.layer.borderWidth = 0.5
                        cell.d2Btnc.layer.cornerRadius = cell.d2Btnc.frame.height / 2
                        cell.d2Btnc.clipsToBounds = true
                            
                        cell.d3Btnc.layer.borderColor = UIColor.black.cgColor
                        cell.d3Btnc.layer.borderWidth = 0.5
                        cell.d3Btnc.layer.cornerRadius = cell.d3Btnc.frame.height / 2
                        cell.d3Btnc.clipsToBounds = true
                            
                        cell.d4Btnc.layer.borderColor = UIColor.black.cgColor
                        cell.d4Btnc.layer.borderWidth = 0.5
                        cell.d4Btnc.layer.cornerRadius = cell.d4Btnc.frame.height / 2
                        cell.d4Btnc.clipsToBounds = true
                            
                        cell.d5Btnc.layer.borderColor = UIColor.black.cgColor
                        cell.d5Btnc.layer.borderWidth = 0.5
                        cell.d5Btnc.layer.cornerRadius = cell.d4Btnc.frame.height / 2
                        cell.d5Btnc.clipsToBounds = true
                    
                    
                    if ispr == true {
                        
                        cell.viewPrice.isHidden = true
                        cell.viewDiaNo.isHidden = true
                        cell.viewDiaTotal.isHidden = true
                        cell.viewColCla.isHidden = true
                       
                    }else {
                        cell.viewPrice.isHidden = false
                        if self.diamondAsset[indexPath.row].quantity != "0" {
                            cell.viewDiaNo.isHidden = false
                            
                              
                        }
                        else {
                            cell.viewDiaNo.isHidden = true
                        }
                        cell.viewDiaTotal.isHidden = false
                        cell.viewColCla.isHidden = false
                    }
                    
                    return cell
                }
                let cell = tableView.dequeueReusableCell(withIdentifier: "diamondCellCertified") as! productDiamondCellCertified
                cell.d1Btn.isHidden = true
                cell.d2Btn.isHidden = true
                cell.d3Btn.isHidden = true
                cell.d4Btn.isHidden = true
                cell.d5Btn.isHidden = true
                
                cell.d1Btnc.isHidden = true
                cell.d2Btnc.isHidden = true
                cell.d3Btnc.isHidden = true
                cell.d4Btnc.isHidden = true
                cell.d5Btnc.isHidden = true
                
                let diamondBtn = [cell.d1Btn,cell.d2Btn,cell.d3Btn,cell.d4Btn,cell.d5Btn]
                let diamondBtnC = [cell.d1Btnc,cell.d2Btnc,cell.d3Btnc,cell.d4Btnc,cell.d5Btnc]
                
                
                
                cell.diamondTypeBtn.setTitle(self.diamondAsset[indexPath.row].jwellerySize, for: .normal)
            let diamondColor = self.diamondAsset[indexPath.row].color.components(separatedBy: ",")
            for i in  0 ..< diamondColor.count {
                diamondBtn[i]?.tag = indexPath.row
                diamondBtn[i]?.isHidden = false
                diamondBtn[i]?.setTitle(diamondColor[i], for: .normal)
                diamondBtn[i]?.addTarget(self, action: #selector(diamondColoBtn(_:)), for: .touchUpInside)
                diamondBtn[i]?.backgroundColor = UIColor.white
                diamondBtn[i]?.setTitleColor(.black, for: .normal)
            }
               
                let diamondClarity = self.diamondAsset[indexPath.row].clarity.components(separatedBy: ",")
                    for i in  0 ..< diamondClarity.count {
                    diamondBtnC[i]?.tag = indexPath.row
                    diamondBtnC[i]?.isHidden = false
                    diamondBtnC[i]?.setTitle(diamondClarity[i], for: .normal)
                    diamondBtnC[i]?.addTarget(self, action: #selector(diamondClarityBtn(_:)), for: .touchUpInside)
                    diamondBtnC[i]?.backgroundColor = UIColor.white
                    diamondBtnC[i]?.setTitleColor(.black, for: .normal)
                }
               
                let clrTemp = NSMutableArray()
            for i in 0 ..< diamondBtn.count {
                print(diamondBtn[i]?.titleLabel?.text ?? "")
                print(self.diamondColorTemp)
                        
                if diamondBtn[i]?.titleLabel?.text! == self.diamondColorTemp {
                    diamondBtn[i]?.backgroundColor = UIColor.init(named: "base_color")
                    diamondBtn[i]?.setTitleColor(.white, for: .normal)
                    
                    let tempdic = ["name":diamondBtn[i]?.titleLabel?.text!,"value":"1"]
                    
                    clrTemp.add(tempdic)
                }else {
                    let tempdic = ["name":diamondBtn[i]?.titleLabel?.text!,"value":"0"]
                    clrTemp.add(tempdic)
                }
            }
                
               
                    
                let tempdic = ["name":self.diamondAsset[indexPath.row].jwellerySize,"value":clrTemp] as [String : Any]
                
                if self.newcolorarray.count != 0 {
                    for i in 0..<self.newcolorarray.count {
                        let name = self.newcolorarray[i]["name"] as! String
                        if name == self.diamondAsset[indexPath.row].jwellerySize {
                            self.newcolorarray.remove(at: i)
                            self.newcolorarray.insert(tempdic, at: i)
                            break
                        }
                    }
                    
                }else {
                    self.newcolorarray.append(tempdic)
                }
                
                 
                
                
                
                let clarityTemp = NSMutableArray()
                
                
                
                self.clarArr = []
                for i in 0 ..< diamondBtnC.count {
                    let btnName = diamondBtnC[i]?.titleLabel?.text! ?? ""
                    if btnName == self.diamondClarityTemp {
                        
                        diamondBtnC[i]?.backgroundColor = UIColor.init(named: "base_color")
                        diamondBtnC[i]?.setTitleColor(.white, for: .normal)
                        let tempdic = ["name":btnName,"value":"1"]
                        clarityTemp.add(tempdic)
                    }else {
                        let tempdic = ["name":btnName,"value":"0"]
                        clarityTemp.add(tempdic)
                    }
                }
                   
                
                
                
                let tempdic1 = ["name":self.diamondAsset[indexPath.row].jwellerySize,"value":clarityTemp] as [String : Any]
                
                if self.newClarityarray.count != 0 {
                    for i in 0..<self.newClarityarray.count {
                        let name = self.newClarityarray[i]["name"] as! String
                        if name == self.diamondAsset[indexPath.row].jwellerySize {
                            self.newClarityarray.remove(at: i)
                            self.newClarityarray.insert(tempdic1, at: i)
                            break
                        }
                    }
                    
                }else {
                    self.newClarityarray.append(tempdic1)
                }
                
                
    //            for i in 0 ..< diamondBtn.count {
    //                print(diamondBtn[i]?.titleLabel?.text ?? "")
    //                print(self.diamondColorTemp)
    //
    //                if diamondBtn[i]?.titleLabel?.text! == self.diamondColorTemp {
    //                    diamondBtn[i]?.backgroundColor = UIColor.init(named: "base_color")
    //                    diamondBtn[i]?.setTitleColor(.white, for: .normal)
    //                }
    //            }
    //            if self.diamondColorTemp == "" && self.diamondClarityTemp == "" {
    //                self.diamondColorTemp = diamondColor[0]
    //                self.diamondClarityTemp = diamondClarity[0]
    //            }
    //
    //            for i in 0 ..< diamondBtnC.count {
    //                let btnName = diamondBtnC[i]?.titleLabel?.text! ?? ""
    //                print(btnName)
    //                if btnName == self.diamondClarityTemp {
    //                    diamondBtnC[i]?.backgroundColor = UIColor.init(named: "base_color")
    //                    diamondBtnC[i]?.setTitleColor(.white, for: .normal)
    //                }
    //            }
    //                if self.diamondColorTemp == "" && self.diamondClarityTemp == "" {
    //                    self.diamondColorTemp = diamondColor[0]
    //                    self.diamondClarityTemp = diamondClarity[0]
    //                }
               
                //MARK:- Name label
                cell.lblName.text = self.diamondAsset[indexPath.row].jwellerySize
                self.diaType = self.diamondAsset[indexPath.row].jwellerySize
                //MARK:- Weight Label
                cell.lblWeight.text = self.diamondAsset[indexPath.row].weight + " Ct"
                
                //MARK:- Daimond Price
                var diamondPrice = ""
                for i in self.product!.price.diamondMaster {
                    
                    if i.diamond_type == self.diamondAsset[indexPath.row].jwellerySize {
                        if i.type == self.diamondAsset[indexPath.row].defaultColorClarity {
                            if i.diamond_type == self.diamondAsset[indexPath.row].jwellerySize {
                                diamondPrice = i.price
                                
                            }
                        }
                    }
                    
                    
                }
                cell.lblPrice.text = "₹" + diamondPrice + "/ Ct"
                
                //MARK:- No of Diamond
                cell.lblNoDiamond.text = self.diamondAsset[indexPath.row].quantity + " Pc"
                
                
                //MARK:- Diamond Color Clarity
                cell.lblDiamondColorClarity.text = self.diamondAsset[indexPath.row].defaultColorClarity
                
                //MARK:- Certificate charge
                cell.lblCertificateCharges.text = self.diamondAsset[indexPath.row].certificationCost
                
                
                var certCost = 0.0
                if self.diamondAsset[indexPath.row].crtcostOption == "PerCarat" {
                    //MARK:- Certificate charge
                    cell.lblCertificateCharges.text = "₹" + self.diamondAsset[indexPath.row].certificationCost + " /Ct"
                    
                    
                    certCost = self.diamondAsset[indexPath.row].weight.toDouble() * self.diamondAsset[indexPath.row].certificationCost.toDouble()
                } else if self.diamondAsset[indexPath.row].crtcostOption == "Fixed" {
                    //MARK:- Certificate charge
                    cell.lblCertificateCharges.text = "₹" + self.diamondAsset[indexPath.row].certificationCost
                    
                    certCost = self.diamondAsset[indexPath.row].certificationCost.toDouble()
                }
                
                //MARK:- Total Certification Charge
                cell.lblTotalCertificateCharges.text = "₹ " + certCost.toString()
                
                //MARK:- Total Diamond
                cell.lblDiamondTotal.text = "₹ " + (PriceCalculation.shared.diamondPrice(diamondWeight: self.diamondAsset[indexPath.row].weight.toDouble(), diamondRate: diamondPrice.toDouble()) + certCost).toString()
                
                cell.d1Btn.layer.borderColor = UIColor.black.cgColor
                cell.d1Btn.layer.borderWidth = 0.5
                cell.d1Btn.layer.cornerRadius = cell.d1Btn.frame.height / 2
                cell.d1Btn.clipsToBounds = true
                        
                cell.d2Btn.layer.borderColor = UIColor.black.cgColor
                cell.d2Btn.layer.borderWidth = 0.5
                cell.d2Btn.layer.cornerRadius = cell.d2Btn.frame.height / 2
                cell.d2Btn.clipsToBounds = true
                        
                cell.d3Btn.layer.borderColor = UIColor.black.cgColor
                cell.d3Btn.layer.borderWidth = 0.5
                cell.d3Btn.layer.cornerRadius = cell.d3Btn.frame.height / 2
                cell.d3Btn.clipsToBounds = true
                        
                cell.d4Btn.layer.borderColor = UIColor.black.cgColor
                cell.d4Btn.layer.borderWidth = 0.5
                cell.d4Btn.layer.cornerRadius = cell.d4Btn.frame.height / 2
                cell.d4Btn.clipsToBounds = true
                        
                cell.d5Btn.layer.borderColor = UIColor.black.cgColor
                cell.d5Btn.layer.borderWidth = 0.5
                cell.d5Btn.layer.cornerRadius = cell.d5Btn.frame.height / 2
                cell.d5Btn.clipsToBounds = true
                    
                cell.d1Btnc.layer.borderColor = UIColor.black.cgColor
                cell.d1Btnc.layer.borderWidth = 0.5
                cell.d1Btnc.layer.cornerRadius = cell.d1Btnc.frame.height / 2
                cell.d1Btnc.clipsToBounds = true
                    
                cell.d2Btnc.layer.borderColor = UIColor.black.cgColor
                cell.d2Btnc.layer.borderWidth = 0.5
                cell.d2Btnc.layer.cornerRadius = cell.d2Btnc.frame.height / 2
                cell.d2Btnc.clipsToBounds = true
                    
                cell.d3Btnc.layer.borderColor = UIColor.black.cgColor
                cell.d3Btnc.layer.borderWidth = 0.5
                cell.d3Btnc.layer.cornerRadius = cell.d3Btnc.frame.height / 2
                cell.d3Btnc.clipsToBounds = true
                    
                cell.d4Btnc.layer.borderColor = UIColor.black.cgColor
                cell.d4Btnc.layer.borderWidth = 0.5
                cell.d4Btnc.layer.cornerRadius = cell.d4Btnc.frame.height / 2
                cell.d4Btnc.clipsToBounds = true
                    
                cell.d5Btnc.layer.borderColor = UIColor.black.cgColor
                cell.d5Btnc.layer.borderWidth = 0.5
                cell.d5Btnc.layer.cornerRadius = cell.d4Btnc.frame.height / 2
                cell.d5Btnc.clipsToBounds = true
                
                if ispr == true {
                    
                    cell.viewPrice.isHidden = true
                    cell.viewDiaNo.isHidden = true
                    cell.viewDiaTotal.isHidden = true
                    cell.viewColcla.isHidden = true
                    cell.viewCertTotal.isHidden = true
                    cell.viewCertCharge.isHidden = true
                   
                }else {
                    cell.viewPrice.isHidden = false
                    cell.viewDiaNo.isHidden = false
                    cell.viewDiaTotal.isHidden = false
                    cell.viewColcla.isHidden = false
                    cell.viewCertTotal.isHidden = false
                    cell.viewCertCharge.isHidden = false
                }
                
                
                return cell
            } else if indexPath.section == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "goldCell") as! GoldDetailCell
                cell.k12Btn.isHidden = true
                cell.k18Btn.isHidden = true
                cell.k8Btn.isHidden = true
                cell.k16Btn.isHidden = true
                let btnArr = [cell.k8Btn,cell.k12Btn,cell.k16Btn,cell.k18Btn]
                
                for i in 0 ..< self.goldAsset.count {
                    
                    btnArr[i]?.isHidden = false
                    btnArr[i]?.setTitle(self.goldAsset[i].jwellerySize, for: .normal)
                    btnArr[i]?.addTarget(self, action: #selector(goldSelect(_:)), for: .touchUpInside)
                    btnArr[i]?.backgroundColor = UIColor.white
                    btnArr[i]?.setTitleColor(.black, for: .normal)
                }
                if self.goldAsset.count > 0 {
                    for i in btnArr {
                        if i?.titleLabel?.text == self.goldAsset[self.selectedIndGold].jwellerySize {
                            i?.backgroundColor = UIColor.init(named: "base_color")
                            i?.setTitleColor(.white, for: .normal)
                            self.selectedgoldtype = (i?.titleLabel?.text)!
                            //self.defualttype = (0.titleLabel?.text)!
                        }
                    }
                }
                
                cell.k12Btn.layer.borderColor = UIColor.black.cgColor
                cell.k12Btn.layer.borderWidth = 1
                cell.k12Btn.layer.cornerRadius = cell.k12Btn.frame.height / 2
                cell.k12Btn.clipsToBounds = true
                    
                cell.k18Btn.layer.borderColor = UIColor.black.cgColor
                cell.k18Btn.layer.borderWidth = 1
                cell.k18Btn.layer.cornerRadius = cell.k18Btn.frame.height / 2
                cell.k18Btn.clipsToBounds = true
                    
                cell.k8Btn.layer.borderColor = UIColor.black.cgColor
                cell.k8Btn.layer.borderWidth = 1
                cell.k8Btn.layer.cornerRadius = cell.k8Btn.frame.height / 2
                cell.k8Btn.clipsToBounds = true
                    
                cell.k16Btn.layer.borderColor = UIColor.black.cgColor
                cell.k16Btn.layer.borderWidth = 1
                cell.k16Btn.layer.cornerRadius = cell.k16Btn.frame.height / 2
                cell.k16Btn.clipsToBounds = true
                
                
                cell.producCodeLbl.text = self.product?.data.productcode
                
                //MARK:- Value In Calc
                var valueIn = ""
                
                print(self.goldAsset.count)
                if self.goldAsset.count > 0 {
                    let goldType = self.goldAsset[self.selectedIndGold].jwellerySize
                    for i in self.product!.price.gold {
                        if goldType == i.type {
                            print(i.valueIn)
                            let type = String(format: "%.2f", i.valueIn.toDouble())
                            cell.goldPurityLbl.text = type + "%"
                            valueIn = i.valueIn
                        }
                    }
                }
                    
                
                
               
                
                //MARK:- Net Gold Weight
                let netgold = Double(self.goldAsset[self.selectedIndGold].weight)
                
                let netgoldy = String(format: "%.3f", netgold!)
                cell.netGoldWeightLbl.text = netgoldy + " g"
                
                if ispr == true {
                    
                    cell.viewNetGoldWeight.isHidden = true
                }else {
                    cell.viewNetGoldWeight.isHidden = false
                }
                
                //MARK:- Gold Making Charge
                
                let Making = Double(self.goldAsset[self.selectedIndGold].makingCharge)
                
                if Making != 0 {
                    cell.viewMakingCharge.isHidden = false
                     cell.viewTotalMakingCharge.isHidden = false
                    let Makingy = String(format: "%.1f", Making!)
                    cell.goldMakingChargeLbl.text = "₹ " + Makingy + "/ g"
                    
                    if ispr == true {
                        
                        cell.viewMakingCharge.isHidden = true
                    }else {
                        cell.viewMakingCharge.isHidden = false
                    }
                    
                }else {
                    cell.viewTotalMakingCharge.isHidden = true
                    cell.viewMakingCharge.isHidden = true
                }
                
                var  wastage = Double(self.goldAsset[self.selectedIndGold].wastage)
                if wastage == nil {
                    wastage = 0
                }
                if wastage != 0 {
                    cell.viewGoldWastage.isHidden = false
                    let wastagey = String(format: "%.1f", wastage!)
                    cell.lblWastage.text = wastagey + " %"
                    
                    if ispr == true {
                        
                        cell.viewGoldWastage.isHidden = true
                    }else {
                        cell.viewGoldWastage.isHidden = false
                    }
                    
                }else {
                    cell.viewGoldWastage.isHidden = true
                }
                
                let value = valueIn.toDouble()
                let mainweight = netgoldy.toDouble()
                var was = wastage
                
                if self.goldAsset[self.selectedIndGold].chargesOption == "Percentage" {
                    was = self.goldAsset[self.selectedIndGold].makingCharge.toDouble()
                }
                
                
                
                let fineWeight = mainweight * (value+was!) / 100
                //MARK:- Fine Gold Weight
            //    let purity = fineWeight.toDouble() / 100
                let finew = String(format: "%.3f", fineWeight)
                cell.fineGoldWeightlbl.text = finew + " g"
                
                //MARK:- Fine Gold Rate
                var goldRate = 0.0
                var mainrate = 0.0
                for i in self.product!.price.gold {
                    print(i.price)
                    if i.type == "24KT" {
                        print(i.price)
                        let rate = String(format: "%.2f", i.price.toDouble())
                        cell.fineGoldRateLbl.text = "₹ " + rate + " / g"
                        mainrate = rate.toDouble()
                        goldRate = i.price.toDouble()
                    }
                }
                
                //MARK:- Meena Cost
                var finalMeenaCost = 0.0
                if self.goldAsset[self.selectedIndGold].meenacostOption == "PerGram" {
                    let meenaCost = PriceCalculation.shared.MeenaCost(meenaRate: self.goldAsset[self.selectedIndGold].meenaCost.toDouble(), weight: self.goldAsset[self.selectedIndGold].weight.toDouble(), isPergram: true)
                    finalMeenaCost = meenaCost
                } else if self.goldAsset[self.selectedIndGold].meenacostOption == "Fixed" {
                    let meenaCost = PriceCalculation.shared.MeenaCost(meenaRate: self.goldAsset[self.selectedIndGold].meenaCost.toDouble(), weight: self.goldAsset[self.selectedIndGold].weight.toDouble(), isPergram: false)
                    finalMeenaCost = meenaCost
                }
                
                //MARK:- MakingCharges
                var makingCharge = 0.0
                if self.goldAsset[self.selectedIndGold].chargesOption == "PerGram" {
                   makingCharge = PriceCalculation.shared.goldMakingCharge(goldWeight: self.goldAsset[self.selectedIndGold].weight.toDouble(), makingTypeFixed: false, makingChargeRate: self.goldAsset[self.selectedIndGold].makingCharge.toDouble())
                    cell.viewTotalMakingCharge.isHidden = false
                } else if self.goldAsset[self.selectedIndGold].chargesOption == "Fixed" {
                    makingCharge = PriceCalculation.shared.goldMakingCharge(goldWeight: self.goldAsset[self.selectedIndGold].weight.toDouble(), makingTypeFixed: true, makingChargeRate: self.goldAsset[self.selectedIndGold].makingCharge.toDouble())
                    cell.viewTotalMakingCharge.isHidden = false
                }else {
                    
                    let value = valueIn.toDouble()
                    let mainweight = netgoldy.toDouble()
                    let was = self.goldAsset[self.selectedIndGold].makingCharge.toDouble()
                    makingCharge = mainweight * (value+was) / 100
                    cell.viewTotalMakingCharge.isHidden = true
                    cell.lblMakingTitle.text = "Gold wastage"
                    
                }
                
                //MARK:- Total Making Charge
                let totalMakingCharge = self.goldAsset[self.selectedIndGold].makingCharge.toDouble() * self.goldAsset[self.selectedIndGold].weight.toDouble()
                let maintotalMakingCharge = String(format: "%.2f", totalMakingCharge)
                
                cell.totalMakingChargelbl.text = "₹ " + maintotalMakingCharge
                
                if totalMakingCharge == 0 {
                    cell.viewTotalMakingCharge.isHidden = true
                }
                //MARK:- Total Amount
                var totalmain = Double()
                
                if self.goldAsset[self.selectedIndGold].chargesOption == "Percentage" {
                    totalmain = (PriceCalculation.shared.goldPrice(goldRate: mainrate, goldweight: netgoldy.toDouble(), goldPurity: valueIn.toDouble(), goldWastage: was!) + finalMeenaCost)
                }else {
                    totalmain = (PriceCalculation.shared.goldPrice(goldRate: mainrate, goldweight: netgoldy.toDouble(), goldPurity: valueIn.toDouble(), goldWastage: was!) + finalMeenaCost + makingCharge)
                }

                
                
                 
                let stotalmain = String(format: "%.3f", totalmain)
                
                let numberFormatter = NumberFormatter()
                numberFormatter.minimumFractionDigits = 2
                numberFormatter.maximumFractionDigits = 2
                numberFormatter.roundingMode = .down
                let str = numberFormatter.string(from: NSNumber(value: totalmain))
               // let str2 = numberFormatter.string(from: NSNumber(value: num2))
                
                
                cell.totalAmount.text = "₹ " + str!
                
                if ispr == true {
                    
                    cell.viewTotalAmount.isHidden = true
              
                    cell.viewPurity.isHidden = true
                    cell.viewFineGoldRate.isHidden = true
                    cell.viewFineGoldWeight.isHidden = true
                }else {
                    cell.viewTotalAmount.isHidden = false
                   
                    cell.viewPurity.isHidden = false
                    cell.viewFineGoldRate.isHidden = false
                    cell.viewFineGoldWeight.isHidden = false
                }
                
                
                
                return cell
            } else if indexPath.section == 3 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "stoneCell") as! productStoneCell
                
                
                if self.arrFinalStone[indexPath.row]["stoneInside"] == nil {
                    cell.downArrow.isHidden  = true
                    cell.btnStoneType.isUserInteractionEnabled = false
                    cell.btnStoneType.layer.borderWidth = 1.0
                    cell.btnStoneType.layer.borderColor = UIColor.darkGray.cgColor
                    cell.btnStoneType.setTitle(self.arrFinalStone[indexPath.row]["jwellerySize"] as! String, for: .normal)
                    
                    
                    if self.arrFinalStone[indexPath.row]["quantity"] as! String == "0" ||  self.arrFinalStone[indexPath.row]["quantity"] as! String == "" {
                        cell.viewMain.isHidden = true
                        
                    }else {
                        cell.viewMain.isHidden = false
                    }
                    
                    cell.lblNoOfStone.text = self.arrFinalStone[indexPath.row]["quantity"] as! String + " Pc"
                    let we = self.arrFinalStone[indexPath.row]["weight"] as! String
                    let ston = String(format: "%.3f", we.toDouble())
                               cell.lblStoneWeight.text = ston + " Ct"
                   
                               var stonRate = ""
                               for i in self.product!.price.stone {
                                   if i.type == (self.arrFinalStone[indexPath.row]["jwellerySize"] as! String).uppercased() {
                                       stonRate = i.price
                                   }
                               }
                               let stonrat = String(format: "%.1f", stonRate.toDouble())
                               cell.lblStonePrice.text = stonrat + "/ Ct"
                               stonRate = stonrat
                   
                                
                               let stonratotal = String(format: "%.2f", (stonRate.toDouble() * we.toDouble()))
                   
                   
                               cell.lblStoneTotal.text = "₹ " + stonratotal
                    
                    
                    
                }else {
                    cell.downArrow.isHidden  = false
                    cell.btnStoneType.tag = indexPath.row
                    cell.btnStoneType.isUserInteractionEnabled = true
                    cell.btnStoneType.addTarget(self, action: #selector(selectStone(_:)), for: .touchUpInside)
                    let arrmain = self.arrFinalStone[indexPath.row]["stoneInside"] as! [[String:Any]]
                    
                    cell.btnStoneType.setTitle(arrmain[0]["jwellerySize"] as! String, for: .normal)
                    if arrmain[0]["quantity"] as! String == "0" ||  arrmain[0]["quantity"] as! String == "" {
                        cell.viewMain.isHidden = true
                        
                    }else {
                        cell.viewMain.isHidden = false
                    }
                    cell.lblNoOfStone.text = arrmain[0]["quantity"] as! String + " Pc"
                    let we = arrmain[0]["weight"] as! String
                    let ston = String(format: "%.3f", we.toDouble())
                               cell.lblStoneWeight.text = ston + " Ct"
                   
                               var stonRate = ""
                               for i in self.product!.price.stone {
                                   if i.type == (arrmain[0]["jwellerySize"] as! String).uppercased() {
                                       stonRate = i.price
                                   }
                               }
                               let stonrat = String(format: "%.1f", stonRate.toDouble())
                               cell.lblStonePrice.text = stonrat + "/ Ct"
                               stonRate = stonrat
                   
                                
                               let stonratotal = String(format: "%.2f", (stonRate.toDouble() * we.toDouble()))
                   
                   
                               cell.lblStoneTotal.text = "₹ " + stonratotal
                    
                }
                
                
                if ispr == true {
                    
                    cell.viewRate.isHidden = true
                    cell.viewTot.isHidden = true
                    
                   
                }else {
                    cell.viewRate.isHidden = false
                    cell.viewTot.isHidden = false
                }
    //            cell.btnStoneType.setTitle(self.stoneAsset[indexPath.row].jwellerySize, for: .normal)
    //
    //
    //            cell.lblNoOfStone.text = self.stoneAsset[indexPath.row].quantity + " Pc"
    //
    //            let ston = String(format: "%.3f", self.stoneAsset[indexPath.row].weight.toDouble())
    //            cell.lblStoneWeight.text = ston + " Ct"
    //
    //            var stonRate = ""
    //            for i in self.product!.price.stone {
    //                if i.type == self.stoneAsset[indexPath.row].jwellerySize.uppercased() {
    //                    stonRate = i.price
    //                }
    //            }
    //            let stonrat = String(format: "%.1f", stonRate.toDouble())
    //            cell.lblStonePrice.text = stonrat + "/ Ct"
    //            stonRate = stonrat
    //
    //
    //            let stonratotal = String(format: "%.2f", (stonRate.toDouble() * self.stoneAsset[indexPath.row].weight.toDouble()))
    //
    //
    //            cell.lblStoneTotal.text = "₹ " + stonratotal
                return cell
            } else if indexPath.section == 4 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "platinumCell") as! productPlatinumCell
                
                //MARK:- Product Code
                cell.lblProdcutCode.text = "  " + (self.product?.data.productcode)!
                
                //MARK:- Platinum Price
                let price = self.product?.price.platinum[0].price
                let pricetot = String(format: "%.2f", price?.toDouble() as! CVarArg)
                cell.lblPlatinumPrice.text = "  " + "₹ " + pricetot + " /g"
                
                //MARK:- Platinum weight
                let weight = self.platinumAsset[indexPath.row].weight
                let weighttot = String(format: "%.3f", weight.toDouble() as! CVarArg)
                cell.lblPlatinumWeight.text = "  " + weighttot + " g"
                
                //MARK:- Platinum Purity
                cell.lblPlatinumPurity.text = "  " + self.platinumAsset[indexPath.row].purity + "%"
                
                //MARK:- Platinum Wastage
                
                
                let wastage = self.platinumAsset[indexPath.row].wastage
                
                if wastage == "" || wastage == "<null>"{
                    cell.viewastage.isHidden = true
                }else {
                    cell.viewastage.isHidden = false
                    cell.lblPlatinumWasteage.text = "  " + self.platinumAsset[indexPath.row].wastage + "%"
                    
                    if self.ispr == true {
                        cell.viewastage.isHidden = true
                    }else {
                        cell.viewastage.isHidden = false
                    }
                }
                
                
                //MARK:- Platinum Makig Charge
                let smakingCharge = self.platinumAsset[indexPath.row].makingCharge
                let smakingChargetot = String(format: "%.2f", smakingCharge.toDouble() as! CVarArg)
                cell.lblPlatinumMakingCharge.text = "  " + "₹ " + smakingChargetot + " /g"
                
                //MARK:- Total Making Charge
                var makingCharge = 0.0
                var totalweight = 0.0
                if ischange == false {
                     totalweight = sizeCalculation(selectedSize: Int((self.product?.data.defaultSize)!)!, weight: self.platinumAsset[indexPath.row].weight.toDouble())
                }else {
                    totalweight = self.platinumAsset[indexPath.row].weight.toDouble()
                }
                
                
                
                if self.platinumAsset[indexPath.row].chargesOption == "PerGram" {
                    makingCharge = PriceCalculation.shared.platinumMaking(weight: totalweight, rate: self.platinumAsset[indexPath.row].makingCharge.toDouble(), isPerGram: true)
                } else if self.platinumAsset[indexPath.row].chargesOption == "Fixed" || self.platinumAsset[indexPath.row].chargesOption == "PerPiece" {
                    makingCharge = PriceCalculation.shared.platinumMaking(weight: self.platinumAsset[indexPath.row].weight.toDouble(), rate: self.platinumAsset[indexPath.row].makingCharge.toDouble(), isPerGram: false)
                }
                
                //MARK:- Meena Cost
                var finalMeenaCost = 0.0
                if self.platinumAsset[indexPath.row].meenacostOption == "PerGram" {
                    let meenaCost = PriceCalculation.shared.MeenaCost(meenaRate: self.platinumAsset[indexPath.row].meenaCost.toDouble(), weight: self.platinumAsset[indexPath.row].weight.toDouble(), isPergram: true)
                    finalMeenaCost = meenaCost
                } else if self.platinumAsset[indexPath.row].meenacostOption == "Fixed" {
                    let meenaCost = PriceCalculation.shared.MeenaCost(meenaRate: self.platinumAsset[indexPath.row].meenaCost.toDouble(), weight: self.platinumAsset[indexPath.row].weight.toDouble(), isPergram: false)
                    finalMeenaCost = meenaCost
                }
                
                cell.lblTotalMakingCharge.text = "  " + "₹ " + makingCharge.toString()
                
                //MARK:- Platinum Total
                let tot = (PriceCalculation.shared.platinumPrice(weight: totalweight, rate: (self.product?.price.platinum[0].price.toDouble())!, wastage: self.platinumAsset[indexPath.row].wastage.toDouble(), purity: self.platinumAsset[indexPath.row].purity.toDouble())) + makingCharge + finalMeenaCost
                let plate = String(format: "%.2f", tot)
               
                
                cell.lblPlatinumTotal.text = "  " + "₹ " + plate
                
                if self.ispr == true {
                    cell.viewPrice.isHidden = true
                    cell.viewPurity.isHidden = true
                    cell.viewWeigh.isHidden = true
                    cell.viewMaking.isHidden = true
                    cell.viewTotalMakingCharge.isHidden = true
                    cell.viewMakingCharge.isHidden = true
                }else {
                    cell.viewPrice.isHidden = false
                    
                    cell.viewPurity.isHidden = false
                    cell.viewWeigh.isHidden = false
                    cell.viewMaking.isHidden = false
                    cell.viewTotalMakingCharge.isHidden = false
                    cell.viewMakingCharge.isHidden = false
                }
                
                
                return cell
            } else if indexPath.section == 5 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "silverCell") as! productSilverCell
                
                
                
                cell.btn1.isHidden = true
                cell.btn2.isHidden = true
                cell.btn3.isHidden = true
                cell.btn4.isHidden = true
                let btnArr = [cell.btn1,cell.btn2,cell.btn3,cell.btn4]
                
                for i in 0 ..< self.silverAsset.count {
                    
                    btnArr[i]?.isHidden = false
                    btnArr[i]?.setTitle(self.silverAsset[i].jwellerySize, for: .normal)
                    btnArr[i]?.addTarget(self, action: #selector(goldSelect(_:)), for: .touchUpInside)
                    btnArr[i]?.backgroundColor = UIColor.white
                    btnArr[i]?.setTitleColor(.black, for: .normal)
                }
                if self.silverAsset.count > 0 {
                    for i in btnArr {
                        if i?.titleLabel?.text == self.silverAsset[self.selectedIndSilver].jwellerySize {
                            i?.backgroundColor = UIColor.init(named: "base_color")
                            i?.setTitleColor(.white, for: .normal)
                            self.selectedsilvertype = (i?.titleLabel?.text)!
                            //self.defualttype = (0.titleLabel?.text)!
                        }
                    }
                }
                
                cell.btn1.layer.borderColor = UIColor.black.cgColor
                cell.btn1.layer.borderWidth = 1
                cell.btn1.layer.cornerRadius = cell.btn1.frame.height / 2
                cell.btn1.clipsToBounds = true
                    
                cell.btn2.layer.borderColor = UIColor.black.cgColor
                cell.btn2.layer.borderWidth = 1
                cell.btn2.layer.cornerRadius = cell.btn2.frame.height / 2
                cell.btn2.clipsToBounds = true
                    
                cell.btn3.layer.borderColor = UIColor.black.cgColor
                cell.btn3.layer.borderWidth = 1
                cell.btn3.layer.cornerRadius = cell.btn3.frame.height / 2
                cell.btn3.clipsToBounds = true
                    
                cell.btn4.layer.borderColor = UIColor.black.cgColor
                cell.btn4.layer.borderWidth = 1
                cell.btn4.layer.cornerRadius = cell.btn4.frame.height / 2
                cell.btn4.clipsToBounds = true
                
                
                cell.lblProductCode.text = "  " + (self.product?.data.productcode)!
                cell.viewCode.isHidden = true
                
                let price = self.product?.price.silver[0].price
                let pricetot = String(format: "%.2f", price?.toDouble() as! CVarArg)
                cell.lblRate.text =  "₹ " + pricetot + " /g"
                                
                                //MARK:- Value In Calc
                                var valueIn = ""
                                
                                print(self.silverAsset.count)
                                if self.silverAsset.count > 0 {
                                    let goldType = self.silverAsset[self.selectedIndSilver].jwellerySize
                                    for i in self.product!.price.silver {
                                        if goldType == i.type {
                                            print(i.valueIn)
                                            let type = String(format: "%.2f", i.valueIn.toDouble())
                                            cell.lblPurity.text = type + "%"
                                            valueIn = i.valueIn
                                        }
                                    }
                                }
                                    
                                
                                
                               
                                
                                //MARK:- Net Gold Weight
                                let netgold = Double(self.silverAsset[self.selectedIndSilver].weight)
                                
                                let netgoldy = String(format: "%.3f", netgold!)
                                cell.lblWeight.text = netgoldy + " g"
                                
                                if ispr == true {
                                    
                                    cell.viewWeight.isHidden = true
                                }else {
                                    cell.viewWeight.isHidden = false
                                }
                                
                                //MARK:- Gold Making Charge
                                
                                let Making = Double(self.silverAsset[self.selectedIndSilver].makingCharge)
                                
                                if Making != 0 {
                                    cell.viewMaking.isHidden = false
                                     cell.viewTotalMaking.isHidden = false
                                    let Makingy = String(format: "%.1f", Making!)
                                    cell.lblSilverMakingCharge.text = "₹ " + Makingy + "/ g"
                                    
                                    if ispr == true {
                                        
                                        cell.viewMaking.isHidden = true
                                    }else {
                                        cell.viewMaking.isHidden = false
                                    }
                                    
                                }else {
                                    cell.viewTotalMaking.isHidden = true
                                    cell.viewMaking.isHidden = true
                                }
                                
                                var  wastage = Double(self.silverAsset[self.selectedIndSilver].wastage)
                                if wastage == nil {
                                    wastage = 0
                                }
                                if wastage != 0 {
                                    cell.viewWastage.isHidden = false
                                    let wastagey = String(format: "%.1f", wastage!)
                                    cell.lblWastage.text = wastagey + " %"
                                    
                                    if ispr == true {
                                        
                                        cell.viewWastage.isHidden = true
                                    }else {
                                        cell.viewWastage.isHidden = false
                                    }
                                    
                                }else {
                                    cell.viewWastage.isHidden = true
                                }
                                
                                let value = valueIn.toDouble()
                                let mainweight = netgoldy.toDouble()
                                let was = wastage
                                let fineWeight = mainweight * (value+was!) / 100
                                //MARK:- Fine Gold Weight
                            //    let purity = fineWeight.toDouble() / 100
                                let finew = String(format: "%.3f", fineWeight)
                                cell.lblFineSilverWeight.text = finew + " g"
                                
                                //MARK:- Fine Gold Rate
                                var goldRate = 0.0
                                var mainrate = 0.0
                                for i in self.product!.price.silver {
                                    print(i.price)
                                    if i.type == "1000" {
                                        print(i.price)
                                        let rate = String(format: "%.2f", i.price.toDouble())
                                        cell.lblFineSilverRate.text = "₹ " + rate + " / g"
                                        mainrate = rate.toDouble()
                                        goldRate = i.price.toDouble()
                                    }
                                }
                                
                                //MARK:- Meena Cost
                                var finalMeenaCost = 0.0
                                if self.silverAsset[self.selectedIndSilver].meenacostOption == "PerGram" {
                                    cell.lblChargeType.text = "PerGram"
                                    let meenaCost = PriceCalculation.shared.MeenaCost(meenaRate: self.silverAsset[self.selectedIndSilver].meenaCost.toDouble(), weight: self.silverAsset[self.selectedIndSilver].weight.toDouble(), isPergram: true)
                                    finalMeenaCost = meenaCost
                                } else if self.silverAsset[self.selectedIndSilver].meenacostOption == "Fixed" {
                                    cell.lblChargeType.text = "Fixed"
                                    let meenaCost = PriceCalculation.shared.MeenaCost(meenaRate: self.silverAsset[self.selectedIndSilver].meenaCost.toDouble(), weight: self.silverAsset[self.selectedIndSilver].weight.toDouble(), isPergram: false)
                                    finalMeenaCost = meenaCost
                                }
                                
                                //MARK:- MakingCharges
                                var makingCharge = 0.0
                
                                if self.silverAsset[self.selectedIndSilver].chargesOption == "PerGram" {
                                    
                                    makingCharge = PriceCalculation.shared.silverMaking(weight: self.silverAsset[self.selectedIndSilver].weight.toDouble(), rate: self.silverAsset[self.selectedIndSilver].makingCharge.toDouble(), isPergram: true)
                                    
                        
                                } else if self.silverAsset[self.selectedIndSilver].chargesOption == "Fixed" {
                                    
                                    makingCharge = PriceCalculation.shared.silverMaking(weight: self.silverAsset[self.selectedIndSilver].weight.toDouble(), rate: self.silverAsset[self.selectedIndSilver].makingCharge.toDouble(), isPergram: false)
                                    
                                   
                                }
                                
                                //MARK:- Total Making Charge
                let totalMakingCharge = self.silverAsset[self.selectedIndSilver].makingCharge.toDouble() * netgoldy.toDouble()
                                let maintotalMakingCharge = String(format: "%.2f", totalMakingCharge)
                                
                                cell.lblSilverPrice.text = "₹ " + maintotalMakingCharge
                                
                                //MARK:- Total Amount
                
                
                let totalmain = (PriceCalculation.shared.silverPrice(weight: netgoldy.toDouble(), rate: mainrate, wastage: self.silverAsset[self.selectedIndSilver].wastage.toDouble() + finalMeenaCost, purity: valueIn.toDouble()))
                
                
                                
                                
                                let stotalmain = String(format: "%.3f", totalmain + totalMakingCharge)
                                
                                let numberFormatter = NumberFormatter()
                                numberFormatter.minimumFractionDigits = 2
                                numberFormatter.maximumFractionDigits = 2
                                numberFormatter.roundingMode = .down
                               // let str = numberFormatter.string(from: NSNumber(value: stotalmain))
                               // let str2 = numberFormatter.string(from: NSNumber(value: num2))
                                
                                
                cell.lblSilverTotal.text = "₹ " + stotalmain
                
                
                
                if self.ispr == true {
                    cell.viewMaking.isHidden = true
                    cell.viewPurity.isHidden = true
                    cell.viewRate.isHidden = true
                    cell.viewTotalMaking.isHidden = true
                    cell.viewWeight.isHidden = true
                    cell.viewTotal.isHidden = true
                    
                    
                    cell.viewFineSilverWeight.isHidden = true
                    cell.viewFineSIlverRate.isHidden = true
                }else {
                    cell.viewMaking.isHidden = false
                    cell.viewPurity.isHidden = false
                    cell.viewRate.isHidden = false
                    cell.viewTotalMaking.isHidden = false
                    cell.viewWeight.isHidden = false
                    cell.viewTotal.isHidden = false
                    
                    cell.viewFineSilverWeight.isHidden = false
                    cell.viewFineSIlverRate.isHidden = false
                }
                cell.viewPurity.isHidden = true
                cell.viewFineSIlverRate.isHidden = true
                
                return cell
                
                
            
            } else if indexPath.section == 6 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "certifiedByCell") as! productCertifiedByCell
                cell.img1.isHidden = true
                cell.img2.isHidden = true
                cell.img3.isHidden = true
                
                var imgArr = [cell.img1,cell.img2,cell.img3]
                for i in 0 ..< self.product!.certification.count {
                    imgArr[i]?.isHidden = false
                    imgArr[i]?.kf.indicatorType = .activity
                    imgArr[i]?.kf.setImage(with: URL(string: self.product!.certification[i].image),placeholder: nil,options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
                        switch result {
                        case .success(let value):
                            print("Task done for: \(value.source.url?.absoluteString ?? "")")
                            
                        case .failure(let error):
                            print("Job failed: \(error.localizedDescription)")
                            
                        }
                    }
                }
                return cell
            } else if indexPath.section == 7 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "manufactureCell") as! productManufactureByCell
                cell.lbl1.numberOfLines = 0
                cell.img.kf.indicatorType = .activity
                print(self.manufactureURL)
                
                var urlString = self.product?.manufacture.logo.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                cell.img.kf.setImage(with: URL(string: (urlString)!),placeholder: nil,options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
                    switch result {
                    case .success(let value):
                        print("Task done for: \(value.source.url?.absoluteString ?? "")")
                                       
                    case .failure(let error):
                        print("Job failed: \(error.localizedDescription)")
                    }
                }
                cell.lbl1.text = self.product?.manufacture.companyName
                return cell
            } else if indexPath.section == 8 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "descriptionCell") as! productOtherDetailsCell
                cell.txtDetails.attributedText = self.product?.data.dataDescription.convertHtml(str: (self.product?.data.dataDescription)!)
                return cell
            } else if indexPath.section == 9 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "priceCell") as! productPriceCell
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    cell.lblTotalPrice.text = "₹ " + self.calculateTotalPrice()
                    var sentence = self.productCode.text
                    let wordToRemove = "Gross weight :"
                    if let range = sentence!.range(of: wordToRemove) {
                        sentence!.removeSubrange(range)
                        cell.lblGrossWe.text = sentence
                    }

                    
                }
                
                if ispr == true {
                   // cell.lblToTtitle.isHidden = true
                    cell.lblTotalPrice.isHidden = true
                }else {
                   // cell.lblToTtitle.isHidden = false
                    cell.lblTotalPrice.isHidden = false
                }
                
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            return cell!
        }
        else if self.prodType == "PLATINUM JEWELLERY" {
            if indexPath.section == 0 {
                if indexPath.row == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "colorCell") as! productColorCell
                    cell.roseBtn.isHidden = true
                    cell.goldBtn.isHidden = true
                    cell.whiteBtn.isHidden = true
                    if self.product?.data.color.contains("Yellow") ?? false {
                        cell.goldBtn.isHidden = false
                        self.mycolor = "Yellow"
                    }
                    if self.product?.data.color.contains("Rose") ?? false {
                        cell.roseBtn.isHidden = false
                        self.mycolor = "Rose"
                    }
                    if self.product?.data.color.contains("White") ?? false {
                        cell.whiteBtn.isHidden = false
                        self.mycolor = "White"
                    }
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
                                        
                    return cell
                } else if indexPath.row == 1 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "sizecell") as! productSizeCell
                    
                    if self.product?.data.jwelleryType.lowercased() == "bangles" {
                        cell.lblTitle.text = "Select Size"
                        let defaultSize = self.product?.data.defaultSize
                        for i in self.product!.price.bangle {
                            if i.sizes == defaultSize {
                                cell.btnSize.setTitle(i.bangleSize, for: .normal)
                                self.productSize = i.bangleSize
                                self.defaultSize = i.bangleSize
                                self.defaultSizeBangle = i.bangleSize
                            }
                        }
                        cell.btnSize.layer.borderColor = UIColor.lightGray.cgColor
                        cell.btnSize.layer.borderWidth = 0.6
                        cell.btnSize.addTarget(self, action: #selector(selectSizeBangle(_:)), for: .touchUpInside)
                    } else if self.product?.data.jwelleryType == "Ring" {
                        cell.lblTitle.text = "Select Size"
                        cell.btnSize.setTitle(self.product?.data.defaultSize, for: .normal)
                        self.productSize = (self.product?.data.defaultSize)!
                        cell.btnSize.addTarget(self, action: #selector(selectSizeRing(_:)), for: .touchUpInside)
                    } else if self.product?.data.jwelleryType == "Chain" {
                        cell.lblTitle.text = "Select Length"
                        
                        cell.btnSize.setTitle(self.product?.data.defaultSize, for: .normal)
                        self.productSize = (self.product?.data.defaultSize)!
                        cell.btnSize.addTarget(self, action: #selector(selectSizeRing(_:)), for: .touchUpInside)
                        
                    }else {
                       
                        cell.isHidden = true
                    }
                    
                   
                    return cell
                }
                else if indexPath.row == 2 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "codecell") as! codecell
                    
                    cell.lblCode.text = self.product?.data.productcode
                    return cell
                }
                else if indexPath.row == 3 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "quantityCell") as! quantityCell
                    
                    cell.qtyLbl.text = "\(qty)"
                    cell.plusBtn.addTarget(self, action: #selector(plusBtn), for: .touchUpInside)
                    cell.minusBtn.addTarget(self, action: #selector(minusBtn), for: .touchUpInside)
                    
                    return cell
                }
            } else if indexPath.section == 1 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "platinumCell") as! productPlatinumCell
                
                //MARK:- Product Code
                cell.lblProdcutCode.text = "  " + (self.product?.data.productcode)!
                
                //MARK:- Platinum Price
                let price = self.product?.price.platinum[0].price
                let pricetot = String(format: "%.2f", price?.toDouble() as! CVarArg)
                cell.lblPlatinumPrice.text = "  " + "₹ " + pricetot + " /g"
                
                //MARK:- Platinum weight
                let weight = self.platinumAsset[indexPath.row].weight
                let weighttot = String(format: "%.3f", weight.toDouble() as! CVarArg)
                cell.lblPlatinumWeight.text = "  " + weighttot + " g"
                
                //MARK:- Platinum Purity
                cell.lblPlatinumPurity.text = "  " + self.platinumAsset[indexPath.row].purity + "%"
                
                //MARK:- Platinum Wastage
                
                
                let wastage = self.platinumAsset[indexPath.row].wastage
                
                if wastage == "" || wastage == "<null>"{
                    cell.viewastage.isHidden = true
                }else {
                    cell.viewastage.isHidden = false
                    cell.lblPlatinumWasteage.text = "  " + self.platinumAsset[indexPath.row].wastage + "%"
                    
                    if self.ispr == true {
                        cell.viewastage.isHidden = true
                    }else {
                        cell.viewastage.isHidden = false
                    }
                }
                
                
                //MARK:- Platinum Makig Charge
                let smakingCharge = self.platinumAsset[indexPath.row].makingCharge
                let smakingChargetot = String(format: "%.2f", smakingCharge.toDouble() as! CVarArg)
                cell.lblPlatinumMakingCharge.text = "  " + "₹ " + smakingChargetot + " /g"
                
                //MARK:- Total Making Charge
                var makingCharge = 0.0
                var totalweight = 0.0
                if ischange == false {
                     totalweight = sizeCalculation(selectedSize: Int((self.product?.data.defaultSize)!)!, weight: self.platinumAsset[indexPath.row].weight.toDouble())
                }else {
                    totalweight = self.platinumAsset[indexPath.row].weight.toDouble()
                }
                
                
                
                if self.platinumAsset[indexPath.row].chargesOption == "PerGram" {
                    makingCharge = PriceCalculation.shared.platinumMaking(weight: totalweight, rate: self.platinumAsset[indexPath.row].makingCharge.toDouble(), isPerGram: true)
                } else if self.platinumAsset[indexPath.row].chargesOption == "Fixed" || self.platinumAsset[indexPath.row].chargesOption == "PerPiece" {
                    makingCharge = PriceCalculation.shared.platinumMaking(weight: self.platinumAsset[indexPath.row].weight.toDouble(), rate: self.platinumAsset[indexPath.row].makingCharge.toDouble(), isPerGram: false)
                }
                
                //MARK:- Meena Cost
                var finalMeenaCost = 0.0
                if self.platinumAsset[indexPath.row].meenacostOption == "PerGram" {
                    let meenaCost = PriceCalculation.shared.MeenaCost(meenaRate: self.platinumAsset[indexPath.row].meenaCost.toDouble(), weight: self.platinumAsset[indexPath.row].weight.toDouble(), isPergram: true)
                    finalMeenaCost = meenaCost
                } else if self.platinumAsset[indexPath.row].meenacostOption == "Fixed" {
                    let meenaCost = PriceCalculation.shared.MeenaCost(meenaRate: self.platinumAsset[indexPath.row].meenaCost.toDouble(), weight: self.platinumAsset[indexPath.row].weight.toDouble(), isPergram: false)
                    finalMeenaCost = meenaCost
                }
                
                cell.lblTotalMakingCharge.text = "  " + "₹ " + makingCharge.toString()
                
                //MARK:- Platinum Total
                let tot = (PriceCalculation.shared.platinumPrice(weight: totalweight, rate: (self.product?.price.platinum[0].price.toDouble())!, wastage: self.platinumAsset[indexPath.row].wastage.toDouble(), purity: self.platinumAsset[indexPath.row].purity.toDouble())) + makingCharge + finalMeenaCost
                let plate = String(format: "%.2f", tot)
               
                
                cell.lblPlatinumTotal.text = "  " + "₹ " + plate
                
                if self.ispr == true {
                    cell.viewPrice.isHidden = true
                    cell.viewPurity.isHidden = true
                    cell.viewWeigh.isHidden = true
                    cell.viewMaking.isHidden = true
                    cell.viewTotalMakingCharge.isHidden = true
                    cell.viewMakingCharge.isHidden = true
                }else {
                    cell.viewPrice.isHidden = false
                    
                    cell.viewPurity.isHidden = false
                    cell.viewWeigh.isHidden = false
                    cell.viewMaking.isHidden = false
                    cell.viewTotalMakingCharge.isHidden = false
                    cell.viewMakingCharge.isHidden = false
                }
                
                
                return cell
                
            } else if indexPath.section == 2 {
                
                if self.diamondAsset[indexPath.row].certificationCost == "" || self.diamondAsset[indexPath.row].certificationCost == "0"{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "diamondCell") as! productDiamondCell
                    cell.d1Btn.isHidden = true
                    cell.d2Btn.isHidden = true
                    cell.d3Btn.isHidden = true
                    cell.d4Btn.isHidden = true
                    cell.d5Btn.isHidden = true
                    cell.d6BtnC.isHidden = true
                    
                    cell.d1Btnc.isHidden = true
                    cell.d2Btnc.isHidden = true
                    cell.d3Btnc.isHidden = true
                    cell.d4Btnc.isHidden = true
                    cell.d5Btnc.isHidden = true
                    
                    cell.diamondTypeBtn.setTitle(self.diamondAsset[indexPath.row].jwellerySize, for: .normal)
                    
                    let diamondBtn = [cell.d1Btn,cell.d2Btn,cell.d3Btn,cell.d4Btn,cell.d5Btn,cell.d6BtnC]
                    let diamondBtnC = [cell.d1Btnc,cell.d2Btnc,cell.d3Btnc,cell.d4Btnc,cell.d5Btnc]
                    
                    let diamondColor = self.diamondAsset[indexPath.row].color.components(separatedBy: ",")
                    for i in  0 ..< diamondColor.count {
                        diamondBtn[i]?.tag = indexPath.row
                        diamondBtn[i]?.isHidden = false
                        diamondBtn[i]?.setTitle(diamondColor[i], for: .normal)
                       // self.diamondColorTemp = diamondColor[i]
                        diamondBtn[i]?.addTarget(self, action: #selector(diamondColoBtn(_:)), for: .touchUpInside)
                        diamondBtn[i]?.backgroundColor = UIColor.white
                        diamondBtn[i]?.setTitleColor(.black, for: .normal)
                    }
                       
                    let diamondClarity = self.diamondAsset[indexPath.row].clarity.components(separatedBy: ",")
                    for i in  0 ..< diamondClarity.count {
                        diamondBtnC[i]?.tag = indexPath.row
                        diamondBtnC[i]?.isHidden = false
                        diamondBtnC[i]?.setTitle(diamondClarity[i], for: .normal)
                        //self.diamondClarityTemp = diamondClarity[i]
                        diamondBtnC[i]?.addTarget(self, action: #selector(diamondClarityBtn(_:)), for: .touchUpInside)
                        diamondBtnC[i]?.backgroundColor = UIColor.white
                        diamondBtnC[i]?.setTitleColor(.black, for: .normal)
                    }
                    
                    let clrTemp = NSMutableArray()
                for i in 0 ..< diamondBtn.count {
                    print(diamondBtn[i]?.titleLabel?.text ?? "")
                    print(self.diamondColorTemp)
                            
                    if diamondBtn[i]?.titleLabel?.text! == self.diamondColorTemp {
                        diamondBtn[i]?.backgroundColor = UIColor.init(named: "base_color")
                        diamondBtn[i]?.setTitleColor(.white, for: .normal)
                        
                        let tempdic = ["name":diamondBtn[i]?.titleLabel?.text!,"value":"1"]
                        
                        clrTemp.add(tempdic)
                    }else {
                        let tempdic = ["name":diamondBtn[i]?.titleLabel?.text!,"value":"0"]
                        clrTemp.add(tempdic)
                    }
                }
                    
                   
                        
                    let tempdic = ["name":self.diamondAsset[indexPath.row].jwellerySize,"value":clrTemp] as [String : Any]
                    
                    if self.newcolorarray.count != 0 {
                        for i in 0..<self.newcolorarray.count {
                            let name = self.newcolorarray[i]["name"] as! String
                            if name == self.diamondAsset[indexPath.row].jwellerySize {
                                self.newcolorarray.remove(at: i)
                                self.newcolorarray.insert(tempdic, at: i)
                                break
                            }
                        }
                        
                    }else {
                        self.newcolorarray.append(tempdic)
                    }
                    
                     
                    
                    
                    
                    let clarityTemp = NSMutableArray()
                    
                    
                    
                    self.clarArr = []
                    for i in 0 ..< diamondBtnC.count {
                        let btnName = diamondBtnC[i]?.titleLabel?.text! ?? ""
                        if btnName == self.diamondClarityTemp {
                            
                            diamondBtnC[i]?.backgroundColor = UIColor.init(named: "base_color")
                            diamondBtnC[i]?.setTitleColor(.white, for: .normal)
                            let tempdic = ["name":btnName,"value":"1"]
                            clarityTemp.add(tempdic)
                        }else {
                            let tempdic = ["name":btnName,"value":"0"]
                            clarityTemp.add(tempdic)
                        }
                    }
                        if self.diamondColorTemp == "" && self.diamondClarityTemp == "" {
                            self.diamondColorTemp = diamondColor[0]
                            self.diamondClarityTemp = diamondClarity[0]
                        }
                    
                    
                    
                    let tempdic1 = ["name":self.diamondAsset[indexPath.row].jwellerySize,"value":clarityTemp] as [String : Any]
                    
                    if self.newClarityarray.count != 0 {
                        for i in 0..<self.newClarityarray.count {
                            let name = self.newClarityarray[i]["name"] as! String
                            if name == self.diamondAsset[indexPath.row].jwellerySize {
                                self.newClarityarray.remove(at: i)
                                self.newClarityarray.insert(tempdic1, at: i)
                                break
                            }
                        }
                        
                    }else {
                        self.newClarityarray.append(tempdic1)
                    }
                       
                        //MARK:- Name label
                        cell.lblName.text = self.diamondAsset[indexPath.row].jwellerySize
                    self.diaType = self.diamondAsset[indexPath.row].jwellerySize
                        //MARK:- Weight Label
                    let weight = self.diamondAsset[indexPath.row].weight.toDouble()
                    let we = String(format: "%.3f", weight)
                        cell.lblWeight.text = we + " Ct"
                        
                        //MARK:- Daimond Price
                        var diamondPrice = ""
                        for i in self.product!.price.diamondMaster {
                            if i.type == self.diamondAsset[indexPath.row].defaultColorClarity {
                                if i.diamond_type == self.diamondAsset[indexPath.row].jwellerySize {
                                    diamondPrice = i.price
                                    
                                }
                            }
                        }
                    let daimondpr = diamondPrice.toDouble()
                    let wedaimondpr = String(format: "%.1f", daimondpr)
                        cell.lblPrice.text = "₹ " + wedaimondpr + "/ ct"
                        
                        //MARK:- No of Diamond
                    cell.lblNoDiamond.text = self.diamondAsset[indexPath.row].quantity + " pc"
                   
                        
                        //MARK:- Total Diamond
                    
                    let daitotal = PriceCalculation.shared.diamondPrice(diamondWeight: self.diamondAsset[indexPath.row].weight.toDouble(), diamondRate: diamondPrice.toDouble())
                    
                    let rateTotal = String(format: "%.2f", daitotal)
                    cell.lblDiamondTotal.text = "₹ " + rateTotal
                        
                        //MARK:- Diamond Color Clarity
                        cell.lblDiamondColorClarity.text = self.diamondAsset[indexPath.row].defaultColorClarity
                        
                        
                        cell.d1Btn.layer.borderColor = UIColor.black.cgColor
                        cell.d1Btn.layer.borderWidth = 0.5
                        cell.d1Btn.layer.cornerRadius = cell.d1Btn.frame.height / 2
                        cell.d1Btn.clipsToBounds = true
                                
                        cell.d2Btn.layer.borderColor = UIColor.black.cgColor
                        cell.d2Btn.layer.borderWidth = 0.5
                        cell.d2Btn.layer.cornerRadius = cell.d2Btn.frame.height / 2
                        cell.d2Btn.clipsToBounds = true
                                
                        cell.d3Btn.layer.borderColor = UIColor.black.cgColor
                        cell.d3Btn.layer.borderWidth = 0.5
                        cell.d3Btn.layer.cornerRadius = cell.d3Btn.frame.height / 2
                        cell.d3Btn.clipsToBounds = true
                                
                        cell.d4Btn.layer.borderColor = UIColor.black.cgColor
                        cell.d4Btn.layer.borderWidth = 0.5
                        cell.d4Btn.layer.cornerRadius = cell.d4Btn.frame.height / 2
                        cell.d4Btn.clipsToBounds = true
                                
                        cell.d5Btn.layer.borderColor = UIColor.black.cgColor
                        cell.d5Btn.layer.borderWidth = 0.5
                        cell.d5Btn.layer.cornerRadius = cell.d5Btn.frame.height / 2
                        cell.d5Btn.clipsToBounds = true
                    
                    cell.d6BtnC.layer.borderColor = UIColor.black.cgColor
                    cell.d6BtnC.layer.borderWidth = 0.5
                    cell.d6BtnC.layer.cornerRadius = cell.d5Btn.frame.height / 2
                    cell.d6BtnC.clipsToBounds = true
                            
                        cell.d1Btnc.layer.borderColor = UIColor.black.cgColor
                        cell.d1Btnc.layer.borderWidth = 0.5
                        cell.d1Btnc.layer.cornerRadius = cell.d1Btnc.frame.height / 2
                        cell.d1Btnc.clipsToBounds = true
                            
                        cell.d2Btnc.layer.borderColor = UIColor.black.cgColor
                        cell.d2Btnc.layer.borderWidth = 0.5
                        cell.d2Btnc.layer.cornerRadius = cell.d2Btnc.frame.height / 2
                        cell.d2Btnc.clipsToBounds = true
                            
                        cell.d3Btnc.layer.borderColor = UIColor.black.cgColor
                        cell.d3Btnc.layer.borderWidth = 0.5
                        cell.d3Btnc.layer.cornerRadius = cell.d3Btnc.frame.height / 2
                        cell.d3Btnc.clipsToBounds = true
                            
                        cell.d4Btnc.layer.borderColor = UIColor.black.cgColor
                        cell.d4Btnc.layer.borderWidth = 0.5
                        cell.d4Btnc.layer.cornerRadius = cell.d4Btnc.frame.height / 2
                        cell.d4Btnc.clipsToBounds = true
                            
                        cell.d5Btnc.layer.borderColor = UIColor.black.cgColor
                        cell.d5Btnc.layer.borderWidth = 0.5
                        cell.d5Btnc.layer.cornerRadius = cell.d4Btnc.frame.height / 2
                        cell.d5Btnc.clipsToBounds = true
                    
                    
                    if ispr == true {
                        
                        cell.viewPrice.isHidden = true
                        cell.viewDiaNo.isHidden = true
                        cell.viewDiaTotal.isHidden = true
                        cell.viewColCla.isHidden = true
                       
                    }else {
                        cell.viewPrice.isHidden = false
                        if self.diamondAsset[indexPath.row].quantity != "0" {
                            cell.viewDiaNo.isHidden = false
                            
                              
                        }
                        else {
                            cell.viewDiaNo.isHidden = true
                        }
                        cell.viewDiaTotal.isHidden = false
                        cell.viewColCla.isHidden = false
                    }
                    
                    return cell
                }
                let cell = tableView.dequeueReusableCell(withIdentifier: "diamondCellCertified") as! productDiamondCellCertified
                cell.d1Btn.isHidden = true
                cell.d2Btn.isHidden = true
                cell.d3Btn.isHidden = true
                cell.d4Btn.isHidden = true
                cell.d5Btn.isHidden = true
                
                cell.d1Btnc.isHidden = true
                cell.d2Btnc.isHidden = true
                cell.d3Btnc.isHidden = true
                cell.d4Btnc.isHidden = true
                cell.d5Btnc.isHidden = true
                
                let diamondBtn = [cell.d1Btn,cell.d2Btn,cell.d3Btn,cell.d4Btn,cell.d5Btn]
                let diamondBtnC = [cell.d1Btnc,cell.d2Btnc,cell.d3Btnc,cell.d4Btnc,cell.d5Btnc]
                
                
                
                cell.diamondTypeBtn.setTitle(self.diamondAsset[indexPath.row].jwellerySize, for: .normal)
            let diamondColor = self.diamondAsset[indexPath.row].color.components(separatedBy: ",")
            for i in  0 ..< diamondColor.count {
                diamondBtn[i]?.tag = indexPath.row
                diamondBtn[i]?.isHidden = false
                diamondBtn[i]?.setTitle(diamondColor[i], for: .normal)
                diamondBtn[i]?.addTarget(self, action: #selector(diamondColoBtn(_:)), for: .touchUpInside)
                diamondBtn[i]?.backgroundColor = UIColor.white
                diamondBtn[i]?.setTitleColor(.black, for: .normal)
            }
               
                let diamondClarity = self.diamondAsset[indexPath.row].clarity.components(separatedBy: ",")
                    for i in  0 ..< diamondClarity.count {
                    diamondBtnC[i]?.tag = indexPath.row
                    diamondBtnC[i]?.isHidden = false
                    diamondBtnC[i]?.setTitle(diamondClarity[i], for: .normal)
                    diamondBtnC[i]?.addTarget(self, action: #selector(diamondClarityBtn(_:)), for: .touchUpInside)
                    diamondBtnC[i]?.backgroundColor = UIColor.white
                    diamondBtnC[i]?.setTitleColor(.black, for: .normal)
                }
               
                let clrTemp = NSMutableArray()
            for i in 0 ..< diamondBtn.count {
                print(diamondBtn[i]?.titleLabel?.text ?? "")
                print(self.diamondColorTemp)
                        
                if diamondBtn[i]?.titleLabel?.text! == self.diamondColorTemp {
                    diamondBtn[i]?.backgroundColor = UIColor.init(named: "base_color")
                    diamondBtn[i]?.setTitleColor(.white, for: .normal)
                    
                    let tempdic = ["name":diamondBtn[i]?.titleLabel?.text!,"value":"1"]
                    
                    clrTemp.add(tempdic)
                }else {
                    let tempdic = ["name":diamondBtn[i]?.titleLabel?.text!,"value":"0"]
                    clrTemp.add(tempdic)
                }
            }
                
               
                    
                let tempdic = ["name":self.diamondAsset[indexPath.row].jwellerySize,"value":clrTemp] as [String : Any]
                
                if self.newcolorarray.count != 0 {
                    for i in 0..<self.newcolorarray.count {
                        let name = self.newcolorarray[i]["name"] as! String
                        if name == self.diamondAsset[indexPath.row].jwellerySize {
                            self.newcolorarray.remove(at: i)
                            self.newcolorarray.insert(tempdic, at: i)
                            break
                        }
                    }
                    
                }else {
                    self.newcolorarray.append(tempdic)
                }
                
                 
                
                
                
                let clarityTemp = NSMutableArray()
                
                
                
                self.clarArr = []
                for i in 0 ..< diamondBtnC.count {
                    let btnName = diamondBtnC[i]?.titleLabel?.text! ?? ""
                    if btnName == self.diamondClarityTemp {
                        
                        diamondBtnC[i]?.backgroundColor = UIColor.init(named: "base_color")
                        diamondBtnC[i]?.setTitleColor(.white, for: .normal)
                        let tempdic = ["name":btnName,"value":"1"]
                        clarityTemp.add(tempdic)
                    }else {
                        let tempdic = ["name":btnName,"value":"0"]
                        clarityTemp.add(tempdic)
                    }
                }
                
                
                
                let tempdic1 = ["name":self.diamondAsset[indexPath.row].jwellerySize,"value":clarityTemp] as [String : Any]
                
                if self.newClarityarray.count != 0 {
                    for i in 0..<self.newClarityarray.count {
                        let name = self.newClarityarray[i]["name"] as! String
                        if name == self.diamondAsset[indexPath.row].jwellerySize {
                            self.newClarityarray.remove(at: i)
                            self.newClarityarray.insert(tempdic1, at: i)
                            break
                        }
                    }
                    
                }else {
                    self.newClarityarray.append(tempdic1)
                }
                
                
    //            for i in 0 ..< diamondBtn.count {
    //                print(diamondBtn[i]?.titleLabel?.text ?? "")
    //                print(self.diamondColorTemp)
    //
    //                if diamondBtn[i]?.titleLabel?.text! == self.diamondColorTemp {
    //                    diamondBtn[i]?.backgroundColor = UIColor.init(named: "base_color")
    //                    diamondBtn[i]?.setTitleColor(.white, for: .normal)
    //                }
    //            }
    //            if self.diamondColorTemp == "" && self.diamondClarityTemp == "" {
    //                self.diamondColorTemp = diamondColor[0]
    //                self.diamondClarityTemp = diamondClarity[0]
    //            }
    //
    //            for i in 0 ..< diamondBtnC.count {
    //                let btnName = diamondBtnC[i]?.titleLabel?.text! ?? ""
    //                print(btnName)
    //                if btnName == self.diamondClarityTemp {
    //                    diamondBtnC[i]?.backgroundColor = UIColor.init(named: "base_color")
    //                    diamondBtnC[i]?.setTitleColor(.white, for: .normal)
    //                }
    //            }
    //                if self.diamondColorTemp == "" && self.diamondClarityTemp == "" {
    //                    self.diamondColorTemp = diamondColor[0]
    //                    self.diamondClarityTemp = diamondClarity[0]
    //                }
               
                //MARK:- Name label
                cell.lblName.text = self.diamondAsset[indexPath.row].jwellerySize
                self.diaType = self.diamondAsset[indexPath.row].jwellerySize
                //MARK:- Weight Label
                cell.lblWeight.text = self.diamondAsset[indexPath.row].weight + " Ct"
                
                //MARK:- Daimond Price
                var diamondPrice = ""
                for i in self.product!.price.diamondMaster {
                    
                    if i.diamond_type == self.diamondAsset[indexPath.row].jwellerySize {
                        if i.type == self.diamondAsset[indexPath.row].defaultColorClarity {
                            if i.diamond_type == self.diamondAsset[indexPath.row].jwellerySize {
                                diamondPrice = i.price
                                
                            }
                        }
                    }
                    
                    
                }
                cell.lblPrice.text = "₹" + diamondPrice + "/ Ct"
                
                //MARK:- No of Diamond
                cell.lblNoDiamond.text = self.diamondAsset[indexPath.row].quantity + " Pc"
                
                
                //MARK:- Diamond Color Clarity
                cell.lblDiamondColorClarity.text = self.diamondAsset[indexPath.row].defaultColorClarity
                
                //MARK:- Certificate charge
                cell.lblCertificateCharges.text = self.diamondAsset[indexPath.row].certificationCost
                
                
                var certCost = 0.0
                if self.diamondAsset[indexPath.row].crtcostOption == "PerCarat" {
                    //MARK:- Certificate charge
                    cell.lblCertificateCharges.text = "₹" + self.diamondAsset[indexPath.row].certificationCost + " /Ct"
                    
                    
                    certCost = self.diamondAsset[indexPath.row].weight.toDouble() * self.diamondAsset[indexPath.row].certificationCost.toDouble()
                } else if self.diamondAsset[indexPath.row].crtcostOption == "Fixed" {
                    //MARK:- Certificate charge
                    cell.lblCertificateCharges.text = "₹" + self.diamondAsset[indexPath.row].certificationCost
                    
                    certCost = self.diamondAsset[indexPath.row].certificationCost.toDouble()
                }
                
                //MARK:- Total Certification Charge
                cell.lblTotalCertificateCharges.text = "₹ " + certCost.toString()
                
                //MARK:- Total Diamond
                cell.lblDiamondTotal.text = "₹ " + (PriceCalculation.shared.diamondPrice(diamondWeight: self.diamondAsset[indexPath.row].weight.toDouble(), diamondRate: diamondPrice.toDouble()) + certCost).toString()
                
                cell.d1Btn.layer.borderColor = UIColor.black.cgColor
                cell.d1Btn.layer.borderWidth = 0.5
                cell.d1Btn.layer.cornerRadius = cell.d1Btn.frame.height / 2
                cell.d1Btn.clipsToBounds = true
                        
                cell.d2Btn.layer.borderColor = UIColor.black.cgColor
                cell.d2Btn.layer.borderWidth = 0.5
                cell.d2Btn.layer.cornerRadius = cell.d2Btn.frame.height / 2
                cell.d2Btn.clipsToBounds = true
                        
                cell.d3Btn.layer.borderColor = UIColor.black.cgColor
                cell.d3Btn.layer.borderWidth = 0.5
                cell.d3Btn.layer.cornerRadius = cell.d3Btn.frame.height / 2
                cell.d3Btn.clipsToBounds = true
                        
                cell.d4Btn.layer.borderColor = UIColor.black.cgColor
                cell.d4Btn.layer.borderWidth = 0.5
                cell.d4Btn.layer.cornerRadius = cell.d4Btn.frame.height / 2
                cell.d4Btn.clipsToBounds = true
                        
                cell.d5Btn.layer.borderColor = UIColor.black.cgColor
                cell.d5Btn.layer.borderWidth = 0.5
                cell.d5Btn.layer.cornerRadius = cell.d5Btn.frame.height / 2
                cell.d5Btn.clipsToBounds = true
                    
                cell.d1Btnc.layer.borderColor = UIColor.black.cgColor
                cell.d1Btnc.layer.borderWidth = 0.5
                cell.d1Btnc.layer.cornerRadius = cell.d1Btnc.frame.height / 2
                cell.d1Btnc.clipsToBounds = true
                    
                cell.d2Btnc.layer.borderColor = UIColor.black.cgColor
                cell.d2Btnc.layer.borderWidth = 0.5
                cell.d2Btnc.layer.cornerRadius = cell.d2Btnc.frame.height / 2
                cell.d2Btnc.clipsToBounds = true
                    
                cell.d3Btnc.layer.borderColor = UIColor.black.cgColor
                cell.d3Btnc.layer.borderWidth = 0.5
                cell.d3Btnc.layer.cornerRadius = cell.d3Btnc.frame.height / 2
                cell.d3Btnc.clipsToBounds = true
                    
                cell.d4Btnc.layer.borderColor = UIColor.black.cgColor
                cell.d4Btnc.layer.borderWidth = 0.5
                cell.d4Btnc.layer.cornerRadius = cell.d4Btnc.frame.height / 2
                cell.d4Btnc.clipsToBounds = true
                    
                cell.d5Btnc.layer.borderColor = UIColor.black.cgColor
                cell.d5Btnc.layer.borderWidth = 0.5
                cell.d5Btnc.layer.cornerRadius = cell.d4Btnc.frame.height / 2
                cell.d5Btnc.clipsToBounds = true
                
                if ispr == true {
                    
                    cell.viewPrice.isHidden = true
                    cell.viewDiaNo.isHidden = true
                    cell.viewDiaTotal.isHidden = true
                    cell.viewColcla.isHidden = true
                    cell.viewCertTotal.isHidden = true
                    cell.viewCertCharge.isHidden = true
                   
                }else {
                    cell.viewPrice.isHidden = false
                    cell.viewDiaNo.isHidden = false
                    cell.viewDiaTotal.isHidden = false
                    cell.viewColcla.isHidden = false
                    cell.viewCertTotal.isHidden = false
                    cell.viewCertCharge.isHidden = false
                }
                
                
                return cell
            } else if indexPath.section == 3 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "stoneCell") as! productStoneCell
                
                
                if self.arrFinalStone[indexPath.row]["stoneInside"] == nil {
                    cell.downArrow.isHidden  = true
                    cell.btnStoneType.isUserInteractionEnabled = false
                    cell.btnStoneType.layer.borderWidth = 1.0
                    cell.btnStoneType.layer.borderColor = UIColor.darkGray.cgColor
                    cell.btnStoneType.setTitle(self.arrFinalStone[indexPath.row]["jwellerySize"] as! String, for: .normal)
                    
                    
                    if self.arrFinalStone[indexPath.row]["quantity"] as! String == "0" ||  self.arrFinalStone[indexPath.row]["quantity"] as! String == "" {
                        cell.viewMain.isHidden = true
                        
                    }else {
                        cell.viewMain.isHidden = false
                    }
                    
                    cell.lblNoOfStone.text = self.arrFinalStone[indexPath.row]["quantity"] as! String + " Pc"
                    let we = self.arrFinalStone[indexPath.row]["weight"] as! String
                    let ston = String(format: "%.3f", we.toDouble())
                               cell.lblStoneWeight.text = ston + " Ct"
                   
                               var stonRate = ""
                               for i in self.product!.price.stone {
                                   if i.type == (self.arrFinalStone[indexPath.row]["jwellerySize"] as! String).uppercased() {
                                       stonRate = i.price
                                   }
                               }
                               let stonrat = String(format: "%.1f", stonRate.toDouble())
                               cell.lblStonePrice.text = stonrat + "/ Ct"
                               stonRate = stonrat
                   
                                
                               let stonratotal = String(format: "%.2f", (stonRate.toDouble() * we.toDouble()))
                   
                   
                               cell.lblStoneTotal.text = "₹ " + stonratotal
                    
                    
                    
                }else {
                    cell.downArrow.isHidden  = false
                    cell.btnStoneType.tag = indexPath.row
                    cell.btnStoneType.isUserInteractionEnabled = true
                    cell.btnStoneType.addTarget(self, action: #selector(selectStone(_:)), for: .touchUpInside)
                    let arrmain = self.arrFinalStone[indexPath.row]["stoneInside"] as! [[String:Any]]
                    
                    cell.btnStoneType.setTitle(arrmain[0]["jwellerySize"] as! String, for: .normal)
                    if self.arrFinalStone[indexPath.row]["quantity"] as! String == "0" ||  self.arrFinalStone[indexPath.row]["quantity"] as! String == "" {
                        cell.viewMain.isHidden = true
                        
                    }else {
                        cell.viewMain.isHidden = false
                    }
                    cell.lblNoOfStone.text = arrmain[0]["quantity"] as! String + " Pc"
                    let we = arrmain[0]["weight"] as! String
                    let ston = String(format: "%.3f", we.toDouble())
                               cell.lblStoneWeight.text = ston + " Ct"
                   
                               var stonRate = ""
                               for i in self.product!.price.stone {
                                   if i.type == (arrmain[0]["jwellerySize"] as! String).uppercased() {
                                       stonRate = i.price
                                   }
                               }
                               let stonrat = String(format: "%.1f", stonRate.toDouble())
                               cell.lblStonePrice.text = stonrat + "/ Ct"
                               stonRate = stonrat
                   
                                
                               let stonratotal = String(format: "%.2f", (stonRate.toDouble() * we.toDouble()))
                   
                   
                               cell.lblStoneTotal.text = "₹ " + stonratotal
                    
                }
                
                
                if ispr == true {
                    
                    cell.viewRate.isHidden = true
                    cell.viewTot.isHidden = true
                    
                   
                }else {
                    cell.viewRate.isHidden = false
                    cell.viewTot.isHidden = false
                }
    //            cell.btnStoneType.setTitle(self.stoneAsset[indexPath.row].jwellerySize, for: .normal)
    //
    //
    //            cell.lblNoOfStone.text = self.stoneAsset[indexPath.row].quantity + " Pc"
    //
    //            let ston = String(format: "%.3f", self.stoneAsset[indexPath.row].weight.toDouble())
    //            cell.lblStoneWeight.text = ston + " Ct"
    //
    //            var stonRate = ""
    //            for i in self.product!.price.stone {
    //                if i.type == self.stoneAsset[indexPath.row].jwellerySize.uppercased() {
    //                    stonRate = i.price
    //                }
    //            }
    //            let stonrat = String(format: "%.1f", stonRate.toDouble())
    //            cell.lblStonePrice.text = stonrat + "/ Ct"
    //            stonRate = stonrat
    //
    //
    //            let stonratotal = String(format: "%.2f", (stonRate.toDouble() * self.stoneAsset[indexPath.row].weight.toDouble()))
    //
    //
    //            cell.lblStoneTotal.text = "₹ " + stonratotal
                return cell
            } else if indexPath.section == 4 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "goldCell") as! GoldDetailCell
                cell.k12Btn.isHidden = true
                cell.k18Btn.isHidden = true
                cell.k8Btn.isHidden = true
                cell.k16Btn.isHidden = true
                let btnArr = [cell.k8Btn,cell.k12Btn,cell.k16Btn,cell.k18Btn]
                
                for i in 0 ..< self.goldAsset.count {
                    
                    btnArr[i]?.isHidden = false
                    btnArr[i]?.setTitle(self.goldAsset[i].jwellerySize, for: .normal)
                    btnArr[i]?.addTarget(self, action: #selector(goldSelect(_:)), for: .touchUpInside)
                    btnArr[i]?.backgroundColor = UIColor.white
                    btnArr[i]?.setTitleColor(.black, for: .normal)
                }
                if self.goldAsset.count > 0 {
                    for i in btnArr {
                        if i?.titleLabel?.text == self.goldAsset[self.selectedIndGold].jwellerySize {
                            i?.backgroundColor = UIColor.init(named: "base_color")
                            i?.setTitleColor(.white, for: .normal)
                            self.selectedgoldtype = (i?.titleLabel?.text)!
                            //self.defualttype = (0.titleLabel?.text)!
                        }
                    }
                }
                
                cell.k12Btn.layer.borderColor = UIColor.black.cgColor
                cell.k12Btn.layer.borderWidth = 1
                cell.k12Btn.layer.cornerRadius = cell.k12Btn.frame.height / 2
                cell.k12Btn.clipsToBounds = true
                    
                cell.k18Btn.layer.borderColor = UIColor.black.cgColor
                cell.k18Btn.layer.borderWidth = 1
                cell.k18Btn.layer.cornerRadius = cell.k18Btn.frame.height / 2
                cell.k18Btn.clipsToBounds = true
                    
                cell.k8Btn.layer.borderColor = UIColor.black.cgColor
                cell.k8Btn.layer.borderWidth = 1
                cell.k8Btn.layer.cornerRadius = cell.k8Btn.frame.height / 2
                cell.k8Btn.clipsToBounds = true
                    
                cell.k16Btn.layer.borderColor = UIColor.black.cgColor
                cell.k16Btn.layer.borderWidth = 1
                cell.k16Btn.layer.cornerRadius = cell.k16Btn.frame.height / 2
                cell.k16Btn.clipsToBounds = true
                
                
                cell.producCodeLbl.text = self.product?.data.productcode
                
                //MARK:- Value In Calc
                var valueIn = ""
                
                print(self.goldAsset.count)
                if self.goldAsset.count > 0 {
                    let goldType = self.goldAsset[self.selectedIndGold].jwellerySize
                    for i in self.product!.price.gold {
                        if goldType == i.type {
                            print(i.valueIn)
                            let type = String(format: "%.2f", i.valueIn.toDouble())
                            cell.goldPurityLbl.text = type + "%"
                            valueIn = i.valueIn
                        }
                    }
                }
                    
                
                
               
                
                //MARK:- Net Gold Weight
                let netgold = Double(self.goldAsset[self.selectedIndGold].weight)
                
                let netgoldy = String(format: "%.3f", netgold!)
                cell.netGoldWeightLbl.text = netgoldy + " g"
                
                if ispr == true {
                    
                    cell.viewNetGoldWeight.isHidden = true
                }else {
                    cell.viewNetGoldWeight.isHidden = false
                }
                
                //MARK:- Gold Making Charge
                
                let Making = Double(self.goldAsset[self.selectedIndGold].makingCharge)
                
                if Making != 0 {
                    cell.viewMakingCharge.isHidden = false
                     cell.viewTotalMakingCharge.isHidden = false
                    let Makingy = String(format: "%.1f", Making!)
                    cell.goldMakingChargeLbl.text = "₹ " + Makingy + "/ g"
                    
                    if ispr == true {
                        
                        cell.viewMakingCharge.isHidden = true
                    }else {
                        cell.viewMakingCharge.isHidden = false
                    }
                    
                }else {
                    cell.viewTotalMakingCharge.isHidden = true
                    cell.viewMakingCharge.isHidden = true
                }
                
                var  wastage = Double(self.goldAsset[self.selectedIndGold].wastage)
                if wastage == nil {
                    wastage = 0
                }
                if wastage != 0 {
                    cell.viewGoldWastage.isHidden = false
                    let wastagey = String(format: "%.1f", wastage!)
                    cell.lblWastage.text = wastagey + " %"
                    
                    if ispr == true {
                        
                        cell.viewGoldWastage.isHidden = true
                    }else {
                        cell.viewGoldWastage.isHidden = false
                    }
                    
                }else {
                    cell.viewGoldWastage.isHidden = true
                }
                
                let value = valueIn.toDouble()
                let mainweight = netgoldy.toDouble()
                var was = wastage
                
                if self.goldAsset[self.selectedIndGold].chargesOption == "Percentage" {
                    was = self.goldAsset[self.selectedIndGold].makingCharge.toDouble()
                }
                
                
                
                let fineWeight = mainweight * (value+was!) / 100
                //MARK:- Fine Gold Weight
            //    let purity = fineWeight.toDouble() / 100
                let finew = String(format: "%.3f", fineWeight)
                cell.fineGoldWeightlbl.text = finew + " g"
                
                //MARK:- Fine Gold Rate
                var goldRate = 0.0
                var mainrate = 0.0
                for i in self.product!.price.gold {
                    print(i.price)
                    if i.type == "24KT" {
                        print(i.price)
                        let rate = String(format: "%.2f", i.price.toDouble())
                        cell.fineGoldRateLbl.text = "₹ " + rate + " / g"
                        mainrate = rate.toDouble()
                        goldRate = i.price.toDouble()
                    }
                }
                
                //MARK:- Meena Cost
                var finalMeenaCost = 0.0
                if self.goldAsset[self.selectedIndGold].meenacostOption == "PerGram" {
                    let meenaCost = PriceCalculation.shared.MeenaCost(meenaRate: self.goldAsset[self.selectedIndGold].meenaCost.toDouble(), weight: self.goldAsset[self.selectedIndGold].weight.toDouble(), isPergram: true)
                    finalMeenaCost = meenaCost
                } else if self.goldAsset[self.selectedIndGold].meenacostOption == "Fixed" {
                    let meenaCost = PriceCalculation.shared.MeenaCost(meenaRate: self.goldAsset[self.selectedIndGold].meenaCost.toDouble(), weight: self.goldAsset[self.selectedIndGold].weight.toDouble(), isPergram: false)
                    finalMeenaCost = meenaCost
                }
                
                //MARK:- MakingCharges
                var makingCharge = 0.0
                if self.goldAsset[self.selectedIndGold].chargesOption == "PerGram" {
                   makingCharge = PriceCalculation.shared.goldMakingCharge(goldWeight: self.goldAsset[self.selectedIndGold].weight.toDouble(), makingTypeFixed: false, makingChargeRate: self.goldAsset[self.selectedIndGold].makingCharge.toDouble())
                    cell.viewTotalMakingCharge.isHidden = false
                } else if self.goldAsset[self.selectedIndGold].chargesOption == "Fixed" {
                    makingCharge = PriceCalculation.shared.goldMakingCharge(goldWeight: self.goldAsset[self.selectedIndGold].weight.toDouble(), makingTypeFixed: true, makingChargeRate: self.goldAsset[self.selectedIndGold].makingCharge.toDouble())
                    cell.viewTotalMakingCharge.isHidden = false
                }else {
                    
                    let value = valueIn.toDouble()
                    let mainweight = netgoldy.toDouble()
                    let was = self.goldAsset[self.selectedIndGold].makingCharge.toDouble()
                    makingCharge = mainweight * (value+was) / 100
                    cell.viewTotalMakingCharge.isHidden = true
                    cell.lblMakingTitle.text = "Gold wastage"
                    
                }
                
                //MARK:- Total Making Charge
                let totalMakingCharge = self.goldAsset[self.selectedIndGold].makingCharge.toDouble() * self.goldAsset[self.selectedIndGold].weight.toDouble()
                let maintotalMakingCharge = String(format: "%.2f", totalMakingCharge)
                
                cell.totalMakingChargelbl.text = "₹ " + maintotalMakingCharge
                
                if totalMakingCharge == 0 {
                    cell.viewTotalMakingCharge.isHidden = true
                }
                //MARK:- Total Amount
                var totalmain = Double()
                
                if self.goldAsset[self.selectedIndGold].chargesOption == "Percentage" {
                    totalmain = (PriceCalculation.shared.goldPrice(goldRate: mainrate, goldweight: netgoldy.toDouble(), goldPurity: valueIn.toDouble(), goldWastage: was!) + finalMeenaCost)
                }else {
                    totalmain = (PriceCalculation.shared.goldPrice(goldRate: mainrate, goldweight: netgoldy.toDouble(), goldPurity: valueIn.toDouble(), goldWastage: was!) + finalMeenaCost + makingCharge)
                }

                
                
                 
                let stotalmain = String(format: "%.3f", totalmain)
                
                let numberFormatter = NumberFormatter()
                numberFormatter.minimumFractionDigits = 2
                numberFormatter.maximumFractionDigits = 2
                numberFormatter.roundingMode = .down
                let str = numberFormatter.string(from: NSNumber(value: totalmain))
               // let str2 = numberFormatter.string(from: NSNumber(value: num2))
                
                
                cell.totalAmount.text = "₹ " + str!
                
                if ispr == true {
                    
                    cell.viewTotalAmount.isHidden = true
              
                    cell.viewPurity.isHidden = true
                    cell.viewFineGoldRate.isHidden = true
                    cell.viewFineGoldWeight.isHidden = true
                }else {
                    cell.viewTotalAmount.isHidden = false
                   
                    cell.viewPurity.isHidden = false
                    cell.viewFineGoldRate.isHidden = false
                    cell.viewFineGoldWeight.isHidden = false
                }
                
                
                
                return cell
            } else if indexPath.section == 5 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "silverCell") as! productSilverCell
                
                
                
                cell.btn1.isHidden = true
                cell.btn2.isHidden = true
                cell.btn3.isHidden = true
                cell.btn4.isHidden = true
                let btnArr = [cell.btn1,cell.btn2,cell.btn3,cell.btn4]
                
                for i in 0 ..< self.silverAsset.count {
                    
                    btnArr[i]?.isHidden = false
                    btnArr[i]?.setTitle(self.silverAsset[i].jwellerySize, for: .normal)
                    btnArr[i]?.addTarget(self, action: #selector(goldSelect(_:)), for: .touchUpInside)
                    btnArr[i]?.backgroundColor = UIColor.white
                    btnArr[i]?.setTitleColor(.black, for: .normal)
                }
                if self.silverAsset.count > 0 {
                    for i in btnArr {
                        if i?.titleLabel?.text == self.silverAsset[self.selectedIndSilver].jwellerySize {
                            i?.backgroundColor = UIColor.init(named: "base_color")
                            i?.setTitleColor(.white, for: .normal)
                            self.selectedsilvertype = (i?.titleLabel?.text)!
                            //self.defualttype = (0.titleLabel?.text)!
                        }
                    }
                }
                
                cell.btn1.layer.borderColor = UIColor.black.cgColor
                cell.btn1.layer.borderWidth = 1
                cell.btn1.layer.cornerRadius = cell.btn1.frame.height / 2
                cell.btn1.clipsToBounds = true
                    
                cell.btn2.layer.borderColor = UIColor.black.cgColor
                cell.btn2.layer.borderWidth = 1
                cell.btn2.layer.cornerRadius = cell.btn2.frame.height / 2
                cell.btn2.clipsToBounds = true
                    
                cell.btn3.layer.borderColor = UIColor.black.cgColor
                cell.btn3.layer.borderWidth = 1
                cell.btn3.layer.cornerRadius = cell.btn3.frame.height / 2
                cell.btn3.clipsToBounds = true
                    
                cell.btn4.layer.borderColor = UIColor.black.cgColor
                cell.btn4.layer.borderWidth = 1
                cell.btn4.layer.cornerRadius = cell.btn4.frame.height / 2
                cell.btn4.clipsToBounds = true
                
                
                cell.lblProductCode.text = "  " + (self.product?.data.productcode)!
                cell.viewCode.isHidden = true
                
                let price = self.product?.price.silver[0].price
                let pricetot = String(format: "%.2f", price?.toDouble() as! CVarArg)
                cell.lblRate.text =  "₹ " + pricetot + " /g"
                                
                                //MARK:- Value In Calc
                                var valueIn = ""
                                
                                print(self.silverAsset.count)
                                if self.silverAsset.count > 0 {
                                    let goldType = self.silverAsset[self.selectedIndSilver].jwellerySize
                                    for i in self.product!.price.silver {
                                        if goldType == i.type {
                                            print(i.valueIn)
                                            let type = String(format: "%.2f", i.valueIn.toDouble())
                                            cell.lblPurity.text = type + "%"
                                            valueIn = i.valueIn
                                        }
                                    }
                                }
                                    
                                
                                
                               
                                
                                //MARK:- Net Gold Weight
                                let netgold = Double(self.silverAsset[self.selectedIndSilver].weight)
                                
                                let netgoldy = String(format: "%.3f", netgold!)
                                cell.lblWeight.text = netgoldy + " g"
                                
                                if ispr == true {
                                    
                                    cell.viewWeight.isHidden = true
                                }else {
                                    cell.viewWeight.isHidden = false
                                }
                                
                                //MARK:- Gold Making Charge
                                
                                let Making = Double(self.silverAsset[self.selectedIndSilver].makingCharge)
                                
                                if Making != 0 {
                                    cell.viewMaking.isHidden = false
                                     cell.viewTotalMaking.isHidden = false
                                    let Makingy = String(format: "%.1f", Making!)
                                    cell.lblSilverMakingCharge.text = "₹ " + Makingy + "/ g"
                                    
                                    if ispr == true {
                                        
                                        cell.viewMaking.isHidden = true
                                    }else {
                                        cell.viewMaking.isHidden = false
                                    }
                                    
                                }else {
                                    cell.viewTotalMaking.isHidden = true
                                    cell.viewMaking.isHidden = true
                                }
                                
                                var  wastage = Double(self.silverAsset[self.selectedIndSilver].wastage)
                                if wastage == nil {
                                    wastage = 0
                                }
                                if wastage != 0 {
                                    cell.viewWastage.isHidden = false
                                    let wastagey = String(format: "%.1f", wastage!)
                                    cell.lblWastage.text = wastagey + " %"
                                    
                                    if ispr == true {
                                        
                                        cell.viewWastage.isHidden = true
                                    }else {
                                        cell.viewWastage.isHidden = false
                                    }
                                    
                                }else {
                                    cell.viewWastage.isHidden = true
                                }
                                
                                let value = valueIn.toDouble()
                                let mainweight = netgoldy.toDouble()
                                let was = wastage
                                let fineWeight = mainweight * (value+was!) / 100
                                //MARK:- Fine Gold Weight
                            //    let purity = fineWeight.toDouble() / 100
                                let finew = String(format: "%.3f", fineWeight)
                                cell.lblFineSilverWeight.text = finew + " g"
                                
                                //MARK:- Fine Gold Rate
                                var goldRate = 0.0
                                var mainrate = 0.0
                                for i in self.product!.price.silver {
                                    print(i.price)
                                    if i.type == "1000" {
                                        print(i.price)
                                        let rate = String(format: "%.2f", i.price.toDouble())
                                        cell.lblFineSilverRate.text = "₹ " + rate + " / g"
                                        mainrate = rate.toDouble()
                                        goldRate = i.price.toDouble()
                                    }
                                }
                                
                                //MARK:- Meena Cost
                                var finalMeenaCost = 0.0
                                if self.silverAsset[self.selectedIndSilver].meenacostOption == "PerGram" {
                                    cell.lblChargeType.text = "PerGram"
                                    let meenaCost = PriceCalculation.shared.MeenaCost(meenaRate: self.silverAsset[self.selectedIndSilver].meenaCost.toDouble(), weight: self.silverAsset[self.selectedIndSilver].weight.toDouble(), isPergram: true)
                                    finalMeenaCost = meenaCost
                                } else if self.silverAsset[self.selectedIndSilver].meenacostOption == "Fixed" {
                                    cell.lblChargeType.text = "Fixed"
                                    let meenaCost = PriceCalculation.shared.MeenaCost(meenaRate: self.silverAsset[self.selectedIndSilver].meenaCost.toDouble(), weight: self.silverAsset[self.selectedIndSilver].weight.toDouble(), isPergram: false)
                                    finalMeenaCost = meenaCost
                                }
                                
                                //MARK:- MakingCharges
                                var makingCharge = 0.0
                
                                if self.silverAsset[self.selectedIndSilver].chargesOption == "PerGram" {
                                    
                                    makingCharge = PriceCalculation.shared.silverMaking(weight: self.silverAsset[self.selectedIndSilver].weight.toDouble(), rate: self.silverAsset[self.selectedIndSilver].makingCharge.toDouble(), isPergram: true)
                                    
                        
                                } else if self.silverAsset[self.selectedIndSilver].chargesOption == "Fixed" {
                                    
                                    makingCharge = PriceCalculation.shared.silverMaking(weight: self.silverAsset[self.selectedIndSilver].weight.toDouble(), rate: self.silverAsset[self.selectedIndSilver].makingCharge.toDouble(), isPergram: false)
                                    
                                   
                                }
                                
                                //MARK:- Total Making Charge
                let totalMakingCharge = self.silverAsset[self.selectedIndSilver].makingCharge.toDouble() * netgoldy.toDouble()
                                let maintotalMakingCharge = String(format: "%.2f", totalMakingCharge)
                                
                                cell.lblSilverPrice.text = "₹ " + maintotalMakingCharge
                                
                                //MARK:- Total Amount
                
                
                let totalmain = (PriceCalculation.shared.silverPrice(weight: netgoldy.toDouble(), rate: mainrate, wastage: self.silverAsset[self.selectedIndSilver].wastage.toDouble() + finalMeenaCost, purity: valueIn.toDouble()))
                
                
                                
                                
                                let stotalmain = String(format: "%.3f", totalmain + totalMakingCharge)
                                
                                let numberFormatter = NumberFormatter()
                                numberFormatter.minimumFractionDigits = 2
                                numberFormatter.maximumFractionDigits = 2
                                numberFormatter.roundingMode = .down
                               // let str = numberFormatter.string(from: NSNumber(value: stotalmain))
                               // let str2 = numberFormatter.string(from: NSNumber(value: num2))
                                
                                
                cell.lblSilverTotal.text = "₹ " + stotalmain
                
                
                
                if self.ispr == true {
                    cell.viewMaking.isHidden = true
                    cell.viewPurity.isHidden = true
                    cell.viewRate.isHidden = true
                    cell.viewTotalMaking.isHidden = true
                    cell.viewWeight.isHidden = true
                    cell.viewTotal.isHidden = true
                    
                    
                    cell.viewFineSilverWeight.isHidden = true
                    cell.viewFineSIlverRate.isHidden = true
                }else {
                    cell.viewMaking.isHidden = false
                    cell.viewPurity.isHidden = false
                    cell.viewRate.isHidden = false
                    cell.viewTotalMaking.isHidden = false
                    cell.viewWeight.isHidden = false
                    cell.viewTotal.isHidden = false
                    
                    cell.viewFineSilverWeight.isHidden = false
                    cell.viewFineSIlverRate.isHidden = false
                }
                cell.viewPurity.isHidden = true
                cell.viewFineSIlverRate.isHidden = true
                
                return cell
                
                
            
            } else if indexPath.section == 6 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "certifiedByCell") as! productCertifiedByCell
                cell.img1.isHidden = true
                cell.img2.isHidden = true
                cell.img3.isHidden = true
                
                var imgArr = [cell.img1,cell.img2,cell.img3]
                for i in 0 ..< self.product!.certification.count {
                    imgArr[i]?.isHidden = false
                    imgArr[i]?.kf.indicatorType = .activity
                    imgArr[i]?.kf.setImage(with: URL(string: self.product!.certification[i].image),placeholder: nil,options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
                        switch result {
                        case .success(let value):
                            print("Task done for: \(value.source.url?.absoluteString ?? "")")
                            
                        case .failure(let error):
                            print("Job failed: \(error.localizedDescription)")
                            
                        }
                    }
                }
                return cell
            } else if indexPath.section == 7 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "manufactureCell") as! productManufactureByCell
                cell.lbl1.numberOfLines = 0
                cell.img.kf.indicatorType = .activity
                print(self.manufactureURL)
                
                var urlString = self.product?.manufacture.logo.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                cell.img.kf.setImage(with: URL(string: (urlString)!),placeholder: nil,options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
                    switch result {
                    case .success(let value):
                        print("Task done for: \(value.source.url?.absoluteString ?? "")")
                                       
                    case .failure(let error):
                        print("Job failed: \(error.localizedDescription)")
                    }
                }
                cell.lbl1.text = self.product?.manufacture.companyName
                return cell
            } else if indexPath.section == 8 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "descriptionCell") as! productOtherDetailsCell
                cell.txtDetails.attributedText = self.product?.data.dataDescription.convertHtml(str: (self.product?.data.dataDescription)!)
                return cell
            } else if indexPath.section == 9 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "priceCell") as! productPriceCell
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    cell.lblTotalPrice.text = "₹ " + self.calculateTotalPrice()
                    var sentence = self.productCode.text
                    let wordToRemove = "Gross weight :"
                    if let range = sentence!.range(of: wordToRemove) {
                        sentence!.removeSubrange(range)
                        cell.lblGrossWe.text = sentence
                    }

                    
                }
                
                if ispr == true {
                   // cell.lblToTtitle.isHidden = true
                    cell.lblTotalPrice.isHidden = true
                }else {
                   // cell.lblToTtitle.isHidden = false
                    cell.lblTotalPrice.isHidden = false
                }
                
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            return cell!
        }
        else if self.prodType == "SILVER JEWELLERY" {
            
            
                if indexPath.section == 0 {
                    if indexPath.row == 0 {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "colorCell") as! productColorCell
                        cell.roseBtn.isHidden = true
                        cell.goldBtn.isHidden = true
                        cell.whiteBtn.isHidden = true
                        if self.product?.data.color.contains("Yellow") ?? false {
                            cell.goldBtn.isHidden = false
                            self.mycolor = "Yellow"
                        }
                        if self.product?.data.color.contains("Rose") ?? false {
                            cell.roseBtn.isHidden = false
                            self.mycolor = "Rose"
                        }
                        if self.product?.data.color.contains("White") ?? false {
                            cell.whiteBtn.isHidden = false
                            self.mycolor = "White"
                        }
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
                                            
                        return cell
                    } else if indexPath.row == 1 {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "sizecell") as! productSizeCell
                        
                        if self.product?.data.jwelleryType.lowercased() == "bangles" {
                            cell.lblTitle.text = "Select Size"
                            let defaultSize = self.product?.data.defaultSize
                            for i in self.product!.price.bangle {
                                if i.sizes == defaultSize {
                                    cell.btnSize.setTitle(i.bangleSize, for: .normal)
                                    self.productSize = i.bangleSize
                                    self.defaultSize = i.bangleSize
                                    self.defaultSizeBangle = i.bangleSize
                                }
                            }
                            cell.btnSize.layer.borderColor = UIColor.lightGray.cgColor
                            cell.btnSize.layer.borderWidth = 0.6
                            cell.btnSize.addTarget(self, action: #selector(selectSizeBangle(_:)), for: .touchUpInside)
                        } else if self.product?.data.jwelleryType == "Ring" {
                            cell.lblTitle.text = "Select Size"
                            cell.btnSize.setTitle(self.product?.data.defaultSize, for: .normal)
                            self.productSize = (self.product?.data.defaultSize)!
                            cell.btnSize.addTarget(self, action: #selector(selectSizeRing(_:)), for: .touchUpInside)
                        } else if self.product?.data.jwelleryType == "Chain" {
                            cell.lblTitle.text = "Select Length"
                            
                            cell.btnSize.setTitle(self.product?.data.defaultSize, for: .normal)
                            self.productSize = (self.product?.data.defaultSize)!
                            cell.btnSize.addTarget(self, action: #selector(selectSizeRing(_:)), for: .touchUpInside)
                            
                        }else {
                           
                            cell.isHidden = true
                        }
                        
                       
                        return cell
                    }
                    else if indexPath.row == 2 {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "codecell") as! codecell
                        
                        cell.lblCode.text = self.product?.data.productcode
                        return cell
                    }
                    else if indexPath.row == 3 {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "quantityCell") as! quantityCell
                        
                        cell.qtyLbl.text = "\(qty)"
                        cell.plusBtn.addTarget(self, action: #selector(plusBtn), for: .touchUpInside)
                        cell.minusBtn.addTarget(self, action: #selector(minusBtn), for: .touchUpInside)
                        
                        return cell
                    }
                } else if indexPath.section == 1 {
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "silverCell") as! productSilverCell
                    
                    
                    
                    cell.btn1.isHidden = true
                    cell.btn2.isHidden = true
                    cell.btn3.isHidden = true
                    cell.btn4.isHidden = true
                    let btnArr = [cell.btn1,cell.btn2,cell.btn3,cell.btn4]
                    
                    for i in 0 ..< self.silverAsset.count {
                        
                        btnArr[i]?.isHidden = false
                        btnArr[i]?.setTitle(self.silverAsset[i].jwellerySize, for: .normal)
                        btnArr[i]?.addTarget(self, action: #selector(goldSelect(_:)), for: .touchUpInside)
                        btnArr[i]?.backgroundColor = UIColor.white
                        btnArr[i]?.setTitleColor(.black, for: .normal)
                    }
                    if self.silverAsset.count > 0 {
                        for i in btnArr {
                            if i?.titleLabel?.text == self.silverAsset[self.selectedIndSilver].jwellerySize {
                                i?.backgroundColor = UIColor.init(named: "base_color")
                                i?.setTitleColor(.white, for: .normal)
                                self.selectedsilvertype = (i?.titleLabel?.text)!
                                //self.defualttype = (0.titleLabel?.text)!
                            }
                        }
                    }
                    
                    cell.btn1.layer.borderColor = UIColor.black.cgColor
                    cell.btn1.layer.borderWidth = 1
                    cell.btn1.layer.cornerRadius = cell.btn1.frame.height / 2
                    cell.btn1.clipsToBounds = true
                        
                    cell.btn2.layer.borderColor = UIColor.black.cgColor
                    cell.btn2.layer.borderWidth = 1
                    cell.btn2.layer.cornerRadius = cell.btn2.frame.height / 2
                    cell.btn2.clipsToBounds = true
                        
                    cell.btn3.layer.borderColor = UIColor.black.cgColor
                    cell.btn3.layer.borderWidth = 1
                    cell.btn3.layer.cornerRadius = cell.btn3.frame.height / 2
                    cell.btn3.clipsToBounds = true
                        
                    cell.btn4.layer.borderColor = UIColor.black.cgColor
                    cell.btn4.layer.borderWidth = 1
                    cell.btn4.layer.cornerRadius = cell.btn4.frame.height / 2
                    cell.btn4.clipsToBounds = true
                    
                    
                    cell.lblProductCode.text = "  " + (self.product?.data.productcode)!
                    cell.viewCode.isHidden = true
                    
                    let price = self.product?.price.silver[0].price
                    let pricetot = String(format: "%.2f", price?.toDouble() as! CVarArg)
                    cell.lblRate.text =  "₹ " + pricetot + " /g"
                                    
                                    //MARK:- Value In Calc
                                    var valueIn = ""
                                    
                                    print(self.silverAsset.count)
                                    if self.silverAsset.count > 0 {
                                        let goldType = self.silverAsset[self.selectedIndSilver].jwellerySize
                                        for i in self.product!.price.silver {
                                            if goldType == i.type {
                                                print(i.valueIn)
                                                let type = String(format: "%.2f", i.valueIn.toDouble())
                                                cell.lblPurity.text = type + "%"
                                                valueIn = i.valueIn
                                            }
                                        }
                                    }
                                        
                                    
                                    
                                   
                    let wes = sizeCalculation(selectedSize: Int(self.productSize)!, weight: self.silverAsset[self.selectedIndSilver].weight.toDouble())
                                    //MARK:- Net Gold Weight
                                    let netgold = Double(self.silverAsset[self.selectedIndSilver].weight)
                                    
                                    let netgoldy = String(format: "%.3f", wes)
                                    cell.lblWeight.text = netgoldy + " g"
                                    
                                    if ispr == true {
                                        
                                        cell.viewWeight.isHidden = true
                                    }else {
                                        cell.viewWeight.isHidden = false
                                    }
                                    
                                    //MARK:- Gold Making Charge
                                    
                                    let Making = Double(self.silverAsset[self.selectedIndSilver].makingCharge)
                                    
                                    if Making != 0 {
                                        cell.viewMaking.isHidden = false
                                         cell.viewTotalMaking.isHidden = false
                                        let Makingy = String(format: "%.1f", Making!)
                                        cell.lblSilverMakingCharge.text = "₹ " + Makingy + "/ g"
                                        
                                        if ispr == true {
                                            
                                            cell.viewMaking.isHidden = true
                                        }else {
                                            cell.viewMaking.isHidden = false
                                        }
                                        
                                    }else {
                                        cell.viewTotalMaking.isHidden = true
                                        cell.viewMaking.isHidden = true
                                    }
                                    
                                    var  wastage = Double(self.silverAsset[self.selectedIndSilver].wastage)
                                    if wastage == nil {
                                        wastage = 0
                                    }
                                    if wastage != 0 {
                                        cell.viewWastage.isHidden = false
                                        let wastagey = String(format: "%.1f", wastage!)
                                        cell.lblWastage.text = wastagey + " %"
                                        
                                        if ispr == true {
                                            
                                            cell.viewWastage.isHidden = true
                                        }else {
                                            cell.viewWastage.isHidden = false
                                        }
                                        
                                    }else {
                                        cell.viewWastage.isHidden = true
                                    }
                                    
                                    let value = valueIn.toDouble()
                                    let mainweight = netgoldy.toDouble()
                                    let was = wastage
                                    let fineWeight = mainweight * (value+was!) / 100
                                    //MARK:- Fine Gold Weight
                                //    let purity = fineWeight.toDouble() / 100
                                    let finew = String(format: "%.3f", fineWeight)
                                    cell.lblFineSilverWeight.text = finew + " g"
                                    
                                    //MARK:- Fine Gold Rate
                                    var goldRate = 0.0
                                    var mainrate = 0.0
                                    for i in self.product!.price.silver {
                                        print(i.price)
                                        if i.type == "1000" {
                                            print(i.price)
                                            let rate = String(format: "%.2f", i.price.toDouble())
                                            cell.lblFineSilverRate.text = "₹ " + rate + " / g"
                                            mainrate = rate.toDouble()
                                            goldRate = i.price.toDouble()
                                        }
                                    }
                                    
                                    //MARK:- Meena Cost
                                    var finalMeenaCost = 0.0
                                    if self.silverAsset[self.selectedIndSilver].meenacostOption == "PerGram" {
                                        cell.lblChargeType.text = "PerGram"
                                        let meenaCost = PriceCalculation.shared.MeenaCost(meenaRate: self.silverAsset[self.selectedIndSilver].meenaCost.toDouble(), weight: self.silverAsset[self.selectedIndSilver].weight.toDouble(), isPergram: true)
                                        finalMeenaCost = meenaCost
                                    } else if self.silverAsset[self.selectedIndSilver].meenacostOption == "Fixed" {
                                        cell.lblChargeType.text = "Fixed"
                                        let meenaCost = PriceCalculation.shared.MeenaCost(meenaRate: self.silverAsset[self.selectedIndSilver].meenaCost.toDouble(), weight: self.silverAsset[self.selectedIndSilver].weight.toDouble(), isPergram: false)
                                        finalMeenaCost = meenaCost
                                    }
                                    
                                    //MARK:- MakingCharges
                                    var makingCharge = 0.0
                    
                                    if self.silverAsset[self.selectedIndSilver].chargesOption == "PerGram" {
                                        
                                        makingCharge = PriceCalculation.shared.silverMaking(weight: self.silverAsset[self.selectedIndSilver].weight.toDouble(), rate: self.silverAsset[self.selectedIndSilver].makingCharge.toDouble(), isPergram: true)
                                        
                            
                                    } else if self.silverAsset[self.selectedIndSilver].chargesOption == "Fixed" {
                                        
                                        makingCharge = PriceCalculation.shared.silverMaking(weight: self.silverAsset[self.selectedIndSilver].weight.toDouble(), rate: self.silverAsset[self.selectedIndSilver].makingCharge.toDouble(), isPergram: false)
                                        
                                       
                                    }
                                    
                                    //MARK:- Total Making Charge
                    let totalMakingCharge = self.silverAsset[self.selectedIndSilver].makingCharge.toDouble() * netgoldy.toDouble()
                                    let maintotalMakingCharge = String(format: "%.2f", totalMakingCharge)
                                    
                                    cell.lblSilverPrice.text = "₹ " + maintotalMakingCharge
                                    
                                    //MARK:- Total Amount
                    
                    
                    let totalmain = (PriceCalculation.shared.silverPrice(weight: netgoldy.toDouble(), rate: mainrate, wastage: self.silverAsset[self.selectedIndSilver].wastage.toDouble() + finalMeenaCost, purity: valueIn.toDouble()))
                    
                    
                                    
                                    
                                    let stotalmain = String(format: "%.3f", totalmain + totalMakingCharge)
                                    
                                    let numberFormatter = NumberFormatter()
                                    numberFormatter.minimumFractionDigits = 2
                                    numberFormatter.maximumFractionDigits = 2
                                    numberFormatter.roundingMode = .down
                                   // let str = numberFormatter.string(from: NSNumber(value: stotalmain))
                                   // let str2 = numberFormatter.string(from: NSNumber(value: num2))
                                    
                                    
                    cell.lblSilverTotal.text = "₹ " + stotalmain
                    
                    
                    
                    if self.ispr == true {
                        cell.viewMaking.isHidden = true
                        cell.viewPurity.isHidden = true
                        cell.viewRate.isHidden = true
                        cell.viewTotalMaking.isHidden = true
                        cell.viewWeight.isHidden = true
                        cell.viewTotal.isHidden = true
                        
                        
                        cell.viewFineSilverWeight.isHidden = true
                        cell.viewFineSIlverRate.isHidden = true
                    }else {
                        cell.viewMaking.isHidden = false
                        cell.viewPurity.isHidden = false
                        cell.viewRate.isHidden = false
                        cell.viewTotalMaking.isHidden = false
                        cell.viewWeight.isHidden = false
                        cell.viewTotal.isHidden = false
                        
                        cell.viewFineSilverWeight.isHidden = false
                        cell.viewFineSIlverRate.isHidden = false
                    }
                    cell.viewPurity.isHidden = true
                    cell.viewFineSIlverRate.isHidden = true
                    
                    return cell
                    
                    
                
                } else if indexPath.section == 2 {
                    
                    if self.diamondAsset[indexPath.row].certificationCost == "" || self.diamondAsset[indexPath.row].certificationCost == "0"{
                        let cell = tableView.dequeueReusableCell(withIdentifier: "diamondCell") as! productDiamondCell
                        cell.d1Btn.isHidden = true
                        cell.d2Btn.isHidden = true
                        cell.d3Btn.isHidden = true
                        cell.d4Btn.isHidden = true
                        cell.d5Btn.isHidden = true
                        cell.d6BtnC.isHidden = true
                        
                        cell.d1Btnc.isHidden = true
                        cell.d2Btnc.isHidden = true
                        cell.d3Btnc.isHidden = true
                        cell.d4Btnc.isHidden = true
                        cell.d5Btnc.isHidden = true
                        
                        cell.diamondTypeBtn.setTitle(self.diamondAsset[indexPath.row].jwellerySize, for: .normal)
                        
                        let diamondBtn = [cell.d1Btn,cell.d2Btn,cell.d3Btn,cell.d4Btn,cell.d5Btn,cell.d6BtnC]
                        let diamondBtnC = [cell.d1Btnc,cell.d2Btnc,cell.d3Btnc,cell.d4Btnc,cell.d5Btnc]
                        
                        let diamondColor = self.diamondAsset[indexPath.row].color.components(separatedBy: ",")
                        for i in  0 ..< diamondColor.count {
                            diamondBtn[i]?.tag = indexPath.row
                            diamondBtn[i]?.isHidden = false
                            diamondBtn[i]?.setTitle(diamondColor[i], for: .normal)
                           // self.diamondColorTemp = diamondColor[i]
                            diamondBtn[i]?.addTarget(self, action: #selector(diamondColoBtn(_:)), for: .touchUpInside)
                            diamondBtn[i]?.backgroundColor = UIColor.white
                            diamondBtn[i]?.setTitleColor(.black, for: .normal)
                        }
                           
                        let diamondClarity = self.diamondAsset[indexPath.row].clarity.components(separatedBy: ",")
                        for i in  0 ..< diamondClarity.count {
                            diamondBtnC[i]?.tag = indexPath.row
                            diamondBtnC[i]?.isHidden = false
                            diamondBtnC[i]?.setTitle(diamondClarity[i], for: .normal)
                            //self.diamondClarityTemp = diamondClarity[i]
                            diamondBtnC[i]?.addTarget(self, action: #selector(diamondClarityBtn(_:)), for: .touchUpInside)
                            diamondBtnC[i]?.backgroundColor = UIColor.white
                            diamondBtnC[i]?.setTitleColor(.black, for: .normal)
                        }
                        
                        let clrTemp = NSMutableArray()
                    for i in 0 ..< diamondBtn.count {
                        print(diamondBtn[i]?.titleLabel?.text ?? "")
                        print(self.diamondColorTemp)
                                
                        if diamondBtn[i]?.titleLabel?.text! == self.diamondColorTemp {
                            diamondBtn[i]?.backgroundColor = UIColor.init(named: "base_color")
                            diamondBtn[i]?.setTitleColor(.white, for: .normal)
                            
                            let tempdic = ["name":diamondBtn[i]?.titleLabel?.text!,"value":"1"]
                            
                            clrTemp.add(tempdic)
                        }else {
                            let tempdic = ["name":diamondBtn[i]?.titleLabel?.text!,"value":"0"]
                            clrTemp.add(tempdic)
                        }
                    }
                        
                       
                            
                        let tempdic = ["name":self.diamondAsset[indexPath.row].jwellerySize,"value":clrTemp] as [String : Any]
                        
                        if self.newcolorarray.count != 0 {
                            for i in 0..<self.newcolorarray.count {
                                let name = self.newcolorarray[i]["name"] as! String
                                if name == self.diamondAsset[indexPath.row].jwellerySize {
                                    self.newcolorarray.remove(at: i)
                                    self.newcolorarray.insert(tempdic, at: i)
                                    break
                                }
                            }
                            
                        }else {
                            self.newcolorarray.append(tempdic)
                        }
                        
                         
                        
                        
                        
                        let clarityTemp = NSMutableArray()
                        
                        
                        
                        self.clarArr = []
                        for i in 0 ..< diamondBtnC.count {
                            let btnName = diamondBtnC[i]?.titleLabel?.text! ?? ""
                            if btnName == self.diamondClarityTemp {
                                
                                diamondBtnC[i]?.backgroundColor = UIColor.init(named: "base_color")
                                diamondBtnC[i]?.setTitleColor(.white, for: .normal)
                                let tempdic = ["name":btnName,"value":"1"]
                                clarityTemp.add(tempdic)
                            }else {
                                let tempdic = ["name":btnName,"value":"0"]
                                clarityTemp.add(tempdic)
                            }
                        }
                            if self.diamondColorTemp == "" && self.diamondClarityTemp == "" {
                                self.diamondColorTemp = diamondColor[0]
                                self.diamondClarityTemp = diamondClarity[0]
                            }
                        
                        
                        
                        let tempdic1 = ["name":self.diamondAsset[indexPath.row].jwellerySize,"value":clarityTemp] as [String : Any]
                        
                        if self.newClarityarray.count != 0 {
                            for i in 0..<self.newClarityarray.count {
                                let name = self.newClarityarray[i]["name"] as! String
                                if name == self.diamondAsset[indexPath.row].jwellerySize {
                                    self.newClarityarray.remove(at: i)
                                    self.newClarityarray.insert(tempdic1, at: i)
                                    break
                                }
                            }
                            
                        }else {
                            self.newClarityarray.append(tempdic1)
                        }
                           
                            //MARK:- Name label
                            cell.lblName.text = self.diamondAsset[indexPath.row].jwellerySize
                        self.diaType = self.diamondAsset[indexPath.row].jwellerySize
                            //MARK:- Weight Label
                        let weight = self.diamondAsset[indexPath.row].weight.toDouble()
                        let we = String(format: "%.3f", weight)
                            cell.lblWeight.text = we + " Ct"
                            
                            //MARK:- Daimond Price
                            var diamondPrice = ""
                            for i in self.product!.price.diamondMaster {
                                if i.type == self.diamondAsset[indexPath.row].defaultColorClarity {
                                    if i.diamond_type == self.diamondAsset[indexPath.row].jwellerySize {
                                        diamondPrice = i.price
                                        
                                    }
                                }
                            }
                        let daimondpr = diamondPrice.toDouble()
                        let wedaimondpr = String(format: "%.1f", daimondpr)
                            cell.lblPrice.text = "₹ " + wedaimondpr + "/ ct"
                            
                            //MARK:- No of Diamond
                        cell.lblNoDiamond.text = self.diamondAsset[indexPath.row].quantity + " pc"
                       
                            
                            //MARK:- Total Diamond
                        
                        let daitotal = PriceCalculation.shared.diamondPrice(diamondWeight: self.diamondAsset[indexPath.row].weight.toDouble(), diamondRate: diamondPrice.toDouble())
                        
                        let rateTotal = String(format: "%.2f", daitotal)
                        cell.lblDiamondTotal.text = "₹ " + rateTotal
                            
                            //MARK:- Diamond Color Clarity
                            cell.lblDiamondColorClarity.text = self.diamondAsset[indexPath.row].defaultColorClarity
                            
                            
                            cell.d1Btn.layer.borderColor = UIColor.black.cgColor
                            cell.d1Btn.layer.borderWidth = 0.5
                            cell.d1Btn.layer.cornerRadius = cell.d1Btn.frame.height / 2
                            cell.d1Btn.clipsToBounds = true
                                    
                            cell.d2Btn.layer.borderColor = UIColor.black.cgColor
                            cell.d2Btn.layer.borderWidth = 0.5
                            cell.d2Btn.layer.cornerRadius = cell.d2Btn.frame.height / 2
                            cell.d2Btn.clipsToBounds = true
                                    
                            cell.d3Btn.layer.borderColor = UIColor.black.cgColor
                            cell.d3Btn.layer.borderWidth = 0.5
                            cell.d3Btn.layer.cornerRadius = cell.d3Btn.frame.height / 2
                            cell.d3Btn.clipsToBounds = true
                                    
                            cell.d4Btn.layer.borderColor = UIColor.black.cgColor
                            cell.d4Btn.layer.borderWidth = 0.5
                            cell.d4Btn.layer.cornerRadius = cell.d4Btn.frame.height / 2
                            cell.d4Btn.clipsToBounds = true
                                    
                            cell.d5Btn.layer.borderColor = UIColor.black.cgColor
                            cell.d5Btn.layer.borderWidth = 0.5
                            cell.d5Btn.layer.cornerRadius = cell.d5Btn.frame.height / 2
                            cell.d5Btn.clipsToBounds = true
                        
                        cell.d6BtnC.layer.borderColor = UIColor.black.cgColor
                        cell.d6BtnC.layer.borderWidth = 0.5
                        cell.d6BtnC.layer.cornerRadius = cell.d5Btn.frame.height / 2
                        cell.d6BtnC.clipsToBounds = true
                                
                            cell.d1Btnc.layer.borderColor = UIColor.black.cgColor
                            cell.d1Btnc.layer.borderWidth = 0.5
                            cell.d1Btnc.layer.cornerRadius = cell.d1Btnc.frame.height / 2
                            cell.d1Btnc.clipsToBounds = true
                                
                            cell.d2Btnc.layer.borderColor = UIColor.black.cgColor
                            cell.d2Btnc.layer.borderWidth = 0.5
                            cell.d2Btnc.layer.cornerRadius = cell.d2Btnc.frame.height / 2
                            cell.d2Btnc.clipsToBounds = true
                                
                            cell.d3Btnc.layer.borderColor = UIColor.black.cgColor
                            cell.d3Btnc.layer.borderWidth = 0.5
                            cell.d3Btnc.layer.cornerRadius = cell.d3Btnc.frame.height / 2
                            cell.d3Btnc.clipsToBounds = true
                                
                            cell.d4Btnc.layer.borderColor = UIColor.black.cgColor
                            cell.d4Btnc.layer.borderWidth = 0.5
                            cell.d4Btnc.layer.cornerRadius = cell.d4Btnc.frame.height / 2
                            cell.d4Btnc.clipsToBounds = true
                                
                            cell.d5Btnc.layer.borderColor = UIColor.black.cgColor
                            cell.d5Btnc.layer.borderWidth = 0.5
                            cell.d5Btnc.layer.cornerRadius = cell.d4Btnc.frame.height / 2
                            cell.d5Btnc.clipsToBounds = true
                        
                        
                        if ispr == true {
                            
                            cell.viewPrice.isHidden = true
                            cell.viewDiaNo.isHidden = true
                            cell.viewDiaTotal.isHidden = true
                            cell.viewColCla.isHidden = true
                           
                        }else {
                            cell.viewPrice.isHidden = false
                            if self.diamondAsset[indexPath.row].quantity != "0" {
                                cell.viewDiaNo.isHidden = false
                                
                                  
                            }
                            else {
                                cell.viewDiaNo.isHidden = true
                            }
                            cell.viewDiaTotal.isHidden = false
                            cell.viewColCla.isHidden = false
                        }
                        
                        return cell
                    }
                    let cell = tableView.dequeueReusableCell(withIdentifier: "diamondCellCertified") as! productDiamondCellCertified
                    cell.d1Btn.isHidden = true
                    cell.d2Btn.isHidden = true
                    cell.d3Btn.isHidden = true
                    cell.d4Btn.isHidden = true
                    cell.d5Btn.isHidden = true
                    
                    cell.d1Btnc.isHidden = true
                    cell.d2Btnc.isHidden = true
                    cell.d3Btnc.isHidden = true
                    cell.d4Btnc.isHidden = true
                    cell.d5Btnc.isHidden = true
                    
                    let diamondBtn = [cell.d1Btn,cell.d2Btn,cell.d3Btn,cell.d4Btn,cell.d5Btn]
                    let diamondBtnC = [cell.d1Btnc,cell.d2Btnc,cell.d3Btnc,cell.d4Btnc,cell.d5Btnc]
                    
                    
                    
                    cell.diamondTypeBtn.setTitle(self.diamondAsset[indexPath.row].jwellerySize, for: .normal)
                let diamondColor = self.diamondAsset[indexPath.row].color.components(separatedBy: ",")
                for i in  0 ..< diamondColor.count {
                    diamondBtn[i]?.tag = indexPath.row
                    diamondBtn[i]?.isHidden = false
                    diamondBtn[i]?.setTitle(diamondColor[i], for: .normal)
                    diamondBtn[i]?.addTarget(self, action: #selector(diamondColoBtn(_:)), for: .touchUpInside)
                    diamondBtn[i]?.backgroundColor = UIColor.white
                    diamondBtn[i]?.setTitleColor(.black, for: .normal)
                }
                   
                    let diamondClarity = self.diamondAsset[indexPath.row].clarity.components(separatedBy: ",")
                        for i in  0 ..< diamondClarity.count {
                        diamondBtnC[i]?.tag = indexPath.row
                        diamondBtnC[i]?.isHidden = false
                        diamondBtnC[i]?.setTitle(diamondClarity[i], for: .normal)
                        diamondBtnC[i]?.addTarget(self, action: #selector(diamondClarityBtn(_:)), for: .touchUpInside)
                        diamondBtnC[i]?.backgroundColor = UIColor.white
                        diamondBtnC[i]?.setTitleColor(.black, for: .normal)
                    }
                   
                    let clrTemp = NSMutableArray()
                for i in 0 ..< diamondBtn.count {
                    print(diamondBtn[i]?.titleLabel?.text ?? "")
                    print(self.diamondColorTemp)
                            
                    if diamondBtn[i]?.titleLabel?.text! == self.diamondColorTemp {
                        diamondBtn[i]?.backgroundColor = UIColor.init(named: "base_color")
                        diamondBtn[i]?.setTitleColor(.white, for: .normal)
                        
                        let tempdic = ["name":diamondBtn[i]?.titleLabel?.text!,"value":"1"]
                        
                        clrTemp.add(tempdic)
                    }else {
                        let tempdic = ["name":diamondBtn[i]?.titleLabel?.text!,"value":"0"]
                        clrTemp.add(tempdic)
                    }
                }
                    
                   
                        
                    let tempdic = ["name":self.diamondAsset[indexPath.row].jwellerySize,"value":clrTemp] as [String : Any]
                    
                    if self.newcolorarray.count != 0 {
                        for i in 0..<self.newcolorarray.count {
                            let name = self.newcolorarray[i]["name"] as! String
                            if name == self.diamondAsset[indexPath.row].jwellerySize {
                                self.newcolorarray.remove(at: i)
                                self.newcolorarray.insert(tempdic, at: i)
                                break
                            }
                        }
                        
                    }else {
                        self.newcolorarray.append(tempdic)
                    }
                    
                     
                    
                    
                    
                    let clarityTemp = NSMutableArray()
                    
                    
                    
                    self.clarArr = []
                    for i in 0 ..< diamondBtnC.count {
                        let btnName = diamondBtnC[i]?.titleLabel?.text! ?? ""
                        if btnName == self.diamondClarityTemp {
                            
                            diamondBtnC[i]?.backgroundColor = UIColor.init(named: "base_color")
                            diamondBtnC[i]?.setTitleColor(.white, for: .normal)
                            let tempdic = ["name":btnName,"value":"1"]
                            clarityTemp.add(tempdic)
                        }else {
                            let tempdic = ["name":btnName,"value":"0"]
                            clarityTemp.add(tempdic)
                        }
                    }
                      
                    
                    
                    let tempdic1 = ["name":self.diamondAsset[indexPath.row].jwellerySize,"value":clarityTemp] as [String : Any]
                    
                    if self.newClarityarray.count != 0 {
                        for i in 0..<self.newClarityarray.count {
                            let name = self.newClarityarray[i]["name"] as! String
                            if name == self.diamondAsset[indexPath.row].jwellerySize {
                                self.newClarityarray.remove(at: i)
                                self.newClarityarray.insert(tempdic1, at: i)
                                break
                            }
                        }
                        
                    }else {
                        self.newClarityarray.append(tempdic1)
                    }
                    
                    
        //            for i in 0 ..< diamondBtn.count {
        //                print(diamondBtn[i]?.titleLabel?.text ?? "")
        //                print(self.diamondColorTemp)
        //
        //                if diamondBtn[i]?.titleLabel?.text! == self.diamondColorTemp {
        //                    diamondBtn[i]?.backgroundColor = UIColor.init(named: "base_color")
        //                    diamondBtn[i]?.setTitleColor(.white, for: .normal)
        //                }
        //            }
        //            if self.diamondColorTemp == "" && self.diamondClarityTemp == "" {
        //                self.diamondColorTemp = diamondColor[0]
        //                self.diamondClarityTemp = diamondClarity[0]
        //            }
        //
        //            for i in 0 ..< diamondBtnC.count {
        //                let btnName = diamondBtnC[i]?.titleLabel?.text! ?? ""
        //                print(btnName)
        //                if btnName == self.diamondClarityTemp {
        //                    diamondBtnC[i]?.backgroundColor = UIColor.init(named: "base_color")
        //                    diamondBtnC[i]?.setTitleColor(.white, for: .normal)
        //                }
        //            }
        //                if self.diamondColorTemp == "" && self.diamondClarityTemp == "" {
        //                    self.diamondColorTemp = diamondColor[0]
        //                    self.diamondClarityTemp = diamondClarity[0]
        //                }
                   
                    //MARK:- Name label
                    cell.lblName.text = self.diamondAsset[indexPath.row].jwellerySize
                    self.diaType = self.diamondAsset[indexPath.row].jwellerySize
                    //MARK:- Weight Label
                    cell.lblWeight.text = self.diamondAsset[indexPath.row].weight + " Ct"
                    
                    //MARK:- Daimond Price
                    var diamondPrice = ""
                    for i in self.product!.price.diamondMaster {
                        
                        if i.diamond_type == self.diamondAsset[indexPath.row].jwellerySize {
                            if i.type == self.diamondAsset[indexPath.row].defaultColorClarity {
                                if i.diamond_type == self.diamondAsset[indexPath.row].jwellerySize {
                                    diamondPrice = i.price
                                    
                                }
                            }
                        }
                        
                        
                    }
                    cell.lblPrice.text = "₹" + diamondPrice + "/ Ct"
                    
                    //MARK:- No of Diamond
                    cell.lblNoDiamond.text = self.diamondAsset[indexPath.row].quantity + " Pc"
                    
                    
                    //MARK:- Diamond Color Clarity
                    cell.lblDiamondColorClarity.text = self.diamondAsset[indexPath.row].defaultColorClarity
                    
                    //MARK:- Certificate charge
                    cell.lblCertificateCharges.text = self.diamondAsset[indexPath.row].certificationCost
                    
                    
                    var certCost = 0.0
                    if self.diamondAsset[indexPath.row].crtcostOption == "PerCarat" {
                        //MARK:- Certificate charge
                        cell.lblCertificateCharges.text = "₹" + self.diamondAsset[indexPath.row].certificationCost + " /Ct"
                        
                        
                        certCost = self.diamondAsset[indexPath.row].weight.toDouble() * self.diamondAsset[indexPath.row].certificationCost.toDouble()
                    } else if self.diamondAsset[indexPath.row].crtcostOption == "Fixed" {
                        //MARK:- Certificate charge
                        cell.lblCertificateCharges.text = "₹" + self.diamondAsset[indexPath.row].certificationCost
                        
                        certCost = self.diamondAsset[indexPath.row].certificationCost.toDouble()
                    }
                    
                    //MARK:- Total Certification Charge
                    cell.lblTotalCertificateCharges.text = "₹ " + certCost.toString()
                    
                    //MARK:- Total Diamond
                    cell.lblDiamondTotal.text = "₹ " + (PriceCalculation.shared.diamondPrice(diamondWeight: self.diamondAsset[indexPath.row].weight.toDouble(), diamondRate: diamondPrice.toDouble()) + certCost).toString()
                    
                    cell.d1Btn.layer.borderColor = UIColor.black.cgColor
                    cell.d1Btn.layer.borderWidth = 0.5
                    cell.d1Btn.layer.cornerRadius = cell.d1Btn.frame.height / 2
                    cell.d1Btn.clipsToBounds = true
                            
                    cell.d2Btn.layer.borderColor = UIColor.black.cgColor
                    cell.d2Btn.layer.borderWidth = 0.5
                    cell.d2Btn.layer.cornerRadius = cell.d2Btn.frame.height / 2
                    cell.d2Btn.clipsToBounds = true
                            
                    cell.d3Btn.layer.borderColor = UIColor.black.cgColor
                    cell.d3Btn.layer.borderWidth = 0.5
                    cell.d3Btn.layer.cornerRadius = cell.d3Btn.frame.height / 2
                    cell.d3Btn.clipsToBounds = true
                            
                    cell.d4Btn.layer.borderColor = UIColor.black.cgColor
                    cell.d4Btn.layer.borderWidth = 0.5
                    cell.d4Btn.layer.cornerRadius = cell.d4Btn.frame.height / 2
                    cell.d4Btn.clipsToBounds = true
                            
                    cell.d5Btn.layer.borderColor = UIColor.black.cgColor
                    cell.d5Btn.layer.borderWidth = 0.5
                    cell.d5Btn.layer.cornerRadius = cell.d5Btn.frame.height / 2
                    cell.d5Btn.clipsToBounds = true
                        
                    cell.d1Btnc.layer.borderColor = UIColor.black.cgColor
                    cell.d1Btnc.layer.borderWidth = 0.5
                    cell.d1Btnc.layer.cornerRadius = cell.d1Btnc.frame.height / 2
                    cell.d1Btnc.clipsToBounds = true
                        
                    cell.d2Btnc.layer.borderColor = UIColor.black.cgColor
                    cell.d2Btnc.layer.borderWidth = 0.5
                    cell.d2Btnc.layer.cornerRadius = cell.d2Btnc.frame.height / 2
                    cell.d2Btnc.clipsToBounds = true
                        
                    cell.d3Btnc.layer.borderColor = UIColor.black.cgColor
                    cell.d3Btnc.layer.borderWidth = 0.5
                    cell.d3Btnc.layer.cornerRadius = cell.d3Btnc.frame.height / 2
                    cell.d3Btnc.clipsToBounds = true
                        
                    cell.d4Btnc.layer.borderColor = UIColor.black.cgColor
                    cell.d4Btnc.layer.borderWidth = 0.5
                    cell.d4Btnc.layer.cornerRadius = cell.d4Btnc.frame.height / 2
                    cell.d4Btnc.clipsToBounds = true
                        
                    cell.d5Btnc.layer.borderColor = UIColor.black.cgColor
                    cell.d5Btnc.layer.borderWidth = 0.5
                    cell.d5Btnc.layer.cornerRadius = cell.d4Btnc.frame.height / 2
                    cell.d5Btnc.clipsToBounds = true
                    
                    if ispr == true {
                        
                        cell.viewPrice.isHidden = true
                        cell.viewDiaNo.isHidden = true
                        cell.viewDiaTotal.isHidden = true
                        cell.viewColcla.isHidden = true
                        cell.viewCertTotal.isHidden = true
                        cell.viewCertCharge.isHidden = true
                       
                    }else {
                        cell.viewPrice.isHidden = false
                        cell.viewDiaNo.isHidden = false
                        cell.viewDiaTotal.isHidden = false
                        cell.viewColcla.isHidden = false
                        cell.viewCertTotal.isHidden = false
                        cell.viewCertCharge.isHidden = false
                    }
                    
                    
                    return cell
                } else if indexPath.section == 3 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "stoneCell") as! productStoneCell
                    
                    
                    if self.arrFinalStone[indexPath.row]["stoneInside"] == nil {
                        cell.downArrow.isHidden  = true
                        cell.btnStoneType.isUserInteractionEnabled = false
                        cell.btnStoneType.layer.borderWidth = 1.0
                        cell.btnStoneType.layer.borderColor = UIColor.darkGray.cgColor
                        cell.btnStoneType.setTitle(self.arrFinalStone[indexPath.row]["jwellerySize"] as! String, for: .normal)
                        
                        
                        if self.arrFinalStone[indexPath.row]["quantity"] as! String == "0" ||  self.arrFinalStone[indexPath.row]["quantity"] as! String == "" {
                            cell.viewMain.isHidden = true
                            
                        }else {
                            cell.viewMain.isHidden = false
                        }
                        
                        cell.lblNoOfStone.text = self.arrFinalStone[indexPath.row]["quantity"] as! String + " Pc"
                        let we = self.arrFinalStone[indexPath.row]["weight"] as! String
                        let ston = String(format: "%.3f", we.toDouble())
                                   cell.lblStoneWeight.text = ston + " Ct"
                       
                                   var stonRate = ""
                                   for i in self.product!.price.stone {
                                       if i.type == (self.arrFinalStone[indexPath.row]["jwellerySize"] as! String).uppercased() {
                                           stonRate = i.price
                                       }
                                   }
                                   let stonrat = String(format: "%.1f", stonRate.toDouble())
                                   cell.lblStonePrice.text = stonrat + "/ Ct"
                                   stonRate = stonrat
                       
                                    
                                   let stonratotal = String(format: "%.2f", (stonRate.toDouble() * we.toDouble()))
                       
                       
                                   cell.lblStoneTotal.text = "₹ " + stonratotal
                        
                        
                        
                    }else {
                        cell.downArrow.isHidden  = false
                        cell.btnStoneType.tag = indexPath.row
                        cell.btnStoneType.isUserInteractionEnabled = true
                        cell.btnStoneType.addTarget(self, action: #selector(selectStone(_:)), for: .touchUpInside)
                        let arrmain = self.arrFinalStone[indexPath.row]["stoneInside"] as! [[String:Any]]
                        
                        cell.btnStoneType.setTitle(arrmain[0]["jwellerySize"] as! String, for: .normal)
                        if self.arrFinalStone[indexPath.row]["quantity"] as! String == "0" ||  self.arrFinalStone[indexPath.row]["quantity"] as! String == "" {
                            cell.viewMain.isHidden = true
                            
                        }else {
                            cell.viewMain.isHidden = false
                        }
                        cell.lblNoOfStone.text = arrmain[0]["quantity"] as! String + " Pc"
                        let we = arrmain[0]["weight"] as! String
                        let ston = String(format: "%.3f", we.toDouble())
                                   cell.lblStoneWeight.text = ston + " Ct"
                       
                                   var stonRate = ""
                                   for i in self.product!.price.stone {
                                       if i.type == (arrmain[0]["jwellerySize"] as! String).uppercased() {
                                           stonRate = i.price
                                       }
                                   }
                                   let stonrat = String(format: "%.1f", stonRate.toDouble())
                                   cell.lblStonePrice.text = stonrat + "/ Ct"
                                   stonRate = stonrat
                       
                                    
                                   let stonratotal = String(format: "%.2f", (stonRate.toDouble() * we.toDouble()))
                       
                       
                                   cell.lblStoneTotal.text = "₹ " + stonratotal
                        
                    }
                    
                    
                    if ispr == true {
                        
                        cell.viewRate.isHidden = true
                        cell.viewTot.isHidden = true
                        
                       
                    }else {
                        cell.viewRate.isHidden = false
                        cell.viewTot.isHidden = false
                    }
        //            cell.btnStoneType.setTitle(self.stoneAsset[indexPath.row].jwellerySize, for: .normal)
        //
        //
        //            cell.lblNoOfStone.text = self.stoneAsset[indexPath.row].quantity + " Pc"
        //
        //            let ston = String(format: "%.3f", self.stoneAsset[indexPath.row].weight.toDouble())
        //            cell.lblStoneWeight.text = ston + " Ct"
        //
        //            var stonRate = ""
        //            for i in self.product!.price.stone {
        //                if i.type == self.stoneAsset[indexPath.row].jwellerySize.uppercased() {
        //                    stonRate = i.price
        //                }
        //            }
        //            let stonrat = String(format: "%.1f", stonRate.toDouble())
        //            cell.lblStonePrice.text = stonrat + "/ Ct"
        //            stonRate = stonrat
        //
        //
        //            let stonratotal = String(format: "%.2f", (stonRate.toDouble() * self.stoneAsset[indexPath.row].weight.toDouble()))
        //
        //
        //            cell.lblStoneTotal.text = "₹ " + stonratotal
                    return cell
                } else if indexPath.section == 4 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "platinumCell") as! productPlatinumCell
                    
                    //MARK:- Product Code
                    cell.lblProdcutCode.text = "  " + (self.product?.data.productcode)!
                    
                    //MARK:- Platinum Price
                    let price = self.product?.price.platinum[0].price
                    let pricetot = String(format: "%.2f", price?.toDouble() as! CVarArg)
                    cell.lblPlatinumPrice.text = "  " + "₹ " + pricetot + " /g"
                    
                    //MARK:- Platinum weight
                    let weight = self.platinumAsset[indexPath.row].weight
                    let weighttot = String(format: "%.3f", weight.toDouble() as! CVarArg)
                    cell.lblPlatinumWeight.text = "  " + weighttot + " g"
                    
                    //MARK:- Platinum Purity
                    cell.lblPlatinumPurity.text = "  " + self.platinumAsset[indexPath.row].purity + "%"
                    
                    //MARK:- Platinum Wastage
                    
                    
                    let wastage = self.platinumAsset[indexPath.row].wastage
                    
                    if wastage == "" || wastage == "<null>"{
                        cell.viewastage.isHidden = true
                    }else {
                        cell.viewastage.isHidden = false
                        cell.lblPlatinumWasteage.text = "  " + self.platinumAsset[indexPath.row].wastage + "%"
                        
                        if self.ispr == true {
                            cell.viewastage.isHidden = true
                        }else {
                            cell.viewastage.isHidden = false
                        }
                    }
                    
                    
                    //MARK:- Platinum Makig Charge
                    let smakingCharge = self.platinumAsset[indexPath.row].makingCharge
                    let smakingChargetot = String(format: "%.2f", smakingCharge.toDouble() as! CVarArg)
                    cell.lblPlatinumMakingCharge.text = "  " + "₹ " + smakingChargetot + " /g"
                    
                    //MARK:- Total Making Charge
                    var makingCharge = 0.0
                    var totalweight = 0.0
                    if ischange == false {
                         totalweight = sizeCalculation(selectedSize: Int((self.product?.data.defaultSize)!)!, weight: self.platinumAsset[indexPath.row].weight.toDouble())
                    }else {
                        totalweight = self.platinumAsset[indexPath.row].weight.toDouble()
                    }
                    
                    
                    
                    if self.platinumAsset[indexPath.row].chargesOption == "PerGram" {
                        makingCharge = PriceCalculation.shared.platinumMaking(weight: totalweight, rate: self.platinumAsset[indexPath.row].makingCharge.toDouble(), isPerGram: true)
                    } else if self.platinumAsset[indexPath.row].chargesOption == "Fixed" || self.platinumAsset[indexPath.row].chargesOption == "PerPiece" {
                        makingCharge = PriceCalculation.shared.platinumMaking(weight: self.platinumAsset[indexPath.row].weight.toDouble(), rate: self.platinumAsset[indexPath.row].makingCharge.toDouble(), isPerGram: false)
                    }
                    
                    //MARK:- Meena Cost
                    var finalMeenaCost = 0.0
                    if self.platinumAsset[indexPath.row].meenacostOption == "PerGram" {
                        let meenaCost = PriceCalculation.shared.MeenaCost(meenaRate: self.platinumAsset[indexPath.row].meenaCost.toDouble(), weight: self.platinumAsset[indexPath.row].weight.toDouble(), isPergram: true)
                        finalMeenaCost = meenaCost
                    } else if self.platinumAsset[indexPath.row].meenacostOption == "Fixed" {
                        let meenaCost = PriceCalculation.shared.MeenaCost(meenaRate: self.platinumAsset[indexPath.row].meenaCost.toDouble(), weight: self.platinumAsset[indexPath.row].weight.toDouble(), isPergram: false)
                        finalMeenaCost = meenaCost
                    }
                    
                    cell.lblTotalMakingCharge.text = "  " + "₹ " + makingCharge.toString()
                    
                    //MARK:- Platinum Total
                    let tot = (PriceCalculation.shared.platinumPrice(weight: totalweight, rate: (self.product?.price.platinum[0].price.toDouble())!, wastage: self.platinumAsset[indexPath.row].wastage.toDouble(), purity: self.platinumAsset[indexPath.row].purity.toDouble())) + makingCharge + finalMeenaCost
                    let plate = String(format: "%.2f", tot)
                   
                    
                    cell.lblPlatinumTotal.text = "  " + "₹ " + plate
                    
                    if self.ispr == true {
                        cell.viewPrice.isHidden = true
                        cell.viewPurity.isHidden = true
                        cell.viewWeigh.isHidden = true
                        cell.viewMaking.isHidden = true
                        cell.viewTotalMakingCharge.isHidden = true
                        cell.viewMakingCharge.isHidden = true
                    }else {
                        cell.viewPrice.isHidden = false
                        
                        cell.viewPurity.isHidden = false
                        cell.viewWeigh.isHidden = false
                        cell.viewMaking.isHidden = false
                        cell.viewTotalMakingCharge.isHidden = false
                        cell.viewMakingCharge.isHidden = false
                    }
                    
                    
                    return cell
                } else if indexPath.section == 5 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "goldCell") as! GoldDetailCell
                    cell.k12Btn.isHidden = true
                    cell.k18Btn.isHidden = true
                    cell.k8Btn.isHidden = true
                    cell.k16Btn.isHidden = true
                    let btnArr = [cell.k8Btn,cell.k12Btn,cell.k16Btn,cell.k18Btn]
                    
                    for i in 0 ..< self.goldAsset.count {
                        
                        btnArr[i]?.isHidden = false
                        btnArr[i]?.setTitle(self.goldAsset[i].jwellerySize, for: .normal)
                        btnArr[i]?.addTarget(self, action: #selector(goldSelect(_:)), for: .touchUpInside)
                        btnArr[i]?.backgroundColor = UIColor.white
                        btnArr[i]?.setTitleColor(.black, for: .normal)
                    }
                    if self.goldAsset.count > 0 {
                        for i in btnArr {
                            if i?.titleLabel?.text == self.goldAsset[self.selectedIndGold].jwellerySize {
                                i?.backgroundColor = UIColor.init(named: "base_color")
                                i?.setTitleColor(.white, for: .normal)
                                self.selectedgoldtype = (i?.titleLabel?.text)!
                                //self.defualttype = (0.titleLabel?.text)!
                            }
                        }
                    }
                    
                    cell.k12Btn.layer.borderColor = UIColor.black.cgColor
                    cell.k12Btn.layer.borderWidth = 1
                    cell.k12Btn.layer.cornerRadius = cell.k12Btn.frame.height / 2
                    cell.k12Btn.clipsToBounds = true
                        
                    cell.k18Btn.layer.borderColor = UIColor.black.cgColor
                    cell.k18Btn.layer.borderWidth = 1
                    cell.k18Btn.layer.cornerRadius = cell.k18Btn.frame.height / 2
                    cell.k18Btn.clipsToBounds = true
                        
                    cell.k8Btn.layer.borderColor = UIColor.black.cgColor
                    cell.k8Btn.layer.borderWidth = 1
                    cell.k8Btn.layer.cornerRadius = cell.k8Btn.frame.height / 2
                    cell.k8Btn.clipsToBounds = true
                        
                    cell.k16Btn.layer.borderColor = UIColor.black.cgColor
                    cell.k16Btn.layer.borderWidth = 1
                    cell.k16Btn.layer.cornerRadius = cell.k16Btn.frame.height / 2
                    cell.k16Btn.clipsToBounds = true
                    
                    
                    cell.producCodeLbl.text = self.product?.data.productcode
                    
                    //MARK:- Value In Calc
                    var valueIn = ""
                    
                    print(self.goldAsset.count)
                    if self.goldAsset.count > 0 {
                        let goldType = self.goldAsset[self.selectedIndGold].jwellerySize
                        for i in self.product!.price.gold {
                            if goldType == i.type {
                                print(i.valueIn)
                                let type = String(format: "%.2f", i.valueIn.toDouble())
                                cell.goldPurityLbl.text = type + "%"
                                valueIn = i.valueIn
                            }
                        }
                    }
                        
                    
                    
                   
                    
                    //MARK:- Net Gold Weight
                    let netgold = Double(self.goldAsset[self.selectedIndGold].weight)
                    
                    let netgoldy = String(format: "%.3f", netgold!)
                    cell.netGoldWeightLbl.text = netgoldy + " g"
                    
                    if ispr == true {
                        
                        cell.viewNetGoldWeight.isHidden = true
                    }else {
                        cell.viewNetGoldWeight.isHidden = false
                    }
                    
                    //MARK:- Gold Making Charge
                    
                    let Making = Double(self.goldAsset[self.selectedIndGold].makingCharge)
                    
                    if Making != 0 {
                        cell.viewMakingCharge.isHidden = false
                         cell.viewTotalMakingCharge.isHidden = false
                        let Makingy = String(format: "%.1f", Making!)
                        cell.goldMakingChargeLbl.text = "₹ " + Makingy + "/ g"
                        
                        if ispr == true {
                            
                            cell.viewMakingCharge.isHidden = true
                        }else {
                            cell.viewMakingCharge.isHidden = false
                        }
                        
                    }else {
                        cell.viewTotalMakingCharge.isHidden = true
                        cell.viewMakingCharge.isHidden = true
                    }
                    
                    var  wastage = Double(self.goldAsset[self.selectedIndGold].wastage)
                    if wastage == nil {
                        wastage = 0
                    }
                    if wastage != 0 {
                        cell.viewGoldWastage.isHidden = false
                        let wastagey = String(format: "%.1f", wastage!)
                        cell.lblWastage.text = wastagey + " %"
                        
                        if ispr == true {
                            
                            cell.viewGoldWastage.isHidden = true
                        }else {
                            cell.viewGoldWastage.isHidden = false
                        }
                        
                    }else {
                        cell.viewGoldWastage.isHidden = true
                    }
                    
                    let value = valueIn.toDouble()
                    let mainweight = netgoldy.toDouble()
                    var was = wastage
                    
                    if self.goldAsset[self.selectedIndGold].chargesOption == "Percentage" {
                        was = self.goldAsset[self.selectedIndGold].makingCharge.toDouble()
                    }
                    
                    
                    
                    let fineWeight = mainweight * (value+was!) / 100
                    //MARK:- Fine Gold Weight
                //    let purity = fineWeight.toDouble() / 100
                    let finew = String(format: "%.3f", fineWeight)
                    cell.fineGoldWeightlbl.text = finew + " g"
                    
                    //MARK:- Fine Gold Rate
                    var goldRate = 0.0
                    var mainrate = 0.0
                    for i in self.product!.price.gold {
                        print(i.price)
                        if i.type == "24KT" {
                            print(i.price)
                            let rate = String(format: "%.2f", i.price.toDouble())
                            cell.fineGoldRateLbl.text = "₹ " + rate + " / g"
                            mainrate = rate.toDouble()
                            goldRate = i.price.toDouble()
                        }
                    }
                    
                    //MARK:- Meena Cost
                    var finalMeenaCost = 0.0
                    if self.goldAsset[self.selectedIndGold].meenacostOption == "PerGram" {
                        let meenaCost = PriceCalculation.shared.MeenaCost(meenaRate: self.goldAsset[self.selectedIndGold].meenaCost.toDouble(), weight: self.goldAsset[self.selectedIndGold].weight.toDouble(), isPergram: true)
                        finalMeenaCost = meenaCost
                    } else if self.goldAsset[self.selectedIndGold].meenacostOption == "Fixed" {
                        let meenaCost = PriceCalculation.shared.MeenaCost(meenaRate: self.goldAsset[self.selectedIndGold].meenaCost.toDouble(), weight: self.goldAsset[self.selectedIndGold].weight.toDouble(), isPergram: false)
                        finalMeenaCost = meenaCost
                    }
                    
                    //MARK:- MakingCharges
                    var makingCharge = 0.0
                    if self.goldAsset[self.selectedIndGold].chargesOption == "PerGram" {
                       makingCharge = PriceCalculation.shared.goldMakingCharge(goldWeight: self.goldAsset[self.selectedIndGold].weight.toDouble(), makingTypeFixed: false, makingChargeRate: self.goldAsset[self.selectedIndGold].makingCharge.toDouble())
                        cell.viewTotalMakingCharge.isHidden = false
                    } else if self.goldAsset[self.selectedIndGold].chargesOption == "Fixed" {
                        makingCharge = PriceCalculation.shared.goldMakingCharge(goldWeight: self.goldAsset[self.selectedIndGold].weight.toDouble(), makingTypeFixed: true, makingChargeRate: self.goldAsset[self.selectedIndGold].makingCharge.toDouble())
                        cell.viewTotalMakingCharge.isHidden = false
                    }else {
                        
                        let value = valueIn.toDouble()
                        let mainweight = netgoldy.toDouble()
                        let was = self.goldAsset[self.selectedIndGold].makingCharge.toDouble()
                        makingCharge = mainweight * (value+was) / 100
                        cell.viewTotalMakingCharge.isHidden = true
                        cell.lblMakingTitle.text = "Gold wastage"
                        
                    }
                    
                    
                    //MARK:- Total Making Charge
                    let totalMakingCharge = self.goldAsset[self.selectedIndGold].makingCharge.toDouble() * self.goldAsset[self.selectedIndGold].weight.toDouble()
                    let maintotalMakingCharge = String(format: "%.2f", totalMakingCharge)
                    
                    cell.totalMakingChargelbl.text = "₹ " + maintotalMakingCharge
                    
                    if totalMakingCharge == 0 {
                        cell.viewTotalMakingCharge.isHidden = true
                    }
                    //MARK:- Total Amount
                    var totalmain = Double()
                    
                    if self.goldAsset[self.selectedIndGold].chargesOption == "Percentage" {
                        totalmain = (PriceCalculation.shared.goldPrice(goldRate: mainrate, goldweight: netgoldy.toDouble(), goldPurity: valueIn.toDouble(), goldWastage: was!) + finalMeenaCost)
                    }else {
                        totalmain = (PriceCalculation.shared.goldPrice(goldRate: mainrate, goldweight: netgoldy.toDouble(), goldPurity: valueIn.toDouble(), goldWastage: was!) + finalMeenaCost + makingCharge)
                    }

                    
                    
                     
                    let stotalmain = String(format: "%.3f", totalmain)
                    
                    let numberFormatter = NumberFormatter()
                    numberFormatter.minimumFractionDigits = 2
                    numberFormatter.maximumFractionDigits = 2
                    numberFormatter.roundingMode = .down
                    let str = numberFormatter.string(from: NSNumber(value: totalmain))
                   // let str2 = numberFormatter.string(from: NSNumber(value: num2))
                    
                    
                    cell.totalAmount.text = "₹ " + str!
                    
                    if ispr == true {
                        
                        cell.viewTotalAmount.isHidden = true
                  
                        cell.viewPurity.isHidden = true
                        cell.viewFineGoldRate.isHidden = true
                        cell.viewFineGoldWeight.isHidden = true
                    }else {
                        cell.viewTotalAmount.isHidden = false
                       
                        cell.viewPurity.isHidden = false
                        cell.viewFineGoldRate.isHidden = false
                        cell.viewFineGoldWeight.isHidden = false
                    }
                    
                    
                    
                    return cell
                } else if indexPath.section == 6 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "certifiedByCell") as! productCertifiedByCell
                    cell.img1.isHidden = true
                    cell.img2.isHidden = true
                    cell.img3.isHidden = true
                    
                    var imgArr = [cell.img1,cell.img2,cell.img3]
                    for i in 0 ..< self.product!.certification.count {
                        imgArr[i]?.isHidden = false
                        imgArr[i]?.kf.indicatorType = .activity
                        imgArr[i]?.kf.setImage(with: URL(string: self.product!.certification[i].image),placeholder: nil,options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
                            switch result {
                            case .success(let value):
                                print("Task done for: \(value.source.url?.absoluteString ?? "")")
                                
                            case .failure(let error):
                                print("Job failed: \(error.localizedDescription)")
                                
                            }
                        }
                    }
                    return cell
                } else if indexPath.section == 7 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "manufactureCell") as! productManufactureByCell
                    cell.lbl1.numberOfLines = 0
                    cell.img.kf.indicatorType = .activity
                    print(self.manufactureURL)
                    
                    var urlString = self.product?.manufacture.logo.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                    cell.img.kf.setImage(with: URL(string: (urlString)!),placeholder: nil,options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
                        switch result {
                        case .success(let value):
                            print("Task done for: \(value.source.url?.absoluteString ?? "")")
                                           
                        case .failure(let error):
                            print("Job failed: \(error.localizedDescription)")
                        }
                    }
                    cell.lbl1.text = self.product?.manufacture.companyName
                    return cell
                } else if indexPath.section == 8 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "descriptionCell") as! productOtherDetailsCell
                    cell.txtDetails.attributedText = self.product?.data.dataDescription.convertHtml(str: (self.product?.data.dataDescription)!)
                    return cell
                } else if indexPath.section == 9 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "priceCell") as! productPriceCell
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        cell.lblTotalPrice.text = "₹ " + self.calculateTotalPrice()
                        var sentence = self.productCode.text
                        let wordToRemove = "Gross weight :"
                        if let range = sentence!.range(of: wordToRemove) {
                            sentence!.removeSubrange(range)
                            cell.lblGrossWe.text = sentence
                        }

                        
                    }
                    
                    if ispr == true {
                       // cell.lblToTtitle.isHidden = true
                        cell.lblTotalPrice.isHidden = true
                    }else {
                       // cell.lblToTtitle.isHidden = false
                        cell.lblTotalPrice.isHidden = false
                    }
                    
                    return cell
                }
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
                return cell!
        }else {
            
                if indexPath.section == 0 {
                    if indexPath.row == 0 {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "colorCell") as! productColorCell
                        cell.roseBtn.isHidden = true
                        cell.goldBtn.isHidden = true
                        cell.whiteBtn.isHidden = true
                        if self.product?.data.color.contains("Yellow") ?? false {
                            cell.goldBtn.isHidden = false
                            self.mycolor = "Yellow"
                        }
                        if self.product?.data.color.contains("Rose") ?? false {
                            cell.roseBtn.isHidden = false
                            self.mycolor = "Rose"
                        }
                        if self.product?.data.color.contains("White") ?? false {
                            cell.whiteBtn.isHidden = false
                            self.mycolor = "White"
                        }
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
                                            
                        return cell
                    } else if indexPath.row == 1 {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "sizecell") as! productSizeCell
                        
                        if self.product?.data.jwelleryType.lowercased() == "bangles" {
                            cell.lblTitle.text = "Select Size"
                            let defaultSize = self.product?.data.defaultSize
                            for i in self.product!.price.bangle {
                                if i.sizes == defaultSize {
                                    cell.btnSize.setTitle(i.bangleSize, for: .normal)
                                    self.productSize = i.bangleSize
                                    self.defaultSize = i.bangleSize
                                    self.defaultSizeBangle = i.bangleSize
                                }
                            }
                            cell.btnSize.layer.borderColor = UIColor.lightGray.cgColor
                            cell.btnSize.layer.borderWidth = 0.6
                            cell.btnSize.addTarget(self, action: #selector(selectSizeBangle(_:)), for: .touchUpInside)
                        } else if self.product?.data.jwelleryType == "Ring" {
                            cell.lblTitle.text = "Select Size"
                            cell.btnSize.setTitle(self.product?.data.defaultSize, for: .normal)
                            self.productSize = (self.product?.data.defaultSize)!
                            cell.btnSize.addTarget(self, action: #selector(selectSizeRing(_:)), for: .touchUpInside)
                        } else if self.product?.data.jwelleryType == "Chain" {
                            cell.lblTitle.text = "Select Length"
                            
                            cell.btnSize.setTitle(self.product?.data.defaultSize, for: .normal)
                            self.productSize = (self.product?.data.defaultSize)!
                            cell.btnSize.addTarget(self, action: #selector(selectSizeRing(_:)), for: .touchUpInside)
                            
                        }else {
                           
                            cell.isHidden = true
                        }
                        
                       
                        return cell
                    }
                    else if indexPath.row == 2 {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "codecell") as! codecell
                        
                        cell.lblCode.text = self.product?.data.productcode
                        return cell
                    }
                    else if indexPath.row == 3 {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "quantityCell") as! quantityCell
                        
                        cell.qtyLbl.text = "\(qty)"
                        cell.plusBtn.addTarget(self, action: #selector(plusBtn), for: .touchUpInside)
                        cell.minusBtn.addTarget(self, action: #selector(minusBtn), for: .touchUpInside)
                        
                        return cell
                    }
                } else if indexPath.section == 1 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "goldCell") as! GoldDetailCell
                    cell.k12Btn.isHidden = true
                    cell.k18Btn.isHidden = true
                    cell.k8Btn.isHidden = true
                    cell.k16Btn.isHidden = true
                    let btnArr = [cell.k8Btn,cell.k12Btn,cell.k16Btn,cell.k18Btn]
                    
                    for i in 0 ..< self.goldAsset.count {
                        
                        btnArr[i]?.isHidden = false
                        btnArr[i]?.setTitle(self.goldAsset[i].jwellerySize, for: .normal)
                        btnArr[i]?.addTarget(self, action: #selector(goldSelect(_:)), for: .touchUpInside)
                        btnArr[i]?.backgroundColor = UIColor.white
                        btnArr[i]?.setTitleColor(.black, for: .normal)
                    }
                    if self.goldAsset.count > 0 {
                        for i in btnArr {
                            if i?.titleLabel?.text == self.goldAsset[self.selectedIndGold].jwellerySize {
                                i?.backgroundColor = UIColor.init(named: "base_color")
                                i?.setTitleColor(.white, for: .normal)
                                self.selectedgoldtype = (i?.titleLabel?.text)!
                                //self.defualttype = (0.titleLabel?.text)!
                            }
                        }
                    }
                    
                    cell.k12Btn.layer.borderColor = UIColor.black.cgColor
                    cell.k12Btn.layer.borderWidth = 1
                    cell.k12Btn.layer.cornerRadius = cell.k12Btn.frame.height / 2
                    cell.k12Btn.clipsToBounds = true
                        
                    cell.k18Btn.layer.borderColor = UIColor.black.cgColor
                    cell.k18Btn.layer.borderWidth = 1
                    cell.k18Btn.layer.cornerRadius = cell.k18Btn.frame.height / 2
                    cell.k18Btn.clipsToBounds = true
                        
                    cell.k8Btn.layer.borderColor = UIColor.black.cgColor
                    cell.k8Btn.layer.borderWidth = 1
                    cell.k8Btn.layer.cornerRadius = cell.k8Btn.frame.height / 2
                    cell.k8Btn.clipsToBounds = true
                        
                    cell.k16Btn.layer.borderColor = UIColor.black.cgColor
                    cell.k16Btn.layer.borderWidth = 1
                    cell.k16Btn.layer.cornerRadius = cell.k16Btn.frame.height / 2
                    cell.k16Btn.clipsToBounds = true
                    
                    
                    cell.producCodeLbl.text = self.product?.data.productcode
                    
                    //MARK:- Value In Calc
                    var valueIn = ""
                    
                    print(self.goldAsset.count)
                    if self.goldAsset.count > 0 {
                        let goldType = self.goldAsset[self.selectedIndGold].jwellerySize
                        for i in self.product!.price.gold {
                            if goldType == i.type {
                                print(i.valueIn)
                                let type = String(format: "%.2f", i.valueIn.toDouble())
                                cell.goldPurityLbl.text = type + "%"
                                valueIn = i.valueIn
                            }
                        }
                    }
                        
                    
                    
                   
                    
                    //MARK:- Net Gold Weight
                    let netgold = Double(self.goldAsset[self.selectedIndGold].weight)
                    
                    let netgoldy = String(format: "%.3f", netgold!)
                    cell.netGoldWeightLbl.text = netgoldy + " g"
                    
                    if ispr == true {
                        
                        cell.viewNetGoldWeight.isHidden = true
                    }else {
                        cell.viewNetGoldWeight.isHidden = false
                    }
                    
                    //MARK:- Gold Making Charge
                    
                    let Making = Double(self.goldAsset[self.selectedIndGold].makingCharge)
                    
                    if Making != 0 {
                        cell.viewMakingCharge.isHidden = false
                         cell.viewTotalMakingCharge.isHidden = false
                        let Makingy = String(format: "%.1f", Making!)
                        cell.goldMakingChargeLbl.text = "₹ " + Makingy + "/ g"
                        
                        if ispr == true {
                            
                            cell.viewMakingCharge.isHidden = true
                        }else {
                            cell.viewMakingCharge.isHidden = false
                        }
                        
                    }else {
                        cell.viewTotalMakingCharge.isHidden = true
                        cell.viewMakingCharge.isHidden = true
                    }
                    
                    var  wastage = Double(self.goldAsset[self.selectedIndGold].wastage)
                    if wastage == nil {
                        wastage = 0
                    }
                    if wastage != 0 {
                        cell.viewGoldWastage.isHidden = false
                        let wastagey = String(format: "%.1f", wastage!)
                        cell.lblWastage.text = wastagey + " %"
                        
                        if ispr == true {
                            
                            cell.viewGoldWastage.isHidden = true
                        }else {
                            cell.viewGoldWastage.isHidden = false
                        }
                        
                    }else {
                        cell.viewGoldWastage.isHidden = true
                    }
                    
                    let value = valueIn.toDouble()
                    let mainweight = netgoldy.toDouble()
                    var was = wastage
                    
                    if self.goldAsset[self.selectedIndGold].chargesOption == "Percentage" {
                        was = self.goldAsset[self.selectedIndGold].makingCharge.toDouble()
                    }
                    
                    
                    
                    let fineWeight = mainweight * (value+was!) / 100
                    //MARK:- Fine Gold Weight
                //    let purity = fineWeight.toDouble() / 100
                    let finew = String(format: "%.3f", fineWeight)
                    cell.fineGoldWeightlbl.text = finew + " g"
                    
                    //MARK:- Fine Gold Rate
                    var goldRate = 0.0
                    var mainrate = 0.0
                    for i in self.product!.price.gold {
                        print(i.price)
                        if i.type == "24KT" {
                            print(i.price)
                            let rate = String(format: "%.2f", i.price.toDouble())
                            cell.fineGoldRateLbl.text = "₹ " + rate + " / g"
                            mainrate = rate.toDouble()
                            goldRate = i.price.toDouble()
                        }
                    }
                    
                    //MARK:- Meena Cost
                    var finalMeenaCost = 0.0
                    if self.goldAsset[self.selectedIndGold].meenacostOption == "PerGram" {
                        let meenaCost = PriceCalculation.shared.MeenaCost(meenaRate: self.goldAsset[self.selectedIndGold].meenaCost.toDouble(), weight: self.goldAsset[self.selectedIndGold].weight.toDouble(), isPergram: true)
                        finalMeenaCost = meenaCost
                    } else if self.goldAsset[self.selectedIndGold].meenacostOption == "Fixed" {
                        let meenaCost = PriceCalculation.shared.MeenaCost(meenaRate: self.goldAsset[self.selectedIndGold].meenaCost.toDouble(), weight: self.goldAsset[self.selectedIndGold].weight.toDouble(), isPergram: false)
                        finalMeenaCost = meenaCost
                    }
                    
                    //MARK:- MakingCharges
                    var makingCharge = 0.0
                    if self.goldAsset[self.selectedIndGold].chargesOption == "PerGram" {
                       makingCharge = PriceCalculation.shared.goldMakingCharge(goldWeight: self.goldAsset[self.selectedIndGold].weight.toDouble(), makingTypeFixed: false, makingChargeRate: self.goldAsset[self.selectedIndGold].makingCharge.toDouble())
                        cell.viewTotalMakingCharge.isHidden = false
                    } else if self.goldAsset[self.selectedIndGold].chargesOption == "Fixed" {
                        makingCharge = PriceCalculation.shared.goldMakingCharge(goldWeight: self.goldAsset[self.selectedIndGold].weight.toDouble(), makingTypeFixed: true, makingChargeRate: self.goldAsset[self.selectedIndGold].makingCharge.toDouble())
                        cell.viewTotalMakingCharge.isHidden = false
                    }else {
                        
                        let value = valueIn.toDouble()
                        let mainweight = netgoldy.toDouble()
                        let was = self.goldAsset[self.selectedIndGold].makingCharge.toDouble()
                        makingCharge = mainweight * (value+was) / 100
                        cell.viewTotalMakingCharge.isHidden = true
                        cell.lblMakingTitle.text = "Gold wastage"
                        
                    }
                    
                    //MARK:- Total Making Charge
                    let totalMakingCharge = self.goldAsset[self.selectedIndGold].makingCharge.toDouble() * self.goldAsset[self.selectedIndGold].weight.toDouble()
                    let maintotalMakingCharge = String(format: "%.2f", totalMakingCharge)
                    
                    cell.totalMakingChargelbl.text = "₹ " + maintotalMakingCharge
                    
                    if totalMakingCharge == 0 {
                        cell.viewTotalMakingCharge.isHidden = true
                    }
                    //MARK:- Total Amount
                    var totalmain = Double()
                    
                    if self.goldAsset[self.selectedIndGold].chargesOption == "Percentage" {
                        totalmain = (PriceCalculation.shared.goldPrice(goldRate: mainrate, goldweight: netgoldy.toDouble(), goldPurity: valueIn.toDouble(), goldWastage: was!) + finalMeenaCost)
                    }else {
                        totalmain = (PriceCalculation.shared.goldPrice(goldRate: mainrate, goldweight: netgoldy.toDouble(), goldPurity: valueIn.toDouble(), goldWastage: was!) + finalMeenaCost + makingCharge)
                    }

                    
                    
                     
                    let stotalmain = String(format: "%.3f", totalmain)
                    
                    let numberFormatter = NumberFormatter()
                    numberFormatter.minimumFractionDigits = 2
                    numberFormatter.maximumFractionDigits = 2
                    numberFormatter.roundingMode = .down
                    let str = numberFormatter.string(from: NSNumber(value: totalmain))
                   // let str2 = numberFormatter.string(from: NSNumber(value: num2))
                    
                    
                    cell.totalAmount.text = "₹ " + str!
                    
                    if ispr == true {
                        
                        cell.viewTotalAmount.isHidden = true
                  
                        cell.viewPurity.isHidden = true
                        cell.viewFineGoldRate.isHidden = true
                        cell.viewFineGoldWeight.isHidden = true
                    }else {
                        cell.viewTotalAmount.isHidden = false
                       
                        cell.viewPurity.isHidden = false
                        cell.viewFineGoldRate.isHidden = false
                        cell.viewFineGoldWeight.isHidden = false
                    }
                    
                    
                    
                    return cell
                } else if indexPath.section == 2 {
                    
                    if self.diamondAsset[indexPath.row].certificationCost == "" || self.diamondAsset[indexPath.row].certificationCost == "0"{
                        let cell = tableView.dequeueReusableCell(withIdentifier: "diamondCell") as! productDiamondCell
                        cell.d1Btn.isHidden = true
                        cell.d2Btn.isHidden = true
                        cell.d3Btn.isHidden = true
                        cell.d4Btn.isHidden = true
                        cell.d5Btn.isHidden = true
                        cell.d6BtnC.isHidden = true
                        
                        cell.d1Btnc.isHidden = true
                        cell.d2Btnc.isHidden = true
                        cell.d3Btnc.isHidden = true
                        cell.d4Btnc.isHidden = true
                        cell.d5Btnc.isHidden = true
                        
                        cell.diamondTypeBtn.setTitle(self.diamondAsset[indexPath.row].jwellerySize, for: .normal)
                        
                        let diamondBtn = [cell.d1Btn,cell.d2Btn,cell.d3Btn,cell.d4Btn,cell.d5Btn,cell.d6BtnC]
                        let diamondBtnC = [cell.d1Btnc,cell.d2Btnc,cell.d3Btnc,cell.d4Btnc,cell.d5Btnc]
                        
                        let diamondColor = self.diamondAsset[indexPath.row].color.components(separatedBy: ",")
                        for i in  0 ..< diamondColor.count {
                            diamondBtn[i]?.tag = indexPath.row
                            diamondBtn[i]?.isHidden = false
                            diamondBtn[i]?.setTitle(diamondColor[i], for: .normal)
                           // self.diamondColorTemp = diamondColor[i]
                            diamondBtn[i]?.addTarget(self, action: #selector(diamondColoBtn(_:)), for: .touchUpInside)
                            diamondBtn[i]?.backgroundColor = UIColor.white
                            diamondBtn[i]?.setTitleColor(.black, for: .normal)
                        }
                           
                        let diamondClarity = self.diamondAsset[indexPath.row].clarity.components(separatedBy: ",")
                        for i in  0 ..< diamondClarity.count {
                            diamondBtnC[i]?.tag = indexPath.row
                            diamondBtnC[i]?.isHidden = false
                            diamondBtnC[i]?.setTitle(diamondClarity[i], for: .normal)
                            //self.diamondClarityTemp = diamondClarity[i]
                            diamondBtnC[i]?.addTarget(self, action: #selector(diamondClarityBtn(_:)), for: .touchUpInside)
                            diamondBtnC[i]?.backgroundColor = UIColor.white
                            diamondBtnC[i]?.setTitleColor(.black, for: .normal)
                        }
                        
                        let clrTemp = NSMutableArray()
                    for i in 0 ..< diamondBtn.count {
                        print(diamondBtn[i]?.titleLabel?.text ?? "")
                        print(self.diamondColorTemp)
                                
                        if diamondBtn[i]?.titleLabel?.text! == self.diamondColorTemp {
                            diamondBtn[i]?.backgroundColor = UIColor.init(named: "base_color")
                            diamondBtn[i]?.setTitleColor(.white, for: .normal)
                            
                            let tempdic = ["name":diamondBtn[i]?.titleLabel?.text!,"value":"1"]
                            
                            clrTemp.add(tempdic)
                        }else {
                            let tempdic = ["name":diamondBtn[i]?.titleLabel?.text!,"value":"0"]
                            clrTemp.add(tempdic)
                        }
                    }
                        
                       
                            
                        let tempdic = ["name":self.diamondAsset[indexPath.row].jwellerySize,"value":clrTemp] as [String : Any]
                        
                        if self.newcolorarray.count != 0 {
                            for i in 0..<self.newcolorarray.count {
                                let name = self.newcolorarray[i]["name"] as! String
                                if name == self.diamondAsset[indexPath.row].jwellerySize {
                                    self.newcolorarray.remove(at: i)
                                    self.newcolorarray.insert(tempdic, at: i)
                                    break
                                }
                            }
                            
                        }else {
                            self.newcolorarray.append(tempdic)
                        }
                        
                         
                        
                        
                        
                        let clarityTemp = NSMutableArray()
                        
                        
                        
                        self.clarArr = []
                        for i in 0 ..< diamondBtnC.count {
                            let btnName = diamondBtnC[i]?.titleLabel?.text! ?? ""
                            if btnName == self.diamondClarityTemp {
                                
                                diamondBtnC[i]?.backgroundColor = UIColor.init(named: "base_color")
                                diamondBtnC[i]?.setTitleColor(.white, for: .normal)
                                let tempdic = ["name":btnName,"value":"1"]
                                clarityTemp.add(tempdic)
                            }else {
                                let tempdic = ["name":btnName,"value":"0"]
                                clarityTemp.add(tempdic)
                            }
                        }
                            if self.diamondColorTemp == "" && self.diamondClarityTemp == "" {
                                self.diamondColorTemp = diamondColor[0]
                                self.diamondClarityTemp = diamondClarity[0]
                            }
                        
                        
                        
                        let tempdic1 = ["name":self.diamondAsset[indexPath.row].jwellerySize,"value":clarityTemp] as [String : Any]
                        
                        if self.newClarityarray.count != 0 {
                            for i in 0..<self.newClarityarray.count {
                                let name = self.newClarityarray[i]["name"] as! String
                                if name == self.diamondAsset[indexPath.row].jwellerySize {
                                    self.newClarityarray.remove(at: i)
                                    self.newClarityarray.insert(tempdic1, at: i)
                                    break
                                }
                            }
                            
                        }else {
                            self.newClarityarray.append(tempdic1)
                        }
                           
                            //MARK:- Name label
                            cell.lblName.text = self.diamondAsset[indexPath.row].jwellerySize
                        self.diaType = self.diamondAsset[indexPath.row].jwellerySize
                            //MARK:- Weight Label
                        let weight = self.diamondAsset[indexPath.row].weight.toDouble()
                        let we = String(format: "%.3f", weight)
                            cell.lblWeight.text = we + " Ct"
                            
                            //MARK:- Daimond Price
                            var diamondPrice = ""
                            for i in self.product!.price.diamondMaster {
                                if i.type == self.diamondAsset[indexPath.row].defaultColorClarity {
                                    if i.diamond_type == self.diamondAsset[indexPath.row].jwellerySize {
                                        diamondPrice = i.price
                                        
                                    }
                                }
                            }
                        let daimondpr = diamondPrice.toDouble()
                        let wedaimondpr = String(format: "%.1f", daimondpr)
                            cell.lblPrice.text = "₹ " + wedaimondpr + "/ ct"
                            
                            //MARK:- No of Diamond
                        cell.lblNoDiamond.text = self.diamondAsset[indexPath.row].quantity + " pc"
                       
                            
                            //MARK:- Total Diamond
                        
                        let daitotal = PriceCalculation.shared.diamondPrice(diamondWeight: self.diamondAsset[indexPath.row].weight.toDouble(), diamondRate: diamondPrice.toDouble())
                        
                        let rateTotal = String(format: "%.2f", daitotal)
                        cell.lblDiamondTotal.text = "₹ " + rateTotal
                            
                            //MARK:- Diamond Color Clarity
                            cell.lblDiamondColorClarity.text = self.diamondAsset[indexPath.row].defaultColorClarity
                            
                            
                            cell.d1Btn.layer.borderColor = UIColor.black.cgColor
                            cell.d1Btn.layer.borderWidth = 0.5
                            cell.d1Btn.layer.cornerRadius = cell.d1Btn.frame.height / 2
                            cell.d1Btn.clipsToBounds = true
                                    
                            cell.d2Btn.layer.borderColor = UIColor.black.cgColor
                            cell.d2Btn.layer.borderWidth = 0.5
                            cell.d2Btn.layer.cornerRadius = cell.d2Btn.frame.height / 2
                            cell.d2Btn.clipsToBounds = true
                                    
                            cell.d3Btn.layer.borderColor = UIColor.black.cgColor
                            cell.d3Btn.layer.borderWidth = 0.5
                            cell.d3Btn.layer.cornerRadius = cell.d3Btn.frame.height / 2
                            cell.d3Btn.clipsToBounds = true
                                    
                            cell.d4Btn.layer.borderColor = UIColor.black.cgColor
                            cell.d4Btn.layer.borderWidth = 0.5
                            cell.d4Btn.layer.cornerRadius = cell.d4Btn.frame.height / 2
                            cell.d4Btn.clipsToBounds = true
                                    
                            cell.d5Btn.layer.borderColor = UIColor.black.cgColor
                            cell.d5Btn.layer.borderWidth = 0.5
                            cell.d5Btn.layer.cornerRadius = cell.d5Btn.frame.height / 2
                            cell.d5Btn.clipsToBounds = true
                        
                        cell.d6BtnC.layer.borderColor = UIColor.black.cgColor
                        cell.d6BtnC.layer.borderWidth = 0.5
                        cell.d6BtnC.layer.cornerRadius = cell.d5Btn.frame.height / 2
                        cell.d6BtnC.clipsToBounds = true
                                
                            cell.d1Btnc.layer.borderColor = UIColor.black.cgColor
                            cell.d1Btnc.layer.borderWidth = 0.5
                            cell.d1Btnc.layer.cornerRadius = cell.d1Btnc.frame.height / 2
                            cell.d1Btnc.clipsToBounds = true
                                
                            cell.d2Btnc.layer.borderColor = UIColor.black.cgColor
                            cell.d2Btnc.layer.borderWidth = 0.5
                            cell.d2Btnc.layer.cornerRadius = cell.d2Btnc.frame.height / 2
                            cell.d2Btnc.clipsToBounds = true
                                
                            cell.d3Btnc.layer.borderColor = UIColor.black.cgColor
                            cell.d3Btnc.layer.borderWidth = 0.5
                            cell.d3Btnc.layer.cornerRadius = cell.d3Btnc.frame.height / 2
                            cell.d3Btnc.clipsToBounds = true
                                
                            cell.d4Btnc.layer.borderColor = UIColor.black.cgColor
                            cell.d4Btnc.layer.borderWidth = 0.5
                            cell.d4Btnc.layer.cornerRadius = cell.d4Btnc.frame.height / 2
                            cell.d4Btnc.clipsToBounds = true
                                
                            cell.d5Btnc.layer.borderColor = UIColor.black.cgColor
                            cell.d5Btnc.layer.borderWidth = 0.5
                            cell.d5Btnc.layer.cornerRadius = cell.d4Btnc.frame.height / 2
                            cell.d5Btnc.clipsToBounds = true
                        
                        
                        if ispr == true {
                            
                            cell.viewPrice.isHidden = true
                            cell.viewDiaNo.isHidden = true
                            cell.viewDiaTotal.isHidden = true
                            cell.viewColCla.isHidden = true
                           
                        }else {
                            cell.viewPrice.isHidden = false
                            if self.diamondAsset[indexPath.row].quantity != "0" {
                                cell.viewDiaNo.isHidden = false
                                
                                  
                            }
                            else {
                                cell.viewDiaNo.isHidden = true
                            }
                            cell.viewDiaTotal.isHidden = false
                            cell.viewColCla.isHidden = false
                        }
                        
                        return cell
                    }
                    let cell = tableView.dequeueReusableCell(withIdentifier: "diamondCellCertified") as! productDiamondCellCertified
                    cell.d1Btn.isHidden = true
                    cell.d2Btn.isHidden = true
                    cell.d3Btn.isHidden = true
                    cell.d4Btn.isHidden = true
                    cell.d5Btn.isHidden = true
                    
                    cell.d1Btnc.isHidden = true
                    cell.d2Btnc.isHidden = true
                    cell.d3Btnc.isHidden = true
                    cell.d4Btnc.isHidden = true
                    cell.d5Btnc.isHidden = true
                    
                    let diamondBtn = [cell.d1Btn,cell.d2Btn,cell.d3Btn,cell.d4Btn,cell.d5Btn]
                    let diamondBtnC = [cell.d1Btnc,cell.d2Btnc,cell.d3Btnc,cell.d4Btnc,cell.d5Btnc]
                    
                    
                    
                    cell.diamondTypeBtn.setTitle(self.diamondAsset[indexPath.row].jwellerySize, for: .normal)
                let diamondColor = self.diamondAsset[indexPath.row].color.components(separatedBy: ",")
                for i in  0 ..< diamondColor.count {
                    diamondBtn[i]?.tag = indexPath.row
                    diamondBtn[i]?.isHidden = false
                    diamondBtn[i]?.setTitle(diamondColor[i], for: .normal)
                    diamondBtn[i]?.addTarget(self, action: #selector(diamondColoBtn(_:)), for: .touchUpInside)
                    diamondBtn[i]?.backgroundColor = UIColor.white
                    diamondBtn[i]?.setTitleColor(.black, for: .normal)
                }
                   
                    let diamondClarity = self.diamondAsset[indexPath.row].clarity.components(separatedBy: ",")
                        for i in  0 ..< diamondClarity.count {
                        diamondBtnC[i]?.tag = indexPath.row
                        diamondBtnC[i]?.isHidden = false
                        diamondBtnC[i]?.setTitle(diamondClarity[i], for: .normal)
                        diamondBtnC[i]?.addTarget(self, action: #selector(diamondClarityBtn(_:)), for: .touchUpInside)
                        diamondBtnC[i]?.backgroundColor = UIColor.white
                        diamondBtnC[i]?.setTitleColor(.black, for: .normal)
                    }
                   
                    let clrTemp = NSMutableArray()
                for i in 0 ..< diamondBtn.count {
                    print(diamondBtn[i]?.titleLabel?.text ?? "")
                    print(self.diamondColorTemp)
                            
                    if diamondBtn[i]?.titleLabel?.text! == self.diamondColorTemp {
                        diamondBtn[i]?.backgroundColor = UIColor.init(named: "base_color")
                        diamondBtn[i]?.setTitleColor(.white, for: .normal)
                        
                        let tempdic = ["name":diamondBtn[i]?.titleLabel?.text!,"value":"1"]
                        
                        clrTemp.add(tempdic)
                    }else {
                        let tempdic = ["name":diamondBtn[i]?.titleLabel?.text!,"value":"0"]
                        clrTemp.add(tempdic)
                    }
                }
                    
                   
                        
                    let tempdic = ["name":self.diamondAsset[indexPath.row].jwellerySize,"value":clrTemp] as [String : Any]
                    
                    if self.newcolorarray.count != 0 {
                        for i in 0..<self.newcolorarray.count {
                            let name = self.newcolorarray[i]["name"] as! String
                            if name == self.diamondAsset[indexPath.row].jwellerySize {
                                self.newcolorarray.remove(at: i)
                                self.newcolorarray.insert(tempdic, at: i)
                                break
                            }
                        }
                        
                    }else {
                        self.newcolorarray.append(tempdic)
                    }
                    
                     
                    
                    
                    
                    let clarityTemp = NSMutableArray()
                    
                    
                    
                    self.clarArr = []
                    for i in 0 ..< diamondBtnC.count {
                        let btnName = diamondBtnC[i]?.titleLabel?.text! ?? ""
                        if btnName == self.diamondClarityTemp {
                            
                            diamondBtnC[i]?.backgroundColor = UIColor.init(named: "base_color")
                            diamondBtnC[i]?.setTitleColor(.white, for: .normal)
                            let tempdic = ["name":btnName,"value":"1"]
                            clarityTemp.add(tempdic)
                        }else {
                            let tempdic = ["name":btnName,"value":"0"]
                            clarityTemp.add(tempdic)
                        }
                    }
                      
                    
                    let tempdic1 = ["name":self.diamondAsset[indexPath.row].jwellerySize,"value":clarityTemp] as [String : Any]
                    
                    if self.newClarityarray.count != 0 {
                        for i in 0..<self.newClarityarray.count {
                            let name = self.newClarityarray[i]["name"] as! String
                            if name == self.diamondAsset[indexPath.row].jwellerySize {
                                self.newClarityarray.remove(at: i)
                                self.newClarityarray.insert(tempdic1, at: i)
                                break
                            }
                        }
                        
                    }else {
                        self.newClarityarray.append(tempdic1)
                    }
                    
        //            for i in 0 ..< diamondBtn.count {
        //                print(diamondBtn[i]?.titleLabel?.text ?? "")
        //                print(self.diamondColorTemp)
        //
        //                if diamondBtn[i]?.titleLabel?.text! == self.diamondColorTemp {
        //                    diamondBtn[i]?.backgroundColor = UIColor.init(named: "base_color")
        //                    diamondBtn[i]?.setTitleColor(.white, for: .normal)
        //                }
        //            }
        //            if self.diamondColorTemp == "" && self.diamondClarityTemp == "" {
        //                self.diamondColorTemp = diamondColor[0]
        //                self.diamondClarityTemp = diamondClarity[0]
        //            }
        //
        //            for i in 0 ..< diamondBtnC.count {
        //                let btnName = diamondBtnC[i]?.titleLabel?.text! ?? ""
        //                print(btnName)
        //                if btnName == self.diamondClarityTemp {
        //                    diamondBtnC[i]?.backgroundColor = UIColor.init(named: "base_color")
        //                    diamondBtnC[i]?.setTitleColor(.white, for: .normal)
        //                }
        //            }
        //                if self.diamondColorTemp == "" && self.diamondClarityTemp == "" {
        //                    self.diamondColorTemp = diamondColor[0]
        //                    self.diamondClarityTemp = diamondClarity[0]
        //                }
                   
                    //MARK:- Name label
                    cell.lblName.text = self.diamondAsset[indexPath.row].jwellerySize
                    self.diaType = self.diamondAsset[indexPath.row].jwellerySize
                    //MARK:- Weight Label
                    cell.lblWeight.text = self.diamondAsset[indexPath.row].weight + " Ct"
                    
                    //MARK:- Daimond Price
                    var diamondPrice = ""
                    for i in self.product!.price.diamondMaster {
                        
                        if i.diamond_type == self.diamondAsset[indexPath.row].jwellerySize {
                            if i.type == self.diamondAsset[indexPath.row].defaultColorClarity {
                                if i.diamond_type == self.diamondAsset[indexPath.row].jwellerySize {
                                    diamondPrice = i.price
                                    
                                }
                            }
                        }
                        
                        
                    }
                    cell.lblPrice.text = "₹" + diamondPrice + "/ Ct"
                    
                    //MARK:- No of Diamond
                    cell.lblNoDiamond.text = self.diamondAsset[indexPath.row].quantity + " Pc"
                    
                    
                    //MARK:- Diamond Color Clarity
                    cell.lblDiamondColorClarity.text = self.diamondAsset[indexPath.row].defaultColorClarity
                    
                    //MARK:- Certificate charge
                    cell.lblCertificateCharges.text = self.diamondAsset[indexPath.row].certificationCost
                    
                    
                    var certCost = 0.0
                    if self.diamondAsset[indexPath.row].crtcostOption == "PerCarat" {
                        //MARK:- Certificate charge
                        cell.lblCertificateCharges.text = "₹" + self.diamondAsset[indexPath.row].certificationCost + " /Ct"
                        
                        
                        certCost = self.diamondAsset[indexPath.row].weight.toDouble() * self.diamondAsset[indexPath.row].certificationCost.toDouble()
                    } else if self.diamondAsset[indexPath.row].crtcostOption == "Fixed" {
                        //MARK:- Certificate charge
                        cell.lblCertificateCharges.text = "₹" + self.diamondAsset[indexPath.row].certificationCost
                        
                        certCost = self.diamondAsset[indexPath.row].certificationCost.toDouble()
                    }
                    
                    //MARK:- Total Certification Charge
                    cell.lblTotalCertificateCharges.text = "₹ " + certCost.toString()
                    
                    //MARK:- Total Diamond
                    cell.lblDiamondTotal.text = "₹ " + (PriceCalculation.shared.diamondPrice(diamondWeight: self.diamondAsset[indexPath.row].weight.toDouble(), diamondRate: diamondPrice.toDouble()) + certCost).toString()
                    
                    cell.d1Btn.layer.borderColor = UIColor.black.cgColor
                    cell.d1Btn.layer.borderWidth = 0.5
                    cell.d1Btn.layer.cornerRadius = cell.d1Btn.frame.height / 2
                    cell.d1Btn.clipsToBounds = true
                            
                    cell.d2Btn.layer.borderColor = UIColor.black.cgColor
                    cell.d2Btn.layer.borderWidth = 0.5
                    cell.d2Btn.layer.cornerRadius = cell.d2Btn.frame.height / 2
                    cell.d2Btn.clipsToBounds = true
                            
                    cell.d3Btn.layer.borderColor = UIColor.black.cgColor
                    cell.d3Btn.layer.borderWidth = 0.5
                    cell.d3Btn.layer.cornerRadius = cell.d3Btn.frame.height / 2
                    cell.d3Btn.clipsToBounds = true
                            
                    cell.d4Btn.layer.borderColor = UIColor.black.cgColor
                    cell.d4Btn.layer.borderWidth = 0.5
                    cell.d4Btn.layer.cornerRadius = cell.d4Btn.frame.height / 2
                    cell.d4Btn.clipsToBounds = true
                            
                    cell.d5Btn.layer.borderColor = UIColor.black.cgColor
                    cell.d5Btn.layer.borderWidth = 0.5
                    cell.d5Btn.layer.cornerRadius = cell.d5Btn.frame.height / 2
                    cell.d5Btn.clipsToBounds = true
                        
                    cell.d1Btnc.layer.borderColor = UIColor.black.cgColor
                    cell.d1Btnc.layer.borderWidth = 0.5
                    cell.d1Btnc.layer.cornerRadius = cell.d1Btnc.frame.height / 2
                    cell.d1Btnc.clipsToBounds = true
                        
                    cell.d2Btnc.layer.borderColor = UIColor.black.cgColor
                    cell.d2Btnc.layer.borderWidth = 0.5
                    cell.d2Btnc.layer.cornerRadius = cell.d2Btnc.frame.height / 2
                    cell.d2Btnc.clipsToBounds = true
                        
                    cell.d3Btnc.layer.borderColor = UIColor.black.cgColor
                    cell.d3Btnc.layer.borderWidth = 0.5
                    cell.d3Btnc.layer.cornerRadius = cell.d3Btnc.frame.height / 2
                    cell.d3Btnc.clipsToBounds = true
                        
                    cell.d4Btnc.layer.borderColor = UIColor.black.cgColor
                    cell.d4Btnc.layer.borderWidth = 0.5
                    cell.d4Btnc.layer.cornerRadius = cell.d4Btnc.frame.height / 2
                    cell.d4Btnc.clipsToBounds = true
                        
                    cell.d5Btnc.layer.borderColor = UIColor.black.cgColor
                    cell.d5Btnc.layer.borderWidth = 0.5
                    cell.d5Btnc.layer.cornerRadius = cell.d4Btnc.frame.height / 2
                    cell.d5Btnc.clipsToBounds = true
                    
                    if ispr == true {
                        
                        cell.viewPrice.isHidden = true
                        cell.viewDiaNo.isHidden = true
                        cell.viewDiaTotal.isHidden = true
                        cell.viewColcla.isHidden = true
                        cell.viewCertTotal.isHidden = true
                        cell.viewCertCharge.isHidden = true
                       
                    }else {
                        cell.viewPrice.isHidden = false
                        cell.viewDiaNo.isHidden = false
                        cell.viewDiaTotal.isHidden = false
                        cell.viewColcla.isHidden = false
                        cell.viewCertTotal.isHidden = false
                        cell.viewCertCharge.isHidden = false
                    }
                    
                    
                    return cell
                } else if indexPath.section == 3 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "stoneCell") as! productStoneCell
                    
                    
                    if self.arrFinalStone[indexPath.row]["stoneInside"] == nil {
                        cell.downArrow.isHidden  = true
                        cell.btnStoneType.isUserInteractionEnabled = false
                        cell.btnStoneType.layer.borderWidth = 1.0
                        cell.btnStoneType.layer.borderColor = UIColor.darkGray.cgColor
                        cell.btnStoneType.setTitle(self.arrFinalStone[indexPath.row]["jwellerySize"] as! String, for: .normal)
                        
                        
                        if self.arrFinalStone[indexPath.row]["quantity"] as! String == "0" ||  self.arrFinalStone[indexPath.row]["quantity"] as! String == "" {
                            cell.viewMain.isHidden = true
                            
                        }else {
                            cell.viewMain.isHidden = false
                        }
                        
                        cell.lblNoOfStone.text = self.arrFinalStone[indexPath.row]["quantity"] as! String + " Pc"
                        let we = self.arrFinalStone[indexPath.row]["weight"] as! String
                        let ston = String(format: "%.3f", we.toDouble())
                                   cell.lblStoneWeight.text = ston + " Ct"
                       
                                   var stonRate = ""
                                   for i in self.product!.price.stone {
                                       if i.type == (self.arrFinalStone[indexPath.row]["jwellerySize"] as! String).uppercased() {
                                           stonRate = i.price
                                       }
                                   }
                                   let stonrat = String(format: "%.1f", stonRate.toDouble())
                                   cell.lblStonePrice.text = stonrat + "/ Ct"
                                   stonRate = stonrat
                       
                                    
                                   let stonratotal = String(format: "%.2f", (stonRate.toDouble() * we.toDouble()))
                       
                       
                                   cell.lblStoneTotal.text = "₹ " + stonratotal
                        
                        
                        
                    }else {
                        cell.downArrow.isHidden  = false
                        cell.btnStoneType.tag = indexPath.row
                        cell.btnStoneType.isUserInteractionEnabled = true
                        cell.btnStoneType.addTarget(self, action: #selector(selectStone(_:)), for: .touchUpInside)
                        let arrmain = self.arrFinalStone[indexPath.row]["stoneInside"] as! [[String:Any]]
                        
                        cell.btnStoneType.setTitle(arrmain[0]["jwellerySize"] as! String, for: .normal)
                        if self.arrFinalStone[indexPath.row]["quantity"] as! String == "0" ||  self.arrFinalStone[indexPath.row]["quantity"] as! String == "" {
                            cell.viewMain.isHidden = true
                            
                        }else {
                            cell.viewMain.isHidden = false
                        }
                        cell.lblNoOfStone.text = arrmain[0]["quantity"] as! String + " Pc"
                        let we = arrmain[0]["weight"] as! String
                        let ston = String(format: "%.3f", we.toDouble())
                                   cell.lblStoneWeight.text = ston + " Ct"
                       
                                   var stonRate = ""
                                   for i in self.product!.price.stone {
                                       if i.type == (arrmain[0]["jwellerySize"] as! String).uppercased() {
                                           stonRate = i.price
                                       }
                                   }
                                   let stonrat = String(format: "%.1f", stonRate.toDouble())
                                   cell.lblStonePrice.text = stonrat + "/ Ct"
                                   stonRate = stonrat
                       
                                    
                                   let stonratotal = String(format: "%.2f", (stonRate.toDouble() * we.toDouble()))
                       
                       
                                   cell.lblStoneTotal.text = "₹ " + stonratotal
                        
                    }
                    
                    
                    if ispr == true {
                        
                        cell.viewRate.isHidden = true
                        cell.viewTot.isHidden = true
                        
                       
                    }else {
                        cell.viewRate.isHidden = false
                        cell.viewTot.isHidden = false
                    }
        //            cell.btnStoneType.setTitle(self.stoneAsset[indexPath.row].jwellerySize, for: .normal)
        //
        //
        //            cell.lblNoOfStone.text = self.stoneAsset[indexPath.row].quantity + " Pc"
        //
        //            let ston = String(format: "%.3f", self.stoneAsset[indexPath.row].weight.toDouble())
        //            cell.lblStoneWeight.text = ston + " Ct"
        //
        //            var stonRate = ""
        //            for i in self.product!.price.stone {
        //                if i.type == self.stoneAsset[indexPath.row].jwellerySize.uppercased() {
        //                    stonRate = i.price
        //                }
        //            }
        //            let stonrat = String(format: "%.1f", stonRate.toDouble())
        //            cell.lblStonePrice.text = stonrat + "/ Ct"
        //            stonRate = stonrat
        //
        //
        //            let stonratotal = String(format: "%.2f", (stonRate.toDouble() * self.stoneAsset[indexPath.row].weight.toDouble()))
        //
        //
        //            cell.lblStoneTotal.text = "₹ " + stonratotal
                    return cell
                } else if indexPath.section == 4 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "platinumCell") as! productPlatinumCell
                    
                    //MARK:- Product Code
                    cell.lblProdcutCode.text = "  " + (self.product?.data.productcode)!
                    
                    //MARK:- Platinum Price
                    let price = self.product?.price.platinum[0].price
                    let pricetot = String(format: "%.2f", price?.toDouble() as! CVarArg)
                    cell.lblPlatinumPrice.text = "  " + "₹ " + pricetot + " /g"
                    
                    //MARK:- Platinum weight
                    let weight = self.platinumAsset[indexPath.row].weight
                    let weighttot = String(format: "%.3f", weight.toDouble() as! CVarArg)
                    cell.lblPlatinumWeight.text = "  " + weighttot + " g"
                    
                    //MARK:- Platinum Purity
                    cell.lblPlatinumPurity.text = "  " + self.platinumAsset[indexPath.row].purity + "%"
                    
                    //MARK:- Platinum Wastage
                    
                    
                    let wastage = self.platinumAsset[indexPath.row].wastage
                    
                    if wastage == "" || wastage == "<null>"{
                        cell.viewastage.isHidden = true
                    }else {
                        cell.viewastage.isHidden = false
                        cell.lblPlatinumWasteage.text = "  " + self.platinumAsset[indexPath.row].wastage + "%"
                        
                        if self.ispr == true {
                            cell.viewastage.isHidden = true
                        }else {
                            cell.viewastage.isHidden = false
                        }
                    }
                    
                    
                    //MARK:- Platinum Makig Charge
                    let smakingCharge = self.platinumAsset[indexPath.row].makingCharge
                    let smakingChargetot = String(format: "%.2f", smakingCharge.toDouble() as! CVarArg)
                    cell.lblPlatinumMakingCharge.text = "  " + "₹ " + smakingChargetot + " /g"
                    
                    //MARK:- Total Making Charge
                    var makingCharge = 0.0
                    var totalweight = 0.0
                    if ischange == false {
                         totalweight = sizeCalculation(selectedSize: Int((self.product?.data.defaultSize)!)!, weight: self.platinumAsset[indexPath.row].weight.toDouble())
                    }else {
                        totalweight = self.platinumAsset[indexPath.row].weight.toDouble()
                    }
                    
                    
                    
                    if self.platinumAsset[indexPath.row].chargesOption == "PerGram" {
                        makingCharge = PriceCalculation.shared.platinumMaking(weight: totalweight, rate: self.platinumAsset[indexPath.row].makingCharge.toDouble(), isPerGram: true)
                    } else if self.platinumAsset[indexPath.row].chargesOption == "Fixed" || self.platinumAsset[indexPath.row].chargesOption == "PerPiece" {
                        makingCharge = PriceCalculation.shared.platinumMaking(weight: self.platinumAsset[indexPath.row].weight.toDouble(), rate: self.platinumAsset[indexPath.row].makingCharge.toDouble(), isPerGram: false)
                    }
                    
                    //MARK:- Meena Cost
                    var finalMeenaCost = 0.0
                    if self.platinumAsset[indexPath.row].meenacostOption == "PerGram" {
                        let meenaCost = PriceCalculation.shared.MeenaCost(meenaRate: self.platinumAsset[indexPath.row].meenaCost.toDouble(), weight: self.platinumAsset[indexPath.row].weight.toDouble(), isPergram: true)
                        finalMeenaCost = meenaCost
                    } else if self.platinumAsset[indexPath.row].meenacostOption == "Fixed" {
                        let meenaCost = PriceCalculation.shared.MeenaCost(meenaRate: self.platinumAsset[indexPath.row].meenaCost.toDouble(), weight: self.platinumAsset[indexPath.row].weight.toDouble(), isPergram: false)
                        finalMeenaCost = meenaCost
                    }
                    
                    cell.lblTotalMakingCharge.text = "  " + "₹ " + makingCharge.toString()
                    
                    //MARK:- Platinum Total
                    let tot = (PriceCalculation.shared.platinumPrice(weight: totalweight, rate: (self.product?.price.platinum[0].price.toDouble())!, wastage: self.platinumAsset[indexPath.row].wastage.toDouble(), purity: self.platinumAsset[indexPath.row].purity.toDouble())) + makingCharge + finalMeenaCost
                    let plate = String(format: "%.2f", tot)
                   
                    
                    cell.lblPlatinumTotal.text = "  " + "₹ " + plate
                    
                    if self.ispr == true {
                        cell.viewPrice.isHidden = true
                        cell.viewPurity.isHidden = true
                        cell.viewWeigh.isHidden = true
                        cell.viewMaking.isHidden = true
                        cell.viewTotalMakingCharge.isHidden = true
                        cell.viewMakingCharge.isHidden = true
                    }else {
                        cell.viewPrice.isHidden = false
                        
                        cell.viewPurity.isHidden = false
                        cell.viewWeigh.isHidden = false
                        cell.viewMaking.isHidden = false
                        cell.viewTotalMakingCharge.isHidden = false
                        cell.viewMakingCharge.isHidden = false
                    }
                    
                    
                    return cell
                } else if indexPath.section == 5 {
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "silverCell") as! productSilverCell
                    
                    
                    
                    cell.btn1.isHidden = true
                    cell.btn2.isHidden = true
                    cell.btn3.isHidden = true
                    cell.btn4.isHidden = true
                    let btnArr = [cell.btn1,cell.btn2,cell.btn3,cell.btn4]
                    
                    for i in 0 ..< self.silverAsset.count {
                        
                        btnArr[i]?.isHidden = false
                        btnArr[i]?.setTitle(self.silverAsset[i].jwellerySize, for: .normal)
                        btnArr[i]?.addTarget(self, action: #selector(goldSelect(_:)), for: .touchUpInside)
                        btnArr[i]?.backgroundColor = UIColor.white
                        btnArr[i]?.setTitleColor(.black, for: .normal)
                    }
                    if self.silverAsset.count > 0 {
                        for i in btnArr {
                            if i?.titleLabel?.text == self.silverAsset[self.selectedIndSilver].jwellerySize {
                                i?.backgroundColor = UIColor.init(named: "base_color")
                                i?.setTitleColor(.white, for: .normal)
                                self.selectedsilvertype = (i?.titleLabel?.text)!
                                //self.defualttype = (0.titleLabel?.text)!
                            }
                        }
                    }
                    
                    cell.btn1.layer.borderColor = UIColor.black.cgColor
                    cell.btn1.layer.borderWidth = 1
                    cell.btn1.layer.cornerRadius = cell.btn1.frame.height / 2
                    cell.btn1.clipsToBounds = true
                        
                    cell.btn2.layer.borderColor = UIColor.black.cgColor
                    cell.btn2.layer.borderWidth = 1
                    cell.btn2.layer.cornerRadius = cell.btn2.frame.height / 2
                    cell.btn2.clipsToBounds = true
                        
                    cell.btn3.layer.borderColor = UIColor.black.cgColor
                    cell.btn3.layer.borderWidth = 1
                    cell.btn3.layer.cornerRadius = cell.btn3.frame.height / 2
                    cell.btn3.clipsToBounds = true
                        
                    cell.btn4.layer.borderColor = UIColor.black.cgColor
                    cell.btn4.layer.borderWidth = 1
                    cell.btn4.layer.cornerRadius = cell.btn4.frame.height / 2
                    cell.btn4.clipsToBounds = true
                    
                    
                    cell.lblProductCode.text = "  " + (self.product?.data.productcode)!
                    cell.viewCode.isHidden = true
                    
                    let price = self.product?.price.silver[0].price
                    let pricetot = String(format: "%.2f", price?.toDouble() as! CVarArg)
                    cell.lblRate.text =  "₹ " + pricetot + " /g"
                                    
                                    //MARK:- Value In Calc
                                    var valueIn = ""
                                    
                                    print(self.silverAsset.count)
                                    if self.silverAsset.count > 0 {
                                        let goldType = self.silverAsset[self.selectedIndSilver].jwellerySize
                                        for i in self.product!.price.silver {
                                            if goldType == i.type {
                                                print(i.valueIn)
                                                let type = String(format: "%.2f", i.valueIn.toDouble())
                                                cell.lblPurity.text = type + "%"
                                                valueIn = i.valueIn
                                            }
                                        }
                                    }
                                        
                                    
                                    
                                   
                                    
                                    //MARK:- Net Gold Weight
                                    let netgold = Double(self.silverAsset[self.selectedIndSilver].weight)
                                    
                                    let netgoldy = String(format: "%.3f", netgold!)
                                    cell.lblWeight.text = netgoldy + " g"
                                    
                                    if ispr == true {
                                        
                                        cell.viewWeight.isHidden = true
                                    }else {
                                        cell.viewWeight.isHidden = false
                                    }
                                    
                                    //MARK:- Gold Making Charge
                                    
                                    let Making = Double(self.silverAsset[self.selectedIndSilver].makingCharge)
                                    
                                    if Making != 0 {
                                        cell.viewMaking.isHidden = false
                                         cell.viewTotalMaking.isHidden = false
                                        let Makingy = String(format: "%.1f", Making!)
                                        cell.lblSilverMakingCharge.text = "₹ " + Makingy + "/ g"
                                        
                                        if ispr == true {
                                            
                                            cell.viewMaking.isHidden = true
                                        }else {
                                            cell.viewMaking.isHidden = false
                                        }
                                        
                                    }else {
                                        cell.viewTotalMaking.isHidden = true
                                        cell.viewMaking.isHidden = true
                                    }
                                    
                                    var  wastage = Double(self.silverAsset[self.selectedIndSilver].wastage)
                                    if wastage == nil {
                                        wastage = 0
                                    }
                                    if wastage != 0 {
                                        cell.viewWastage.isHidden = false
                                        let wastagey = String(format: "%.1f", wastage!)
                                        cell.lblWastage.text = wastagey + " %"
                                        
                                        if ispr == true {
                                            
                                            cell.viewWastage.isHidden = true
                                        }else {
                                            cell.viewWastage.isHidden = false
                                        }
                                        
                                    }else {
                                        cell.viewWastage.isHidden = true
                                    }
                                    
                                    let value = valueIn.toDouble()
                                    let mainweight = netgoldy.toDouble()
                                    let was = wastage
                                    let fineWeight = mainweight * (value+was!) / 100
                                    //MARK:- Fine Gold Weight
                                //    let purity = fineWeight.toDouble() / 100
                                    let finew = String(format: "%.3f", fineWeight)
                                    cell.lblFineSilverWeight.text = finew + " g"
                                    
                                    //MARK:- Fine Gold Rate
                                    var goldRate = 0.0
                                    var mainrate = 0.0
                                    for i in self.product!.price.silver {
                                        print(i.price)
                                        if i.type == "1000" {
                                            print(i.price)
                                            let rate = String(format: "%.2f", i.price.toDouble())
                                            cell.lblFineSilverRate.text = "₹ " + rate + " / g"
                                            mainrate = rate.toDouble()
                                            goldRate = i.price.toDouble()
                                        }
                                    }
                                    
                                    //MARK:- Meena Cost
                                    var finalMeenaCost = 0.0
                                    if self.silverAsset[self.selectedIndSilver].meenacostOption == "PerGram" {
                                        cell.lblChargeType.text = "PerGram"
                                        let meenaCost = PriceCalculation.shared.MeenaCost(meenaRate: self.silverAsset[self.selectedIndSilver].meenaCost.toDouble(), weight: self.silverAsset[self.selectedIndSilver].weight.toDouble(), isPergram: true)
                                        finalMeenaCost = meenaCost
                                    } else if self.silverAsset[self.selectedIndSilver].meenacostOption == "Fixed" {
                                        cell.lblChargeType.text = "Fixed"
                                        let meenaCost = PriceCalculation.shared.MeenaCost(meenaRate: self.silverAsset[self.selectedIndSilver].meenaCost.toDouble(), weight: self.silverAsset[self.selectedIndSilver].weight.toDouble(), isPergram: false)
                                        finalMeenaCost = meenaCost
                                    }
                                    
                                    //MARK:- MakingCharges
                                    var makingCharge = 0.0
                    
                                    if self.silverAsset[self.selectedIndSilver].chargesOption == "PerGram" {
                                        
                                        makingCharge = PriceCalculation.shared.silverMaking(weight: self.silverAsset[self.selectedIndSilver].weight.toDouble(), rate: self.silverAsset[self.selectedIndSilver].makingCharge.toDouble(), isPergram: true)
                                        
                            
                                    } else if self.silverAsset[self.selectedIndSilver].chargesOption == "Fixed" {
                                        
                                        makingCharge = PriceCalculation.shared.silverMaking(weight: self.silverAsset[self.selectedIndSilver].weight.toDouble(), rate: self.silverAsset[self.selectedIndSilver].makingCharge.toDouble(), isPergram: false)
                                        
                                       
                                    }
                                    
                                    //MARK:- Total Making Charge
                    let totalMakingCharge = self.silverAsset[self.selectedIndSilver].makingCharge.toDouble() * netgoldy.toDouble()
                                    let maintotalMakingCharge = String(format: "%.2f", totalMakingCharge)
                                    
                                    cell.lblSilverPrice.text = "₹ " + maintotalMakingCharge
                                    
                                    //MARK:- Total Amount
                    
                    
                    let totalmain = (PriceCalculation.shared.silverPrice(weight: netgoldy.toDouble(), rate: mainrate, wastage: self.silverAsset[self.selectedIndSilver].wastage.toDouble() + finalMeenaCost, purity: valueIn.toDouble()))
                    
                    
                                    
                                    
                                    let stotalmain = String(format: "%.3f", totalmain + totalMakingCharge)
                                    
                                    let numberFormatter = NumberFormatter()
                                    numberFormatter.minimumFractionDigits = 2
                                    numberFormatter.maximumFractionDigits = 2
                                    numberFormatter.roundingMode = .down
                                   // let str = numberFormatter.string(from: NSNumber(value: stotalmain))
                                   // let str2 = numberFormatter.string(from: NSNumber(value: num2))
                                    
                                    
                    cell.lblSilverTotal.text = "₹ " + stotalmain
                    
                    
                    
                    if self.ispr == true {
                        cell.viewMaking.isHidden = true
                        cell.viewPurity.isHidden = true
                        cell.viewRate.isHidden = true
                        cell.viewTotalMaking.isHidden = true
                        cell.viewWeight.isHidden = true
                        cell.viewTotal.isHidden = true
                        
                        
                        cell.viewFineSilverWeight.isHidden = true
                        cell.viewFineSIlverRate.isHidden = true
                    }else {
                        cell.viewMaking.isHidden = false
                        cell.viewPurity.isHidden = false
                        cell.viewRate.isHidden = false
                        cell.viewTotalMaking.isHidden = false
                        cell.viewWeight.isHidden = false
                        cell.viewTotal.isHidden = false
                        
                        cell.viewFineSilverWeight.isHidden = false
                        cell.viewFineSIlverRate.isHidden = false
                    }
                    cell.viewPurity.isHidden = true
                    cell.viewFineSIlverRate.isHidden = true
                    
                    return cell
                    
                    
                
                } else if indexPath.section == 6 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "certifiedByCell") as! productCertifiedByCell
                    cell.img1.isHidden = true
                    cell.img2.isHidden = true
                    cell.img3.isHidden = true
                    
                    var imgArr = [cell.img1,cell.img2,cell.img3]
                    for i in 0 ..< self.product!.certification.count {
                        imgArr[i]?.isHidden = false
                        imgArr[i]?.kf.indicatorType = .activity
                        imgArr[i]?.kf.setImage(with: URL(string: self.product!.certification[i].image),placeholder: nil,options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
                            switch result {
                            case .success(let value):
                                print("Task done for: \(value.source.url?.absoluteString ?? "")")
                                
                            case .failure(let error):
                                print("Job failed: \(error.localizedDescription)")
                                
                            }
                        }
                    }
                    return cell
                } else if indexPath.section == 7 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "manufactureCell") as! productManufactureByCell
                    cell.lbl1.numberOfLines = 0
                    cell.img.kf.indicatorType = .activity
                    print(self.manufactureURL)
                    
                    var urlString = self.product?.manufacture.logo.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                    cell.img.kf.setImage(with: URL(string: (urlString)!),placeholder: nil,options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
                        switch result {
                        case .success(let value):
                            print("Task done for: \(value.source.url?.absoluteString ?? "")")
                                           
                        case .failure(let error):
                            print("Job failed: \(error.localizedDescription)")
                        }
                    }
                    cell.lbl1.text = self.product?.manufacture.companyName
                    return cell
                } else if indexPath.section == 8 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "descriptionCell") as! productOtherDetailsCell
                    cell.txtDetails.attributedText = self.product?.data.dataDescription.convertHtml(str: (self.product?.data.dataDescription)!)
                    return cell
                } else if indexPath.section == 9 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "priceCell") as! productPriceCell
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        cell.lblTotalPrice.text = "₹ " + self.calculateTotalPrice()
                        var sentence = self.productCode.text
                        let wordToRemove = "Gross weight :"
                        if let range = sentence!.range(of: wordToRemove) {
                            sentence!.removeSubrange(range)
                            cell.lblGrossWe.text = sentence
                        }

                        
                    }
                    
                    if ispr == true {
                       // cell.lblToTtitle.isHidden = true
                        cell.lblTotalPrice.isHidden = true
                    }else {
                       // cell.lblToTtitle.isHidden = false
                        cell.lblTotalPrice.isHidden = false
                    }
                    
                    return cell
                }
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
                return cell!
            }
            
        
            

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if self.prodType == "GOLD JEWELLERY" {
            
           
            if indexPath.section == 0 {
                return UITableView.automaticDimension
            } else if indexPath.section == 1 {
                if ispr == true {
                    return 100
                }else {
                    return 278
                }
             
            } else if indexPath.section == 2 {
                if ispr == true {
                    return 233
                }else {
                    return 433
                }
            } else if indexPath.section == 3 {
                if ispr == true {
                    return 150
                }else {
                    return 274
                }
            } else if indexPath.section == 4 {
                if ispr == true {
                    return 150
                }else {
                    return 274
                }
            } else if indexPath.section == 5 {
                if ispr == true {
                    return 150
                }else {
                    return 274
                }
            } else if indexPath.section == 6 {
                return 124
            } else if indexPath.section == 7 {
                return UITableView.automaticDimension
            } else if indexPath.section == 8 {
                return UITableView.automaticDimension
            } else if indexPath.section == 9 {
                return UITableView.automaticDimension
            }
            return UITableView.automaticDimension
          
        } else if self.prodType == "DIAMOND JEWELLERY" {
            
            if indexPath.section == 0 {
                return UITableView.automaticDimension
            } else if indexPath.section == 1 {
                if ispr == true {
                    return 233
                }else {
                    return 433
                }
             
            } else if indexPath.section == 2 {
                if ispr == true {
                    return 100
                }else {
                    return 278
                }
                
            } else if indexPath.section == 3 {
                if ispr == true {
                    return 150
                }else {
                    return 274
                }
            } else if indexPath.section == 4 {
                if ispr == true {
                    return 150
                }else {
                    return 274
                }
            } else if indexPath.section == 5 {
                if ispr == true {
                    return 150
                }else {
                    return 274
                }
            } else if indexPath.section == 6 {
                return 124
            } else if indexPath.section == 7 {
                return UITableView.automaticDimension
            } else if indexPath.section == 8 {
                return UITableView.automaticDimension
            } else if indexPath.section == 9 {
                return UITableView.automaticDimension
            }
            return UITableView.automaticDimension
            
        }  else if self.prodType == "PLATINUM JEWELLERY" {
            
            if indexPath.section == 0 {
                return UITableView.automaticDimension
            } else if indexPath.section == 1 {
                if ispr == true {
                    return 150
                }else {
                    return 274
                }
             
            } else if indexPath.section == 2 {
                if ispr == true {
                    return 233
                }else {
                    return 433
                }
            } else if indexPath.section == 3 {
                if ispr == true {
                    return 150
                }else {
                    return 274
                }
            } else if indexPath.section == 4 {
                
                if ispr == true {
                    return 100
                }else {
                    return 278
                }
                
                
            } else if indexPath.section == 5 {
                if ispr == true {
                    return 150
                }else {
                    return 274
                }
            } else if indexPath.section == 6 {
                return 124
            } else if indexPath.section == 7 {
                return UITableView.automaticDimension
            } else if indexPath.section == 8 {
                return UITableView.automaticDimension
            } else if indexPath.section == 9 {
                return UITableView.automaticDimension
            }
            return UITableView.automaticDimension
          
        } else if self.prodType == "SILVER JEWELLERY" {
            
            if indexPath.section == 0 {
                return UITableView.automaticDimension
            } else if indexPath.section == 1 {
                if ispr == true {
                    return 150
                }else {
                    return 450
                }
             
            } else if indexPath.section == 2 {
                if ispr == true {
                    return 233
                }else {
                    return 433
                }
            } else if indexPath.section == 3 {
                if ispr == true {
                    return 150
                }else {
                    return 274
                }
            } else if indexPath.section == 4 {
                if ispr == true {
                    return 150
                }else {
                    return 274
                }
            } else if indexPath.section == 5 {
                if ispr == true {
                    return 100
                }else {
                    return 278
                }
                
            } else if indexPath.section == 6 {
                return 124
            } else if indexPath.section == 7 {
                return UITableView.automaticDimension
            } else if indexPath.section == 8 {
                return UITableView.automaticDimension
            } else if indexPath.section == 9 {
                return UITableView.automaticDimension
            }
            return UITableView.automaticDimension
        }else {
            
            if indexPath.section == 0 {
                return UITableView.automaticDimension
            } else if indexPath.section == 1 {
                if ispr == true {
                    return 100
                }else {
                    return 278
                }
             
            } else if indexPath.section == 2 {
                if ispr == true {
                    return 233
                }else {
                    return 433
                }
            } else if indexPath.section == 3 {
                if ispr == true {
                    return 150
                }else {
                    return 274
                }
            } else if indexPath.section == 4 {
                if ispr == true {
                    return 150
                }else {
                    return 274
                }
            } else if indexPath.section == 5 {
                if ispr == true {
                    return 150
                }else {
                    return 274
                }
            } else if indexPath.section == 6 {
                return 124
            } else if indexPath.section == 7 {
                return UITableView.automaticDimension
            } else if indexPath.section == 8 {
                return UITableView.automaticDimension
            } else if indexPath.section == 9 {
                return UITableView.automaticDimension
            }
            return UITableView.automaticDimension
          
        }
        
      
        
        
        
        
       
    }
}

//MARK:- UICollectionView Delegate Methods
extension ProductDetials2:UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.recentCollectionView {
            return trendingProduct.count
        }
        return self.allFiles.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.recentCollectionView {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! trendingProCell
            
            let ind = self.trendingProduct[indexPath.row]
            let urll = "\(MainURL.mainurl)img/product/"
            let imgurl = ind.image
            let finalurl = urll + imgurl
            
            cell.img.kf.indicatorType = .activity
            if let encodedString  = finalurl.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed), let url = URL(string: encodedString) {
                cell.img.kf.setImage(with: url,placeholder: nil,options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
                    switch result {
                    case .success(let value):
                        print("Task done for: \(value.source.url?.absoluteString ?? "")")
                        
                    case .failure(let error):
                        print(finalurl)
                        print("Job failed: \(error.localizedDescription)")
                        
                    }
                }
            }
            
            if ind.product_category == "GOLD JEWELLERY" || ind.product_category == "GOLD CHAINS" {
                print(ind.weight)
                //let gq = ind.proQuality["Gold"] as? String ?? ""
                let gw = ind.weight["Gold"] as? String ?? "0.0"
                let doubleStr = String(format: "%.3f", gw.toDouble())
                
                let ktw = ind.quality["Gold"]  as? String ?? ""
                
                
                cell.priceLbl.text = "\(doubleStr)" + " g"
            } else if ind.product_category == "DIAMOND JEWELLERY" {
               // let dq = ind.proQuality["Diamond"] as? String ?? ""
                let dct = ind.weight["Diamond"] as? String ?? ""
                let doubleStr = String(format: "%.3f", dct.toDouble())
                
               
                cell.ctlabel.text = doubleStr + " Ct"
                
                
                
                var weight = Double()
                if let gw = ind.weight["Gold"] as? String {
                    //let gq = ind.proQuality["Gold"] as! String
                    weight = weight+Double(gw)!
                   // cell.originalPriceLbl.text = gw + " g"
                }
                if let pw = ind.weight["Platinum"] as? String {
                    weight = weight+Double(pw)!
                    //let pq = ind.proQuality["Gold"] as! String
                    cell.priceLbl.text = pw + " g"
                }
                if let sw = ind.weight["Silver"] as? String {
                    weight = weight+Double(sw)!
                    //let sq = ind.proQuality["Gold"] as! String
                  //  cell.originalPriceLbl.text = sw + " g"
                }
                
                if let dw = ind.weight["Diamond"] as? String {
                    weight = weight+(Double(dw)! * 0.2)
                    //let sq = ind.proQuality["Gold"] as! String
                  //  cell.originalPriceLbl.text = sw + " g"
                }
                
                if let Stone = ind.weight["Stone"] as? String {
                    weight = weight+(Double(Stone)! * 0.2)
                    //let sq = ind.proQuality["Gold"] as! String
                  //  cell.originalPriceLbl.text = sw + " g"
                }
                
                let we = String(format: "%.3f", weight)
                cell.priceLbl.text = we + " g"
                
            } else if ind.product_category == "PLATINUM JEWELLERY" {
                
    //            let gw = ind.proWeight["Platinum"] as! String
    //            cell.originalPriceLbl.text = "\(gw)" + " g"
                
                if let dct = ind.weight["Diamond"] as? String {
                    let doubleStr = String(format: "%.3f", dct.toDouble())
                    
                    
                    cell.ctlabel.text = doubleStr + " Ct"
                }
            
                var weight = Double()
                if let gw = ind.weight["Gold"] as? String {
                    //let gq = ind.proQuality["Gold"] as! String
                    weight = weight+Double(gw)!
                   // cell.originalPriceLbl.text = gw + " g"
                }
                if let pw = ind.weight["Platinum"] as? String {
                    weight = weight+Double(pw)!
                    //let pq = ind.proQuality["Gold"] as! String
                    cell.priceLbl.text = pw + " g"
                }
                if let sw = ind.weight["Silver"] as? String {
                    weight = weight+Double(sw)!
                    //let sq = ind.proQuality["Gold"] as! String
                  //  cell.originalPriceLbl.text = sw + " g"
                }
                
                if let dw = ind.weight["Diamond"] as? String {
                    weight = weight+(Double(dw)! * 0.2)
                    //let sq = ind.proQuality["Gold"] as! String
                  //  cell.originalPriceLbl.text = sw + " g"
                }
                
                if let Stone = ind.weight["Stone"] as? String {
                    weight = weight+(Double(Stone)! * 0.2)
                    //let sq = ind.proQuality["Gold"] as! String
                  //  cell.originalPriceLbl.text = sw + " g"
                }
                
                let quality = ind.quality["Platinum"] as? String
                
                let we = String(format: "%.3f", weight)
                cell.priceLbl.text = we + " g /\(quality!)"
            }
            
            cell.lblname.text = ind.productName
            
            return cell
            
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! imgCell
        let img = self.allFiles[indexPath.row].image
        if img.contains("mp4") {
            
            let thumbnail = self.allFiles[indexPath.row].thumbnail
            
            cell.img.kf.indicatorType = .activity
            cell.img.kf.setImage(with: URL(string: (thumbnail ).replacingOccurrences(of: " ", with: "%20")),placeholder: nil,options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
                switch result {
                case .success(let value):
                    print("Task done for: \(value.source.url?.absoluteString ?? "")")
                    
                case .failure(let error):
                    print("Job failed: \(error.localizedDescription)")
                    
                }
            }
            
            
            cell.btnPlay.isHidden = false
            cell.btnPlay.tag = indexPath.row
            cell.btnPlay.addTarget(self, action: #selector(btnplay), for: .touchUpInside)
            
        } else {
            cell.btnPlay.isHidden = true
            cell.img.kf.indicatorType = .activity
            cell.img.kf.setImage(with: URL(string: (img ).replacingOccurrences(of: " ", with: "%20")),placeholder: nil,options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
                switch result {
                case .success(let value):
                    print("Task done for: \(value.source.url?.absoluteString ?? "")")
                    
                case .failure(let error):
                    print("Job failed: \(error.localizedDescription)")
                    
                }
            }
        }
        
        
        return cell
    }
    @objc func btnplay(_ sender:UIButton){
        
    
       
        let ind = self.allFiles[sender.tag].image
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == self.recentCollectionView {
            return CGSize(width: 134, height: 134)
        }
        
        return CGSize(width: self.imgCollectionview.frame.width, height: self.imgCollectionview.frame.height)
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         if collectionView == self.imgCollectionview {
            let ind = self.allFiles[indexPath.item].image
            if ind.contains("mp4") {
                let url:URL = URL(string: ind)!

                let player = AVPlayer.init(url: url)
                let playerVC = AVPlayerViewController()
                playerVC.player = player
                self.present(playerVC, animated: true) {
                    playerVC.player?.play()
                }
            }else {
                self.selectedimage = ind
                self.performSegue(withIdentifier: "image", sender: self)
            }
         }else {
            let ind = self.trendingProduct[indexPath.row]
            
            self.nextproid = ind.productID
            let tempdic = ["id":self.nextproid]
            
            let urll = "\(MainURL.mainurl)img/product/"
            let imgurl = self.trendingProduct[indexPath.row].image
            let finalurl = urll + imgurl
            
            self.tempfile = Files.init(id: self.trendingProduct[indexPath.row].productID, productID: self.trendingProduct[indexPath.row].productID.toString(), image: finalurl.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!, type: 1, createdAt: "", updatedAt: "", thumbnail: "")
            
            
         
            self.performSegue(withIdentifier: "two", sender: self)
          

            
         }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "two" {
            let dvc = segue.destination as! productDetailNewVC
            dvc.productId = self.nextproid
            dvc.tempFile = self.tempfile
        }else if segue.identifier == "image" {
            let dvc = segue.destination as! ImageVC
            dvc.img = self.selectedimage
        }
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pageControl.currentPage = indexPath.row
    }
}
extension ProductDetials2 {
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
    
    func getAllData() {
        APIManager.shareInstance.getCurrentProfile(vc: self) { (pro, kyc,url) in
            
            APIManager.shareInstance.viewCart(user_id: pro.uid, vc: self) { [self] (allPro) in
                if allPro.count == 0 {
                  
                    self.removeAnimation()
                } else {
    
                    self.carts = allPro
                    for _ in 0 ..< self.carts.count {
                        self.quty.append(1)
                    }
                
                    for i in  0..<self.carts.count {
                        
                        let indCart = self.carts[i]
                        
                        
                        for j in 0..<indCart.assets.count {
                            
                        
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
                                           //cell.priceLbl.text = "₹ " + String(data)
                                          // cell.priceLbl.text = "₹ " + String(Utils.calculatePrice(weight: indCart.assets[j].weight.floatValue, rate: GoldPrice.sharedInstance.getpriceByGoldPrice(gold_type: indCart.assets[j].materialType).floatValue, makingCharge: indCart.assets[j].makingCharge.floatValue, isPerGram: true))
                                           
                //                           if self.allPrices.count == self.carts.count {
                //
                //                           } else {
                                               
                                               self.allPrices.append(data)
                                               
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
                                           
                                           
                                          // cell.priceLbl.text = "₹ " + String(daidata)
                                           
                                         //  cell.priceLbl.text = "₹ " + String(Utils.calculatePrice(weight: indCart.assets[j].weight.floatValue, rate: DiamondMaster.sharedInstance.getpriceByDiamondName(name: indCart.assets[j].materialType).floatValue, makingCharge: indCart.assets[j].makingCharge.floatValue, isPerGram: true))
                //                           if self.allPrices.count == self.carts.count {
                //
                //                           } else {
                                               
                                               self.allPrices.append(daidata)
                                               
                                         //  self.allPrices.append(Utils.calculatePrice(weight: indCart.assets[j].weight.floatValue, rate: DiamondMaster.sharedInstance.getpriceByDiamondName(name: indCart.assets[j].materialType).floatValue, makingCharge: indCart.assets[j].makingCharge.floatValue, isPerGram: true))
                                               
                                               self.basePrice.append(daidata)
                                           
                                    //       self.basePrice.append(Utils.calculatePrice(weight: indCart.assets[j].weight.floatValue, rate: DiamondMaster.sharedInstance.getpriceByDiamondName(name: indCart.assets[j].materialType).floatValue, makingCharge: indCart.assets[j].makingCharge.floatValue, isPerGram: true))
                                         //  }
                                       } else if indCart.assets[j].metal == "Stone" {
                                          // cell.priceLbl.text = "₹ " + String(Utils.calculatePrice(type: "Stone", weight: indCart.assets[j].weight.floatValue, rate: StonePrice.sharedInstance.getpriceByStoneprice(stone_type: indCart.assets[j].materialType).floatValue, makingCharge: indCart.assets[j].makingCharge.floatValue, option: indCart.assets[j].options, goldValue: 0.0, gold24k: 0.0))
                //                           if self.allPrices.count == self.carts.count {
                //
                //                           } else {
                                               self.allPrices.append(Utils.calculatePrice(type: "Stone", weight: indCart.assets[j].weight.floatValue, rate: StonePrice.sharedInstance.getpriceByStoneprice(stone_type: indCart.assets[j].materialType).floatValue, makingCharge: indCart.assets[j].makingCharge.floatValue, option: indCart.assets[j].options, goldValue: 0.0, gold24k: 0.0))
                                           
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
                                        //   cell.priceLbl.text = "₹ " + String(Utils.calculatePrice(type: "Platinum", weight: indCart.assets[j].weight.floatValue, rate: rate, makingCharge: indCart.assets[j].makingCharge.floatValue, option: indCart.assets[j].options, goldValue: 0.0, gold24k: 0.0))
                //                           if self.allPrices.count == self.carts.count {
                //
                //                           } else {
                                               self.allPrices.append(Utils.calculatePrice(type: "Platinum", weight: indCart.assets[j].weight.floatValue, rate: rate, makingCharge: indCart.assets[j].makingCharge.floatValue, option: indCart.assets[j].options, goldValue: 0.0, gold24k: 0.0))
                                           
                                               self.basePrice.append(Utils.calculatePrice(type: "Platinum", weight: indCart.assets[j].weight.floatValue, rate: rate, makingCharge: indCart.assets[j].makingCharge.floatValue, option: indCart.assets[j].options, goldValue: 0.0, gold24k: 0.0))
                                           //}
                                       }
                        }
                   
                        self.limit =  Double(allPro[0].manufacture_limit)!
                        
                        
                        
                }
                    calculateTotalPrices()
            }
                    
                    
                    
                    self.removeAnimation()
                }
            }
        }
    
    func calculateTotalPrices() {
//        let allTemp = self.allPrices.uniques
//
//        if allTemp.count == self.carts.count {
            var total = 0.0
            let deilveryCharge = 800.0
            for i in self.allPrices {
                print(i)
                total += i
            }
            
            if total > limit {
                self.view.makeToast("Product added to cart")
            }else {
                
                let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CartPopUpVC") as! CartPopUpVC
                        
                           self.addChild(popOverVC)
                popOverVC.total = total
                popOverVC.id = (product?.data.manufactureID)!
                           popOverVC.view.frame = self.view.frame
                           self.view.addSubview(popOverVC.view)
                           popOverVC.didMove(toParent: self)
                
            }
            
//            let serviceCharge = total / 100
//
//            let sgsttotal = total + serviceCharge
//
//            self.serviceChargeLbl.text = "₹ " + String(format: "%.2f", total / 100)
//            self.totalPriceLbl.text = "₹ " + String(format: "%.2f", total)
//            self.sgstLbl.text = "₹ " + String(self.calculateSGST(total: sgsttotal).rounded(toPlaces: 2))
//            self.cgstLbl.text = "₹ " + String(self.calculateCGST(total: sgsttotal).rounded(toPlaces: 2))
//            self.finalPriceLbl.text = "₹ " + String(format: "%.2f", self.calculateSGST(total: total) + self.calculateCGST(total: total) + total + serviceCharge + deilveryCharge)
//
//            self.bottomTotalPrice.text = "₹ " + String(format: "%.2f", self.calculateSGST(total: sgsttotal) + self.calculateCGST(total: sgsttotal) + total + serviceCharge + deilveryCharge)
//
//            var weight = 0.0
//
//            for i in 0 ..< self.carts.count {
//                let count = self.quty[i]
//                for j in self.carts[i].assets {
//                    let data = j.metal
//
//                    if data == "Stone"{
//                        let weightt = Double(j.weight)!*0.2
//                        weight += weightt * Double(count)
//                    }else if data == "Diamond"{
//                        let weightt = Double(j.weight)!*0.2
//                        weight += weightt * Double(count)
//
//                    }
//                    else {
//                        let weightt = Double(j.weight)
//                        weight += weightt! * Double(count)
//                    }
//
//                }
//            }
//         //   if weight >= 100 {
//                if weight > 150 {
//                    let additinal = weight - 150.0
//                    let deliveryCalc = additinal * 3.0
//                    let deliveryTotal = deilveryCharge + deliveryCalc
//                    self.deliveryChargeLbl.text = "₹ " + String(format: "%.2f", deliveryTotal)
//                } else {
//                    self.deliveryChargeLbl.text = "₹ " + String(format: "%.2f", deilveryCharge)
//                }
//          //  } else {
//          //      self.showAlert(titlee: "Message", message: "Your order should be minimum 100 Grams")
//          //  }
//           // self.deliveryChargeLbl.text = "₹ " + "\(deilveryCharge)"
//            self.totalWeight.text = String(format: "%.3f", weight) + " g"
//        }
    }
    func removeSpecialCharsFromString(text: String) -> String {
        let okayChars = Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890+=().!_")
        return text.filter {okayChars.contains($0) }
    }
}


