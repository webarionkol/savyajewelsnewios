//
//  leftVC.swift
//  savyaApp
//
//  Created by Yash on 6/18/19.
//  Copyright © 2019 Yash Rathod. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

struct ExpandableNames {
    
    var isExpanded: Bool
    let names: [[String:Any]]
    
}

class leftVC:UIViewController{

    @IBOutlet weak var tablee:UITableView!
    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var img:UIImageView!
    @IBOutlet weak var settingBtn:UIButton!
    @IBOutlet weak var imgVerify:UIImageView!
    @IBOutlet weak var statusLbl:UILabel!
    var arrName = [String]()
    var arrImage = [UIImage]()
    var arrRes = [[String:AnyObject]]()
    var expand = [Bool]()
    let apis = APIManager()
    var sendid = 0
    var categoryId = 0
    var fromleft = ""
    
    @IBOutlet weak var btnABout: UIButton!
    @IBOutlet weak var btnContact: UIButton!
    var twoDimensionalArray = [ExpandableNames]()
    
    @IBOutlet weak var btnPP: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let headerNib = UINib.init(nibName: "sectionHeader", bundle: Bundle.main)
        self.tablee.register(headerNib, forHeaderFooterViewReuseIdentifier: "sectionHeader")
        
        let aboutus = UINib.init(nibName: "aboutusHeader", bundle: Bundle.main)
        self.tablee.register(aboutus, forHeaderFooterViewReuseIdentifier: "aboutusHeader")
        
        let privacy = UINib.init(nibName: "privacyHeader", bundle: Bundle.main)
        self.tablee.register(privacy, forHeaderFooterViewReuseIdentifier: "privacyHeader")
        
        self.arrName.append("Home")
        self.arrName.append("Rings")
        self.arrName.append("Earrings")
        self.arrName.append("Pendants")
        self.arrName.append("Bangles")
        self.arrName.append("All Categories")
        self.arrName.append("Bullian")
        self.arrName.append("More")
        
        self.arrImage.append(UIImage(named: "home")!)
        self.arrImage.append(UIImage(named: "wedding-rings")!)
        self.arrImage.append(UIImage(named: "earrings")!)
        self.arrImage.append(UIImage(named: "pendant")!)
        self.arrImage.append(UIImage(named: "bracelet")!)
        self.arrImage.append(UIImage(named: "home")!)
        self.arrImage.append(UIImage(named: "bullion")!)
        self.arrImage.append(UIImage(named: "more")!)
        
        self.img.layer.cornerRadius = self.img.frame.height / 2
        self.img.clipsToBounds = true
        
        self.getAllData()
        self.getProfile()
        
        btnPP.layer.borderWidth = 1.0
        btnPP.layer.borderColor = UIColor.lightGray.cgColor
        
        btnABout.layer.borderWidth = 1.0
        btnABout.layer.borderColor = UIColor.lightGray.cgColor
        
