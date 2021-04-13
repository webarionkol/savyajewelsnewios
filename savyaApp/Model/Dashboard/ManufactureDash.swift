//
//  ManufactureDash.swift
//  savyaApp
//
//  Created by Yash on 7/16/20.
//  Copyright © 2020 Yash Rathod. All rights reserved.
//

import Foundation


// MARK: - ManufactureDash
class ManufactureDash {
    var name, logo, description, package_name: String
    var manufactureID: Int

    init(name: String, logo: String, description: String, package_name: String, manufactureID: Int) {
        self.name = name
        self.description = description
        self.package_name = package_name
        self.logo = logo
        self.manufactureID = manufactureID
    }
}
