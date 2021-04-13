//
//  Notification.swift
//  savyaApp
//
//  Created by Yash on 7/28/19.
//  Copyright © 2019 Yash Rathod. All rights reserved.
//

import Foundation

class Notifications:NSObject {
    
    var title:String!
    var message:String!
    var date:String!
    var time:String!
    
    init(title:String,message:String,date:String,time:String) {
        self.title = title
        self.message = message
        self.date = date
        self.time = time
    }
}
