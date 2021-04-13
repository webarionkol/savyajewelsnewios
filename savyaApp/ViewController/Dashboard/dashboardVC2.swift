//
//  dashboardVC2.swift
//  savyaApp
//
//  Created by Yash on 7/16/20.
//  Copyright © 2020 Yash Rathod. All rights reserved.
//

import UIKit
import SwiftVideoBackground
import CoreMedia
import SwiftGifOrigin
import Kingfisher
import GameplayKit

class dashboardVC2: RootBaseVC {
    
    //MARK:- IBOutlets View
    @IBOutlet weak var liverate_table:UITableView!
    @IBOutlet weak var scrollView:UIScrollView!
    @IBOutlet weak var nameLbl:UILabel!
    @IBOutlet weak var documentVerified:UIView!
    @IBOutlet weak var product_view:UIView!
    @IBOutlet weak var event_view:UIView!
    @IBOutlet weak var partner_view:UIView!
    @IBOutlet weak var tableHeight:NSLayoutConstraint!
    @IBOutlet weak var liveRateTblHeight:NSLayoutConstraint!
    @IBOutlet weak var playButton:UIButton!
    var isfromKyc = false
    
    //MARK:- IBOutlets Collections Main View
    @IBOutlet weak var appBanner_collection:UICollectionView!
    @IBOutlet weak var appBanner_collection2:UICollectionView!
    @IBOutlet weak var categories_collection:UICollectionView!
    @IBOutlet weak var manufacturer_collection:UICollectionView!
    @IBOutlet weak var videoView:UIView!
    @IBOutlet weak var gallery_collection:UICollectionView!
    @IBOutlet weak var exclusiveBanner_table:UITableView!
    @IBOutlet weak var product_collection:UICollectionView!
    @IBOutlet weak var event_collection:UICollectionView!
    @IBOutlet weak var partner_collection:UICollectionView!
    
    //MARK:- Array Data
    var kycBanner = [kycBanners]()
    var allAppBanner = [AppBannerDash]()
    var categories = [Categories]()
    var manufacturerr = [ManufactureDash]()
    var videoo = [Video]()
    var galleryy = [GalleryDash]()
    var exclusiveBannerr = [ExclusiveBanner]()
    var product = [ProductDash]()
    var events = [Event]()
    var review = [String]()
    var partnerr = [Partner]()
    var rates = [LiveRate]()
    var oldrates = [LiveRate]()
    var sendid = 0
    var imgView = UIImageView()
    var profile:Profile?
    var kyc:Kyc?
    var selectedEvent:Event?
    var timer = Timer()
    var displayCell:IndexPath?
    
    var appBannerInd = IndexPath(row: 0, section: 0)
    var galleryInd = IndexPath(row: 0, section: 0)
    var partnerInd = IndexPath(row: 0, section: 0)
    var ratesInd = IndexPath(row: 0, section: 0)
    
    var oldask:Float!
    var oldbid:Float!
    var oldhigh:Float!
    var oldlow:Float!
    var isVideoPlaying = false
    
    
    var iskyc = false


    //MARK:- SELLER VIEW
    @IBOutlet var machinerySellerView: UIView!
    @IBOutlet var machinerySellerScrollView: UIScrollView!
    @IBOutlet weak var machinerySellerContentView: UIView!
    @IBOutlet weak var machinerySellerContentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var machinerySellereLogo: UIImageView!
    @IBOutlet weak var machinerySellerTitle: UILabel!
    @IBOutlet weak var machinerySellerPartnershipLogo: UIImageView!
    @IBOutlet weak var machinerySellerDescription: UILabel!
    var selectedSellerId: Int = 0
    var tempfile:Files?
    
    var isfrom = "0"
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.loadAnimation()
        self.setDelegates()
        self.getCurrentProfile()
        self.getallRate()
        VideoBackground.shared.isMuted = false
        liverate_table.tableFooterView = UIView()
        
        if isKeyPresentInUserDefaults(key: "price") {
            
        }else{
            UserDefaults.standard.set("1", forKey: "price")
        }
        
