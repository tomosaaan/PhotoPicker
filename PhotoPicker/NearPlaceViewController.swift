//
//  NearPlaceViewController.swift
//  PhotoPicker
//
//  Created by takahashi tomoki on 2017/02/14.
//  Copyright © 2017年 Tomoki Takahashi. All rights reserved.
//


import UIKit
import MapKit
import APOfflineReverseGeocoding
import RxSwift
import RxCocoa

final class NearPlaceViewController: UIViewController {
    fileprivate let viewModel = NearPlaceViewModel.shared
    
    let disposeBag = DisposeBag()
    
    var dataStream = Variable<PhotoModel?>(nil)
    
    @IBOutlet weak var mapView: MKMapView!

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configure()
        self.bind()
        self.viewModel.getRequestByPlace()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.viewModel.nearPlacePhotos.value = []
    }
    
    func configure(){
        self.navigationItem.title = "Nearby"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.collectionView.registerCell(type: MainCollectionViewCell.self)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.view.frame.width/3 - 1, height: self.view.frame.width/3 - 1)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        self.collectionView.collectionViewLayout = layout
    }
    
    func bind(){
        self.dataStream.asObservable()
            .subscribe(onNext:{[weak self] photo in
                self?.viewModel.selectedPhoto.value = photo
                self?.viewModel.getRequestByPlace()
            }).addDisposableTo(self.disposeBag)
        
        self.viewModel.selectedPhoto.asObservable()
            .filter{ $0 != nil}
            .map{ $0! }
            .subscribe(onNext:{[weak self] photo in
                if let lat = photo.latitude, let lon = photo.longtitude {
                    let code = CLLocationCoordinate2DMake(Double(lat)!,Double(lon)!)
                    let span = MKCoordinateSpanMake(0.05, 0.05)
                    let region = MKCoordinateRegionMake(code, span)
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = code
                    self?.mapView.setRegion(region, animated: true)
                    self?.mapView.addAnnotation(annotation)
                }
            }).addDisposableTo(self.disposeBag)
        
        
        self.viewModel.nearPlacePhotos.asDriver()
            .drive(self.collectionView.rx.items(cellIdentifier: "MainCollectionViewCell", cellType: MainCollectionViewCell.self)) { index, photo,cell in
                cell.bind(photo)
            }.addDisposableTo(self.disposeBag)
        
        self.collectionView.rx.modelSelected(PhotoModel.self).asControlEvent()
            .subscribe(onNext: {[weak self] photo in
                let nextVC = MapViewController.instatiate()
                nextVC.dataStream.value = photo
                self?.navigationController?.pushViewController(nextVC, animated: true)
            }).addDisposableTo(self.disposeBag)
        
        self.viewModel.isReachable.asObservable().distinctUntilChanged()
            .subscribe(onNext: {[weak self] isReachable in
                if isReachable {
                    guard let state = self?.viewModel.state.value else { return }
                    switch state {
                    case .error:
                        self?.viewModel.getRequestByPlace()
                    default:
                        break
                    }
                }
            }).addDisposableTo(self.disposeBag)

        
    }

    class func instatiate() -> NearPlaceViewController {
        let storyBoard = UIStoryboard(name: "NearPlace", bundle: nil)
        return storyBoard.instantiateInitialViewController() as! NearPlaceViewController
    }

    
}
