//
//  NavigationFirstViewController.swift
//  PhotoPicker
//
//  Created by takahashi tomoki on 2017/02/12.
//  Copyright © 2017年 Tomoki Takahashi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class NavigationFirstViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var startButton: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bind()
    }
    
    func bind(){
        self.startButton.rx.tap.asControlEvent()
            .subscribe(onNext:{[weak self] in
                let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
                UIView.transition(
                    with:(self?.view.window)! ,
                    duration: 0.5,
                    options: .transitionCrossDissolve,
                    animations: {
                        UIView.setAnimationsEnabled(false)
                        self?.view.window?.rootViewController = nextVC
                        UIView.setAnimationsEnabled(true)
                    },
                    completion: nil
                )
            }).addDisposableTo(self.disposeBag)
        
    }
    
    class func instatiate() -> NavigationFirstViewController {
        let storyBoard = UIStoryboard(name: "FirstLaunch", bundle: nil)
        return storyBoard.instantiateViewController(withIdentifier: "NavigationFirstLaunch") as! NavigationFirstViewController
    }


}
