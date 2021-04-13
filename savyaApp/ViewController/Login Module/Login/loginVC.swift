//
//  loginVC.swift
//  savyaApp
//
//  Created by Yash on 6/16/19.
//  Copyright © 2019 Yash Rathod. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import RealmSwift
import Material

class loginVC:RootBaseVC {
    
    @IBOutlet weak var lblreg: UILabel!
    @IBOutlet weak var viewShadow:UIView!
    @IBOutlet weak var viewCorner:UIView!
    @IBOutlet weak var loginBtn:UIButton!
    @IBOutlet weak var numberTxt:TextField!
    @IBOutlet weak var passwordTxt:UITextField!
   // @IBOutlet weak var act:UIActivityIndicatorView!
    let realm = try! Realm()
    var uid = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        self.loginBtn.layer.cornerRadius = 20
        self.loginBtn.clipsToBounds = true
        
        var myString:NSString = "New To Savya? Register now"
        var myMutableString = NSMutableAttributedString()
        
       // numberTxt.text = ""
        
        myMutableString = NSMutableAttributedString(string: myString as String, attributes: [NSAttributedString.Key.font:UIFont(name: "Dosis-Regular", size: 13)!])
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.newPrimaryColor, range: NSRange(location:14,length:12))
        myMutableString.addAttributes([NSAttributedString.Key.font:UIFont(name: "Dosis-Bold", size: 13)!], range:  NSRange(location:14,length:12))
        
           // set label Attribute
           lblreg.attributedText = myMutableString
        
        
        if Global.getUpdate() == "1" {
            let alertController = UIAlertController(title: "Savya Jewels Business", message: "App update available please download the new version from the app store", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Update", style: UIAlertAction.Style.default) {
                                UIAlertAction in
                UIApplication.shared.openURL(NSURL(string: "https://apps.apple.com/in/app/savya-jewels-business/id1472834371")! as URL)

            }
            let cancelAction = UIAlertAction(title: "Not now", style: UIAlertAction.Style.destructive) {
                                           UIAlertAction in
                          

                       }
            
         
            alertController.addAction(okAction)

            self.present(alertController, animated: true, completion: nil)
        }
        
      //  self.act.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.numberTxt.dividerNormalColor = .clear
        self.numberTxt.dividerActiveColor = .clear
        self.numberTxt.placeholderActiveColor = .black
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.viewCorner.layer.cornerRadius = 5
        self.viewCorner.clipsToBounds = true
        self.viewShadow.dropShadow(color: .gray, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "proceed" {
            _ = segue.destination as! sidemenu
        } else if segue.identifier == "guest" {
            _ = segue.destination as! sidemenu
        }
    }
    func clearRealm(completion: @escaping (Bool) -> Void) {
        let r1 = try! Realm()
        let allR1 = try! Realm().objects(Mobile.self)
        try! r1.write {
            r1.delete(allR1)
            
        }
        completion(true)
    }
    
    func getCurrentProfile(otp:String) {
        APIManager.shareInstance.getCurrentProfile(vc: self) { (pro,kyc,url) in
            self.mobileinRealm(email: pro.email, otp: otp)
        }
    }
    
    func mobileinRealm(email:String,otp:String) {
        self.clearRealm { (cleared) in
            if cleared {
                let m1 = Mobile()
                m1.mobile = self.numberTxt.text!
                m1.uid = self.uid
                m1.email = email
                try! self.realm.write {
                    self.realm.add(m1)
                    let dvc = self.storyboard?.instantiateViewController(withIdentifier: "otp") as! otpVC
                    self.present(dvc, animated: true, completion: nil)
                }
            }
        }
    }
    
    
    func newLogin(number:String) {
        APIManager.shareInstance.otpRequest(mobile_no: number, vc: self) { (response) in
            if response == "success" {
                let dvc = self.storyboard?.instantiateViewController(withIdentifier: "otp") as! otpVC
                dvc.mobile_no = number
                self.present(dvc, animated: true, completion: nil)
            } else if response == "number not exsist" {
                self.showAlert(titlee: "Message", message: "Mobile Number Not Exsist")
            } else {
                self.showAlert(titlee: "Message", message: "Something went wront")
            }
        }
    }
    
    func login() {
        
        let values = ["mobile_no":self.numberTxt.text!,"one_singnal":UIDevice.current.identifierForVendor?.uuidString] as [String : Any]
        
        AF.request(Apis.login,method: .post,parameters: values,encoding: JSONEncoding.default,headers: header.headers).responseJSON { (responseData) in
            print(responseData.response?.statusCode)
            if responseData.value != nil {
                if responseData.response?.statusCode == 404 {
                    self.loginBtn.isEnabled = true
                 //   self.act.isHidden = true
                 //   self.act.stopAnimating()
                    self.showAlert(titlee: "Message", message: "User Not Exsist")
                    
                } else if responseData.response?.statusCode == 302 {
                    self.loginBtn.isEnabled = true
                //    self.act.isHidden = true
                //    self.act.stopAnimating()
                    self.showAlert(titlee: "Message", message: "Invalid Credentials")
                } else if responseData.response?.statusCode == 403 {
                    self.loginBtn.isEnabled = true
                  //  self.act.isHidden = true
                  //  self.act.stopAnimating()
                    self.showAlert(titlee: "Message", message: "User is not active")
                } else if responseData.response?.statusCode == 200 {
                    UserDefaults.standard.set(self.numberTxt.text, forKey: "mobile")
                    let resData = responseData.value as! [String:Any]
                    let res1Data = resData["data"] as! [[String:AnyObject]]
                    let newData = res1Data[0]["uid"] as! Int
                    self.uid = String(newData)
                    self.getCurrentProfile(otp: "")
                }
            }
        }
    }
    
    @IBAction func newLoginBtn(_ sender:UIButton) {
        if let number = self.numberTxt.text {
            self.newLogin(number: number)
        } else {
            self.showAlert(titlee: "Message", message: "Please enter mobile number")
        }
    }
    
    @IBAction func loginBtn(_ sender:UIButton) {
        if self.numberTxt.text == "" && self.passwordTxt.text == "" {
            self.showAlert(titlee: "Message", message: "Please enter all details")
        } else {
//            if self.passwordTxt.text == "" {
//                self.showAlert(titlee: "Message", message: "Please enter password")
//                return
//            }
            if self.numberTxt.text == "" {
                self.showAlert(titlee: "Meesage", message: "Please enter mobile number")
                return
            }
            self.loginBtn.isEnabled = false
          //  self.act.isHidden = false
          //  self.act.startAnimating()
            if Reachability.isConnectedToNetwork() {
                self.login()
            } else {
                self.showAlert(titlee: "Message", message: "No Internet Coneection")
            }
        }
    }
    
    @IBAction func guestBtn(_ sender:UIButton) {
        let dvc = self.storyboard?.instantiateViewController(withIdentifier: "side") as! sidemenu
        UserDefaults.standard.set(true, forKey: "guest")
        self.present(dvc, animated: true, completion: nil)
    }
}
extension UIColor {
  
    static let newPrimaryColor = UIColor(named: "base_color")
    
}
