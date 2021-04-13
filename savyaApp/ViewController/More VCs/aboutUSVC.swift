//
//  aboutUSVC.swift
//  savyaApp
//
//  Created by Yash on 8/6/19.
//  Copyright © 2019 Yash Rathod. All rights reserved.
//

import Foundation
import UIKit

enum PageToOpen {
    static let buying = "BUYING"
    static let selling = "SELLING"
    static let returnPayment = "RETURN AND PAYMENT"
    static let termCondition = "TERM & CONDITION"
    static let aboutUs = "ABOUT US"
}

class aboutUSVC:RootBaseVC {
    
    @IBOutlet weak var txt1:UITextView!
    @IBOutlet weak var screenTitle:UILabel!
    @IBOutlet weak var act:UIActivityIndicatorView!
    var pageToOpen: String = ""
    let api = APIManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.screenTitle.text = pageToOpen
        self.act.startAnimating()
           
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getTerms()
    }
    func getTerms() {
        var apiName = ""
        if pageToOpen == PageToOpen.buying {
            apiName = NewAPI.buying
        } else if pageToOpen == PageToOpen.selling {
            apiName = NewAPI.selling
        }  else if pageToOpen == PageToOpen.returnPayment {
            apiName = NewAPI.returnPayment
        }  else if pageToOpen == PageToOpen.termCondition {
            apiName = NewAPI.termConditions
        }  else if pageToOpen == PageToOpen.aboutUs {
            apiName = NewAPI.aboutUs
        }
        api.getPrivacyPolicy(vc: self, apiName: apiName) { (aboutus) in
            let data = Data(aboutus.content.utf8)
            
            if let attributedString = try? NSMutableAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
                attributedString.addAttributes([.font: UIFont.systemFont(ofSize: 18)], range: NSRange(location: 0, length: attributedString.length))
                self.txt1.attributedText = attributedString
                self.act.stopAnimating()
                self.act.isHidden = true
            }
        }
    }
    @IBAction func back(_ sender:UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
