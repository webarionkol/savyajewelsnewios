//
//  webViewVC.swift
//  savyaApp
//
//  Created by Yash on 8/9/19.
//  Copyright © 2019 Yash Rathod. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class webViewVC:RootBaseVC {
    
    @IBOutlet weak var web1:WKWebView!
    @IBOutlet weak var titleLbl:UILabel!
    var titleLblStr = ""
    var website = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.titleLbl.text = self.titleLblStr
        self.web1.load(URLRequest(url: URL(string: self.website)!))
    }
    @IBAction func back(_ sender:UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
