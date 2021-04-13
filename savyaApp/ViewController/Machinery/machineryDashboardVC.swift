//
//  machineryVC.swift
//  savyaApp
//
//  Created by Yash on 2/12/20.
//  Copyright © 2020 Yash Rathod. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import Alamofire
import SwiftyJSON
import AVFoundation
import AVKit
import Player
import FWPlayerCore
import Toast_Swift


class machineryDashboardVC:UIViewController, UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,PlayerDelegate,PlayerPlaybackDelegate,UIScrollViewDelegate {
    
    
    
    //MARK:- UICollectionView Outlets
    @IBOutlet weak var collection1:UICollectionView!
    @IBOutlet weak var collection2:UICollectionView!
    @IBOutlet weak var collection3:UICollectionView!
 
    @IBOutlet weak var collection5:UICollectionView!
   
    @IBOutlet weak var collection7:UICollectionView!
    @IBOutlet weak var collection8:UICollectionView!
    @IBOutlet weak var eventView:UIView!
    @IBOutlet weak var partnerView:UIView!
  
    @IBOutlet weak var collection1Act:UIActivityIndicatorView!
    @IBOutlet weak var collection2Act:UIActivityIndicatorView!
    @IBOutlet weak var collection8Act:UIActivityIndicatorView!
    @IBOutlet weak var tablee2Act:UIActivityIndicatorView!
    
    
    @IBOutlet weak var tablee3:UITableView!
    
    @IBOutlet weak var documentVerified:UIView!
    var player = AVPlayer()
    
    var isfrom = "0"
    var menuid = ""
  
    private lazy var containerView: UIImageView = {
        let imageView = UIImageView()
        imageView.setImageWithURLString("coverImageUrl", placeholder: UIImage(named: "placeholder"))
        return imageView
    }()
   
    @IBOutlet weak var table1Img:UIImageView!
    @IBOutlet weak var bannerImg:UIImageView!
  
    @IBOutlet weak var heightCollection:NSLayoutConstraint!
    @IBOutlet weak var scrollView:UIScrollView!
    @IBOutlet weak var collection5Hieght:NSLayoutConstraint!
    
    let apis = APIManager()
    
    var appBanners = [AppBanner]()
    
    deinit {
        self.player.pause()
    }
    var rates = [LiveRate]()
    var trendingProduct = [Product]()
    let bannerimgs = [UIImage(named: "1"),UIImage(named: "2"),UIImage(named: "3"),UIImage(named: "4")]
    let partnerShipLbl = [UIImage(named: "p1"),UIImage(named: "p2"),UIImage(named: "p3")]
  
    var app_banners = [[String:AnyObject]]()
    var exclusive_banner = [[String:AnyObject]]()
    var sub_categories = [[String:AnyObject]]()
    var manufacturer = [[String:AnyObject]]()
    var manufacturerRandom = [[String:AnyObject]]()
    var trending_product = [[String:AnyObject]]()
    var machineryProd = [MachineryProduct]()
    var events = [Event]()
    var imgurl = ""
    var sendid = 0
    var isFromManufacture: Bool = false
    var productimgurl = ""
    let videos = ["https://s3.ap-south-1.amazonaws.com/www.savyajewelsbusiness.com/video/otherassets/savya_home.mp4"]
   
    let categories = ["Gold","Silver","Diamond","Platinum","Stone"]
    var oldask:Float!
    var oldbid:Float!
    var oldhigh:Float!
    var oldlow:Float!
    let tapViewGesture = UITapGestureRecognizer()
    var ind = IndexPath(row: 0, section: 0)
    var indd = IndexPath(row: 0, section: 0)
    var inddd = IndexPath(row: 0, section: 0)
    var indddd = IndexPath(row: 0, section: 0)
    var currentProfile:Profile!
    var kyc:Kyc!
    var selectedEvent:Event?
    var partners = [Partner]()
    var allGallery = [Gallery]()
    
    
    
    @IBOutlet var machinerySellerView: UIView!
    @IBOutlet var machinerySellerScrollView: UIScrollView!
    @IBOutlet weak var machinerySellerContentView: UIView!
    @IBOutlet weak var machinerySellerContentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var machinerySellereLogo: UIImageView!
    @IBOutlet weak var machinerySellerTitle: UILabel!
    @IBOutlet weak var machinerySellerPartnershipLogo: UIImageView!
    @IBOutlet weak var machinerySellerDescription: UILabel!
    var selectedSellerId: Int = 0

    
    //MARK:- UIView Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collection1Act.startAnimating()
        self.collection1Act.isHidden = false
        
        self.collection2Act.startAnimating()
        self.collection2Act.isHidden = false
        
