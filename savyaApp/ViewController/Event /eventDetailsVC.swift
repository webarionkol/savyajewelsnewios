//
//  eventDetailsVC.swift
//  savyaApp
//
//  Created by Yash on 7/28/19.
//  Copyright © 2019 Yash Rathod. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import Kingfisher

class eventDetailsVC:RootBaseVC {
    
    @IBOutlet weak var dateLbl:UILabel!
    @IBOutlet weak var timeLbl:UILabel!
    @IBOutlet weak var img:UIImageView!
    @IBOutlet weak var nameLbl:UILabel!
    @IBOutlet weak var descLbl:UILabel!
    @IBOutlet weak var addressLbl:UILabel!
    @IBOutlet weak var feeLbl:UILabel!
    @IBOutlet weak var registerBtn:UIButton!
    @IBOutlet weak var shareBtn:UIButton!
    var currentEvent:Event!
    var imgUrl = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerBtn.layer.cornerRadius = 6.0
        self.registerBtn.clipsToBounds = true
        
        self.registerBtn.layer.borderColor = UIColor.black.withAlphaComponent(0.5).cgColor
        self.registerBtn.layer.borderWidth = 1
        
        self.img.layer.cornerRadius = 6.0
        self.img.clipsToBounds = true
        
        self.shareBtn.layer.cornerRadius = 6.0
        self.shareBtn.clipsToBounds = true
        
        nameLbl.text = ""
        descLbl.text = ""
        addressLbl.text = ""
        feeLbl.text = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imgUrl = MainURL.mainurl + "img/events"
        guard let event = self.currentEvent else {
            return
        }
        let imgurl = event.img!
        let finalURl = self.imgUrl + "/" + imgurl
        self.dateLbl.text = event.date
        self.timeLbl.text = event.time
        self.nameLbl.text = event.eventName
        self.descLbl.text = event.descr
        self.addressLbl.text = event.address
        self.feeLbl.text = "Event Fees : \(event.event_type!)"
        self.img.kf.indicatorType = .activity
        self.img.kf.setImage(with: URL(string: finalURl),placeholder: nil,options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
                
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
                
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    @IBAction func shareBtn(_ sender:UIButton) {
        // text to share
        //let text = "\(String(describing: self.nameLbl.text))\n\(String(describing: self.addressLbl.text))\n\(String(describing: self.dateLbl.text))"
        let text = "\(self.nameLbl.text ?? "")\n\(self.addressLbl.text ?? "")\n\(self.dateLbl.text ?? "")"
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = sender // so that iPads won't crash
        
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    @IBAction func backBtn(_ sender:UIButton) {
        if self.navigationController?.viewControllers.count ?? 0 > 0 {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    @IBAction func registerBtn(_ sender:UIButton) {
        
    }
}
