//
//  Gallery.swift
//  savyaApp
//
//  Created by Yash on 7/16/20.
//  Copyright © 2020 Yash Rathod. All rights reserved.
//

import Foundation

// MARK: - Gallery
class GalleryDash {
    var id: Int
    var title, fileType, fileName: String
    var thumbnail, webContent: String
    var status: String
    var createdAt, updatedAt: String

    init(id: Int, title: String, fileType: String, fileName: String, thumbnail: String, webContent: String, status: String, createdAt: String, updatedAt: String) {
        self.id = id
        self.title = title
        self.fileType = fileType
        self.fileName = fileName
        self.thumbnail = thumbnail
        self.webContent = webContent
        self.status = status
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

