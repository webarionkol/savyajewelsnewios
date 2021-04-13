//
//  KYC.swift
//  savyaApp
//
//  Created by Yash on 5/16/20.
//  Copyright © 2020 Yash Rathod. All rights reserved.
//

import Foundation

// MARK: - Kyc
class Kyc {
    let id: Int
    let uid: String
    let agentCode, gstNo, panNo, aadhar: String
    let gstDoc, gstBack: String
    let aadharDoc, aadharBack, visitingDoc, visitingBack: String
    let panDoc, documentVerified, status, createdAt: String
    let updatedAt: String
    let aadhar_doc_status,aadhar_back_status,gst_back_status,gst_doc_status,pan_doc_status,visiting_back_status,visiting_doc_status,shopname,designation:String

    init(id: Int, uid: String, agentCode: String, gstNo: String, panNo: String, aadhar: String, gstDoc: String, gstBack: String, aadharDoc: String, aadharBack: String, visitingDoc: String, visitingBack: String, panDoc: String, documentVerified: String, status: String, createdAt: String, updatedAt: String,aadhar_back_status:String,aadhar_doc_status:String,gst_back_status:String,gst_doc_status:String,pan_doc_status:String,visiting_back_status:String,visiting_doc_status:String,shopname:String,designation:String) {
        self.id = id
        self.uid = uid
        self.agentCode = agentCode
        self.gstNo = gstNo
        self.panNo = panNo
        self.aadhar = aadhar
        self.gstDoc = gstDoc
        self.gstBack = gstBack
        self.aadharDoc = aadharDoc
        self.aadharBack = aadharBack
        self.visitingDoc = visitingDoc
        self.visitingBack = visitingBack
        self.panDoc = panDoc
        self.documentVerified = documentVerified
        self.status = status
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.aadhar_back_status = aadhar_back_status
        self.aadhar_doc_status = aadhar_doc_status
        self.gst_doc_status = gst_doc_status
        self.gst_back_status = gst_back_status
        self.pan_doc_status = pan_doc_status
        self.visiting_doc_status = visiting_doc_status
        self.visiting_back_status = visiting_back_status
        self.shopname = shopname
        self.designation = designation
    }
}
