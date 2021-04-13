//
//  AppDelegate.swift
//  savyaApp
//
//  Created by Yash on 6/16/19.
//  Copyright © 2019 Yash Rathod. All rights reserved.
//

import UIKit
import CoreData
import OneSignal
import Alamofire
import RealmSwift
import Firebase
import Siren
@UIApplicationMain
 class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        print(try! Realm().configuration.fileURL?.absoluteString ?? "")
        self.getAllPrice()
        FirebaseApp.configure()
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]
        
        
        OneSignal.initWithLaunchOptions(launchOptions, appId: "1444a43f-8e18-4612-90aa-4ad9aa58072c", handleNotificationAction: { (result) in

                    let payload = result?.notification.payload
                    if let additionalData = payload?.additionalData {

                        guard let data = payload?.additionalData as? [String: Any] else { return }
                        
                        
                        let notification_id =  String(format: "%@", (data["notification_id"]) as! CVarArg)
                        let category_id =  String(format: "%@", (data["category_id"]) as! CVarArg)
                        let manufaturer_id =  String(format: "%@", (data["manufaturer_id"]) as! CVarArg)
                        let subsubcategory_id =  String(format: "%@", (data["subsubcategory_id"]) as! CVarArg)
                        let sub_category_id =  String(format: "%@", (data["sub_category_id"]) as! CVarArg)
                        let machinery_id =  String(format: "%@", (data["machinery_id"]) as! CVarArg)
                        let product_id =  String(format: "%@", (data["product_id"]) as! CVarArg)
                        let location_id =  String(format: "%@", (data["location_id"]) as! CVarArg)
                        let bullianID =  String(format: "%@", (data["bullianID"]) as! CVarArg)
                        
                        

                        
                        Global.setIsFrom(isFrom: "1")
                        Global.setNotiId(notificaitonid: "\(notification_id)")
                        Global.setSubid(sub_category_id: sub_category_id)
                        Global.setMenuid(manufaturer_id: manufaturer_id)
                        Global.setCateid(category_id: category_id)
                        Global.setproid(product_id: product_id)
                        Global.setmachine(machinery_id: machinery_id)
                        Global.setlocation(location_id: location_id)
                        
                        Global.setbullid(bullianID: bullianID)
                      
                        
                        DispatchQueue.main.async {
                            self.window = UIWindow(frame: UIScreen.main.bounds)

                               let storyboard = UIStoryboard(name: "Main", bundle: nil)

                               let initialViewController = storyboard.instantiateViewController(withIdentifier: "splashVC") as! splashVC

                               self.window?.rootViewController = initialViewController
                               self.window?.makeKeyAndVisible()
                        }
                        
                      
    
                    }


                },settings: onesignalInitSettings)
        
        // Replace 'YOUR_APP_ID' with your OneSignal App ID.
//        OneSignal.initWithLaunchOptions(launchOptions,
//                                        appId: "1444a43f-8e18-4612-90aa-4ad9aa58072c",
//                                        handleNotificationAction: nil,
//                                        settings: onesignalInitSettings)
        
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification
        
        // Recommend moving the below line to prompt for push after informing the user about
        //   how your app will use them.
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
        })
        UserDefaults.standard.removeObject(forKey: "guest")
        
        
        let update = appUpdateAvailable()
        print(update)
        UIApplication.shared.applicationIconBadgeNumber = 0
//        if update == true {
//            Global.setUpdate(update: "1")
//           
//        }else {
//            
//            Global.setUpdate(update: "0")
//        }
        
        
        return true
    }

    func getAllPrice() {
        AF.request(Apis.priceList, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: header.headers).responseJSON { (responseData) in
            if responseData.value != nil {
                if responseData.response?.statusCode == 200 {
                    self.cleanupDb()
                    let res1 = responseData.value as! [String:Any]
                    let res = res1["data"] as! [String:Any]
                    //MARK: Diamond Name
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
                            g1.gold_type = i["gold_type"] as! String
                            g1.price = "\(i["price"] as! Int)"
                            g1.valuein = Double(i["valuein"] as! String)!
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
                            s1.silver_type = i["silver_type"] as! String
                            s1.price = "\(i["price"] as! Int)"
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
                            st1.stone_type = i["stone_type"] as! String
                            st1.price = "\(i["price"] as! Int)"
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
                            dc1.price = "\(i["price"] as! Int)"
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
                            dcl1.price = i["price"] as! String
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
                            p1.platinum_type = i["platinum_type"] as! String
                            p1.price = i["price"] as! String
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
                            dm1.name = i["name"] as! String
                            dm1.price = i["price"] as! String
                            try! realm.write {
                                realm.add(dm1)
                            }
                        }
                    }
                }
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
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "savyaApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    func appUpdateAvailable() -> Bool
    {
        let storeInfoURL: String = "http://itunes.apple.com/lookup?bundleId=com.dev1.savyaApp"
        var upgradeAvailable = false
        // Get the main bundle of the app so that we can determine the app's version number
        let bundle = Bundle.main
        if let infoDictionary = bundle.infoDictionary {
            // The URL for this app on the iTunes store uses the Apple ID for the  This never changes, so it is a constant
            let urlOnAppStore = NSURL(string: storeInfoURL)
            if let dataInJSON = NSData(contentsOf: urlOnAppStore! as URL) {
                // Try to deserialize the JSON that we got
                if let dict: NSDictionary = try! JSONSerialization.jsonObject(with: dataInJSON as Data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: AnyObject] as NSDictionary? {
                    if let results:NSArray = dict["results"] as? NSArray {
                        print(results)
                        if let version = (results[0] as AnyObject).value(forKey: "version") as? String {
                            let fileSizeBytes = (results[0] as AnyObject).value(forKey: "fileSizeBytes") as? String
                            // Get the version number of the current version installed on device
                            if let currentVersion = infoDictionary["CFBundleShortVersionString"] as? String {
                                // Check if they are the same. If not, an upgrade is available.
                                print("\(version)")
                                if version != currentVersion {
                                    upgradeAvailable = true
                                }
                            }
                        }
                    }
                }
            }
        }
        return upgradeAvailable
    }

}

