//
//  offersVC.swift
//  savyaApp
//
//  Created by Yash on 6/17/19.
//  Copyright © 2019 Yash Rathod. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import Toast_Swift

class offerVC:RootBaseVC {
    
    @IBOutlet weak var backBtn:UIButton!
    @IBOutlet weak var view1:UIView!
    @IBOutlet weak var tableView:UITableView!
    var page = 1
    var allOffers = [Offer]()
    var total = 0
    var wheree = ""
    var ispage = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        self.view1.layer.borderColor = UIColor.black.cgColor
        self.view1.layer.borderWidth = 1.0
        
        
        if self.wheree == "menu" {
            self.backBtn.setImage(UIImage(named: "backblack"), for: .normal)
        } else {
            
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadAnimation()
        self.getAllData()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    @IBAction func back(_ sender:UIButton) {
        if self.backBtn.imageView?.image == UIImage(named: "backblack") {
            self.dismiss(animated: true, completion: nil)
        }
    }
    func getBypage(page:Int) {
        if total != self.allOffers.count {
            APIManager.shareInstance.getAllOffer(page: page, vc: self) { (offers, total,current_page,last_page) in
                for i in offers {
                    self.allOffers.append(i)
                }
                if current_page != last_page {
                    self.ispage = true
                }
                self.tableView.reloadData()
                self.removeAnimation()
                
            }
        }
    }
    func getAllData() {
        
        APIManager.shareInstance.getAllOffer(page: self.page, vc: self) { (offers, total,current_page,last_page) in
            self.removeAnimation()
            if offers.count == 0 {
                let alert = UIAlertController.init(title: "Message", message: "No Offers Found", preferredStyle: .alert)
                alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { (_) in
                    if self.wheree == "menu" {
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        self.tabBarController?.selectedIndex = 0
                    }
                }))
                self.present(alert, animated: true, completion: nil)
            } else {
                self.allOffers = offers
                self.total = total
                self.tableView.reloadData()
                
                if current_page != last_page {
                    self.ispage = true
                }
            }
            
        }
    }
}
extension offerVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allOffers.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! offersCell
        let indRes = self.allOffers[indexPath.row]
        cell.titleLbl.text = indRes.titlee
        cell.descrlbl.text = indRes.subtitle
        cell.valueLbl.text = "Value:- " + indRes.value
        cell.codeLbl.text =  "Coupon Code:- " + indRes.code
        cell.img.kf.indicatorType = .activity
        if let encodedString  = indRes.img.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed), let url = URL(string: encodedString) {
            cell.img.kf.setImage(with: url,placeholder: nil,options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
                switch result {
                case .success(let value):
                    print("Task done for: \(value.source.url?.absoluteString ?? "")")
                    
                case .failure(let error):
                    print(encodedString)
                    print("Job failed: \(error.localizedDescription)")
                    
                }
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if self.ispage == true {
            if indexPath.row == self.allOffers.count - 1 {
                self.page += 1
                self.getBypage(page: self.page)
            }
        }
        
      
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIPasteboard.general.string = self.allOffers[indexPath.row].code
        self.view.makeToast("Code Copied")
        
    }
}

