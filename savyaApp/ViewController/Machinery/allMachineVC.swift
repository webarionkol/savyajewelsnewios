//
//  allMachineVC.swift
//  savyaApp
//
//  Created by Yash on 2/12/20.
//  Copyright © 2020 Yash Rathod. All rights reserved.
//

import Foundation
import UIKit

class allMachineVC:RootBaseVC {
    
    @IBOutlet weak var collection:UICollectionView!
    var allProd = [MachineryProduct]()
    var subcata = ""
    var sendid = ""
    var isFromManufacturer: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 02, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: self.view.frame.width / 2, height: 178)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        self.collection!.collectionViewLayout = layout*/
        self.collection.delegate = self
        self.collection.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getAllData()
        
    }
    @IBAction func backBtn(_ sender:UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    func dismisAlert() {
        let alert = UIAlertController.init(title: "Message", message: "No Product Found", preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { (_) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    func getAllData() {
        APIManager.shareInstance.getMachineList(subcata: self.subcata, isFromManufacturer: self.isFromManufacturer) { (all) in
            self.allProd = all
            self.collection.reloadData()
            if self.allProd.count == 0 {
                self.dismisAlert()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "proceed" {
            let dvc = segue.destination as! machineDetailsVC
            dvc.id = self.sendid
        }
    }
}
extension allMachineVC:UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.allProd.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! productCell
        let ind = self.allProd[indexPath.item]

        cell.originalPriceLbl.text = ind.productName
        
        cell.view1.cornerRadius(radius: 8)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            cell.shadowView.dropShadow(color: UIColor.black, opacity: 0.2, offSet: CGSize.init(width: -1, height: 1), radius: 5, scale: true)
        }
        //cell.shadowView.dropShadow(color: .lightGray, opacity: 0.5, offSet: CGSize.init(width: -0.5, height: 0.5), radius: 2, scale: true)
        
        cell.img.kf.indicatorType = .activity
        cell.img.contentMode = .scaleAspectFit
        
        cell.img.kf.setImage(with: URL(string: ind.image.replacingOccurrences(of: " ", with: "%20")),placeholder: nil,options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
                
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
                
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(self.allProd[indexPath.row].productID)
        self.sendid = self.allProd[indexPath.row].productID.toString()
        self.performSegue(withIdentifier: "proceed", sender: self)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width/2-5, height: 185)
    }
}