        self.collection8Act.startAnimating()
        self.collection8Act.isHidden = false
        
        self.collection1.tag = 1
        self.collection2.tag = 2
        self.collection3.tag = 3
        self.collection5.tag = 5
      
        tapViewGesture.delegate = self
        tapViewGesture.cancelsTouchesInView = false
       // self.scrollView.addGestureRecognizer(tapViewGesture)
    //    self.scrollView.delegate = self
        self.startTimer()
        self.startTimer2()
        self.startTimer3()
        self.startTimer4()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.documentVerified.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       // self.getallRate()
        self.getAllData()
        self.getAllEvents()
        self.collection5.reloadData()
        self.collection7.reloadData()
        let dispatchQueue = DispatchQueue(label: "QueueIdentification", qos: .background)
        dispatchQueue.async{
           // self.getallRate()
        }
    
      //  self.scrollView.contentSize.height = 4000
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
   //     self.tablee2.invalidateIntrinsicContentSize()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            if UIDevice.current.userInterfaceIdiom == .pad {
//                let total1 = self.collection5.frame.height + self.tablee2.frame.height + self.collection1.frame.height + 200
//                let total = self.collection2.frame.height + self.collection3.frame.height + self.collection4.frame.height + self.collection6.frame.height + total1
//                self.scrollView.contentSize = CGSize(width: self.view.frame.width, height:total +  self.collection7.frame.height + 210 + self.collection8.frame.height + 200)
//            } else if UIDevice.current.userInterfaceIdiom == .phone {
//                let total1 = self.collection5.frame.height + self.tablee2.frame.height + self.collection1.frame.height + 200
//                let total = self.collection2.frame.height + self.collection3.frame.height + self.collection4.frame.height + self.collection6.frame.height + total1
//                self.scrollView.contentSize = CGSize(width: self.view.frame.width, height:total +  self.collection7.frame.height + 210 + self.collection8.frame.height)
//            }
        
            if UIDevice.current.userInterfaceIdiom == .pad {
                
                let total = self.collection1.frame.height + self.collection2.frame.height + self.collection3.frame.height + self.collection8.frame.height + self.collection5.frame.height + self.collection7.frame.height
                self.scrollView.contentSize.height = total + 100
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "proceed" {
            let dvc = segue.destination as! allMachineVC
            dvc.isFromManufacturer = self.isFromManufacture
            dvc.subcata = self.sendid.toString()
        } else if segue.identifier == "search" {
            let dvc = segue.destination as! searchVC
            dvc.isMachinerySearch = true
        }else if segue.identifier == "machineDetail" {
            let dvc = segue.destination as! machineDetailsVC
            dvc.id = "\(self.sendid)"
        }
    }
    
    
    @objc func trendProduct(_ sender:UIButton) {
        if self.kyc.documentVerified == "0" {
            self.documentVerified.isHidden = false
        } else {
            self.sendid = self.trending_product[sender.tag]["id"] as! Int
            
            self.performSegue(withIdentifier: "trend", sender: self)
        }
    }
    //search
    @IBAction func searchBtn(_ sender:UIButton) {
        self.performSegue(withIdentifier: "search", sender: self)
    }
    @IBAction func closeBtn(_ sender:UIButton) {
        self.documentVerified.isHidden = true
    }
    @IBAction func backbtn(_ sender:UIButton) {
        let dvc = self.storyboard?.instantiateViewController(withIdentifier: "sidemenu2") as! machinerySideMenu
        dvc.dismiss(animated: true, completion: nil)
    }
    @objc func didTapView(gesture: UITapGestureRecognizer) {
        view.endEditing(true)
        let touchLocation:CGPoint = gesture.location(ofTouch: 0, in: self.collection3)
        let indexPath = self.collection3.indexPathForItem(at: touchLocation)
        if indexPath != nil {
            let cell = self.collection3.cellForItem(at: indexPath!)
            if (cell?.isSelected)! {
                //PREFORM DESELECT
            } else {
                let id = self.trending_product[indexPath!.row]["product_id"] as! Int
                self.sendid = id
                self.performSegue(withIdentifier: "trend", sender: self)
            }
        }
    }
    
    func playerReady(_ player: Player) {
        
    }
    
    func playerPlaybackStateDidChange(_ player: Player) {
        
    }
    
    func playerBufferingStateDidChange(_ player: Player) {
        
    }
    
    func playerBufferTimeDidChange(_ bufferTime: Double) {
        
    }
    
    func player(_ player: Player, didFailWithError error: Error?) {
        
    }
    
    func playerCurrentTimeDidChange(_ player: Player) {
        
    }
    
