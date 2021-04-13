//
//  kycListVC.swift
//  savyaApp
//
//  Created by Yash on 3/9/20.
//  Copyright © 2020 Yash Rathod. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import Material

class kycListVC: RootBaseVC,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,docUpdateDelegate,UICollectionViewDelegateFlowLayout,gstUploadBack,gstUploadFront,panUpload,adharUploadFornt,adharUploadBack,visitingUploadFront,visitingUploadBack,UITextFieldDelegate {
   
   
    @IBOutlet weak var btnSUb: UIButton!
    @IBOutlet weak var imgMain: UIImageView!
    @IBOutlet weak var txtAddress: TextField!
    @IBOutlet weak var txtph: TextField!
    @IBOutlet weak var txtGST: TextField!
    @IBOutlet weak var txtShop: TextField!
    @IBOutlet weak var txtDesig: TextField!
    @IBOutlet weak var txtName: TextField!
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var collectionView:UICollectionView!
    
    var profileImg:UIImage?
    
    
    let lblTitle = ["GST Registration Certificate Front","GST Registration Certificate Back","PAN","Adhar Card Front","Adhar Card Back","Visiting Card Front","Visiting Card back"]
    var imgs = [UIImage.init(named: "kyc1"),UIImage.init(named: "GSTback"),UIImage.init(named: "kyc2"),UIImage.init(named: "kyc3"),UIImage.init(named: "kyc3"),UIImage.init(named: "kyc4"),UIImage.init(named: "kyc4")]
    var imgLink = ["https://s3.ap-south-1.amazonaws.com/www.savyajewelsbusiness.com/KYC+IMAGE/1.+GST+(1)/GST_Front-0.jpg","https://s3.ap-south-1.amazonaws.com/www.savyajewelsbusiness.com/KYC+IMAGE/2.+GST+(2)/GST_Back-0.jpg","https://s3.ap-south-1.amazonaws.com/www.savyajewelsbusiness.com/KYC+IMAGE/5.+PAN/PANCARD-0.jpg","https://s3.ap-south-1.amazonaws.com/www.savyajewelsbusiness.com/KYC+IMAGE/3.+Aadhar+(1)/Aadhar_Front-0.jpg","https://s3.ap-south-1.amazonaws.com/www.savyajewelsbusiness.com/KYC+IMAGE/4+Aadhar+(2)/Aadhar_Back-0.jpg","https://s3.ap-south-1.amazonaws.com/www.savyajewelsbusiness.com/KYC+IMAGE/6.+Visiting+Card/VisitingCard_Front-0.jpg","https://s3.ap-south-1.amazonaws.com/www.savyajewelsbusiness.com/KYC+IMAGE/7.+Visiting+Card/VisitingCard_Back-0.jpg"]
    
    //https://s3.ap-south-1.amazonaws.com/www.savyajewelsbusiness.com/KYC+IMAGE/1.+GST+(1)/GST_Front-0.jpg
    let whatneedLbl = ""
    var from = ""
    var values = ["","","",""]
    var gstimages = [UIImage]()
    var panImg:UIImage!
    var adharImages = [UIImage]()
    var visitingImages = [UIImage]()
    var statusArr = [String]()
    var mobile = ""
    var uploadedDoc = [String]()
    
    var gst_front:UIImage?
    var gst_bac:UIImage?
    var adhar_front:UIImage?
    var adha_back:UIImage?
    var pan_front:UIImage?
    var visiting_front:UIImage?
    var visiting_back:UIImage?
    var isverified = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.showsHorizontalScrollIndicator = false
        self.tableView.showsVerticalScrollIndicator = false
        
        if isverified == true {
            btnSUb.setTitle("Update", for: .normal)
        }else {
            btnSUb.setTitle("Submit", for: .normal)
        }
        txtGST.delegate = self
       

    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtGST {
            txtGST.text = (textField.text! as NSString).replacingCharacters(in: range, with: string.uppercased())

        }
        return false
      
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getCurrentPro()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    @IBAction func btnChangeprofile(_ sender: Any) {
        let action = UIAlertController(title: "Message", message: "Please Select Any One", preferredStyle: .actionSheet)
        action.addAction(UIAlertAction.init(title: "Camera", style: .default, handler: { (_) in
            self.openCamera()
        }))
        action.addAction(UIAlertAction.init(title: "Gallery", style: .default, handler: { (_) in
            self.openGallery()
        }))
        action.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: { (_) in
            
        }))
