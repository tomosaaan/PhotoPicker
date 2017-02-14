//
//  Router.swift
//  PhotoPicker
//
//  Created by takahashi tomoki on 2017/02/12.
//  Copyright © 2017年 Tomoki Takahashi. All rights reserved.
//

import UIKit
import RxSwift

extension Api {
    
    struct Main {
        enum Router: ApiRouter {
            case photos
            
            var baseUrl: String {
                return ApiInfomation.baseUrl
            }
            var path: String {
                return ApiInfomation.path
            }
        }
        
        func getPhotosList(page: Int) -> Observable<Any> {
            let params: [String: Any] = [
                "extras":"url_t,geo,owner_name",
                "format":"json",
                "method":"flickr.photos.search",
                "has_geo": 1,
                "nojsoncallback":1,
                "page":page,
            ]
            return Api.create(router: Api.Main.Router.photos, method: .GET)
                    .parameters(params)
                    .httpRequest()
        }
        func getPhotoListByLocation(page: Int, lat: Double, lon: Double) -> Observable<Any>{
            let params: [String: Any] = [
                "extras":"url_t,geo,owner_name",
                "format":"json",
                "method":"flickr.photos.search",
                "has_geo": 1,
                "nojsoncallback":1,
                "page":page,
                "lat":lat,
                "lon":lon
            ]
            
            return Api.create(router: Api.Main.Router.photos, method: .GET)
                    .parameters(params)
                    .httpRequest()
            
        }
    }
    
    
}
