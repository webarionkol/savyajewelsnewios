//
//  StateBullian.swift
//  savyaApp
//
//  Created by Yash on 5/8/20.
//  Copyright © 2020 Yash Rathod. All rights reserved.
//

import Foundation


// MARK: - Banner
class StateBullian {
    let id: Int
    let name: String
    let status: Int
    let createdAt, updatedAt: String

    init(id: Int, name: String, status: Int, createdAt: String, updatedAt: String) {
        self.id = id
        self.name = name
        self.status = status
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
