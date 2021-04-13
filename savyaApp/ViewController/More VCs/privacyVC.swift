//
//  privacyVC.swift
//  savyaApp
//
//  Created by Yash on 8/9/19.
//  Copyright © 2019 Yash Rathod. All rights reserved.
//

import Foundation
import UIKit

class privacyVC:RootBaseVC {
    
    @IBOutlet weak var tableView:UITableView!
    let names = ["Buying","Selling","Return And Payment", "Term & Condition"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
   
    @IBAction func back(_ sender:UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "aboutus" {
            let dvc = segue.destination as! aboutUSVC
            let row = (sender as! IndexPath).row
            if row == 0 {
                dvc.pageToOpen = PageToOpen.buying
            } else if row == 1 {
                dvc.pageToOpen = PageToOpen.selling
            } else if row == 2 {
                dvc.pageToOpen = PageToOpen.returnPayment
            } else if row == 3 {
               dvc.pageToOpen = PageToOpen.termCondition
            }
        }
    }
}
extension privacyVC:UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.names.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! PrivacyPolicyCell
        cell.titleLabel.text = self.names[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "aboutus", sender: indexPath)
    }
}
