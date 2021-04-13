//
//  newRegisterVC.swift
//  savyaApp
//
//  Created by Yash on 3/4/20.
//  Copyright © 2020 Yash Rathod. All rights reserved.
//

import Foundation
import UIKit
import Material
import Alamofire
import CoreLocation
import MapKit

class newRegisterVC: RootBaseVC,CLLocationManagerDelegate {
    var locationManager: CLLocationManager!
    
    @IBOutlet weak var emailTxt:TextField!
    @IBOutlet weak var nameTxt:TextField!
    @IBOutlet weak var referalTxt:TextField!
    @IBOutlet weak var mobileTxt:TextField!
    @IBOutlet weak var registerBtn:UIButton!
    @IBOutlet weak var viewBg:UIView!
    @IBOutlet weak var scrollView:UIScrollView!
    
    var latitude = ""
    var lognitude = ""
    var agent_code = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.customization()
        self.registerKeyboardNotifications()
        
        if (CLLocationManager.locationServicesEnabled())
                {
                    locationManager = CLLocationManager()
                    locationManager.delegate = self
                    locationManager.desiredAccuracy = kCLLocationAccuracyBest
                    locationManager.requestAlwaysAuthorization()
                    locationManager.startUpdatingLocation()
                }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
       {

           let location = locations.last! as CLLocation

           let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
           let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))

        print(location.coordinate.latitude)
        print(location.coordinate.longitude)
        
        self.latitude = "\(location.coordinate.latitude)"
        self.lognitude = "\(location.coordinate.longitude)"
       }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    func customization() {
       
        self.emailTxt.placeholderAnimation = .hidden
        self.nameTxt.placeholderAnimation = .hidden
        self.mobileTxt.placeholderAnimation = .hidden
        self.referalTxt.placeholderAnimation = .hidden
        
        self.emailTxt.dividerNormalColor = UIColor.init(named: "base_color")!
        self.nameTxt.dividerNormalColor = UIColor.init(named: "base_color")!
        self.mobileTxt.dividerNormalColor = UIColor.init(named: "base_color")!
        self.referalTxt.dividerNormalColor = UIColor.init(named: "base_color")!
        
        self.emailTxt.dividerActiveColor = UIColor.init(named: "base_color")!
        self.nameTxt.dividerActiveColor = UIColor.init(named: "base_color")!
        self.mobileTxt.dividerActiveColor = UIColor.init(named: "base_color")!
        self.referalTxt.dividerActiveColor = UIColor.init(named: "base_color")!
        
        self.viewBg.cornerRadius(radius: 10)
        
        self.registerBtn.cornerRadius(radius: self.registerBtn.frame.height / 2)
    }
    
    @IBAction func backBtn(_ sender:UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue
        let keyboardSize = keyboardInfo.cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
    @IBAction func registerBtn(_ sender:UIButton) {
        
        if referalTxt.text == "" {
            self.registerAPI()
        }else {
            self.refrealcodeAPI()
        }
        
        
        
        
        
        
//        let values = [    "name":self.nameTxt.text ?? "No Name",
//                          get_popup_flag
        
    }
    
    func registerAPI() {
        self.loadAnimation()
        
        if let name = self.nameTxt.text, let email = self.emailTxt.text, let mobile = self.mobileTxt.text, let Referal = self.referalTxt.text {
            APIManager.shareInstance.registerUser(agent_code:agent_code,name: name, email: email, mobile_no: mobile,Referal:Referal,lognitude:self.lognitude,latitude:self.latitude, vc: self) { (response) in
                if response == "success" {
                    self.removeAnimation()
                    let dvc = self.storyboard?.instantiateViewController(withIdentifier: "otp") as! otpVC
                    dvc.mobile_no = mobile
                    self.present(dvc, animated: true, completion: nil)
                } else if response == "mobile" {
                    self.removeAnimation()
                    self.showAlert(titlee: "Message", message: "Mobile Number has Already been taken")
                } else if response == "email" {
                    self.removeAnimation()
                    self.showAlert(titlee: "Message", message: "Email has Already been taken")
                } else {
                    self.removeAnimation()
                    self.showAlert(titlee: "Message", message: "Something went wrong")
                }
            }
        } else {
            self.removeAnimation()
            self.showAlert(titlee: "Message", message: "Please fill all the fields")
        }
    }
    
    func refrealcodeAPI() {
        self.loadAnimation()
        
       
        APIManager.shareInstance.verifyrefrealcode(code: referalTxt.text!, vc: self) { (response) in
              
                    self.removeAnimation()
                    print(response)

                    self.agent_code = response
                    self.registerAPI()
               
        }
    }
    }

