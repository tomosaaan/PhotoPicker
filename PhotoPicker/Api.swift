//
//  Api.swift
//  PhotoPicker
//
//  Created by takahashi tomoki on 2017/02/12.
//  Copyright © 2017年 Tomoki Takahashi. All rights reserved.
//

import UIKit
import RxSwift
import Alamofire

// This App used [:GET] method only
enum ApiMethod: String{
    case GET = "GET"
    var httpMethod: HTTPMethod {
        switch self {
        case .GET:
            return .get
        }
    }
}

class Api: ApiClient {
    fileprivate(set) var router: ApiRouter
    fileprivate(set) var method: ApiMethod
    fileprivate(set) var parameters: [String: Any] = [
        "api_key":ApiInfomation.apiKey
    ]
    fileprivate let encoder = URLEncoding()
    fileprivate var request: URLRequest {
        let urlString = router.baseUrl + router.path
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = method.rawValue
        return try! encoder.encode(request as URLRequestConvertible, with: self.parameters)
    }
    
    // MARK: fileprivate Method
    fileprivate init(router: ApiRouter,method: ApiMethod){
        self.router = router
        self.method = method
    }
    
    
    // MARK: Public Method
    
    // Create Api Instance
    public static func create(router: ApiRouter,method: ApiMethod) -> Api {
        return Api.init(router:router, method: method)
    }
    // Create and Set parameters
    public func parameters(_ params: [String: Any]) -> Self{
        params.forEach{ key, value in
            self.parameters.updateValue(value, forKey: key)
        }
        return self
    }
}
extension Api {
    
    // :TODO エラーハンドリング
    func httpRequest() -> Observable<Any>{
        let alamofireManager = Alamofire.SessionManager.default
        alamofireManager.session.configuration.timeoutIntervalForRequest = 10
        return Observable.create({ (observer : AnyObserver<Any>) in
            alamofireManager.request(self.request)
                .validate()
                .responseJSON(completionHandler: { response in
                    switch response.result {
                    case .success(let value):
                        observer.onNext(value)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                })
            return Disposables.create {
            }
        })
    }
    
}





