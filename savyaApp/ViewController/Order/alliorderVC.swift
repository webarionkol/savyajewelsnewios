//
//  alliorderVC.swift
//  savyaApp
//
//  Created by Yash on 1/5/20.
//  Copyright © 2020 Yash Rathod. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import AFDateHelper

class allOrderVC:RootBaseVC {
    
    @IBOutlet weak var tableView:UITableView!
    var allOrders = [Order]()
    var page = 1
    var total = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadAnimation()
        self.getAllData()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "order" {
            let dvc = segue.destination as! orderDetailVC
            let ind = self.tableView.indexPathForSelectedRow
            dvc.tempOrder = self.allOrders[ind!.row]
        }
    }
    @IBAction func backBtn(_ sender:UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @objc func reorderBtn(_ sender:UIButton) {
        /*var dataToSend = [[String:Any]]()
        var assetes = [[String:Any]]()
        let order = self.allOrders[sender.tag]
        for i in order.product {
            
            for j in i.assets {
                assetes.append(["weight" : j.weight,"materialType":j.materialType,"makingCharge":j.makingCharge,"option":j.options,"metal":j.metal,"productId":j.product_id])
            }
            dataToSend.append(["count":i.count,"productId":i.productID,"userid":Mobile.getUid(),"category":i.category,"subCategory":i.subCategory,"subSubCategory":i.subSubCategory,"productCode":i.productCode,"productName":i.productName,"description":i.welcomeDescription,"productType":i.productType,"assests":assetes])
        }
       
        
        APIManager.shareInstance.addToCart(data: dataToSend, vc: self) { (response) in
            print(response)
            self.performSegue(withIdentifier: "cart", sender: self)
        }*/
    }
    func getAllData() {
        APIManager.shareInstance.getAllOrder(page: self.page, vc: self) { (orderss, totla) in
            self.allOrders = orderss
            self.total = totla
            if self.allOrders.count == 0 {
                self.removeAnimation()
                self.showAlertDismiss()
            } else {
                self.tableView.reloadData()
                self.removeAnimation()
            }
        }
    }
    func showAlertDismiss() {
        let alert = UIAlertController.init(title: "Message", message: "No Orders", preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { (_) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension allOrderVC:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allOrders.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! orderCell
        cell.view1.cornerRadius(radius: 8)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            cell.shadowView.dropShadow(color: UIColor.black, opacity: 0.2, offSet: CGSize.init(width: -1, height: 1), radius: 8, scale: true)
        }
        let indRes = self.allOrders[indexPath.row]
        //let data = Date(fromString: indRes.createdAt, format: .isoDateTime)
    
        let dateFormatter = DateFormatter()
        //dateFormatter.isLenient = true
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        dateFormatter.calendar = Calendar(identifier: .iso8601)
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let orderDate = dateFormatter.date(from:indRes.createdAt)
        
        dateFormatter.dateFormat = "h:mm a"
        let formttedTime = dateFormatter.string(from: orderDate!)
        
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        let formttedDate = dateFormatter.string(from: orderDate!)

        
        cell.reorderBtn.tag = indexPath.row
        cell.reorderBtn.addTarget(self, action: #selector(reorderBtn(_:)), for: .touchUpInside)
        cell.orideridLbl.text = "Order id:- \(indRes.orderID)"
        cell.totalAmountLbl.text = "₹ " + indRes.finalTotal
        cell.countLbl.text = "\(indRes.product.count)"
        cell.timeLbl.text = "Time: \(formttedTime)"//orderDate?.toString(style: .medium)
        cell.dateLbl.text = formttedDate//orderDate?.toString(style: .ordinalDay)
        cell.img.kf.indicatorType = .activity
        if let encodedString  = indRes.product[0].image.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed), let url = URL(string: encodedString) {
            cell.img.kf.setImage(with: url,placeholder: nil,options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "order", sender: self)
    }
}
