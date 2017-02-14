//
//  ParentViewModel.swift
//  PhotoPicker
//
//  Created by takahashi tomoki on 2017/02/14.
//  Copyright © 2017年 Tomoki Takahashi. All rights reserved.
//

import UIKit
import ReachabilitySwift
import RxSwift


class ParentViewModel {

    internal var reach: Reachability = Reachability()!
    
    internal var isReachable = Variable<Bool>(true)
    
    init(){
        self.initReachability()
    }

    func reachStart(){
        do {
            try reach.startNotifier()
        } catch {
            
        }
    }
    func reachStop(){
        reach.stopNotifier()
    }
    
    fileprivate func initReachability(){
        reach.whenReachable = { [weak self] check in
            self?.isReachable.value = check.isReachable
            
        }
        reach.whenUnreachable = { [weak self] check in
            self?.isReachable.value = check.isReachable
        }
    }
    
}
