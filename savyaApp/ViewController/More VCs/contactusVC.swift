//
//  contactusVC.swift
//  savyaApp
//
//  Created by Yash on 8/6/19.
//  Copyright © 2019 Yash Rathod. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import WebKit
import MessageUI

class contactusVC:RootBaseVC,UITableViewDelegate,UITableViewDataSource,MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var mapView:MKMapView!
    @IBOutlet weak var web1:WKWebView!
    @IBOutlet weak var tableView:UITableView!
    let api = APIManager()
    var imgs:[UIImage] = []
    var lbls:[String] = []
    var email = ""
    var website = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "facebook" {
            let dvc = segue.destination as! webViewVC
            dvc.titleLblStr = "Instagram"
            dvc.website = self.website
        } else if segue.identifier == "instagram" {
            let dvc = segue.destination as! webViewVC
            dvc.titleLblStr = "Facebook"
            dvc.website = self.website
        }
        else if segue.identifier == "twitter" {
            let dvc = segue.destination as! webViewVC
            dvc.titleLblStr = "Twitter"
            dvc.website = self.website
        }
        else if segue.identifier == "linkedin" {
            let dvc = segue.destination as! webViewVC
            dvc.titleLblStr = "Linkedin"
            dvc.website = self.website
        }
    }
    func getData() {
        api.getContactUs(vc: self) { (contactus) in
            self.lbls.append(contactus.address)
            self.lbls.append(contactus.email)
            self.lbls.append(contactus.mobile)
          //  self.lbls.append(contactus.landline)
           self.lbls.append(contactus.facebook)
            self.lbls.append(contactus.instagram)
            self.lbls.append(contactus.twitter)
             self.lbls.append(contactus.linkendin)
            
            
            self.imgs.append(UIImage(named: "icons8-address")!)
            self.imgs.append(UIImage(named: "mail")!)
            self.imgs.append(UIImage(named: "phone-1")!)
          //  self.imgs.append(UIImage(named: "landline")!)
            self.imgs.append(UIImage(named: "facebook")!)
            self.imgs.append(UIImage(named: "instagram")!)
            self.imgs.append(UIImage(named: "twitter")!)
            self.imgs.append(UIImage(named: "linkedin")!)
            
            self.email = contactus.email
            self.tableView.reloadData()
            let address = contactus.address
         //   let latandlon = address?.components(separatedBy: ",")
           // let finalLon = latandlon![1].replacingOccurrences(of: " ", with: "")
            let lat = Double(28.5672827)
            let lon = Double(77.3192569)
            let annotation = MKPointAnnotation()
            let centerCoordinate = CLLocationCoordinate2D(latitude: lat, longitude:lon)
            annotation.coordinate = centerCoordinate
            annotation.title = "B-122, IIIrd Floor, Sector-2, Noida, Uttar Pracdesh - 201301"
            self.mapView.addAnnotation(annotation)
            
            
            let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            let region = MKCoordinateRegion(center: centerCoordinate, span: span)
            self.mapView.region = region
        }
    }
    func callNumber(phoneNumber:String) {
        if let phoneCallURL:NSURL = NSURL(string:"tel://\(phoneNumber)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL as URL)) {
                application.open(phoneCallURL as URL, options: [:], completionHandler: nil)
                
            }
        }
    }
    func emailSend() {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
    
        mailComposerVC.setToRecipients([self.email])
        mailComposerVC.setSubject("Contact US")
        mailComposerVC.setMessageBody("Hello Sir", isHTML: false)
        
        return mailComposerVC
    }
    func showSendMailErrorAlert() {
        let alert = UIAlertController(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    @IBAction func back(_ sender:UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.lbls.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! contactusCell
        cell.lbl.numberOfLines = 0
        let str = self.lbls[indexPath.row]
        if str.contains("facebook"){
            cell.lbl.text = "Follow Us On Facebook"
        }else if str.contains("instagram"){
            cell.lbl.text = "Follow Us On Instagram"
        }
        else if str.contains("twitter"){
            cell.lbl.text = "Follow Us On Twitter"
        }
        else if str.contains("linkedin"){
            cell.lbl.text = "Follow Us On Linkedin"
        }
        
        else {
            cell.lbl.text = self.lbls[indexPath.row]
        }
        
       
        cell.img.image = self.imgs[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
        } else if indexPath.row == 1 {
            self.emailSend()
        } else if indexPath.row == 2 {
            self.callNumber(phoneNumber: self.lbls[indexPath.row])
        } else if indexPath.row == 3 {
            self.website = self.lbls[indexPath.row]
            self.performSegue(withIdentifier: "instagram", sender: self)
        } else if indexPath.row == 4 {
            self.website = self.lbls[indexPath.row]
            self.performSegue(withIdentifier: "facebook", sender: self)
        }
        else if indexPath.row == 5 {
            self.website = self.lbls[indexPath.row]
            self.performSegue(withIdentifier: "twitter", sender: self)
        }
        else if indexPath.row == 6 {
            self.website = self.lbls[indexPath.row]
            self.performSegue(withIdentifier: "linkedin", sender: self)
        }
    }
}
