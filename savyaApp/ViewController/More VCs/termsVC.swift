//
//  termsVC.swift
//  savyaApp
//
//  Created by Yash on 8/9/19.
//  Copyright © 2019 Yash Rathod. All rights reserved.
//

import Foundation
import UIKit

class termsVC:RootBaseVC {
    
    @IBOutlet weak var txt1:UITextView!
    @IBOutlet weak var act:UIActivityIndicatorView!
    let api = APIManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.act.startAnimating()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadAnimation()
        self.getTerms()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    func getTerms() {
        api.gettermsandcondition(vc: self) { (aboutus) in
            let data = Data(aboutus.content.utf8)
            if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
                self.txt1.attributedText = attributedString
                self.act.stopAnimating()
                self.act.isHidden = true
                self.removeAnimation()
            }
        }
    }
    @IBAction func back(_ sender:UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

