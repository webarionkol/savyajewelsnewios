//
//  wishlistVC.swift
//  savyaApp
//
//  Created by Yash on 8/9/19.
//  Copyright © 2019 Yash Rathod. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import RealmSwift

class wishlistVC:RootBaseVC,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tablee:UITableView!
    var allWish = [Wishlist]()
    var selected = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadAnimation()
        self.getAllData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "proceed" {
            let dvc = segue.destination as! productDetailNewVC
            dvc.productId = self.selected
        }
    }
    @objc func removeFromWishlist(_ sender:UIButton) {
        
        APIManager.shareInstance.removewishlist(product_id: self.allWish[sender.tag].productID.toString(), vc: self) { (response) in
            self.getAllData()
            if response == "success" {
                self.view.makeToast("Product removed from wishlist")
             //   self.removeFromRealm(index: sender.tag)
                
            }  else {
                self.showAlert(titlee: "Message", message: "Something went wrong")
            }
        }
    }
    @objc func addToCart(_ sender:UIButton) {
           
        _ = [[String:Any]]()
        
//        if self.allWish[sender.tag].gold.count > 0 {
//            assetsArr.append(["weight" : self.allWish[sender.tag].gold[0].goldweight!,"materialType":self.allWish[sender.tag].gold[0].goldquality!,"makingCharge":self.allWish[sender.tag].gold[0].makingcharge!,"option":self.allWish[sender.tag].gold[0].option!,"metal":"Gold","productId":"1"])
//        }
//
//
//        if self.allWish[sender.tag].diamond.count > 0 {
//            assetsArr.append(["weight" :self.allWish[sender.tag].diamond[0].diamondqty!,"materialType":"\(self.allWish[sender.tag].diamond[0].diamondcolor!)/\(self.allWish[sender.tag].diamond[0].diamondclarity!)","makingCharge":self.allWish[sender.tag].diamond[0].diamondcharge!,"option":"pergram","metal":"Diamond","productId":"1"])
//        }
//
//        if self.allWish[sender.tag].stone.count > 0 {
//            assetsArr.append(["weight" : self.allWish[sender.tag].stone[0].stoneno,"materialType":self.allWish[sender.tag].stone[0].stonetype,"makingCharge":self.allWish[sender.tag].stone[0].stonecharges,"option":"pergram","metal":"Stone","productId":"1"])
//           }
//        if self.allWish[sender.tag].platinum.count > 0 {
//            assetsArr.append(["weight" : self.allWish[sender.tag].platinum[0].platinumQty,"materialType":"Platinum","makingCharge":self.allWish[sender.tag].platinum[0].platinumCharge,"option":"pergram","metal":"Platinum","productId":"1"])
//           }
//
//        let data = ["count":1,"productId":self.allWish[sender.tag].product_id,"userid":Mobile.getUid(),"category":"gold","subCategory":"subCata","subSubCategory":"subsub","productCode":"code","productName":"pname","description":"descr","productType":"abc","assests":assetsArr] as [String : Any]
//
//           APIManager.shareInstance.addToCart(data: [data]) { (response) in
//            if response == "success" {
//                self.view.makeToast("Product added successfully")
//            } else {
//                self.view.makeToast("Something went wrong")
//            }
//
//           }
       }
    func removeFromRealm(index:Int) {
       
        
        let realm = try! Realm()
        try! realm.write {
            realm.delete( try! Realm().objects(WishlistRealm.self).filter("pid=%@",self.allWish[index].productID))
        
        }
    }
    func getAllData() {
        self.allWish.removeAll()
        APIManager.shareInstance.viewWishlist(vc: self) { (wishlist) in
            self.allWish = wishlist
            if self.allWish.count == 0 {
                self.removeAnimation()
                self.showAlertDismiss()
            } else {
                self.tablee.reloadData()
                self.removeAnimation()
            }
        }
        
    }
    func showAlertDismiss() {
        let alert = UIAlertController.init(title: "Message", message: "No Products in wishlist", preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { (_) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func backBtn(_ sender:UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allWish.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! wishlistCell
        let ind = self.allWish[indexPath.row]
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            cell.viewShadow.addShadowWithCorner(corner: 10)
        }
        cell.viewCorner.layer.cornerRadius = 10.0
        cell.viewCorner.clipsToBounds = true
//        cell.viewCorner.layer.borderColor = UIColor.black.cgColor
//        cell.viewCorner.layer.borderWidth = 0.8
        cell.namelbl.text = ind.productname
        cell.img.kf.indicatorType = .activity
        cell.img.kf.setImage(with: URL(string:ind.image),placeholder: nil,options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
                
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
                
            }
        }
        cell.cartBtn.tag = indexPath.row
        cell.cartBtn.addTarget(self, action: #selector(addToCart(_:)), for: .touchUpInside)
        cell.deleteBtn.tag = indexPath.row
        cell.deleteBtn.addTarget(self, action: #selector(removeFromWishlist(_:)), for: .touchUpInside)
        cell.priceLbl.text = self.allWish[indexPath.row].quality + "/" + self.allWish[indexPath.row].weight
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 158
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selected = self.allWish[indexPath.row].productID
        self.performSegue(withIdentifier: "proceed", sender: self)
    }
}
