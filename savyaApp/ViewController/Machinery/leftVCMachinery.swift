//
//  leftVC.swift
//  savyaApp
//
//  Created by Yash on 2/27/20.
//  Copyright © 2020 Yash Rathod. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class leftVCMachinery:UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tablee:UITableView!
    
    var arrName = [String]()
    var arrImage = [UIImage]()
    var arrRes = [[String:Any]]()
    var expand = [Bool]()
    let apis = APIManager()
    var sendid = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getAllData()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "proceed" {
            let dvc = segue.destination as! allMachineVC
            dvc.subcata = self.sendid.toString()
        }
    }
    
    func getAllData() {
            let authorization:HTTPHeaders =  ["Authorization":Token.getLatestToken()]
            
            AF.request(NewAPI.machineryDashboard,method: .get,parameters: nil,encoding: JSONEncoding.default,headers: authorization).responseJSON { (responseData) in
                
                APIManager.shareInstance.printEveryThing(responseData: responseData, statusCode: responseData.response?.statusCode ?? 000, url: NewAPI.dashboard, para: "para")
                if responseData.value != nil {
                    
                    let respData = responseData.value as! [String:Any]
                    let respData1 = respData["body"] as! [[String:Any]]
                    //MARK:-Sub Categories 1
                    let sub_cata = respData1[1]["categories"] as! [[String:Any]]
                    let sub_cata_resData = JSON(sub_cata)
                    if let resData3 = sub_cata_resData.arrayObject {
                        self.arrRes = resData3 as! [[String:Any]]
                        let tempdic = ["home":"Home"]
                        self.arrRes.insert(tempdic, at: 0)
                        print(self.arrRes)
                    }
                   
                    self.tablee.reloadData()
                }
            }
        }
   
    
   

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrRes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! sideCell
        
        if indexPath.row == 0 {
            cell.lbl1.text = "Home"
            
        }else {
            let sub_data = self.arrRes[indexPath.row]["subcategory"] as? String ?? ""
            let imgurl = self.arrRes[indexPath.row]["image"] as? String
            let finalURL = "\(MainURL.mainurl)img/subcategory/\(imgurl!)"
            var turl = finalURL
            if finalURL.contains(" ") {
                turl = finalURL.replacingOccurrences(of: " ", with: "%20")
            }
            cell.img.kf.indicatorType = .activity
            cell.img.kf.setImage(with: URL(string: turl),placeholder: nil,options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))], completionHandler:  { result in
                switch result {
                case .success(let value):
                    print("Task done for: \(value.source.url?.absoluteString ?? "")")
                    
                case .failure(let error):
                    print("Job failed: \(error.localizedDescription)")
                    
                }
            })
            cell.lbl1.text = sub_data
        }
        
        
       
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            dismiss(animated: true, completion: nil)
        }else {
            let id = self.arrRes[indexPath.row]["id"] as? Int ?? 0
            self.sendid = id
            self.performSegue(withIdentifier: "proceed", sender: self)
        }
        
      
    }
}
