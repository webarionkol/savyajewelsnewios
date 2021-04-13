//
//  ImageVC.swift
//  savyaApp
//
//  Created by keval dattani on 24/03/21.
//  Copyright © 2021 Yash Rathod. All rights reserved.
//

import UIKit
import Zoomy
import Kingfisher

class ImageVC: UIViewController {
    
    @IBOutlet weak var imgmain:UIImageView!
    
    var img = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgmain.kf.indicatorType = .activity
        imgmain.kf.setImage(with: URL(string: (img ).replacingOccurrences(of: " ", with: "%20")),placeholder: nil,options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
                
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
                
            }
        }

        addZoombehavior(for: imgmain)

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnAddClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
