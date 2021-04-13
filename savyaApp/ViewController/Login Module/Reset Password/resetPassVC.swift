//
//  resetPassVC.swift
//  savyaApp
//
//  Created by Yash on 7/11/19.
//  Copyright © 2019 Yash Rathod. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import Material

class resetPassVC:RootBaseVC {
    
    @IBOutlet weak var view1:UIView!
    @IBOutlet weak var btn1:UIButton!
    @IBOutlet weak var txt1:TextField!
    var mobile_no = 0
    var otp = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view1.layer.cornerRadius = 10
        self.view1.clipsToBounds = true
        self.hideKeyboardWhenTappedAround()
        self.btn1.layer.cornerRadius = 15
        self.btn1.clipsToBounds = true
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "proceed" {
            let dvc = segue.destination as! otpVC
            dvc.otp = self.otp
        }
    }
    @IBAction func back(_ sender:UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func submitBtn(_ sender:UIButton) {
        self.sendRequest()
    }
    
    func sendRequest() {
      //  let header = ["Content-Type":"application/json","APP_KEY":"8447126401"]
        let parameters = ["mobile_no":self.txt1.text!]
        AF.request(Apis.forgotPassword,method: .post,parameters: parameters,encoding: JSONEncoding.default,headers: header.headers).responseJSON { (responseData) in
            if responseData.value != nil {
                if responseData.response?.statusCode == 200 {
                    let data = responseData.value as! [String:Any]
                    self.otp = data["otp"] as! Int
                    self.performSegue(withIdentifier: "proceed", sender: self)
                } else {
                    self.showAlert(titlee: "Message", message: "Something went wrong")
                }
            }
        }
    }
}
