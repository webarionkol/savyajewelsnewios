//
//  hintVC.swift
//  savyaApp
//
//  Created by Yash on 1/19/20.
//  Copyright © 2020 Yash Rathod. All rights reserved.
//

import Foundation
import UIKit

class hintVC:UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var img1:UIImageView!
    @IBOutlet weak var img2:UIImageView!
    @IBOutlet weak var img3:UIImageView!
    @IBOutlet weak var img4:UIImageView!
    @IBOutlet weak var img5:UIImageView!
    @IBOutlet weak var img6:UIImageView!
    @IBOutlet weak var img7:UIImageView!
    @IBOutlet weak var collectionView:UICollectionView!
    @IBOutlet weak var img8:UIImageView!
    @IBOutlet weak var bottomVIew:UIView!
    
    let imgs = [UIImage(named: "h1"),UIImage(named: "h2"),UIImage(named: "h3"),UIImage(named: "h4"),UIImage(named: "h5"),UIImage(named: "h6"),UIImage(named: "h7"),UIImage(named: "h8")]
    
    let titleLbl = ["Gold","Diamonds","Platinum Collection","Silver Collection","Stone Collection","Machinery","Design","Packaging"]
    
    let subtitle = ["The easiest way to order Gold Jewellery from our best","Checkout world class diamond collection","We have large collection of platinum jewellery","We have large collection of silver jewellery","","","",""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.customization()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.bottomVIew.layer.addBorder(side: .top, thickness: 1, color: UIColor.white.cgColor)
    }
    func customization() {
        self.img1.layer.cornerRadius = self.img1.frame.height / 2
        self.img1.clipsToBounds = true
        
        self.img2.layer.cornerRadius = self.img2.frame.height / 2
        self.img2.clipsToBounds = true
        
        self.img3.layer.cornerRadius = self.img3.frame.height / 2
        self.img3.clipsToBounds = true
        
        self.img4.layer.cornerRadius = self.img4.frame.height / 2
        self.img4.clipsToBounds = true
        
        self.img5.layer.cornerRadius = self.img5.frame.height / 2
        self.img5.clipsToBounds = true
        
        self.img6.layer.cornerRadius = self.img6.frame.height / 2
        self.img6.clipsToBounds = true
        
        self.img7.layer.cornerRadius = self.img7.frame.height / 2
        self.img7.clipsToBounds = true
        
        self.img8.layer.cornerRadius = self.img8.frame.height / 2
        self.img8.clipsToBounds = true
    }
    @IBAction func nextBtn(_ sender:UIButton) {
        UserDefaults.standard.set(true, forKey: "first")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imgs.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! hintCell
//        cell.img.layer.cornerRadius = cell.img.frame.width / 2
//        cell.img.clipsToBounds = true
        
        cell.img.image = self.imgs[indexPath.row]
        cell.img.layer.cornerRadius = cell.img.frame.height / 2
        cell.img.clipsToBounds = true
        cell.lbl1.text = self.titleLbl[indexPath.item] + "\n" + self.subtitle[indexPath.item]
      //  cell.lbl2.text = self.subtitle[indexPath.item]
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width / 2 - 10, height: self.collectionView.frame.height / 4)
    }
}
