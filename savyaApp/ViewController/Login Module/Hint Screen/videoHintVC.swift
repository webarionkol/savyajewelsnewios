//
//  videoHintVC.swift
//  savyaApp
//
//  Created by Yash on 5/26/20.
//  Copyright © 2020 Yash Rathod. All rights reserved.
//

import UIKit

class videoHintVC: RootBaseVC {

    @IBOutlet weak var videoView:VideoView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        videoView.configure(url: "https://savyajewelsbusiness.com/videos/con.mp4")
        videoView.isLoop = true
        self.videoView.play()
    }
    @IBAction func nextBtn(_ sender:UIButton) {
        UserDefaults.standard.set(true, forKey: "first")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