    func playerPlaybackWillStartFromBeginning(_ player: Player) {
        
    }
    
    func playerPlaybackDidEnd(_ player: Player) {
        
    }
    
    func playerPlaybackWillLoop(_ player: Player) {
        
    }
    
    func playerPlaybackDidLoop(_ player: Player) {
        
    }
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let dvc = self.storyboard?.instantiateInitialViewController()
        self.present(dvc!, animated: true, completion: nil)
    }
    @objc func gotoDetails(_ sender:UIButton) {
        let id = self.trending_product[sender.tag]["product_id"] as! Int
        self.sendid = id
        self.performSegue(withIdentifier: "trend", sender: self)
    }
    //MARK:- GetAll Data
    func getAllData() {
        let authorization:HTTPHeaders =  ["Authorization":Token.getLatestToken()]
        
        AF.request(NewAPI.machineryDashboard,method: .get,parameters: nil,encoding: JSONEncoding.default,headers: authorization).responseJSON { (responseData) in
            
            APIManager.shareInstance.printEveryThing(responseData: responseData, statusCode: responseData.response?.statusCode ?? 000, url: NewAPI.dashboard, para: "para")
            if responseData.value != nil {
                print(responseData.value)
                let respData = responseData.value as! [String:Any]
                let respData1 = respData["body"] as! [[String:Any]]
                
                //MARK:- App Banners 0
                let appBanners = respData1[0]["machinery_banners"] as! [[String:Any]]
                let filteredBanners = appBanners.filter({$0["place"] as! String == "App"})
                let app_resData = JSON(filteredBanners)
                if let resData = app_resData.arrayObject {
                    self.app_banners = resData as! [[String:AnyObject]]
                }
                for i in self.app_banners {
                    let id = i["id"] as? Int ?? 0
                    let banner_for = i["banner_for"] as? String ?? ""
                    let state_code = i["state_code"] as? String ?? ""
                    let city_code = i["city_code"] as? String ?? ""
                    let user_id = i["user_id"] as? String ?? ""
                    let title = i["title"] as? String ?? ""
                    let type = i["type"] as? String ?? ""
                    let place = i["place"] as? String ?? ""
                    let start_date = i["start_date"] as? String ?? ""
                    let end_date = i["end_date"] as? String ?? ""
                    let category_id = i["category_id"] as? String ?? ""
                    let subcategory_id = i["subcategory_id"] as? String ?? ""
                    let subsubcategory_id = i["subsubcategory_id"] as? String ?? ""
                    let image = i["image"] as? String ?? ""
                    let status = i["status"] as? String ?? ""
                    let created_at = i["created_at"] as? String ?? ""
                    let updated_at = i["updated_at"] as? String ?? ""
                    
                    let tempurlImg = MainURL.mainurl + "img/machinarybanner/" + image
                    
                   
                        self.appBanners.append(AppBanner.init(id: id, bannerFor: banner_for, stateCode: state_code, cityCode: city_code, userID: user_id, title: title, type: type, place: place, startDate: start_date, endDate: end_date, categoryID: category_id, subcategoryID: subcategory_id, subsubcategoryID: subsubcategory_id, image: tempurlImg.replacingOccurrences(of: " ", with: "%20"), status: status, createdAt: created_at, updatedAt: updated_at))
                    
                    
                }
                print(self.appBanners.count)
                self.collection1.reloadData()
                self.collection1Act.isHidden = true
                
                
                
                //MARK:-Sub Categories 1
                let sub_cata = respData1[1]["categories"] as! [[String:Any]]
                let sub_cata_resData = JSON(sub_cata)
                if let resData3 = sub_cata_resData.arrayObject {
                    self.sub_categories = resData3 as! [[String:AnyObject]]
                }
                self.collection2.reloadData()
                print(self.sub_categories)
                self.collection2Act.isHidden = true
                
                //MARK:- Manufacture 2
                let manufacturer = respData1[2]["manufacture"] as! [[String:Any]]
                let manufacturer_resData = JSON(manufacturer)
                if let resDataManu = manufacturer_resData.arrayObject {
                    self.manufacturer = resDataManu as! [[String:AnyObject]]
                }
                self.manufacturerRandom = self.manufacturer.shuffled()
                self.collection8.reloadData()
                self.collection8Act.isHidden = true
                
                
                //MARK:-machinery_model 3
                let gallery = respData1[3]["machinery_model"] as! [[String:Any]]
                self.allGallery.removeAll()
                for i in gallery {
                    let id = i["id"] as? Int ?? 0
                    let title = i["title"] as? String ?? "No Address"
                    let file_type = i["file_type"] as? String ?? "No Date"
                    let file_name = i["file_name"] as? String ?? "No time"
                    let thumbnail = i["thumbnail"] as? String ?? "No image"
                    let status = i["status"] as? String ?? "No Description"
                    
                    self.allGallery.append(Gallery.init(id: id, title: title, fileType: file_type, fileName: (MainURL.mainurl + "img/machinerygallery/" + file_name).replacingOccurrences(of: " ", with: "%20"), thumbnail: thumbnail, status: status, createdAt: "", updatedAt: ""))
                }
                self.collection5.reloadData()
                

                
                
                //MARK:-Exclusive banners 4
                let exclusiveBanner = respData1[4]["exclusive_banners"] as! [[String:Any]]
                let exclusuve_resData = JSON(exclusiveBanner)
                if let resData2 = exclusuve_resData.arrayObject {
                    self.exclusive_banner = resData2 as! [[String:AnyObject]]
                }
//                self.tablee2.reloadData()
//                if self.exclusive_banner.count == 0 {
//                    self.tablee2.visiblity(gone: true)
//                }
        
                //MARK:-Machinery_product 5
                let allmachineProd = respData1[5]["Machinery_product"] as! [[String:Any]]
                self.machineryProd.removeAll()
                for i in allmachineProd {
                    let product_id = i["product_id"] as? Int ?? 0
                    let product_name = i["product_name"] as? String ?? ""
                    let productcode = i["productcode"] as? String ?? ""
                    let amount = i["amount"] as? String ?? ""
                    let image = i["image"] as? String ?? ""
                    
                    let tempurlImg = (MainURL.mainurl + "img/product/" + image).replacingOccurrences(of: " ", with: "%20")
                    
                    let e1 = MachineryProduct.init(productID: product_id, productName: product_name, productcode: productcode, amount: amount, image: tempurlImg)
                    self.machineryProd.append(e1)
                }
                self.collection3.reloadData()
                if self.machineryProd.count == 0 {
                  //  self.eventView.visiblity(gone: true)
                }
                
                //MARK:- Partner 6
                let partner = respData1[6]["machinery_partner"] as! [[String:Any]]
                for i in partner {
                    let id = i["id"] as? Int ?? 0
                    let title = i["title"] as? String ?? ""
                    let image = i["image"] as? String ?? ""
                    let status = i["status"] as? String ?? ""
                    let created_at = i["created_at"] as? String ?? ""
                    let updated_at = i["updated_at"] as? String ?? ""
                    
                    let tempurlImg = (MainURL.mainurl + "img/machinerypartner/" + image).replacingOccurrences(of: " ", with: "%20")
                    
                    self.partners.append(Partner.init(id: id, title: title, image: tempurlImg, status: status, createdAt: created_at, updatedAt: updated_at))
                }
                self.collection7.reloadData()
                if self.partners.count == 0 {
                    self.partnerView.visiblity(gone: true)
                }
                
                
                
                
                
                
                self.productimgurl = respData["product_url"] as? String ?? ""
                self.collection3.reloadData()
                
                
                if Global.getIsfrom() == "1" {
                    Global.setIsFrom(isFrom: "")
                    if Global.getNotiId() == "19" {
                        Global.setIsFrom(isFrom: "")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            let menuid = Global.getMenuid()
                            for i in 0..<self.manufacturerRandom.count {
                                if menuid == "\(self.manufacturerRandom[i]["id"])" {
                                    self.configureMachinerySellerView(seller: self.manufacturerRandom[i])
                                    break
                                }
                            }
                        }
                    }
                    
                }
           //     self.removeAnimation()
            }
        }
    }
    
    //MARK:- Get All Events
    func getAllEvents() {
        apis.getAllEvents(vc: self) { (event, imgurl) in
            //self.events = event!
          //  self.imgurl = imgurl
            
        }
    }
    
    //MARK:- Get All Live Rates
