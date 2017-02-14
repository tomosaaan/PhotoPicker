//
//  String+.swift
//  PhotoPicker
//
//  Created by takahashi tomoki on 2017/02/13.
//  Copyright © 2017年 Tomoki Takahashi. All rights reserved.
//

import UIKit


extension String {
    
    
    func flickrResolution(_ mstzb: String) -> String{
        return self.replacingOccurrences(of:"t.jpg", with: "\(mstzb).jpg")
    }
    
}
