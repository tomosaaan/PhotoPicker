//
//  MainViewModel.swift
//  PhotoPicker
//
//  Created by takahashi tomoki on 2017/02/12.
//  Copyright © 2017年 Tomoki Takahashi. All rights reserved.
//

import UIKit
import ObjectMapper
import RxSwift
import RxCocoa
import ReachabilitySwift

enum StateManager {
    case error
    case success
    case complete
    case loading
}
final class MainViewModel:ParentViewModel{
    
    static let shared = MainViewModel()
    let disposeBag = DisposeBag()
    let router = Api.Main()
    
    fileprivate(set) var photos = Variable<[PhotoModel]>([])
    
    fileprivate(set) var state = Variable<StateManager>(.complete)
    
    internal var pageingCount = Variable<Int>(1)

    override init(){
        super.init()
        self.reachStart()
    }
    
    deinit {
        self.reachStop()
    }
    func getRequest(completion: ((Void) -> (Void))? = nil){
        
        self.state.value = .loading
        self.router.getPhotosList(page: pageingCount.value).asObservable()
            .shareReplay(1)
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
            .subscribe(onNext:{ [weak self] photos in
                let parseJson = Mapper<PhotosModel>().map(JSONObject: photos)
                guard let data = parseJson?.photos else { return }
                
                if self?.photos.value.count == 0 {
                    self?.photos.value = data
                } else {
                    data.forEach({ photo in
                        self?.photos.value.append(photo)
                    })
                }
                self?.state.value = .success
                },onError:{[weak self] _ in
                    self?.state.value = .error
                },onCompleted:{[weak self] in
                    self?.state.value = .complete
                    if let comp = completion {
                        comp()
                    }
            }).addDisposableTo(self.disposeBag)
    }

}