//        if let presenter = action.popoverPresentationController {
//            presenter.sourceView = sender
//            presenter.sourceRect = sender.bounds
//        }
        self.present(action, animated: true, completion: nil)
    }
    func openGallery() {
        let img = UIImagePickerController()
        img.delegate = self
        img.sourceType = .photoLibrary
        img.allowsEditing = true
        self.present(img, animated: true, completion: nil)
    }
    func openCamera() {
        let img = UIImagePickerController()
        img.delegate = self
        img.sourceType = .camera
        img.allowsEditing = true
        self.present(img, animated: true, completion: nil)
    }
    @IBAction func btnSubmitClicked(_ sender: Any) {
        if txtName.text == "" {
            self.view.makeToast("Please enter Name")
            return
        }
        else if txtDesig.text == "" {
            self.view.makeToast("Please enter Designation")
            return
        }
        else if txtShop.text == "" {
            self.view.makeToast("Please enter Shop Name")
            return
        }
        else if txtGST.text == "" {
            self.view.makeToast("Please enter Gst number")
            return
        }
        else if isValidGSTNumer(gst: txtGST.text!) == false{
            self.view.makeToast("Please Enter a valid GST Number")
            return
        }
        else if txtph.text == "" {
            self.view.makeToast("Please Enter a phone number")
            return
        }
        else if txtAddress.text == "" {
            self.view.makeToast("Please Enter address")
            return
        }
        else {
            self.loadAnimation()
            uploaKyc(name: txtName.text!, desig: txtDesig.text!, shop: txtShop.text!, gst: txtGST.text!, phone: txtph.text!, address: txtAddress.text!) { (str) in
                
                self.removeAnimation()
                Global.setKyc(kyc: "1")
                let dvc = self.storyboard?.instantiateViewController(withIdentifier: "side") as! sidemenu
                
                dvc.modalPresentationStyle = .fullScreen
                self.present(dvc, animated: true, completion: nil)
                //self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
   
    func isValidGSTNumer(gst:String) -> Bool {
        let regularExpression = "[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}"
        let nsregular = try! NSRegularExpression(pattern: regularExpression, options: .caseInsensitive)
        let panCardValidation = NSPredicate(format : "SELF MATCHES %@", regularExpression)
        nsregular.enumerateMatches(in: gst, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSRange(location: 0, length: gst.count), using: { (result: NSTextCheckingResult!, _, _) in
            print(result)
        })
        return panCardValidation.evaluate(with: gst)
    }
    @IBAction func rightBtn(_ sender:UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "uploadoc" {
            let dvc = segue.destination as! kycUploadVC
            dvc.from = self.from
            dvc.gstbackDelegate = self
            dvc.gstFrontDelegate = self
            dvc.panDelegate = self
            dvc.adharBackDelegate = self
            dvc.adharFrontDelegate = self
            dvc.visitingBackDelegate = self
            dvc.visitingFrontDelegate = self
        }
        else if segue.identifier == "home" {
            let dvc = segue.destination as! dashboardVC2
            dvc.isfromKyc = true
          
        }
    }
    
    func getCurrentPro() {
        APIManager.shareInstance.getCurrentProfile(vc: self) { (pro, kyc,url) in
            
            print(pro)
            
            self.mobile = pro.mobile_no
            
            self.txtph.text = self.mobile
            self.txtGST.text = kyc.gstNo
            self.txtShop.text = kyc.shopname
            self.txtAddress.text = pro.address
            self.txtName.text = pro.name
            self.txtDesig.text = kyc.designation
         
            
            
            
            //self.statusArr.removeAll()
//            self.uploadedDoc.removeAll()
//            self.statusArr.append(kyc.gst_doc_status)
//            self.statusArr.append(kyc.gst_back_status)
//            self.statusArr.append(kyc.pan_doc_status)
//            self.statusArr.append(kyc.aadhar_doc_status)
//            self.statusArr.append(kyc.aadhar_back_status)
//            self.statusArr.append(kyc.visiting_doc_status)
//            self.statusArr.append(kyc.visiting_back_status)
            
//            if kyc.gstDoc != "" {
//                self.imgLink[0] = kyc.gstDoc.replacingOccurrences(of: " ", with: "%20")
//                self.uploadedDoc.append("gst_front")
//            }
//            if kyc.gstBack != "" {
//
//                self.imgLink[1] = kyc.gstBack.replacingOccurrences(of: " ", with: "%20")
//                self.uploadedDoc.append("gst_back")
//            }
//            if kyc.panDoc != "" && kyc.panDoc.contains(".jpg") || kyc.panDoc.contains(".jpeg") {
//                print(kyc.panDoc)
//                self.imgLink[2] = kyc.panDoc.replacingOccurrences(of: " ", with: "%20")
//                self.uploadedDoc.append("pan")
//            }
//            if kyc.aadharDoc != "" && kyc.aadharDoc.contains(".jpg") || kyc.aadharDoc.contains(".jpeg") {
//
//                self.imgLink[3] = kyc.aadharDoc.replacingOccurrences(of: " ", with: "%20")
//                self.uploadedDoc.append("adhar_front")
//            }
//            if kyc.aadharBack != "" && kyc.aadharBack.contains(".jpg") || kyc.aadharBack.contains(".jpeg") {
//
//                self.imgLink[4] = kyc.aadharBack.replacingOccurrences(of: " ", with: "%20")
//                self.uploadedDoc.append("adhar_back")
//            }
//            if kyc.visitingDoc != "" && kyc.visitingDoc.contains(".jpg") || kyc.visitingDoc.contains(".jpeg") {
//
//                self.imgLink[5] = kyc.visitingDoc.replacingOccurrences(of: " ", with: "%20")
//                self.uploadedDoc.append("visiting_front")
//            }
//            if kyc.visitingBack != "" && kyc.visitingBack.contains(".jpg") || kyc.visitingBack.contains(".jpeg"){
//
//                self.imgLink[6] = kyc.visitingBack.replacingOccurrences(of: " ", with: "%20")
//                self.uploadedDoc.append("visiting_back")
//            }
//            if self.uploadedDoc.count >= 6 {
//                self.showAlert(titlee: "Message", message: "Thanks For Uploading documents. Please wait as our team is verifying your documents")
//            }
//            self.tableView.reloadData()
        }
    }
    
    //Upload GST
    func gstUplaodDoc(gst_back: UIImage) {
        let gstnumber = UserDefaults.standard.string(forKey: "GSTSET")
        let prevCell = self.tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! kycCell
        let cell = self.tableView.cellForRow(at: IndexPath.init(row: 1, section: 0)) as! kycCell
        cell.img.image = gst_back
        self.imgs[1] = gst_back
        self.gst_bac = gst_back
        
        let gstFrontIMG = UIImage.init(data: UserDefaults.standard.data(forKey: "gstFrontIMG")!)
        self.uploaDoc(docnumber: gstnumber ?? "", imgData1: (gstFrontIMG?.jpegData(compressionQuality: 0.8))!, imgData2: (gst_back.jpegData(compressionQuality: 0.8))!, key1: "gst_front", key2: "gst_back", docKey: "gst_no") { (response) in
            print(response)
        }
    }
       
    func gstUplaodDoc(gst_front: UIImage, gstnumber: String) {
        UserDefaults.standard.set(gstnumber, forKey: "GSTSET")
        UserDefaults.standard.set(gst_front.jpegData(compressionQuality: 0.8), forKey: "gstFrontIMG")
        let cell = self.tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! kycCell
        cell.img.image = gst_front
        self.imgs[0] = gst_front
        self.gst_front = gst_front
    }
    
    func panUploadDoc(pan: UIImage, pannumber: String) {
        let cell = self.tableView.cellForRow(at: IndexPath.init(row: 2, section: 0)) as! kycCell
        cell.img.image = pan
        self.imgs[2] = pan
        self.pan_front = pan
        self.uploaDoc(docnumber: pannumber, imgData1: (cell.img.image?.jpegData(compressionQuality: 0.8))!, imgData2: Data(), key1: "pan_front", key2: "", docKey: "pan_no") { (response) in
        print(response)
        }
    }
    
    func adharuploadFront(adhar_front: UIImage, adharnumber: String) {
        UserDefaults.standard.set(adharnumber, forKey: "ADHARSET")
        let cell = self.tableView.cellForRow(at: IndexPath.init(row: 3, section: 0)) as! kycCell
        cell.img.image = adhar_front
        self.imgs[3] = adhar_front
        self.adhar_front = adhar_front
    }
    
    func adharuploadBack(adhar_back: UIImage) {
        let adharnumber = UserDefaults.standard.string(forKey: "ADHARSET")
        let prevCell = self.tableView.cellForRow(at: IndexPath.init(row: 3, section: 0)) as! kycCell
        let cell = self.tableView.cellForRow(at: IndexPath.init(row: 4, section: 0)) as! kycCell
        cell.img.image = adhar_back
        self.imgs[4] = adhar_back
        self.adha_back = adhar_back
        self.uploaDoc(docnumber: adharnumber ?? "", imgData1: (self.adhar_front?.jpegData(compressionQuality: 0.8))!, imgData2: (self.adha_back?.jpegData(compressionQuality: 0.8))!, key1: "adhar_fornt", key2: "adhar_back", docKey: "aadhar") { (response) in
            print(response)
        }
    }
    
    func visitingFornt(card_front: UIImage) {
        let cell = self.tableView.cellForRow(at: IndexPath.init(row: 5, section: 0)) as! kycCell
        cell.img.image = card_front
        self.imgs[5] = card_front
        self.visiting_front = card_front
    }
    
    func visitingBack(card_back: UIImage) {
        let prevCell = self.tableView.cellForRow(at: IndexPath.init(row: 5, section: 0)) as! kycCell
        let cell = self.tableView.cellForRow(at: IndexPath.init(row: 6, section: 0)) as! kycCell
        cell.img.image = card_back
        self.imgs[6] = card_back
        self.visiting_back = card_back
        self.uploaDoc(docnumber: "", imgData1: (self.visiting_front?.jpegData(compressionQuality: 0.8))!, imgData2: (self.visiting_back?.jpegData(compressionQuality: 0.8))!, key1: "visiting_front", key2: "visiting_back", docKey: "") { (response) in
            print(response)
        }
    }
    func uploaKyc(name:String,desig:String,shop:String,gst:String,phone:String,address:String,completion:@escaping (String) -> Void) {
          
        let authorization:HTTPHeaders =  ["Authorization":Token.getLatestToken()]
               
        let fileName = UUID().uuidString
        let fileName2 = UUID().uuidString
        // Start Alamofire
               
        AF.upload(multipartFormData: { multipartFormData in
            
            multipartFormData.append(phone.data(using: .utf8)!, withName: "mobile_no")
            multipartFormData.append(name.data(using: .utf8)!, withName: "name")
            multipartFormData.append(desig.data(using: .utf8)!, withName: "designation")
            multipartFormData.append(shop.data(using: .utf8)!, withName: "shopname")
            multipartFormData.append(gst.data(using: .utf8)!, withName: "gst_no")
            multipartFormData.append(address.data(using: .utf8)!, withName: "address")
            
            print(multipartFormData.contentType)
        }, to: NewAPI.docUpload,method: .post,headers: authorization)
            .responseJSON { response in
                print(response)
                print(response.response?.statusCode)
                if response.response?.statusCode == 200 {
                    completion("success")
                    
                   // self.getCurrentPro()
                } else {
                    completion("failure")
                }
            }
        
//        AF.upload(multipartFormData: { multipartFormData in
//            for (key,value) in parameters {
//                multipartFormData.append((value as! String).data(using: .utf8)!, withName: key)
//            }
//            multipartFormData.append(imgData1, withName: key1, fileName: fileName + ".jpg",mimeType: "image/jpeg")
//            multipartFormData.append(imgData2, withName: key2, fileName: fileName + ".jpg",mimeType: "image/jpeg")
//            print(multipartFormData.contentType)
//        },
//        usingThreshold: UInt64.init(),
//        to: Apis.docUpload,
//        method: .post,headers: header.headers,
//
//        encodingCompletion: { encodingResult in
//            switch encodingResult {
//                case .success(let upload, _, _):
//                    upload.responseJSON { (response) in
//                    print(response)
//                    if response.response?.statusCode == 200 {
//                        completion("success")
//                    } else {
//                        completion("failure")
//                    }
//                }
//                case .failure(let encodingError):
//                    print(encodingError)
//            }
//        })
    }
    func uploaDoc(docnumber:String,imgData1:Data,imgData2:Data,key1:String,key2:String,docKey:String,completion:@escaping (String) -> Void) {
          
        let authorization:HTTPHeaders =  ["Authorization":Token.getLatestToken()]
               
        let fileName = UUID().uuidString
        let fileName2 = UUID().uuidString
        // Start Alamofire
               
        AF.upload(multipartFormData: { multipartFormData in
            
            multipartFormData.append(imgData1, withName: key1, fileName: fileName + ".jpg",mimeType: "image/jpeg")
            multipartFormData.append(imgData2, withName: key2, fileName: fileName2 + ".jpg",mimeType: "image/jpeg")
            multipartFormData.append(docnumber.data(using: .utf8)!, withName: docKey)
            multipartFormData.append(self.mobile.data(using: .utf8)!, withName: "mobile_no")
            print(multipartFormData.contentType)
        }, to: NewAPI.docUpload,method: .post,headers: authorization)
            .responseJSON { response in
                print(response)
                print(response.response?.statusCode)
                if response.response?.statusCode == 200 {
                    completion("success")
                    self.getCurrentPro()
                } else {
                    completion("failure")
                }
            }
        
//        AF.upload(multipartFormData: { multipartFormData in
//            for (key,value) in parameters {
//                multipartFormData.append((value as! String).data(using: .utf8)!, withName: key)
//            }
//            multipartFormData.append(imgData1, withName: key1, fileName: fileName + ".jpg",mimeType: "image/jpeg")
//            multipartFormData.append(imgData2, withName: key2, fileName: fileName + ".jpg",mimeType: "image/jpeg")
//            print(multipartFormData.contentType)
//        },
//        usingThreshold: UInt64.init(),
//        to: Apis.docUpload,
//        method: .post,headers: header.headers,
//
//        encodingCompletion: { encodingResult in
//            switch encodingResult {
//                case .success(let upload, _, _):
//                    upload.responseJSON { (response) in
//                    print(response)
//                    if response.response?.statusCode == 200 {
//                        completion("success")
//                    } else {
//                        completion("failure")
//                    }
//                }
//                case .failure(let encodingError):
//                    print(encodingError)
//            }
//        })
    }
    func docValues(gst: String, pan: String, adhar: String, visiting: String) {
        self.values.removeAll()
        self.values.append(gst)
        self.values.append(pan)
        self.values.append(adhar)
        self.values.append(visiting)
        self.tableView.reloadData()
    }
    @IBAction func backBtn(_ sender:UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func doneBtn(_ sender:UIButton) {
        if self.uploadedDoc.count >= 6 {
            let alert = UIAlertController.init(title: "Message", message: "Thanks For Uploading documents. Please wait as our team is verifying your documents", preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { (_) in
                let dvc = self.storyboard?.instantiateViewController(withIdentifier: "side") as! sidemenu
                dvc.modalPresentationStyle = .fullScreen
                self.present(dvc, animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            self.showAlert(titlee: "Message", message: "Please Upload All Documents")
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.statusArr.count == 0 {
            return 0
        }
        return self.imgs.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! kycCell
        cell.lblTitle.text = self.lblTitle[indexPath.row]
        cell.img.image = self.imgs[indexPath.row]
        cell.img.kf.indicatorType = .activity
        cell.img.kf.setImage(with: URL(string: self.imgLink[indexPath.row]),placeholder: nil,options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
                
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
                
        }
        }
        //cell.lblTxt.isHidden = true
        cell.uploadBtn.layer.cornerRadius = 5
        cell.uploadBtn.clipsToBounds = true
        cell.uploadBtn.isEnabled = false
        
        if indexPath.row == 0 {
            if self.statusArr[indexPath.row] == "3" {
                cell.view1.layer.borderColor = UIColor.red.cgColor
                cell.view1.layer.borderWidth = 1
            }
            if self.gst_front == nil {
                cell.img.kf.indicatorType = .activity
                cell.img.kf.setImage(with: URL(string: self.imgLink[indexPath.row]),placeholder: nil,options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
                    switch result {
                    case .success(let value):
                        print("Task done for: \(value.source.url?.absoluteString ?? "")")
                        
                    case .failure(let error):
                        print("Job failed: \(error.localizedDescription)")
                        
                    }
                }
            } else {
                cell.img.image = self.gst_front
            }
            cell.lblTxt.attributedText = NSMutableAttributedString().boldNew("Certificate Must show").normalNew("\nRegistration Number\nLegal Name\nTrader Name")
            if self.uploadedDoc.contains("gst_front") {
                cell.uploadBtn.setTitle("Uploaded", for: .normal)
                cell.uploadBtn.backgroundColor = UIColor.systemGreen
            } else {
                cell.uploadBtn.setTitle("Upload", for: .normal)
                cell.uploadBtn.backgroundColor = UIColor.init(rgb: 0x3E75CF)
            }
        } else if indexPath.row == 1 {
            if self.statusArr[indexPath.row] == "3" {
                cell.view1.layer.borderColor = UIColor.red.cgColor
                cell.view1.layer.borderWidth = 1
            }
            if self.gst_bac == nil {
                cell.img.kf.indicatorType = .activity
                cell.img.kf.setImage(with: URL(string: self.imgLink[indexPath.row]),placeholder: nil,options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
                    switch result {
                    case .success(let value):
                        print("Task done for: \(value.source.url?.absoluteString ?? "")")
                        
                    case .failure(let error):
                        print("Job failed: \(error.localizedDescription)")
                        
                    }
                }
            } else {
                cell.img.image = self.gst_bac
            }
            cell.lblTxt.attributedText = NSMutableAttributedString().boldNew("Certificate Must show").normalNew("\nRegistration Number\nLegal Name\nTrader Name")
            if self.uploadedDoc.contains("gst_back") {
                cell.uploadBtn.setTitle("Uploaded", for: .normal)
                cell.uploadBtn.backgroundColor = UIColor.systemGreen
            } else {
                cell.uploadBtn.setTitle("Upload", for: .normal)
                cell.uploadBtn.backgroundColor = UIColor.init(rgb: 0x3E75CF)
            }
        } else if indexPath.row == 2 {
            if self.statusArr[indexPath.row] == "3" {
                cell.view1.layer.borderColor = UIColor.red.cgColor
                cell.view1.layer.borderWidth = 1
            }
            if self.pan_front == nil {
                cell.img.kf.indicatorType = .activity
                cell.img.kf.setImage(with: URL(string: self.imgLink[indexPath.row]),placeholder: nil,options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
                    switch result {
                    case .success(let value):
                        print("Task done for: \(value.source.url?.absoluteString ?? "")")
                        
                    case .failure(let error):
                        print("Job failed: \(error.localizedDescription)")
                        
                    }
                }
            } else {
                cell.img.image = self.pan_front
            }
            cell.lblTxt.attributedText = NSMutableAttributedString().boldNew("Certificate Must show").normalNew("\nPan Number\nPan Name\nPhoto")
            if self.uploadedDoc.contains("pan") {
                cell.uploadBtn.setTitle("Uploaded", for: .normal)
                cell.uploadBtn.backgroundColor = UIColor.systemGreen
            } else {
                cell.uploadBtn.setTitle("Upload", for: .normal)
                cell.uploadBtn.backgroundColor = UIColor.init(rgb: 0x3E75CF)
            }
        } else if indexPath.row == 3 {
            if self.statusArr[indexPath.row] == "3" {
                cell.view1.layer.borderColor = UIColor.red.cgColor
                cell.view1.layer.borderWidth = 1
            }
            if self.adhar_front == nil {
                cell.img.kf.indicatorType = .activity
                cell.img.kf.setImage(with: URL(string: self.imgLink[indexPath.row]),placeholder: nil,options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
                    switch result {
                    case .success(let value):
                        print("Task done for: \(value.source.url?.absoluteString ?? "")")
                        
                    case .failure(let error):
                        print("Job failed: \(error.localizedDescription)")
                        
                    }
                }
            } else {
                cell.img.image = self.adhar_front
            }
            cell.lblTxt.attributedText = NSMutableAttributedString().boldNew("Certificate Must show").normalNew("\nAadhar no\nLegal Name")
            if self.uploadedDoc.contains("adhar_front") {
                cell.uploadBtn.setTitle("Uploaded", for: .normal)
                cell.uploadBtn.backgroundColor = UIColor.systemGreen
            } else {
                cell.uploadBtn.setTitle("Upload", for: .normal)
                cell.uploadBtn.backgroundColor = UIColor.init(rgb: 0x3E75CF)
            }
        } else if indexPath.row == 4 {
            if self.statusArr[indexPath.row] == "3" {
                cell.view1.layer.borderColor = UIColor.red.cgColor
                cell.view1.layer.borderWidth = 1
            }
            if self.adha_back == nil {
                cell.img.kf.indicatorType = .activity
                cell.img.kf.setImage(with: URL(string: self.imgLink[indexPath.row]),placeholder: nil,options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
                    switch result {
                    case .success(let value):
                        print("Task done for: \(value.source.url?.absoluteString ?? "")")
                        
                    case .failure(let error):
                        print("Job failed: \(error.localizedDescription)")
                        
                    }
                }
            } else {
                cell.img.image = self.adha_back
            }
            cell.lblTxt.attributedText = NSMutableAttributedString().boldNew("Certificate Must show").normalNew("\nAddress")
            if self.uploadedDoc.contains("adhar_back") {
                cell.uploadBtn.setTitle("Uploaded", for: .normal)
                cell.uploadBtn.backgroundColor = UIColor.systemGreen
            } else {
                cell.uploadBtn.setTitle("Upload", for: .normal)
                cell.uploadBtn.backgroundColor = UIColor.init(rgb: 0x3E75CF)
            }
        } else if indexPath.row == 5 {
            if self.statusArr[indexPath.row] == "3" {
                cell.view1.layer.borderColor = UIColor.red.cgColor
                cell.view1.layer.borderWidth = 1
            }
            if self.visiting_front == nil {
                cell.img.kf.indicatorType = .activity
                cell.img.kf.setImage(with: URL(string: self.imgLink[indexPath.row]),placeholder: nil,options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
                    switch result {
                    case .success(let value):
                        print("Task done for: \(value.source.url?.absoluteString ?? "")")
                        
                    case .failure(let error):
                        print("Job failed: \(error.localizedDescription)")
                        
                    }
                }
            } else {
                cell.img.image = self.visiting_front
            }
            cell.lblTxt.attributedText = NSMutableAttributedString().boldNew("Certificate Must show").normalNew("\nBusiness Name\nAddress\nPhone No")
            if self.uploadedDoc.contains("visiting_front") {
                cell.uploadBtn.setTitle("Uploaded", for: .normal)
                cell.uploadBtn.backgroundColor = UIColor.systemGreen
            } else {
                cell.uploadBtn.setTitle("Upload", for: .normal)
                cell.uploadBtn.backgroundColor = UIColor.init(rgb: 0x3E75CF)
            }
        } else if indexPath.row == 6 {
            if self.statusArr[indexPath.row] == "3" {
                cell.view1.layer.borderColor = UIColor.red.cgColor
                cell.view1.layer.borderWidth = 1
            }
            if self.visiting_back == nil {
                cell.img.kf.indicatorType = .activity
                cell.img.kf.setImage(with: URL(string: self.imgLink[indexPath.row]),placeholder: nil,options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
                    switch result {
                    case .success(let value):
                        print("Task done for: \(value.source.url?.absoluteString ?? "")")
                        
                    case .failure(let error):
                        print("Job failed: \(error.localizedDescription)")
                        
                    }
                }
            } else {
                cell.img.image = self.visiting_back
            }
            cell.lblTxt.attributedText = NSMutableAttributedString().boldNew("Certificate Must show").normalNew("\nRegistration Number\nLegal Name\nTrader Name")
            if self.uploadedDoc.contains("visiting_back") {
                cell.uploadBtn.setTitle("Uploaded", for: .normal)
                cell.uploadBtn.backgroundColor = UIColor.systemGreen
            } else {
                cell.uploadBtn.setTitle("Upload", for: .normal)
                cell.uploadBtn.backgroundColor = UIColor.init(rgb: 0x3E75CF)
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return self.tableView.frame.height / 2
        }
        return 200
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.from = "gst_front"
        } else if indexPath.row == 1 {
            self.from = "gst_back"
        } else if indexPath.row == 2 {
            self.from = "pan"
        } else if indexPath.row == 3 {
            self.from = "adhar_front"
        } else if indexPath.row == 4 {
            self.from = "adhar_back"
        } else if indexPath.row == 5 {
            self.from = "visiting_front"
        } else if indexPath.row == 6 {
            self.from = "visiting_back"
        }
        self.performSegue(withIdentifier: "uploadoc", sender: self)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! wrongDocCell
        cell.img.image = self.imgs[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width / 3, height: self.collectionView.frame.height)
    }
}
extension kycListVC:UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.profileImg = (info[.originalImage] as! UIImage)
        self.imgMain.image = self.profileImg
        picker.dismiss(animated: true, completion: nil)
    }
}
