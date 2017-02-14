//
//  PhotosModel.swift
//  PhotoPicker
//
//  Created by takahashi tomoki on 2017/02/13.
//  Copyright © 2017年 Tomoki Takahashi. All rights reserved.
//

import UIKit
import ObjectMapper

class PhotosModel: Mappable {
    internal var photos: [PhotoModel] = []
    
    required init?(map: Map) {
        self.mapping(map: map)
    }
    
    func mapping(map: Map) {
        self.photos <- map["photos.photo"]
    }
}