//    func getallRate() {
//       // self.widthCollection.constant = self.view.frame.width
//        APIManager.shareInstance.getliverates(vc: self) { (ratees) in
//            if ratees.count > 0 {
//                self.rates.removeAll()
//                self.rates = ratees
//            }
//
//          //  self.collection6.reloadData()
//          //  sleep(4)
//            let dispatchQueue = DispatchQueue(label: "QueueIdentification", qos: .background)
//            dispatchQueue.async{
//                //self.getallRate()
//            }
//         //
//        }
//    }
    
    @IBAction func btnCall(_ sender: Any) {
        let url: NSURL = URL(string: "TEL://0120-4576629")! as NSURL
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
    }
    //MARK:- IBActions
    @IBAction func phoneBtn(_ sender:UIButton) {
//        let url: NSURL = URL(string: "TEL://18004199612")! as NSURL
//        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        let urlWhats = "whatsapp://send?phone=+919711022520"
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed){
            if let whatsappURL = URL(string: urlString) {
                if UIApplication.shared.canOpenURL(whatsappURL){
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(whatsappURL, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(whatsappURL)
                    }
                }
                else {
                    self.view.makeToast("WhatsApp not installed in phone")
                }
            }
        }
    }
    
    //MARK:- CollectionView Scroll to Next
    @objc func scrollToNextCell() {

        if self.ind.row >= self.appBanners.count - 1 {
            print("Collection 1")
            print("inside block")
            print("Index = \(self.ind)")
            self.ind.row = 0
            let ind2 = self.ind.row
            self.ind.row = ind2
            let finalindd = IndexPath(row: ind2, section: 0)
            self.collection1.scrollToItem(at: finalindd, at: .left, animated: true)
        } else {
            let ind2 = self.ind.row + 1
            self.ind.row = ind2
            let finalindd = IndexPath(row: ind2, section: 0)
            self.collection1.scrollToItem(at: finalindd, at: .right, animated: true)
        }
        
      
    
    }
    @objc func scrollToNextCell2() {

        if self.inddd.row == self.allGallery.count - 1 {
            print("Collection 1")
            print("inside block")
            print("Index = \(self.ind)")
            self.inddd.row = 0
            let ind2 = self.inddd.row
            let finalindd = IndexPath(row: ind2, section: 0)
            self.collection5.scrollToItem(at: finalindd, at: .left, animated: true)
        } else {
            let ind2 = self.inddd.row + 1
            self.inddd.row = ind2
            let finalindd = IndexPath(row: ind2, section: 0)
            self.collection5.scrollToItem(at: finalindd, at: .right, animated: true)
        }
        
      
    
    }
    @objc func scrollToNextCell3() {
//        if self.indd.row == self.partners.count - 1 {
//            print("Collection 1")
//            print("inside block")
//            print("Index = \(self.ind)")
//            self.indd.row = 0
//            let ind2 = self.indd.row
//            self.indd.row = ind2
//            let finalindd = IndexPath(row: ind2, section: 0)
//            self.collection7.scrollToItem(at: finalindd, at: .left, animated: true)
//        } else {
//            let ind2 = self.indd.row + 1
//            self.indd.row = ind2
//            let finalindd = IndexPath(row: ind2, section: 0)
//            self.collection7.scrollToItem(at: finalindd, at: .right, animated: true)
//        }
        
    }
    @objc func scrollToNextCell4() {
        let ind2 = self.indddd.row + 1
        self.indddd.row = ind2
        let finalindd = IndexPath(row: ind2, section: 0)
       // self.collection6.scrollToItem(at: finalindd, at: .right, animated: true)
    }
    @objc func eventTapped(_ sender:UIButton) {
        print(sender.tag)
    }
    func startTimer() {
        _ = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(scrollToNextCell), userInfo: self, repeats: true)
    }
    func startTimer2() {
        _ = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(scrollToNextCell2), userInfo: self, repeats: true)
    }
    func startTimer3() {
        _ = Timer.scheduledTimer(timeInterval: 7.0, target: self, selector: #selector(scrollToNextCell3), userInfo: self, repeats: true)
    }
    func startTimer4() {
        _ = Timer.scheduledTimer(timeInterval: 7.0, target: self, selector: #selector(scrollToNextCell4), userInfo: self, repeats: true)
    }
    @objc func unlimitedBanner(_ sender:UIButton) {
        let id = Int((self.exclusive_banner[sender.tag]["category_id"] as? String)!)
        self.sendid = id!
        
        self.performSegue(withIdentifier: "subsub", sender: self)
    }
    //MARK:- UICollectionView Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collection1 {
            return self.appBanners.count
        } else if collectionView == self.collection2 {
            return self.sub_categories.count
        } else if collectionView == self.collection3 {
            return self.machineryProd.count
        } else if collectionView == self.collection5 {
            return self.allGallery.count
        } else if collectionView == self.collection7 {
            return self.partners.count
        } else if collectionView == self.collection8{
            return self.manufacturerRandom.count
        } else {
            return 9000
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if indexPath.row == self.app_banners.count - 1 {
                self.collection1.scrollToItem(at: IndexPath.init(row: 0, section: 0), at: UICollectionView.ScrollPosition.left, animated: true)
                
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collection1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! exclusive_bannerCell
            if self.appBanners.count > 0 {
                let ind = self.appBanners[indexPath.item]
               // let itemToShow = self.app_banners[indexPath.row % self.app_banners.count]
               
                 // cell.img.layer.cornerRadius = 10.0
                //  cell.img.clipsToBounds = true
                  cell.img.kf.indicatorType = .activity
                cell.img.kf.setImage(with: URL(string: ind.image),placeholder: nil,options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
                      switch result {
                      case .success(let value):
                          print("Task done for: \(value.source.url?.absoluteString ?? "")")
                          
                      case .failure(let error):
                          
                        print("Job failed: \(error.localizedDescription) \(ind.image)")
                          
                      }
                  }
            }
            
            return cell
        } else if collectionView == self.collection2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! subcategoryCell
            
            cell.lbl1.numberOfLines = 0
            cell.lbl1.text = self.sub_categories[indexPath.row]["subcategory"] as? String
            
            cell.view1.layer.cornerRadius = 6
            cell.view1.clipsToBounds = true
            let img = self.sub_categories[indexPath.row]["image"] as? String
            let finalurl = MainURL.mainurl + "img/subcategory/\(img ?? "no image")"
            var turl = finalurl
            if finalurl.contains(" ") {
                turl = finalurl.replacingOccurrences(of: " ", with: "%20")
            }
            cell.img.kf.indicatorType = .activity
            cell.img.kf.setImage(with: URL(string: turl),placeholder: nil,options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
                switch result {
                case .success(let value):
                    print("Task done for: \(value.source.url?.absoluteString ?? "")")
                    
                case .failure(let error):
                    print("Job failed: \(error.localizedDescription)")
                    
                }
            }
            return cell
        } else if collectionView == self.collection3 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! productCell
            let ind = self.machineryProd[indexPath.row]
           // let ind = self.trendingProduct[indexPath.row]
        
           
            cell.originalPriceLbl.text = ind.productName
            
            
            
            cell.img.kf.indicatorType = .activity
            cell.img.kf.setImage(with: URL(string: ind.image),placeholder: nil,options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
                switch result {
                case .success(let value):
                    print("Task done for: \(value.source.url?.absoluteString ?? "")")
                    
                case .failure(let error):
                    print("Job failed: \(error.localizedDescription)")
                    
                }
            }
            

            return cell
        } else if collectionView == self.collection7 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! patnershipCell
          //  let itemToShow = self.partnerShipLbl[indexPath.row % self.partnerShipLbl.count]
           // let itemToShoww = self.partnerShipLbll[indexPath.row % self.partnerShipLbll.count]
           // cell.img.image = itemToShow!
            cell.lbl1.text = self.partners[indexPath.row].title
            cell.img.kf.indicatorType = .activity
            cell.img.kf.setImage(with: URL(string: self.partners[indexPath.item].image),placeholder: nil,options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
                switch result {
                case .success(let value):
                    print("Task done for: \(value.source.url?.absoluteString ?? "")")
                    
                case .failure(let error):
                    print("Job failed: \(error.localizedDescription)")
                    
                }
            }
            return cell
            
        } else if collectionView == self.collection5 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! bannerImgCell
            
            
            cell.img.kf.indicatorType = .activity
            cell.img.kf.setImage(with: URL(string: self.allGallery[indexPath.item].fileName),placeholder: nil,options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
                switch result {
                case .success(let value):
                    print("Task done for: \(value.source.url?.absoluteString ?? "")")
                    
                case .failure(let error):
                    print("Job failed: \(error.localizedDescription)")
                    
                }
            }
            
            return cell
        }  else if collectionView == self.collection8 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! subcategoryCell
            
            cell.lbl1.numberOfLines = 0
            cell.lbl1.text = self.manufacturerRandom[indexPath.row]["name"] as? String
            
            cell.view1.layer.cornerRadius = 6
            cell.view1.clipsToBounds = true
            let img = self.manufacturerRandom[indexPath.row]["logo"] as? String
            let finalurl = MainURL.mainurl + "img/users/\(img ?? "no image")"
            var turl = finalurl
            if finalurl.contains(" ") {
                turl = finalurl.replacingOccurrences(of: " ", with: "%20")
            }
            cell.img.kf.indicatorType = .activity
            cell.img.kf.setImage(with: URL(string: turl),placeholder: nil,options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
                switch result {
                case .success(let value):
                    print("Task done for: \(value.source.url?.absoluteString ?? "")")
                    
                case .failure(let error):
                    print("Job failed: \(error.localizedDescription)")
                    
                }
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collection1 {
            return CGSize(width: self.collection1.frame.width, height: 200)
        } else if collectionView == self.collection2 {
            if UIDevice.current.userInterfaceIdiom == .pad {
                return CGSize(width: self.collection2.frame.width / 4, height: self.collection2.frame.height)
            }
            return CGSize(width: self.collection2.frame.width / 4, height: self.collection2.frame.height - 5)
        } else if collectionView == self.collection3 {
            if UIDevice.current.userInterfaceIdiom == .pad {
                return CGSize(width: self.collection3.frame.width / 5, height: self.collection3.frame.height)
            }
            return CGSize(width: self.collection3.frame.width / 3, height: self.collection3.frame.height)
        } else if collectionView == self.collection5 {
            if UIDevice.current.userInterfaceIdiom == .pad {
                 return CGSize(width: self.view.frame.width / 4, height: self.collection5.frame.height)
            }
            return CGSize(width: self.view.frame.width / 2, height: 150)
        } else if collectionView == self.collection7 {
            if UIDevice.current.userInterfaceIdiom == .pad {
                return CGSize(width: self.view.frame.width / 3, height: self.collection7.frame.height - 25)
            }
            return CGSize(width: self.view.frame.width - 30, height: self.collection7.frame.height - 25)
        } else if collectionView == self.collection8 {
            if UIDevice.current.userInterfaceIdiom == .pad {
                return CGSize(width: self.collection2.frame.width / 7, height: self.collection2.frame.height)
            }
            return CGSize(width: self.collection2.frame.width / 3, height: self.collection2.frame.height)
        } else {
            return CGSize.zero
        }
    }
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collection1 {
            let id = self.appBanners[indexPath.item].userID
            self.sendid = id.toInt()
            self.isFromManufacture = true
            self.performSegue(withIdentifier: "proceed", sender: self)
        } else if collectionView == self.collection3 {
            /*let id = self.trending_product[indexPath.row]["product_id"] as! Int
            self.sendid = id
            self.performSegue(withIdentifier: "trend", sender: self)*/
            self.sendid = self.machineryProd[indexPath.item].productID
            self.performSegue(withIdentifier: "machineDetail", sender: self)
        
        } else if collectionView == self.collection2 {
            let cate = self.sub_categories[indexPath.row]["id"] as! Int
            self.sendid = cate
            self.isFromManufacture = false
            self.performSegue(withIdentifier: "proceed", sender: self)
            
            
        } else if collectionView == self.collection8 {
            self.configureMachinerySellerView(seller: self.manufacturerRandom[indexPath.item])
        }
    }
    
    //MARK:- UITableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if tableView == self.tablee1 {
