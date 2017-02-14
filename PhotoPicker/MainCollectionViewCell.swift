//
//  MainCollectionViewCell.swift
//  PhotoPicker
//
//  Created by takahashi tomoki on 2017/02/12.
//  Copyright © 2017年 Tomoki Takahashi. All rights reserved.
//

import UIKit
import Kingfisher

class MainCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var photoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func bind(_ photo: PhotoModel){
        
        let url: URL = URL(string:photo.url.flickrResolution("n"))!
        self.photoImageView.kf.setImage(with: url,
                                        placeholder: nil,
                                        options: [.transition(.fade(1.0))],
                                        progressBlock: nil,
                                        completionHandler: nil)
        
    }

}
