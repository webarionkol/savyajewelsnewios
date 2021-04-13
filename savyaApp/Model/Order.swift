//
//  Order.swift
//  savyaApp
//
//  Created by Yash on 1/5/20.
//  Copyright © 2020 Yash Rathod. All rights reserved.
//

import Foundation

class Order:NSObject {
    let orderID: Int
    let paymentMode, transactionID, message, addressID: String
    let totalamount, sgst, cgst, igst: String
    let finalTotal, sgstPer, cgstPer, igstPer: String
    let status, orderStatus, createdAt: String
    let product: [Cart]!

    init(orderID: Int, paymentMode: String, transactionID: String, message: String, addressID: String, totalamount: String, sgst: String, cgst: String, igst: String, finalTotal: String, sgstPer: String, cgstPer: String, igstPer: String, status: String, orderStatus: String, createdAt: String,product:[Cart]) {
        self.orderID = orderID
        self.paymentMode = paymentMode
        self.transactionID = transactionID
        self.message = message
        self.addressID = addressID
        self.totalamount = totalamount
        self.sgst = sgst
        self.cgst = cgst
        self.igst = igst
        self.finalTotal = finalTotal
        self.sgstPer = sgstPer
        self.cgstPer = cgstPer
        self.igstPer = igstPer
        self.status = status
        self.orderStatus = orderStatus
        self.createdAt = createdAt
        self.product = product
    }
    
}
