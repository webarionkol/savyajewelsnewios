//
//  allProductVC.swift
//  savyaApp
//
//  Created by Yash on 8/5/19.
//  Copyright © 2019 Yash Rathod. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import RealmSwift
import SimpleCheckbox
import TTRangeSlider

class allProductVC:RootBaseVC,UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet weak var collection:UICollectionView!
    @IBOutlet weak var tableFilterName:UITableView!
    @IBOutlet weak var tableFilterValue:UITableView!
    @IBOutlet weak var filterView:UIView!
    @IBOutlet weak var documentView:UIView!
    var kyc:Kyc!
    var currentProfile:Profile!
    var arrRes = [Product]()
    var filteredProducts = [Product]()
    var subCategoryId = 0
    var categoryId = 0
    var selectedID = 0
    var sendid = 0
    var page = 1
    var totalPro = 0
    var orderby = ""//"ASC"
    var jewelery_for = [String]()
    var jewelery_type = [String]()
    var material = [String]()
    var purity = [String]()
    var subcategory = 1
    var tempfile:Files?
    var productFilters = [ProductFilters]()
    var selectedFilter: ProductFilters? = nil
    var isFilteredProducts = false
    var selectedProductFilters = [String:Any]()
    var isDiamondFilters = false
    var menuid = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getFilterData()
        self.documentView.isHidden = true
        self.getCurrentProfile()
        self.collection.showsVerticalScrollIndicator = false
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 02, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: self.view.frame.width / 2, height: 178)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        self.collection!.collectionViewLayout = layout
        tableFilterName.tableFooterView = UIView()
        tableFilterValue.tableFooterView = UIView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotificationPrev(notification:)), name: Notification.Name("go"), object: nil)
    }
    
    @objc private func methodOfReceivedNotificationPrev(notification: NSNotification) {
        print(notification)
        
        if let obj = notification.object as? [String:Any] {
            let id = obj["id"] as! Int
            self.sendid = id
            
            self.performSegue(withIdentifier: "shows", sender: self)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.filterView.isHidden = true
        self.loadAnimation()
        self.getAllData()
        
    }
    @IBAction func btnkyc(_ sender: Any) {
        self.performSegue(withIdentifier: "verify", sender: self)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(self.page)
    }
    func getCurrentProfile() {
        APIManager.shareInstance.getCurrentProfile(vc: self) { (pro,kyc,url) in
            self.currentProfile = pro
        }
    }
    func getFilterData() {
        APIManager.shareInstance.filterMenu(vc: self, categoryID: self.categoryId, subCategoryID: self.subCategoryId) { (filters) in
            self.productFilters.removeAll()
            if filters.count > 0 {
                let filtered = filters.filter({$0.name.lowercased().contains("diamond")})
                self.isDiamondFilters = filtered.count > 0 ? true : false
                if self.isDiamondFilters {
                    self.productFilters.append(filters[1])
                    self.productFilters.append(filters[0])
                    self.productFilters.append(filters[3])
                    self.productFilters.append(filters[4])
                    self.productFilters.append(filters[5])
                    self.productFilters.append(filters[2])
                } else {
                    if filters[0].name.lowercased().contains("gold") {
                        self.productFilters = filters
                        let item = self.productFilters.remove(at: 1)
                        self.productFilters.insert(item, at: 2)
                    } else {
                        self.productFilters = filters
                    }
                }
            }
            self.tableFilterName.reloadData()
        }
    }
    @objc func addToWishList(_ sender:UIButton) {
        APIManager.shareInstance.addwishlist(product_id: "\(sender.tag)", vc: self) { (response) in
            if response == "success" {
                self.collection.reloadData()
                self.addWishlistotrealm(id: sender.tag)
            } else {
                self.showAlert(titlee: "Message", message: "Something went wrong")
            }
        }
    }
   @objc func removeFromWishlist(_ sender:UIButton) {
    APIManager.shareInstance.removewishlist(product_id: "\(self.subCategoryId)", vc: self) { (response) in
            if response == "success" {
                self.removeFromRealm(id: sender.tag)
                self.collection.reloadData()
                self.view.makeToast("Product removed from wishlist")
                
            } else {
                self.showAlert(titlee: "Message", message: "Something went wrong")
            }
        }
    }
    @IBAction func cancelBtn(_ sender:UIButton) {
        self.resetAllFilters()
        self.page = 1
        getAllData()
        self.filterView.isHidden = true
    }
    func resetAllFilters() {
        self.productFilters = productFilters.map({
            var dict = $0
            dict.isSelected = false
            return dict
        })
        for (index, filter) in productFilters.enumerated() {
            var properties = filter.properties
            properties = properties.map({
                var dict = $0
                if dict.isWeightFilter {
                    dict.selectedMin = dict.min
                    dict.selectedMax = dict.max
                }
                dict.isSelected = false
                return dict
            })
            productFilters[index].properties = properties
        }
        self.selectedFilter = nil
        self.selectedProductFilters.removeAll()
        self.isFilteredProducts = false
    }
    @IBAction func applyBtn(_ sender:UIButton) {
        self.selectedProductFilters.removeAll()
        if self.selectedFilter != nil {
            if let index = self.productFilters.firstIndex(where: { $0.name == self.selectedFilter?.name}) {
                self.productFilters[index].properties = self.selectedFilter?.properties as! [FilterProperties]
            }
        }
        for item in self.productFilters {
            let filters = item.properties.filter({$0.isSelected == true})
            if item.filterName.lowercased() == "gold" || item.filterName.lowercased() == "gems" {
                if filters.count > 0 {
                    selectedProductFilters[item.filterName] = [filters.first?.title ?? ""]
                } else {
                    selectedProductFilters[item.filterName] = []
                }
            } else if item.filterName.lowercased() == "purity" {
                if filters.count > 0 {
                    selectedProductFilters[item.filterName] = filters.first?.title ?? ""
                } else {
                    selectedProductFilters[item.filterName] = []
                }
            } else if item.filterName.lowercased() == "clarity" || item.filterName.lowercased() == "color"  {
                if filters.count > 0 {
                    var values = [String]()
                    for item in filters {
                        values.append(item.title)
                    }
                    selectedProductFilters[item.filterName] = values
                } else {
                    selectedProductFilters[item.filterName] = []
                }
                
            } else if item.filterName.lowercased().contains("weight")  {
                let minValue = String(format: "%.2f", item.properties.first?.selectedMin ?? 0)
                let maxValue = String(format: "%.2f", item.properties.first?.selectedMax ?? 0)
                selectedProductFilters[item.filterName] = ["min": minValue, "max": maxValue]
                
            }
        }
        selectedProductFilters["subsubcategory"] = "\(self.subCategoryId)"
        self.isFilteredProducts = true
        self.page = 1
        self.getProductsUsingFilter()
    }
    func addWishlistotrealm(id:Int) {
        let realm = try! Realm()
        let w1 = WishlistRealm()
        w1.pid = id
        try! realm.write {
            realm.add(w1)
        }
    }
    func removeFromRealm(id:Int) {
        let realm = try! Realm()
        let predicate = NSPredicate(format: "pid == \(id)")
        if let product = realm.objects(WishlistRealm.self).filter(predicate).first {
            try! realm.write {
                realm.delete(product)
                print("realm removed")
            }
        }
    }
    func getAllData() {
        APIManager.shareInstance.getAllProducts(manufacture_id: menuid, subsubcategory: self.subCategoryId, page: self.page, orderby: "", vc: self) { (products,total) in
            if products.count > 0 {
                if self.page == 1 {
                    self.arrRes.removeAll()
                    self.filteredProducts.removeAll()
                }
                self.arrRes = products
                self.filteredProducts = products
                self.totalPro = total
                self.collection.reloadData()
                self.removeAnimation()
            } else {
                self.removeAnimation()
                //self.showAlert()
            }
            
        }
    }
    func addDatainArray(page:Int) {
        if (self.arrRes.count != self.totalPro) && (self.arrRes.count < self.totalPro) {
            APIManager.shareInstance.getAllProducts(manufacture_id: menuid, subsubcategory: self.subCategoryId, page: page, orderby: "", vc: self) { (products,total) in
                print(products.count)
                for i in products {
                    self.arrRes.append(i)
                }
                self.filteredProducts = self.arrRes
                if self.orderby != "" {
                    self.sortData()
                } else {
                    self.collection.reloadData()
                }
            }
        }
    }
    func getProductsUsingFilter() {
        self.filterView.isHidden = true
        APIManager.shareInstance.filterData(para: selectedProductFilters, subcategoryId: self.subCategoryId, page: self.page, vc: self) { (products,total) in
            print(products.count)
            if products.count == 0 {
                let alert = UIAlertController.init(title: "Message", message: "No Product found", preferredStyle: .alert)
                alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { (_) in
                    self.cancelBtn(UIButton())
                    return
                }))
                self.present(alert, animated: true, completion: nil)
            } else {
                if self.page == 1 {
                    self.arrRes.removeAll()
                    self.filteredProducts.removeAll()
                }
                self.arrRes = products
                self.filteredProducts = products
                self.totalPro = total
                self.collection.reloadData()
            }
        }
    }
    func addFilteredDatainArray(page:Int) {
        if (self.arrRes.count != self.totalPro) && (self.arrRes.count < self.totalPro) {
            APIManager.shareInstance.filterData(para: selectedProductFilters, subcategoryId: self.subCategoryId, page: self.page, vc: self) { (products, total) in
                print(products.count)
                for i in products {
                    self.arrRes.append(i)
                }
                self.filteredProducts = self.arrRes
                if self.orderby != "" {
                    self.sortData()
                } else {
                    self.collection.reloadData()
                }
                print(self.arrRes.count)
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show" {
            let dvc = segue.destination as! productDetailNewVC
            dvc.productId = self.sendid
            dvc.tempFile = self.tempfile
        }else if segue.identifier == "search" {
        }
        else if segue.identifier == "verify" {
        }
        else {
            let dvc = segue.destination as! productDetailNewVC
            dvc.productId = self.sendid
        }
    }
    func showAlert() {
        let alert = UIAlertController(title: "Message", message: "No Product Found", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func closeBtn(_ sender:UIButton) {
        self.documentView.isHidden = true
    }
    @IBAction func filterBtn(_ sender:UIButton) {
        self.resetAllFilters()
        if self.productFilters.count > 0 {
            self.filterView.isHidden = false
            self.tableFilterName.reloadData()
            self.tableFilterValue.reloadData()
        } else {
            let alert = UIAlertController(title: "", message: "No filter available for your selection", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    @IBAction func sortBtn(_ sender:UIButton) {
        let action = UIAlertController(title: "Please Select your sort filter", message: "", preferredStyle: .actionSheet)
        
        action.addAction(UIAlertAction(title: "Weight: High to low", style: .default, handler: { (_) in
            self.orderby = "DESC"
            self.sortData()
        }))
        action.addAction(UIAlertAction(title: "Weight: Low to high", style: .default, handler: { (_) in
            self.orderby = "ASC"
            self.sortData()
        }))
        if isDiamondFilters {
            action.addAction(UIAlertAction(title: "Diamond Weight: High to low", style: .default, handler: { (_) in
                self.orderby = "DESC-D"
                self.sortData()
            }))
            action.addAction(UIAlertAction(title: "Diamond Weight: Low to high", style: .default, handler: { (_) in
                self.orderby = "ASC-D"
                self.sortData()
            }))
        }
        action.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (_) in
            
        }))
        self.present(action, animated: true, completion: nil)
        
    }
    func sortData() {
        let sortedProducts = arrRes.sorted {
            //$0.weight < $1.weight
            if self.orderby == "ASC" || self.orderby == "DESC" {
                var weight = Double()
                if let gw = $0.proWeight["Gold"] as? String {
                    weight = weight+Double(gw)!
                }
                if let pw = $0.proWeight["Platinum"] as? String {
                    weight = weight+Double(pw)!
                }
                if let sw = $0.proWeight["Silver"] as? String {
                    weight = weight+Double(sw)!
                }
                
                if let dw = $0.proWeight["Diamond"] as? String {
                    weight = weight+(Double(dw)! * 0.2)
                }
                
                if let Stone = $0.proWeight["Stone"] as? String {
                    weight = weight+(Double(Stone)! * 0.2)
                }
                
                var weight2 = Double()
                if let gw = $1.proWeight["Gold"] as? String {
                    weight2 = weight2+Double(gw)!
                }
                if let pw = $1.proWeight["Platinum"] as? String {
                    weight2 = weight2+Double(pw)!
                }
                if let sw = $1.proWeight["Silver"] as? String {
                    weight2 = weight2+Double(sw)!
                }
                
                if let dw = $1.proWeight["Diamond"] as? String {
                    weight2 = weight2+(Double(dw)! * 0.2)
                }
                
                if let Stone = $1.proWeight["Stone"] as? String {
                    weight2 = weight2+(Double(Stone)! * 0.2)
                }
                
                /*//let item1 = $0.proWeight.keys
                let keyValue1: String = $0.proWeight["Gold"] as! String
                let weight1 = (keyValue1 as NSString).floatValue
                
                //let item2 = $1.proWeight.keys
                let keyValue2: String = $1.proWeight["Gold"] as! String
                let weight2 = (keyValue2 as NSString).floatValue*/
                if self.orderby == "ASC" {
                    return weight < weight2
                } else {
                    return weight > weight2
                }
            } else {
                let keyValue1: String = $0.proWeight["Diamond"] as! String
                let weight1 = (keyValue1 as NSString).floatValue
                
                //let item2 = $1.proWeight.keys
                let keyValue2: String = $1.proWeight["Diamond"] as! String
                let weight2 = (keyValue2 as NSString).floatValue
                
                if self.orderby == "ASC-D" {
                    return weight1 < weight2
                } else {
                    //DESC-D
                    return weight1 > weight2
                }
            }
        }
        self.filteredProducts = sortedProducts
        self.collection.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.collection.contentOffset = .zero
        }
    }
    
    @IBAction func back(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.filteredProducts.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! productCell
        let ind = self.filteredProducts[indexPath.row]
        let urll = "\(MainURL.mainurl)img/product/"
        let imgurl = ind.imgs!
        let finalurl = urll + imgurl
        
        if WishlistRealm.sharedInstace.getAllId().contains(ind.id) {
            cell.favButton.setImage(UIImage(named: "likefilled"), for: .normal)
            cell.favButton.addTarget(self, action: #selector(removeFromWishlist), for: .touchUpInside)
        } else {
            cell.favButton.setImage(UIImage(named: "like"), for: .normal)
            cell.favButton.addTarget(self, action: #selector(addToWishList(_:)), for: .touchUpInside)
        }
        cell.diamondLbl.text = ""
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            cell.shadowView.dropShadow(color: UIColor.black, opacity: 0.2, offSet: CGSize.init(width: -1, height: 1), radius: 5, scale: true)
        }

        cell.view1.layer.cornerRadius = 10
        cell.view1.clipsToBounds = true
        cell.favButton.tag = ind.id!
        cell.img.kf.indicatorType = .activity
        if let encodedString  = finalurl.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed), let url = URL(string: encodedString) {
            cell.img.kf.setImage(with: url,placeholder: nil,options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
                switch result {
                case .success(let value):
                    print("Task done for: \(value.source.url?.absoluteString ?? "")")
                    
                case .failure(let error):
                    print(finalurl)
                    print("Job failed: \(error.localizedDescription)")
                    
                }
            }
        }
        if ind.product_category == "GOLD JEWELLERY" || ind.product_category == "GOLD CHAINS" {
            print(ind.proWeight)
            //let gq = ind.proQuality["Gold"] as? String ?? ""
            let gw = ind.proWeight["Gold"] as? String ?? "0.0"
            let doubleStr = String(format: "%.3f", gw.toDouble())
            
            let ktw = ind.proQuality["Gold"]  as? String ?? ""
            
            
            cell.originalPriceLbl.text = "\(doubleStr)" + " g / \(ktw)"
        } else if ind.product_category == "DIAMOND JEWELLERY" {
           // let dq = ind.proQuality["Diamond"] as? String ?? ""
            let dct = ind.proWeight["Diamond"] as? String ?? ""
            let doubleStr = String(format: "%.3f", dct.toDouble())
            
            cell.diamondLbl.text = ""
            cell.ctLbl.text = doubleStr + " Ct"
            
            
            
            var weight = Double()
            if let gw = ind.proWeight["Gold"] as? String {
                //let gq = ind.proQuality["Gold"] as! String
                weight = weight+Double(gw)!
               // cell.originalPriceLbl.text = gw + " g"
            }
            if let pw = ind.proWeight["Platinum"] as? String {
                weight = weight+Double(pw)!
                //let pq = ind.proQuality["Gold"] as! String
                cell.originalPriceLbl.text = pw + " g"
            }
            if let sw = ind.proWeight["Silver"] as? String {
                weight = weight+Double(sw)!
                //let sq = ind.proQuality["Gold"] as! String
              //  cell.originalPriceLbl.text = sw + " g"
            }
            
            if let dw = ind.proWeight["Diamond"] as? String {
                weight = weight+(Double(dw)! * 0.2)
                //let sq = ind.proQuality["Gold"] as! String
              //  cell.originalPriceLbl.text = sw + " g"
            }
            
            if let Stone = ind.proWeight["Stone"] as? String {
                weight = weight+(Double(Stone)! * 0.2)
                //let sq = ind.proQuality["Gold"] as! String
              //  cell.originalPriceLbl.text = sw + " g"
            }
            
            let we = String(format: "%.3f", weight)
            cell.originalPriceLbl.text = we + " g"
            
        } else if ind.product_category == "PLATINUM JEWELLERY" {
            
//            let gw = ind.proWeight["Platinum"] as! String
//            cell.originalPriceLbl.text = "\(gw)" + " g"
            
            if let dct = ind.proWeight["Diamond"] as? String {
                let doubleStr = String(format: "%.3f", dct.toDouble())
                
                
                cell.ctLbl.text = doubleStr + " Ct"
            }
        
            var weight = Double()
            if let gw = ind.proWeight["Gold"] as? String {
                //let gq = ind.proQuality["Gold"] as! String
                weight = weight+Double(gw)!
               // cell.originalPriceLbl.text = gw + " g"
            }
            if let pw = ind.proWeight["Platinum"] as? String {
                weight = weight+Double(pw)!
                //let pq = ind.proQuality["Gold"] as! String
                cell.originalPriceLbl.text = pw + " g"
            }
            if let sw = ind.proWeight["Silver"] as? String {
                weight = weight+Double(sw)!
                //let sq = ind.proQuality["Gold"] as! String
              //  cell.originalPriceLbl.text = sw + " g"
            }
            
            if let dw = ind.proWeight["Diamond"] as? String {
                weight = weight+(Double(dw)! * 0.2)
                //let sq = ind.proQuality["Gold"] as! String
              //  cell.originalPriceLbl.text = sw + " g"
            }
            
            if let Stone = ind.proWeight["Stone"] as? String {
                weight = weight+(Double(Stone)! * 0.2)
                //let sq = ind.proQuality["Gold"] as! String
              //  cell.originalPriceLbl.text = sw + " g"
            }
            
            let quality = ind.proQuality["Platinum"] as? String
            
            let we = String(format: "%.3f", weight)
            cell.originalPriceLbl.text = we + " g /\(quality!)"
        }
        else if ind.product_category  == "SILVER JEWELLERY" {
            print(ind.proWeight)
            //let gq = ind.proQuality["Gold"] as? String ?? ""
            let gw = ind.proWeight["Silver"] as? String ?? "0.0"
            let doubleStr = String(format: "%.3f", gw.toDouble())
            
            let ktw = ind.proQuality["Silver"]  as? String ?? ""
            
            
            cell.originalPriceLbl.text = "\(doubleStr)" + " g / \(ktw)"
        }
       // cell.originalPriceLbl.text = ind.weight + "g" + "/" + ind.quality

        return cell
    }
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if isKeyPresentInUserDefaults(key: "document_verifiedKyc") {
            if UserDefaults.standard.string(forKey: "document_verifiedKyc") == "0" ||   UserDefaults.standard.string(forKey: "document_verifiedKyc") == "1" {
                self.documentView.isHidden = false
            }else {
                self.sendid = self.filteredProducts[indexPath.row].id
                let urll = "\(MainURL.mainurl)img/product/"
                let imgurl = self.filteredProducts[indexPath.row].imgs!
                let finalurl = urll + imgurl
                
                self.tempfile = Files.init(id: self.filteredProducts[indexPath.row].id, productID: self.filteredProducts[indexPath.row].id.toString(), image: finalurl.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!, type: 1, createdAt: "", updatedAt: "", thumbnail: "")
                self.performSegue(withIdentifier: "show", sender: self)
            }
        }else {
            self.documentView.isHidden = false
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if self.filteredProducts.count > 8 {
            if isFilteredProducts == false {
                if indexPath.item == self.filteredProducts.count - 1 {
                    self.page += 1
                    self.addDatainArray(page:self.page)
                }
            } else {
                if indexPath.item == self.filteredProducts.count - 1 {
                    self.page += 1
                    self.addFilteredDatainArray(page: self.page)
                }
            }
            
        }
    }
}
extension allProductVC:UITableViewDelegate,UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableFilterName {
            return self.productFilters.count
        } else {
            return self.selectedFilter?.properties.count ?? 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableFilterName {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! filterMenuNameCell
            cell.titleLabel.text = self.productFilters[indexPath.row].name
            if self.productFilters[indexPath.row].isSelected {
                cell.titleLabel.textColor = #colorLiteral(red: 0.9019607843, green: 0.4549019608, blue: 0.1764705882, alpha: 1)
            } else {
                cell.titleLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                cell.shadowView.addShadowWithCorner(corner: 4)
            }
            return cell
        } else {
            var superCell = UITableViewCell()
            if selectedFilter?.name.lowercased().contains("weight") ?? false {
                let cell = tableView.dequeueReusableCell(withIdentifier: "WeightCell") as! ProductFilterSliderCell
                cell.titleLabel.text = "Select \(self.selectedFilter?.name ?? "") Range"
                
                cell.wightSlider.minValue = self.selectedFilter?.properties[indexPath.row].min ?? 0
                cell.wightSlider.maxValue = self.selectedFilter?.properties[indexPath.row].max ?? 0
                cell.wightSlider.selectedMinimum = self.selectedFilter?.properties[indexPath.row].selectedMin ?? 0
                cell.wightSlider.selectedMaximum = self.selectedFilter?.properties[indexPath.row].selectedMax ?? 0
                cell.wightSlider.step = 0.1
                cell.wightSlider.delegate = self
                
                let minValue = String(format: "%.2f", cell.wightSlider.selectedMinimum)
                let maxValue = String(format: "%.2f", cell.wightSlider.selectedMaximum)
                cell.descriptionLabel.text = "Min: \(minValue) g - Max: \(maxValue) g"
                
                cell.descriptionLabel.tag = 1000+indexPath.row
                cell.wightSlider.tag = 2000+indexPath.row
                superCell = cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! filterMenuValueCell
                cell.lbl1.text = self.selectedFilter?.properties[indexPath.row].title
                cell.checkbox.checkmarkStyle = .tick
                cell.checkbox.borderLineWidth = 2
                cell.checkbox.borderCornerRadius = 2
                cell.checkbox.checkmarkSize = 0.5
                cell.checkbox.checkmarkColor = #colorLiteral(red: 0.08235294118, green: 0.6039215686, blue: 0.5490196078, alpha: 1)
                cell.checkbox.checkedBorderColor = #colorLiteral(red: 0.08235294118, green: 0.6039215686, blue: 0.5490196078, alpha: 1)
                cell.checkbox.uncheckedBorderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
                cell.checkbox.isUserInteractionEnabled = false
                
                cell.checkbox.tag = indexPath.row
                if self.selectedFilter?.properties[indexPath.row].isSelected ?? false {
                    cell.checkbox.isChecked = true
                } else {
                    cell.checkbox.isChecked = false
                }
                superCell = cell
            }
            
            return superCell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tableFilterName {
            if self.selectedFilter != nil {
                if let index = self.productFilters.firstIndex(where: { $0.name == self.selectedFilter?.name}) {
                    self.productFilters[index].properties = self.selectedFilter?.properties as! [FilterProperties]
                }
            }
            self.productFilters = productFilters.map({
                var dict = $0
                dict.isSelected = false
                return dict
            })
            self.productFilters[indexPath.row].isSelected = true
            self.tableFilterName.reloadData()
            self.selectedFilter = self.productFilters[indexPath.row]
            DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                self.tableFilterValue.reloadData()
            }
        } else {
            if selectedFilter?.name.lowercased() == "gems" || selectedFilter?.name.lowercased().contains("gold") == true || selectedFilter?.name.lowercased().contains("purity") == true {
                //Single Selection
                if self.selectedFilter?.properties[indexPath.row].isSelected == true {
                    self.selectedFilter?.properties[indexPath.row].isSelected = false
                } else {
                    if var properties = selectedFilter?.properties {
                        properties = properties.map({
                            var dict = $0
                            dict.isSelected = false
                            return dict
                        })
                        properties[indexPath.row].isSelected = true
                        self.selectedFilter?.properties = properties
                    }
                }
                self.tableFilterValue.reloadData()
            } else {
               //Multi Selection
                if let selection = self.selectedFilter?.properties[indexPath.row].isSelected {
                    self.selectedFilter?.properties[indexPath.row].isSelected = !selection
                }
                self.tableFilterValue.reloadData()
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension allProductVC: TTRangeSliderDelegate {
    func rangeSlider(_ sender: TTRangeSlider!, didChangeSelectedMinimumValue selectedMinimum: Float, andMaximumValue selectedMaximum: Float) {
        if let descriptionLabel = self.view.viewWithTag(sender.tag-1000) as? UILabel {
            let index = sender.tag-2000
            self.selectedFilter?.properties[index].selectedMin = selectedMinimum
            self.selectedFilter?.properties[index].selectedMax = selectedMaximum
            let minValue = String(format: "%.2f", selectedMinimum)
            let maxValue = String(format: "%.2f", selectedMaximum)
            descriptionLabel.text = "Min: \(minValue) g - Max: \(maxValue) g"
        }
    }
}
