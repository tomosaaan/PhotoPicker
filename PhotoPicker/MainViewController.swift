//
//  ViewController.swift
//  PhotoPicker
//
//  Created by takahashi tomoki on 2017/02/12.
//  Copyright © 2017年 Tomoki Takahashi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import UIScrollView_InfiniteScroll
import PullToRefreshSwift
import KRAlertController

final class MainViewController: UIViewController {
    fileprivate let viewModel = MainViewModel.shared
    
    let disposeBag = DisposeBag()
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
        self.bind()
        
        self.viewModel.getRequest()
    }

    fileprivate func configure(){
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.collectionView.registerCell(type: MainCollectionViewCell.self)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.view.frame.width/3 - 1, height: self.view.frame.width/3 - 1)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        self.collectionView.collectionViewLayout = layout
        self.collectionView.delegate = self
    
        self.infiniteScrollViewConfigure()
        self.refreshConfigure()

    }
    fileprivate func bind(){
        self.viewModel.photos.asDriver()
            .drive(self.collectionView.rx.items(cellIdentifier: "MainCollectionViewCell", cellType: MainCollectionViewCell.self)) { row, photo, cell in
                cell.bind(photo)
            }.addDisposableTo(self.disposeBag)
        
        self.collectionView.rx.modelSelected(PhotoModel.self).asControlEvent()
            .subscribe(onNext:{[weak self] photo in
                let nextVC = MapViewController.instatiate()
                nextVC.dataStream.value = photo
                self?.navigationController?.pushViewController(nextVC, animated: true)
            }).addDisposableTo(self.disposeBag)
        
        self.viewModel.state.asObservable()
            .subscribe(onNext: {[weak self] state in
                switch state {
                case .error( _ ):
                    let alert = KRAlertController(
                        title:"Error",
                        message:"Please check the communication environment")
                        .addAction(title: "OK")
                    self?.collectionView.allowsSelection = false
                    self?.collectionView.stopPullRefreshEver(false)
                    alert.showError(icon: true)
                    break
                default:
                    self?.collectionView.allowsSelection = true
                    break
                }
                
            }).addDisposableTo(self.disposeBag)
        
        
        
        self.viewModel.isReachable.asObservable().distinctUntilChanged()
            .subscribe(onNext: {[weak self] isReachable in
                if isReachable {
                    guard let code = self?.viewModel.state.value else { return }
                    switch code {
                    case .error:
                        self?.viewModel.getRequest()
                        break
                    default:
                        break
                    }
                }
            }).addDisposableTo(self.disposeBag)
    }
    
    fileprivate func refreshConfigure(){
        self.collectionView.addPullRefresh(refreshCompletion: { [weak self] in
            self?.viewModel.pageingCount.value = 1
            self?.viewModel.getRequest(completion: { [weak self] in
                self?.collectionView.stopPullRefreshEver(false)
            })
        })
    }
    
    fileprivate func infiniteScrollViewConfigure(){
        self.collectionView.infiniteScrollIndicatorMargin = 40
        
        self.collectionView.addInfiniteScroll(handler: { [weak self] _ in
            self?.viewModel.pageingCount.value += 1
            self?.viewModel.getRequest(completion: { [weak self] in
                self?.collectionView.finishInfiniteScroll()
            })
        })
    }
    
    class func instatiate() -> MainViewController{
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        return storyBoard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
    }

}
extension MainViewController: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > self.collectionView.contentSize.height {
            self.viewModel.pageingCount.value += 1
            self.viewModel.getRequest()
        }
    }
    
}


