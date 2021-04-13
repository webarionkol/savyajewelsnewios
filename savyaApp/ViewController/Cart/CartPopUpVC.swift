//
//  CartPopUpVC.swift
//  savyaApp
//
//  Created by keval dattani on 01/11/20.
//  Copyright © 2020 Yash Rathod. All rights reserved.
//

import UIKit

class CartPopUpVC: UIViewController {

    @IBOutlet weak var lblMinOrderTitle: UILabel!
    @IBOutlet weak var imgMain: UIImageView!
    @IBOutlet weak var lblMinOrder: UILabel!
    @IBOutlet weak var lblOrderValueTitle: UILabel!
    @IBOutlet weak var lblOrderValue: UILabel!
    @IBOutlet weak var lblMoreTitle: UILabel!
    @IBOutlet weak var lblMore: UILabel!
    @IBOutlet weak var btnContinue: UIButton!
    
    
    var total = Double()
    var id = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        self.showAnimate()
        
        getAllData()
        // Do any additional setup after loading the view.
    }
    @IBAction func btnContinueClicked(_ sender: Any) {
        removeAnimate()
       // self.performSegue(withIdentifier: "more", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "more" {
            let dvc = segue.destination as! subCategoryVC
            dvc.manuid = "\(id)"
        }
    }
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
    
    func getAllData() {
        APIManager.shareInstance.getCurrentProfile(vc: self) { (pro, kyc,url) in
            
            APIManager.shareInstance.viewCart(user_id: pro.uid, vc: self) { (allPro) in
                self.lblMinOrder.text = allPro[0].manufacture_limit
                self.lblMinOrderTitle.text = "Minimum Order From \(allPro[0].manufacture_name)"
                
                let limit = Double(allPro[0].manufacture_limit)
                
                let str = String(format: "%.2f", self.total)
                self.lblOrderValue.text = str
                let doubleStr = String(format: "%.2f", limit! - self.total)
                self.lblMore.text = doubleStr
                
                self.btnContinue.setTitle("Continue Shopping \(allPro[0].manufacture_name)", for: .normal)
                }
            }
    }
}
