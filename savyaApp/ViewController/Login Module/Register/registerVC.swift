//
//  registerVC.swift
//  savyaApp
//
//  Created by Yash on 6/17/19.
//  Copyright © 2019 Yash Rathod. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import Material

class registerVC:RootBaseVC,UINavigationControllerDelegate,UIImagePickerControllerDelegate,TextFieldDelegate {
    
    @IBOutlet weak var viewCorner:UIView!
    @IBOutlet weak var viewShadow:UIView!
    @IBOutlet weak var act:UIActivityIndicatorView!
    @IBOutlet weak var addImgBtn:UIButton!
    @IBOutlet weak var registerBtn:UIButton!
    @IBOutlet weak var designationTxt:TextField!
    @IBOutlet weak var nameTxt:TextField!
    @IBOutlet weak var companyTxt:TextField!
    @IBOutlet weak var gstTxt:TextField!
    @IBOutlet weak var panTxt:TextField!
    @IBOutlet weak var emailTxt:TextField!
    @IBOutlet weak var mobileTxt:TextField!
    @IBOutlet weak var addressTxt:TextField!
    @IBOutlet weak var cityTxt:TextField!
    @IBOutlet weak var pincodeTxt:TextField!
    @IBOutlet weak var stateTxt:TextField!
    @IBOutlet weak var img:UIImageView!
    @IBOutlet weak var passwordTxt:TextField!
    @IBOutlet weak var retyePassTxt:TextField!
    @IBOutlet weak var lblState:UILabel!
    @IBOutlet weak var regiLbl:UILabel!
    @IBOutlet weak var scrollView:UIScrollView!
    @IBOutlet weak var reeferCode:TextField!
    var otp = 0
    let states = ["Andhra Pradesh",
                  "Arunachal Pradesh",
                  "Assam",
                  "Bihar",
                  "Chhattisgarh",
                  "Goa",
                  "Gujarat",
                  "Haryana",
                  "Himachal Pradesh",
                  "Jammu and Kashmir",
                  "Jharkhand",
                  "Karnataka",
                  "Kerala",
                  "Madhya Pradesh",
                  "Maharashtra",
                  "Manipur",
                  "Meghalaya",
                  "Mizoram",
                  "Nagaland",
                  "Odisha",
                  "Punjab",
                  "Rajasthan",
                  "Sikkim",
                  "Tamil Nadu",
                  "Telangana",
                  "Tripura",
                  "Uttar Pradesh",
                  "Uttarakhand",
                  "West Bengal",
                  "Andaman and Nicobar",
                  "Dadra and Nagar Haveli and Daman and Diu",
                  "Delhi",
                  "Ladakh",
                  "Lakshadweep",
                  "Puducherry"]
    var userType = ["Manufacture","Retailer","Wholeseller","Franchise"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        self.viewCorner.layer.cornerRadius = 10
        self.viewCorner.clipsToBounds = true
        self.act.isHidden = true
        self.addImgBtn.clipsToBounds = true
        self.addImgBtn.layer.cornerRadius = 17
        
        self.registerBtn.clipsToBounds = true
        self.registerBtn.layer.cornerRadius = 17
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.customization()
        self.setAllDelegates()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: 1300)
        self.viewShadow.dropShadow(color: .gray, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
    }
    func setAllDelegates() {
        self.gstTxt.delegate = self
        self.panTxt.delegate = self
        self.mobileTxt.delegate = self
        self.emailTxt.delegate = self
    }
    func customization() {
        self.companyTxt.placeholderNormalColor = .black
        self.companyTxt.dividerNormalColor = .black
        self.companyTxt.dividerActiveColor = .black
        self.companyTxt.placeholderLabel.font = .boldSystemFont(ofSize: 13)
        
    }
    func textField(textField: TextField, didChange text: String?) {
        if textField == self.gstTxt {
            if isValidGSTNumer(gst: text!) {
                textField.detail = ""
                textField.dividerActiveColor = .blue
            } else {
                textField.detail = "Invalid GST Number"
                textField.detailColor = .red
                textField.dividerActiveColor = .red
            }
        } else if textField == self.panTxt {
            if validatePANCardNumber(text!) {
                textField.detail = ""
                textField.dividerActiveColor = .blue
            } else {
                textField.detail = "Invalid PAN Number"
                textField.detailColor = .red
                textField.dividerActiveColor = .red
            }
        } else if textField == self.emailTxt {
            if isValidEmail(emailStr: text!) {
                textField.detail = ""
                textField.dividerActiveColor = .blue
            } else {
                textField.detail = "Invalid Email"
                textField.detailColor = .red
                textField.dividerActiveColor = .red
            }
        } else if textField == self.mobileTxt {
            if text?.count == 10 {
                textField.detail = ""
                textField.dividerActiveColor = .blue
            }  else {
                textField.detail = "Invalid Mobile Number"
                textField.detailColor = .red
                textField.dividerActiveColor = .red
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "proceed" {
            let dvc = segue.destination as! otpVC
            dvc.otp = self.otp
        }
    }
   
    @objc func keyboardWillShow(notification:NSNotification){
        
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
    @IBAction func selectState(_ sender:UIButton) {
        let action = UIAlertController(title: "Message", message: "Please select any one state", preferredStyle: .actionSheet)
        action.popoverPresentationController?.sourceRect = sender.bounds
        action.popoverPresentationController?.sourceView = sender
        for i in self.states {
            action.addAction(UIAlertAction(title: i, style: .default, handler: { (_) in
                self.lblState.text = i
            }))
        }
        self.present(action, animated: true, completion: nil)
    }
    @IBAction func selectReg(_ sender:UIButton) {
        let action = UIAlertController(title: "Message", message: "Please select any one state", preferredStyle: .actionSheet)
        action.popoverPresentationController?.sourceRect = sender.bounds
        action.popoverPresentationController?.sourceView = sender
        for i in self.userType {
            action.addAction(UIAlertAction(title: i, style: .default, handler: { (_) in
                self.regiLbl.text = i
            }))
        }
        
        self.present(action, animated: true, completion: nil)
    }
    @IBAction func profilePicBtn(_ sender:UIButton) {
        let action = UIAlertController(title: "Message", message: "Please select one", preferredStyle: .actionSheet)
        action.popoverPresentationController?.sourceRect = sender.bounds
        action.popoverPresentationController?.sourceView = sender
        action.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_) in
            self.openCamera()
        }))
        action.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (_) in
            self.openGallery()
        }))
        action.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (_) in
            
        }))
        self.present(action, animated: true, completion: nil)
    }
    @IBAction func registerBtn(_ sender:UIButton) {
       
        if self.nameTxt.text == "" || self.companyTxt.text == "" || self.gstTxt.text == "" || self.panTxt.text == "" || self.emailTxt.text == "" || self.mobileTxt.text == "" || self.cityTxt.text == "" || self.pincodeTxt.text == "" || self.addressTxt.text == "" {
            self.showAlert(titlee: "Message", message: "Please enter all the details")
        } else {
            if self.passwordTxt.text == self.retyePassTxt.text {
                if self.isValidEmail(emailStr: self.emailTxt.text!) {
                    if self.isValidGSTNumer(gst: self.gstTxt.text!) {
                        if self.validatePANCardNumber(self.panTxt.text!) {

                            self.registerRequest()
                        } else {
                            self.showAlert(titlee: "Message", message: "Please Enter proper PAN Number")
                        }

                    } else {
                        self.showAlert(titlee: "Message", message: "Please Enter Correct GST Number")
                    }

                } else {
                    self.showAlert(titlee: "Message", message: "Please Enter Proper Email")
                }

            } else {
                self.showAlert(titlee: "Message", message: "Password Does not Matched")
            }
        }
    }
    func validatePANCardNumber(_ strPANNumber : String) -> Bool{
        let regularExpression = "[A-Z]{5}[0-9]{4}[A-Z]{1}"
        let panCardValidation = NSPredicate(format : "SELF MATCHES %@", regularExpression)
        return panCardValidation.evaluate(with: strPANNumber)
    }
    func isValidGSTNumer(gst:String) -> Bool {
        let gstRegex = "[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", gstRegex)
        return emailPred.evaluate(with: gst)
    }
    func isValidEmail(emailStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailStr)
    }
    func openCamera() {
        let img = UIImagePickerController()
        img.delegate = self
        img.sourceType = .camera
        img.cameraCaptureMode = .photo
        img.allowsEditing = true
        self.present(img, animated: true, completion: nil)
    }
    func openGallery() {
        let img = UIImagePickerController()
        img.delegate = self
        img.sourceType = .photoLibrary
        img.allowsEditing = true
        self.present(img, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let img = info[.editedImage] as! UIImage
        self.img.image = img
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    func registerRequest() {
        self.act.isHidden = false
        self.act.startAnimating()
        if self.img.image == nil {
            let values = [    "name":self.nameTxt.text ?? "No Name",
                              "register_type":self.regiLbl.text!,
                              "company_name":self.companyTxt.text!,
                              "gstno":self.gstTxt.text!,
                              "panno":self.panTxt.text!,
                              "email":self.emailTxt.text!,
                              "mobile_no":self.mobileTxt.text!,
                              "city":self.cityTxt.text!,
                              "pincode":self.pincodeTxt.text!,
                              "state":self.lblState.text!,
                              "address":self.addressTxt.text!,
                              "password":self.passwordTxt.text!,
                              "Image":"filename","designation":self.designationTxt.text!,
                              "agent_code":self.reeferCode.text!] as [String : Any]
            
                    AF.request(Apis.signup,method: .post,parameters: values,encoding: JSONEncoding.default,headers: header.headers).responseJSON { (repsonseData) in
                        if repsonseData.value != nil {
                            if repsonseData.response?.statusCode == 201 {
                                let resData = repsonseData.value as! [String:Any]
                                let otp = resData["otp"] as! Int
                                self.otp = otp
                                print("otp:- \(otp)")
                                let dvc = self.storyboard?.instantiateViewController(withIdentifier: "otp") as! otpVC
                                dvc.otp = self.otp
                                self.present(dvc, animated: true, completion: nil)
                               // self.performSegue(withIdentifier: "proceed", sender: self)
                            } else if repsonseData.response?.statusCode == 401 {
                                self.act.isHidden = true
                                self.showAlert(titlee: "Message", message: "User Already Registered")
                            }
                        }
                    }
        } else {
            if let data = self.img.image?.jpegData(compressionQuality: 0.5) {
                let parameters: Parameters = [
                    "name":self.nameTxt.text ?? "No Name",
                    "register_type":self.regiLbl.text!,
                    "company_name":self.companyTxt.text!,
                    "gstno":self.gstTxt.text!,
                    "panno":self.panTxt.text!,
                    "email":self.emailTxt.text!,
                    "mobile_no":self.mobileTxt.text!,
                    "city":self.cityTxt.text!,
                    "pincode":self.pincodeTxt.text!,
                    "state":self.lblState.text!,
                    "address":self.addressTxt.text!,
                    "password":self.passwordTxt.text!,
                    "designation":self.designationTxt.text!,
                    "agent_code":self.reeferCode.text!]
                // You can change your image name here, i use NSURL image and convert into string
                
                let fileName = UUID().uuidString
                // Start Alamofire
                
//                Alamofire.upload(multipartFormData: { multipartFormData in
//                    for (key,value) in parameters {
//                        multipartFormData.append((value as! String).data(using: .utf8)!, withName: key)
//                    }
//                    multipartFormData.append(data, withName: "image", fileName: fileName,mimeType: "image/jpeg")
//                },
//                        usingThreshold: UInt64.init(),
//                        to: Apis.signup,
//                        method: .post,headers: header.headers,
//                        encodingCompletion: { encodingResult in
//                        switch encodingResult {
//                        case .success(let upload, _, _):
//                        upload.responseJSON { response in
//                            debugPrint(response)
//                            let resData = response.result.value as! [String:Any]
//                            let otp = resData["otp"] as! Int
//                            self.otp = otp
//                            print("otp:- \(otp)")
//                            let dvc = self.storyboard?.instantiateViewController(withIdentifier: "otp") as! otpVC
//                            dvc.otp = self.otp
//                            self.present(dvc, animated: true, completion: nil)
//                        }
//                        case .failure(let encodingError):
//                            print(encodingError)
//                    }
//                })
            }
        }
    }
}
