//
//  productDetails.swift
//  savyaApp
//
//  Created by Yash on 8/30/19.
//  Copyright © 2019 Yash Rathod. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import RealmSwift
import Toast_Swift
import AVKit

class machineDetailsVC:RootBaseVC {
    
    @IBOutlet weak var fileCollection:UICollectionView!
    @IBOutlet weak var similarCollection:UICollectionView!
    @IBOutlet weak var manuImg:UIImageView!
    @IBOutlet weak var manuNameLbl:UILabel!
    @IBOutlet weak var pNameLbl:UILabel!
    @IBOutlet weak var pPriceLbl:UILabel!
    @IBOutlet weak var pCodeLbl:UILabel!
    @IBOutlet weak var txt:UITextView!
    @IBOutlet weak var scrollView:UIScrollView!
    var similarArr = [MachineryProduct]()
    var filess = [Files]()
    
    var id = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.similarCollection.delegate = self
        self.fileCollection.delegate = self
        self.similarCollection.dataSource = self
        self.fileCollection.dataSource = self
        manuNameLbl.text = ""
        pNameLbl.text = ""
        pPriceLbl.text = ""
        pCodeLbl.text = ""
        txt.text = ""
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(self.id)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadAnimation()
        self.getAllData()
    }
    @IBAction func backBtn(_ sender:UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @objc func intrestedButton() {
        
        self.view.makeToast("Thanks for showing your intrest. Our team will contact you")
    }
    func addTwoButtons(withTitle: String) {
        if let button = self.view.viewWithTag(5555) as? UIButton {
            button.setTitle(withTitle, for: .normal)
            return
        }
        let theHeight = view.frame.size.height //grabs the height of your view
        
        let btn1 = UIButton(frame: CGRect(x: 0, y: theHeight - 60, width: self.view.frame.width , height: 60))
        btn1.tag = 5555
        
        btn1.backgroundColor = UIColor.init(named: "base_color")
        
        btn1.setTitle(withTitle, for: .normal)
        
        btn1.setTitleColor(.white, for: .normal)
        
        btn1.addTarget(self, action: #selector(intrestedButton), for: .touchUpInside)
        
        self.view.addSubview(btn1)
        
    }
    func getAllData() {
        APIManager.shareInstance.getmachineryDetail(id: self.id) { (machDetail, similar, file, manu) in
            self.removeAnimation()
            self.pNameLbl.text = machDetail.productName
            if machDetail.amount == "" || machDetail.amount == "0" {
                self.pPriceLbl.text = ""
                self.addTwoButtons(withTitle: "Ask Price")
            } else {
                self.pPriceLbl.text = "₹" + machDetail.amount
                self.addTwoButtons(withTitle: "Interested")
            }
            
            self.pCodeLbl.text = "Product Code: " + machDetail.productcode
         //   self.txt.text = machDetail.machineryDetailDescription
            let data = Data(machDetail.machineryDetailDescription.utf8)
            if let attributedString = try? NSMutableAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
                attributedString.addAttributes([.font: UIFont.systemFont(ofSize: 16)], range: NSRange(location: 0, length: attributedString.length))
                self.txt.attributedText = attributedString
            }
            
            //self.txt.setHTMLFromString(htmlText: machDetail.machineryDetailDescription)
            
            self.similarArr = similar
            self.similarCollection.reloadData()
            self.filess = file
            self.fileCollection.reloadData()
            self.manuNameLbl.text = manu.companyName
            self.manuImg.kf.indicatorType = .activity
            self.manuImg.kf.setImage(with: URL(string: manu.logo.replacingOccurrences(of: " ", with: "%20")),placeholder: nil,options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
                switch result {
                case .success(let value):
                    print("Task done for: \(value.source.url?.absoluteString ?? "")")
                    
                case .failure(let error):
                    print("Job failed: \(error.localizedDescription)")
                    
                }
            }
        }
    }
    func createThumbnailOfVideoFromRemoteUrl(url: String) -> UIImage? {
        let asset = AVAsset(url: URL(string: url)!)
        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        //Can set this to improve performance if target size is known before hand
        //assetImgGenerate.maximumSize = CGSize(width,height)
        let time = CMTimeMakeWithSeconds(1.0, preferredTimescale: 600)
        do {
            let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
            let thumbnail = UIImage(cgImage: img)
            return thumbnail
        } catch {
          print(error.localizedDescription)
          return nil
        }
    }
    
}
extension machineDetailsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.fileCollection {
            return self.filess.count
        }
        return self.similarArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.fileCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! imgCell
            let img = self.filess[indexPath.row].image
            if img.contains("mp4") {
                cell.img.image = self.createThumbnailOfVideoFromRemoteUrl(url: img )
            } else {
                print(img)
                cell.img.kf.indicatorType = .activity
                cell.img.kf.setImage(with: URL(string: (img ).replacingOccurrences(of: " ", with: "%20")),placeholder: nil,options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
                    switch result {
                    case .success(let value):
                        print("Task done for: \(value.source.url?.absoluteString ?? "")")
                        
                    case .failure(let error):
                        print("Job failed: \(error.localizedDescription)")
                        
                    }
                }
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! trendingProCell
             let onePro = self.similarArr[indexPath.row]
             
            cell.lblname.text = self.similarArr[indexPath.row].productName
            
             cell.img.kf.indicatorType = .activity
             cell.img.kf.setImage(with: URL(string: onePro.image.replacingOccurrences(of: " ", with: "%20")),placeholder: nil,options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
                 switch result {
                 case .success(let value):
                     print("Task done for: \(value.source.url?.absoluteString ?? "")")
                     
                 case .failure(let error):
                     print("Job failed: \(error.localizedDescription)")
                     
                 }
             }
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == similarCollection {
            self.id = "\(self.similarArr[indexPath.item].productID)"
            self.loadAnimation()
            self.getAllData()
            self.scrollView.contentOffset = .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.similarCollection {
            return CGSize.init(width: self.similarCollection.frame.width / 3, height: self.similarCollection.frame.height)
        } else {
            return CGSize.init(width: self.fileCollection.frame.width, height: self.fileCollection.frame.height)
        }
    }
}

extension UILabel {
    func setHTMLFromString(htmlText: String) {
        let modifiedFont = String(format:"<span style=\"font-family: '-apple-system', 'HelveticaNeue'; font-size: \(self.font!.pointSize)\">%@</span>", htmlText)

        let attrStr = try! NSAttributedString(
            data: modifiedFont.data(using: .unicode, allowLossyConversion: true)!,
            options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue],
            documentAttributes: nil)

        self.attributedText = attrStr
    }
}
extension UITextView {
    func setHTMLFromString(htmlText: String) {
        let modifiedFont = String(format:"<span style=\"font-family: '-apple-system', 'HelveticaNeue'; font-size: \(self.font!.pointSize)\">%@</span>", htmlText)

        let attrStr = try! NSAttributedString(
            data: modifiedFont.data(using: .unicode, allowLossyConversion: true)!,
            options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue],
            documentAttributes: nil)

        self.attributedText = attrStr
    }
}
