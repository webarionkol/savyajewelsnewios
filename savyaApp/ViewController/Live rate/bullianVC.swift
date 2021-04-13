//
//  bullianVC.swift
//  savyaApp
//
//  Created by Yash on 7/24/20.
//  Copyright © 2020 Yash Rathod. All rights reserved.
//

import Foundation
import UIKit


class bullianVC:RootBaseVC,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    
   // @IBOutlet weak var tableView:subtableView!
    @IBOutlet weak var stateTblView:subtableView!
//    @IBOutlet weak var act:UIActivityIndicatorView!
//    @IBOutlet weak var collectionView:UICollectionView!
  //  @IBOutlet weak var heightTbl:NSLayoutConstraint!
    @IBOutlet weak var collectionBullian:UICollectionView!
    @IBOutlet weak var collectionHeight:NSLayoutConstraint!
    @IBOutlet weak var scrollView:UIScrollView!
    @IBOutlet weak var searchBar:UISearchBar!
    
    var rates = [LiveRate]()
    let api = APIManager()
    var allState = [StateBullian]()
    var filteredStates = [StateBullian]()
    var allCity = [BullianCity]()
    var filteredCities = [BullianCity]()
    var ind = IndexPath(row: 0, section: 0)
    let bannerimgs = [UIImage(named: "1b"),UIImage(named: "2b"),UIImage(named: "3b")]
    var oldask:Float!
    var oldbid:Float!
    var oldhigh:Float!
    var oldlow:Float!
    var sendid = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
     //   self.getallRate()
        self.collectionBullian.delegate = self
        self.collectionBullian.dataSource = self
        self.collectionBullian.isScrollEnabled = false
        self.view.backgroundColor = UIColor.lightGray
        stateTblView.tableFooterView = UIView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadAnimation()
        self.gettAllState()
        searchBar.text = ""
        self.filteredCities.removeAll()
        self.filteredStates.removeAll()
        searchBar.resignFirstResponder()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.removeAnimation()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "proceed" {
            let dvc = segue.destination as! bullianCityVC
            dvc.cityid = self.sendid
        } else if segue.identifier == "bulliannList" {
            let dvc = segue.destination as! bullianListVC
            dvc.cityid = self.sendid
        }
    }
    func gettAllState() {
        APIManager.shareInstance.getAllState(vc: self) { (all,allCity)  in
            self.allState = all
            self.filteredStates = all
            self.allCity = allCity
            self.stateTblView.reloadData()
            self.collectionBullian.reloadData()
            self.stateTblView.invalidateIntrinsicContentSize()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                print(self.collectionBullian.collectionViewLayout.collectionViewContentSize.height)
            }
        }
    }