//            return self.categories.count
//        } else {
//        if tableView == self.tablee2 {
//            return 0
//            return self.exclusive_banner.count
//        } else {
//            return 1
//        }
        return 0
            
   //     }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if tableView == self.tablee1 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
//            cell?.textLabel?.text = self.categories[indexPath.row]
//            return cell!
//        } else {
        if tableView == self.tablee3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ShotTableViewCell
            
                cell.configureCell(imageUrl: nil, description: "Video", videoUrl: videos[indexPath.row])
            
            
               // cell.configureCell(imageUrl: nil, description: "Image", videoUrl: nil)
            
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! unlimited_banner
        let img = self.exclusive_banner[indexPath.row]["image"] as? String
        let finalurl = MainURL.mainurl + "/img/banner/\(img ?? "no image")"
        var turl = finalurl
        if finalurl.contains(" ") {
            turl = finalurl.replacingOccurrences(of: " ", with: "%20")
        }
        cell.btn1.addTarget(self, action: #selector(unlimitedBanner(_:)), for: .touchUpInside)
        cell.img.kf.indicatorType = .activity
        cell.img.kf.setImage(with: URL(string: turl),placeholder: nil,options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
                    
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
                print(finalurl)
                    
            }
        }
        cell.titleLbl.text = self.exclusive_banner[indexPath.row]["title"] as? String
        cell.subtitlLbl.text = self.exclusive_banner[indexPath.row]["description"] as? String
        cell.titleLbl1.text = self.exclusive_banner[indexPath.row]["title"] as? String
        cell.subtitleLbl1.text = self.exclusive_banner[indexPath.row]["description"] as? String
        cell.designLbl.text = "20 Design"
        cell.priceLbl.text = "Starting From ₹5000"
        let yourViewBorder = CAShapeLayer()
        yourViewBorder.strokeColor = UIColor.init(red: 175/255, green: 156/255, blue: 105/255, alpha: 1.0).cgColor
        yourViewBorder.lineDashPattern = [10, 2]
        yourViewBorder.frame = cell.desginView.bounds
        yourViewBorder.fillColor = nil
        yourViewBorder.path = UIBezierPath(rect: cell.desginView.bounds).cgPath
        cell.desginView.layer.addSublayer(yourViewBorder)
            
        let yourViewBorder1 = CAShapeLayer()
        yourViewBorder1.strokeColor = UIColor.init(red: 175/255, green: 156/255, blue: 105/255, alpha: 1.0).cgColor
        yourViewBorder1.lineDashPattern = [10, 2]
        yourViewBorder1.frame = cell.preiceView.bounds
        yourViewBorder1.fillColor = nil
        yourViewBorder1.path = UIBezierPath(rect: cell.preiceView.bounds).cgPath
        cell.preiceView.layer.addSublayer(yourViewBorder1)
        return cell
      //  }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if tableView == self.tablee1 {
