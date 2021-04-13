//
//  profileVC.swift
//  savyaApp
//
//  Created by Yash on 6/17/19.
//  Copyright © 2019 Yash Rathod. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import RealmSwift

class profileVC:RootBaseVC,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tablee:UITableView!
    @IBOutlet weak var img:UIImageView!
    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var cityLbl:UILabel!
    @IBOutlet weak var imgVerify:UIImageView!
    
    var arrNames = [String]()
    var arrImgs = [UIImage]()
    let apis = APIManager()
    var isDocumentVerified = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.arrNames.append("Address Book")
        self.arrNames.append("My Wishlist")
        self.arrNames.append("My Orders")
        self.arrNames.append("My Offers")
        self.arrNames.append("Update Profile")
        self.arrNames.append("KYC Verification")
        self.arrNames.append("General Setting")
        self.arrNames.append("Logout")
        
        self.arrImgs.append(UIImage(named: "book")!)
        self.arrImgs.append(UIImage(named: "wishlist")!)
        self.arrImgs.append(UIImage(named: "order")!)
        self.arrImgs.append(UIImage(named: "offer")!)
        self.arrImgs.append(UIImage(named: "profileedit")!)
        self.arrImgs.append(UIImage(named: "kyc")!)
        self.arrImgs.append(UIImage(named: "kyc")!)
        self.arrImgs.append(UIImage(named: "logout")!)
        
        self.img.layer.cornerRadius = self.img.frame.height / 2
        self.img.clipsToBounds = true
        self.imgVerify.layer.cornerRadius = self.imgVerify.frame.height / 2
        self.imgVerify.clipsToBounds = true
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(updateProfile))
        self.img.isUserInteractionEnabled = true
        self.img.addGestureRecognizer(tap)
        
        self.getProfile()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addressbook" {
            _ = segue.destination as! allAddressVC
        } else if segue.identifier == "wishlist" {
            _ = segue.destination as! wishlistVC
        } else if segue.identifier == "offer" {
            let dvc = segue.destination as! offerVC
            dvc.wheree = "menu"
        } else if segue.identifier == "kyc" {
            let dvc = segue.destination as! kycInfoVC
            dvc.isDocumentVerified = self.isDocumentVerified
        }
    }
    @objc func updateProfile() {
        self.performSegue(withIdentifier: "update", sender: self)
    }
    func getProfile() {
        
        apis.getCurrentProfile(vc: self) { (pro,kyc,url) in
            self.lblName.text = pro.name
            self.cityLbl.text = pro.city
            let finalurl = pro.image
            var turl = finalurl
            if finalurl!.contains(" ") {
                turl = finalurl!.replacingOccurrences(of: " ", with: "%20")
            }
            
            self.img.kf.indicatorType = .activity
            self.img.kf.setImage(with: URL(string: turl!),placeholder: UIImage.init(named: "placeholder"),options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))], completionHandler:  { result in
                switch result {
                case .success(let value):
                    print("Task done for: \(value.source.url?.absoluteString ?? "")")
                    
                case .failure(let error):
                    
                    print("Job failed: \(error.localizedDescription) \(String(describing: finalurl))")
                    
                }
            })
            self.isDocumentVerified = false
            if kyc.documentVerified == "0" {
                self.imgVerify.image = UIImage(named: "notverified")
                
            } else if kyc.documentVerified == "1" {
                self.imgVerify.image = UIImage(named: "pending")
               
            } else if kyc.documentVerified == "2" {
                self.imgVerify.image = UIImage(named: "verified")
                self.isDocumentVerified = true
                
            } else {
                self.imgVerify.image = UIImage(named: "notverified")
                
            }
        }
    }
    func clearRealm(completion: @escaping (Bool) -> Void) {
        let r1 = try! Realm()
        let allR1 = try! Realm().objects(Mobile.self)
        try! r1.write {
            r1.delete(allR1)
            
        }
        completion(true)
    }
    @IBAction func backBtn(_ sender:UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if UserDefaults.standard.bool(forKey: "guest") == true {
            return self.arrNames.count - 1
        } else {
            return self.arrNames.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! profileCell
        cell.img.image = self.arrImgs[indexPath.row]
        cell.lbl1.text = self.arrNames[indexPath.row]
        
        if indexPath.row == 1 {
            cell.accessoryType = .disclosureIndicator
        } else if indexPath.row == 2 {
            cell.accessoryType = .disclosureIndicator
        } else if indexPath.row == 3 {
            cell.accessoryType = .disclosureIndicator
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let dvc = self.storyboard?.instantiateViewController(withIdentifier: "addressbook") as! allAddressVC
            self.present(dvc, animated: true, completion: nil)
        } else if indexPath.row == 7 {
            self.clearRealm { (clear) in
                if clear {
                    self.performSegue(withIdentifier: "logout", sender: self)
                }
            }
            
        } else if indexPath.row == 1 {
            self.performSegue(withIdentifier: "wishlist", sender: self)
        } else if indexPath.row == 2 {
            self.performSegue(withIdentifier: "order", sender: self)
        } else if indexPath.row == 3 {
            self.performSegue(withIdentifier: "offer", sender: self)
        } else if indexPath.row == 4 {
            self.performSegue(withIdentifier: "update", sender: self)
        } else if indexPath.row == 5 {
            
            self.performSegue(withIdentifier: "kyc", sender: self)
        }
        else if indexPath.row == 6 {
          
           self.performSegue(withIdentifier: "setting", sender: self)
       }
    }
}
