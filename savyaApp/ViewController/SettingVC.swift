//
//  SettingVC.swift
//  savyaApp
//
//  Created by keval dattani on 18/11/20.
//  Copyright © 2020 Yash Rathod. All rights reserved.
//

import UIKit

class SettingVC: UIViewController {

    @IBOutlet weak var priceSwitch: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isKeyPresentInUserDefaults(key: "price") {
            if UserDefaults.standard.string(forKey: "price") == "1" {
                priceSwitch.setOn(true, animated: false)
            }else {
                priceSwitch.setOn(false, animated: false)
            }
        }else{
            priceSwitch.setOn(false, animated: false)
        }
        
       

        priceSwitch.tintColor = UIColor.white
        // Do any additional setup after loading the view.
    }
    
    @IBAction func priceSwitchClicked(_ sender: Any) {
        if priceSwitch.isOn {
            UserDefaults.standard.set("1", forKey: "price")
        }else {
            UserDefaults.standard.set("0", forKey: "price")
        }
    }
    @IBAction func btnBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
}
