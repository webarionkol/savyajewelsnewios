//
//  APIManager.swift
//  savyaApp
//
//  Created by Yash on 7/28/19.
//  Copyright © 2019 Yash Rathod. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift
import UIKit

class APIManager {
    
    static let shareInstance = APIManager()
    private static var alamofireManager: Session? = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 20
        let alamofireManager = Session(configuration: configuration)
        return alamofireManager
    }()
    
    func printEveryThing(responseData:AFDataResponse<Any>,statusCode:Int,url:String,para:Any) {
        
        print("----------------- URL --------------")
        print(url)
        print("----------------- URL --------------")
        print("\n")
        print("----------------- data --------------")
        print(responseData)
        print("----------------- data --------------")
        print("\n")
        print("----------------- statusCode --------------")
        print(statusCode)
        print("----------------- statusCode --------------")
        print("\n")
        print("----------------- Parameter --------------")
        print(para)
        print("----------------- Parameter --------------")
        print("\n")
        
    }
    
    func deleteAllToen(completion:@escaping (String) -> Void) {
        let realm = try! Realm()
        let allToken = try! Realm().objects(Token.self)
        try! realm.write {
            realm.delete(allToken)
        }
        completion("success")
    }
    
    func registerUser(agent_code:String,name:String,email:String,mobile_no:String,Referal:String,lognitude:String,latitude:String,vc:UIViewController,completion:@escaping(String) -> Void) {
        let para:Parameters = ["agent_code":agent_code,"name":name,"email":email,"mobile_no":mobile_no,"referal_code":Referal,"lognitude":lognitude,"latitude":latitude]
        print(para)
        if Reachability.isConnectedToNetwork() == false {
            vc.showAlert(titlee: "Message", message: "No Internet Connection")
        }
        AF.request(NewAPI.register, method: .post, parameters: para, encoding: JSONEncoding.default, headers: nil).responseJSON { (responseData) in
            self.printEveryThing(responseData: responseData, statusCode: responseData.response!.statusCode, url: (responseData.request?.url!.absoluteString)!, para: para)
            if responseData.value != nil {
                if responseData.response?.statusCode == 200 {
                    completion("success")
                } else if responseData.response?.statusCode == 401 {
                    let data = responseData.value as! [String:Any]
                    let str = data.description
                    if str.contains("mobile_no") {
                        completion("mobile")
                    } else if str.contains("email") {
                        completion("email")
                    }
                }
            }
        }
    }
    
    func verifyrefrealcode(code:String,vc:UIViewController,completion:@escaping(String) -> Void) {
        let para = ["referal_code":code]
        
        if Reachability.isConnectedToNetwork() == false {
            vc.showAlert(titlee: "Message", message: "No Internet Connection")
        }
        let url =  NewAPI.verifyreferalcode+"?referal_code=\(code)"
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (responseData) in
           
            if responseData.value != nil {
                if responseData.response?.statusCode == 200 {
                    let data = responseData.value as! [String:Any]
                    let agent = data["agent_code"] as! String
                    completion(agent)
                } else if responseData.response?.statusCode == 401 {
                    let data = responseData.value as! [String:Any]
                    let str = data.description
                    if str.contains("mobile_no") {
                        completion("mobile")
                    } else if str.contains("email") {
                        completion("email")
                    }
                }
            }
        }
    }
    
    func login(mobile_no:String,otp:String,one_singnal:String,vc:UIViewController,completion:@escaping (String) -> Void) {
        let para:Parameters = ["mobile_no":mobile_no,"otp":otp,"one_singnal":one_singnal]
        if Reachability.isConnectedToNetwork() == false {
            vc.showAlert(titlee: "Message", message: "No Internet Connection")
        }
        AF.request(NewAPI.login, method: .post, parameters: para, encoding: JSONEncoding.default, headers: nil).responseJSON { (responseData) in
            self.printEveryThing(responseData: responseData, statusCode: responseData.response!.statusCode, url: (responseData.request?.url!.absoluteString)!, para: para)
            if responseData.value != nil {
                if responseData.response?.statusCode == 200 {
                    let data = responseData.value as! [String:Any]
                    let success = data["success"] as! [String:Any]
                    if let pass = success["token"] as? String {
                        self.deleteAllToen { (str) in
                            if str == "success" {
                                let realm = try! Realm()
                                let t1 = Token()
                                t1.token = "Bearer " + pass
                                          
                                try! realm.write {
                                    realm.add(t1)
                                    completion("success")
                                            
                                }
                            }
                        }
                    }
                } else if responseData.response?.statusCode == 405 {
                    completion("otpwrong")
                }
            }
        }
    }
    
    func otpRequest(mobile_no:String,vc:UIViewController,compltion:@escaping (String) -> Void) {
        let para:Parameters = ["mobile_no":mobile_no]
        if Reachability.isConnectedToNetwork() == false {
            vc.showAlert(titlee: "Message", message: "No Internet Connection")
        }
        AF.request(NewAPI.otpRequest, method: .post, parameters: para, encoding: JSONEncoding.default, headers: nil).responseJSON { (responseData) in
            self.printEveryThing(responseData: responseData, statusCode: responseData.response?.statusCode ?? 000, url: NewAPI.otpRequest, para: para)
            if responseData.value != nil {
                if responseData.response?.statusCode == 200 {
                    compltion("success")
                } else if responseData.response?.statusCode == 405 {
                    compltion("number not exsist")
                } else {
                    compltion("failure")
                }
            }
        }
    }
    func getAllEvents(vc:UIViewController,completion: @escaping ([Event]?,String) -> Void) {
        let authorization:HTTPHeaders =  ["Authorization":Token.getLatestToken()]
        if Reachability.isConnectedToNetwork() == false {
            vc.showAlert(titlee: "Message", message: "No Internet Connection")
        }
        AF.request(Apis.events,method: .post,parameters: nil,encoding: JSONEncoding.default,headers: authorization).responseJSON { (responseData) in
            print(responseData)
            if responseData.value != nil {
                let data = responseData.value as! [String:Any]
                let e1data = data["data"] as! [String:Any]
                let imageURL = data["url"] as! String
                let e2Data = JSON(e1data["data"]!)
                var allEvents = [[String:AnyObject]]()
                if let resData = e2Data.arrayObject {
                    allEvents = resData as! [[String:AnyObject]]
                }
                var eventss = [Event]()
                for i in allEvents {
                    let eventName = i["title"] as? String ?? "No Name"
                    let address = i["address"] as? String ?? "No Address"
                    let date = i["date"] as? String ?? "No Date"
                    let time = i["eventtime"] as? String ?? "No time"
                    let img = i["image"] as? String ?? "No image"
                    let descr = i["description"] as? String ?? "No Description"
                    let status = i["status"] as? String
                    let event_type = i["event_type"] as? String
                    let e1 = Event(eventName: eventName, address: address, date: date, time: time, img: img, descr: descr, status: Int(status!)!,event_type:event_type!)
                    if Int(status!)! == 1 {
                        eventss.append(e1)
                    }
                    
                    
                }
                completion(eventss,imageURL)
            }
        }
    }
    
    func getAllNotifications(user_id:String,vc:UIViewController,completion: @escaping ([Notifications]) -> Void) {
        
        let authorization:HTTPHeaders =  ["Authorization":Token.getLatestToken()]
        if Reachability.isConnectedToNetwork() == false {
            vc.showAlert(titlee: "Message", message: "No Internet Connection")
        }
        print(NewAPI.notifications)
        AF.request(NewAPI.notifications,method: .get,parameters: nil,encoding: URLEncoding.default,headers: authorization).responseJSON { (responseData) in
            
            var notifications = [Notifications]()
            print(responseData.response)
            if responseData.value != nil {
                let data = responseData.value as! [String:Any]
                let e1data = data["data"] as! [String:Any]
               
                let e2Data = JSON(e1data["data"]!)
                var allNotifications = [[String:AnyObject]]()
                if let resData = e2Data.arrayObject {
                    allNotifications = resData as! [[String:AnyObject]]
                }
                
                for i in allNotifications {
                    let title = i["title"] as? String ?? "No Name"
                    let date = i["created_at"] as? String ?? "No Date"
                    let time = i["eventtime"] as? String ?? "No Time"
                    let message = i["description"] as? String ?? "No Message"
                    
                    let n1 = Notifications(title: title, message: message, date: date, time: time)
                    notifications.append(n1)
                    
                }
                completion(notifications)
            }
            completion(notifications)
        }
    }
    func getCurrentProfile(vc:UIViewController,completion: @escaping (Profile,Kyc,String) -> Void) {
        let authorization:HTTPHeaders =  ["Authorization":Token.getLatestToken()]
        if Reachability.isConnectedToNetwork() == false {
            vc.showAlert(titlee: "Message", message: "No Internet Connection")
        }
        AF.request(NewAPI.profile, method: .post, parameters: nil, encoding: URLEncoding.default, headers: authorization).responseJSON { (responseData) in
            self.printEveryThing(responseData: responseData, statusCode: responseData.response?.statusCode ?? 000 , url: (responseData.request?.url!.absoluteString) ?? "", para: "para")
            if responseData.value != nil {
                
                if responseData.response?.statusCode == 200 {
                    let pData = responseData.value as! [String:Any]
                    let p1Data = pData["user"] as! [String:Any]
                    print(pData)
                    print(p1Data)
                    var KycNew:Kyc?
                    let url = pData["url"] as? String ?? ""
                    
                    
                    let newData = p1Data
                    let name = newData["name"] as? String ?? "No Name"
                    let register_type = newData["register_type"] as? String ?? "No Type"
                    let company_name = newData["company_name"] as? String ?? "No company"
                    let gst_no = newData["gst_no"] as? String ?? "No gst"
                    let pan_no = newData["pan_no"] as? String ?? "no pan"
                    let uid = newData["id"] as? Int ?? 0
                    let email = newData["email"] as? String ?? "No email"
                    let mobile_no = newData["mobile_no"] as? String ?? "no mobile number"
                    let addreess = newData["address"] as? String ?? "No address"
                    let city = newData["city"] as? String ?? "No city"
                    let pincode = newData["pincode"] as? String ?? "No pincode"
                    let state = newData["state"] as? String ?? "No State"
                    let image = "\(url)/\(newData["logo"] as? String ?? "No image")"
                    let document_verified = newData["document_verified"] as? Int ?? 0
                    UserDefaults.standard.set("\(uid)", forKey: "userid")
                    
                    if let kyc = pData["kyc"] as? [String:Any] {
                        let id = kyc["id"] as? Int ?? 0
                        let uidd = kyc["uid"] as? String ?? ""
                        let agent_code = kyc["agent_code"] as? String ?? ""
                        let gst_noo = kyc["gst_no"] as? String ?? ""
                        let pan_noo = kyc["pan_no"] as? String ?? ""
                        let pan_doc = kyc["pan_doc"] as? String ?? ""
                        let aadharr = kyc["aadhar"] as? String ?? ""
                        let gst_doc = kyc["gst_doc"] as? String ?? ""
                        let gst_back = kyc["gst_back"] as? String ?? ""
                        let aadhar_doc = kyc["aadhar_doc"] as? String ?? ""
                        let aadhar_back = kyc["aadhar_back"] as? String ?? ""
                        let visiting_doc = kyc["visiting_doc"] as? String ?? ""
                        let visiting_back = kyc["visiting_back"] as? String ?? ""
                        let document_verifiedKyc = kyc["document_verified"] as? String ?? ""
                        let shopname = kyc["shopname"] as? String ?? ""
                        let designation = kyc["designation"] as? String ?? ""
                        
                        UserDefaults.standard.set(document_verifiedKyc, forKey: "document_verifiedKyc")
                        
                        let status = kyc["status"] as? String ?? ""
                        let aadhar_doc_status = kyc["aadhar_doc_status"] as? String ?? ""
                        let aadhar_back_status = kyc["aadhar_back_status"] as? String ?? ""
                        let gst_back_status = kyc["gst_back_status"] as? String ?? ""
                        let gst_doc_status = kyc["gst_doc_status"] as? String ?? ""
                        let pan_doc_status = kyc["pan_doc_status"] as? String ?? ""
                        let visiting_back_status = kyc["visiting_back_status"] as? String ?? ""
                        let visiting_doc_status = kyc["visiting_doc_status"] as? String ?? ""
                        
                        
                        let temp = Kyc.init(id: id, uid: uidd, agentCode: agent_code, gstNo: gst_noo, panNo: pan_noo, aadhar: aadharr, gstDoc: url + "/" + gst_doc, gstBack:  url + "/" + gst_back, aadharDoc: url + "/" + aadhar_doc, aadharBack: url + "/" + aadhar_back, visitingDoc: url + "/" + visiting_doc, visitingBack:  url + "/" + visiting_back, panDoc:url + "/" + pan_doc, documentVerified: document_verifiedKyc, status: status, createdAt: "", updatedAt: "", aadhar_back_status: aadhar_back_status, aadhar_doc_status: aadhar_doc_status, gst_back_status: gst_back_status, gst_doc_status: gst_doc_status, pan_doc_status: pan_doc_status, visiting_back_status: visiting_back_status, visiting_doc_status: visiting_doc_status,shopname:shopname,designation:designation)
                        
                        KycNew = temp
                    } else {
                        UserDefaults.standard.set("0", forKey: "document_verifiedKyc")
                        let temp = Kyc.init(id: 0, uid: "", agentCode: "", gstNo: "", panNo: "", aadhar: "", gstDoc: "", gstBack: "", aadharDoc: "", aadharBack: "", visitingDoc: "", visitingBack: "", panDoc: "", documentVerified: "", status: "", createdAt: "", updatedAt: "", aadhar_back_status: "", aadhar_doc_status: "", gst_back_status: "", gst_doc_status: "", pan_doc_status: "", visiting_back_status: "", visiting_doc_status: "",shopname:"",designation:"")
                        KycNew = temp
                    }
                    
                    
                    
                        
                    let p1 = Profile(name: name, uid: uid.toString(), register_type: register_type, company_name: company_name, gst_no: gst_no, pan_no: pan_no, email: email, mobile_no: mobile_no, address: addreess, city: city, pincode: pincode, state: state, image: image, document_verified: document_verified ?? 0)
                        
                    completion(p1,KycNew!,url)
                }
            }
        }
    }
    func getAboutus(vc:UIViewController,completion:@escaping (AboutUS) -> Void) {
        if Reachability.isConnectedToNetwork() == false {
            vc.showAlert(titlee: "Message", message: "No Internet Connection")
        }
        AF.request(Apis.aboutus,method: .post,parameters: nil,encoding: JSONEncoding.default,headers: header.headers).responseJSON { (responseData) in
            if responseData.value != nil {
                let data = responseData.value as! [String:Any]
                let r1Data = data["data"] as! [[String:Any]]
                let aboutus = r1Data[0]
                let descr = aboutus["description"] as! String
                let aboutusobj = AboutUS.init(descr: descr)
                
                completion(aboutusobj)
            }
        }
    }
    
    func getContactUs(vc:UIViewController,completion: @escaping (ContactUS) -> Void) {
        let authorization:HTTPHeaders =  ["Authorization":Token.getLatestToken()]
        if Reachability.isConnectedToNetwork() == false {
            vc.showAlert(titlee: "Message", message: "No Internet Connection")
        }
        AF.request(NewAPI.contactus,method: .get,parameters: nil,encoding: URLEncoding.default,headers: authorization).responseJSON { (responseData) in
            self.printEveryThing(responseData: responseData, statusCode: responseData.response?.statusCode ?? 000, url: NewAPI.contactus, para: "")
            if responseData.value != nil {
                let data = responseData.value as! [String:Any]
                let r1Data = data["data"] as! [String:Any]
                
                let id = r1Data["r1Data"] as? Int ?? 0
                let address = r1Data["address"] as? String ?? ""
                let mobile = r1Data["mobile"] as? String ?? "No Number"
                let email = r1Data["email"] as? String ?? ""
                let landline = r1Data["landline"] as? String ?? ""
                let instagram = r1Data["instagram"] as? String ?? "No Instagram"
                let facebook = r1Data["facebook"] as? String ?? ""
                let twitter = r1Data["twitter"] as? String ?? "No twitter"
                let linkendin = r1Data["linkendin"] as? String ?? ""
                
                let contactusobj = ContactUS.init(id: id, address: address, mobile: mobile, landline: landline, email: email, instagram: instagram, facebook: facebook, createdAt: "", updatedAt: "",linkendin:linkendin,twitter:twitter)
                completion(contactusobj)
            }
        }
    }
    func gettermsandcondition(vc:UIViewController,completion: @escaping (Terms) -> Void) {
        if Reachability.isConnectedToNetwork() == false {
            vc.showAlert(titlee: "Message", message: "No Internet Connection")
        }
        AF.request(Apis.termsandcondition,method: .post,parameters: nil,encoding: JSONEncoding.default,headers: header.headers).responseJSON { (responseData) in
            if responseData.value != nil {
                
                let data = responseData.value as! [String:Any]
                let r1Data = data["data"] as! [[String:Any]]
                let contactus = r1Data[0]
                let descr = contactus["description"] as! String
                let termsobj = Terms.init(content: descr)
                completion(termsobj)
            }
        }
    }
    func getPrivacyPolicy(vc:UIViewController, apiName: String,completion: @escaping (Terms) -> Void) {
        if Reachability.isConnectedToNetwork() == false {
            vc.showAlert(titlee: "Message", message: "No Internet Connection")
        }
        AF.request(apiName,method: .get,parameters: nil,encoding: JSONEncoding.default,headers: header.headers).responseJSON { (responseData) in
            if responseData.value != nil {
                
                if let data = responseData.value as? [String:Any] {
                    if let r1Data = data["data"] as? [String:Any] {
                        //let contactus = r1Data[0]
                        let descr = r1Data["description"] as! String
                        let termsobj = Terms.init(content: descr)
                        completion(termsobj)
                    }
                }
                
                
            }
        }
    }
    
    func getliverates(vc:UIViewController,completion: @escaping ([LiveRate]) -> Void) {
        if Reachability.isConnectedToNetwork() == false {
            vc.showAlert(titlee: "Message", message: "No Internet Connection")
            return
        }
        AF.request(NewAPI.liverate).responseJSON { (responseData) in
            self.printEveryThing(responseData: responseData, statusCode: responseData.response?.statusCode ?? 000, url: NewAPI.liverate, para: "")
            if responseData.value != nil {
                let data = responseData.value as! [String:Any]
                let r2Data = data["data"] as! [String:Any]
                let r1Data = r2Data["rows"] as! [String:Any]
                var liveData = [LiveRate]()
                
                
                let r1 = r1Data["0"] as! [String:Any]
               
                let r3 = r1Data["2"] as! [String:Any]
                let r4 = r1Data["3"] as! [String:Any]
                let r5 = r1Data["4"] as! [String:Any]
                let r6 = r1Data["5"] as! [String:Any]
                
                
                var mainarr = [[String:Any]]()
                mainarr.removeAll()
                
                mainarr.append(r1)
                mainarr.append(r6)
                mainarr.append(r3)
                mainarr.append(r4)
                mainarr.append(r5)
                
               
                
                for i in mainarr {
              
                    var nameofcolumn = ""
                    let symbol = i["Symbol"] as! String
                    let high = i["High"] as! String
                    let low = i["Low"] as! String
                    let ask = i["Ask"] as! String
                    let bid = i["Bid"] as! String
                   
                    
                    if symbol == "GLD" {
                        nameofcolumn = "Gold (₹)"
                    } else if symbol == "SILVER" {
                        nameofcolumn = "Silver (₹)"
                    } else if symbol == "XAUUSD" {
                        nameofcolumn = "Gold ($)"
                    } else if symbol == "XAGUSD" {
                        nameofcolumn = "Silver ($)"
                    } else if symbol == "INRSpot" {
                        nameofcolumn = "INR (₹)"
                    }
                    
                    let tempData = LiveRate.init(symbol: nameofcolumn, ask: ask, bid: bid, low: low, high: high, askStatus: "", bidStatus: "")
                    
                    liveData.append(tempData)
                }
                
                completion(liveData)
            } else {
                completion([])
            }
        }
    }
    func getAllSubCategory(manufacture_id:String,id:Int,vc:UIViewController,completion:@escaping ([Category]) -> Void) {
        let parameters = ["category_id":id,"manufacture_id":manufacture_id] as [String : Any]
        print(parameters)
        if Reachability.isConnectedToNetwork() == false {
            vc.showAlert(titlee: "Message", message: "No Internet Connection")
        }
        let authorization:HTTPHeaders =  ["Authorization":Token.getLatestToken()]
        AF.request(NewAPI.subcata,method: .post,parameters: parameters,encoding: JSONEncoding.default,headers: authorization).responseJSON { (responseData) in
            self.printEveryThing(responseData: responseData, statusCode: responseData.response?.statusCode ?? 000, url: NewAPI.subcata, para: parameters)
            if responseData.value != nil {
                let data1 = responseData.value as! [String:Any]
                let data2 = data1["data"] as! [[String:AnyObject]]
                var categories = [Category]()
                for i in data2 {
                    let id = i["id"] as! Int
                    let subcategory = i["subcategory"] as? String
                    let category_id = i["category_id"] as? String
                    let description = i["description"] as? String
                    let image = i["image"] as? String
                    let status = i["status"] as? String
                   
                    
                    let temp = Category.init(id: id, subcategory: subcategory ?? "", categoryID: category_id ?? "", subCategoryDescription: description ?? "", image: image ?? "", status: status ?? "", createdAt: "", updatedAt: "")
                    if status == "1" {
                        categories.append(temp)
                    }
                    
                }
                completion(categories)
            }
        }
        
    }
    func getAllSubsubCategory(id:Int,manufacture_id:String,vc:UIViewController,completion:@escaping ([Any]) -> Void) {
        let parameters = ["subcategory_id":id,"manufacture_id":manufacture_id] as [String : Any]
        print(parameters)
        if Reachability.isConnectedToNetwork() == false {
            vc.showAlert(titlee: "Message", message: "No Internet Connection")
        }
        let authorization:HTTPHeaders =  ["Authorization":Token.getLatestToken()]
        AF.request(NewAPI.subsubcate,method: .post,parameters: parameters,encoding: JSONEncoding.default,headers: authorization).responseJSON { (responseData) in
            print(responseData)
            print(Apis.subsubcate)
            if responseData.value != nil {
                let data1 = responseData.value as! [String:Any]
                if let data2 = data1["data"] as? [[String:AnyObject]] {
                    var categories = [SubCategory]()
                    var machineProduts = [MachineProduct]()
                    if data2.count > 0 {
                        
                        if let pid = data2[0]["product_id"] as? Int {
                            let imgurl = data1["url"] as! String
                            for i in data2 {
                                let id = i["product_id"] as! Int
                                let productname = i["productname"] as! String
                                let amount = i["amount"] as! String
                                let size = i["size"] as! String
                                let default_size = i["default_size"] as! String
                                let size_type = i["size_type"] as! String
                                let image = i["image"] as! String
                                
                                                   
                                let temp = MachineProduct.init(productID: id, productname: productname, amount: amount, size: size, defaultSize: default_size, sizeType: size_type, image: imgurl + "/" + image)
                                machineProduts.append(temp)
                            }
                            completion(machineProduts)
                        } else if let id = data2[0]["id"] as? Int {
                            for i in data2 {
                                let id = i["id"] as! Int
                                let category = i["category"] as? String
                                let subcategory = i["subcategory"] as? String
                                let title = i["title"] as? String
                                let image = i["image"] as? String
                                let created_at = i["created_at"] as? String
                                let updated_at = i["updated_at"] as? String
                                
                                                   
                                let temp = SubCategory.init(id: id, category: category ?? "", subcategory: subcategory ?? "", title: title ?? "", image: image ?? "", createdAt: created_at ?? "", updatedAt: updated_at ?? "")
                                categories.append(temp)
                            }
                            completion(categories)
                        }
                    } else {
                        completion([responseData.response?.statusCode])
                    }
                } else {
                    completion([responseData.response?.statusCode])
                }
            }
        }
    }
    func getAllProducts(manufacture_id:Int,subsubcategory:Int,page:Int,orderby:String,vc:UIViewController,completion: @escaping ([Product],Int) -> Void) {
        let authorization:HTTPHeaders = ["Authorization":Token.getLatestToken()]
        if Reachability.isConnectedToNetwork() == false {
            vc.showAlert(titlee: "Message", message: "No Internet Connection")
        }
        let pare = ["subsubcategory_id":subsubcategory,"page":page,"orderby":orderby,"manufacture_id":manufacture_id/*,"name":"a"*/] as [String : Any]
        AF.request(NewAPI.productList, method: .post, parameters: pare, encoding: URLEncoding.default, headers: authorization).responseJSON { (responseData) in
            self.printEveryThing(responseData: responseData, statusCode: 200, url: NewAPI.productList, para: pare)
            
            if responseData.value != nil {
                
                let resData = responseData.value as! [String:Any]
                print(resData)
                
                if let productData = resData["data"] as? [[String:AnyObject]] {
                    let totalproduct = resData["pagination"] as? Int
                    var allProduct = [Product]()
                    
                    for i in productData {
                        
                        var goldd = [Gold]()
                        var diamondd = [Diamond]()
                        var stonee = [Stone]()
                        var platinumm = [Platinum]()
                        var silverr = [Silver]()
                        
                        let pid = i["product_id"] as! Int
                        let pname = i["product_name"] as? String
                        let size = i["size_type"] as? String
                        let defaultSize = i["default_size"] as? String
                        let sizeType = i["size_type"] as? String
                        let img = i["image"] as? String
                        let weight = i["weight"] as? String
                        let quality = i["quality"] as? String
                        
                        if let gold = i["gold"] as? [String:Any] {
                            let goldweight = gold["goldweight"] as! String
                            let goldquality = gold["goldquality"] as! String
                            let makingcharge = gold["makingcharge"] as! String
                            let option = gold["option"] as! String
                            
                            let tempGold = Gold.init(goldweight: goldweight, goldquality: goldquality, makingcharge: makingcharge, option: option)
                            goldd.append(tempGold)
                        }
                        
                        if let diamong = i["diamond"] as? [String:Any] {
                            let diamond = diamong["diamond"] as! String
                            let diamondqty = diamong["diamondqty"] as! String
                            let default_size = diamong["default_size"] as! String
                            let type = diamong["type"] as! String
                            let diamondcharge = diamong["diamondcharge"] as! String
                            
                            let tempdiamond = Diamond.init(diamond: diamond, diamondqty: diamondqty, no_diamond: "", default_size: default_size, diamondcolor: "", diamondclarity: "", type: type, diamondcharge: diamondcharge)
                            diamondd.append(tempdiamond)
                        }
                        
                        if let stone = i["stone"] as? [String:Any] {
                            let stone_id = stone["stone_id"] as? Int
                            let id = stone["id"] as! Int
                            let product_id = stone["product_id"] as! String
                            let stonetype = stone["stonetype"] as! String
                            let stoneqty = stone["stoneqty"] as! String
                            let stoneno = stone["stoneno"] as! String
                            let type = stone["type"] as! String
                            let stonecharges = stone["stonecharges"] as! String
                            let created_at = stone["created_at"] as! String
                            let updated_at = stone["updated_at"] as! String
                            
                            let tempRes = Stone.init(stoneID: stone_id ?? 0, id: id, productID: product_id, stonetype: stonetype, stoneqty: stoneqty, stoneno: stoneno, type: type, stonecharges: stonecharges, createdAt: created_at, updatedAt: updated_at)
                            
                            stonee.append(tempRes)
                            
                        }
                        
                        if let platinum = i["productpaltinum"] as? [String:Any] {
                            let id = platinum["id"] as! Int
                             let product_id = platinum["product_id"] as! String
                             let platinum_type = platinum["platinum_type"] as! String
                             let platinum_qty = platinum["platinum_qty"] as! String
                             let wastage = platinum["wastage"] as? String
                             let purity = platinum["purity"] as? String
                             let charge_type = platinum["charge_type"] as! String
                             let platinum_charge = platinum["platinum_charge"] as! String
                            
                                 
                            let tempsRes = Platinum.init(id: id, productID: product_id, platinumType: platinum_type, platinumQty: platinum_qty, wastage: wastage ?? "0", purity: purity ?? "0", chargeType: charge_type, platinumCharge: platinum_charge)
                            platinumm.append(tempsRes)
                        }
                        if let silver = i["productsilver"] as? [String:Any] {
                            let id = silver["id"] as! Int
                            let product_id = silver["product_id"] as! String
                            let silver_type = silver["silver_type"] as! String
                            let silverqty = silver["silverqty"] as! String
                            let silverno = silver["silverno"] as! String
                            let charge_type = silver["charge_type"] as! String
                            let silvercharges = silver["silvercharges"] as! String
                            
                           
                            let tempRes = Silver.init(id: id, productID: product_id, silverType: silver_type, silverqty: silverqty, silverno: silverno, chargeType: charge_type, silvercharges: silvercharges)
                            
                            silverr.append(tempRes)
                        }
                        let proWeight = i["weight"] as! [String:Any]
                        let proQuality = i["quality"] as! [String:Any]
                        let product_category = i["product_category"] as? String ?? ""
                        
                        let tempPro = Product.init(imgs: img ?? "", name: pname ?? "", price: "", discountPrice: "", size: size ?? "", gold: goldd, diamond: diamondd, platinum: platinumm, stone: stonee, details: "", id: pid, silver: silverr,weight: weight ?? "",quality: quality ?? "",proWeight: proWeight,proQuality: proQuality, product_category: product_category)
                        
                        allProduct.append(tempPro)
                    }
                    completion(allProduct, totalproduct ?? 10)
                } else {
                    let totalproduct = 0
                    let allProduct = [Product]()
                    completion(allProduct, totalproduct)
                }
            }
        }
    }
    func addToCart(data:[[String:Any]],vc:UIViewController,completion:@escaping ([String:Any]) -> Void) {
        let para = ["data":data]
        print(para)
        let authorization:HTTPHeaders = ["Authorization":Token.getLatestToken()]
        if Reachability.isConnectedToNetwork() == false {
            vc.showAlert(titlee: "Message", message: "No Internet Connection")
        }
        print(header.headers)
        AF.request(Apis.addtocar, method: .post, parameters: para, encoding: JSONEncoding.default, headers: authorization).responseJSON { (responseData) in
            print(responseData)
            if responseData.value != nil {
                
                let data = responseData.value as! [String:Any]
                let status = data["status"] as! Int
                
                completion(data)
               
                
            }
        }
    }
    func cleanupDb() {
        let diamondName = try! Realm().objects(DiamondPrice.self)
        let gold = try! Realm().objects(GoldPrice.self)
        let silver = try! Realm().objects(SilverPrice.self)
        let stone = try! Realm().objects(StonePrice.self)
        let diamondcolor = try! Realm().objects(DiamondColor.self)
        let diamondclarity = try! Realm().objects(DiamondClarity.self)
        let platinum = try! Realm().objects(PlatinumPrice.self)
        let diamondMaster = try! Realm().objects(DiamondMaster.self)
        
        let realm = try! Realm()
        try! realm.write {
            realm.delete(diamondName)
            realm.delete(gold)
            realm.delete(silver)
            realm.delete(stone)
            realm.delete(diamondcolor)
            realm.delete(diamondclarity)
            realm.delete(platinum)
            realm.delete(diamondMaster)
        }
       
    }
    func viewCart(user_id:String,vc:UIViewController,completion:@escaping ([Cart]) -> Void) {
        let authorization:HTTPHeaders = ["Authorization":Token.getLatestToken()]
        if Reachability.isConnectedToNetwork() == false {
            vc.showAlert(titlee: "Message", message: "No Internet Connection")
        }
        AF.request(NewAPI.viweCart + user_id, method: .get, parameters: nil, encoding: URLEncoding.default, headers: authorization).responseJSON { (responseData) in
            self.printEveryThing(responseData: responseData, statusCode: responseData.response?.statusCode ?? 000, url: NewAPI.viweCart, para: "")
            if responseData.value != nil {
                
                let data = responseData.value as! [String:Any]
                let status = data["status"] as! Int
                var cartTemp = [Cart]()
                self.cleanupDb()
                print(responseData.value)
                if status == 200 {
                    let baseUrl = data["url"] as! String
                    let resData = data["data"] as! [[String:AnyObject]]
                    let manufacture_limit = data["manufacture_limit"] as! Double
                    let manufacture_name = data["manufacture_name"] as! String
                    
                    
                    let res = resData[0]["price"] as! [String:Any]
                    
                    
                    if let diamondName = res["diamond"] as? [[String:AnyObject]] {
                                           let realm = try! Realm()
                                           for i in diamondName {
                                               let dp1 = DiamondPrice()
                                               dp1.id = dp1.incremnetID()
                                            dp1.diamond_type = (i["diamond_type"] as? String)!
                                               
                                               dp1.price = (i["price"] as? String)!
                                               try! realm.write {
                                                   realm.add(dp1)
                                               }
                                           }
                                       }

                                       //MARK: Gold
                                       if let gold = res["gold"] as? [[String:AnyObject]] {
                                           let realm = try! Realm()
                                           for i in gold {
                                               let g1 = GoldPrice()
                                               g1.id = g1.incremnetID()
                                               g1.gold_type = i["type"] as! String
                                              g1.price =  String(format: "%@", (i["price"]) as! CVarArg)
                                              
                                               g1.valuein = Double(i["value_in"] as! String)!
                                               try! realm.write {
                                                   realm.add(g1)
                                               }
                                           }
                                       }

                                       //MARK: Silver
                                       if let silver = res["silver"] as? [[String:AnyObject]] {
                                           let realm = try! Realm()
                                           for i in silver {
                                               let s1 = SilverPrice()
                                                
                                               s1.id = s1.incremnetID()
                                               s1.silver_type = i["type"] as! String
                                            s1.value = i["value_in"] as! String
                                            s1.price =  String(format: "%@", (i["price"]) as! CVarArg)
                                              
                                               try! realm.write {
                                                   realm.add(s1)
                                               }
                                           }
                                       }

                                       //MARK: Stone
                                       if let stone = res["stone"] as? [[String:AnyObject]] {
                                           let realm = try! Realm()
                                           for i in stone {
                                               let st1 = StonePrice()
                                               st1.id = st1.incremnetID()
                                               st1.stone_type = i["type"] as! String
                                              
                                            st1.price =  String(format: "%@", (i["price"]) as! CVarArg)
                                               try! realm.write {
                                                   realm.add(st1)
                                               }
                                           }
                                       }

                                       //MARK: Diamond COlor
                                       if let diamondcolor = res["diamondcolor"] as? [[String:AnyObject]] {
                                           let realm = try! Realm()
                                           for i in diamondcolor {
                                               let dc1 = DiamondColor()
                                               dc1.id = dc1.incremnetID()
                                               dc1.color = i["color"] as! String
                                               
                                            dc1.price =  String(format: "%@", (i["price"]) as! CVarArg)
                                               try! realm.write {
                                                   realm.add(dc1)
                                               }
                                           }
                                       }
                                       if let diamondclarity = res["diamondclarity"] as? [[String:AnyObject]] {
                                           let realm = try! Realm()
                                           for i in diamondclarity {
                                               let dcl1 = DiamondClarity()
                                               dcl1.id = dcl1.incremnetID()
                                               dcl1.clarity = i["clarity"] as! String
                                              
                                            
                                            dcl1.price =  String(format: "%@", (i["price"]) as! CVarArg)
                                            
                                               try! realm.write {
                                                   realm.add(dcl1)
                                               }
                                           }
                                       }
                                       if let platinum = res["platinum"] as? [[String:AnyObject]] {
                                           let realm = try! Realm()
                                           for i in platinum {
                                               let p1 = PlatinumPrice()
                                               p1.id = p1.incremnetID()
                                               p1.platinum_type = i["type"] as! String
                                              
                                            p1.price =  String(format: "%@", (i["price"]) as! CVarArg)
                                               try! realm.write {
                                                   realm.add(p1)
                                               }
                                           }
                                       }
                                       if let diamondMaster = res["diamond_master"] as? [[String:AnyObject]] {
                                           let realm = try! Realm()
                                           for i in diamondMaster {
                                            let dm1 = DiamondMaster()
                                            dm1.id = dm1.incremnetID()
                                            print(dm1.id)
                                            dm1.name = i["diamond_type"] as! String
                                            dm1.type = i["type"] as! String
                                            dm1.price =  String(format: "%@", (i["price"]) as! CVarArg)
                                               try! realm.write {
                                                   realm.add(dm1)
                                               }
                                           }
                                       }
                  
                    for i in resData {
                        var asset = [Asset]()
                        let cart_id = i["cart_id"] as! Int
                        let count = i["count"] as? String
                        let product_id = i["product_id"] as? String
                        let user_id = i["user_id"] as? String
                        let category = i["category"] as? String
                        let subCategory = i["subCategory"] as? String
                        let subSubCategory = i["subSubCategory"] as? String
                        let productCode = i["productCode"] as? String
                        let productName = i["productName"] as? String
                        let description = i["description"] as? String
                        let imgTemp = i["image"] as? String
                        //let wastage = i["wastage"] as? String
                        let image = baseUrl + "/" + imgTemp!
                        let default_size = i["default_size"] as! String
                        let product_size = i["product_size"] as! String
                        let productType = i["jwellery_type"] as! String
                        
                        
                        if let assets = i["assests"] as? [[String:Any]] {
                            
                            for ii in assets {
                                let id = ii["id"] as! Int
                                let weight = ii["weight"] as? String
                                let materialType = ii["materialType"] as? String
                                let makingCharge = ii["makingCharge"] as? String
                                let options = ii["options"] as? String
                                let metal = ii["metal"] as? String
                                let product_id = ii["product_id"] as? String
                                let cart_id = ii["cart_id"] as? String
                                let wastage = ii["wastage"] as? String
                                var diamondType = ""
                                var certification_cost = ""
                                var crtcost_option = ""
                                var diamond_index = ""
                                var meena_cost = ""
                                var meenacost_option = ""
                                var product_size = ""
                                var selectedColor = ""
                                var stoneType = ""
                                var stone_index = ""
                                
                                if ii ["diamondType"] != nil
                                {
                                    diamondType =  String(format: "%@", (ii ["diamondType"]) as! CVarArg)
                                }
                                if ii ["certification_cost"] != nil
                                {
                                    
                                    certification_cost =  String(format: "%@", (ii ["certification_cost"]) as! CVarArg)
                                }
                                if ii ["crtcost_option"] != nil
                                {
                                    crtcost_option =  String(format: "%@", (ii ["crtcost_option"]) as! CVarArg)
                                    
                                }
                                if ii ["diamond_index"] != nil
                                {
                                    
                                    diamond_index =  String(format: "%@", (ii ["diamond_index"]) as! CVarArg)
                                }
                                if ii ["meena_cost"] != nil
                                {
                                    meena_cost =  String(format: "%@", (ii ["meena_cost"]) as! CVarArg)
                                   
                                }
                                if ii ["meenacost_option"] != nil
                                {
                                    meenacost_option =  String(format: "%@", (ii ["meenacost_option"]) as! CVarArg)
                                    
                                }
                                if ii ["product_size"] != nil
                                {
                                    product_size =  String(format: "%@", (ii ["product_size"]) as! CVarArg)
                                 
                                }
                                if ii ["stoneType"] != nil
                                {
                                    stoneType =  String(format: "%@", (ii ["stoneType"]) as! CVarArg)
                                   
                                }
                                
                                
                                if ii ["stone_index"] != nil
                                {
                                    stone_index =  String(format: "%@", (ii ["stone_index"]) as! CVarArg)
                                   
                                }
                                var purity = ""
                                if ii ["purity"] != nil
                                {
                                    purity =  String(format: "%@", (ii ["purity"]) as! CVarArg)
                                    
                                }
                               
                                if ii ["product_size"] != nil
                                {
                                    product_size =  String(format: "%@", (ii ["product_size"]) as! CVarArg)
                                  
                                }
                                
                                let tempAsset = Asset.init(id: id, weight: weight!, materialType: materialType!, makingCharge: makingCharge!, options: options!, metal: metal!, product_id: product_id!, cart_id: cart_id!,wastage:wastage!,diamondType:diamondType,purity:purity, certification_cost : certification_cost, crtcost_option : crtcost_option, diamond_index : diamond_index, meena_cost : meena_cost, meenacost_option : meenacost_option,product_size : product_size, selectedColor:selectedColor, stone_index : stone_index, stoneType : stoneType)
                                
                                asset.append(tempAsset)
                            }
                        }
                        let tempCart = Cart.init(cartID: cart_id, count: count!, productID: product_id!, userID: user_id!, category: category!, subCategory: subCategory!, subSubCategory: subSubCategory!, productCode: productCode!, productName: productName!, welcomeDescription: description!, productType: productType, productTotal: "", totalMakingCharge: "", image: image, assets: asset,manufacture_limit:"\(manufacture_limit)",manufacture_name:manufacture_name,product_size:product_size,default_size:default_size)
                       
                        
                        cartTemp.append(tempCart)
                    }
                    completion(cartTemp)
                } else if status == 400 {
                    completion(cartTemp)
                }
            }
        }
    }
    func cartUpdate(productId:String,count:String,vc:UIViewController,completion:@escaping(String) -> Void) {
        let authorization:HTTPHeaders =  ["Authorization":Token.getLatestToken()]
        if Reachability.isConnectedToNetwork() == false {
            vc.showAlert(titlee: "Message", message: "No Internet Connection")
        }
        let para = NSDictionary()
        let userid = UserDefaults.standard.string(forKey: "userid") as! String
        if Reachability.isConnectedToNetwork() == false {
            vc.showAlert(titlee: "Message", message: "No Internet Connection")
        }
        AF.request("\(Apis.cartUpdate)?cart_id=\(productId)&user_id=\(userid)&count=\(count)", method: .put, parameters: para as! Parameters, encoding: JSONEncoding.default, headers: authorization).responseJSON { (responseData) in
            print(responseData)
            if responseData.value != nil {
                let data = responseData.value as! [String:Any]
                
                let status = data["status"] as! Int
                if status == 200 {
                    completion("success")
                } else {
                    completion("failure")
                }
            }
        }
    }
    func removeCart(productId:String,vc:UIViewController,completion:@escaping(String) -> Void) {
        let authorization:HTTPHeaders =  ["Authorization":Token.getLatestToken()]
        if Reachability.isConnectedToNetwork() == false {
            vc.showAlert(titlee: "Message", message: "No Internet Connection")
        }
        let para = NSDictionary()
        let userid = UserDefaults.standard.string(forKey: "userid") as! String
        if Reachability.isConnectedToNetwork() == false {
            vc.showAlert(titlee: "Message", message: "No Internet Connection")
        }
        AF.request("\(Apis.cartDelete)?cart_id=\(productId)&user_id=\(userid)", method: .delete, parameters: para as! Parameters, encoding: JSONEncoding.default, headers: authorization).responseJSON { (responseData) in
            print(responseData)
            if responseData.value != nil {
                let data = responseData.value as! [String:Any]
                
                let status = data["status"] as! Int
                if status == 200 {
                    completion("success")
                } else {
                    completion("failure")
                }
            }
        }
    }
    func viewWishlist(vc:UIViewController,completion:@escaping ([Wishlist]) -> Void) {
        let authorization:HTTPHeaders = ["Authorization":Token.getLatestToken()]
        if Reachability.isConnectedToNetwork() == false {
            vc.showAlert(titlee: "Message", message: "No Internet Connection")
        }
        AF.request(NewAPI.wishlistView, method: .get, parameters: nil, encoding: URLEncoding.default, headers: authorization).responseJSON { (responseData) in
            if responseData.value != nil {
                if responseData.response?.statusCode == 200 {
                    var tempArr = [Wishlist]()
                    let data = responseData.value as! [String:Any]
                    let url = data["url"] as! String
                    let all = data["data"] as! [[String:Any]]
                    for i in all {
                        let wishlist_id = i["wishlist_id"] as? Int ?? 0
                        let product_id = i["product_id"] as? Int ?? 0
                        let productname = i["productname"] as? String ?? ""
                        let size = i["size"] as? String ?? ""
                        let image = i["image"] as? String ?? ""
                        let quality = i["quality"] as? String ?? ""
                        let weight = i["weight"] as? String ?? ""
                        
                        let temp = Wishlist.init(wishlistID: wishlist_id, productID: product_id, productname: productname, size: size, image: url + "/" + image, quality: quality, weight: weight)
                        
                        tempArr.append(temp)
                    }
                    completion(tempArr)
                }
            }
        }
    }
    
    func getAllOffer(page:Int,vc:UIViewController,completion:@escaping ([Offer],Int,Int,Int) -> Void) {
        let authorization:HTTPHeaders =  ["Authorization":Token.getLatestToken()]
        if Reachability.isConnectedToNetwork() == false {
            vc.showAlert(titlee: "Message", message: "No Internet Connection")
        }
        print(NewAPI.offers)
        AF.request(NewAPI.offers, method: .get, parameters: nil, encoding: URLEncoding.default, headers: authorization).responseJSON { (responseData) in
            self.printEveryThing(responseData: responseData, statusCode: responseData.response?.statusCode ?? 000, url: NewAPI.offers, para: "")
            var allOffer = [Offer]()
            if responseData.value != nil {
                
                if responseData.response?.statusCode == 200 {
                    let data = responseData.value as! [String:Any]
                    let resData = data["data"] as! [String:Any]
                    let url = data["url"] as! String
                    let resData1 = resData["data"] as! [[String:AnyObject]]
                    let totalNumber = resData["total"] as! Int
                    let current_page = resData["current_page"] as! Int
                    let last_page = resData["last_page"] as! Int
                    
                    for i in resData1 {
                        let title = i["title"] as! String
                        let description = i["description"] as! String
                        let coupan = i["coupan"] as! String
                        let value = i["value"] as! String
                        let img = i["image"] as! String
                        
                        let temp = Offer.init(title: title, subtitle: description, img: url + "/" + img, code: coupan, value: value)
                        allOffer.append(temp)
                    }
                    completion(allOffer,totalNumber,current_page,last_page)
                }
            }
            completion(allOffer,0,0,0)
        }
    }
    func getAllOrder(page:Int,vc:UIViewController,completion:@escaping ([Order],Int) -> Void) {
        let userid = UserDefaults.standard.string(forKey: "userid") as! String
        let authorization:HTTPHeaders =  ["Authorization":Token.getLatestToken()]
        let para = ["user_id":userid,"page":page] as [String : Any]
        if Reachability.isConnectedToNetwork() == false {
            vc.showAlert(titlee: "Message", message: "No Internet Connection")
        }
        AF.request(Apis.order, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: authorization).responseJSON { (responseData) in
            print(responseData)
            if responseData.value != nil {
                var orders = [Order]()
                if responseData.response?.statusCode == 200 {
                    let data = responseData.value as! [String:Any]
                    let resData = data["data"] as! [[String:AnyObject]]
                    let baseUrl = data["url"] as! String
                    let total = 0
                    
                    for i in resData {
                        var products = [Cart]()
                        let Order_id = i["Order_id"] as! Int
                        let payment_mode = i["payment_mode"] as! String
                        let transaction_id = i["transaction_id"] as! String
                        let message = i["message"] as! String
                        let address_id = i["address_id"] as! String
                        let totalamount = i["totalamount"] as! String
                        let sgst = i["sgst"] as! String
                        let cgst = i["cgst"] as! String
                        let igst = i["igst"] as! String
                        let final_total = i["final_total"] as! String
                        let sgst_per = i["sgst_per"] as! String
                        let cgst_per = i["cgst_per"] as! String
                        let igst_per = i["igst_per"] as! String
                        let status = i["status"] as! String
                        let order_status = ""
                        let created_at = i["created_at"] as! String
                        let product = i["product"] as! [[String:AnyObject]]
                        for ii in product {
                            var asset = [Asset]()
                            let cart_id = ii["cart_id"] as! Int
                            let count = ii["count"] as? String
                            let product_id = ii["product_id"] as? String
                            let user_id = ii["user_id"] as? String
                            let category = ii["category"] as? String
                            let subCategory = ii["subCategory"] as? String
                            let subSubCategory = ii["subSubCategory"] as? String
                            let productCode = ii["productCode"] as? String
                            let productName = ii["productName"] as? String
                            let productType = ii["productType"] as? String
                            let productTotal = ii["productTotal"] as? String
                            let totalMakingCharge = ii["totalMakingCharge"] as? String
                            let description = ii["description"] as? String
                            let imgTemp = ii["image"] as? String
                            
                            let image = baseUrl + "/" + imgTemp!
                            if let assets = ii["assests"] as? [[String:Any]] {
                                for iii in assets {
                                    let id = iii["id"] as! Int
                                    let weight = iii["weight"] as? String
                                    let materialType = iii["materialType"] as? String
                                    let makingCharge = iii["makingCharge"] as? String
                                    let options = iii["options"] as? String
                                    let metal = iii["metal"] as? String
                                    let product_id = iii["product_id"] as? String
                                    
                                    let cart_id = iii["cart_id"] as? String
                                    
                                    var diamondType = ""
                                   
                                    var certification_cost = ""
                                    var crtcost_option = ""
                                    var diamond_index = ""
                                    var meena_cost = ""
                                    var meenacost_option = ""
                                    var product_size = ""
                                    var stoneType = ""
                                    var stone_index = ""
                                    var wastage = ""
                                    if iii ["wastage"] != nil
                                    {
                                        wastage =  String(format: "%@", (iii ["wastage"]) as! CVarArg)
                                    }
                                    
                                    if iii ["diamondType"] != nil
                                    {
                                        diamondType =  String(format: "%@", (iii ["diamondType"]) as! CVarArg)
                                    }
                                    if iii ["certification_cost"] != nil
                                    {
                                        
                                        certification_cost =  String(format: "%@", (iii ["certification_cost"]) as! CVarArg)
                                    }
                                    if iii ["crtcost_option"] != nil
                                    {
                                        crtcost_option =  String(format: "%@", (iii ["crtcost_option"]) as! CVarArg)
                                        
                                    }
                                    if iii ["diamond_index"] != nil
                                    {
                                        
                                        diamond_index =  String(format: "%@", (iii ["diamond_index"]) as! CVarArg)
                                    }
                                    if iii ["meena_cost"] != nil
                                    {
                                        meena_cost =  String(format: "%@", (iii ["meena_cost"]) as! CVarArg)
                                       
                                    }
                                    if iii ["meenacost_option"] != nil
                                    {
                                        meenacost_option =  String(format: "%@", (iii ["meenacost_option"]) as! CVarArg)
                                        
                                    }
                                    if iii ["product_size"] != nil
                                    {
                                        product_size =  String(format: "%@", (iii ["product_size"]) as! CVarArg)
                                     
                                    }
                                    if iii ["stoneType"] != nil
                                    {
                                        stoneType =  String(format: "%@", (iii ["stoneType"]) as! CVarArg)
                                       
                                    }
                                    
                                    
                                    if iii ["stone_index"] != nil
                                    {
                                        stone_index =  String(format: "%@", (iii ["stone_index"]) as! CVarArg)
                                       
                                    }
                                    var purity = ""
                                    if iii ["purity"] != nil
                                    {
                                        purity =  String(format: "%@", (iii ["purity"]) as! CVarArg)
                                        
                                    }
                                   
                                    if iii ["product_size"] != nil
                                    {
                                        product_size =  String(format: "%@", (iii ["product_size"]) as! CVarArg)
                                      
                                    }
                                    let tempAsset = Asset.init(id: id, weight: weight!, materialType: materialType!, makingCharge: makingCharge!, options: options!, metal: metal!, product_id: product_id!, cart_id: cart_id!,wastage:wastage,diamondType:diamondType,purity:purity,certification_cost : "", crtcost_option : "", diamond_index : "", meena_cost : "", meenacost_option : "", product_size: product_size,selectedColor : "",stone_index : "", stoneType : "")
                                    
                                    asset.append(tempAsset)
                                }
                            }
                            
                            let temporder = Cart.init(cartID: cart_id, count: count!, productID: product_id!, userID: user_id!, category: category!, subCategory: subCategory!, subSubCategory: subSubCategory!, productCode: productCode!, productName: productName!, welcomeDescription: description!, productType: productType!, productTotal: productTotal!, totalMakingCharge: totalMakingCharge!, image: image, assets: asset,manufacture_limit:"",manufacture_name:"",product_size:"",default_size:"")
                            
                            products.append(temporder)
                        }
                        let tempOrder = Order.init(orderID: Order_id, paymentMode: payment_mode, transactionID: transaction_id, message: message, addressID: address_id, totalamount: totalamount, sgst: sgst, cgst: cgst, igst: igst, finalTotal: final_total, sgstPer: sgst_per, cgstPer: cgst_per, igstPer: igst_per, status: status, orderStatus: order_status, createdAt: created_at, product: products)
                        
                        orders.append(tempOrder)
                    }
                    completion(orders,total)
                } else {
                    completion(orders,0)
                }
            }
        }
    }
    
    func getAllAddress(vc:UIViewController,completion:@escaping([Address]) -> Void) {
        let authorization:HTTPHeaders =  ["Authorization":Token.getLatestToken()]
        if Reachability.isConnectedToNetwork() == false {
            vc.showAlert(titlee: "Message", message: "No Internet Connection")
        }
        AF.request(NewAPI.addressView,method: .get,parameters: nil,encoding: URLEncoding.default,headers: authorization).responseJSON { (responseData) in
            self.printEveryThing(responseData: responseData, statusCode: responseData.response?.statusCode ?? 000, url: responseData.request?.url?.absoluteString ?? "", para: "")
            if responseData.value != nil {
                if responseData.response?.statusCode == 200 {
                    let data = responseData.value as! [String:Any]
                    let data1 = data["data"] as! [[String:AnyObject]]
                    var allAddr = [Address]()
                    for i in data1 {
                        let id = i["id"] as! Int
                        let uid = i["uid"] as? String
                        let first = i["first"] as? String
                        let last = i["last"] as? String
                        let country = i["country"] as? String
                        let address = i["address"] as? String
                        let pincode = i["pincode"] as? String
                        let city = i["city"] as? String
                        let region = i["region"] as? String
                        let mobileno = i["mobileno"] as? String
                        
                        let tempAdd = Address.init(id: id, uid: uid!, first: first!, last: last!, country: country!, address: address!, pincode: pincode!, city: city!, region: region!, mobileno: mobileno!)
                        allAddr.append(tempAdd)
                    }
                    completion(allAddr)
                }
            }
        }
    }
    func addAddress(first:String,last:String,country:String,address:String,pincode:String,city:String,region:String,mobileno:String,method:HTTPMethod,vc:UIViewController,completion: @escaping (String) -> Void) {
        let para = ["first":first,"last":last,"country":country,"address":address,"pincode":pincode,"city":city,"region":region,"mobileno":mobileno]
        let authorization:HTTPHeaders =  ["Authorization":Token.getLatestToken()]
        if Reachability.isConnectedToNetwork() == false {
            vc.showAlert(titlee: "Message", message: "No Internet Connection")
        }
        AF.request(NewAPI.addressAdd, method: method, parameters: para, encoding: URLEncoding.default, headers: authorization).responseJSON { (responseData) in
            self.printEveryThing(responseData: responseData, statusCode: responseData.response?.statusCode ?? 000, url: responseData.request?.url?.absoluteString ?? "", para: para)
            if responseData.value != nil {
                if responseData.response?.statusCode == 200 {
                    completion("success")
                }
            }
        }
    }
    func updateAddress(first:String,last:String,country:String,address:String,pincode:String,city:String,region:String,mobileno:String,addrid:String,vc:UIViewController,completion: @escaping (String) -> Void) {
        let para = ["first":first,"last":last,"country":country,"address":address,"pincode":pincode,"city":city,"region":region,"mobileno":mobileno]
        if Reachability.isConnectedToNetwork() == false {
            vc.showAlert(titlee: "Message", message: "No Internet Connection")
        }
        let authorization:HTTPHeaders =  ["Authorization":Token.getLatestToken()]
        AF.request(NewAPI.addressEdit + addrid, method: .put, parameters: para, encoding: URLEncoding.default, headers: authorization).responseJSON { (responseData) in
            self.printEveryThing(responseData: responseData, statusCode: responseData.response?.statusCode ?? 000, url: responseData.request?.url?.absoluteString ?? "", para: para)
            if responseData.value != nil {
                if responseData.response?.statusCode == 200 {
                    completion("success")
                }
            }
        }
        
    }
    func deleteAddress(addr_id:String,vc:UIViewController,completion:@escaping(String) -> Void) {
        let authorization:HTTPHeaders =  ["Authorization":Token.getLatestToken()]
        if Reachability.isConnectedToNetwork() == false {
            vc.showAlert(titlee: "Message", message: "No Internet Connection")
        }
        AF.request(NewAPI.addressDelete + addr_id, method: .delete, parameters: nil, encoding: URLEncoding.default, headers: authorization).responseJSON { (responseData) in
            self.printEveryThing(responseData: responseData, statusCode: responseData.response?.statusCode ?? 000, url: responseData.request?.url?.absoluteString ?? "", para: addr_id)
            if responseData.value != nil {
                if responseData.response?.statusCode == 200 {
                    completion("success")
                } else {
                    completion("failure")
                }
            }
        }
    }
    
    func addwishlist(product_id:String,vc:UIViewController,completion:@escaping (String) -> Void) {
        let para = ["product_id":product_id]
        if Reachability.isConnectedToNetwork() == false {
            vc.showAlert(titlee: "Message", message: "No Internet Connection")
        }
        let authorization:HTTPHeaders =  ["Authorization":Token.getLatestToken()]
        AF.request(NewAPI.wishlistStore, method: .post, parameters: para, encoding: URLEncoding.default, headers: authorization).responseJSON { (responseData) in
            print(responseData)
            if responseData.value != nil {
                if responseData.response?.statusCode == 200 {
                    completion("success")
                }else if responseData.response?.statusCode == 402 {
                    
                    let data = responseData.value as! [String:Any]
                    
                    let message = data["message"] as! String
                    
                   completion(message)
                    
                    }else {
                    completion("failure")
                }
            }
        }
    }
    func removewishlist(product_id:String,vc:UIViewController,completion:@escaping (String) -> Void) {
        let authorization:HTTPHeaders =  ["Authorization":Token.getLatestToken()]
        if Reachability.isConnectedToNetwork() == false {
            vc.showAlert(titlee: "Message", message: "No Internet Connection")
        }
        AF.request(NewAPI.wishlistDelete + product_id, method: .delete, parameters: nil, encoding: URLEncoding.default, headers: authorization).responseJSON { (responseData) in
            self.printEveryThing(responseData: responseData, statusCode: responseData.response?.statusCode ?? 000, url: responseData.request?.url?.absoluteString ?? "", para: "")
            if responseData.value != nil {
                if responseData.response?.statusCode == 200 {
                    completion("success")
                } else {
                    completion("failure")
                }
            }
        }
    }
    
    func checkout(data:[String:Any],vc:UIViewController,completion:@escaping ([String:Any]) -> Void) {
        let authorization:HTTPHeaders =  ["Authorization":Token.getLatestToken()]
        let para = ["calculation":data]
        if Reachability.isConnectedToNetwork() == false {
            vc.showAlert(titlee: "Message", message: "No Internet Connection")
        }
        AF.request(Apis.checkout, method: .post, parameters: para, encoding: JSONEncoding.default, headers: authorization).responseJSON { (responseData) in
            print(para)
            print(responseData.value)
            if responseData.value != nil {
                let data = responseData.value as! [String:Any]
                let status = data["status"] as! Int
                if status == 200 {
                    let data = responseData.value as! [String:Any]
                    completion(data)
                } else {
                    completion([:])
                }
            }
        }
    }
    
    func getInvoice(order_id:String,buyer_id:String,seller_id:String,vc:UIViewController,completion:@escaping (String) -> Void) {
        let authorization:HTTPHeaders =  ["Authorization":Token.getLatestToken()]
        let para = NSDictionary()
        if Reachability.isConnectedToNetwork() == false {
            vc.showAlert(titlee: "Message", message: "No Internet Connection")
        }
        AF.request(Apis.invoice+order_id+"/"+buyer_id+"/"+seller_id, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: authorization).responseJSON { (responseData) in
            print(para)
            print(responseData.value)
            if responseData.value != nil {
                let data = responseData.value as! [String:Any]
                let status = data["status"] as! Int
                if status == 200 {
                    completion("success")
                } else {
                    completion("failure")
                }
            }
        }
    }
    
    func getFilterData(vc:UIViewController,completion:@escaping ([String:[String]]) -> Void) {
        if Reachability.isConnectedToNetwork() == false {
            vc.showAlert(titlee: "Message", message: "No Internet Connection")
        }
        AF.request(Apis.filterData, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: header.headers).responseJSON { (responsedata) in
            if responsedata.value != nil {
                let data = responsedata.value as! [String:Any]
                let status = data["status"] as! Int
                if status == 200 {
                    let menu = data["menu"] as! [String:Any]
                    for i in menu {
                        print(i.key)
                    }
                }
            }
        }
    }
    
    func searchProduct(name:String,vc:UIViewController,completion:@escaping ([Searchproduct], [SearchSeller]) -> Void) {
        let para = ["search":name]
        let authorization:HTTPHeaders =  ["Authorization":Token.getLatestToken()]
        if Reachability.isConnectedToNetwork() == false {
            vc.showAlert(titlee: "Message", message: "No Internet Connection")
        }
        AF.request(NewAPI.productList, method: .post, parameters: para, encoding: URLEncoding.default, headers: authorization).responseJSON { (responseData) in
            self.printEveryThing(responseData: responseData, statusCode: responseData.response?.statusCode ?? 000, url: NewAPI.searchurl, para: para)
            if responseData.value != nil {
                if responseData.response?.statusCode == 200 {
                    let data = responseData.value as! [String:Any]
                    let url = data["url"] as? String ?? ""
                    var allSearchPro = [Searchproduct]()
                    var allSearchSellers = [SearchSeller]()
                    
                    if let resData = data["data"] as? [[String:AnyObject]] {
                        for i in resData {
                            let product_id = i["product_id"] as? Int ?? 0
                            let productname = i["product_name"] as? String ?? ""
                            let amount = i["amount"] as? String ?? ""
                            let code = i["productcode"] as? String ?? ""
                            let jwellery_type = i["jwellery_type"] as? String ?? ""
                            let default_size = i["default_size"] as? String ?? ""
                            let size_type = i["size_type"] as? String ?? ""
                            let image = i["image"] as? String ?? ""
                            
                            let temp = Searchproduct.init(productID: product_id, productname: productname, amount: amount, productCode: code, jwelleryType: jwellery_type, defaultSize: default_size, sizeType: size_type, image:url + "/" + image)
                            
                            allSearchPro.append(temp)
                        }
                    }
                    if let resData = data["manufacture_data"] as? [[String:AnyObject]] {
                        for i in resData {
                            let manufacture_id = i["manufacture_id"] as? Int ?? 0
                            let company_name = i["company_name"] as? String ?? ""
                            let description = i["description"] as? String ?? ""
                            let email = i["email"] as? String ?? ""
                            let logo = i["logo"] as? String ?? ""
                            let mobile_no = i["mobile_no"] as? String ?? ""
                            let name = i["name"] as? String ?? ""
                            
                            let temp = SearchSeller(manufacture_id: manufacture_id, name: name, email: email, description: description, mobile_no: mobile_no, company_name: company_name, logo: logo)
                            
                            allSearchSellers.append(temp)
                        }
                    }
                    completion(allSearchPro, allSearchSellers)
                }
            }
        }
    }
    func searchMachinery(name:String,vc:UIViewController,completion:@escaping ([Searchproduct], [SearchSeller]) -> Void) {
           let para = ["search":name]
           let authorization:HTTPHeaders =  ["Authorization":Token.getLatestToken()]
           if Reachability.isConnectedToNetwork() == false {
               vc.showAlert(titlee: "Message", message: "No Internet Connection")
           }
           AF.request(NewAPI.machinerySearchURL, method: .post, parameters: para, encoding: URLEncoding.default, headers: authorization).responseJSON { (responseData) in
               self.printEveryThing(responseData: responseData, statusCode: responseData.response?.statusCode ?? 000, url: NewAPI.searchurl, para: para)
               if responseData.value != nil {
                if responseData.response?.statusCode == 200 {
                    let data = responseData.value as! [String:Any]
                    let url = data["url"] as? String ?? ""
                    var allSearchPro = [Searchproduct]()
                    var allSearchSellers = [SearchSeller]()
                    if let resData = data["data"] as? [[String:AnyObject]] {
                        for i in resData {
                            let product_id = i["machinery_id"] as? Int ?? 0
                            let productname = i["machinery_name"] as? String ?? ""
                            let amount = i["amount"] as? String ?? ""
                            let description = i["machinery_category"] as? String ?? ""
                            let jwellery_type = ""
                            let default_size = ""
                            let size_type = ""
                            let image = i["image"] as? String ?? ""
                            var imageUrl = ""
                            if image.contains("http") {
                                imageUrl = image
                            } else {
                                imageUrl = url + "/" + image
                            }
                            
                            let temp = Searchproduct.init(productID: product_id, productname: productname, amount: amount, productCode: description, jwelleryType: jwellery_type, defaultSize: default_size, sizeType: size_type, image:imageUrl)
                            
                            allSearchPro.append(temp)
                        }
                    }
                    if let resData = data["manufacture_data"] as? [[String:AnyObject]] {
                        for i in resData {
                            let manufacture_id = i["manufacture_id"] as? Int ?? 0
                            let company_name = i["company_name"] as? String ?? ""
                            let description = i["description"] as? String ?? ""
                            let email = i["email"] as? String ?? ""
                            let logo = i["logo"] as? String ?? ""
                            let mobile_no = i["mobile_no"] as? String ?? ""
                            let name = i["name"] as? String ?? ""
                            
                            let temp = SearchSeller(manufacture_id: manufacture_id, name: name, email: email, description: description, mobile_no: mobile_no, company_name: company_name, logo: logo)
                            
                            allSearchSellers.append(temp)
                        }
                    }
                    completion(allSearchPro, allSearchSellers)
                }
               }
           }
       }
    
    //MARK: Upload Profile Picture and Documents
    func uploaDoc1(gst:String,pan:String,mobile:String,adhar:String,imgs:[[String:Any]],vc:UIViewController,completion:@escaping (String) -> Void) {
          
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgs[0]["img1Data"] as! Data, withName: "gst_doc", fileName:"image1.jpg", mimeType: "image/jpeg")
            multipartFormData.append(imgs[1]["img2Data"] as! Data, withName: "aadhar_doc", fileName:"image2.jpg", mimeType: "image/jpeg")
            multipartFormData.append(imgs[2]["img3Data"] as! Data, withName: "visiting_doc", fileName:"image3.jpg", mimeType: "image/jpeg")
            multipartFormData.append(imgs[3]["img4Data"] as! Data, withName: "pan_doc", fileName:"image4.jpg", mimeType: "image/jpeg")
                 
            
            multipartFormData.append((pan).data(using: String.Encoding.utf8)!, withName: "pan_no")
            multipartFormData.append((gst).data(using: String.Encoding.utf8)!, withName: "gst_no")
            multipartFormData.append((adhar).data(using: String.Encoding.utf8)!, withName: "aadhar")
            multipartFormData.append((mobile).data(using: String.Encoding.utf8)!, withName: "mobile_no")
        }, to: Apis.docUpload,method: .post,headers: header.headers)
            .responseJSON { response in
                print(response)
                let resData = response.value as! [String:Any]
                let status = resData["status"] as! Int
                let force_update = resData["force_update"] as! Int
                if force_update == 0 {
                    if status == 1 {
                        completion("success")
                    } else {
                        
                    }
                } else {
                    
                }
            }
        
