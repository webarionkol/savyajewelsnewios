//
//  notificationVC.swift
//  savyaApp
//
//  Created by Yash on 6/17/19.
//  Copyright © 2019 Yash Rathod. All rights reserved.
//

import Foundation
import UIKit

class notificationVC:RootBaseVC,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tablee:UITableView!
    let apis = APIManager()
    var notifs = [Notifications]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadAnimation()
        self.getAllData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    func getAllData() {
        apis.getAllNotifications(user_id: "1", vc: self) { (notif) in
            self.notifs = notif
            self.tablee.reloadData()
            self.removeAnimation()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notifs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! notificationCell
        let notifInd = self.notifs[indexPath.row]
        cell.mainView.layer.cornerRadius = 10
        cell.mainView.clipsToBounds = true
        cell.mainView.layer.borderColor = UIColor.lightGray.cgColor
        cell.mainView.layer.borderWidth = 1
        cell.dateLbl.numberOfLines = 0
        cell.dateView.layer.cornerRadius = cell.dateView.frame.height / 2
        cell.dateView.clipsToBounds = true
        cell.dateView.layer.borderWidth = 0.5
        cell.dateView.layer.borderColor = UIColor.black.cgColor
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM"
        
        let dateFormatterPrintt = DateFormatter()
        dateFormatterPrintt.dateFormat = "dd"

        if let date = dateFormatterGet.date(from: notifInd.date) {
            print(dateFormatterPrint.string(from: date))
            cell.dateLbl.text = "\(dateFormatterPrintt.string(from: date))\n\(dateFormatterPrint.string(from: date))"
        } else {
           print("There was an error decoding the string")
        }
        let formattedString = NSMutableAttributedString()
        formattedString
            .bold(notifInd.title + "\n")
            .normal(notifInd.message)

       
        cell.contentLbl.attributedText = formattedString
        
        
        cell.timeLbl.text = "4:40 PM"
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 116
    }
}
