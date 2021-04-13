//
//  Gallery.swift
//  savyaApp
//
//  Created by Yash on 7/1/20.
//  Copyright © 2020 Yash Rathod. All rights reserved.
//

import Foundation

// MARK: - Gallery
class Gallery {
    var id: Int
    var title, fileType, fileName, thumbnail: String
    var status, createdAt, updatedAt: String

    init(id: Int, title: String, fileType: String, fileName: String, thumbnail: String, status: String, createdAt: String, updatedAt: String) {
        self.id = id
        self.title = title
        self.fileType = fileType
        self.fileName = fileName
        self.thumbnail = thumbnail
        self.status = status
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
