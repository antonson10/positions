//
//  Position.swift
//  positions
//
//  Created by Anton Chugunov on 29.08.2018.
//  Copyright © 2018 Anton Chugunov. All rights reserved.
//

import Foundation

class Position: NSObject {
    let id: String
    let createdAt: String
    let title: String
    let location: String
    let type: String
    let descr: String
    let howToApply: String
    let company: String
    let companyUrl: String?
    let companyLogo: String?
    let url: String
    
    init(id: String, createdAt: String, title: String, location: String, type: String, descr: String, howToApply: String, company: String, companyUrl: String?,  companyLogo: String?, url: String) {
        self.id = id
        self.createdAt = createdAt
        self.title = title
        self.location = location
        self.type = type
        self.descr = descr
        self.howToApply = howToApply
        self.company = company
        self.companyUrl = companyUrl
        self.companyLogo = companyLogo
        self.url = url
    }
}
