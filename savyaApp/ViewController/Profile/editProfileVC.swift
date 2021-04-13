//
//  editProfileVC.swift
//  savyaApp
//
//  Created by Yash on 3/8/20.
//  Copyright © 2020 Yash Rathod. All rights reserved.
//

import Foundation
import UIKit

class editProfileVC:RootBaseVC,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var btnVerify:UIButton!
    @IBOutlet weak var scrollView:UIScrollView!
    var section = ["Profile Picture","Name"]
    var placeholder = ["","","Email","Password","Confirm Password"]
    var img:UIImage!
    var name = ""
    var currenntUser:Profile?
    var profileImg:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.tableView.separatorStyle = .none
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadAnimation()
        self.tableView.tableFooterView = UIView()
        self.btnVerify.cornerRadius(radius: self.btnVerify.frame.height / 2)
        self.getProfile()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    @IBAction func backBtn(_ sender:UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    func getProfile() {
        
        APIManager.shareInstance.getCurrentProfile(vc: self) { (pro,kyc,url) in
            self.currenntUser = pro
            
            self.tableView.invalidateIntrinsicContentSize()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.tableView.reloadData()
            }
            self.removeAnimation()
        }
    }
    @IBAction func editProfile(_ sender:UIButton) {
        let cell1 = self.tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! editProfileCell1
        let cell2 = self.tableView.cellForRow(at: IndexPath.init(row: 2, section: 0)) as! editProfileCell3
        let img = cell1.img.image?.jpegData(compressionQuality: 0.8)
        APIManager.shareInstance.editProfile(image: img!, name: cell2.txt1.text ?? "") { (str) in
            self.dismiss(animated: true, completion: nil)
        }
    }
    @objc func verifyBtn() {
        self.performSegue(withIdentifier: "verify", sender: self)
    }
    @objc func addImage(_ sender:UIButton) {
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1") as! editProfileCell1
            
            if self.profileImg == nil {
                cell.img.kf.indicatorType = .activity
                cell.img.kf.setImage(with: URL(string: self.currenntUser?.image.replacingOccurrences(of: " ", with: "%20") ?? ""),placeholder: UIImage.init(named: "placeholder"),options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
                    switch result {
                    case .success(let value):
                        
                        print("Task done for: \(value.source.url?.absoluteString ?? "")")
                        
                    case .failure(let error):
                        
                        print("Job failed: \(error.localizedDescription) \(String(describing: self.currenntUser?.image.replacingOccurrences(of: " ", with: "%20")))")
                        
                    }
                }
            } else {
                cell.img.image = self.profileImg
            }
            
           // cell.img.image = self.img ?? UIImage.init(named: "placeholder")
            cell.img.layer.cornerRadius = cell.img.frame.height / 2
            cell.img.clipsToBounds = true
            
           // cell.img.backgroundColor = .systemRed
            cell.editBtn.layer.cornerRadius = cell.editBtn.frame.height / 2
            cell.editBtn.clipsToBounds = true
            cell.editBtn.addTarget(self, action: #selector(addImage), for: .touchUpInside)
            return cell
        } else if indexPath.row == 1 {
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "cell2") as! editProfileCell2
           // cell2.btnVerify.layer.cornerRadius = 5
          //  cell2.btnVerify.clipsToBounds = true
           // cell2.btnVerify.addTarget(self, action: #selector(verifyBtn), for: .touchUpInside)
            return cell2
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell3") as! editProfileCell3
            cell.txt1.placeholder = "Name*"
            
            cell.txt1.text = self.currenntUser?.name
            return cell
        } else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell3") as! editProfileCell3
            cell.txt1.placeholder = "Email*"
            cell.txt1.text = self.currenntUser?.email
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell3") as! editProfileCell3
            cell.txt1.placeholder = "Mobile*"
            cell.txt1.text = self.currenntUser?.mobile_no
            cell.txt1.isEnabled = false
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 185
        } else if indexPath.row == 1 {
            return 0
        } else {
            return 70
        }
    }
}
extension editProfileVC:UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.profileImg = (info[.originalImage] as! UIImage)
        self.tableView.reloadRows(at: [IndexPath.init(row: 0, section: 0)], with: .automatic)
        picker.dismiss(animated: true, completion: nil)
    }
}