//            return self.tablee1.frame.height / 5
//        } else {
       
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 600
        } else {
            return 300
        }
    //    }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if tableView == self.tablee2 {
//            let id = Int((self.exclusive_banner[indexPath.row]["sub_catagory"] as? String)!)
//            self.sendid = id!
//            print(self.sendid)
//            self.performSegue(withIdentifier: "subsub", sender: self)
//        }
//        } else if tableView == self.tablee1 {
//            let id = indexPath.row + 1
//            self.sendid = id
//            self.performSegue(withIdentifier: "subcata", sender: self)
//        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
    }
       
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            
        }
    }
       
//    func pausePlayeVideos(){
//        ASVideoPlayerController.sharedVideoPlayer.pausePlayeVideosFor(tableView: self.tablee3)
//    }
       
    @objc func appEnteredFromBackground() {
        ASVideoPlayerController.sharedVideoPlayer.pausePlayeVideosFor(tableView: self.tablee3, appEnteredFromBackground: true)
    }
}
extension machineryDashboardVC {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

//MARK:- SELLER VIEW
extension machineryDashboardVC {
    func configureMachinerySellerView(seller: [String:AnyObject]) {
        self.view.layoutIfNeeded()
        
        machinerySellerTitle.text = seller["name"] as? String
        machinerySellerDescription.text = seller["description"] as? String
        selectedSellerId = seller["manufacture_id"] as? Int ?? 0
        
        let img = seller["logo"] as? String
        let finalurl = MainURL.mainurl + "img/users/\(img ?? "no image")"
        var turl = finalurl
        if finalurl.contains(" ") {
            turl = finalurl.replacingOccurrences(of: " ", with: "%20")
        }
        
        machinerySellereLogo.kf.indicatorType = .activity
        machinerySellereLogo.kf.setImage(with: URL(string: turl),placeholder: nil,options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
                
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
                
            }
        }
        
