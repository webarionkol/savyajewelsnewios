//
//  kycInfoVC.swift
//  savyaApp
//
//  Created by Yash on 5/29/20.
//  Copyright © 2020 Yash Rathod. All rights reserved.
//

import UIKit

class kycInfoVC: RootBaseVC {

    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var kycBtn:UIButton!
    var isDocumentVerified: Bool = false
    
    let lbl1 = ["Exclusive Prices","Exclusive selection"]
    let lbl2 = ["Exclusive Access to schemes and program to unlock the best price on Savya Jewels business","Access to exclusive selection from brand and manufacture"]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.kycBtn.cornerRadius(radius: self.kycBtn.frame.height / 2)
        if isDocumentVerified {
            kycBtn.setTitle("KYC VERIFIED", for: .normal)
            kycBtn.backgroundColor = .systemGreen
        } else {
            kycBtn.setTitle("VERIFY YOUR BUSINESS NOW", for: .normal)
            kycBtn.backgroundColor = #colorLiteral(red: 0.9019607843, green: 0.4549019608, blue: 0.1764705882, alpha: 1)
        }
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.showsHorizontalScrollIndicator = false
        self.tableView.showsVerticalScrollIndicator = false
    }
    @IBAction func backBtn(_ sender:UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func verifyBusinessBtn(_ sender:UIButton) {
        if isDocumentVerified {
            let alert = UIAlertController(title: "Savya Jewels Business", message: "Your account is already KYC verified. Click 'OK' if you want to update KYC document", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                self.performSegue(withIdentifier: "kycList", sender: self)
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            self.performSegue(withIdentifier: "kycList", sender: self)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "kycList" {
            let dvc = segue.destination as! kycListVC
            dvc.isverified = self.isDocumentVerified
          
        }
    }
}
extension kycInfoVC:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1") as! kycinfoCell1
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2") as! kycinfoCell2
            cell.lbl1.text = self.lbl1[indexPath.row - 1]
            cell.lbl2.text = self.lbl2[indexPath.row - 1]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2") as! kycinfoCell2
            cell.lbl1.text = self.lbl1[indexPath.row - 1]
            cell.lbl2.text = self.lbl2[indexPath.row - 1]
            return cell
        }
    }
}

class kycinfoCell1:UITableViewCell {
    

}
class kycinfoCell2:UITableViewCell {
    
    @IBOutlet weak var lbl1:UILabel!
    @IBOutlet weak var lbl2:UILabel!
}
