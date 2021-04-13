//
//  FilterMenu.swift
//  savyaApp
//
//  Created by Yash on 2/21/20.
//  Copyright © 2020 Yash Rathod. All rights reserved.
//

import Foundation

class FilterMenu:NSObject {
    
    var name:String!
    var values = [String]()
    
    init(name:String,values:[String]) {
        self.name = name
        self.values = values
    }
}
struct FilterProperties {
    var title:String = ""
    var isSelected: Bool = false
    var min: Float = 0
    var max: Float = 0
    var selectedMin: Float = 0
    var selectedMax: Float = 0
    var isWeightFilter: Bool = false
}
struct ProductFilters {
    var name:String = ""
    var filterName: String = ""
    var isSelected: Bool = false
    var properties: [FilterProperties] = []
}
