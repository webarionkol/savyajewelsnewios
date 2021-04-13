//
//  Event.swift
//  savyaApp
//
//  Created by Yash on 7/28/19.
//  Copyright © 2019 Yash Rathod. All rights reserved.
//

import Foundation

class Event:NSObject {
    
    var eventName:String!
    var descr:String!
    var address:String!
    var date:String!
    var time:String!
    var img:String!
    var status:Int!
    var event_type : String!
    
    
    init(eventName:String,address:String,date:String,time:String,img:String,descr:String,status:Int,event_type:String) {
        self.eventName = eventName
        self.address = address
        self.date = date
        self.time = time
        self.img = img
        self.descr = descr
        self.status = status
        self.event_type = event_type
    }
}
