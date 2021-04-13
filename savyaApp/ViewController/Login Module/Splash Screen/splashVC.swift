//
//  splashVC.swift
//  savyaApp
//
//  Created by Yash on 12/29/19.
//  Copyright © 2019 Yash Rathod. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class splashVC:UIViewController {
    
    var allObj = try! Realm().objects(Token.self)
    
    var isgo = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.allObj.count > 0 {
            
            if Global.getIsfrom() == "1" {
                if Global.getNotiId() == "12" {
                    Global.setIsFrom(isFrom: "")
                    DispatchQueue.main.async {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "subCategoryVC") as! subCategoryVC
                        vc.id = Int(Global.getCateid())!
                        vc.manuid = Global.getMenuid()
                        self.present(vc, animated: true, completion: nil)
                        
                    }
                }
                else if Global.getNotiId() == "9" {
                    self.performSegue(withIdentifier: "home", sender: self)
                }
                
                else if Global.getNotiId() == "22" {
                    Global.setIsFrom(isFrom: "")
                    DispatchQueue.main.async {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetials2") as! ProductDetials2
                        vc.productId = Int(Global.getproid())!
                        self.present(vc, animated: true, completion: nil)
                    }
                }
                else if Global.getNotiId() == "23" {
                    self.performSegue(withIdentifier: "home", sender: self)
                }

                else if Global.getNotiId() == "21" {
                    Global.setIsFrom(isFrom: "")
                    DispatchQueue.main.async {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "subSubVC") as! subSubVC
                        vc.id = Int(Global.getSubid())!
                        vc.menuid = Global.getMenuid()
                        self.present(vc, animated: true, completion: nil)
                      
                    }
                }

                else if Global.getNotiId() == "18" {
                    self.performSegue(withIdentifier: "home", sender: self)
                }
                else if Global.getNotiId() == "15" {
                    Global.setIsFrom(isFrom: "")
                    DispatchQueue.main.async {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "bullianVC") as! bullianVC
                        self.present(vc, animated: true, completion: nil)
                    }
                }
                else if Global.getNotiId() == "16" {
                    Global.setIsFrom(isFrom: "")
                    DispatchQueue.main.async {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "aboutUSVC") as! aboutUSVC
                        vc.pageToOpen = PageToOpen.aboutUs
                        self.present(vc, animated: true, completion: nil)
                     
                    }
                }
                else if Global.getNotiId() == "19" {
                    Global.setIsFrom(isFrom: "")
                    DispatchQueue.main.async {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "machineryDashboardVC") as! machineryDashboardVC
                        vc.isfrom = "1"
                        vc.menuid = Global.getMenuid()
                        self.present(vc, animated: true, completion: nil)
                     
                    }
                }
                else if Global.getNotiId() == "17" {
                    Global.setIsFrom(isFrom: "")
                    DispatchQueue.main.async {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "machineDetailsVC") as! machineDetailsVC

                        vc.id = Global.getmachine()
                        self.present(vc, animated: true, completion: nil)
                     
                    }
                }
                else if Global.getNotiId() == "13" {
                    Global.setIsFrom(isFrom: "")
                    DispatchQueue.main.async {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "bullianDetailVC") as! bullianDetailVC

                        vc.bulliaid = Global.getbullid()
                        self.present(vc, animated: true, completion: nil)
                     
                    }
                }
                else if Global.getNotiId() == "14" {
                    Global.setIsFrom(isFrom: "")
                    DispatchQueue.main.async {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "bullianListVC") as! bullianListVC

                        vc.cityid = Global.getlocation()
                        self.present(vc, animated: true, completion: nil)
                     
                    }
                }
                
            }else {
                self.performSegue(withIdentifier: "home", sender: self)
            }
            
            
           
        } else {
            if UserDefaults.standard.bool(forKey: "first") == true {
                self.performSegue(withIdentifier: "login", sender: self)
            } else {
                self.performSegue(withIdentifier: "first", sender: self)
            }
            
        }
    }
    
    
}
