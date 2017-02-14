//
//  ApiProtocol.swift
//  PhotoPicker
//
//  Created by takahashi tomoki on 2017/02/12.
//  Copyright © 2017年 Tomoki Takahashi. All rights reserved.
//

import UIKit

protocol ApiClient {
    static func create(router: ApiRouter,method: ApiMethod) -> Api
    func parameters(_ params: [String: Any]) -> Self
}

protocol ApiRouter {
    var baseUrl: String { get }
    var path: String { get }
}
