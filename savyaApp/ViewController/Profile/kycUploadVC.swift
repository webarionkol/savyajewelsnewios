//
//  File.swift
//  savyaApp
//
//  Created by Yash on 3/9/20.
//  Copyright © 2020 Yash Rathod. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import AVKit
import Material
import Toast_Swift

protocol docUpdateDelegate:class {
    func docValues(gst:String,pan:String,adhar:String,visiting:String)
}

protocol gstUploadFront:class {
    func gstUplaodDoc(gst_front:UIImage,gstnumber:String)
}
protocol gstUploadBack:class {
    func gstUplaodDoc(gst_back:UIImage)
}
protocol panUpload:class {
    func panUploadDoc(pan:UIImage,pannumber:String)
}
protocol adharUploadFornt:class {
    func adharuploadFront(adhar_front:UIImage,adharnumber:String)
}
protocol adharUploadBack:class {
    func adharuploadBack(adhar_back:UIImage)
}
protocol visitingUploadFront:class {
    func visitingFornt(card_front:UIImage)
}
protocol visitingUploadBack:class {
    func visitingBack(card_back:UIImage)
}
class kycUploadVC:RootBaseVC,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var img:UIImageView!
    @IBOutlet weak var uploadView:UIView!
    @IBOutlet weak var collectionView:UICollectionView!
    @IBOutlet weak var txt1:TextField!
    @IBOutlet weak var doneBrn:UIButton!
    var titleLbl = ""
    let imgs = [UIImage.init(named: "wdoc1"),UIImage.init(named: "wdoc2"),UIImage.init(named: "wdoc3"),UIImage.init(named: "wdoc4"),UIImage.init(named: "wdoc5")]
    let vision = Vision.vision()
    var from = ""
    var newfrom = 1
    var delegate:docUpdateDelegate?
    var gstFrontDelegate:gstUploadFront?
    var gstbackDelegate:gstUploadBack?
    var panDelegate:panUpload?
    var adharFrontDelegate:adharUploadFornt?
    var adharBackDelegate:adharUploadBack?
    var visitingFrontDelegate:visitingUploadFront?
    var visitingBackDelegate:visitingUploadBack?
    var selectedImg:UIImage?
    
    //https://s3.ap-south-1.amazonaws.com/www.savyajewelsbusiness.com/KYC+IMAGE/1.+GST+(1)/GST_Front-0.jpg
    let gstimg = ["https://s3.ap-south-1.amazonaws.com/www.savyajewelsbusiness.com/KYC+IMAGE/1.+GST+(1)/GST_Front-1.jpg",
                  "https://s3.ap-south-1.amazonaws.com/www.savyajewelsbusiness.com/KYC+IMAGE/1.+GST+(1)/GST_Front-2.jpg",
                  "https://s3.ap-south-1.amazonaws.com/www.savyajewelsbusiness.com/KYC+IMAGE/1.+GST+(1)/GST_Front-3.jpg",
                  "https://s3.ap-south-1.amazonaws.com/www.savyajewelsbusiness.com/KYC+IMAGE/1.+GST+(1)/GST_Front-4.jpg"]
    let gstBack = ["https://s3.ap-south-1.amazonaws.com/www.savyajewelsbusiness.com/KYC+IMAGE/2.+GST+(2)/GST_Back-1.jpg",
                   "https://s3.ap-south-1.amazonaws.com/www.savyajewelsbusiness.com/KYC+IMAGE/2.+GST+(2)/GST_Back-2.jpg",
                   "https://s3.ap-south-1.amazonaws.com/www.savyajewelsbusiness.com/KYC+IMAGE/2.+GST+(2)/GST_Back-3.jpg",
                   "https://s3.ap-south-1.amazonaws.com/www.savyajewelsbusiness.com/KYC+IMAGE/2.+GST+(2)/GST_Back-4.jpg"]
    let pan = ["https://s3.ap-south-1.amazonaws.com/www.savyajewelsbusiness.com/KYC+IMAGE/5.+PAN/PANCARD-1.jpg",
               "https://s3.ap-south-1.amazonaws.com/www.savyajewelsbusiness.com/KYC+IMAGE/5.+PAN/PANCARD-2.jpg",
               "https://s3.ap-south-1.amazonaws.com/www.savyajewelsbusiness.com/KYC+IMAGE/5.+PAN/PANCARD-3.jpg"]
    let adhar = ["https://s3.ap-south-1.amazonaws.com/www.savyajewelsbusiness.com/KYC+IMAGE/3.+Aadhar+(1)/Aadhar_Front-1.jpg",
                 "https://s3.ap-south-1.amazonaws.com/www.savyajewelsbusiness.com/KYC+IMAGE/3.+Aadhar+(1)/Aadhar_Front-2.jpg",
                 "https://s3.ap-south-1.amazonaws.com/www.savyajewelsbusiness.com/KYC+IMAGE/3.+Aadhar+(1)/Aadhar_Front-3.jpg",
                 "https://s3.ap-south-1.amazonaws.com/www.savyajewelsbusiness.com/KYC+IMAGE/3.+Aadhar+(1)/Aadhar_Front-4.jpg"]
    let adhar_back = ["https://s3.ap-south-1.amazonaws.com/www.savyajewelsbusiness.com/KYC+IMAGE/4+Aadhar+(2)/Aadhar_Back-1.jpg",
                      "https://s3.ap-south-1.amazonaws.com/www.savyajewelsbusiness.com/KYC+IMAGE/4+Aadhar+(2)/Aadhar_Back-2.jpg",
                      "https://s3.ap-south-1.amazonaws.com/www.savyajewelsbusiness.com/KYC+IMAGE/4+Aadhar+(2)/Aadhar_Back-3.jpg",
                      "https://s3.ap-south-1.amazonaws.com/www.savyajewelsbusiness.com/KYC+IMAGE/4+Aadhar+(2)/Aadhar_Back-4.jpg"]
    let visiting = ["https://s3.ap-south-1.amazonaws.com/www.savyajewelsbusiness.com/KYC+IMAGE/6.+Visiting+Card/VisitingCard_Front-1.jpg",
                    "https://s3.ap-south-1.amazonaws.com/www.savyajewelsbusiness.com/KYC+IMAGE/6.+Visiting+Card/VisitingCard_Front-2.jpg",
                    "https://s3.ap-south-1.amazonaws.com/www.savyajewelsbusiness.com/KYC+IMAGE/6.+Visiting+Card/VisitingCard_Front-3.jpg"]
    let visitingBack = ["https://s3.ap-south-1.amazonaws.com/www.savyajewelsbusiness.com/KYC+IMAGE/7.+Visiting+Card/VisitingCard_Back-1.jpg",
                        "https://s3.ap-south-1.amazonaws.com/www.savyajewelsbusiness.com/KYC+IMAGE/7.+Visiting+Card/VisitingCard_Back-2.jpg",
                        "https://s3.ap-south-1.amazonaws.com/www.savyajewelsbusiness.com/KYC+IMAGE/7.+Visiting+Card/VisitingCard_Back-3.jpg"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.doneBrn.isHidden = true
        if self.from == "gst_front" || self.from == "gst_back" {
            self.lblTitle.text = "GST Document"
            self.txt1.placeholder = "GST No."
            if self.from == "gst_back" {
                self.txt1.isHidden = true
            }
        } else if self.from == "pan" {
            self.lblTitle.text = "PAN Card"
            self.txt1.placeholder = "PAN No."
        } else if self.from == "adhar_front" || self.from == "adhar_back" {
            self.lblTitle.text = "Aadhar Card"
            self.txt1.placeholder = "Aadhar No."
            if self.from == "adhar_back" {
                self.txt1.isHidden = true
            }
        } else if self.from == "visiting_front" || self.from == "visiting_back" {
            self.lblTitle.text = "Visiting Card"
            self.txt1.isHidden = true
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.uploadView.addDashedBorder()
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
      //  self.uploadView.addDashedBorder()
    }
    @IBAction func backBtn(_ sender:UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func proceedBtn(_ sender:UIButton) {
        self.view.endEditing(true)
        if self.from == "gst_front" {
            if self.txt1.text == "" {
                self.view.makeToast("Please Enter GST No")
                return
               
            } else {
                if self.isValidGSTNumer(gst: self.txt1.text ?? "") {
                    if self.selectedImg != nil {
                        self.gstFrontDelegate?.gstUplaodDoc(gst_front: self.img.image!, gstnumber: self.txt1.text ?? "")
                    } else {
                        self.view.makeToast("Please Add GST Image")
                        return
                    }
                    
                } else {
                    self.view.makeToast("Please Enter a valid GST Number")
                    return
                }
                
            }
            
        } else if self.from == "pan" {
            
            if self.txt1.text == "" {
                self.view.makeToast("Please Enter PAN Number")
                return
            } else {
                if self.validatePANCardNumber(self.txt1.text ?? "") {
                    if self.selectedImg == nil {
                        self.view.makeToast("Please Add PAN Card Image")
                        return
                    } else {
                        self.panDelegate?.panUploadDoc(pan: self.img.image!, pannumber: self.txt1.text ?? "")
                    }
                } else {
                    self.view.makeToast("Please Enter a Valid PAN Number")
                    return
                }
            }
            
        } else if self.from == "adhar_front" {
            
            if self.txt1.text == "" {
                self.view.makeToast("Please Enter Aadhar Card Number")
                return
            } else {
                if VerhoeffAlgorithm.sharedInstance.ValidateVerhoeff(num: self.txt1.text ?? "") {
                    if self.selectedImg == nil {
                        self.view.makeToast("Please Add Aadhar Card Image")
                        return
                    } else {
                        self.adharFrontDelegate?.adharuploadFront(adhar_front: self.img.image!, adharnumber: self.txt1.text ?? "")
                    }
                } else {
                    self.view.makeToast("Please Enter a Valid Aadhar Card Number")
                    return
                }
            }
                
            
            
        } else if self.from == "visiting_front" {
            self.visitingFrontDelegate?.visitingFornt(card_front: self.img.image!)
        } else if self.from == "gst_back" {
            if self.selectedImg == nil {
                self.view.makeToast("Please Add GST back Image")
                return
            } else {
                self.gstbackDelegate?.gstUplaodDoc(gst_back: self.img.image!)
            }
        } else if self.from == "adhar_back" {
            if self.selectedImg == nil {
                self.view.makeToast("Please Add Adhar Back Image")
                return
            } else {
                self.adharBackDelegate?.adharuploadBack(adhar_back: self.img.image!)
            }
            
        } else if self.from == "visiting_back" {
            self.visitingBackDelegate?.visitingBack(card_back: self.img.image!)
        }
        self.dismiss(animated: true, completion: nil)
    }
    func validatePANCardNumber(_ strPANNumber : String) -> Bool{
        let regularExpression = "[A-Z]{5}[0-9]{4}[A-Z]{1}"
        let nsregular = try! NSRegularExpression(pattern: regularExpression, options: .caseInsensitive)
        let panCardValidation = NSPredicate(format : "SELF MATCHES %@", regularExpression)
        nsregular.enumerateMatches(in: strPANNumber, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSRange(location: 0, length: strPANNumber.count), using: { (result: NSTextCheckingResult!, _, _) in
            print(result)
        })
        return panCardValidation.evaluate(with: strPANNumber)
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
    func detectTextOnDevice(image: UIImage?) {
        
      guard let image = image else { return }

      // [START init_text]
      let onDeviceTextRecognizer = vision.onDeviceTextRecognizer()
      // [END init_text]
      // Define the metadata for the image.
      let imageMetadata = VisionImageMetadata()
      imageMetadata.orientation = UIUtilities.visionImageOrientation(from: image.imageOrientation)

      // Initialize a VisionImage object with the given UIImage.
      let visionImage = VisionImage(image: image)
      visionImage.metadata = imageMetadata

      
      process(visionImage, with: onDeviceTextRecognizer)
    }
    @IBAction func selectPhotoBtn(_ sender:UIButton) {
        let action = UIAlertController(title: "Message", message: "Please Select Any One", preferredStyle: .actionSheet)
        action.addAction(UIAlertAction.init(title: "Camera", style: .default, handler: { (_) in
            self.openCamera()
        }))
        action.addAction(UIAlertAction.init(title: "Gallery", style: .default, handler: { (_) in
            self.openGallery()
        }))
        action.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: { (_) in
            
        }))
        if let presenter = action.popoverPresentationController {
            presenter.sourceView = sender
            presenter.sourceRect = sender.bounds
        }
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
    private func process(_ visionImage: VisionImage, with textRecognizer: VisionTextRecognizer?) {
     // textRecognizer?.process(visionImage) { text, error in
//        if self.from == "gst_front" {
//            if self.txt1.text != "" {
//                self.showAlert(titlee: "Message", message: "Please Enter GST Number")
//            } else {
//                 self.gstFrontDelegate?.gstUplaodDoc(gst_front: self.img.image!, gstnumber: self.txt1.text ?? "")
//            }
////            if text == nil {
////                let alert = UIAlertController.init(title: "Message", message: "Please Capture Again GST number not detected", preferredStyle: .alert)
////                alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { (_) in
////                    return
////                }))
////                self.present(alert, animated: true, completion: nil)
////            } else {
////
////                for i in 0 ..< text!.blocks.count {
////                    if i == 1 {
////                        let all = text?.blocks[i].text.components(separatedBy: ":")
////
////                        if all![1].isValidGSTIN() {
////                            self.gstFrontDelegate?.gstUplaodDoc(gst_front: self.img.image!, gstnumber: all![1])
////                        } else {
////                            let alert = UIAlertController.init(title: "Message", message: "Please Capture Again GST number not detected", preferredStyle: .alert)
////                            alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { (_) in
////                                return
////                            }))
////                            self.present(alert, animated: true, completion: nil)
////
////                            break
////                        }
////                    }
////                }
////            }
//        } else if self.from == "gst_back" {
//            if text == nil {
//                let alert = UIAlertController.init(title: "Message", message: "Please Capture Again GST number not detected", preferredStyle: .alert)
//                alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { (_) in
//                    return
//                }))
//                self.present(alert, animated: true, completion: nil)
//            } else {
//                for i in 0 ..< text!.blocks.count {
//                    if UserDefaults.standard.object(forKey: "GSTSET") != nil {
//                        self.gstbackDelegate?.gstUplaodDoc(gst_back: self.img.image!)
//                    } else {
//                        if i == 3 {
//                            let all = text?.blocks[i].text.components(separatedBy: "\n")
//                            if self.isValidGSTNumer(gst: all![0]) {
//                                self.gstbackDelegate?.gstUplaodDoc(gst_back: self.img.image!)
//                            } else {
//                                let alert = UIAlertController.init(title: "Message", message: "Please Capture Again GST number not detected", preferredStyle: .alert)
//                                alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { (_) in
//                                    return
//                                }))
//                                self.present(alert, animated: true, completion: nil)
//                            }
//                        }
//                    }
//
//                }
//            }
//        } else if self.from == "pan" {
//            if text == nil {
//                let alert = UIAlertController.init(title: "Message", message: "Please Capture Again PAN Number not detected", preferredStyle: .alert)
//                alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { (_) in
//                    return
//                }))
//                self.present(alert, animated: true, completion: nil)
//            } else {
//                for i in 0 ..< text!.blocks.count {
//                    if i == 3 {
//                        let all = text!.blocks[i].text.components(separatedBy: "\n")
//                        if self.validatePANCardNumber(all.last!) {
//                            self.panDelegate?.panUploadDoc(pan: self.img.image!, pannumber: "")
//                        } else {
//                            let alert = UIAlertController.init(title: "Message", message: "Please Capture Again PAN number not detected", preferredStyle: .alert)
//                            alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { (_) in
//                                return
//                            }))
//                            self.present(alert, animated: true, completion: nil)
//                        }
//                    }
//                }
//            }
//
//        } else if self.from == "adhar_front" {
//            if text == nil {
//                let alert = UIAlertController.init(title: "Message", message: "Please Capture Again Adhar number not detected", preferredStyle: .alert)
//                alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { (_) in
//                    return
//                }))
//                self.present(alert, animated: true, completion: nil)
//            } else {
//                for i in 0 ..< text!.blocks.count {
//                    if i == 5 {
//                        if text!.blocks[i].text.replacingOccurrences(of: " ", with: "").isNumber {
//                            self.adharFrontDelegate?.adharuploadFront(adhar_front: self.img.image!, adharnumber: "")
//                        } else {
//                            let alert = UIAlertController.init(title: "Message", message: "Please Capture Again Adhar number not detected", preferredStyle: .alert)
//                            alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { (_) in
//                                return
//                            }))
//                            self.present(alert, animated: true, completion: nil)
//                        }
//                    }
//                }
//            }
//        } else if self.from == "adhar_back" {
//            self.adharBackDelegate?.adharuploadBack(adhar_back: self.img.image!)
//        } else if self.from == "visiting_front" {
//            self.visitingFrontDelegate?.visitingFornt(card_front: self.img.image!)
//        } else if self.from == "visiting_back" {
//            self.visitingBackDelegate?.visitingBack(card_back: self.img.image!)
//        }
//        self.dismiss(animated: true, completion: nil)
//
//      }
    }

    private func process(_ visionImage: VisionImage,with documentTextRecognizer: VisionDocumentTextRecognizer?) {
        documentTextRecognizer?.process(visionImage) { text, error in
            guard error == nil, let text = text else {
          
                return
            }
            print(text.text)
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.from == "gst_front" {
            return self.gstimg.count
        } else if self.from == "gst_back" {
            return self.gstBack.count
        } else if self.from == "pan" {
            return self.pan.count
        } else if self.from == "adhar_front" {
            return self.adhar.count
        } else if self.from == "adhar_back" {
            return self.adhar_back.count
        } else if self.from == "visiting_front" {
            return self.visiting.count
        } else if self.from == "visiting_back" {
            return self.visitingBack.count
        }
        return 0
 
//        if self.from == "gst_front" || self.from == "gst_back" {
//            self.lblTitle.text = "GST Document"
//        } else if self.from == "pan" {
//            self.lblTitle.text = "PAN Card"
//        } else if self.from == "adhar_front" || self.from == "adhar_back" {
//            self.lblTitle.text = "Aadhar Card"
//        } else if self.from == "visiting_front" || self.from == "visiting_back" {
//            self.lblTitle.text = "Visiting Card"
//        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! wrongDocCell
        if self.from == "gst_front" {
            cell.img.kf.indicatorType = .activity
            cell.img.kf.setImage(with: URL(string: self.gstimg[indexPath.row]),placeholder: nil,options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
                switch result {
                case .success(let value):
                    print("Task done for: \(value.source.url?.absoluteString ?? "")")
                    
                case .failure(let error):
                    print("Job failed: \(error.localizedDescription)")
                    
                }
            }
        } else if self.from == "gst_back" {
            cell.img.kf.indicatorType = .activity
            cell.img.kf.setImage(with: URL(string: self.gstBack[indexPath.row]),placeholder: nil,options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
                switch result {
                case .success(let value):
                    print("Task done for: \(value.source.url?.absoluteString ?? "")")
                    
                case .failure(let error):
                    print("Job failed: \(error.localizedDescription)")
                    
                }
            }
        } else if self.from == "pan" {
            cell.img.kf.indicatorType = .activity
            cell.img.kf.setImage(with: URL(string: self.pan[indexPath.row]),placeholder: nil,options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
                switch result {
                case .success(let value):
                    print("Task done for: \(value.source.url?.absoluteString ?? "")")
                    
                case .failure(let error):
                    print("Job failed: \(error.localizedDescription)")
                    
                }
            }
        } else if self.from == "adhar_front" {
            cell.img.kf.indicatorType = .activity
            cell.img.kf.setImage(with: URL(string: self.adhar[indexPath.row]),placeholder: nil,options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
                switch result {
                case .success(let value):
                    print("Task done for: \(value.source.url?.absoluteString ?? "")")
                    
                case .failure(let error):
                    print("Job failed: \(error.localizedDescription)")
                    
                }
            }
        } else if self.from == "adhar_back" {
            cell.img.kf.indicatorType = .activity
            cell.img.kf.setImage(with: URL(string: self.adhar_back[indexPath.row]),placeholder: nil,options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
                switch result {
                case .success(let value):
                    print("Task done for: \(value.source.url?.absoluteString ?? "")")
                    
                case .failure(let error):
                    print("Job failed: \(error.localizedDescription)")
                    
                }
            }
        } else if self.from == "visiting_front" {
            cell.img.kf.indicatorType = .activity
            cell.img.kf.setImage(with: URL(string: self.visiting[indexPath.row]),placeholder: nil,options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
                switch result {
                case .success(let value):
                    print("Task done for: \(value.source.url?.absoluteString ?? "")")
                    
                case .failure(let error):
                    print("Job failed: \(error.localizedDescription)")
                    
                }
            }
        } else if self.from == "visiting_back" {
            cell.img.kf.indicatorType = .activity
            cell.img.kf.setImage(with: URL(string: self.visitingBack[indexPath.row]),placeholder: nil,options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
                switch result {
                case .success(let value):
                    print("Task done for: \(value.source.url?.absoluteString ?? "")")
                    
                case .failure(let error):
                    print("Job failed: \(error.localizedDescription)")
                    
                }
            }
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width / 2, height: self.collectionView.frame.height)
    }
}
extension kycUploadVC:UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.img.image = info[.editedImage] as? UIImage
        self.detectTextOnDevice(image: self.img.image!)
        self.selectedImg = info[.editedImage] as? UIImage
        
        picker.dismiss(animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                self.doneBrn.isHidden = false
            }
        }
        
    }
}

/*
 else if self.from == "pan" {
     self.delegate?.docValues(gst: "GSTVALUR", pan: "PANVSLUE", adhar: "", visiting: "")
 } else if self.from == "adhar" {
     self.delegate?.docValues(gst: "GSTVALUE", pan: "PANVALUE", adhar: "ADHARVALUE", visiting: "")
 } else if self.from == "visiting" {
     self.delegate?.docValues(gst: "GSTVALAUE", pan: "PANVALUE", adhar: "ADHARVALUE", visiting: "")
 }
 */

extension String  {
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}
extension String
{
    func isValidGSTIN() -> Bool{ var uniScalars = [Int]();for (index, item) in (self.dropLast().unicodeScalars).enumerated(){ let alpha = Int((48...57 ~= item.value) ?(item.value - 48) : (item.value - 55));let beta = (((index + 1) % 2 == 0) ?2 : 1);  uniScalars.append((alpha * beta < 36) ? alpha * beta : 1 + ( alpha * beta - 36))};let gamma = (uniScalars.reduce(0, +) % 36);return ((self.dropLast() + "\((Character(UnicodeScalar((0...9 ~= (36 - gamma)+48) ?(36 - gamma) : (36 - gamma)+55)!)))") == self ) ? true : false}

}
