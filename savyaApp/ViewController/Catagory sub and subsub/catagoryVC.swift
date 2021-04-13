//
//  catagoryVC.swift
//  savyaApp
//
//  Created by Yash on 3/22/20.
//  Copyright © 2020 Yash Rathod. All rights reserved.
//

import UIKit
import Alamofire


class catagoryVC: RootBaseVC,UITableViewDelegate,UITableViewDataSource ,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
   
    @IBOutlet weak var collectionView:UICollectionView!
    @IBOutlet weak var tablee:UITableView!
    var arrRes = [CategoryNew]()
    var allBanner = [Banner]()
    var id = 0
    var ind = IndexPath(row: 0, section: 0)
    var sendid = 0
    var manuId = ""
    let bannerimgs = [UIImage(named: "1b"),UIImage(named: "2b"),UIImage(named: "3b")]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadAnimation()
        self.getAllData()
        self.getAllBanner()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "subcata" {
            let dvc = segue.destination as! subCategoryVC
            dvc.id = self.sendid
            dvc.manuid = self.id.toString()
        }
    }
    @objc func scrollToNextCell2() {
        let ind2 = self.ind.row + 1
        self.ind.row = ind2
        let finalindd = IndexPath(row: ind2, section: 0)
        self.collectionView.scrollToItem(at: finalindd, at: .right, animated: true)
    }
    @IBAction func back(_ sender:UIButton) {
//        if let viewControllers = navigationController?.viewControllers {
//            for viewController in viewControllers {
//
//                if viewController.isKind(of: subCategoryVC.self) {
//                    self.navigationController?.popViewController(animated: true)
//                    break
//                }
//            }
//        }
        //self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    func alertShow() {
        let alert = UIAlertController.init(title: "Message", message: "Sorry No Product Found", preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { (_) in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    func startTimer2() {
        _ = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(scrollToNextCell2), userInfo: self, repeats: true)
    }
    func getAllData() {
        APIManager.shareInstance.getAllCategory(manufacture_id: self.id.toString(), vc: self) { (cata) in
            self.arrRes = cata
            
            self.tablee.reloadData()
            self.removeAnimation()
            if self.arrRes.count == 0 {
                self.alertShow()
            }
        }
    }
    func getAllBanner() {
        APIManager.shareInstance.getAllBanners(user_id: self.id.toString(), type: "3", vc: self) { (all) in
            if all.count > 0 {
                self.allBanner = all
                self.collectionView.reloadData()
                self.startTimer2()
            } else {
                self.collectionView.visiblity(gone: true)
            }
            
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
            let cellEmpty = tableView.dequeueReusableCell(withIdentifier: "empty") as! emptyCell
            return cellEmpty
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! subSubCell
            cell.btn.cornerRadius(radius: 4)
            cell.btn.setTitle("   \(self.arrRes[indexPath.row].category)", for: .normal)
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.arrRes.count == 0 {
            return self.tablee.frame.height
        } else {
            return 50
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.arrRes.count == 0 {
            
        } else {
            self.sendid = self.arrRes[indexPath.row].id
            self.performSegue(withIdentifier: "subcata", sender: self)
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if self.allBanner.count == 0 {
            return 0
        }
        return 9000
    }
       
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! bannerImgCell
        let itemToShow = self.allBanner[indexPath.row % self.allBanner.count].image
       
        cell.img.kf.indicatorType = .activity
        cell.img.kf.setImage(with: URL(string: itemToShow),placeholder: nil,options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
                
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
                
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: self.collectionView.frame.height)
    }
}