        if (seller["package_name"] as? String)?.lowercased() == "silver" {
            machinerySellerPartnershipLogo.image = #imageLiteral(resourceName: "silvermember")
        } else if (seller["package_name"] as? String)?.lowercased() == "gold" {
            machinerySellerPartnershipLogo.image = #imageLiteral(resourceName: "goldmember")
        } else if (seller["package_name"] as? String)?.lowercased() == "platinum" {
            machinerySellerPartnershipLogo.image = #imageLiteral(resourceName: "platinummember")
        } else if (seller["package_name"] as? String)?.lowercased() == "diamond" {
            machinerySellerPartnershipLogo.image = #imageLiteral(resourceName: "diamondmember")
        }
        
        machinerySellerView.frame = self.view.bounds
        machinerySellerView.center = self.view.center
        UIView.transition(with: self.view, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.view.addSubview(self.machinerySellerView)
        }, completion: nil)
        self.view.bringSubviewToFront(machinerySellerView)
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            if self.machinerySellerScrollView.contentSize.height > 400 {
                var height = self.machinerySellerScrollView.contentSize.height
                if height >= self.view.bounds.height {
                    height = self.view.bounds.height-150
                } else {
                    height = height > self.view.bounds.height-150 ? self.view.bounds.height-150 : height
                }
                self.machinerySellerContentViewHeight.constant = height
            } else {
                self.machinerySellerContentViewHeight.constant = self.machinerySellerScrollView.contentSize.height
            }
        }
    }
    @IBAction func machinerySellerCancelBtn(_ sender: Any) {
        UIView.transition(with: self.view, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.selectedSellerId = 0
            self.machinerySellerView.removeFromSuperview()
        }, completion: nil)
    }
    @IBAction func machinerySellerOkBtn(_ sender: Any) {
        self.machinerySellerView.removeFromSuperview()
        self.sendid = self.selectedSellerId
        self.isFromManufacture = true
        self.performSegue(withIdentifier: "proceed", sender: self)
    }
}
