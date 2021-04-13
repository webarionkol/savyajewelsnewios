//
//  dashboardVC.swift
//  savyaApp
//
//  Created by Yash on 6/22/19.
//  Copyright © 2019 Yash Rathod. All rights reserved.
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


class dashboardVC:RootBaseVC, UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,PlayerDelegate,PlayerPlaybackDelegate,UIScrollViewDelegate {
    
    
    
    //MARK:- UICollectionView Outlets
    @IBOutlet weak var collection1:UICollectionView!
    @IBOutlet weak var collection2:UICollectionView!
    @IBOutlet weak var collection3:UICollectionView!
    @IBOutlet weak var collection4:UICollectionView!
    @IBOutlet weak var collection5:UICollectionView!
    @IBOutlet weak var collection6:UICollectionView!
    @IBOutlet weak var collection7:UICollectionView!
    @IBOutlet weak var collection8:UICollectionView!
    @IBOutlet weak var eventView:UIView!
    @IBOutlet weak var partnerView:UIView!
    //MARK:- UIAct Outlets
    @IBOutlet weak var collection1Act:UIActivityIndicatorView!
    @IBOutlet weak var collection2Act:UIActivityIndicatorView!
    @IBOutlet weak var collection8Act:UIActivityIndicatorView!
    @IBOutlet weak var tablee2Act:UIActivityIndicatorView!
    
    @IBOutlet weak var table2Height:NSLayoutConstraint!
    @IBOutlet weak var tablee2:UITableView!
    @IBOutlet weak var tablee3:UITableView!
    
    @IBOutlet weak var documentVerified:UIView!
    var player = AVPlayer()
   
    private lazy var containerView: UIImageView = {
        let imageView = UIImageView()
        imageView.setImageWithURLString("coverImageUrl", placeholder: UIImage(named: "placeholder"))
        return imageView
    }()
    var playerController: ASVideoPlayerController?
    var videoLayer: AVPlayerLayer = AVPlayerLayer()
    var videoURL: String? {
        didSet {
            if let videoURL = videoURL {
                ASVideoPlayerController.sharedVideoPlayer.setupVideoFor(url: videoURL)
            }
            videoLayer.isHidden = videoURL == nil
        }
    }
    //MARK:- UIImageView Outlets
    @IBOutlet weak var table1Img:UIImageView!
    @IBOutlet weak var bannerImg:UIImageView!
   // @IBOutlet weak var videoView:UIView!
    @IBOutlet weak var heightCollection:NSLayoutConstraint!
    @IBOutlet weak var scrollView:UIScrollView!
    @IBOutlet weak var collection5Hieght:NSLayoutConstraint!
    @IBOutlet weak var videoView: VideoView!
    let apis = APIManager()
    
    var appBanners = [AppBanner]()
    
    deinit {
        self.player.pause()
    }
    var rates = [LiveRate]()
    var trendingProduct = [Product]()
    let bannerimgs = [UIImage(named: "1"),UIImage(named: "2"),UIImage(named: "3"),UIImage(named: "4")]
    let partnerShipLbl = [UIImage(named: "p1"),UIImage(named: "p2"),UIImage(named: "p3")]
   // let partnerShipLbll = ["Logistic Partner","Banking Partner","Event Partner"]
    var app_banners = [[String:AnyObject]]()
    var exclusive_banner = [[String:AnyObject]]()
    var sub_categories = [[String:AnyObject]]()
    var manufacturer = [[String:AnyObject]]()
    var manufacturerRandom = [[String:AnyObject]]()
    var trending_product = [[String:AnyObject]]()
    var events = [Event]()
    var imgurl = ""
    var sendid = 0
    var productimgurl = ""
    var videos = [""]
   
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
        self.collection4.tag = 4
        self.collection5.tag = 5
        self.collection6.tag = 6
        
       // self.tablee1.tag = 1
        self.tablee2.tag = 2
        tapViewGesture.delegate = self
        tapViewGesture.cancelsTouchesInView = false
        self.scrollView.addGestureRecognizer(tapViewGesture)
        self.scrollView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getCurrentProfile()
     //   self.loadAnimation()
      //  let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(gesture:)))
    //    view.addGestureRecognizer(tapGesture)
//        if UIDevice.current.userInterfaceIdiom == .pad {
//            self.collection5Hieght.constant = 190
//        }
        self.documentVerified.isHidden = true
        
        self.bannerImg.image = nil
            
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
       
        self.getallRate()
        self.getAllData()
        