        if Global.getUpdate() == "1" {
            let alertController = UIAlertController(title: "Savya Jewels Business", message: "App update available please download the new version from the app store", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Update", style: UIAlertAction.Style.default) {
                                UIAlertAction in
                UIApplication.shared.openURL(NSURL(string: "https://apps.apple.com/in/app/savya-jewels-business/id1472834371")! as URL)

            }
            let cancelAction = UIAlertAction(title: "Not now", style: UIAlertAction.Style.destructive) {
                                           UIAlertAction in
                          

                       }
            
         
            alertController.addAction(okAction)

            self.present(alertController, animated: true, completion: nil)
        }
        
      
      
    }
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getDashBoardData()
        self.scheduledTimerWithTimeInterval()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Global.getKyc() == "1" {
            Global.setKyc(kyc: "0")
            view.makeToast("KYC application submitted successfully!! Please wait for review & approval by Admin")
        }
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.exclusiveBanner_table.layoutIfNeeded()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "subsub" {
            let dvc = segue.destination as! subSubVC
            dvc.id = self.sendid
            dvc.categoryId = self.sendid
        } else if segue.identifier == "subcata" {
            let dvc = segue.destination as! subCategoryVC
            dvc.id = self.sendid
        } else if segue.identifier == "trend" {
            let dvc = segue.destination as! productDetailNewVC
            dvc.productId = self.sendid
            dvc.tempFile = self.tempfile
        } else if segue.identifier == "cata" {
            let dvc = segue.destination as! catagoryVC
            dvc.id = self.sendid
        } else if segue.identifier == "event" {
            let dvc = segue.destination as! eventDetailsVC
            dvc.currentEvent = self.selectedEvent
        }
        else if segue.identifier == "aboutus" {
            let dvc = segue.destination as! aboutUSVC
            dvc.pageToOpen = "ABOUT US"
        }
    }
    
    @IBAction func btnCall(_ sender: Any) {
        let url: NSURL = URL(string: "TEL://0120-4576629")! as NSURL
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
    }
    @IBAction func btnWhatsAPp(_ sender: Any) {
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
    
    //MARK:- Get All Data
    func getDashBoardData() {
        
        APIManager.shareInstance.dashboardData { (appbanners, categories, manufacture, video, gallery, exclusiveBanner, product, event, review, partner) in
            
            self.allAppBanner = appbanners
            self.categories = categories
            self.manufacturerr = manufacture
            self.videoo = video
            self.galleryy = gallery
            self.exclusiveBannerr = exclusiveBanner
            self.product = product
            
            self.events = event
            print(event)
            self.review = review
            self.partnerr = partner
            
            self.manufacturerr.shuffle()
            
            self.appBanner_collection.reloadData()
            self.categories_collection.reloadData()
            self.manufacturer_collection.reloadData()
            self.gallery_collection.reloadData()
            self.exclusiveBanner_table.reloadData()
            self.event_collection.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                if UIDevice.current.userInterfaceIdiom == .pad {
                    self.tableHeight.constant = CGFloat(self.exclusiveBannerr.count * 600)
                }
            }
            self.product_collection.reloadData()
            self.tableHeight.constant = CGFloat(self.exclusiveBannerr.count * 280)
            self.event_collection.reloadData()
            self.partner_collection.reloadData()
            if self.events.count == 0 {
                self.event_view.visiblity(gone: true)
            }
            if self.partnerr.count == 0 {
                self.partner_view.visiblity(gone: true)
            }
            self.appBanner_collection.decelerationRate = .normal
            self.setView()
            self.startTimer()
            self.startTimer2()
            self.startTimer3()
            self.startTimer4()
            self.removeAnimation()
            self.getKycBanners()
            
            
            
            
        }
        
        if Global.getIsfrom() == "1" {
            Global.setIsFrom(isFrom: "")
            if Global.getNotiId() == "9" {
                DispatchQueue.main.async {
                    self.tabBarController?.selectedIndex = 3
                }
            }
        }
        else if Global.getNotiId() == "23" {
            Global.setIsFrom(isFrom: "")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                let menuid = Global.getMenuid()
                for i in self.manufacturerr {
                    if menuid == "\(i.manufactureID)" {
                        self.configureMachinerySellerView(seller: i)
                        break
                    }
                }
            }
        }
                        else if Global.getNotiId() == "18" {
                            Global.setIsFrom(isFrom: "")
                            DispatchQueue.main.async {
                                self.performSegue(withIdentifier: "machine", sender: self)
                            }
                        }
                        else if Global.getNotiId() == "28" {
                            Global.setIsFrom(isFrom: "")
                            DispatchQueue.main.async {
                                self.tabBarController?.selectedIndex = 2
                            }
                        }
    }
    func getKycBanners() {
        
        APIManager.shareInstance.bannerData { (kycBannerss) in
            
            self.kycBanner = kycBannerss
            print(self.kycBanner[0].image)
            self.appBanner_collection2.reloadData()
            self.appBanner_collection2.decelerationRate = .normal
    
            self.removeAnimation()
        }
    }
    
    //MARK:- Get Current Profile
    func getCurrentProfile() {
        APIManager.shareInstance.getCurrentProfile(vc: self) { (profile, kcy, str) in
            self.nameLbl.text = "Welcome \(profile.name!)"
            let kyc = kcy.documentVerified
            if kyc == "2" {
                self.iskyc = true
            }else {
                self.iskyc = false
            }
        }
    }
    //MARK:- Get All Live Rates
    func getallRate() {
        APIManager.shareInstance.getliverates(vc: self) { (ratees) in
            if ratees.count > 0 {
                self.rates.removeAll()
                self.rates = ratees
                self.oldrates = ratees
                self.liverate_table.reloadData()
                self.liveRateTblHeight.constant = 38.0 * 6
            }
            self.removeAnimation()

        }
    }
    @IBAction func btnSearchClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "search", sender: self)
    }
    
    func setDelegates() {
        self.appBanner_collection.delegate = self
        self.appBanner_collection.dataSource = self
        
        self.categories_collection.delegate = self
        self.categories_collection.dataSource = self
        
        self.liverate_table.delegate = self
        self.liverate_table.dataSource = self
        
        self.manufacturer_collection.delegate = self
        self.manufacturer_collection.dataSource = self
        
        self.gallery_collection.delegate = self
        self.gallery_collection.dataSource = self
        
        self.product_collection.delegate = self
        self.product_collection.dataSource = self
        
        self.event_collection.delegate = self
        self.event_collection.dataSource = self
        
        self.partner_collection.delegate = self
        self.partner_collection.dataSource = self
        
        self.exclusiveBanner_table.delegate = self
        self.exclusiveBanner_table.dataSource = self
        
        self.scrollView.delegate = self
    }
    func setView() {
        let url = URL(string: self.videoo[0].fileName)!
        let preferredTimeScale : Int32 = 1
        let img = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: self.videoView.frame.width, height: self.videoView.frame.height))
        self.imgView = img
        if self.videoo[0].thumbnail.lowercased().contains("gif") {
            //https://testserver.savyajewelsbusiness.com/img/gallery/1597310352_4bbdkn.gif
            let imgURL = MainURL.mainurl+"img/gallery/"+self.videoo[0].thumbnail
            self.imgView.image = try! VideoBackground.shared.getThumbnailImage(from: url, at: CMTime.init(seconds: 1, preferredTimescale: preferredTimeScale))
            self.imgView.kf.setImage(with: URL(string: imgURL), placeholder: nil, options: nil, progressBlock: nil) { (image, error, cacheType, imageURL) in
                if let image = image {
                    self.imgView.animationImages = image.images
                    self.imgView.animationDuration = image.duration
                    self.imgView.animationRepeatCount = 0
                    self.imgView.image = image.images?.last
                    self.imgView.startAnimating()
                }
            }
        } else {
            self.imgView.image = try! VideoBackground.shared.getThumbnailImage(from: url, at: CMTime.init(seconds: 1, preferredTimescale: preferredTimeScale))
        }
        
        self.videoView.addSubview(self.imgView)
    }
    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
   //     timer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(updateCounting), userInfo: nil, repeats: true)
    }

    func startTimer() {
        _ = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(scrollToNextCellAppBanner), userInfo: self, repeats: true)
    }
    func startTimer2() {
        _ = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(scrollToNextCell2Gallery), userInfo: self, repeats: true)
    }
    func startTimer3() {
        _ = Timer.scheduledTimer(timeInterval: 7.0, target: self, selector: #selector(scrollToNextCell3Partner), userInfo: self, repeats: true)
    }
    func startTimer4() {
       // _ = Timer.scheduledTimer(timeInterval: 7.0, target: self, selector: #selector(scrollToNextCell4LiveRate), userInfo: self, repeats: true)
    }
    @objc func scrollToNextCellAppBanner() {

        if self.allAppBanner.count > 0 {
            if self.appBannerInd.row >= self.allAppBanner.count - 1 {
                self.appBannerInd.row = 0
                let ind2 = self.appBannerInd.row
                self.appBannerInd.row = ind2
                let finalindd = IndexPath(row: ind2, section: 0)
                self.appBanner_collection.scrollToItem(at: finalindd, at: .right, animated: true)
            } else {
                
                let ind2 = self.appBannerInd.row + 1
                self.appBannerInd.row = ind2
                let finalindd = IndexPath(row: ind2, section: 0)
                self.appBanner_collection.scrollToItem(at: finalindd, at: .right, animated: true)
            }
        }
    }
    @objc func scrollToNextCell2Gallery() {
        if self.galleryInd.row >= self.galleryy.count - 1 {
            self.galleryInd.row = 0
            let ind2 = self.galleryInd.row
            let finalindd = IndexPath(row: ind2, section: 0)
            self.gallery_collection.scrollToItem(at: finalindd, at: .left, animated: true)
        } else {
            let ind2 = self.galleryInd.row + 1
            self.galleryInd.row = ind2
            let finalindd = IndexPath(row: ind2, section: 0)
           // self.gallery_collection.scrollToItem(at: finalindd, at: .right, animated: true)
        }
    }
    @objc func scrollToNextCell3Partner() {
        if self.partnerInd.row >= self.partnerr.count - 1 {
            
            self.partnerInd.row = 0
            let ind2 = self.partnerInd.row
            let finalindd = IndexPath.init(row: ind2, section: 0)
            if self.partnerr.count > 0 {
                self.partner_collection.scrollToItem(at: finalindd, at: .left, animated: true)
            }
        } else {
            
            let ind2 = self.partnerInd.row + 1
            self.partnerInd.row = ind2
            let finalindd = IndexPath(row: ind2, section: 0)
            if self.partnerr.count > 0 {
                self.partner_collection.scrollToItem(at: finalindd, at: .right, animated: true)
            }
        }
        
        
    }
    @objc func scrollToNextCell4LiveRate() {
//        if self.ratesInd.row >= self.rates.count - 1 {
//            self.ratesInd.row = 0
//            let ind2 = self.ratesInd.row
//            let finalindd = IndexPath.init(row: ind2, section: 0)
//            self.liverate_table.scrollToRow(at: finalindd, at: ., animated: true)
//
//        } else {
//
//            let ind2 = self.ratesInd.row + 1
//            self.ratesInd.row = ind2
//            let finalindd = IndexPath(row: ind2, section: 0)
//            self.liverate_table.scrollToRow(at: finalindd, at: .automatic, animated: true)
//        }
        
    }
    @objc func updateCounting(){
        
        DispatchQueue.global(qos: .background).async {
        
        
        APIManager.shareInstance.getliverates(vc: self) { (ratees) in
            if ratees.count > 0 {
                self.oldrates = self.rates
                self.rates.removeAll()
                self.rates = ratees
            }
            DispatchQueue.main.async {
                self.liverate_table.reloadData()
            }
            print("live rate changing")
        }
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.timer.invalidate()
        
    }
}
extension dashboardVC2:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.appBanner_collection {
            return self.allAppBanner.count
        }else if collectionView == self.appBanner_collection2 {
            return self.kycBanner.count
        }
        else if collectionView == self.categories_collection {
            return self.categories.count
        } else if collectionView == self.manufacturer_collection {
            return self.manufacturerr.count
        } else if collectionView == self.gallery_collection {
            return self.categories.count
        } else if collectionView == self.product_collection {
            return self.product.count
        } else if collectionView == self.event_collection {
            return self.events.count
        } else {
            return self.partnerr.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //MARK:- App Banners Collection
        if collectionView == self.appBanner_collection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! exclusive_bannerCell
            if self.allAppBanner.count > 0 {
                cell.img.cornerRadius(radius: 8)
                let ind = self.allAppBanner[indexPath.item]
                cell.img.kf.indicatorType = .activity
                cell.img.kf.setImage(with: URL(string: ind.image),placeholder: nil,options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))], completionHandler:  { result in
                    switch result {
                    case .success(let value):
                        print("Task done for: \(value.source.url?.absoluteString ?? "")")
                        
                    case .failure(let error):
                        
                        print("Job failed: \(error.localizedDescription) \(ind.image)")
                        
                    }
                })
            }
            return cell
            //MARK:- Categories Collection
        }else if
            collectionView == self.appBanner_collection2 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! exclusive_bannerCell
                if self.kycBanner.count > 0 {
                    cell.img.cornerRadius(radius: 8)
                    let ind = self.kycBanner[indexPath.item]
                    cell.img.kf.indicatorType = .activity
                    cell.img.kf.setImage(with: URL(string: ind.image),placeholder: nil,options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))], completionHandler:  { result in
                        switch result {
                        case .success(let value):
                            print("Task done for: \(value.source.url?.absoluteString ?? "")")
                            
                        case .failure(let error):
                            
                            print("Job failed: \(error.localizedDescription) \(ind.image)")
                            
                        }
                    })
                }
                return cell
        }
        
        else if collectionView == self.categories_collection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! subcategoryCell
            let ind = self.categories[indexPath.row]
            cell.lbl1.text = ind.category
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                cell.viewShadow.addShadowWithCorner(corner: 6)
            }
            cell.view1.cornerRadius(radius: 8)
            cell.img.kf.indicatorType = .activity
            cell.img.kf.setImage(with: URL(string: ind.image),placeholder: nil,options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))], completionHandler:  { result in
                switch result {
                case .success(let value):
                    print("Task done for: \(value.source.url?.absoluteString ?? "")")
                    
                case .failure(let error):
                    print("Job failed: \(error.localizedDescription)  \(ind.image)")
                }
            })
            return cell
           
        } //MARK:- Manufacturer Collection
         else if collectionView == self.manufacturer_collection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! subcategoryCell
            let ind = self.manufacturerr[indexPath.row]
            cell.lbl1.text = ind.name
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                cell.viewShadow.addShadowWithCorner(corner: 6)
            }
            cell.view1.cornerRadius(radius: 6)
            cell.img.kf.indicatorType = .activity
            cell.img.kf.setImage(with: URL(string: ind.logo),placeholder: nil,options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))], completionHandler:  { result in
                switch result {
                case .success(let value):
                    print("Task done for: \(value.source.url?.absoluteString ?? "")")
                    
                case .failure(let error):
                    print("Job failed: \(error.localizedDescription)  \(ind.logo)")
                }
            })
            return cell
        } else if collectionView == self.gallery_collection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! bannerImgCell
            let ind = self.categories[indexPath.row]
            cell.img.kf.indicatorType = .activity
            cell.img.kf.setImage(with: URL(string: ind.tranding_banner),placeholder: nil,options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))], completionHandler:  { result in
                switch result {
                case .success(let value):
                    print("Task done for: \(value.source.url?.absoluteString ?? "")")
                    
                case .failure(let error):
                    print("Job failed: \(error.localizedDescription)")
                    
                }
            })
            
            return cell
        }
        else if collectionView == self.product_collection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! productCell
            let ind = self.product[indexPath.row]
            print("ProductName: \(ind.productName)")
               
               
            cell.diamondLbl.text = ind.productName
            
            cell.view1.cornerRadius(radius: 10)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                 //cell.shadowView.dropShadow(color: .black, opacity: 0.2, offSet: CGSize.init(width: -3, height: 1), radius: 2, scale: true)
            }
            
            cell.img.kf.indicatorType = .activity
            if let encodedString  = ind.image.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed), let url = URL(string: encodedString) {
                print(encodedString)
                cell.img.kf.setImage(with: URL(string: (ind.image).replacingOccurrences(of: " ", with: "%20")),placeholder: nil,options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))], completionHandler:  { result in
                    switch result {
                    case .success(let value):
                        print("Task done for: \(value.source.url?.absoluteString ?? "")")
                        
                    case .failure(let error):
                        
                        print("Job failed: \(error.localizedDescription)" + ind.image)
                        
                    }
                })
               }
            if ind.productCategory == "GOLD JEWELLERY" || ind.productCategory == "GOLD CHAINS" {
                print(ind.weight)
                //let gq = ind.proQuality["Gold"] as? String ?? ""
                let gw = ind.weight["Gold"] as? String ?? "0.0"
                let doubleStr = String(format: "%.3f", gw.toDouble())
                
                let ktw = ind.quality["Gold"]  as? String ?? ""
                
                
                cell.originalPriceLbl.text = "\(doubleStr)" + " g"
            } else if ind.productCategory == "DIAMOND JEWELLERY" {
               // let dq = ind.proQuality["Diamond"] as? String ?? ""
                let dct = ind.weight["Diamond"] as? String ?? ""
                let doubleStr = String(format: "%.3f", dct.toDouble())
                
                //cell.diamondLbl.text = ""
                cell.ctLbl.text = doubleStr + " Ct"
                
                
                
                var weight = Double()
                if let gw = ind.weight["Gold"] as? String {
                    //let gq = ind.proQuality["Gold"] as! String
                    weight = weight+Double(gw)!
                   // cell.originalPriceLbl.text = gw + " g"
                }
                if let pw = ind.weight["Platinum"] as? String {
                    weight = weight+Double(pw)!
                    //let pq = ind.proQuality["Gold"] as! String
                    cell.originalPriceLbl.text = pw + " g"
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
                cell.originalPriceLbl.text = we + " g"
                
            } else if ind.productCategory == "PLATINUM JEWELLERY" {
                
    //            let gw = ind.proWeight["Platinum"] as! String
    //            cell.originalPriceLbl.text = "\(gw)" + " g"
                
                if let dct = ind.weight["Diamond"] as? String {
                    let doubleStr = String(format: "%.3f", dct.toDouble())
                    
                    
                    cell.ctLbl.text = doubleStr + " Ct"
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
                    cell.originalPriceLbl.text = pw + " g"
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
                cell.originalPriceLbl.text = we + " g /\(quality!)"
            }
            
               return cell
        }
        else if collectionView == self.event_collection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! eventsCellCollection
            let ind = self.events[indexPath.row]
            cell.eventName.text = ind.eventName
          //  cell.eventypeLbl.text = ind.eventName
            cell.img.kf.indicatorType = .activity
            
            cell.img.kf.setImage(with: URL(string: MainURL.mainurl + "img/events/" + ind.img),placeholder: nil,options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))], completionHandler:  { result in
                switch result {
                case .success(let value):
                    print("Task done for: \(value.source.url?.absoluteString ?? "")")
                    
                case .failure(let error):
                    print("Job failed: \(error.localizedDescription)")
                    
                }
            })
            
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.appBanner_collection {
            return CGSize(width: self.appBanner_collection.frame.width, height: self.appBanner_collection.frame.height )
        }
        if collectionView == self.appBanner_collection2 {
            return CGSize(width: self.appBanner_collection2.frame.width, height: self.appBanner_collection2.frame.height )
        }
        else if collectionView == self.categories_collection {
            if UIDevice.current.userInterfaceIdiom == .pad {
                return CGSize(width: self.categories_collection.frame.width / 4, height: self.categories_collection.frame.height)
            }
            return CGSize(width: self.categories_collection.frame.width / 3.5, height: self.categories_collection.frame.height - 5)
        } else if collectionView == self.manufacturer_collection {
            if UIDevice.current.userInterfaceIdiom == .pad {
                return CGSize(width: self.categories_collection.frame.width / 7, height: self.categories_collection.frame.height)
            }
            return CGSize(width: self.categories_collection.frame.width / 3.5, height: self.categories_collection.frame.height - 5)
        } else if collectionView == self.gallery_collection {
            if UIDevice.current.userInterfaceIdiom == .pad {
                 return CGSize(width: self.view.frame.width / 4, height: self.gallery_collection.frame.height)
            }
            return CGSize(width: self.view.frame.width / 2, height: self.gallery_collection.frame.height)
        } else if collectionView == self.product_collection {
            if UIDevice.current.userInterfaceIdiom == .pad {
                return CGSize(width: self.product_collection.frame.width / 4, height: self.product_collection.frame.height)
            }
            return CGSize(width: self.product_collection.frame.width / 3, height: self.product_collection.frame.height)
        } else if collectionView == self.event_collection {
            return CGSize(width: self.event_collection.frame.width / 3, height: self.event_collection.frame.height - 2)
        } else if collectionView == self.partner_collection {
            if UIDevice.current.userInterfaceIdiom == .pad {
                return CGSize(width: self.view.frame.width / 3, height: self.partner_collection.frame.height - 25)
            }
            return CGSize(width: self.view.frame.width - 30, height: self.partner_collection.frame.height - 25)
        } else {
            return CGSize.zero
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.appBanner_collection {
            let id = self.allAppBanner[indexPath.item].userID
            self.sendid = id.toInt()
           // self.performSegue(withIdentifier: "cata", sender: self)
        }
        if collectionView == self.appBanner_collection2 {
            
            if self.iskyc == true {
                
                self.performSegue(withIdentifier: "addkyc", sender: self)
            }else {
                
                self.performSegue(withIdentifier: "kyc", sender: self)
            }
         
        }
        
        else if collectionView == self.categories_collection {
            let cate = self.categories[indexPath.row].category
            if cate == "MACHINERY" {
                self.performSegue(withIdentifier: "machine", sender: self)
            } else {
                let id = self.categories[indexPath.row].id
                self.sendid = id
                self.performSegue(withIdentifier: "subcata", sender: self)
            }
        }
        else if collectionView == self.gallery_collection {
            let cate = self.categories[indexPath.row].category
            if cate == "MACHINERY" {
              //  self.performSegue(withIdentifier: "machine", sender: self)
            } else {
                let id = self.categories[indexPath.row].id
                self.sendid = id
                self.performSegue(withIdentifier: "subcata", sender: self)
            }
        }
        
        else if collectionView == self.manufacturer_collection {
            self.configureMachinerySellerView(seller: self.manufacturerr[indexPath.item])
        } else if collectionView == self.product_collection {
//            if self.kyc!.documentVerified == "0" {
//                self.documentVerified.isHidden = false
//            } else {
                let id = self.product[indexPath.row].productID
                self.sendid = id
            
            
            let urll = "\(MainURL.mainurl)img/product/"
            let imgurl = self.product[indexPath.row].image
            let finalurl = imgurl
            
            self.tempfile = Files.init(id: self.product[indexPath.row].productID, productID: self.product[indexPath.row].productID.toString(), image: finalurl.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!, type: 1, createdAt: "", updatedAt: "", thumbnail: "")
            
            
                self.performSegue(withIdentifier: "trend", sender: self)
//            }
        } else if collectionView == self.event_collection {
            self.selectedEvent = self.events[indexPath.item]
            self.performSegue(withIdentifier: "event", sender: self)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.displayCell = indexPath
    }
}

