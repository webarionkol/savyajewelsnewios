//
//  filterPopupVC.swift
//  savyaApp
//
//  Created by Yash on 1/12/20.
//  Copyright © 2020 Yash Rathod. All rights reserved.
//

import Foundation
import UIKit

class filterpopUpVC:UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView1:UITableView!
    @IBOutlet weak var tableView2:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView1 {
            return 1
        } else {
            return 1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableView1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            return cell!
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            return cell!
        }
    }
}