       // self.tablee2.invalidateIntrinsicContentSize()
        self.collection5.reloadData()
        self.collection7.reloadData()
        
    
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
       
        
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
        
            
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "subsub" {
            let dvc = segue.destination as! subSubVC
            dvc.id = self.sendid
        } else if segue.identifier == "subcata" {
            let dvc = segue.destination as! subCategoryVC
            dvc.id = self.sendid
        } else if segue.identifier == "trend" {
            let dvc = segue.destination as! productDetailsVC
            dvc.id = self.sendid
        } else if segue.identifier == "cata" {
            let dvc = segue.destination as! catagoryVC
            dvc.id = self.sendid
        } else if segue.identifier == "event" {
            let dvc = segue.destination as! eventDetailsVC
            dvc.currentEvent = self.selectedEvent
        }
    }
    
    func getCurrentProfile() {
        apis.getCurrentProfile(vc: self) { (pro,kyc,url)  in
            let lbl1 = UILabel(frame: CGRect(x: self.bannerImg.frame.origin.x + 4, y: self.bannerImg.frame.origin.y + 4, width: self.view.frame.width - 8, height: self.bannerImg.frame.height))
            lbl1.textAlignment = .center
            lbl1.font = .boldSystemFont(ofSize: 18)
            lbl1.text = "Welcome \(pro.name!)"
            lbl1.backgroundColor = .white
            lbl1.cornerRadius(radius: 4)
            self.currentProfile = pro
            self.kyc = kyc
            self.scrollView.addSubview(lbl1)
        }
    }
    //MARK:- GetAll Data
    func getAllData() {
        let authorization:HTTPHeaders =  ["Authorization":Token.getLatestToken()]
        
        AF.request(NewAPI.dashboard,method: .get,parameters: nil,encoding: JSONEncoding.default,headers: authorization).responseJSON { (responseData) in
            
            APIManager.shareInstance.printEveryThing(responseData: responseData, statusCode: responseData.response?.statusCode ?? 000, url: NewAPI.dashboard, para: "para")
            if responseData.value != nil {
                print(responseData.value)
                let respData = responseData.value as! [String:Any]
                let respData1 = respData["body"] as! [[String:Any]]
                
                //App Banners
                let appBanners = respData1[0]["app_banners"] as! [[String:Any]]
                let app_resData = JSON(appBanners)
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
                    
                    let tempurlImg = MainURL.mainurl + "img/banner/" + image
                    
                    if place == "App" {
                        self.appBanners.append(AppBanner.init(id: id, bannerFor: banner_for, stateCode: state_code, cityCode: city_code, userID: user_id, title: title, type: type, place: place, startDate: start_date, endDate: end_date, categoryID: category_id, subcategoryID: subcategory_id, subsubcategoryID: subsubcategory_id, image: tempurlImg.replacingOccurrences(of: " ", with: "%20"), status: status, createdAt: created_at, updatedAt: updated_at))
                    }
                    
                }
                print(self.appBanners.count)
                self.collection1.reloadData()
                self.collection1Act.isHidden = true
                
                
                //Exclusive banners
                let exclusiveBanner = respData1[5]["exclusive_banners"] as! [[String:Any]]
                let exclusuve_resData = JSON(exclusiveBanner)
                if let resData2 = exclusuve_resData.arrayObject {
                    self.exclusive_banner = resData2 as! [[String:AnyObject]]
                }
                self.tablee2.reloadData()
                self.table2Height.constant = CGFloat(self.exclusive_banner.count * 300)
               
                let manufacturer = respData1[2]["manufacture"] as! [[String:Any]]
                let manufacturer_resData = JSON(manufacturer)
                if let resDataManu = manufacturer_resData.arrayObject {
                    self.manufacturer = resDataManu as! [[String:AnyObject]]
                }
                self.manufacturerRandom = self.manufacturer.shuffled()
                self.collection8.reloadData()
                self.collection8Act.isHidden = true
                
                
                //Sub Categories
                let sub_cata = respData1[1]["categories"] as! [[String:Any]]
                let sub_cata_resData = JSON(sub_cata)
                if let resData3 = sub_cata_resData.arrayObject {
                    self.sub_categories = resData3 as! [[String:AnyObject]]
                }
                self.collection2.reloadData()
                print(self.sub_categories)
                self.collection2Act.isHidden = true
                
                //Gallery
                let gallery = respData1[4]["gallery"] as! [[String:Any]]
                self.allGallery.removeAll()
                for i in gallery {
                    let id = i["id"] as? Int ?? 0
                    let title = i["title"] as? String ?? "No Address"
                    let file_type = i["file_type"] as? String ?? "No Date"
                    let file_name = i["file_name"] as? String ?? "No time"
                    let thumbnail = i["thumbnail"] as? String ?? "No image"
                    let status = i["status"] as? String ?? "No Description"
                    
                    self.allGallery.append(Gallery.init(id: id, title: title, fileType: file_type, fileName: (MainURL.mainurl + "img/gallery/" + file_name).replacingOccurrences(of: " ", with: "%20"), thumbnail: thumbnail, status: status, createdAt: "", updatedAt: ""))
                }
                self.collection5.reloadData()
                
                //Events
                let allEvents = respData1[7]["events"] as! [[String:Any]]
                self.events.removeAll()
                for i in allEvents {
                    let eventName = i["title"] as? String ?? "No Name"
                    let address = i["address"] as? String ?? "No Address"
                    let date = i["date"] as? String ?? "No Date"
                    let time = i["eventtime"] as? String ?? "No time"
                    let img = i["image"] as? String ?? "No image"
                    let descr = i["description"] as? String ?? "No Description"
                    let status = i["status"] as? String
                    let event_type = i["event_type"] as? String
                    let e1 = Event(eventName: eventName, address: address, date: date, time: time, img: img, descr: descr, status: Int(status!)!,event_type:event_type!)
                    if Int(status!)! == 1 {
                        self.events.append(e1)
                    }
                }
                self.collection4.reloadData()
                if self.events.count == 0 {
                    self.eventView.visiblity(gone: true)
                }
                
                //MARK:- Video
                let video = respData1[3]["video"] as! [[String:Any]]
                let filename = video[0]["file_name"] as? String ?? ""
                self.videos[0] = (MainURL.mainurl + "img/gallery/" + filename).replacingOccurrences(of: " ", with: "%20")
                self.videoView.configure(url: self.videos[0])
                self.videoView.isLoop = true
                self.playVideo(videourl: self.videos[0])
                
                
                //Trending Product
                let trending_product = respData1[6]["product"] as! [[String:Any]]
                let trending_product_resData = JSON(trending_product)
                if let resData4 = trending_product_resData.arrayObject {
                    self.trending_product = resData4 as! [[String:AnyObject]]
                }
                
                if let productData = respData1[6]["product"] as? [[String:AnyObject]] {
                    var allProduct = [Product]()
                    
                    for i in productData {
                        
                        var goldd = [Gold]()
                        var diamondd = [Diamond]()
                        var stonee = [Stone]()
                        var platinumm = [Platinum]()
                        var silverr = [Silver]()
                        
                        let pid = i["product_id"] as! Int
                        let pname = i["product_name"] as! String
                        let size = i["size"] as? String
                        _ = i["default_size"] as? String ?? ""
                        _ = i["size_type"] as? String ?? ""
                        let img = i["image"] as? String ?? ""
                        
                        if let gold = i["gold"] as? [String:Any] {
                            let goldweight = gold["goldweight"] as? String ?? ""
                            let goldquality = gold["goldquality"] as? String ?? ""
                            let makingcharge = gold["makingcharge"] as? String ?? ""
                            let option = gold["option"] as? String ?? ""
                            
                            let tempGold = Gold.init(goldweight: goldweight , goldquality: goldquality, makingcharge: makingcharge, option: option)
                            goldd.append(tempGold)
                        }
                        
                        if let diamong = i["diamond"] as? [String:Any] {
                            let diamond = diamong["diamond"] as? String ?? ""
                            let diamondqty = diamong["diamondqty"] as? String ?? ""
                            let default_size = diamong["default_size"] as? String ?? ""
                            let type = diamong["type"] as? String ?? ""
                            let diamondcharge = diamong["diamondcharge"] as? String ?? ""
                            
                            let tempdiamond = Diamond.init(diamond: diamond, diamondqty: diamondqty, no_diamond: "", default_size: default_size, diamondcolor: "", diamondclarity: "", type: type, diamondcharge: diamondcharge)
                            diamondd.append(tempdiamond)
                        }
                        
                        if let stone = i["stone"] as? [[String:Any]] {
                            let stone_id = stone[0]["stone_id"] as! Int
                            let id = stone[0]["id"] as! Int
                            let product_id = stone[0]["product_id"] as! String
                            let stonetype = stone[0]["stonetype"] as! String
                            let stoneqty = stone[0]["stoneqty"] as! String
                            let stoneno = stone[0]["stoneno"] as! String
                            let type = stone[0]["type"] as! String
                            let stonecharges = stone[0]["stonecharges"] as! String
                            let created_at = stone[0]["created_at"] as! String
                            let updated_at = stone[0]["updated_at"] as! String
                            
                            let tempRes = Stone.init(stoneID: stone_id, id: id, productID: product_id, stonetype: stonetype, stoneqty: stoneqty, stoneno: stoneno, type: type, stonecharges: stonecharges, createdAt: created_at, updatedAt: updated_at)
                            
                            stonee.append(tempRes)
                            
                        }
                        
                        if let platinum = i["productpaltinum"] as? [String:Any] {
                           let id = platinum["id"] as! Int
                            let product_id = platinum["product_id"] as! String
                            let platinum_type = platinum["platinum_type"] as! String
                            let platinum_qty = platinum["platinum_qty"] as! String
                            let wastage = platinum["wastage"] as! String
                            let purity = platinum["purity"] as! String
                            let charge_type = platinum["charge_type"] as! String
                            let platinum_charge = platinum["platinum_charge"] as! String
                           
                                
                            let tempsRes = Platinum.init(id: id, productID: product_id, platinumType: platinum_type, platinumQty: platinum_qty, wastage: wastage, purity: purity, chargeType: charge_type, platinumCharge: platinum_charge)
                            platinumm.append(tempsRes)
                        }
                        
                        if let silver = i["productsilver"] as? [String:Any] {
                            let id = silver["id"] as! Int
                            let product_id = silver["product_id"] as! String
                            let silver_type = silver["silver_type"] as! String
                            let silverqty = silver["silverqty"] as! String
                            let silverno = silver["silverno"] as! String
                            let charge_type = silver["charge_type"] as! String
                            let silvercharges = silver["silvercharges"] as! String
                            
                           
                            let tempRes = Silver.init(id: id, productID: product_id, silverType: silver_type, silverqty: silverqty, silverno: silverno, chargeType: charge_type, silvercharges: silvercharges)
                            
                            silverr.append(tempRes)
                        }
                        
                        let proWeight = i["weight"] as! [String:Any]
                        let proQuality = i["quality"] as! [String:Any]
                        let product_category = i["product_category"] as? String ?? ""
                        
                        let tempPro = Product.init(imgs: img, name: pname, price: "", discountPrice: "", size: size ?? "", gold: goldd, diamond: diamondd, platinum: platinumm, stone: stonee, details: "", id: pid, silver: silverr,weight: "",quality: "", proWeight: proWeight, proQuality: proQuality, product_category: product_category)
                        
                        allProduct.append(tempPro)
                    }
                    self.trendingProduct = allProduct
                    
                    self.collection3.reloadData()
                }
                
                
                self.productimgurl = respData["product_url"] as? String ?? ""
                self.collection3.reloadData()
                
                //MARK:- Partner
                let partner = respData1[9]["partner"] as! [[String:Any]]
                for i in partner {
                    let id = i["id"] as? Int ?? 0
                    let title = i["title"] as? String ?? ""
                    let image = i["image"] as? String ?? ""
                    let status = i["status"] as? String ?? ""
                    let created_at = i["created_at"] as? String ?? ""
                    let updated_at = i["updated_at"] as? String ?? ""
                    
                    let tempurlImg = (MainURL.mainurl + "img/partner/" + image).replacingOccurrences(of: " ", with: "%20")
                    
                    self.partners.append(Partner.init(id: id, title: title, image: tempurlImg, status: status, createdAt: created_at, updatedAt: updated_at))
                }
                self.collection7.reloadData()
                if self.partners.count == 0 {
                    self.partnerView.visiblity(gone: true)
                    self.eventView.visiblity(gone: true)
                }
                self.tablee2.backgroundColor = .black
                //self.tablee2.invalidateIntrinsicContentSize()
                self.startTimer()
                self.startTimer2()
                self.startTimer3()
                self.startTimer4()
                self.setupScroll()
                
            }
        }
    }
    func playVideo(videourl:String) {
        self.player = AVPlayer(url: URL(string: videourl)!)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.videoView.bounds
    }

    func setupScroll() {
        
        
        let preTotal = self.collection5.frame.height + self.videoView.frame.height + self.table2Height.constant + self.collection3.frame.height
        let total1 = self.collection1.frame.height + self.collection2.frame.height + self.collection6.frame.height + self.collection8.frame.height + preTotal
        
        var eventView = CGFloat(0.0)
        var partnerView = CGFloat(0.0)
        if self.events.count != 0 {
            eventView = self.eventView.frame.height
        }
        if self.partners.count != 0 {
            partnerView = self.partnerView.frame.height
        }
        
        self.scrollView.layoutIfNeeded()
        self.scrollView.contentSize.height = total1 + eventView + partnerView
        
    }
    @objc func trendProduct(_ sender:UIButton) {
        if self.kyc.documentVerified == "0" {
            self.documentVerified.isHidden = false
        } else {
            self.sendid = self.trending_product[sender.tag]["id"] as! Int
            
            self.performSegue(withIdentifier: "trend", sender: self)
        }
    }
    @IBAction func closeBtn(_ sender:UIButton) {
        self.documentVerified.isHidden = true
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
    
    
    //MARK:- Get All Live Rates
    func getallRate() {
       // self.widthCollection.constant = self.view.frame.width
        APIManager.shareInstance.getliverates(vc: self) { (ratees) in
            if ratees.count > 0 {
                self.rates.removeAll()
                self.rates = ratees
            }
            self.collection6.reloadData()
          //  sleep(4)
            let dispatchQueue = DispatchQueue(label: "QueueIdentification", qos: .background)
            dispatchQueue.async{
                self.getallRate()
            }
         //
        }
    }
    
    //MARK:- IBActions
    @IBAction func phoneBtn(_ sender:UIButton) {
        let url: NSURL = URL(string: "TEL://18004199612")! as NSURL
        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
    }
    
    //MARK:- CollectionView Scroll to Next
    @objc func scrollToNextCell() {

        if self.appBanners.count > 0 {
            if self.ind.row >= self.appBanners.count - 1 {
                print("collection")
                print("inside bloack")
                print("Index Path:- \(self.ind)")
                self.ind.row = 0
                let ind2 = self.ind.row
                self.ind.row = ind2
                let finalindd = IndexPath(row: ind2, section: 0)
                self.collection1.scrollToItem(at: finalindd, at: .right, animated: true)
            } else {
                print("collection")
                print("outside bloack")
                print("Index Path:- \(self.ind)")
                let ind2 = self.ind.row + 1
                self.ind.row = ind2
                let finalindd = IndexPath(row: ind2, section: 0)
                self.collection1.scrollToItem(at: finalindd, at: .right, animated: true)
            }
        }
    }
    @objc func scrollToNextCell2() {

       
        if self.inddd.row >= self.allGallery.count - 1 {
            print("collection 2")
            print("Index Path:- \(self.inddd)")
            self.inddd.row = 0
            let ind2 = self.inddd.row
            let finalindd = IndexPath(row: ind2, section: 0)
            self.collection5.scrollToItem(at: finalindd, at: .left, animated: true)
        } else {
            print("collection 2")
            print("Index Path:- \(self.inddd)")
            let ind2 = self.inddd.row + 1
            self.inddd.row = ind2
            let finalindd = IndexPath(row: ind2, section: 0)
            self.collection5.scrollToItem(at: finalindd, at: .right, animated: true)
        }
      
    
    }
    @objc func scrollToNextCell3() {
        if self.indd.row >= self.partners.count - 1 {
            print("Index Path:- \(self.indd)")
            print("collection 3")
            self.indd.row = 0
            let ind2 = self.indd.row 
            let finalindd = IndexPath.init(row: ind2, section: 0)
            if self.partners.count > 0 {
                self.collection7.scrollToItem(at: finalindd, at: .right, animated: true)
            }
        } else {
            print("collection 3")
            print("Index Path:- \(self.indd)")
            let ind2 = self.indd.row + 1
            self.indd.row = ind2
            let finalindd = IndexPath(row: ind2, section: 0)
            if self.partners.count > 0 {
                self.collection7.scrollToItem(at: finalindd, at: .right, animated: true)
            }
        }
        
        
    }
    @objc func scrollToNextCell4() {
        if self.indddd.row >= self.rates.count - 1 {
            print("Index Path:- \(self.indddd)")
            print("collection 4")
            self.indddd.row = 0
            let ind2 = self.indddd.row
            let finalindd = IndexPath.init(row: ind2, section: 0)
            self.collection6.scrollToItem(at: finalindd, at: .right, animated: true)
        } else {
            print("Index Path:- \(self.indddd)")
            print("collection 4")
            let ind2 = self.indddd.row + 1
            self.indddd.row = ind2
            let finalindd = IndexPath(row: ind2, section: 0)
            self.collection6.scrollToItem(at: finalindd, at: .right, animated: true)
        }
        
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
            return self.trendingProduct.count
        } else if collectionView == self.collection4 {
            return self.events.count
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
        self.viewWillLayoutSubviews()
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collection1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! exclusive_bannerCell
            if self.appBanners.count > 0 {
                cell.img.cornerRadius(radius: 8)
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
            cell.lbl1.text = self.sub_categories[indexPath.row]["category"] as? String
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                cell.viewShadow.addShadowWithCorner(corner: 6)
            }
            cell.view1.layer.cornerRadius = 6
            cell.view1.clipsToBounds = true
            let img = self.sub_categories[indexPath.row]["image"] as? String
            let finalurl = MainURL.mainurl + "img/category/\(img ?? "no image")"
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
              let ind = self.trendingProduct[indexPath.row]
              let urll = "\(MainURL.mainurl)img/product/"
              let imgurl = ind.imgs!
              let finalurl = urll + imgurl
              
              
              cell.diamondLbl.text = ""
            cell.view1.cornerRadius(radius: 10)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                //cell.shadowView.dropShadow(color: .black, opacity: 0.2, offSet: CGSize.init(width: -3, height: 1), radius: 2, scale: true)
            }
           
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
              if ind.product_category == "GOLD" {
                  let gq = ind.proQuality["Gold"] as! String
                  let gw = ind.proWeight["Gold"] as! String
                  cell.originalPriceLbl.text = gw + "g" + "/" + gq
              } else if ind.product_category == "DIAMOND" {
                  let dq = ind.proQuality["Diamond"] as? String ?? ""
                  let dct = ind.proWeight["Diamond"] as? String ?? ""
                  cell.diamondLbl.text = dq
                  cell.ctLbl.text = dct + "CT"
                  if let gw = ind.proWeight["Gold"] as? String {
                      let gq = ind.proQuality["Gold"] as! String
                      cell.originalPriceLbl.text = gw + "g" + "/" + gq
                  } else if let pw = ind.proWeight["Platinum"] as? String {
                      let pq = ind.proQuality["Gold"] as! String
                      cell.originalPriceLbl.text = pw + "g" + "/" + pq
                  } else if let sw = ind.proWeight["Silver"] as? String {
                      let sq = ind.proQuality["Gold"] as! String
                      cell.originalPriceLbl.text = sw + "g" + "/" + sq
                  }
              } else if ind.product_category == "PLATINUM" {
                  let gq = ind.proQuality["Platinum"] as! String
                  let gw = ind.proWeight["Platinum"] as! String
                  cell.originalPriceLbl.text = gw + "g" + "/" + gq
              }
            //  cell.originalPriceLbl.text = ind.weight + "g" + "/" + ind.quality

              return cell
        } else if collectionView == self.collection4 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! eventsCellCollection
            let event = self.events[indexPath.row]
            let imgurl = event.img!
            var finalURl = MainURL.mainurl + "/img/events/" + imgurl
            if finalURl.contains(" ") {
                finalURl = finalURl.replacingOccurrences(of: " ", with: "%20")
            }
            cell.viewCorner.layer.cornerRadius = 5
            cell.viewCorner.clipsToBounds = true 
           // cell.registerBtn.tag = indexPath.row
          //  cell.registerBtn.addTarget(self, action: #selector(eventTapped(_:)), for: .touchUpInside)
            cell.img.kf.indicatorType = .activity
            cell.img.kf.setImage(with: URL(string: finalURl),placeholder: nil,options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
                switch result {
                case .success(let value):
                    print("Task done for: \(value.source.url?.absoluteString ?? "")")
                    
                case .failure(let error):
                    print("Job failed: \(error.localizedDescription)")
                    
                }
            }
            cell.eventName.text = event.eventName
            return cell
        } else if collectionView == self.collection6 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! liveRateCard
            if self.rates.count > 0 {
                let itemToShow = self.rates[indexPath.row % self.rates.count]
                let newask = itemToShow.ask.floatValue
                let newbid = itemToShow.bid.floatValue
                let newlow = itemToShow.high.floatValue
                let newhigh = itemToShow.low.floatValue
                
                if self.oldask == nil {
                    self.oldask = itemToShow.ask.floatValue
                    self.oldbid = itemToShow.bid.floatValue
                    self.oldhigh = itemToShow.high.floatValue
                    self.oldlow = itemToShow.low.floatValue
                } else {
                    if self.oldask > newask {
                      //  cell.askLbl.backgroundColor = .red
                        self.oldask = itemToShow.ask.floatValue
                    } else {
                       // cell.askLbl.backgroundColor = .green
                        self.oldask = itemToShow.ask.floatValue
                    }
                    
                    if self.oldbid > newbid {
                       // cell.bidLbl.backgroundColor = .red
                        self.oldbid = itemToShow.bid.floatValue
                    } else {
                      //  cell.bidLbl.backgroundColor = .green
                        self.oldbid = itemToShow.bid.floatValue
                    }
                    
                    if self.oldhigh > newhigh {
                      //  cell.highLbl.backgroundColor = .red
                        self.oldhigh = itemToShow.high.floatValue
                    } else {
                      //  cell.highLbl.backgroundColor = .green
                        self.oldhigh = itemToShow.high.floatValue
                    }
                    if self.oldlow > newlow {
                      //  cell.lowLbl.backgroundColor = .red
                        self.oldlow = itemToShow.low.floatValue
                    } else {
                       // cell.lowLbl.backgroundColor = .green
                        self.oldlow = itemToShow.low.floatValue
                    }
                }
                cell.symbolLbl.text = itemToShow.symbol
                cell.askLbl.text = "\(newask)"
                cell.bidLbl.text = "\(newbid)"
                cell.highLbl.text = "\(newlow)"
                cell.lowLbl.text = "\(newhigh)"
            }
            
         //   cell.bidLbl.backgroundColor = UIColor.systemRed
        //    cell.askLbl.backgroundColor = UIColor.systemGreen
            
        //    cell.lowLbl.backgroundColor = UIColor.systemBlue
       //     cell.highLbl.backgroundColor = UIColor.systemBlue
    
            cell.bidLbl.layer.borderColor = UIColor.lightGray.cgColor
            cell.bidLbl.layer.borderWidth = 0.7
            
            cell.askLbl.layer.borderColor = UIColor.lightGray.cgColor
            cell.askLbl.layer.borderWidth = 0.7
            
            cell.lowLbl.layer.borderColor = UIColor.lightGray.cgColor
            cell.lowLbl.layer.borderWidth = 0.7
            
            cell.highLbl.layer.borderColor = UIColor.lightGray.cgColor
            cell.highLbl.layer.borderWidth = 0.7
            
            cell.bidLbl1.layer.borderColor = UIColor.lightGray.cgColor
            cell.bidLbl1.layer.borderWidth = 0.7
            
            cell.askLbl1.layer.borderColor = UIColor.lightGray.cgColor
            cell.askLbl1.layer.borderWidth = 0.7
            
            cell.lowLbl1.layer.borderColor = UIColor.lightGray.cgColor
            cell.lowLbl1.layer.borderWidth = 0.7
            
            cell.highLbl1.layer.borderColor = UIColor.lightGray.cgColor
            cell.highLbl1.layer.borderWidth = 0.7
            
            
            
          //  cell.symbolLbl.layer.borderColor = UIColor.black.cgColor
            //            cell.askLbl.layer.borderColor = UIColor.black.cgColor
            //            cell.bidLbl.layer.borderColor = UIColor.black.cgColor
            //            cell.highLbl.layer.borderColor = UIColor.black.cgColor
            //            cell.lowLbl.layer.borderColor = UIColor.black.cgColor
                        
         //   cell.symbolLbl.layer.borderWidth = 1
            //            cell.askLbl.layer.borderWidth = 1
            //            cell.bidLbl.layer.borderWidth = 1
            //            cell.highLbl.layer.borderWidth = 1
            //            cell.lowLbl.layer.borderWidth = 1
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
        } else if collectionView == self.collection7 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! patnershipCell
          //  let itemToShow = self.partnerShipLbl[indexPath.row % self.partnerShipLbl.count]
           // let itemToShoww = self.partnerShipLbll[indexPath.row % self.partnerShipLbll.count]
           // cell.img.image = itemToShow!
            cell.lbl1.text = ""
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
            
        } else if collectionView == self.collection8 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! subcategoryCell
            
            cell.lbl1.numberOfLines = 0
            cell.lbl1.text = self.manufacturerRandom[indexPath.row]["name"] as? String
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                cell.viewShadow.addShadowWithCorner(corner: 6)
            }
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
            return CGSize(width: self.collection1.frame.width, height: self.collection1.frame.height )
        } else if collectionView == self.collection2 {
            if UIDevice.current.userInterfaceIdiom == .pad {
                return CGSize(width: self.collection2.frame.width / 7, height: self.collection2.frame.height)
            }
            return CGSize(width: self.collection2.frame.width / 5, height: self.collection2.frame.height - 5)
        } else if collectionView == self.collection3 {
            if UIDevice.current.userInterfaceIdiom == .pad {
                return CGSize(width: self.collection3.frame.width / 5, height: self.collection3.frame.height)
            }
            return CGSize(width: self.collection3.frame.width / 3, height: self.collection3.frame.height)
        } else if collectionView == self.collection4 {
            return CGSize(width: self.collection4.frame.width / 3, height: self.collection4.frame.height - 2)
        } else if collectionView == self.collection6 {
            if UIDevice.current.userInterfaceIdiom == .pad {
                return CGSize(width: self.collection6.frame.width / 2, height: self.collection6.frame.height)
            }
            return CGSize(width: self.collection6.frame.width, height: self.collection6.frame.height)
        } else if collectionView == self.collection5 {
            if UIDevice.current.userInterfaceIdiom == .pad {
                 return CGSize(width: self.view.frame.width / 4, height: self.collection5.frame.height)
            }
            return CGSize(width: self.view.frame.width / 2, height: self.collection5.frame.height)
        } else if collectionView == self.collection7 {
            if UIDevice.current.userInterfaceIdiom == .pad {
                return CGSize(width: self.view.frame.width / 3, height: self.collection7.frame.height - 25)
            }
            return CGSize(width: self.view.frame.width - 30, height: self.collection7.frame.height - 25)
        } else if collectionView == self.collection8 {
            if UIDevice.current.userInterfaceIdiom == .pad {
                return CGSize(width: self.collection2.frame.width / 7, height: self.collection2.frame.height)
            }
            return CGSize(width: self.collection2.frame.width / 3, height: self.collection2.frame.height - 5)
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
            self.performSegue(withIdentifier: "cata", sender: self)
        } else if collectionView == self.collection3 {
            if self.kyc.documentVerified == "0" {
                self.documentVerified.isHidden = false
            } else {
                let id = self.trending_product[indexPath.row]["product_id"] as! Int
                self.sendid = id
                self.performSegue(withIdentifier: "trend", sender: self)
            }
            
        } else if collectionView == self.collection2 {
            let cate = self.sub_categories[indexPath.row]["category"] as! String
            if cate == "MACHINERY" {
                self.performSegue(withIdentifier: "machine", sender: self)
            } else {
                let id = self.sub_categories[indexPath.row]["id"] as! Int
                self.sendid = id
                self.performSegue(withIdentifier: "subcata", sender: self)
            }
            
            
        } else if collectionView == self.collection6 {
            self.tabBarController?.selectedIndex = 2
        } else if collectionView == self.collection8 {
            self.sendid = self.manufacturer[indexPath.item]["manufacture_id"] as! Int
            
            self.performSegue(withIdentifier: "cata", sender: self)
        } else if collectionView == self.collection4 {
            self.selectedEvent = self.events[indexPath.item]
            self.performSegue(withIdentifier: "event", sender: self)
        }
    }
    
    //MARK:- UITableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if tableView == self.tablee1 {
