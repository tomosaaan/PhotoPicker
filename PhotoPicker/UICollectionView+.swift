//
//  UICollectionView+.swift
//  PhotoPicker
//
//  Created by takahashi tomoki on 2017/02/12.
//  Copyright © 2017年 Tomoki Takahashi. All rights reserved.
//

import UIKit

extension UICollectionView {

    func registerCell<C: UICollectionViewCell>(type: C.Type){
        let nib = UINib(nibName: type.className, bundle: nil)
        self.register(nib, forCellWithReuseIdentifier: type.className)
    }
    
}


