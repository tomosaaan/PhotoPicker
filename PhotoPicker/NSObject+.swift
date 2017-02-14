//
//  NSObject+.swift
//  PhotoPicker
//
//  Created by takahashi tomoki on 2017/02/12.
//  Copyright © 2017年 Tomoki Takahashi. All rights reserved.
//

import UIKit

extension NSObject {
    class var className: String{
        return NSStringFromClass(self).components(separatedBy: ".").last ?? ""
    }
}