//            return self.categories.count
//        } else {
        if tableView == self.tablee2 {
            return self.exclusive_banner.count
        } else {
            return 1
        }
            
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            cell.img.dropShadow(color: .black, opacity: 1, offSet: .zero, radius: 5, scale: true)
        }
        
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
        cell.view1.cornerRadius(radius: 5)
        cell.titleLbl.text = self.exclusive_banner[indexPath.row]["title"] as? String
        cell.subtitlLbl.text = self.exclusive_banner[indexPath.row]["description"] as? String
        
        return cell
      //  }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if tableView == self.tablee1 {
//            return self.tablee1.frame.height / 5
//        } else {
        if tableView == self.tablee3 {
            return self.videoView.frame.height
        }
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 600
        } else {
            return 300
        }
    //    }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tablee2 {
            let id = Int((self.exclusive_banner[indexPath.row]["sub_catagory"] as? String)!)
            self.sendid = id!
            print(self.sendid)
            self.performSegue(withIdentifier: "subsub", sender: self)
        }
//        } else if tableView == self.tablee1 {
//            let id = indexPath.row + 1
//            self.sendid = id
//            self.performSegue(withIdentifier: "subcata", sender: self)
//        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
         if scrollView.bounds.contains(self.videoView.frame) {
                     if self.videoView.player!.isPlaying {
                         
                     } else {
                         self.videoView.play()
                     }
                     
                 } else {
                     if self.videoView.player!.isPlaying {
                         self.videoView.pause()
                     } else {
                         self.videoView.pause()
                     }
                   //  self.player.pause()
         //            let cell = self.tablee3.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! ShotTableViewCell
         //            if let videoCell = cell as? ASAutoPlayVideoLayerContainer, let _ = videoCell.videoURL {
         //                ASVideoPlayerController.sharedVideoPlayer.removeLayerFor(cell: videoCell)
         //            }
                 }
    }
       
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
           if scrollView.bounds.contains(self.videoView.frame) {
                       if self.videoView.player!.isPlaying {
                           
                       } else {
                           self.videoView.play()
                       }
                       
                   } else {
                       if self.videoView.player!.isPlaying {
                           self.videoView.pause()
                       } else {
                           self.videoView.pause()
                       }
                     //  self.player.pause()
           //            let cell = self.tablee3.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! ShotTableViewCell
           //            if let videoCell = cell as? ASAutoPlayVideoLayerContainer, let _ = videoCell.videoURL {
           //                ASVideoPlayerController.sharedVideoPlayer.removeLayerFor(cell: videoCell)
           //            }
                   }
        }
    }
       
//    func pausePlayeVideos(){
//        ASVideoPlayerController.sharedVideoPlayer.pausePlayeVideosFor(tableView: self.tablee3)
//    }
       
    @objc func appEnteredFromBackground() {
        ASVideoPlayerController.sharedVideoPlayer.pausePlayeVideosFor(tableView: self.tablee3, appEnteredFromBackground: true)
    }
}
extension dashboardVC {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}
