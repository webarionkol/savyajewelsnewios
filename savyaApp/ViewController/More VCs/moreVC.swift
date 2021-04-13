//
//  moreVC.swift
//  savyaApp
//
//  Created by Yash on 8/9/19.
//  Copyright © 2019 Yash Rathod. All rights reserved.
//

import Foundation
import UIKit

class moreVC:RootBaseVC,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tablee:UITableView!
    let lbls:[String] = ["Terms and Condition"]
    let imgs:[UIImage] = [UIImage(named: "terms")!]
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "terms" {
            _ = segue.destination as! termsVC
        }
    }
    @IBAction func back(_ sender:UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.lbls.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! contactusCell
        cell.lbl.text = self.lbls[indexPath.row]
        cell.img.image = self.imgs[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.performSegue(withIdentifier: "terms", sender: self)
        }
    }
}
