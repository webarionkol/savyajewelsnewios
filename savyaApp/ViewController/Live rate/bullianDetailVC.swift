//
//  bullianDetailVC.swift
//  savyaApp
//
//  Created by Yash on 5/9/20.
//  Copyright © 2020 Yash Rathod. All rights reserved.
//

import UIKit
import MessageUI
import MapKit


class bullianDetailVC: RootBaseVC,MFMailComposeViewControllerDelegate {

    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var share:UIButton!
    var bulliaid = ""
    var singleBullian:Bullian?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getAllData()
    }
    @IBAction func backBtnn(_ sender:UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    func getAllData() {
        APIManager.shareInstance.getBullianDetails(cityid: self.bulliaid, vc: self) { (bullian) in
            self.singleBullian = bullian[0]
            self.tableView.reloadData()
        }
    }
    @objc func openDialerMobile(_ sender:UIButton) {
        if self.singleBullian?.telephone != "" {
            let alert = UIAlertController.init(title: "Message", message: "Which Number to Call?", preferredStyle: .actionSheet)
            if let popoverController = alert.popoverPresentationController {
                popoverController.sourceView = sender
                popoverController.sourceRect = sender.bounds
            }
            alert.addAction(UIAlertAction.init(title: self.singleBullian?.mobile, style: .default, handler: { (_) in
                if let url = URL(string: "tel://\(self.singleBullian?.mobile ?? "")"), UIApplication.shared.canOpenURL(url) {
                    if #available(iOS 10, *) {
                        UIApplication.shared.open(url)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            }))
            alert.addAction(UIAlertAction.init(title: self.singleBullian?.telephone, style: .default, handler: { (_) in
                if let url = URL(string: "tel://\(self.singleBullian?.telephone ?? "")"), UIApplication.shared.canOpenURL(url) {
                    if #available(iOS 10, *) {
                        UIApplication.shared.open(url)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            }))
            alert.addAction(UIAlertAction.init(title: "Cancel", style: .destructive, handler: { (_) in
                
            }))
            self.present(alert, animated: true, completion: nil)
        }
        if let url = URL(string: "tel://\(self.singleBullian?.mobile ?? "")"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    @objc func openDialerLandLine(_ sender:UIButton) {
        if let url = URL(string: "tel://\(self.singleBullian?.telephone ?? "")"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    @objc func openMap(_ sender:UIButton) {
        let lat = Double(singleBullian?.latitude ?? "0")
        let long = Double(singleBullian?.longitude ?? "0")
        let coordinate = CLLocationCoordinate2DMake(lat!,long!)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
        mapItem.name = singleBullian?.city
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeKey])
    }
    @objc func openMail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([self.singleBullian?.email ?? ""])
            mail.setMessageBody("<p>Contact Email!</p>", isHTML: true)

            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    @IBAction func shareBtn(_ sender:UIButton) {
        // text to share
        let text = "Shop Name:\(self.singleBullian?.shopName ?? "")\n About:\(self.singleBullian?.about ?? "")\n Name:\(self.singleBullian?.name ?? "")\n Contact:\(self.singleBullian?.mobile ?? "")\n Address:\(self.singleBullian?.address ?? "")\n Download Savya Jewels Business:https://apps.apple.com/us/app/id1472834371"

        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.share

        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]

        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
}
extension bullianDetailVC:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1") as! bullianCell1
            cell.img2.cornerRadius(radius: cell.img2.frame.height / 2)
            cell.lblName2.text = ""//self.singleBullian?.shopName ?? ""
            cell.lblName.text = self.singleBullian?.shopName ?? ""
            cell.custName.text = "Name:" + (self.singleBullian?.name ?? "")
            cell.img1.kf.indicatorType = .activity
            cell.img1.kf.setImage(with: URL(string: self.singleBullian?.coverImage ?? "" ),placeholder: nil,options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
                switch result {
                case .success(let value):
                    print("Task done for: \(value.source.url?.absoluteString ?? "")")
                    
                case .failure(let error):
                    print("Job failed: \(error.localizedDescription)")
                    
                }
            }
            cell.img2.kf.indicatorType = .activity
            cell.img2.kf.setImage(with: URL(string: self.singleBullian?.image ?? ""),placeholder: nil,options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
                switch result {
                case .success(let value):
                    print("Task done for: \(value.source.url?.absoluteString ?? "")")
                    
                case .failure(let error):
                    print("Job failed: \(error.localizedDescription)")
                    
                }
            }
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2") as! bullianCell2
            cell.view1.layer.borderColor = UIColor.lightGray.cgColor
            cell.view1.layer.borderWidth = 0.7
            cell.lbl1.text = self.singleBullian?.about
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell3") as! bullianCell3
            cell.view1.layer.borderColor = UIColor.lightGray.cgColor
            cell.view1.layer.borderWidth = 0.7
            cell.btn2.setTitle((self.singleBullian?.mobile ?? "") + "," + (self.singleBullian?.telephone ?? ""), for: .normal)
            cell.btn4.setTitle(self.singleBullian?.email, for: .normal)
            cell.btn2.addTarget(self, action: #selector(openDialerMobile(_:)), for: .touchUpInside)
            cell.btn4.addTarget(self, action: #selector(openMail), for: .touchUpInside)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell4") as! bullianCell4
            cell.view1.layer.borderColor = UIColor.lightGray.cgColor
            cell.addLbl.numberOfLines = 0
            cell.view1.layer.borderWidth = 0.7
            cell.addLbl.text = self.singleBullian?.address
            cell.btnDirection.addTarget(self, action: #selector(openMap(_:)), for: .touchUpInside)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            if UIDevice.current.userInterfaceIdiom == .pad {
                return 450
            }
            return 450
        } else if indexPath.row == 1 {
            return UITableView.automaticDimension
        } else if indexPath.row == 2 {
            return 122
        } else {
            return UITableView.automaticDimension
        }
    }
}
class bullianCell1:UITableViewCell {
    
    @IBOutlet weak var img1:UIImageView!
    @IBOutlet weak var img2:UIImageView!
    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var lblName2:UILabel!
    @IBOutlet weak var custName:UILabel!
    
}
class bullianCell2:UITableViewCell {
    
    @IBOutlet weak var view1:UIView!
    @IBOutlet weak var lbl1:UILabel!
    
    
    
}

class bullianCell3:UITableViewCell {
    
    @IBOutlet weak var view1:UIView!
    @IBOutlet weak var lbl1:UILabel!
    
   
    @IBOutlet weak var btn1:UIButton!
    @IBOutlet weak var btn2:UIButton!
    @IBOutlet weak var btn3:UIButton!
    @IBOutlet weak var btn4:UIButton!
    @IBOutlet weak var btn5:UIButton!
    
    
}
class bullianCell4:UITableViewCell {
    
    @IBOutlet weak var view1:UIView!
    @IBOutlet weak var lbl1:UILabel!
    @IBOutlet weak var addLbl:UILabel!
    @IBOutlet weak var btnDirection:UIButton!
    
}
