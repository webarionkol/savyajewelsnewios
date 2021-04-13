//
//  thankyouVC.swift
//  savyaApp
//
//  Created by Yash on 1/27/20.
//  Copyright © 2020 Yash Rathod. All rights reserved.
//

import Foundation
import UIKit
import Lottie

class thnakyouVC:UIViewController {
    
    let animationView = AnimationView()
    @IBOutlet weak var viewA:UIView!
    @IBOutlet weak var containerView:UIView!
    var blurEffectView = UIVisualEffectView()
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblMiddle: UILabel!
    
    
    var id = String()
    var name = String()
    
    var orderid = ""
    var buyid = ""
    var sellid = ""
    var compname = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblTitle.text = "Order Id: \(id) (\(name))"
        self.lblMiddle.text = "Thank you for ordering very soon you will get confirmation call from seller (\(name))"
        
        getData(Order_id: orderid, buyer_id: buyid, seller_id: sellid)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadAnimation()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//            let dvc = self.storyboard?.instantiateInitialViewController()
//            self.present(dvc!, animated: true, completion: nil)
//        }
    }
    @IBAction func backBtn(_ sender:UIButton) {
        let dvc = self.storyboard?.instantiateViewController(withIdentifier: "side") as! sidemenu
        dvc.modalPresentationStyle = .fullScreen
        self.present(dvc, animated: true, completion: nil)
    }
    func loadAnimation() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        self.blurEffectView = UIVisualEffectView(effect:blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        //view.addSubview(blurEffectView)
        let animationn = Animation.named("lf30_editor_BzAZPD")
        animationView.animation = animationn
        
        animationView.frame = CGRect(x: self.viewA.frame.origin.x, y: self.viewA.frame.origin.y, width: self.viewA.frame.width, height: self.viewA.frame.height)
        //Don't forget this line
        self.containerView.addSubview(animationView)
      //  animationView.translatesAutoresizingMaskIntoConstraints = false
//        view.addConstraint(NSLayoutConstraint(item: animationView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0))
//        view.addConstraint(NSLayoutConstraint(item: animationView, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0))
//        let height = NSLayoutConstraint(item: animationView,attribute: .height,relatedBy: .equal,toItem: nil,attribute: .notAnAttribute,multiplier: 1.0,constant: 100.0)
//        let width = NSLayoutConstraint(item: animationView,attribute: .width,relatedBy: .equal,toItem: nil,attribute: .notAnAttribute,multiplier: 1.0,constant: 100.0)
//
//        animationView.addConstraint(height)
//        animationView.addConstraint(width)

        animationView.layer.cornerRadius = 15
        animationView.clipsToBounds = true
        
        animationView.contentMode = .scaleAspectFill
        animationView.backgroundColor = .clear
        animationView.loopMode = .loop
        animationView.play()
    }
    
    func getData(Order_id:String,buyer_id:String,seller_id:String) {
        self.orderid = "SAV\(Order_id)"
         
        
        APIManager.shareInstance.getInvoice(order_id: "\(Order_id)", buyer_id: "\(buyer_id)", seller_id: "\(seller_id)", vc: self) { (response) in
            if response == "success" {
              
               print(response)
            }
        }
    }
}
