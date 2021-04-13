//
//  liverateVC.swift
//  savyaApp
//
//  Created by Yash on 8/9/19.
//  Copyright © 2019 Yash Rathod. All rights reserved.
//

import Foundation
import UIKit


class liverateVC:RootBaseVC,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    
    @IBOutlet weak var tableView:subtableView!
    @IBOutlet weak var bannerCollection:UICollectionView!
    @IBOutlet weak var heightTbl:NSLayoutConstraint!
    
    @IBOutlet weak var scrollView:UIScrollView!
    
    var rates = [LiveRate]()
    var oldrates = [LiveRate]()
    let api = APIManager()
    var allState = [StateBullian]()
    var allCity = [BullianCity]()
    var appBanner = [AppBannerDash]()
    var ind = IndexPath(row: 0, section: 0)
    let bannerimgs = [UIImage(named: "1b"),UIImage(named: "2b"),UIImage(named: "3b")]
    var oldask:String!
    var oldbid:String!
    var oldhigh:String!
    var oldlow:String!
    var sendid = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        self.getallRate()
        self.bannerCollection.delegate = self
        self.bannerCollection.dataSource = self
        
        self.view.backgroundColor = UIColor.lightGray
    
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadAnimation()
        self.getBanner()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.removeAnimation()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "proceed" {
            let dvc = segue.destination as! bullianCityVC
            dvc.cityid = self.sendid
        } else if segue.identifier == "bulliannList" {
            let dvc = segue.destination as! bullianListVC
            dvc.cityid = self.sendid
        }
    }
    func getBanner() {
        APIManager.shareInstance.dashboardData { (appBanner, _, _, _, _, _, _, _, _, _) in
            self.appBanner = appBanner
            self.bannerCollection.reloadData()
        }
    }
    func getallRate() {
        api.getliverates(vc: self) { (ratees) in
            self.oldrates = self.rates
            self.rates.removeAll()
            self.rates = ratees
            if self.oldrates.count == 0 {
                self.oldrates = self.rates
            }
            self.tableView.reloadData()
            self.tableView.invalidateIntrinsicContentSize()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                self.getallRate()
            }
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.invalidateIntrinsicContentSize()
        
//        self.heightTbl.constant = 38 * 6
//        let liveRateTbl = self.tableView.frame.height
//        let totalBythree = self.allCity.count / 3
//
//        if UIDevice.current.userInterfaceIdiom == .pad {
//            self.collectionHeight.constant = collectionCitySize + 370
//        } else {
//            self.collectionHeight.constant = collectionCitySize + 170
//        }
//
//        let stateTbl = self.stateTblView.intrinsicContentSize.height
//
//        let calc1 = liveRateTbl + collectionCitySize
//        self.scrollView.contentSize = CGSize.init(width: self.view.frame.width, height: calc1 + stateTbl + 400)
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.rates.count + 1 
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 38
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.appBanner.count
    }
       
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! exclusive_bannerCell
        if self.appBanner.count > 0 {
            cell.img.cornerRadius(radius: 8)
            let ind = self.appBanner[indexPath.item]
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
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.bannerCollection.frame.width, height: self.bannerCollection.frame.height )
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
