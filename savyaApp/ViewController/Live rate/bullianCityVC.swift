//
//  bullianCityVC.swift
//  savyaApp
//
//  Created by Yash on 5/9/20.
//  Copyright © 2020 Yash Rathod. All rights reserved.
//

import UIKit

class bullianCityVC: RootBaseVC {

    @IBOutlet weak var tableView:UITableView!
    var allCirt = [BullianCity]()
    var cityid = ""
    var sendid = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadAnimation()
        self.getAllData()
    }
    func getAllData() {
        APIManager.shareInstance.getAllBullianCity(cityid: self.cityid, vc: self) { (all) in
            self.allCirt = all
            if all.count == 0 {
                let alert = UIAlertController.init(title: "Message", message: "No Cities Found", preferredStyle: .alert)
                alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { (_) in
                    self.removeAnimation()
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            }
            self.tableView.reloadData()
        }
    }
    @IBAction func backBtnn(_ sender:UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "proceed" {
            let dvc = segue.destination as! bullianListVC
            dvc.cityid = self.sendid
        }
    }
}
extension bullianCityVC:UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allCirt.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = self.allCirt[indexPath.row].city
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.sendid = self.allCirt[indexPath.row].id.toString()
        self.performSegue(withIdentifier: "proceed", sender: self)
    }
}