        btnContact.layer.borderWidth = 1.0
        btnContact.layer.borderColor = UIColor.lightGray.cgColor
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(update))
        self.img.isUserInteractionEnabled = true
        self.img.addGestureRecognizer(tap)
        
        if UserDefaults.standard.bool(forKey: "guest") == true {
            self.lblName.text = "Guest User"
            self.settingBtn.isEnabled = false
        } else {
            // self.getProfile()
            self.settingBtn.isEnabled = true
        }
        
    }
    @IBAction func btnPPClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "privacy", sender: self)
    }
    @IBAction func btnContactClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "contactus", sender: self)
    }
    @IBAction func btnAbourClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "aboutus", sender: self)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "events" {
            _ = segue.destination as! bullianVC
        } else if segue.identifier == "aboutus" {
            let dvc = segue.destination as! aboutUSVC
            dvc.pageToOpen = PageToOpen.aboutUs
        } else if segue.identifier == "contactus" {
            _ = segue.destination as! contactusVC
        } else if segue.identifier == "more" {
            _ = segue.destination as! moreVC
        } else if segue.identifier == "subsub" {
            let dvc = segue.destination as! subSubVC
            dvc.id = self.sendid
            dvc.categoryId = self.categoryId
            dvc.left = "left"
        }
    }
    @objc func home() {
        self.performSegue(withIdentifier: "home", sender: self)
    }
    @objc func update() {
        self.performSegue(withIdentifier: "update", sender: self)
    }
    func getAllData() {
        let authorization:HTTPHeaders =  ["Authorization":Token.getLatestToken()]
        AF.request(NewAPI.menu,method: .get,parameters: nil,encoding: JSONEncoding.default,headers: authorization).responseJSON { (responseData) in
            print(responseData)
            if responseData.value != nil {
                let res1Data = responseData.value as! [String:Any]
                let res2Data = res1Data["data"]! as! [[String:Any]]
                for object in res2Data {

                    print(object["category"]!)
                    let dict = ["image": object["image"],"SubCategoryName": object["category"],"Products": object["subcategory"]]
                    let singleObj = ExpandableNames(isExpanded: false, names: [dict as [String : Any]])
                    self.twoDimensionalArray.append(singleObj)
                   
                    print(self.twoDimensionalArray[0].names)
                    

                 }
                
                let dict = ["image":"home","SubCategoryName": "Home","Products": [[:]]] as [String : Any]
                let singleObj = ExpandableNames(isExpanded: false, names: [dict as [String : Any]])
                self.twoDimensionalArray.insert(singleObj, at: 0)

                
                let dict1 = ["image":"bullion","SubCategoryName": "Bullion Merchants","Products": [[:]]] as [String : Any]
                let singleObj1 = ExpandableNames(isExpanded: false, names: [dict1 as [String : Any]])
                self.twoDimensionalArray.insert(singleObj1, at: res2Data.count+1)
                
                
                DispatchQueue.main.async {
                    self.tablee.reloadData()

                }
                
//                if let resData = res2Data.arrayObject {
//                    self.arrRes = resData as! [[String:AnyObject]]
//                }
//                for _ in 0 ..< self.arrRes.count {
//                    self.expand.append(false)
//                }
                
            }
        }
    }
    func getProfile() {
        let mobile = UserDefaults.standard.string(forKey: "mobile")
        apis.getCurrentProfile(vc: self) { (pro,kyc,url) in
            self.lblName.text = pro.name
            print(pro.name)
            let finalurl = pro.image
            var turl = finalurl
            if finalurl!.contains(" ") {
                turl = finalurl!.replacingOccurrences(of: " ", with: "%20")
            }
            if kyc.documentVerified == "0" {
                self.imgVerify.image = UIImage(named: "notverified")
                self.statusLbl.text = "Not Verified"
            } else if kyc.documentVerified == "1" {
                self.imgVerify.image = UIImage(named: "pending")
                self.statusLbl.text = "Pending"
            } else if kyc.documentVerified == "2" {
                self.imgVerify.image = UIImage(named: "verified")
                self.statusLbl.text = "Verified"
            } else {
                self.imgVerify.image = UIImage(named: "notverified")
                self.statusLbl.text = "Not Verified"
            }
            self.img.kf.indicatorType = .activity
            self.img.kf.setImage(with: URL(string: turl!),placeholder: UIImage.init(named: "placeholder"),options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
                switch result {
                case .success(let value):
                    print("Task done for: \(value.source.url?.absoluteString ?? "")")
                    
                case .failure(let error):
                    
                    print("Job failed: \(error.localizedDescription) \(finalurl)")
                    
                }
            }
        }
    }
    @objc func moreBtnTapped() {
        self.performSegue(withIdentifier: "more", sender: self)
    }
    @objc func getSelected(sender:UIButton) {
       
        if sender.tag == self.arrRes.count + 1 {
            self.performSegue(withIdentifier: "events", sender: self)
        } else if sender.tag == 0 {
            
        } else if sender.tag <= self.arrRes.count {
            let expandedIndex = self.expand.firstIndex(where: {$0 == true})
            self.expand.removeAll()
            for _ in 0 ..< self.arrRes.count {
                self.expand.append(false)
            }
            if  expandedIndex == nil || (expandedIndex != nil && (expandedIndex != sender.tag-1)) {
                self.expand[sender.tag - 1] = true
            }
            self.tablee.reloadSections(IndexSet(integersIn: 0...self.expand.count), with: .automatic)
        }
        
    }
    @objc func aboutus(_ sender:UIButton) {
        self.performSegue(withIdentifier: "aboutus", sender: self)
    }
    @objc func contactus(_ sender:UIButton) {
        self.performSegue(withIdentifier: "contactus", sender: self)
    }
    @objc func privacyPolicy(_ sender:UIButton) {
        self.performSegue(withIdentifier: "privacy", sender: self)
    }
    @objc func distributor(_ sender:UIButton) {
        self.performSegue(withIdentifier: "distributor", sender: self)
    }
    @objc func machineryBtn() {
        self.performSegue(withIdentifier: "machinery", sender: self)
    }
  //  func numberOfSections(in tableView: UITableView) -> Int {
     //   return self.arrRes.count + 6
 //   }
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if section == self.arrRes.count + 4 {
//            return 70
//        } else if section == self.arrRes.count + 5 {
//            return 70
//        } else if section == self.arrRes.count + 2 {
//            return 0
//        } else if section == self.arrRes.count + 3 {
//            return 0
//        }
//        return 50
//    }
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if section == 0 {
//            return "Home"
//        } else if section == self.arrRes.count + 1 {
//            return "All Categories"
//        } else if section == self.arrRes.count + 2 {
//            return "Bullian"
//        } else if section == self.arrRes.count + 3 {
//            return ""
//        } else if section == self.arrRes.count + 4 {
//            return "About US"
//        } else if section == self.arrRes.count + 5 {
//            return "Our Privacy Policy"
//        } else {
//            return self.arrRes[section - 1]["category"] as? String
//        }
//    }
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        if section == 0 {
//            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "sectionHeader") as! sectionHeader
//            headerView.img.image = self.arrImage[0]
//            headerView.lbl1.text = self.arrName[0]
//            headerView.backgroundColor = UIColor.orange
//            headerView.btn1.addTarget(self, action: #selector(home), for: .touchUpInside)
//            return headerView
//        } else if section == self.arrRes.count + 1 {
//            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "sectionHeader") as! sectionHeader
//            headerView.img.image = self.arrImage[6]
//            headerView.lbl1.text = "Bullion Merchant"
//            headerView.btn1.tag = section
//            headerView.btn1.addTarget(self, action: #selector(getSelected(sender:)), for: .touchUpInside)
//            return headerView
////            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "sectionHeader") as! sectionHeader
////
////            headerView.lbl1.text = ""
////            headerView.btn1.addTarget(self, action: #selector(distributor), for: .touchUpInside)
////            return headerView
//        } else if section == self.arrRes.count + 2 {
//            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "sectionHeader") as! sectionHeader
//              headerView.img.image = nil
//              headerView.lbl1.text = ""
//            //  headerView.btn1.addTarget(self, action: #selector(moreBtnTapped), for: .touchUpInside)
//              return headerView
////            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "sectionHeader") as! sectionHeader
////            headerView.img.image = self.arrImage[6]
////            headerView.lbl1.text = "Events"
////            headerView.btn1.tag = section
////            headerView.btn1.addTarget(self, action: #selector(getSelected(sender:)), for: .touchUpInside)
////            return headerView
//        } else if section == self.arrRes.count + 3 {
//            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "sectionHeader") as! sectionHeader
//            headerView.img.image = nil
//            headerView.lbl1.text = ""
//          //  headerView.btn1.addTarget(self, action: #selector(moreBtnTapped), for: .touchUpInside)
//            return headerView
//        } else if section == self.arrRes.count + 4 {
//            let aboutus = tableView.dequeueReusableHeaderFooterView(withIdentifier: "aboutusHeader") as! aboutusHeader
//            aboutus.aboutusBtn.layer.borderColor = UIColor.lightGray.cgColor
//            aboutus.aboutusBtn.layer.borderWidth = 0.5
//            aboutus.aboutusBtn.addTarget(self, action: #selector(aboutus(_:)), for: .touchUpInside)
//
//            aboutus.contactusBtn.layer.borderColor = UIColor.lightGray.cgColor
//            aboutus.contactusBtn.layer.borderWidth = 0.5
//            aboutus.contactusBtn.addTarget(self, action: #selector(contactus(_:)), for: .touchUpInside)
//
//            return aboutus
//        } else if section == self.arrRes.count + 5 {
//            let privacy = tableView.dequeueReusableHeaderFooterView(withIdentifier: "privacyHeader") as! privacyHeader
//            privacy.privacyBtn.layer.borderWidth = 0.5
//            privacy.privacyBtn.layer.borderColor = UIColor.lightGray.cgColor
//            privacy.privacyBtn.addTarget(self, action: #selector(privacyPolicy(_:)), for: .touchUpInside)
//            return privacy
//        } else {
//            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "sectionHeader") as! sectionHeader
//            let imgurl = self.arrRes[section - 1]["image"] as? String
//            let finalURL = "\(MainURL.mainurl)img/category/\(imgurl!)"
//            var turl = finalURL
//            if finalURL.contains(" ") {
//                turl = finalURL.replacingOccurrences(of: " ", with: "%20")
//            }
//            let sub_cata = self.arrRes[section - 1]["subcategory"] as? [[String:Any]]
//            if sub_cata?.count == 0 {
//                headerView.btn1.isEnabled = false
//            } else {
//                headerView.btn1.isEnabled = true
//                headerView.btn1.tag = section
//                headerView.btn1.addTarget(self, action: #selector(getSelected(sender:)), for: .touchUpInside)
//            }
//
//            headerView.img.kf.indicatorType = .activity
//            headerView.img.kf.setImage(with: URL(string: turl),placeholder: nil,options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
//                switch result {
//                case .success(let value):
//                    print("Task done for: \(value.source.url?.absoluteString ?? "")")
//
//                case .failure(let error):
//                    print("Job failed: \(error.localizedDescription)")
//
//                }
//            }
//
//            headerView.lbl1.text = self.arrRes[section - 1]["category"] as? String
//            let machinery = self.arrRes[section - 1]["category"] as? String
//            if machinery == "MACHINERY" {
//                headerView.btn1.addTarget(self, action: #selector(machineryBtn), for: .touchUpInside)
//            }
//            return headerView
//        }
//
//    }
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        if section == self.arrRes.count + 4 {
//            return 0
//        } else if section == self.arrRes.count + 5 {
//            return 0
//        }
//        return 1
//    }
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 0 {
//            return 0
//        } else if section == self.arrRes.count + 1 {
//            return 0
//        } else if section == self.arrRes.count + 2 {
//            return 0
//        } else if section == self.arrRes.count + 3 {
//            return 0
//        } else if section == self.arrRes.count + 4 {
//            return 0
//        } else if section == self.arrRes.count + 5 {
//            return 0
//        } else {
//            guard let sub_cata = self.arrRes[section - 1]["subcategory"] as? [[String:Any]] else {
//                return 0
//            }
//            if self.expand[section - 1] == true {
//                return sub_cata.count
//            } else {
//                return 0
//            }
//        }
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! sideCell
//        let sub_cata = self.arrRes[indexPath.section - 1]["subcategory"] as? [[String:Any]]
//        let sub_data = sub_cata![indexPath.row]["subcategory"] as? String
//        let imgurl = sub_cata![indexPath.row]["image"] as? String
//        let finalURL = "\(MainURL.mainurl)img/subcategory/\(imgurl!)"
//        var turl = finalURL
//        if finalURL.contains(" ") {
//            turl = finalURL.replacingOccurrences(of: " ", with: "%20")
//        }
//        cell.img.kf.indicatorType = .activity
//        cell.img.kf.setImage(with: URL(string: turl),placeholder: nil,options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
//            switch result {
//            case .success(let value):
//                print("Task done for: \(value.source.url?.absoluteString ?? "")")
//
//            case .failure(let error):
//                print("Job failed: \(error.localizedDescription)")
//
//            }
//        }
//        cell.lbl1.text = sub_data
//
//        return cell
//    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 45
//    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell = tableView.cellForRow(at: indexPath)
//        print(cell?.textLabel?.text)
//        let sub_cata = self.arrRes[indexPath.section - 1]["subcategory"] as? [[String:Any]]
//        let sub_data = sub_cata![indexPath.row]["id"] as! Int
//        self.sendid = Int(sub_data)
//        if let value = sub_cata![indexPath.row]["category_id"] as? String {
//            self.categoryId = Int(value)!
//        } else if let value = sub_cata![indexPath.row]["category_id"] as? Int {
//            self.categoryId = value
//        }
//        self.performSegue(withIdentifier: "subsub", sender: self)
//    }
    
}
extension leftVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let object = twoDimensionalArray[section].names[0]
        print(object)
        
        let headerview = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        
       
        let isExpanded = twoDimensionalArray[section].isExpanded
        
        
        let view1 = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        view1.backgroundColor = .clear
        
        let view2 = UIView(frame: CGRect(x: 0, y: 5, width: tableView.frame.width, height: 40))
        
        
        let label = UILabel(frame: CGRect(x: 50, y: 15, width: tableView.frame.width - 70, height: 30))
        
        label.numberOfLines = 0
        let queston = object["SubCategoryName"] as! String
        let img = object["image"] as! String
        print(queston)
        label.textColor = .black
        
        
       // let attrs = [NSAttributedString.Key.font: UIFont(name: "Montserrat-Medium", size: 15)!]
      //  let attributedString = NSMutableAttributedString(string:queston, attributes:attrs)
        label.text = queston
        label.textColor = UIColor.darkGray
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 17, width: tableView.frame.width, height: 25)
        
        
        button.addTarget(self, action: #selector(handleExpandClose), for: .touchUpInside)
        //button.imageView?.maskWith(color: myColors.Orange)
        button.tag = section
        
          var imageView : UIImageView
          imageView  = UIImageView(frame:CGRect(x: 10, y: 15, width: 30, height: 30));
         // imageView.image = UIImage(named:"image.jpg")
         
        
        if section == 0 {
            imageView.image = UIImage(named: "home")
        }else if section == twoDimensionalArray.count-1
        {
            
            imageView.image = UIImage(named: "bullion")
        }
        else {
            button.setImage(UIImage(named: "rights-arrow")!, for: .normal)
            button.imageEdgeInsets = UIEdgeInsets(top: 5, left: tableView.frame.width - 40, bottom: 5, right: 20)
            let imgurl = img
            let finalURL = "\(MainURL.mainurl)img/category/\(imgurl)"
                    var turl = finalURL
                    if finalURL.contains(" ") {
                        turl = finalURL.replacingOccurrences(of: " ", with: "%20")
                    }
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(with: URL(string: turl),placeholder: nil,options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
                        switch result {
                        case .success(let value):
                            print("Task done for: \(value.source.url?.absoluteString ?? "")")
            
                        case .failure(let error):
                            print("Job failed: \(error.localizedDescription)")
            
                        }
                    }
        }
        
       
        
        view1.addSubview(imageView)
        view2.backgroundColor = UIColor.white
        view1.addSubview(button)
        view1.addSubview(label)
        
        view2.layer.cornerRadius = 5.0
        view2.layer.masksToBounds = true
        headerview.addSubview(view2)
        headerview.addSubview(view1)
         headerview.backgroundColor = UIColor.white
        //        view1.addSubview(button1)
        return headerview
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 50
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return twoDimensionalArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       if !twoDimensionalArray[section].isExpanded {
                return 0
            }
            
            let products = twoDimensionalArray[section].names[0]["Products"] as? [[String:Any]]
        
            return products?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! sideCell
       if let products = twoDimensionalArray[indexPath.section].names[0]["Products"] as? [[String:Any]] {
            
            if let obj = products[indexPath.row] as? [String:Any] {
              
                cell.lbl1.text = obj["subcategory"] as? String
                
                let imgurl = obj["image"] as? String
                        let finalURL = "\(MainURL.mainurl)img/subcategory/\(imgurl!)"
                        var turl = finalURL
                        if finalURL.contains(" ") {
                            turl = finalURL.replacingOccurrences(of: " ", with: "%20")
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

            }
        }
        cell.backgroundColor = UIColor.lightGray
         cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
                
        let products = twoDimensionalArray[indexPath.section].names[0]["Products"] as! [[String:Any]]
             
              let obj = products[indexPath.row] as! [String:Any]
        
        
                let sub_cata = obj["subcategory"] as? String
                let id = obj["id"] as! Int
                self.sendid = Int(id)
                if let value = obj["category_id"] as? String {
                    self.categoryId = Int(value)!
                } else if let value = obj["category_id"] as? Int {
                    self.categoryId = value
                }
                self.performSegue(withIdentifier: "subsub", sender: self)
    }
    @objc func handleExpandClose(button: UIButton) {
        print("Trying to expand and close section...")
        
        let section = button.tag
        
        
        if section == 0 {
            home()
        }
        else if section == twoDimensionalArray.count-1 {
            self.performSegue(withIdentifier: "events", sender: self)
        }
        else if section ==  5{
            self.performSegue(withIdentifier: "machinery", sender: self)
        }
        else {
            // we'll try to close the section first by deleting the rows
            var indexPaths = [IndexPath]()
             if let products = twoDimensionalArray[section].names[0]["Products"] as? [[String:Any]] {
                for row in products.indices {
                           print(0, row)
                           let indexPath = IndexPath(row: row, section: section)
                           indexPaths.append(indexPath)
                }
            }
            let isExpanded = twoDimensionalArray[section].isExpanded
            twoDimensionalArray[section].isExpanded = !isExpanded
            
            button.setImage(isExpanded ? UIImage(named: "rights-arrow")! : UIImage(named: "down-arrow")!, for: .normal)
            
            if isExpanded {
               tablee.deleteRows(at: indexPaths, with: .fade)
            } else {
                tablee.insertRows(at: indexPaths, with: .fade)

            }
            
    //        DispatchQueue.main.async {
    //            self.tblHeight.constant =  self.tblList.contentSize.height+30
    //        }
        }
        
        
    }
    
}
