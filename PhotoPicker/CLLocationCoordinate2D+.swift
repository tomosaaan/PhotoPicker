//
//  CLLocationCoordinate2D+.swift
//  PhotoPicker
//
//  Created by takahashi tomoki on 2017/02/13.
//  Copyright © 2017年 Tomoki Takahashi. All rights reserved.
//

import MapKit
import APOfflineReverseGeocoding

extension CLLocationCoordinate2D {

    func getCountry() -> APCountry? {
        let geocoding = APReverseGeocoding.default()
        return geocoding?.geocodeCountry(with: self)
    }
    
    
    
}
