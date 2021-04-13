//
//  searchVC.swift
//  savyaApp
//
//  Created by Yash on 1/18/20.
//  Copyright © 2020 Yash Rathod. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import Kingfisher

class searchVC:UIViewController,UISearchBarDelegate {
    
    @IBOutlet weak var searchBar:UISearchBar!
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var act:UIActivityIndicatorView!
    var productsArray = [Searchproduct]()
    var sellerArray = [SearchSeller]()
    var id = 0
    
    var isMachinerySearch = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.act.isHidden = true
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "proceed" {
            let dvc = segue.destination as! productDetailNewVC
            dvc.productId = self.id
        } else if segue.identifier == "category" {
            let dvc = segue.destination as! catagoryVC
            dvc.id = self.id
        } else if segue.identifier == "machineDetail" {
            let dvc = segue.destination as! machineDetailsVC
            dvc.id = "\(self.id)"
        } else if segue.identifier == "allMachine" {
            let dvc = segue.destination as! allMachineVC
            dvc.isFromManufacturer = true
            dvc.subcata = self.id.toString()
        }
    }
    @IBAction func backBtn(_ sender:UIButton) {
        self.dismiss(animated: true, completion: nil)
        //self.navigationController?.popViewController(animated: true)
    }
    func getAllData(name:String) {
        self.act.isHidden = false
        self.act.startAnimating()
        if isMachinerySearch {
            APIManager.shareInstance.searchMachinery(name: name, vc: self) { (products, sellers) in
                self.productsArray.removeAll()
                self.productsArray = products
                self.sellerArray = sellers
                self.tableView.reloadData()
                self.act.isHidden = true
            }
        } else {
            APIManager.shareInstance.searchProduct(name: name, vc: self) { (products, sellers) in
                self.productsArray.removeAll()
                self.productsArray = products
                self.sellerArray = sellers
                self.tableView.reloadData()
                self.act.isHidden = true
            }
        }
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.getAllData(name: searchText)
    }
    
}
extension searchVC:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if productsArray.count > 0 && sellerArray.count > 0 {
            return 2
        } else if productsArray.count > 0 {
            return 1
        } else if sellerArray.count > 0 {
            return 1
        } else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if productsArray.count > 0 && sellerArray.count > 0 {
            if section == 0 {
                return sellerArray.count
            } else {
                return productsArray.count
            }
        } else if productsArray.count > 0 {
            return productsArray.count
        } else if sellerArray.count > 0 {
            return sellerArray.count
        } else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if productsArray.count > 0 || sellerArray.count > 0 {
            return 36
        } else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if productsArray.count > 0 || sellerArray.count > 0 {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 36))
            label.backgroundColor = .lightGray
            if productsArray.count > 0 && sellerArray.count > 0 {
                if section == 0 {
                    label.text = "   Sellers"
                } else {
                    label.text = "   Products"
                }
            } else if productsArray.count > 0 {
                label.text = "   Products"
            } else {
                label.text = "   Sellers"
            }
            label.textColor = .darkGray
            return label
        } else {
            return UIView()
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! searchCell
        var name = ""
        var code = ""
        var image = ""
        if productsArray.count > 0 || sellerArray.count > 0 {
            if productsArray.count > 0 && sellerArray.count > 0 {
                if indexPath.section == 0 {
                    name = self.sellerArray[indexPath.row].company_name
                    code = ""//self.sellerArray[indexPath.row].description
                    image = MainURL.mainurl+"img/users/"+self.sellerArray[indexPath.row].logo
                } else {
                    name = self.productsArray[indexPath.row].productname
                    code = self.productsArray[indexPath.row].productCode
                    image = self.productsArray[indexPath.row].image
                }
            } else if productsArray.count > 0 {
                name = self.productsArray[indexPath.row].productname
                code = self.productsArray[indexPath.row].productCode
                image = self.productsArray[indexPath.row].image
            } else {
                name = self.sellerArray[indexPath.row].company_name
                code = ""//self.sellerArray[indexPath.row].description
                image = MainURL.mainurl+"img/users/"+self.sellerArray[indexPath.row].logo
            }
        }
        cell.nameLbl.text = name
        cell.productidLbl.text = code
        
        let finalurl = image.replacingOccurrences(of: " ", with: "%20")
        cell.img.kf.indicatorType = .activity
        cell.img.kf.setImage(with: URL(string: finalurl),placeholder: nil,options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
                
            case .failure(let error):
                print(finalurl)
                print("Job failed: \(error.localizedDescription)")
            }
        }
               
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 91
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isMachinerySearch {
            if productsArray.count > 0 && sellerArray.count > 0 {
                if indexPath.section == 0 {
                    self.id = self.sellerArray[indexPath.row].manufacture_id
                    self.performSegue(withIdentifier: "allMachine", sender: self)
                } else {
                    self.id = self.productsArray[indexPath.row].productID
                    self.performSegue(withIdentifier: "machineDetail", sender: self)
                }
            } else if productsArray.count > 0 {
                self.id = self.productsArray[indexPath.row].productID
                self.performSegue(withIdentifier: "machineDetail", sender: self)
            } else {
                self.id = self.sellerArray[indexPath.row].manufacture_id
                self.performSegue(withIdentifier: "allMachine", sender: self)
            }
        } else {
            if productsArray.count > 0 && sellerArray.count > 0 {
                if indexPath.section == 0 {
                    self.id = self.sellerArray[indexPath.row].manufacture_id
                    self.performSegue(withIdentifier: "category", sender: self)
                } else {
                    self.id = self.productsArray[indexPath.row].productID
                    self.performSegue(withIdentifier: "proceed", sender: self)
                }
            } else if productsArray.count > 0 {
                self.id = self.productsArray[indexPath.row].productID
                self.performSegue(withIdentifier: "proceed", sender: self)
            } else {
                self.id = self.sellerArray[indexPath.row].manufacture_id
                self.performSegue(withIdentifier: "category", sender: self)
            }
        }
        
    }
}