//           AF.upload(
//                  multipartFormData: { multipartFormData in
//
//                multipartFormData.append(imgs[0]["img1Data"] as! Data, withName: "gst_doc", fileName:"image1.jpg", mimeType: "image/jpeg")
//                multipartFormData.append(imgs[1]["img2Data"] as! Data, withName: "aadhar_doc", fileName:"image2.jpg", mimeType: "image/jpeg")
//                multipartFormData.append(imgs[2]["img3Data"] as! Data, withName: "visiting_doc", fileName:"image3.jpg", mimeType: "image/jpeg")
//                multipartFormData.append(imgs[3]["img4Data"] as! Data, withName: "pan_doc", fileName:"image4.jpg", mimeType: "image/jpeg")
//
//
//                    multipartFormData.append((pan).data(using: String.Encoding.utf8)!, withName: "pan_no")
//                    multipartFormData.append((gst).data(using: String.Encoding.utf8)!, withName: "gst_no")
//                    multipartFormData.append((adhar).data(using: String.Encoding.utf8)!, withName: "aadhar")
//                    multipartFormData.append((mobile).data(using: String.Encoding.utf8)!, withName: "mobile_no")
//                  },
//
//                  to: Apis.docUpload,
//                  method: HTTPMethod(rawValue: "POST"),
//                  headers: header.headers,
//
//
//                  encodingCompletion: { encodingResult in
//                  switch encodingResult {
//                  case .success(let upload, _, _):
//                      upload.responseJSON { response in
//                        print(response)
//                          let resData = response.value as! [String:Any]
//                          let status = resData["status"] as! Int
//                          let force_update = resData["force_update"] as! Int
//                          if force_update == 0 {
//                              if status == 1 {
//                                  completion("success")
//                              } else {
//
//                              }
//                          } else {
//
//                          }
//
//
//                  }
//                  case .failure(let encodingError):
//                      completion("failure\(encodingError.localizedDescription)")
//                  }
//              }
//          )
      }
    
    func uploaDoc(gst:String,pan:String,mobile:String,adhar:String,imgs:[[String:Any]],vc:UIViewController,completion:@escaping (String) -> Void) {
       
        if Reachability.isConnectedToNetwork() == false {
            vc.showAlert(titlee: "Message", message: "No Internet Connection")
        }
        
            let parameters: Parameters = [
                "gst_no":gst,
                "pan_no":pan,
                "aadhar":"adhar",
                "mobile_no":Mobile.getMobile()
            ]
            // You can change your image name here, i use NSURL image and convert into string
            
            let fileName = UUID().uuidString
            // Start AF
        AF.upload(multipartFormData: { multipartFormData in
            for (key,value) in parameters {
                    multipartFormData.append((value as! String).data(using: .utf8)!, withName: key)
                }
            //    multipartFormData.append(imgs[0]["img1Data"] as! Data, withName: "aadhar", fileName: fileName,mimeType: "image/jpeg")
                multipartFormData.append(imgs[1]["img2Data"] as! Data, withName: "aadhar_back", fileName: fileName,mimeType: "image/jpeg")
                multipartFormData.append(imgs[2]["img3Data"] as! Data, withName: "gst_back", fileName: fileName,mimeType: "image/jpeg")
                multipartFormData.append(imgs[3]["img4Data"] as! Data, withName: "visiting_back", fileName: fileName,mimeType: "image/jpeg")
                
                multipartFormData.append(imgs[0]["img1Data"] as! Data, withName: "aadhar_front", fileName: fileName,mimeType: "image/jpeg")
                multipartFormData.append(imgs[1]["img2Data"] as! Data, withName: "gst_doc", fileName: fileName,mimeType: "image/jpeg")
                multipartFormData.append(imgs[2]["img3Data"] as! Data, withName: "pan_doc", fileName: fileName,mimeType: "image/jpeg")
                multipartFormData.append(imgs[3]["img4Data"] as! Data, withName: "visiting_doc", fileName: fileName,mimeType: "image/jpeg")
                print(multipartFormData.contentType)
        }, to: Apis.docUpload,method: .post, headers: header.headers)
            .responseJSON { response in
                if response.response?.statusCode == 200 {
                    completion("success")
                } else {
                    completion("failure")
                }
            }
//            AF.upload(multipartFormData: { multipartFormData in
//                for (key,value) in parameters {
//                    multipartFormData.append((value as! String).data(using: .utf8)!, withName: key)
//                }
//            //    multipartFormData.append(imgs[0]["img1Data"] as! Data, withName: "aadhar", fileName: fileName,mimeType: "image/jpeg")
//                multipartFormData.append(imgs[1]["img2Data"] as! Data, withName: "aadhar_back", fileName: fileName,mimeType: "image/jpeg")
//                multipartFormData.append(imgs[2]["img3Data"] as! Data, withName: "gst_back", fileName: fileName,mimeType: "image/jpeg")
//                multipartFormData.append(imgs[3]["img4Data"] as! Data, withName: "visiting_back", fileName: fileName,mimeType: "image/jpeg")
//
//                multipartFormData.append(imgs[0]["img1Data"] as! Data, withName: "aadhar_front", fileName: fileName,mimeType: "image/jpeg")
//                multipartFormData.append(imgs[1]["img2Data"] as! Data, withName: "gst_doc", fileName: fileName,mimeType: "image/jpeg")
//                multipartFormData.append(imgs[2]["img3Data"] as! Data, withName: "pan_doc", fileName: fileName,mimeType: "image/jpeg")
//                multipartFormData.append(imgs[3]["img4Data"] as! Data, withName: "visiting_doc", fileName: fileName,mimeType: "image/jpeg")
//                print(multipartFormData.contentType)
//            },
//            usingThreshold: UInt64.init(),
//            to: Apis.docUpload,
//            method: .post,headers: header.headers,
//
//            encodingCompletion: { encodingResult in
//                switch encodingResult {
//                    case .success(let upload, _, _):
//                        upload.responseJSON { (response) in
//                            print(response)
//                            if response.response?.statusCode == 200 {
//                                completion("success")
//                            } else {
//                                completion("failure")
//                            }
//                    }
//                case .failure(let encodingError):
//                    print(encodingError)
//            }
//        })
    }
    /*
     func getAllAddress(vc:UIViewController,completion:@escaping([Address]) -> Void) {
         let authorization:HTTPHeaders =  ["Authorization":Token.getLatestToken()]
         if Reachability.isConnectedToNetwork() == false {
             vc.showAlert(titlee: "Message", message: "No Internet Connection")
         }
         AF.request(NewAPI.addressView,method: .get,parameters: nil,encoding: URLEncoding.default,headers: authorization).responseJSON { (responseData) in
             self.printEveryThing(responseData: responseData, statusCode: responseData.response?.statusCode ?? 000, url: responseData.request?.url?.absoluteString ?? "", para: "")
             if responseData.value != nil {
                 if responseData.response?.statusCode == 200 {
                     let data = responseData.value as! [String:Any]
                     let data1 = data["data"] as! [[String:AnyObject]]
                     var allAddr = [Address]()
                     for i in data1 {
                         let id = i["id"] as! Int
                         let uid = i["uid"] as? String
                         let first = i["first"] as? String
                         let last = i["last"] as? String
                         let country = i["country"] as? String
                         let address = i["address"] as? String
                         let pincode = i["pincode"] as? String
                         let city = i["city"] as? String
                         let region = i["region"] as? String
                         let mobileno = i["mobileno"] as? String
                         
                         let tempAdd = Address.init(id: id, uid: uid!, first: first!, last: last!, country: country!, address: address!, pincode: pincode!, city: city!, region: region!, mobileno: mobileno!)
                         allAddr.append(tempAdd)
                     }
                     completion(allAddr)
                 }
             }
         }
     }
     */
    
    func filterMenu(vc:UIViewController, categoryID: Int, subCategoryID: Int ,completion:@escaping ([ProductFilters]) -> Void) {
        if Reachability.isConnectedToNetwork() == false {
            vc.showAlert(titlee: "Message", message: "No Internet Connection")
        }
        let authorization:HTTPHeaders =  ["Authorization":Token.getLatestToken()]
        let apiUrl = NewAPI.productsFilter + "/\(categoryID)" + "/\(subCategoryID)"
        AF.request(apiUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: authorization).responseJSON { (responseData) in
            if responseData.value != nil {
                if responseData.response?.statusCode == 200 {
                    var filters = [ProductFilters]()
                    let data = responseData.value as! [String:Any]
                    print(data)
                    if let menu = data["menu"] as? NSDictionary {
                        //.compactMap { String(describing: $0) }
                        if let keys = menu.allKeys as? [String] {
                            for key in keys {
                                if key.lowercased() == "price" {
                                    continue
                                }
                                var name = ""
                                if key.contains("_") {
                                    name = key.replacingOccurrences(of: "_", with: " ").capitalized
                                } else if key.lowercased().contains("purity") {
                                    name = "Gold \(key.capitalized)"
                                } else if key.lowercased().contains("color") || key.lowercased().contains("clarity") {
                                    name = "Diamond \(key.capitalized)"
                                } else {
                                    name = key.capitalized
                                }
                                
                                var properties = [FilterProperties]()
                                if key.lowercased().contains("weight") {
                                    let item = menu[key] as? [String: String]
                                    let min = item?["min"] ?? "0"
                                    let max = item?["max"] ?? "0"
                                    let property = FilterProperties(title: "", isSelected: false, min: (min as NSString).floatValue, max: (max as NSString).floatValue, selectedMin: (min as NSString).floatValue, selectedMax: (max as NSString).floatValue, isWeightFilter: true)
                                    properties.append(property)
                                } else {
                                    if let filterData = menu[key] as? [String] {
                                        for item in filterData {
                                            let property = FilterProperties(title: item, isSelected: false, min: 0, max: 0, selectedMin: 0, selectedMax: 0, isWeightFilter: false)
                                            properties.append(property)
                                        }
                                    }
                                }
                                let productFilter = ProductFilters(name: name, filterName: key, isSelected: false, properties: properties)
                                if productFilter.name.lowercased().contains("weight") {
                                    filters.insert(productFilter, at: 0)
                                } else {
                                    filters.append(productFilter)
                                }
                                
                            }
                        }
                    }
                    completion(filters)
                }
            }
        }
    }
    func filterData(para:[String:Any], subcategoryId: Int, page: Int,vc:UIViewController,completion:@escaping ([Product],Int) -> Void) {
        if Reachability.isConnectedToNetwork() == false {
            vc.showAlert(titlee: "Message", message: "No Internet Connection")
        }
        let authorization:HTTPHeaders = ["Authorization":Token.getLatestToken()]
        let apiUrl = NewAPI.productList + "?subsubcategory_id=\(subcategoryId)&page=\(page)"
        AF.request(apiUrl, method: .post, parameters: para, encoding: JSONEncoding.default, headers: header.headers).responseJSON { (responseData) in
            print(responseData.value)
            print(para)
            if responseData.value != nil {
                
                let resData = responseData.value as! [String:Any]
                
                if let productData = resData["data"] as? [[String:AnyObject]] {
                    let totalproduct = resData["pagination"] as? Int
                    var allProduct = [Product]()
                    
                    for i in productData {
                        
                        var goldd = [Gold]()
                        var diamondd = [Diamond]()
                        var stonee = [Stone]()
                        var platinumm = [Platinum]()
                        var silverr = [Silver]()
                        
                        let pid = i["product_id"] as! Int
                        let pname = i["product_name"] as? String
                        let size = i["size_type"] as? String
                        let defaultSize = i["default_size"] as? String
                        let sizeType = i["size_type"] as? String
                        let img = i["image"] as? String
                        let weight = i["weight"] as? String
                        let quality = i["quality"] as? String
                        
                        if let gold = i["gold"] as? [String:Any] {
                            let goldweight = gold["goldweight"] as! String
                            let goldquality = gold["goldquality"] as! String
                            let makingcharge = gold["makingcharge"] as! String
                            let option = gold["option"] as! String
                            
                            let tempGold = Gold.init(goldweight: goldweight, goldquality: goldquality, makingcharge: makingcharge, option: option)
                            goldd.append(tempGold)
                        }
                        
                        if let diamong = i["diamond"] as? [String:Any] {
                            let diamond = diamong["diamond"] as! String
                            let diamondqty = diamong["diamondqty"] as! String
                            let default_size = diamong["default_size"] as! String
                            let type = diamong["type"] as! String
                            let diamondcharge = diamong["diamondcharge"] as! String
                            
                            let tempdiamond = Diamond.init(diamond: diamond, diamondqty: diamondqty, no_diamond: "", default_size: default_size, diamondcolor: "", diamondclarity: "", type: type, diamondcharge: diamondcharge)
                            diamondd.append(tempdiamond)
                        }
                        
                        if let stone = i["stone"] as? [String:Any] {
                            let stone_id = stone["stone_id"] as? Int
                            let id = stone["id"] as! Int
                            let product_id = stone["product_id"] as! String
                            let stonetype = stone["stonetype"] as! String
                            let stoneqty = stone["stoneqty"] as! String
                            let stoneno = stone["stoneno"] as! String
                            let type = stone["type"] as! String
                            let stonecharges = stone["stonecharges"] as! String
                            let created_at = stone["created_at"] as! String
                            let updated_at = stone["updated_at"] as! String
                            
                            let tempRes = Stone.init(stoneID: stone_id ?? 0, id: id, productID: product_id, stonetype: stonetype, stoneqty: stoneqty, stoneno: stoneno, type: type, stonecharges: stonecharges, createdAt: created_at, updatedAt: updated_at)
                            
                            stonee.append(tempRes)
                            
                        }
                        
                        if let platinum = i["productpaltinum"] as? [String:Any] {
                            let id = platinum["id"] as! Int
                             let product_id = platinum["product_id"] as! String
                             let platinum_type = platinum["platinum_type"] as! String
                             let platinum_qty = platinum["platinum_qty"] as! String
                             let wastage = platinum["wastage"] as? String
                             let purity = platinum["purity"] as? String
                             let charge_type = platinum["charge_type"] as! String
                             let platinum_charge = platinum["platinum_charge"] as! String
                            
                                 
                            let tempsRes = Platinum.init(id: id, productID: product_id, platinumType: platinum_type, platinumQty: platinum_qty, wastage: wastage ?? "0", purity: purity ?? "0", chargeType: charge_type, platinumCharge: platinum_charge)
                            platinumm.append(tempsRes)
                        }
                        if let silver = i["productsilver"] as? [String:Any] {
                            let id = silver["id"] as! Int
                            let product_id = silver["product_id"] as! String
                            let silver_type = silver["silver_type"] as! String
                            let silverqty = silver["silverqty"] as! String
                            let silverno = silver["silverno"] as! String
                            let charge_type = silver["charge_type"] as! String
                            let silvercharges = silver["silvercharges"] as! String
                            
                           
                            let tempRes = Silver.init(id: id, productID: product_id, silverType: silver_type, silverqty: silverqty, silverno: silverno, chargeType: charge_type, silvercharges: silvercharges)
                            
                            silverr.append(tempRes)
                        }
                        let proWeight = i["weight"] as! [String:Any]
                        let proQuality = i["quality"] as! [String:Any]
                        let product_category = i["product_category"] as? String ?? ""
                        
                        let tempPro = Product.init(imgs: img ?? "", name: pname ?? "", price: "", discountPrice: "", size: size ?? "", gold: goldd, diamond: diamondd, platinum: platinumm, stone: stonee, details: "", id: pid, silver: silverr,weight: weight ?? "",quality: quality ?? "",proWeight: proWeight,proQuality: proQuality, product_category: product_category)
                        
                        allProduct.append(tempPro)
                    }
                    completion(allProduct, totalproduct ?? 10)
                } else {
                    let totalproduct = 0
                    let allProduct = [Product]()
                    completion(allProduct, totalproduct)
                }
            } else {
                let totalproduct = 0
                let allProduct = [Product]()
                completion(allProduct, totalproduct)
            }
        }
    }
    
    func sendEnquiry(pid:String,vc:UIViewController,completion:@escaping (String) -> Void) {
        let para = ["product_id":pid,"user_id":Mobile.getUid()]
        if Reachability.isConnectedToNetwork() == false {
            vc.showAlert(titlee: "Message", message: "No Internet Connection")
        }
        AF.request(Apis.enquiry, method: .post, parameters: para, encoding: JSONEncoding.default, headers: header.headers).responseJSON { (responseData) in
            if responseData.value != nil {
                if responseData.response?.statusCode == 200 {
                    completion("success")
                }
            }
        }
    }
    
    func getAllCategory(manufacture_id:String,vc:UIViewController,completion:@escaping ([CategoryNew]) -> Void) {
        let para = ["manufacture_id":manufacture_id]
        print(para)
        if Reachability.isConnectedToNetwork() == false {
            vc.showAlert(titlee: "Message", message: "No Internet Connection")
        }
        let authorization:HTTPHeaders = ["Authorization":Token.getLatestToken()]
        AF.request(NewAPI.category, method: .post, parameters: para, encoding: URLEncoding.default, headers: authorization).responseJSON { (responseData) in
            self.printEveryThing(responseData: responseData, statusCode: responseData.response?.statusCode ?? 000, url: NewAPI.category, para: para)
            var allCata = [CategoryNew]()
            if responseData.value != nil {
                if responseData.response?.statusCode == 200 {
                    let data = responseData.value as! [String:Any]
                    if let resData = data["data"] as? [[String:Any]] {
                        for i in resData {
                            let id = i["id"] as! Int
                            let category = i["category"] as? String ?? ""
                            let description = i["description"] as? String ?? ""
                            let image = i["image"] as? String ?? ""
                            let menu_id = i["menu_id"] as? String ?? ""
                            let status = i["status"] as? String ?? ""
                            let temp = CategoryNew.init(id: id, category: category, categoryDescription: description, image: image, menuID: menu_id, status: status, createdAt: "")
                            if status == "1" {
                                allCata.append(temp)
                            }
                        }
                        completion(allCata)
                    }
                    completion(allCata)
                }
            }
        }
    }
    
    func getAllBanners(user_id:String,type:String,vc:UIViewController,completion: @escaping ([Banner]) -> Void) {
        var para = [String:Any]()
        if type == "4" {
            para = ["category_id":user_id,"type":type]
        }else if type == "5" {
            para = ["subcategory_id":user_id,"type":type]
        }else {
            para = ["user_id":user_id,"type":type]
        }
        
        
        if Reachability.isConnectedToNetwork() == false {
            vc.showAlert(titlee: "Message", message: "No Internet Connection")
        }
        let authorization:HTTPHeaders = ["Authorization":Token.getLatestToken()]
        AF.request(NewAPI.banner, method: .post, parameters: para, encoding: URLEncoding.default, headers: authorization).responseJSON { (responseData) in
            if responseData.value != nil {
                if responseData.response?.statusCode == 200 {
                    var allBanner = [Banner]()
                    let data = responseData.value as! [String:Any]
                    let url = data["url"] as! String
                    let resData = data["data"] as! [[String:Any]]
                    for i in resData {
                        if (i["place"] as? String ?? "").lowercased() == "website" {
                            continue
                        }
                        let id = i["id"] as! Int
                        let user_id = i["user_id"] as? String ?? ""
                        let title = i["title"] as? String ?? ""
                        let type = i["type"] as? String ?? ""
                        let place = i["place"] as? String ?? ""
                        let start_date = i["start_date"] as? String ?? ""
                        let end_date = i["end_date"] as? String ?? ""
                        let category_id = i["category_id"] as? String ?? ""
                        let subcategory_id = i["subcategory_id"] as? String ?? ""
                        let subsubcategory_id = i["subsubcategory_id"] as? String ?? ""
                        let image = i["image"] as? String ?? ""
                        let status = i["status"] as? String ?? ""
                        
                        let temp = Banner.init(id: id, userID: user_id, title: title, type: type, place: place, startDate: start_date, endDate: end_date, categoryID: category_id, subcategoryID: subcategory_id, subsubcategoryID: subsubcategory_id, image: (url + "/img/banner/" + image).replacingOccurrences(of: " ", with: "%20"), status: status, createdAt: "", updatedAt: "")
                        
                        allBanner.append(temp)
                    }
                    completion(allBanner)
                }
            }
        }
    }
    
    func getAllState(vc:UIViewController,completion:@escaping ([StateBullian],[BullianCity]) -> Void) {
        let authorization:HTTPHeaders = ["Authorization":Token.getLatestToken()]
        if Reachability.isConnectedToNetwork() == false {
            vc.showAlert(titlee: "Message", message: "No Internet Connection")
        }
        AF.request(NewAPI.bulianState, method: .get, parameters: nil, encoding: URLEncoding.default, headers: authorization).responseJSON { (responseData) in
            self.printEveryThing(responseData: responseData, statusCode: responseData.response?.statusCode ?? 000, url: responseData.request?.url?.absoluteString ?? "", para: "")
            if responseData.value != nil {
                if responseData.response?.statusCode == 200 {
                    var allState = [StateBullian]()
                    var allCity = [BullianCity]()
                    let data = responseData.value as! [String:Any]
                    let url = data["url"] as! String
                    let resData = data["other"] as! [[String:Any]]
                    if let cities = data["city"] as? [[String:Any]] {
                        for i in cities {
                            let id = i["id"] as! Int
                            let city = i["city"] as? String ?? ""
                            let state_id = i["state_id"] as? Int ?? 0
                            let metropolitan = i["metropolitan"] as? String ?? ""
                            let image = i["image"] as? String ?? ""
                            let status = i["status"] as? Int ?? 0
                            let temp = BullianCity.init(id: id, city: city, stateID: state_id, metropolitan: metropolitan, image: url + "/img/city/" + image, status: status, createdAt: "", updatedAt: "")
                            allCity.append(temp)
                        }
                    }
                    for i in resData {
                        let id = i["id"] as! Int
                        let name = i["name"] as? String ?? ""
                        let status = i["status"] as? Int ?? 0
                        let temp = StateBullian.init(id: id, name: name, status: status, createdAt: "", updatedAt: "")
                        allState.append(temp)
                    }
                    completion(allState,allCity)
                }
            }
        }
    }
    
    func getAllBullianCity(cityid:String,vc:UIViewController,completion: @escaping ([BullianCity]) -> Void) {
        let authorization:HTTPHeaders = ["Authorization":Token.getLatestToken()]
        if Reachability.isConnectedToNetwork() == false {
            vc.showAlert(titlee: "Message", message: "No Internet Connection")
        }
        AF.request(NewAPI.bulianCity + cityid, method: .get, parameters: nil, encoding: URLEncoding.default, headers: authorization).responseJSON { (responseData) in
            if responseData.value != nil {
                if responseData.response?.statusCode == 200 {
                    var allCity = [BullianCity]()
                    let data = responseData.value as! [String:Any]
                    let url = data["url"] as! String
                    let resData = data["data"] as! [[String:Any]]
                    for i in resData {
                        let id = i["id"] as! Int
                        let city = i["city"] as? String ?? ""
                        let state_id = i["state_id"] as? Int ?? 0
                        let metropolitan = i["metropolitan"] as? String ?? ""
                        let image = i["image"] as? String ?? ""
                        let status = i["status"] as? Int ?? 0
                        let temp = BullianCity.init(id: id, city: city, stateID: state_id, metropolitan: metropolitan, image: url + "/" + image, status: status, createdAt: "", updatedAt: "")
                        allCity.append(temp)
                     }
                    completion(allCity)
                }
            }
        }
    }
    
    func getBullianList(cityid:String,vc:UIViewController,completion: @escaping ([Bullian]) -> Void) {
        let authorization:HTTPHeaders = ["Authorization":Token.getLatestToken()]
        if Reachability.isConnectedToNetwork() == false {
            vc.showAlert(titlee: "Message", message: "No Internet Connection")
        }
        AF.request(NewAPI.bullianList + cityid, method: .get, parameters: nil, encoding: URLEncoding.default, headers: authorization).responseJSON { (responseData) in
            self.printEveryThing(responseData: responseData, statusCode: responseData.response?.statusCode ?? 000, url: responseData.request?.url?.absoluteString ?? "", para: cityid)
            if responseData.value != nil {
                if responseData.response?.statusCode == 200 {
                    var allBulian = [Bullian]()
                    let data = responseData.value as! [String:Any]
                    let resData = data["data"] as! [[String:Any]]
                    let url = data["url"] as! String
                    for i in resData {
                        let id = i["id"] as? Int ?? 0
                        let state = i["state"] as? String ?? ""
                        let city = i["city"] as? String ?? ""
                        let shop_name = i["shop_name"] as? String ?? ""
                        let name = i["name"] as? String ?? ""
                        let about = i["about"] as? String ?? ""
                        let email = i["email"] as? String ?? ""
                        let mobile = i["mobile"] as? String ?? ""
                        let telephone = i["telephone"] as? String ?? ""
                        let facebook_link = i["facebook_link"] as? String ?? ""
                        let instagram_link = i["instagram_link"] as? String ?? ""
                        let address = i["address"] as? String ?? ""
                        let latitude = i["latitude"] as? String ?? ""
                        let longitude = i["longitude"] as? String ?? ""
                        let cover_image = i["cover_image"] as? String ?? ""
                        let image = i["image"] as? String ?? ""
                        let status = i["status"] as? Int ?? 0
                        
                        let temp = Bullian.init(id: id, state: state, city: city, shopName: shop_name, name: name, about: about, email: email, mobile: mobile, telephone: telephone, facebookLink: facebook_link, instagramLink: instagram_link, address: address, latitude: latitude, longitude: longitude, coverImage: url + "/img/bullian_merchant/" + cover_image, image:url + "/img/bullian_merchant/" + image, status: status, createdAt: "", updatedAt: "")
                        
                        allBulian.append(temp)
                    }
                    completion(allBulian)
                }
            }
        }
    }
    
    func getBullianDetails(cityid:String,vc:UIViewController,completion: @escaping ([Bullian]) -> Void) {
        let authorization:HTTPHeaders = ["Authorization":Token.getLatestToken()]
        if Reachability.isConnectedToNetwork() == false {
            vc.showAlert(titlee: "Message", message: "No Internet Connection")
        }
        AF.request(NewAPI.bullianDetail + cityid, method: .get, parameters: nil, encoding: URLEncoding.default, headers: authorization).responseJSON { (responseData) in
            self.printEveryThing(responseData: responseData, statusCode: responseData.response?.statusCode ?? 000, url: responseData.request?.url?.absoluteString ?? "", para: cityid)
            if responseData.value != nil {
                if responseData.response?.statusCode == 200 {
                    var allBulian = [Bullian]()
                    let data = responseData.value as! [String:Any]
                    let resData = data["data"] as! [[String:Any]]
                    let url = data["url"] as! String
                    for i in resData {
                        let id = i["id"] as? Int ?? 0
                        let state = i["state"] as? String ?? ""
                        let city = i["city"] as? String ?? ""
                        let shop_name = i["shop_name"] as? String ?? ""
                        let name = i["name"] as? String ?? ""
                        let about = i["about"] as? String ?? ""
                        let email = i["email"] as? String ?? ""
                        let mobile = i["mobile"] as? String ?? ""
                        let telephone = i["telephone"] as? String ?? ""
                        let facebook_link = i["facebook_link"] as? String ?? ""
                        let instagram_link = i["instagram_link"] as? String ?? ""
                        let address = i["address"] as? String ?? ""
                        let latitude = i["latitude"] as? String ?? ""
                        let longitude = i["longitude"] as? String ?? ""
                        let cover_image = i["cover_image"] as? String ?? ""
                        let image = i["image"] as? String ?? ""
                        let status = i["status"] as? Int ?? 0
                        
                        let temp = Bullian.init(id: id, state: state, city: city, shopName: shop_name, name: name, about: about, email: email, mobile: mobile, telephone: telephone, facebookLink: facebook_link, instagramLink: instagram_link, address: address, latitude: latitude, longitude: longitude, coverImage: url + "/img/bullian_merchant/" + cover_image.replacingOccurrences(of: " ", with: "%20"), image:url + "/img/bullian_merchant/" + image.replacingOccurrences(of: " ", with: "%20"), status: status, createdAt: "", updatedAt: "")
                        
                        allBulian.append(temp)
                    }
                    completion(allBulian)
                }
            }
        }
    }
    func uniq<S : Sequence, T : Hashable>(source: S) -> [T] where S.Iterator.Element == T {
        var buffer = [T]()
        var added = Set<T>()
        for elem in source {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
    
    func getProduct(vc:UIViewController,product_id:Int,completion:@escaping (ProductDetail) -> Void) {
        let para = ["product_id":product_id]
        if Reachability.isConnectedToNetwork() == false {
            vc.showAlert(titlee: "Message", message: "No Internet Connection")
        }
        let authorization:HTTPHeaders =  ["Authorization":Token.getLatestToken()]
        AF.request(NewAPI.productDetails + product_id.toString(), method: .put, parameters: para, encoding: JSONEncoding.default, headers: authorization).responseJSON { (responseData) in
            self.printEveryThing(responseData: responseData, statusCode: responseData.response?.statusCode ?? 000, url: responseData.request?.url?.absoluteString ?? "", para: product_id)
            if responseData.value != nil {
                if responseData.response?.statusCode == 200 {
                    print(responseData.value)
                    let data = responseData.value as! [String:Any]
                    let url = data["url"] as? String ?? ""
                    let manufacture_url = data["manufacture_url"] as? String ?? ""
                    let statusRaw = data["status"] as? Int ?? 0
                    let product_category = data["product_category"] as? String ?? ""
                    //MARK:- Data Class
                    let resData = data["data"] as! [String:Any]
                    print(resData)
                    let id = resData["id"] as? Int ?? 0
                    let category_id = resData["category_id"] as? String ?? ""
                    let subcategory_id = resData["subcategory_id"] as? String ?? ""
                    let subsubcategory_id = resData["subsubcategory_id"] as? String ?? ""
                    let productCode = resData["productcode"] as? String ?? ""
                    let productname = resData["productname"] as? String ?? ""
                    let gender = resData["gender"] as? String ?? ""
                    let color = resData["color"] as? String ?? ""
                    let jwellery_type = resData["jwellery_type"] as? String ?? ""
                    let default_size = resData["default_size"] as? String ?? ""
                    let size_type = resData["size_type"] as? String ?? ""
                    let description = resData["description"] as? String ?? ""
                    let manufacture_id = resData["manufacture_id"] as? String ?? ""
                    let manufacture_type = resData["manufacture_type"] as? Int ?? 0
                    let certified_id = resData["certified_id"] as? String ?? ""
                    let amount = resData["amount"] as? String ?? ""
                    let image = resData["image"] as? String ?? ""
                    let status = resData["status"] as? Int ?? 0
                    let most_selling_status = resData["most_selling_status"] as? Int ?? 0
                    let created_at = resData["created_at"] as? String ?? ""
                    let updated_at = resData["updated_at"] as? String ?? ""
                    let delivery_time = resData["delivery_time"] as? String ?? ""
                    
                    let dataClass = DataClass.init(id: id, categoryID: category_id, subcategoryID: subcategory_id, subsubcategoryID: subsubcategory_id, productcode: productCode, productname: productname, gender: gender, color: color, jwelleryType: jwellery_type, defaultSize: default_size, sizeType: size_type, dataDescription: description, manufactureID: manufacture_id,manufactureType: manufacture_type, certifiedID: certified_id, amount: amount, image: image, status: status, mostSellingStatus: most_selling_status, createdAt: created_at, updatedAt: updated_at, delivery_time: delivery_time)
                    
                    
                    //MARK:- Certification
                    let certiArr = data["Certification"] as! [[String:Any]]
                    var certificates = [pdCertification]()
                    for i in certiArr {
                        let id = i["id"] as? Int ?? 0
                        let certi_name = i["certi_name"] as? String ?? ""
                        let image = i["image"] as? String ?? ""
                        let created_at = i["created_at"] as? String ?? ""
                        let updated_at = i["updated_at"] as? String ?? ""
                        certificates.append(pdCertification.init(id: id, certiName: certi_name, image: MainURL.mainurl + "/img/certificate/" + image, createdAt: created_at, updatedAt: updated_at))
                        
                    }
                    
                    //MARK:- Recent Products
                    let recentsArr = data["recent_product"] as! [[String:Any]]
                    var recents = [RecentProduct]()
                    for i in recentsArr {
                        let product_id = i["product_id"] as? Int ?? 0
                        let product_name = i["product_name"] as? String ?? ""
                        let product_category = i["product_category"] as? String ?? ""
                        let product_code = i["productcode"] as? String ?? ""
                        let amount = i["amount"] as? String ?? ""
                        let image = i["image"] as? String ?? ""
                        
                        let quality = i["quality"] as? [String:Any]
                        let weight = i["weight"] as? [String:Any]
                      
                        
                        recents.append(RecentProduct.init(productID: product_id, productName: product_name, productcode: product_code, amount: amount, image: image, quality: quality!, weight: weight!,product_category:product_category))
                    }
                    
                    //MARK:- Manufacturer
                    let manufacArr = data["manufacture"] as! [String:Any]
                    let company_name = manufacArr["company_name"] as? String ?? ""
                    let manufacture_idNew = manufacArr["manufacture_id"] as? Int ?? 0
                    let logo = manufacArr["logo"] as? String ?? ""
                    let manuObj = Manufacture.init(companyName: company_name, manufactureID: manufacture_idNew, logo: manufacture_url + "/" + logo)
                    
                    //MARK:- Assets
                    let assetArr = data["assets"] as! [[String:Any]]
                    var assets = [pdAsset]()
                    for i in assetArr {
                        
                        
                        
                        let id = i["id"] as? Int ?? 0
                        
                        let metrial_type =  String(format: "%@", (i["metrial_type"]) as! CVarArg)
                        let product_idA =  String(format: "%@", (i["product_id"]) as! CVarArg)
                        let jwellery_size =  String(format: "%@", (i["jwellery_size"]) as! CVarArg)
                        let diamond_index =  String(format: "%@", (i["diamond_index"]) as! CVarArg)
                        let stone_index =  String(format: "%@", (i["stone_index"]) as! CVarArg)
                        let multi_weight =  String(format: "%@", (i["multi_weight"]) as! CVarArg)
                        let purity =  String(format: "%@", (i["purity"]) as! CVarArg)
                        let weight =  String(format: "%@", (i["weight"]) as! CVarArg)
                        let wastage =  String(format: "%@", (i["wastage"]) as? CVarArg ?? "")
                        let quantity =  String(format: "%@", (i["quantity"]) as! CVarArg)
                        //let color =  String(format: "%@", (i["color"]) as! CVarArg)
                        
                        let color = i["color"] as? String ?? ""
                        let clarity = i["clarity"] as? String ?? ""
                        let default_color_clarity = i["default_color_clarity"] as? String ?? ""
                        //let clarity =  String(format: "%@", (i["clarity"]) as! CVarArg)
                                           //    let default_color_clarity =  String(format: "%@", (i["default_color_clarity"]) as! CVarArg)
                                               let making_charge =  String(format: "%@", (i["making_charge"]) as! CVarArg)
                                             //  let charges_option =  String(format: "%@", (i["charges_option"]) as! CVarArg)
                                               
                        
//                        let crtcost_option =  String(format: "%@", (i["crtcost_option"]) as! CVarArg)
//                        let certification_cost =  String(format: "%@", (i["certification_cost"]) as! CVarArg)
//                        let meenacost_option =  String(format: "%@", (i["meenacost_option"]) as! CVarArg)
//                        let meena_cost =  String(format: "%@", (i["meena_cost"]) as! CVarArg)
//
//                        let created_at =  String(format: "%@", (i["created_at"]) as! CVarArg)
//                                               let updated_at =  String(format: "%@", (i["updated_at"]) as! CVarArg)
                        
//                        let metrial_type = i["metrial_type"] as? String ?? ""
//                        let product_idA = i["product_id"] as? String ?? ""
//                        let jwellery_size = i["jwellery_size"] as? String ?? ""
//                        let diamond_index = i["diamond_index"] as? String ?? ""
//                        let stone_index = i["stone_index"] as? String ?? ""
//                        let multi_weight = i["multi_weight"] as? String ?? ""
//                        let purity = i["purity"] as? String ?? ""
//                        let weight = i["weight"] as? Double ?? 0.0
//                        let wastage = i["wastage"] as? String ?? "0"
//                        let quantity = i["quantity"] as? String ?? ""
//                        let color = i["color"] as? String ?? ""
//                        let clarity = i["clarity"] as? String ?? ""
//                        let default_color_clarity = i["default_color_clarity"] as? String ?? ""
//                        let making_charge = i["making_charge"] as? Double ?? 0.0
                        let charges_option = i["charges_option"] as? String ?? ""
                        let crtcost_option = i["crtcost_option"] as? String ?? ""
                        let certification_cost = i["certification_cost"] as? String ?? ""
                        let meenacost_option = i["meenacost_option"] as? String ?? ""
                        let meena_cost = i["meena_cost"] as? String ?? ""
                        let created_at = i["created_at"] as? String ?? ""
                        let updated_at = i["updated_at"] as? String ?? ""

                        assets.append(pdAsset.init(id: id, metrialType: metrial_type, productID: product_idA, jwellerySize: jwellery_size, diamondIndex: diamond_index, stoneIndex: stone_index, multiWeight: multi_weight, purity: purity, weight: "\(weight)", wastage: "\(wastage)", quantity: quantity, color: color, clarity: clarity, defaultColorClarity: default_color_clarity, makingCharge: "\(making_charge)", chargesOption: charges_option, crtcostOption: crtcost_option, certificationCost: certification_cost, meenacostOption: meenacost_option, meenaCost: meena_cost, createdAt: created_at, updatedAt: updated_at))
                    }
                    
                    //MARK:- Files
                    let filesArr = data["files"] as! [[String:Any]]
                    var files = [Files]()
                    for i in filesArr {
                        let id = i["id"] as? Int ?? 0
                        let product_id = i["product_id"] as? String ?? ""
                        let image = i["image"] as? String ?? ""
                        let type = i["type"] as? Int ?? 0
                        let created_at = i["created_at"] as? String ?? ""
                        let updated_at = i["updated_at"] as? String ?? ""
                        let thumbnail = i["thumbnail"] as? String ?? ""
                        
                        files.append(Files.init(id: id, productID: product_id, image:(url + "/" + image).replacingOccurrences(of: " ", with: "%20"), type: type, createdAt: created_at, updatedAt: updated_at, thumbnail: (url + "/" + thumbnail).replacingOccurrences(of: " ", with: "%20")))
                    }
                    
                    //, thumbnail: <#String#>MARK:- Price
                    let priceArr = data["price"] as! [String:Any]
                    //MARK:- Silver Price
                    let silverPricArr = priceArr["silver"] as! [[String:Any]]
                    var silverPrice = [pdDiamondMaster]()
                    for i in silverPricArr {
                        let id = i["id"] as? Int ?? 0
                        let metrial_type = i["metrial_type"] as? String ?? ""
                        let user_id = i["user_id"] as? String ?? ""
                        let type = i["type"] as? String ?? ""
                        let price = i["price"] as? String ?? ""
                        let value_in = i["value_in"] as? String ?? ""
                        let diamond_type = i["diamond_type"] as? String ?? ""
                        let created_at = i["created_at"] as? String ?? ""
                        let updated_at = i["updated_at"] as? String ?? ""
                        
                        silverPrice.append(pdDiamondMaster.init(id: id, metrialType: metrial_type, userID: user_id, type: type, price: price, valueIn: value_in, createdAt: created_at, updatedAt: updated_at,diamond_type:diamond_type))
                    }
                    
                    
                    //MARK:- Stone Price
                    let stonePricArr = priceArr["stone"] as! [[String:Any]]
                    var stonePrice = [pdDiamondMaster]()
                    for i in stonePricArr {
                        let id = i["id"] as? Int ?? 0
                        let metrial_type = i["metrial_type"] as? String ?? ""
                        let user_id = i["user_id"] as? String ?? ""
                        let type = i["type"] as? String ?? ""
                        let price = i["price"] as? String ?? ""
                        let value_in = i["value_in"] as? String ?? ""
                        let diamond_type = i["diamond_type"] as? String ?? ""
                        let created_at = i["created_at"] as? String ?? ""
                        let updated_at = i["updated_at"] as? String ?? ""
                        
                        stonePrice.append(pdDiamondMaster.init(id: id, metrialType: metrial_type, userID: user_id, type: type, price: price, valueIn: value_in, createdAt: created_at, updatedAt: updated_at,diamond_type:diamond_type))
                    }
                    var  ringSizeArr = [[String:Any]]()
                    var ringsize = [Ring]()
                    
                  
                   
                    
                    //MARK:- Ring
                    if  priceArr["ring"] != nil {
                         ringSizeArr = priceArr["ring"] as! [[String:Any]]
                        
                        for i in ringSizeArr {
                            let sizes = i["sizes"] as? String ?? ""
                            if size_type.contains(sizes) {
                                ringsize.append(Ring.init(sizes: sizes))
                            }
                        }
                    }else {
                        let vals = size_type.components(separatedBy: ",")
                        
    
                        let  arr = self.uniq(source: vals)
                        
                        for i in arr {
                            let sizes = i as? String ?? ""
                            if size_type.contains(sizes) {
                                ringsize.append(Ring.init(sizes: sizes))
                            }
                        }
                    }
                    
                    
                   
                    
                    //MARK:- Bangles
                    let bangleArr = priceArr["bangle"] as! [[String:Any]]
                    var bangles = [Bangle]()
                    for i in bangleArr {
                        let id = i["id"] as? Int ?? 0
                        let jwellery_type = i["jwellery_type"] as? String ?? ""
                        let sizes = i["sizes"] as? String ?? ""
                        let bangle_size = i["bangle_size"] as? String ?? ""
                        let created_at = i["created_at"] as? String ?? ""
                        if size_type.contains(sizes) {
                            bangles.append(Bangle.init(id: id, jwelleryType: jwellery_type, sizes: sizes, bangleSize: bangle_size, createdAt: created_at))
                        }
                        
                    }
                    bangles = bangles.sorted(by: { $0.sizes < $1.sizes })
                    
                    //MARK:- Chain Size
                    
                    var chainArr = [[String:Any]]()
                    var chain = [Chain]()
                    if priceArr["chain"] != nil {
                        let chainArr = priceArr["chain"] as! [[String:Any]]
                        
                        for i in chainArr {
                            let id = i["id"] as? Int ?? 0
                            let jwellery_type = i["jwellery_type"] as? String ?? ""
                            let sizes = i["sizes"] as? String ?? ""
                            let bangle_size = i["bangle_size"] as? String ?? ""
                            let created_at = i["created_at"] as? String ?? ""
                            if size_type.contains(sizes) {
                                chain.append(Chain.init(id: id, jwelleryType: jwellery_type, sizes: sizes, bangleSize: bangle_size, createdAt: created_at))
                            }
                            
                        }
                    }else {
                        let vals = size_type.components(separatedBy: ",")
                        
    
                        let  arr = self.uniq(source: vals)
                        ringsize.removeAll()
                        for i in arr {
                            let sizes = i as? String ?? ""
                            if size_type.contains(sizes) {
                                ringsize.append(Ring.init(sizes: sizes))
                            }
                        }
                    }
                    
                  
                    //bangles = bangles.sorted(by: { $0.sizes < $1.sizes })
                    
                    //MARK:- Platinum Price
                    let platinumPricArr = priceArr["platinum"] as! [[String:Any]]
                    var platinumPrice = [pdDiamondMaster]()
                    for i in platinumPricArr {
                        let id = i["id"] as? Int ?? 0
                        let metrial_type = i["metrial_type"] as? String ?? ""
                        let user_id = i["user_id"] as? String ?? ""
                        let type = i["type"] as? String ?? ""
                        let price = i["price"] as? String ?? ""
                        let value_in = i["value_in"] as? String ?? ""
                        let diamond_type = i["diamond_type"] as? String ?? ""
                        let created_at = i["created_at"] as? String ?? ""
                        let updated_at = i["updated_at"] as? String ?? ""
                        
                        platinumPrice.append(pdDiamondMaster.init(id: id, metrialType: metrial_type, userID: user_id, type: type, price: price, valueIn: value_in, createdAt: created_at, updatedAt: updated_at,diamond_type:diamond_type))
                    }
                    
                    //MARK:- Gold Price
                    let goldPricArr = priceArr["gold"] as! [[String:Any]]
                    var goldPrice = [pdDiamondMaster]()
                    for i in goldPricArr {
                        let id = i["id"] as? Int ?? 0
                        let metrial_type = i["metrial_type"] as? String ?? ""
                        let user_id = i["user_id"] as? String ?? ""
                        let type = i["type"] as? String ?? ""
                        let price = String(format: "%@", (i["price"]) as! CVarArg)
                        let value_in = i["value_in"] as? String ?? ""
                        let diamond_type = i["diamond_type"] as? String ?? ""
                        let created_at = i["created_at"] as? String ?? ""
                        let updated_at = i["updated_at"] as? String ?? ""
                        
                        goldPrice.append(pdDiamondMaster.init(id: id, metrialType: metrial_type, userID: user_id, type: type, price: "\(price)", valueIn: value_in, createdAt: created_at, updatedAt: updated_at,diamond_type:diamond_type))
                    }
                    
                    //MARK:- Jwellery Type
                    var jwelleryType = [JwelleryType]()
                    if priceArr["jwellery_type"] != nil {
                        let jwelleryTypeArr = priceArr["jwellery_type"] as! [[String:Any]]
                        
                        for i in jwelleryTypeArr {
                            let id = i["id"] as? Int ?? 0
                            let jwellery_name = i["jwellery_name"] as? String ?? ""
                            
                            jwelleryType.append(JwelleryType.init(id: id, jwelleryName: jwellery_name))
                        }
                    }
                    
                    
                    var diamondcolor = [Diamondc]()
                    if priceArr["diamondcolor"] != nil {
                        let diamondColorArr = priceArr["diamondcolor"] as! [[String:Any]]
                       
                        for i in diamondColorArr {
                            let id = i["id"] as? Int ?? 0
                            let type = i["type"] as? String ?? ""
                            let color_or_clarity = i["color_or_clarity"] as? String ?? ""
                            
                            diamondcolor.append(Diamondc.init(id: id, type: type, colorOrClarity: color_or_clarity))
                        }
                    }
                    //MARK:- Diamond Color
                   
                    
                    //MARK:- Diamond Clarity
                    var diamondclarity = [Diamondc]()
                    
                    if priceArr["diamondclarity"] != nil {
                        let diamondclarityArr = priceArr["diamondclarity"] as! [[String:Any]]
                        
                        for i in diamondclarityArr {
                            let id = i["id"] as? Int ?? 0
                            let type = i["type"] as? String ?? ""
                            let color_or_clarity = i["color_or_clarity"] as? String ?? ""
                            
                            diamondclarity.append(Diamondc.init(id: id, type: type, colorOrClarity: color_or_clarity))
                        }
                    }
                    
                    
                    var diamond_master = [pdDiamondMaster]()
                    
                    if priceArr["diamond_master"] != nil {
                        let diamond_masterArr = priceArr["diamond_master"] as! [[String:Any]]
                        
                        for i in diamond_masterArr {
                            let id = i["id"] as? Int ?? 0
                            let metrial_type = i["metrial_type"] as? String ?? ""
                            let user_id = i["user_id"] as? String ?? ""
                            let type = i["type"] as? String ?? ""
                            let price = i["price"] as? String ?? ""
                            let value_in = i["value_in"] as? String ?? ""
                            let diamond_type = i["diamond_type"] as? String ?? ""
                            let created_at = i["created_at"] as? String ?? ""
                            let updated_at = i["updated_at"] as? String ?? ""
                            
                            diamond_master.append(pdDiamondMaster.init(id: id, metrialType: metrial_type, userID: user_id, type: type, price: price, valueIn: value_in, createdAt: created_at, updatedAt: updated_at,diamond_type:diamond_type))
                        }
                    }
                    
                    //MARK:- Diamond Master
                   
                    
                    
                    
                    let price = Price.init(silver: silverPrice, stone: stonePrice, ring: ringsize, chain: chain, bangle: bangles, platinum: platinumPrice, gold: goldPrice, jwelleryType: jwelleryType, diamondcolor: diamondcolor, diamondclarity: diamondclarity, diamondMaster: diamond_master)
                    
                    
                    
                    //MARK:- Final Product
                    let proDetail = ProductDetail.init(data: dataClass, certification: certificates, recentProduct: recents, manufacture: manuObj, assets: assets, files: files, price: price, url: url, manufactureURL: manufacture_url, status: statusRaw,product_category:product_category)
                    
                    completion(proDetail)
                }
            }
        }
    }
    
    func editProfile(image:Data,name:String,completion:@escaping (String) -> Void) {
         let authorization:HTTPHeaders =  ["Authorization":Token.getLatestToken()]
                      
               let fileName = UUID().uuidString
               AF.upload(multipartFormData: { multipartFormData in
                   
                   multipartFormData.append(image, withName: "image", fileName: fileName + ".jpg",mimeType: "image/jpeg")
                   
                   multipartFormData.append(name.data(using: .utf8)!, withName: "name")
                   print(multipartFormData.contentType)
               }, to: NewAPI.editprofile,method: .post,headers: authorization)
                   .responseJSON { response in
                       print(response)
                       print(response.response?.statusCode)
                       if response.response?.statusCode == 200 {
                           completion("success")
                       } else {
                           completion("failure")
                       }
                   }
    }
    
    func getMachineList(subcata:String, isFromManufacturer: Bool = false,completion:@escaping ([MachineryProduct]) -> Void) {
        let para = isFromManufacturer ? ["manufacture_id":subcata] : ["subcategory_id":subcata]
        let authorization:HTTPHeaders =  ["Authorization":Token.getLatestToken()]
        print(authorization)
        AF.request(NewAPI.machineList, method: .post, parameters: para,headers: authorization).responseJSON { (responseData) in
            self.printEveryThing(responseData: responseData, statusCode: 200, url: NewAPI.machineList, para: para)
            var machineryProd = [MachineryProduct]()
            if responseData.value != nil {
                if responseData.response?.statusCode == 200 {
                    let data = responseData.value as! [String:Any]
                    let result = data["data"] as! [[String:Any]]
                    for i in result {
                        let product_id = i["machinery_id"] as? Int ?? 0
                        let product_name = i["machinery_name"] as? String ?? ""
                        let productcode = i["productcode"] as? String ?? ""
                        let amount = i["amount"] as? String ?? ""
                        let image = i["image"] as? String ?? ""
                        
                        
                        
                        let e1 = MachineryProduct.init(productID: product_id, productName: product_name, productcode: productcode, amount: amount, image: image)
                        machineryProd.append(e1)
                    }
                    completion(machineryProd)
                }
            }
        }
    }
    
    func getmachineryDetail(id:String,completion:@escaping (MachineryDetail,[MachineryProduct],[Files],Manufacturer) -> Void) {
        AF.request(NewAPI.machineryDetail + id, method: .put, encoding: URLEncoding.default).responseJSON { (responseData) in
            self.printEveryThing(responseData: responseData, statusCode: responseData.response?.statusCode ?? 000, url: NewAPI.machineryDetail + id, para: "")
            var machineryProd = [MachineryProduct]()
            var filess = [Files]()
            if responseData.value != nil {
                if responseData.response?.statusCode == 200 {
                    let data = responseData.value as! [String:Any]
                    let url = data["url"] as? String ?? ""
                    let manuUrl = data["manufacture_url"] as? String ?? ""
                    let mData = data["Machinerydata"] as! [[String:Any]]
                    
                    let mid = mData[0]["id"] as? Int ?? 0
                    let mCategory_id = mData[0]["category_id"] as? String ?? ""
                    let msubcategory_id = mData[0]["subcategory_id"] as? String ?? ""
                    let mproduct_name = mData[0]["product_name"] as? String ?? ""
                    let mproductcode = mData[0]["productcode"] as? String ?? ""
                    let mamount = mData[0]["amount"] as? String ?? ""
                    let mimage = mData[0]["image"] as? String ?? ""
                    let mdescription = mData[0]["description"] as? String ?? ""
                    let mstatus = mData[0]["status"] as? Int ?? 0
                    let mcreated_at = mData[0]["created_at"] as? String ?? ""
                    let mupdated_at = mData[0]["updated_at"] as? String ?? ""
                    
                    let temp = MachineryDetail.init(id: mid, categoryID: mCategory_id, subcategoryID: msubcategory_id, productName: mproduct_name, productcode: mproductcode, amount: mamount, image: (url + "/" + mimage).replacingOccurrences(of: " ", with: "%20"), machineryDetailDescription: mdescription, status: mstatus, createdAt: mcreated_at, updatedAt: mupdated_at)
                    
                    let recent_prod = data["recent_product"] as! [[String:Any]]
                    for i in recent_prod {
                        let product_id = i["product_id"] as? Int ?? 0
                        let product_name = i["product_name"] as? String ?? ""
                        let productcode = i["productcode"] as? String ?? ""
                        let amount = i["amount"] as? String ?? ""
                        let image = i["image"] as? String ?? ""
                        
                        
                        
                        let e1 = MachineryProduct.init(productID: product_id, productName: product_name, productcode: productcode, amount: amount, image: (url + "/" + image).replacingOccurrences(of: " ", with: "%20"))
                        machineryProd.append(e1)
                    }
                    
                    let files = data["files"] as! [[String:Any]]
                    for i in files {
                        let id = i["id"] as? Int ?? 0
                        let product_id = i["product_id"] as? String ?? ""
                        let image = i["image"] as? String ?? ""
                        let type = i["type"] as? Int ?? 0
                        let created_at = i["created_at"] as? String ?? ""
                        let thumbnail = i["thumbnail"] as? String ?? ""
                        
                        filess.append(Files.init(id: id, productID: product_id, image: (url + "/" + image).replacingOccurrences(of: " ", with: "%20"), type: type, createdAt: created_at, updatedAt: "",thumbnail:(url + "/" + thumbnail).replacingOccurrences(of: " ", with: "%20")))
                    }
                    
                    let manufacture = data["manufacture"] as! [String:Any]
                    let company_name = manufacture["company_name"] as? String ?? ""
                    let manufacture_id = manufacture["manufacture_id"] as? Int ?? 0
                    let logo = manufacture["logo"] as? String ?? ""
                    
                    let tempManu = Manufacturer.init(companyName: company_name, manufactureID: manufacture_id, logo: (manuUrl + "/" + logo).replacingOccurrences(of: " ", with: "%20"))
                    
                    completion(temp,machineryProd,filess,tempManu)
                }
            }
        }
    }
    
    func dashboardData(completion:@escaping ([AppBannerDash],[Categories],[ManufactureDash],[Video],[GalleryDash],[ExclusiveBanner],[ProductDash],[Event],[String],[Partner]) -> Void) {
        let authorization:HTTPHeaders =  ["Authorization":Token.getLatestToken()]
        AF.request(NewAPI.dashboard, method: .get, parameters: nil,encoding: JSONEncoding.default, headers: authorization).responseJSON { (responseData) in
            self.printEveryThing(responseData: responseData, statusCode: responseData.response?.statusCode ?? 000, url: NewAPI.dashboard, para: authorization)
            var allAppBanner = [AppBannerDash]()
            var categories = [Categories]()
            var manufacturerr = [ManufactureDash]()
            var videoo = [Video]()
            var galleryy = [GalleryDash]()
            var exclusiveBannerr = [ExclusiveBanner]()
            var product = [ProductDash]()
            var events = [Event]()
            let review = [String]()
            var partnerr = [Partner]()
            if responseData.response?.statusCode == 200 {
                if responseData.value != nil {
                     let respData = responseData.value as! [String:Any]
                     let respData1 = respData["body"] as! [[String:Any]]
                     
                     //MARK:- App Banners
                     let appBanners = respData1[0]["app_banners"] as! [[String:Any]]
                     for i in appBanners {
                         let id = i["id"] as? Int ?? 0
                         let banner_for = i["banner_for"] as? String ?? ""
                         let state_code = i["state_code"] as? String ?? ""
                         let city_code = i["city_code"] as? String ?? ""
                         let user_id = i["user_id"] as? String ?? ""
                         let title = i["title"] as? String ?? ""
                         let type = i["type"] as? String ?? ""
                         let place = i["place"] as? String ?? ""
                         let start_date = i["start_date"] as? String ?? ""
                         let end_date = i["end_date"] as? String ?? ""
                         let category_id = i["category_id"] as? String ?? ""
                         let subcategory_id = i["subcategory_id"] as? String ?? ""
                         let subsubcategory_id = i["subsubcategory_id"] as? String ?? ""
                         let image = i["image"] as? String ?? ""
                         let status = i["status"] as? String ?? ""
                         let created_at = i["created_at"] as? String ?? ""
                         let updated_at = i["updated_at"] as? String ?? ""
                         
                         let tempurlImg = MainURL.mainurl + "img/banner/" + image
                         
                         if place == "App" {
                            allAppBanner.append(AppBannerDash.init(id: id, bannerFor: banner_for, stateCode: state_code, cityCode: city_code, userID: user_id, title: title, type: type, place: place, startDate: start_date, endDate: end_date, categoryID: category_id, subcategoryID: subcategory_id, subsubcategoryID: subsubcategory_id, image: tempurlImg.replacingOccurrences(of: " ", with: "%20"), status: status, createdAt: created_at, updatedAt: updated_at))
                         }
                         
                     }
                     
                    //MARK:- Categories
                    let sub_cata = respData1[1]["categories"] as! [[String:Any]]
                    for i in sub_cata {
                        let id = i["id"] as? Int ?? 0
                        let category = i["category"] as? String ?? ""
                        let description = i["description"] as? String ?? ""
                        let image = i["image"] as? String ?? ""
                        let menu_id = i["menu_id"] as? String ?? ""
                        let status = i["status"] as? String ?? ""
                        let created_at = i["created_at"] as? String ?? ""
                        let updated_at = i["updated_at"] as? String ?? ""
                        let tranding_banner = i["tranding_banner"] as? String ?? ""
                        
                        
                        
                        categories.append(Categories.init(id: id, category: category, categoriesDescription: description, image:(MainURL.mainurl + "img/category/" + image).replacingOccurrences(of: " ", with: "%20"), menuID: menu_id, status: status, createdAt: created_at, updatedAt: updated_at, tranding_banner: (MainURL.mainurl + "img/category/" + tranding_banner).replacingOccurrences(of: " ", with: "%20")))
                    }
                    
                    //MARK:- Manufacturer
                    let manufacturer = respData1[2]["manufacture"] as! [[String:Any]]
                    for i in manufacturer {
                        let name = i["name"] as? String ?? ""
                        let desc = i["description"] as? String ?? ""
                        let package = i["package_name"] as? String ?? ""
                        let logo = i["logo"] as? String ?? ""
                        let manufacture_id = i["manufacture_id"] as? Int ?? 0
                        
                        manufacturerr.append(.init(name: name, logo: (MainURL.mainurl + "img/users/" + logo).replacingOccurrences(of: " ", with: "%20"),description: desc, package_name: package, manufactureID: manufacture_id))
                    }
                    
                    
                    //MARK:- Video
                    let video = respData1[3]["video"] as! [[String:Any]]
                    for i in video {
                        let id = i["id"] as? Int ?? 0
                        let title = i["title"] as? String ?? ""
                        let file_type = i["file_type"] as? String ?? ""
                        let file_name = i["file_name"] as? String ?? ""
                        let thumbnail = i["thumbnail"] as? String ?? ""
                        let web_content = i["web_content"] as? String ?? ""
                        let status = i["status"] as? String ?? ""
                        
                        videoo.append(Video.init(id: id, title: title, fileType: file_type, fileName: (MainURL.mainurl + "img/gallery/" + file_name).replacingOccurrences(of: " ", with: "%20"), thumbnail: (MainURL.mainurl + "img/gallery/" + thumbnail).replacingOccurrences(of: " ", with: "%20"), webContent: web_content, status: status, createdAt: "", updatedAt: ""))
                    }
                    
                    
                    //MARK:- Gallery
                    let gallery = respData1[4]["gallery"] as! [[String:Any]]
                    
                    for i in gallery {
                        let id = i["id"] as? Int ?? 0
                        let title = i["title"] as? String ?? "No Address"
                        let file_type = i["file_type"] as? String ?? "No Date"
                        let file_name = i["file_name"] as? String ?? "No time"
                        let thumbnail = i["thumbnail"] as? String ?? "No image"
                        let status = i["status"] as? String ?? "No Description"
                        
                        
                        galleryy.append(GalleryDash.init(id: id, title: title, fileType: file_type, fileName: (MainURL.mainurl + "img/gallery/" + file_name).replacingOccurrences(of: " ", with: "%20"), thumbnail: (MainURL.mainurl + "img/gallery/" + "/" + thumbnail).replacingOccurrences(of: " ", with: "%20"), webContent: "", status: status, createdAt: "", updatedAt: ""))
                    }
                   
                    
                    
                     //MARK:- Exclusive banners
                     let exclusiveBanner = respData1[5]["exclusive_banners"] as! [[String:Any]]
                    for i in exclusiveBanner {
                        let id = i["id"] as? Int ?? 0
                        let banner_for = i["banner_for"] as? String ?? "No Address"
                        let state_code = i["state_code"] as? String ?? "No Date"
                        let city_code = i["city_code"] as? String ?? "No time"
                        let user_id = i["user_id"] as? String ?? "No image"
                        let title = i["title"] as? String ?? "No Description"
                        let type = i["type"] as? String ?? ""
                        let place = i["place"] as? String ?? "No Address"
                        let start_date = i["start_date"] as? String ?? "No Date"
                        let end_date = i["end_date"] as? String ?? "No time"
                        let category_id = i["category_id"] as? String ?? "No image"
                        let subcategory_id = i["subcategory_id"] as? String ?? "No Description"
                        let subsubcategory_id = i["subsubcategory_id"] as? String ?? ""
                        let image = i["image"] as? String ?? "No Address"
                        let status = i["status"] as? String ?? "No Date"
                        let created_at = i["created_at"] as? String ?? "No time"
                        let updated_at = i["updated_at"] as? String ?? "No image"
                        
                        exclusiveBannerr.append(ExclusiveBanner.init(id: id, bannerFor: banner_for, stateCode: state_code, cityCode: city_code, userID: user_id, title: title, type: type, place: place, startDate: start_date, endDate: end_date, categoryID: category_id, subcategoryID: subcategory_id, subsubcategoryID: subsubcategory_id, image: (MainURL.mainurl + "img/banner/" + image).replacingOccurrences(of: " ", with: "%20"), status: status, createdAt: created_at, updatedAt: updated_at))
                        
                    }
                    
                     
                    //MARK:- Trending Product
                    let trending_product = respData1[6]["product"] as! [[String:Any]]
                    for i in trending_product {
                        let pid = i["product_id"] as! Int
                        let pname = i["product_name"] as? String
                        let img = i["image"] as? String ?? ""
                        let amount = i["amount"] as? String ?? ""
                        let productcode = i["productcode"] as? String ?? ""
                        let proWeight = i["weight"] as! [String:Any]
                        let proQuality = i["quality"] as! [String:Any]
                        let product_category = i["product_category"] as? String ?? ""
                        let completeImageUrl = img.contains("http") ? img.replacingOccurrences(of: " ", with: "%20") : (MainURL.mainurl + "img/product/" + img).replacingOccurrences(of: " ", with: "%20")
                        product.append(ProductDash.init(productID: pid, productName: pname ?? "", productCategory: product_category, productcode: productcode, amount: amount, image: completeImageUrl, quality: proQuality, weight: proWeight))
                    }
                    //https://testserver.savyajewelsbusiness.com/img/product/1593894653_PPK00073.jpg
                     //MARK:- Events
                     let allEvents = respData1[7]["events"] as! [[String:Any]]
                     
                     for i in allEvents {
                         let eventName = i["title"] as? String ?? "No Name"
                         let address = i["address"] as? String ?? "No Address"
                         let date = i["date"] as? String ?? "No Date"
                         let time = i["eventtime"] as? String ?? "No time"
                         let img = i["image"] as? String ?? "No image"
                         let descr = i["description"] as? String ?? "No Description"
                         let status = i["status"] as? String
                        let event_type = i["event_type"] as? String
                        let e1 = Event(eventName: eventName, address: address, date: date, time: time, img: img, descr: descr, status: Int(status!)!,event_type:event_type!)
                         if Int(status!)! == 1 {
                             events.append(e1)
                         }
                     }
                    
                    
                    //MARK:- Partner
                    let partner = respData1[9]["partner"] as! [[String:Any]]
                    for i in partner {
                        let id = i["id"] as? Int ?? 0
                        let title = i["title"] as? String ?? ""
                        let image = i["image"] as? String ?? ""
                        let status = i["status"] as? String ?? ""
                        let created_at = i["created_at"] as? String ?? ""
                        let updated_at = i["updated_at"] as? String ?? ""
                        
                        let tempurlImg = (MainURL.mainurl + "img/partner/" + image).replacingOccurrences(of: " ", with: "%20")
                        
                       partnerr.append(Partner.init(id: id, title: title, image: tempurlImg, status: status, createdAt: created_at, updatedAt: updated_at))
                    }
                    
                    completion(allAppBanner,categories,manufacturerr,videoo,galleryy,exclusiveBannerr,product,events,review,partnerr)
                }
            } else {
                //completion([],[],[],[],[],[],[],[],[],[])
            }
        }
    }

    func bannerData(completion:@escaping ([kycBanners]) -> Void) {
        let authorization:HTTPHeaders =  ["Authorization":Token.getLatestToken()]
        
       // let para = ["type":"app"]
        
        let url = NewAPI.kyc_banners+"?type=app"
        print(url)
        
        
        AF.request(url, method: .get, parameters: nil,encoding: JSONEncoding.default, headers: authorization).responseJSON { (responseData) in
            self.printEveryThing(responseData: responseData, statusCode: responseData.response?.statusCode ?? 000, url: url, para: authorization)
            var kycBannerss = [kycBanners]()
    
            if responseData.response?.statusCode == 200 {
                if responseData.value != nil {
                     let respData = responseData.value as! [String:Any]
                     let respData1 = respData["body"] as! [String:Any]
                     
                     //MARK:- App Banners
                     //let appBanners = respData1[0]["app_banners"] as! [[String:Any]]
                     
                         let id = respData1["id"] as? Int ?? 0
                         let banner_for = respData1["banner_for"] as? String ?? ""
                       
                         let title = respData1["title"] as? String ?? ""
                         let image = respData1["image"] as? String ?? ""
                         let status = respData1["status"] as? String ?? ""
                         let created_at = respData1["created_at"] as? String ?? ""
                         let updated_at = respData1["updated_at"] as? String ?? ""
                    let alt = respData1["alt"] as? String ?? ""
                         
                         let tempurlImg = MainURL.mainurl + "img/kycbanner/" + image
                         
                         
                    kycBannerss.append(kycBanners.init(id: id, bannerFor: banner_for, title: title, image: tempurlImg.replacingOccurrences(of: " ", with: "%20"), status: status, createdAt: created_at, updatedAt: updated_at, alt: alt))
                         
                
                    
                    
                    completion(kycBannerss)
                }
            } else {
                //completion([],[],[],[],[],[],[],[],[],[])
            }
        }
    }

}
