//
//  bullianListVC.swift
//  savyaApp
//
//  Created by Yash on 5/9/20.
//  Copyright © 2020 Yash Rathod. All rights reserved.
//

import UIKit

class bullianListVC: RootBaseVC {

    @IBOutlet weak var tableView:UITableView!
    var allCirt = [Bullian]()
    var cityid = ""
    var sendid = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadAnimation()
        self.getAllData()
    }
    func getAllData() {
        APIManager.shareInstance.getBullianList(cityid: self.cityid, vc: self) { (all) in
            self.allCirt = all
            if all.count == 0 {
                let alert = UIAlertController.init(title: "Message", message: "No Bullian Found", preferredStyle: .alert)
                alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { (_) in
                    self.removeAnimation()
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            } else {
                self.removeAnimation()
                self.tableView.reloadData()
            }
            
        }
    }
    @IBAction func backBtnn(_ sender:UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @objc func openDialer(_ sender:UIButton) {
        if let url = URL(string: "tel://\(self.allCirt[sender.tag].mobile)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "proceed" {
            let dvc = segue.destination as! bullianDetailVC
            dvc.bulliaid = self.sendid
        }
    }
}
extension bullianListVC:UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allCirt.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! bullianCell
        cell.viewCorner.cornerRadius(radius: 10)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            cell.viewShadow.dropShadow(color: .lightGray, opacity: 1, offSet: CGSize.init(width: -1, height: 1), radius: 7, scale: true)
        }
        
        cell.viewShadow.backgroundColor = .clear
        
        cell.nameLbl.text = self.allCirt[indexPath.row].shopName
        cell.nameLbl2.text = self.allCirt[indexPath.row].about
        cell.custNameLbl.text = self.allCirt[indexPath.row].name
        cell.img.kf.indicatorType = .activity
        cell.img.kf.setImage(with: URL(string: self.allCirt[indexPath.row].image.replacingOccurrences(of: " ", with: "%20")),placeholder: nil,options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
                
            case .failure(let error):
                print(self.allCirt[indexPath.row].image)
                print("Job failed: \(error.localizedDescription)")
                
            }
        }
        cell.phoneBtn.tag = indexPath.row
        cell.phoneBtn.addTarget(self, action: #selector(openDialer(_:)), for: .touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 117
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.sendid = self.allCirt[indexPath.row].id.toString()
        self.performSegue(withIdentifier: "proceed", sender: self)
    }
}
class bullianCell:UITableViewCell {
    
    @IBOutlet weak var viewShadow:UIView!
    @IBOutlet weak var viewCorner:UIView!
    @IBOutlet weak var img:UIImageView!
    @IBOutlet weak var nameLbl:UILabel!
    @IBOutlet weak var nameLbl2:UILabel!
    @IBOutlet weak var custNameLbl:UILabel!
    @IBOutlet weak var phoneBtn:UIButton!
}
