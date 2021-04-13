//
//  kycVC.swift
//  savyaApp
//
//  Created by Yash on 1/30/20.
//  Copyright © 2020 Yash Rathod. All rights reserved.
//

import Foundation
import UIKit

class kycVC:UIViewController {
    
    
    let names = ["GST No","PAN No","AADHAR No","VISITING CARD"]
    var values = [String]()
    @IBOutlet weak var tableView:subtableView!
    var gst = ""
    var pan = ""
    var dataToSend = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.getAllDAta()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
         self.tableView.invalidateIntrinsicContentSize()
    }
    func getAllDAta() {
        APIManager.shareInstance.getCurrentProfile(vc: self) { (pro,kyc,url) in
            self.values.append(pro.gst_no)
            self.values.append(pro.pan_no)
            
            self.values.append("")
            self.values.append("")
            
            self.tableView.reloadData()
            
        }
    }
    @IBAction func backBtn(_ sender:UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @objc func showActionSheet(_ sender:UIButton) {
        let action = UIAlertController(title: "Please Select Any One", message: "", preferredStyle: .actionSheet)
        action.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_) in
            self.showCamera(tag: sender.tag)
        }))
        action.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (_) in
            self.showGalery(tag: sender.tag)
        }))
        action.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (_) in
            
        }))
        if let popoverController = action.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
        }
        self.present(action, animated: true, completion: nil)
        
    }
    func showGalery(tag:Int) {
        let img = UIImagePickerController()
        img.delegate = self
        img.sourceType = .savedPhotosAlbum
        img.allowsEditing = true
        img.view.tag = tag
        self.present(img, animated: true, completion: nil)
    }
    func showCamera(tag:Int) {
        let img = UIImagePickerController()
        img.delegate = self
        img.sourceType = .camera
        img.allowsEditing = true
        img.view.tag = tag
        self.present(img, animated: true, completion: nil)
    }
    @objc func uploadDoc(_ sender:UIButton) {
        let cell1 = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! kycCell1
        let cell2 = self.tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! kycCell1
        let cell3 = self.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! kycCell1
        let cell4 = self.tableView.cellForRow(at: IndexPath(row: 3, section: 0)) as! kycCell1
        self.dataToSend.append(["img1Data" : cell1.img1.image!.jpegData(compressionQuality: 0.6) as Any,"img1MimeType" : "Image/jpg"])
        self.dataToSend.append(["img2Data" : cell2.img1.image!.jpegData(compressionQuality: 0.6) as Any,"img2MimeType" : "Image/jpg"])
        self.dataToSend.append(["img3Data" : cell3.img1.image!.jpegData(compressionQuality: 0.6) as Any,"img3MimeType" : "Image/jpg"])
        self.dataToSend.append(["img4Data" : cell4.img1.image!.jpegData(compressionQuality: 0.6) as Any,"img4MimeType": "Image/jpg"])
        
        if self.dataToSend.count >= 4 {
           
            APIManager.shareInstance.uploaDoc(gst: cell1.txt1.text!, pan: cell2.txt1.text!, mobile:  Mobile.getMobile(), adhar: cell3.txt1.text ?? "11111111111", imgs: self.dataToSend, vc: self) { (response) in
                if response == "success" {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    self.showAlert(titlee: "Message", message: "Something went wrong")
                }
            }
        } else {
            self.showAlert(titlee: "Message", message: "Please Attach All Docs")
        }
        
    }
}
extension kycVC:UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.names.count + 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "lastcell") as! kycCell2
            cell.btnUpload.layer.cornerRadius = cell.btnUpload.frame.height / 2
            cell.btnUpload.clipsToBounds = true
            cell.btnUpload.addTarget(self, action: #selector(uploadDoc(_:)), for: .touchUpInside)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! kycCell1
            cell.lbl1.text = self.names[indexPath.row]
            cell.btnUpload.tag = indexPath.row
            if self.values.count > 0 {
                cell.txt1.text = self.values[indexPath.row]
            }
            
            cell.btnUpload.addTarget(self, action: #selector(showActionSheet(_:)), for: .touchUpInside)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 4 {
            return 90
        } else {
            return 195
        }
    }
}

extension kycVC:UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if picker.view.tag == 0 {
            let img = info[.editedImage] as! UIImage
            let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! kycCell1
            cell.img1.image = img
            picker.dismiss(animated: true, completion: nil)
        } else if picker.view.tag == 1 {
            let img = info[.editedImage] as! UIImage
            let cell = self.tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! kycCell1
            cell.img1.image = img
            picker.dismiss(animated: true, completion: nil)
        } else if picker.view.tag == 2 {
            let img = info[.editedImage] as! UIImage
            let cell = self.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! kycCell1
            cell.img1.image = img
            picker.dismiss(animated: true, completion: nil)
        } else if picker.view.tag == 3 {
            let img = info[.editedImage] as! UIImage
            let cell = self.tableView.cellForRow(at: IndexPath(row: 3, section: 0)) as! kycCell1
            cell.img1.image = img
            picker.dismiss(animated: true, completion: nil)
        }
    }
}
