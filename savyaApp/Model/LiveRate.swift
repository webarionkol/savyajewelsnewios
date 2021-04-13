//
//  LiveRate.swift
//  savyaApp
//
//  Created by Yash on 8/9/19.
//  Copyright © 2019 Yash Rathod. All rights reserved.
//

import Foundation

class LiveRate:NSObject {
    
    var symbol:String!
    var ask:String!
    var askStatus:String!
    var bid:String!
    var bidStatus:String!
    var low:String!
    var high:String!
    
    init(symbol:String,ask:String,bid:String,low:String,high:String, askStatus: String, bidStatus: String) {
        self.symbol = symbol
        self.ask = ask
        self.bid = bid
        self.low = low
        self.high = high
        self.askStatus = askStatus
        self.bidStatus = bidStatus
    }
}