//    func getallRate() {
//        api.getliverates(vc: self) { (ratees) in
//            self.rates.removeAll()
//            self.rates = ratees
//
//            self.tableView.reloadData()
//            self.tableView.invalidateIntrinsicContentSize()
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//                self.getallRate()
//            }
//        }
//    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
       // self.tableView.invalidateIntrinsicContentSize()
        self.stateTblView.invalidateIntrinsicContentSize()
     //   self.heightTbl.constant = 38 * 6
      //  let liveRateTbl = self.tableView.frame.height
        let totalBythree = self.allCity.count / 3
        let collectionCitySize = CGFloat(totalBythree) * CGFloat(self.collectionBullian.frame.width / 3 - 10)
        if UIDevice.current.userInterfaceIdiom == .pad {
            self.collectionHeight.constant = collectionCitySize + 370
        } else {
            self.collectionHeight.constant = collectionCitySize + 190
        }
        
        let stateTbl = self.stateTblView.intrinsicContentSize.height
        
        let calc1 = collectionCitySize
        self.scrollView.contentSize = CGSize.init(width: self.view.frame.width, height: calc1 + stateTbl + 400)
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if filteredCities.count > 0 {
          return 2
        }
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.stateTblView {
            if filteredCities.count > 0 {
                if section == 0 {
                    return self.filteredCities.count
                } else {
                    return self.filteredStates.count
                }
            } else {
                return self.filteredStates.count
            }
        }
        return self.rates.count + 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 38
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if filteredCities.count > 0 {
            if section == 0 {
                return 0
            } else {
                return 36
            }
        } else {
            return 36
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if filteredCities.count > 0 {
            if section == 0 {
                return UIView()
            } else {
                let label = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 36))
                label.backgroundColor = .lightGray
                label.text = "   Other States"
                label.textColor = .darkGray
                return label
            }
        } else {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 36))
            label.backgroundColor = .lightGray
            label.text = "   Other States"
            label.textColor = .darkGray
            return label
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.stateTblView {
            var supercell = UITableViewCell()
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            if filteredCities.count > 0 {
                if indexPath.section == 0 {
                    cell?.textLabel?.text = self.filteredCities[indexPath.row].city
                } else {
                    cell?.textLabel?.text = self.filteredStates[indexPath.row].name
                }
                supercell = cell!
            } else {
                cell?.textLabel?.text = self.filteredStates[indexPath.row].name
                supercell = cell!
            }
            return supercell
        }
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1") as! liverateHeadCell
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2") as! liverateCell
            let newask = self.rates[indexPath.row - 1].ask.floatValue
            let newbid = self.rates[indexPath.row - 1].bid.floatValue
            let newlow = self.rates[indexPath.row - 1].high.floatValue
            let newhigh = self.rates[indexPath.row - 1].low.floatValue
            
            if self.oldask == nil {
                self.oldask = self.rates[indexPath.row - 1].ask.floatValue
                self.oldbid = self.rates[indexPath.row - 1].bid.floatValue
                self.oldhigh = self.rates[indexPath.row - 1].high.floatValue
                self.oldlow = self.rates[indexPath.row - 1].low.floatValue
            } else {
                if self.oldask > newask {
                  //  cell.askLbl.backgroundColor = .red
                    self.oldask = self.rates[indexPath.row - 1].ask.floatValue
                } else {
                   // cell.askLbl.backgroundColor = .green
                    self.oldask = self.rates[indexPath.row - 1].ask.floatValue
                }
                if self.oldbid > newbid {
                  //  cell.bidLbl.backgroundColor = .red
                    self.oldbid = self.rates[indexPath.row - 1].bid.floatValue
                } else {
                 //   cell.bidLbl.backgroundColor = .green
                    self.oldbid = self.rates[indexPath.row - 1].bid.floatValue
                }
                if self.oldhigh > newhigh {
                  //  cell.highLbl.backgroundColor = .red
                    self.oldhigh = self.rates[indexPath.row - 1].high.floatValue
                } else {
                  //  cell.highLbl.backgroundColor = .green
                    self.oldhigh = self.rates[indexPath.row - 1].high.floatValue
                }
                if self.oldlow > newlow {
                 //   cell.lowLbl.backgroundColor = .red
                    self.oldlow = self.rates[indexPath.row - 1].low.floatValue
                } else {
                 //   cell.lowLbl.backgroundColor = .green
                    self.oldlow = self.rates[indexPath.row - 1].low.floatValue
                }
            }
            
            
            cell.symbolLbl.text = self.rates[indexPath.row - 1].symbol
            cell.askLbl.text = "\(newask)"
            cell.bidLbl.text = "\(newbid)"
            cell.highLbl.text = "\(newlow)"
            cell.lowLbl.text = "\(newhigh)"
            
            cell.symbolLbl.layer.borderColor = UIColor.gray.cgColor

            
            cell.symbolLbl.layer.borderWidth = 1

            
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.stateTblView {
            if filteredCities.count > 0 {
                if indexPath.section == 0 {
                    self.sendid = self.filteredCities[indexPath.row].id.toString()
                    self.performSegue(withIdentifier: "bulliannList", sender: self)
                } else {
                    self.sendid = self.filteredStates[indexPath.row].id.toString()
                    self.performSegue(withIdentifier: "proceed", sender: self)
                }
            } else {
                self.sendid = self.filteredStates[indexPath.row].id.toString()
                self.performSegue(withIdentifier: "proceed", sender: self)
            }
            
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.allCity.count
    }
       
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! bulliceCityCell
        let ind = self.allCity[indexPath.row]
        cell.img.kf.indicatorType = .activity
        cell.img.kf.setImage(with: URL(string: ind.image),placeholder: nil,options: [.scaleFactor(UIScreen.main.scale),.transition(.fade(1))]) { result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
                
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
                
            }
        }
        cell.lbl1.text = ind.city
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: self.collectionBullian.frame.width / 3 - 10, height:self.collectionBullian.frame.width / 3 - 10)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.sendid = self.allCity[indexPath.row].id.toString()
        self.performSegue(withIdentifier: "bulliannList", sender: self)
    }
}

extension bullianVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let states = allState.filter({$0.name .contains(searchText)})
        if states.count > 0 {
            filteredStates = states
        } else {
            filteredStates = allState
        }

        let cities = allCity.filter({$0.city .contains(searchText)})
        if cities.count > 0 {
            filteredCities = cities
        } else {
            filteredCities.removeAll()
        }
        stateTblView.reloadData()
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