extension dashboardVC2:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.liverate_table {
            return self.rates.count + 1
        }
        return self.exclusiveBannerr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.liverate_table {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell1") as! liverateHeadCell
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell2") as! liverateCell
                cell.askLbl.layer.borderWidth = 1
                cell.askLbl.layer.borderColor = UIColor.white.cgColor
                if self.rates[indexPath.row - 1].ask.floatValue > self.oldrates[indexPath.row - 1].ask.floatValue {
                    cell.askLbl.backgroundColor = UIColor.init(rgb: 0x43a047)
                    cell.askLbl.textColor = .white
                } else if self.rates[indexPath.row - 1].ask.floatValue < self.oldrates[indexPath.row - 1].ask.floatValue {
                    cell.askLbl.backgroundColor = UIColor.init(rgb: 0xe53935)
                    cell.askLbl.textColor = .white
                } else {
                    cell.askLbl.backgroundColor = UIColor.white
                    cell.askLbl.textColor = .black
                }
                if self.rates[indexPath.row - 1].bid.floatValue > self.oldrates[indexPath.row - 1].bid.floatValue {
                    cell.bidLbl.backgroundColor = UIColor.init(rgb: 0x43a047)
                    cell.bidLbl.textColor = .white
                } else if self.rates[indexPath.row - 1].bid.floatValue < self.oldrates[indexPath.row - 1].bid.floatValue {
                    cell.bidLbl.backgroundColor = UIColor.init(rgb: 0xe53935)
                    cell.bidLbl.textColor = .white
                } else {
                    cell.bidLbl.backgroundColor = UIColor.white
                    cell.bidLbl.textColor = .black
                }
                /*if self.rates[indexPath.row - 1].askStatus.caseInsensitiveCompare("up") == .orderedSame {
                    cell.askLbl.backgroundColor = UIColor.init(rgb: 0x43a047)
                } else if self.rates[indexPath.row - 1].askStatus.caseInsensitiveCompare("down") == .orderedSame {
                    cell.askLbl.backgroundColor = UIColor.init(rgb: 0xe53935)
                } else {
                    cell.askLbl.backgroundColor = UIColor.white
                }
                if self.rates[indexPath.row - 1].bidStatus.caseInsensitiveCompare("up") == .orderedSame {
                    cell.bidLbl.backgroundColor = UIColor.init(rgb: 0x43a047)
                } else if self.rates[indexPath.row - 1].bidStatus.caseInsensitiveCompare("down") == .orderedSame {
                    cell.bidLbl.backgroundColor = UIColor.init(rgb: 0xe53935)
                } else {
                    cell.bidLbl.backgroundColor = UIColor.white
                }*/
                
                if self.rates[indexPath.row - 1].high.floatValue > self.oldrates[indexPath.row - 1].high.floatValue {
                    cell.highLbl.backgroundColor = UIColor.init(rgb: 0x43a047)
                    cell.highLbl.textColor = .white
                } else if self.rates[indexPath.row - 1].high.floatValue < self.oldrates[indexPath.row - 1].high.floatValue {
                    cell.highLbl.backgroundColor = UIColor.init(rgb: 0xe53935)
                    cell.highLbl.textColor = .white
                } else {
                    cell.highLbl.backgroundColor = UIColor.white
                    cell.highLbl.textColor = .black
                }
                
                if self.rates[indexPath.row - 1].low.floatValue > self.oldrates[indexPath.row - 1].low.floatValue {
                    cell.lowLbl.backgroundColor = UIColor.init(rgb: 0x43a047)
                    cell.lowLbl.textColor = .white
                } else if self.rates[indexPath.row - 1].low.floatValue < self.oldrates[indexPath.row - 1].low.floatValue {
                    cell.lowLbl.backgroundColor = UIColor.init(rgb: 0xe53935)
                    cell.lowLbl.textColor = .white
                } else {
                    cell.lowLbl.backgroundColor = UIColor.white
                    cell.lowLbl.textColor = .black
                }
                
//                if self.oldask == nil {
//                    self.oldask = self.rates[indexPath.row - 1].ask.floatValue
//                    self.oldbid = self.rates[indexPath.row - 1].bid.floatValue
//                    self.oldhigh = self.rates[indexPath.row - 1].high.floatValue
//                    self.oldlow = self.rates[indexPath.row - 1].low.floatValue
//                } else {
//                    if newask > self.oldask {
//                        cell.askLbl.backgroundColor = UIColor.init(rgb: 0xe53935)
//                        self.oldask = self.rates[0].ask.floatValue
//                    } else if newask < self.oldask {
//                        cell.askLbl.backgroundColor = UIColor.init(rgb: 0x43a047)
//                        self.oldask = self.rates[0].ask.floatValue
//                    } else {
//                        cell.askLbl.backgroundColor = UIColor.white
//                        self.oldask = self.rates[indexPath.row - 1].ask.floatValue
//                    }
////                    if self.oldask > newask {
////                        cell.askLbl.backgroundColor = UIColor.init(rgb: 0xe53935)
////                        self.oldask = self.rates[indexPath.row - 1].ask.floatValue
////                    } else if self.oldask < newask {
////                        cell.askLbl.backgroundColor = UIColor.init(rgb: 0x43a047)
////                        self.oldask = self.rates[indexPath.row - 1].ask.floatValue
////                    } else {
////
////                    }
////
////                    if self.oldbid > newbid {
////                        cell.bidLbl.backgroundColor = UIColor.init(rgb: 0xe53935)
////                        self.oldbid = self.rates[indexPath.row - 1].bid.floatValue
////                    }else if self.oldbid < newbid {
////                        cell.bidLbl.backgroundColor = UIColor.init(rgb: 0x43a047)
////                        self.oldbid = self.rates[indexPath.row - 1].bid.floatValue
////                    } else {
////                        cell.bidLbl.backgroundColor = UIColor.white
////                        self.oldbid = self.rates[indexPath.row - 1].bid.floatValue
////                    }
////
////                    if self.oldhigh > newhigh {
////                        cell.highLbl.backgroundColor = UIColor.init(rgb: 0xe53935)
////                        self.oldhigh = self.rates[indexPath.row - 1].high.floatValue
////                    } else if self.oldhigh < newhigh {
////                        cell.highLbl.backgroundColor = UIColor.init(rgb: 0x43a047)
////                        self.oldhigh = self.rates[indexPath.row - 1].high.floatValue
////                    } else {
////                        cell.highLbl.backgroundColor = UIColor.white
////                        self.oldhigh = self.rates[indexPath.row - 1].high.floatValue
////                    }
////
////                    if self.oldlow > newlow {
////                        cell.lowLbl.backgroundColor = UIColor.init(rgb: 0xe53935)
////                        self.oldlow = self.rates[indexPath.row - 1].low.floatValue
////                    } else if self.oldlow < newlow {
////                        cell.lowLbl.backgroundColor = UIColor.init(rgb: 0x43a047)
////                        self.oldlow = self.rates[indexPath.row - 1].low.floatValue
////                    } else {
////                        cell.lowLbl.backgroundColor = UIColor.white
////                        self.oldlow = self.rates[indexPath.row - 1].low.floatValue
////                    }
//                }
                
                
                cell.symbolLbl.text = self.rates[indexPath.row - 1].symbol
                cell.askLbl.text = self.rates[indexPath.row - 1].ask
                cell.bidLbl.text = self.rates[indexPath.row - 1].bid
                cell.highLbl.text = self.rates[indexPath.row - 1].high
                cell.lowLbl.text = self.rates[indexPath.row - 1].low
                
                cell.symbolLbl.layer.borderColor = UIColor.gray.cgColor

                
                cell.symbolLbl.layer.borderWidth = 1

                
                return cell
            }
            
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! unlimited_banner
        let ind = self.exclusiveBannerr[indexPath.row]
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            cell.img.dropShadow(color: .black, opacity: 1, offSet: .zero, radius: 5, scale: true)
        }
        cell.img.kf.indicatorType = .activity
        cell.img.kf.setImage(with: URL(string: ind.image),placeholder: nil,options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))], completionHandler:  { result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
                
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)" + ind.image)
                
                
            }
        })
        cell.view1.cornerRadius(radius: 5)
        cell.titleLbl.text = ind.title
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.liverate_table {
            print(self.liverate_table.frame.height / 6 - 10)
            return 38//self.liverate_table.frame.height / 6 - 10
        }
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 600
        }
        return 280
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.liverate_table {
            self.tabBarController?.selectedIndex = 2
            return
        }
        let id = self.exclusiveBannerr[indexPath.row].subcategoryID
        self.sendid = id.toInt()
        
        self.performSegue(withIdentifier: "subsub", sender: self)
    }
}
extension dashboardVC2: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.bounds.contains(self.videoView.frame) {
            
        } else {
            VideoBackground.shared.pause()
        }
    }
    @IBAction func playVideoTapped(_ sender: Any) {
        if isVideoPlaying == false {
            isVideoPlaying = true
            self.imgView.isHidden = true
            self.playButton.setImage(nil, for: .normal)
           let url = URL(string: self.videoo[0].fileName)!
            //let url = URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/VolkswagenGTIReview.mp4")!
            VideoBackground.shared.play(view: self.videoView, url: url, darkness: 0.0, isMuted: false, willLoopVideo: true, setAudioSessionAmbient: true, preventsDisplaySleepDuringVideoPlayback: true)
        } else {
            VideoBackground.shared.pause()
            isVideoPlaying = false
            self.imgView.isHidden = false
            self.playButton.setImage(#imageLiteral(resourceName: "play_icon"), for: .normal)
            
        }
        
    }
}

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
//MARK:- SELLER VIEW
extension dashboardVC2 {
    func configureMachinerySellerView(seller: ManufactureDash) {
        self.view.layoutIfNeeded()
        
        machinerySellerTitle.text = seller.name
        machinerySellerDescription.attributedText = seller.description.htmlToAttributedString
        selectedSellerId = seller.manufactureID
        
        machinerySellereLogo.kf.indicatorType = .activity
        machinerySellereLogo.kf.setImage(with: URL(string: seller.logo),placeholder: nil,options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
                
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
                
            }
        }
        
        if seller.package_name.lowercased() == "silver" {
            machinerySellerPartnershipLogo.image = #imageLiteral(resourceName: "silvermember")
        } else if seller.package_name.lowercased() == "gold" {
            machinerySellerPartnershipLogo.image = #imageLiteral(resourceName: "goldmember")
        } else if seller.package_name.lowercased() == "platinum" {
            machinerySellerPartnershipLogo.image = #imageLiteral(resourceName: "platinummember")
        } else if seller.package_name.lowercased() == "diamond" {
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
        self.performSegue(withIdentifier: "cata", sender: self)
    }
}
extension Array {
    func shuffled(using source: GKRandomSource) -> [Element] {
        return (self as NSArray).shuffled(using: source) as! [Element]
    }
    func shuffled() -> [Element] {
        return (self as NSArray).shuffled() as! [Element]
    }
}
