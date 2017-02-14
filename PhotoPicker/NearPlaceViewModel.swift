//
//  NearPlaceViewModel.swift
//  PhotoPicker
//
//  Created by takahashi tomoki on 2017/02/14.
//  Copyright © 2017年 Tomoki Takahashi. All rights reserved.
//

import UIKit
import RxSwift
import ObjectMapper

final class NearPlaceViewModel:ParentViewModel {
    static let shared = NearPlaceViewModel()
    
    let disposeBag = DisposeBag()
    
    fileprivate(set) var nearPlacePhotos = Variable<[PhotoModel]>([])
    
    fileprivate let router = Api.Main()
    
    internal var pageCount = Variable<Int>(1)
    
    internal var selectedPhoto = Variable<PhotoModel?>(nil)
    
    internal var state = Variable<StateManager>(.complete)
    
    internal var locationInfo = Variable<[String:Double]>([
            "lat" : 0,
            "lon" : 0
        ])
    
    override init(){
        super.init()
        self.reachStart()
        
        self.selectedPhoto.asObservable()
            .subscribe(onNext:{[weak self] photo in
                guard let lat = photo?.latitude,let lon = photo?.longtitude else { return }
                self?.locationInfo.value["lat"] = Double(lat)!
                self?.locationInfo.value["lon"] = Double(lon)!
            }).addDisposableTo(self.disposeBag)
        
    }
    
    deinit {
        self.reachStop()
    }
    
    func getRequestByPlace(completion: ((Void)-> (Void))? = nil){
        
        self.state.value = .loading
        self.router.getPhotoListByLocation(
                page:self.pageCount.value,
                lat: self.locationInfo.value["lat"]!,
                lon: self.locationInfo.value["lon"]!).asObservable()
            .subscribe(onNext:{ [weak self] photos in
                let parseJson = Mapper<PhotosModel>().map(JSONObject: photos)
                guard let data = parseJson?.photos else { return }
                
                if self?.nearPlacePhotos.value.count == 0 {
                    self?.nearPlacePhotos.value = data
                } else {
                    data.forEach({ photo in
                        self?.nearPlacePhotos.value.append(photo)
                    })
                }
                self?.state.value = .success
            },onError:{[weak self] _ in
                self?.state.value = .error
            },onCompleted:{ [weak self] in
                self?.state.value = .complete
            }).addDisposableTo(self.disposeBag)
    }
}
