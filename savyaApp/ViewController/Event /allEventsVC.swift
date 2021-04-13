//
//  allEventsVC.swift
//  savyaApp
//
//  Created by Yash on 7/28/19.
//  Copyright © 2019 Yash Rathod. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

class allEventsVC: RootBaseVC,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tablee:UITableView!
    @IBOutlet weak var act:UIActivityIndicatorView!
    let apis = APIManager()
    var allevents = [Event]()
    var selectedEvent:Event!
    var url = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.act.startAnimating()
        self.act.isHidden = false
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // self.loadAnimation()
        self.getAllData()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "event" {
            let dvc = segue.destination as! eventDetailsVC
            dvc.currentEvent = self.selectedEvent
            dvc.imgUrl = self.url
        }
    }
    func getAllData() {
        apis.getAllEvents(vc: self) { (events,imgurl) in
            self.url = imgurl
            self.allevents = events!
            self.act.isHidden = true
            self.tablee.reloadData()
           // self.removeAnimation()
        }
    }
    @IBAction func back(_ sender:UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allevents.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! eventsCell
        let event = self.allevents[indexPath.row]
        let imgurl = event.img!
        let finalURl = self.url + "/" + imgurl
        if indexPath.row == self.allevents.count - self.allevents.count {
            cell.topView.isHidden = true
        } else {
            cell.topView.isHidden = false
        }
        
        if indexPath.row == self.allevents.count - 1 {
            cell.bottomView.isHidden = true
        } else {
            cell.bottomView.isHidden = false
        }
        cell.viewCorner.layer.cornerRadius = 5
        cell.viewCorner.clipsToBounds = true
        
        cell.viewShadow.dropShadow(color: .gray, opacity: 0.7, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
        
        cell.img.kf.indicatorType = .activity
        cell.img.kf.setImage(with: URL(string: finalURl),placeholder: nil,options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
                
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
                
            }
        }
        cell.addrLbl.text = event.address
        cell.dateLbl.text = event.date
        cell.eventName.text = event.eventName
        cell.eventypeLbl.text = event.descr
        cell.timeLbl.text = event.time
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.model == "iPad" {
            return 200
        } else {
            return 108
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedEvent = self.allevents[indexPath.row]
        self.performSegue(withIdentifier: "event", sender: self)
    }
}
