//
//  RootBaseVC.swift
//  savyaApp
//
//  Created by Yash on 1/16/20.
//  Copyright © 2020 Yash Rathod. All rights reserved.
//

import Foundation
import UIKit
import Lottie
import SwiftGifOrigin

class RootBaseVC:UIViewController {
    
    let animationView = UIImageView()
       
    var blurEffectView = UIVisualEffectView()
       
    override func viewDidLoad() {
        super.viewDidLoad()
           
        self.hideKeyboardWhenTappedAround()
        if #available(iOS 13.0, *) {
            let app = UIApplication.shared
            let statusBarHeight: CGFloat = app.statusBarFrame.size.height
            
            let statusbarView = UIView()
            statusbarView.backgroundColor = UIColor.init(named: "base_color")
            view.addSubview(statusbarView)
          
            statusbarView.translatesAutoresizingMaskIntoConstraints = false
            statusbarView.heightAnchor
                .constraint(equalToConstant: statusBarHeight).isActive = true
            statusbarView.widthAnchor
                .constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
            statusbarView.topAnchor
                .constraint(equalTo: view.topAnchor).isActive = true
            statusbarView.centerXAnchor
                .constraint(equalTo: view.centerXAnchor).isActive = true
          
        } else {
            let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
            statusBar?.backgroundColor = UIColor.init(named: "base_color")
        }
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
           
    }
    func addBottomBorder(with color: UIColor?, andWidth borderWidth: CGFloat,view: UIView) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        border.frame = CGRect(x: 0, y: view.frame.size.height - 2, width: view.frame.size.width, height: 1)
        view.addSubview(border)
    }

    @IBAction func backBtnPublic(_ sender:UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
      
    @IBAction func whatsappBtn(_ sender:UIButton) {
        let phoneNumber =  "+919412200642" // you need to change this number
        let appURL = URL(string: "https://api.whatsapp.com/send?phone=\(phoneNumber)")!
        if UIApplication.shared.canOpenURL(appURL) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
            }
            else {
                UIApplication.shared.openURL(appURL)
            }
        } else {
            // WhatsApp is not installed
        }
    }
    func loadAnimation() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        self.blurEffectView = UIVisualEffectView(effect:blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        animationView.loadGif(name: "logo111-1")
        animationView.frame = CGRect(x: 140, y: 240, width: 100, height: 100)
        //Don't forget this line
        view.addSubview(animationView)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: animationView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: animationView, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0))
        let height = NSLayoutConstraint(item: animationView,attribute: .height,relatedBy: .equal,toItem: nil,attribute: .notAnAttribute,multiplier: 1.0,constant: 100.0)
        let width = NSLayoutConstraint(item: animationView,attribute: .width,relatedBy: .equal,toItem: nil,attribute: .notAnAttribute,multiplier: 1.0,constant: 100.0)
           
        animationView.addConstraint(height)
        animationView.addConstraint(width)

        animationView.layer.cornerRadius = 15
        animationView.clipsToBounds = true
        
        animationView.contentMode = .scaleAspectFill
        animationView.backgroundColor = .white
        
           
    }
    func removeAnimation() {
        self.blurEffectView.removeFromSuperview()
        self.animationView.removeFromSuperview()
    }

}
