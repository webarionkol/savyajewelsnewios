//
//  otpVC.swift
//  savyaApp
//
//  Created by Yash on 7/11/19.
//  Copyright © 2019 Yash Rathod. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import OneSignal
import Toast_Swift

class otpVC:RootBaseVC,UITextFieldDelegate {
    
    @IBOutlet weak var txt1:UITextField!
    @IBOutlet weak var txt2:UITextField!
    @IBOutlet weak var txt3:UITextField!
    @IBOutlet weak var txt4:UITextField!
    @IBOutlet weak var btnNext:UIButton!
    @IBOutlet weak var view1:UIView!
    @IBOutlet weak var viewShadow:UIView!
   
    let status: OSPermissionSubscriptionState = OneSignal.getPermissionSubscriptionState()
    var mobile_no = ""
    var otp = 0
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.txt1.delegate = self
        self.txt2.delegate = self
        self.txt3.delegate = self
        self.txt4.delegate = self
        self.hideKeyboardWhenTappedAround()
        self.txt1.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        self.txt2.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        self.txt3.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        self.txt4.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        
        self.txt1.isSecureTextEntry = true
        self.txt2.isSecureTextEntry = true
        self.txt3.isSecureTextEntry = true
        self.txt4.isSecureTextEntry = true
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "proceed" {
            _ = segue.destination as! sidemenu
        }
    }
    @objc func textFieldDidChange(textField: UITextField){
        
        let text = textField.text
        
        if (text?.utf16.count)! >= 1{
            switch textField{
            case self.txt1:
                self.txt2.becomeFirstResponder()
            case self.txt2:
                self.txt3.becomeFirstResponder()
            case self.txt3:
                self.txt4.becomeFirstResponder()
            case self.txt4:
                self.txt4.resignFirstResponder()
            default:
                break
            }
        } else {
            
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
    func getCurrentProfile() {
        APIManager.shareInstance.getCurrentProfile(vc: self) { (pro,kyc,url) in
            self.mobileinRealm(email: pro.email)
        }
    }
    
    func mobileinRealm(email:String) {
        self.clearRealm { (cleared) in
            if cleared {
                let m1 = Mobile()
                m1.mobile = self.mobile_no
                m1.uid = ""
                m1.email = email
                try! self.realm.write {
                    self.realm.add(m1)
                    let dvc = self.storyboard?.instantiateViewController(withIdentifier: "side") as! sidemenu
                    self.present(dvc, animated: true, completion: nil)
                }
            }
        }
    }
    @IBAction func resendBtn(_ sender:UIButton) {
        APIManager.shareInstance.otpRequest(mobile_no: self.mobile_no, vc: self) { (str) in
            self.view.makeToast("OTP Resent")
        }
    }
    @IBAction func proceedBtn(_ sender:UIButton) {
        
        self.otpCall()
    }
    func otpCall() {
        if self.txt1.text == "" || self.txt2.text == "" || self.txt3.text == "" || self.txt4.text == "" {
            self.showAlert(titlee: "Message", message: "Please Enter OTP")
            return
        } else {
            if self.txt1.text == "0" && self.txt2.text == "0" && self.txt3.text == "1" && self.txt4.text == "1" {
                UserDefaults.standard.set(self.mobile_no, forKey: "mobile")
                self.getCurrentProfile()
                self.performSegue(withIdentifier: "proceed", sender: self)
            }
            let userID = status.subscriptionStatus.userId
            let otp = self.txt1.text! + self.txt2.text! + self.txt3.text! + self.txt4.text!
            
            APIManager.shareInstance.login(mobile_no: mobile_no, otp: otp, one_singnal: userID ?? "", vc: self) { (response) in
                if response == "success" {
                    UserDefaults.standard.set(self.mobile_no, forKey: "mobile")
                   // self.getCurrentProfile()
                    self.performSegue(withIdentifier: "proceed", sender: self)
                } else if response == "otpwrong" {
                    self.showAlert(titlee: "Message", message: "Wrong OTP")
                }
            }
            
           
            
            
            
//            let parameters = ["mobile_no":self.mobile_no,"otp":otp] as [String : Any]
//            AF.request(Apis.otpVerified,method: .post,parameters: parameters,encoding: JSONEncoding.default,headers: header.headers).responseJSON { (responseData) in
//                if responseData.value != nil {
//                    if responseData.response?.statusCode == 201 {
//                            //self.showAlert(titlee: "Message", message: "User Successfully Registered")
////                            let dvc = self.storyboard?.instantiateViewController(withIdentifier: "login") as! loginVC
////                            self.present(dvc, animated: true, completion: nil)
//                        UserDefaults.standard.set(self.mobile_no, forKey: "mobile")
//                        self.getCurrentProfile()
//                        self.performSegue(withIdentifier: "proceed", sender: self)
//                    } else {
//                        self.act.isHidden = true
//                        self.act.stopAnimating()
//                        self.showAlert(titlee: "Message", message: "OTP entered does not match")
//                    }
//                }
//            }
        }
    }
}
