//
//  Photo.swift
//  PhotoPicker
//
//  Created by takahashi tomoki on 2017/02/13.
//  Copyright © 2017年 Tomoki Takahashi. All rights reserved.
//

import UIKit
import ObjectMapper

class PhotoModel: Mappable {
    internal var id: String!
    internal var url: String!
    internal var title: String!
    internal var latitude: String!
    internal var longtitude: String!
    
    required init?(map: Map) {
        self.mapping(map: map)
    }
    
    func mapping(map: Map) {
        self.id <- map["id"]
        self.url <- map["url_t"]
        self.title <- map["title"]
        self.latitude <- map["latitude"]
        self.longtitude <- map["longitude"]
    }
    
}
