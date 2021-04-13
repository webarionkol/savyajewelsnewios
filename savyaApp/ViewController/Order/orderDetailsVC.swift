//
//  orderDetailsVC.swift
//  savyaApp
//
//  Created by Yash on 1/6/20.
//  Copyright © 2020 Yash Rathod. All rights reserved.
//

import Foundation
import UIKit
//import VerticalSteppedSlider

class orderDetailVC:RootBaseVC,UITableViewDelegate,UITableViewDataSource {
    
    var tempOrder:Order!
   
    @IBOutlet weak var tableView:UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    @IBAction func backBtn(_ sender:UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tempOrder.product.count + 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellamount") as! orderCell1
            cell.lblAmount.text = "Total Amount:- ₹" + self.tempOrder.finalTotal
            cell.lblData.text = "Date:- " + self.tempOrder.createdAt
            cell.lblOrderiD.text = "OrderId :- " + String(self.tempOrder.orderID)
            return cell
        } else if indexPath.row == self.tempOrder.product.count + 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellslider") as! orderSLiderCell
            cell.slider.isUserInteractionEnabled = false
            /*if self.tempOrder.orderStatus == "New" {
                cell.slider.value = 1
            } else if self.tempOrder.orderStatus == "Pending" {
                cell.slider.value = 3
            } else if self.tempOrder.orderStatus == "Processing" {
                cell.slider.value = 2
            } else if self.tempOrder.orderStatus == "Ready" {
                cell.slider.value = 4
            } else if self.tempOrder.orderStatus == "Delivered" {
                cell.slider.value = 5
            }*/
            if self.tempOrder.orderStatus.lowercased() == "processing" || self.tempOrder.orderStatus.lowercased() == "new" {
                cell.slider.value = 1
            } else if self.tempOrder.orderStatus.lowercased() == "accepted" || self.tempOrder.orderStatus.lowercased() == "accept" {
                cell.slider.value = 2
            } else if self.tempOrder.orderStatus.lowercased() == "delivered" {
                cell.slider.value = 3
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! orderDetailCell
             let product = self.tempOrder.product[indexPath.row - 1]
             
             cell.nameLbl.text = product.productName
            cell.quantityLbl.text = "Quantity:- " + product.count
            cell.amountlbl.text =  "Amount:- " + product.productTotal
             cell.makingChargeLbl.text = "Making Charge:- " + product.totalMakingCharge
             
            if product.assets.count == 0 {
                cell.goldWeight.isHidden = true
                cell.stoneWeightLbl.isHidden = true
            } else {
                if product.assets.count == 1 {
                    let parameter = product.assets[0].metal == "Gold" ? "g" : " Ct"
                    cell.goldWeight.text = "\(product.assets[0].metal) Weight:- " + product.assets[0].weight + parameter
                    cell.goldWeight.isHidden = false
                    cell.stoneWeightLbl.isHidden = true
                } else {
                    let parameter1 = product.assets[0].metal == "Gold" ? "g" : " Ct"
                    let parameter2 = product.assets.last!.metal == "Gold" ? "g" : " Ct"
                    cell.goldWeight.text = "\(product.assets[0].metal) Weight:- " + product.assets[0].weight + parameter1
                    cell.stoneWeightLbl.text = "\(product.assets.last!.metal) Weight:- " + product.assets.last!.weight + parameter2
                    cell.goldWeight.isHidden = false
                    cell.stoneWeightLbl.isHidden = false
                }
            }
            if product.color != "" {
                cell.colorLbl.text = "Color:- \(product.color)"
              cell.colorLbl.isHidden = false
            } else {
               cell.colorLbl.isHidden = true
            }
            if product.size != 0 {
                cell.sizeLbl.text = "Size:- \(product.size)"
              cell.sizeLbl.isHidden = false
            } else {
               cell.sizeLbl.isHidden = true
            }

             if let encodedString  = product.image.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed), let url = URL(string: encodedString) {
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
        
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 128
        } else if indexPath.row == self.tempOrder.product.count + 1 {
            return 93
        } else {
            return UITableView.automaticDimension
        }
        
    }
}
