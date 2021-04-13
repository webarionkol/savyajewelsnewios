//
//  addressbookVC.swift
//  savyaApp
//
//  Created by Yash on 6/17/19.
//  Copyright © 2019 Yash Rathod. All rights reserved.
//

import Foundation
import UIKit
import Alamofire


class addressBookVC:RootBaseVC,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UITextFieldDelegate {
    
    @IBOutlet weak var tablee:UITableView!
    var addr:Address?
    var fname = ""
    var lname = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(addressBookVC.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(addressBookVC.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        let cellName = self.tablee.cellForRow(at: IndexPath(row: 1, section: 0)) as! addrCell2
        if textField == cellName.fnameTxt {
            self.fname = cellName.fnameTxt.text ?? ""
        } else if textField == cellName.lnameTxt {
            self.lname = cellName.lnameTxt.text ?? ""
        }
        
        
    }
    @objc func saveBtn() {
        
        let cellName = self.tablee.cellForRow(at: IndexPath(row: 1, section: 0)) as! addrCell2
        let cellCountry = self.tablee.cellForRow(at: IndexPath(row: 2, section: 0)) as! addrCell3
        let cellAddress = self.tablee.cellForRow(at: IndexPath(row: 3, section: 0)) as! addrCell4
        let cellPincode = self.tablee.cellForRow(at: IndexPath(row: 4, section: 0)) as! addrCell5
        let cellCity = self.tablee.cellForRow(at: IndexPath(row: 5, section: 0)) as! addrCell6
        let cellMobile = self.tablee.cellForRow(at: IndexPath(row: 6, section: 0)) as! addrCell7
        
        
        if cellName.fnameTxt.text == "" {
            self.showAlert(titlee: "Message", message: "Please Enter First Name")
            return
        }
        if cellName.lnameTxt.text == "" {
            self.showAlert(titlee: "Message", message: "Please Enter Last Name")
            return
        }
        if cellCountry.countryTxt.text == "" {
            self.showAlert(titlee: "Message", message: "Please Enter Country")
            return
        }
        if cellAddress.addrTxt.text == "" {
            self.showAlert(titlee: "Message", message: "Please Enter Address")
            return
        }
        if cellPincode.pincodeTxt.text == "" {
            self.showAlert(titlee: "Message", message: "Please Enter Pincode")
            return
        }
        if cellCity.cityTxt.text == "" {
            self.showAlert(titlee: "Message", message: "Please Enter City")
            return
        }
        if cellCity.regionTxt.text == "" {
            self.showAlert(titlee: "Message", message: "Please Enter Region")
            return
        }
        if cellMobile.mobileTxt.text == "" {
            self.showAlert(titlee: "Message", message: "Please Enter Mobile No.")
            return
        }
        
        if self.addr?.first == nil {
            APIManager.shareInstance.addAddress(first: cellName.fnameTxt.text ?? "No name", last: cellName.lnameTxt.text ?? "", country: cellCountry.countryTxt.text ?? "", address: cellAddress.addrTxt.text ?? "", pincode: cellPincode.pincodeTxt.text ?? "", city: cellCity.cityTxt.text ?? "", region: cellCity.regionTxt.text ?? "", mobileno: cellMobile.mobileTxt.text ?? "", method: .post, vc: self) { (str) in
                if str == "success" {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        } else {
            APIManager.shareInstance.updateAddress(first: cellName.fnameTxt.text ?? "No name", last: cellName.lnameTxt.text ?? "", country: cellCountry.countryTxt.text ?? "", address: cellAddress.addrTxt.text ?? "", pincode: cellPincode.pincodeTxt.text ?? "", city: cellCity.cityTxt.text ?? "", region: cellCity.regionTxt.text ?? "", mobileno: cellMobile.mobileTxt.text ?? "", addrid: self.addr?.id.toString() ?? "1", vc: self) { (str) in
                if str == "success" {
                    self.dismiss(animated: true, completion: nil)
                }
            }
            
        }
        
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    @objc func showActionSheet(sender:UIButton) {
        let actionSheet = UIAlertController(title: "Message", message: "Please Select any one", preferredStyle: .actionSheet)
        actionSheet.popoverPresentationController?.sourceRect = sender.frame
        actionSheet.popoverPresentationController?.sourceView = sender
        actionSheet.addAction(UIAlertAction(title: "Mr.", style: .default, handler: { (_) in
            let cellName = self.tablee.cellForRow(at: IndexPath(row: 1, section: 0)) as! addrCell2
            cellName.designationBtn.setTitle("Mr.", for: .normal)
        }))
        actionSheet.addAction(UIAlertAction(title: "Miss.", style: .default, handler: { (_) in
            let cellName = self.tablee.cellForRow(at: IndexPath(row: 1, section: 0)) as! addrCell2
            cellName.designationBtn.setTitle("Miss.", for: .normal)
        }))
        actionSheet.addAction(UIAlertAction(title: "Mrs.", style: .default, handler: { (_) in
            let cellName = self.tablee.cellForRow(at: IndexPath(row: 1, section: 0)) as! addrCell2
            cellName.designationBtn.setTitle("Mrs.", for: .normal)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (_) in
            
        }))
        self.present(actionSheet, animated: true, completion: nil)
    }
    @objc func keyboardWillShow(_ notification:Notification) {

        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.tablee.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }
    @objc func keyboardWillHide(_ notification:Notification) {

        if ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            self.tablee.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    @IBAction func backBtn(_ sender:UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell1 = tableView.dequeueReusableCell(withIdentifier: "cell1") as! addrCell1
            
            return cell1
        } else if indexPath.row == 1 {
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "cell2") as! addrCell2
            cell2.fnameTxt.placeholder = "First Name"
            cell2.lnameTxt.placeholder = "Last Name"
            cell2.fnameTxt.text = self.addr?.first ?? ""
            cell2.lnameTxt.text = self.addr?.last ?? ""
            if cell2.fnameTxt.text == "" {
                cell2.fnameTxt.text = self.fname
            }
            if cell2.lnameTxt.text == "" {
                cell2.lnameTxt.text = self.lname
            }
            cell2.designationBtn.addTarget(self, action: #selector(showActionSheet(sender:)), for: .touchUpInside)
            cell2.fnameTxt.delegate = self
            cell2.lnameTxt.delegate = self
            return cell2
        } else if indexPath.row == 2 {
            let cell3 = tableView.dequeueReusableCell(withIdentifier: "cell3") as! addrCell3
            cell3.countryTxt.text = "India"
            return cell3
        } else if indexPath.row == 3 {
            let cell4 = tableView.dequeueReusableCell(withIdentifier: "cell4") as! addrCell4
            cell4.addrTxt.delegate = self
            cell4.addrTxt.text = "Address"
            cell4.addrTxt.textColor = UIColor.lightGray
            cell4.addrTxt.text = self.addr?.address ?? ""
            return cell4
        } else if indexPath.row == 4 {
            let cell5 = tableView.dequeueReusableCell(withIdentifier: "cell5") as! addrCell5
            cell5.pincodeTxt.keyboardType = .numberPad
            cell5.pincodeTxt.text = self.addr?.pincode ?? ""
            return cell5
        } else if indexPath.row == 5 {
            let cell6 = tableView.dequeueReusableCell(withIdentifier: "cell6") as! addrCell6
            cell6.cityTxt.text = self.addr?.city ?? ""
            cell6.regionTxt.text = self.addr?.region ?? ""
            return cell6
        } else if indexPath.row == 6 {
            let cell7 = tableView.dequeueReusableCell(withIdentifier: "cell7") as! addrCell7
            cell7.mobileTxt.keyboardType = .numberPad
            cell7.mobileTxt.text = self.addr?.mobileno ?? ""
            return cell7
        } else {
            let cell8 = tableView.dequeueReusableCell(withIdentifier: "cell8") as! addrCell8
            cell8.saveBtn.cornerRadius(radius: cell8.saveBtn.frame.height / 2)
            cell8.saveBtn.addTarget(self, action: #selector(saveBtn), for: .touchUpInside)
            return cell8
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return self.tablee.frame.height / 3
        } else if indexPath.row == 1 {
            return UITableView.automaticDimension
        } else if indexPath.row == 2 {
            return UITableView.automaticDimension
        } else if indexPath.row == 3 {
            return 120
        } else if indexPath.row == 4 {
            return UITableView.automaticDimension
        } else if indexPath.row == 5 {
            return UITableView.automaticDimension
        } else if indexPath.row == 6 {
            return 83
        } else {
            return 50
        }
    }
   
}
