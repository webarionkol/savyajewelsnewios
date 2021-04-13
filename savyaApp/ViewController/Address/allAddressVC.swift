//
//  allAddressVC.swift
//  savyaApp
//
//  Created by Yash on 8/12/19.
//  Copyright © 2019 Yash Rathod. All rights reserved.
//

import Foundation
import UIKit
import Floaty
import Alamofire

import RealmSwift

class allAddressVC:RootBaseVC,UITableViewDelegate,UITableViewDataSource,FloatyDelegate {
    
    @IBOutlet weak var tablee:UITableView!
    var arrRes = [Address]()
    let realm = try! Realm()
    var selectedInd = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tablee.delegate = self
        self.tablee.dataSource = self
        let floaty = Floaty()
        floaty.fabDelegate = self
        floaty.buttonColor = UIColor.init(red: 187/255, green: 157/255, blue: 87/255, alpha: 1.0)
        self.view.addSubview(floaty)
        
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadAnimation()
        self.getAllAddress()
    }
    func getAllAddress() {
        APIManager.shareInstance.getAllAddress(vc: self) { (all) in
            self.arrRes = all
            if self.arrRes.count == 0 {
                self.showAlert(titlee: "Message", message: "No Address found\nAdd New Address")
            }
            self.tablee.reloadData()
            self.removeAnimation()
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "address" {
            _ = segue.destination as! addressBookVC
        } else if segue.identifier == "edit" {
            let dvc = segue.destination as! addressBookVC
          //  let selected = self.tablee.indexPathForSelectedRow
            dvc.addr = self.arrRes[self.selectedInd]
        }
    }
    func deleteBtn(id:String) {
        APIManager.shareInstance.deleteAddress(addr_id: id, vc: self) { (response) in
            if response == "success" {
                self.getAllAddress()
            }
        }
    }
    @IBAction func back(_ sender:UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @objc func openActionSheet(_ sender:UIButton) {
        let action = UIAlertController(title: "Message", message: "Please Select Any One Option", preferredStyle: .actionSheet)
        if let presenter = action.popoverPresentationController {
            presenter.sourceView = sender
            presenter.sourceRect = sender.bounds
        }
        action.addAction(UIAlertAction(title: "Edit", style: .default, handler: { (_) in
            self.selectedInd = sender.tag
            self.performSegue(withIdentifier: "edit", sender: self)
        }))
        action.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (_) in
            self.deleteBtn(id: self.arrRes[sender.tag].id.toString())
        }))
        action.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (_) in
            
        }))
        self.present(action, animated: true, completion: nil)
    }
    func emptyFloatySelected(_ floaty: Floaty) {
        if self.arrRes.count == 3 {
            self.showAlert(titlee: "Message", message: "Sorry You Cannot Add More Than Three Address")
        } else {
            self.performSegue(withIdentifier: "address", sender: self)
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.arrRes.count == 0 {
            return 1
        } else {
            return self.arrRes.count
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.arrRes.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "emptyCell") as! addressCellEmpty
            //cell.img.image = UIImage(named: "noaddress")
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! addressCellList
            let indRes = self.arrRes[indexPath.row]
            let fname = indRes.first
            let lname = indRes.last
            let address = indRes.address
            let number = indRes.mobileno
            let formattedString = NSMutableAttributedString()
             formattedString
                .bold(fname + lname + "\n")
                .normal(address + "\n" + "\n")
                .normal(number)
            cell.txt1.attributedText = formattedString
            cell.btn1.addTarget(self, action: #selector(openActionSheet(_:)), for: .touchUpInside)
            cell.btn1.tag = indexPath.row
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.arrRes.count == 0 {
            return self.tablee.frame.height
        } else {
            return UITableView.automaticDimension
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let indRes = self.arrRes[indexPath.row]
        let fname = indRes.first
        let lname = indRes.last
        let address = indRes.address
        let number = indRes.mobileno
        let id = indRes.id
        
        
        let tempdic = ["fname":fname,"lname":lname,"address":address,"number":number,"id":id] as! [String:Any]
        NotificationCenter.default.post(name: NSNotification.Name("address"), object: tempdic)
        dismiss(animated: true, completion: nil)
//        if self.arrRes.count == 0 {
//
//        } else {
//           self.performSegue(withIdentifier: "edit", sender: self)
//        }
        
    }
}
