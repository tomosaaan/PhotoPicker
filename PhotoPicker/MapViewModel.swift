//
//  MapViewModel.swift
//  PhotoPicker
//
//  Created by takahashi tomoki on 2017/02/13.
//  Copyright © 2017年 Tomoki Takahashi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import APOfflineReverseGeocoding

final class MapViewModel:ParentViewModel{
    static let shared = MapViewModel()
    
    let disposeBag = DisposeBag()
    
    internal var photoData = Variable<PhotoModel?>(nil)
    
    fileprivate(set) var country = Variable<APCountry?>(nil)
    
    internal var state = Variable<StateManager>(.complete)
    
    override init(){
        super.init()
        
        self.reachStart()
        self.photoData.asObservable()
            .subscribe(onNext: { photo in
                if let lat = photo?.latitude,let lon = photo?.longtitude {
                    let code = CLLocationCoordinate2DMake(Double(lat)!,Double(lon)!)
                    self.country.value = code.getCountry()
                }
            }).addDisposableTo(self.disposeBag)
        
        self.isReachable.asObservable()
            .subscribe(onNext:{ [weak self] reachable in
                if !reachable {
                    self?.state.value = .error
                } else {
                    self?.state.value = .complete
                }
                
            }).addDisposableTo(self.disposeBag)
    }
    
    deinit {
        self.reachStop()
    }

    
}
