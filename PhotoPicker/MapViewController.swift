//
//  MapViewController.swift
//  PhotoPicker
//
//  Created by takahashi tomoki on 2017/02/13.
//  Copyright © 2017年 Tomoki Takahashi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MapKit
import KRAlertController
import CoreLocation
import APOfflineReverseGeocoding

final class MapViewController: UIViewController{
    fileprivate let viewModel = MapViewModel.shared
    
    let disposeBag = DisposeBag()
    
    var model = Variable<PhotoModel?>(nil)
    
    var dataStream = Variable<PhotoModel?>(nil)

    
    @IBOutlet var nearbyViewGesture: UITapGestureRecognizer!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var nextVCImageView: UIImageView!
    
    @IBOutlet weak var countryNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
        self.bind()
    }
    
    func configure(){
        self.navigationItem.title = "Place Detail"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        nearbyViewGesture.addTarget(self, action: #selector(self.tappedNearByView(_:)))
    }
    
    func bind(){
        self.dataStream.asObservable()
            .subscribe(onNext:{ [weak self] photo in
                self?.viewModel.photoData.value = photo
            }).addDisposableTo(self.disposeBag)
        
        self.viewModel.photoData.asObservable()
            .filter({ $0 != nil })
            .map({ $0! })
            .subscribe({ [weak self] photoModel in
                guard let photo = photoModel.element else { return }
                if let lat = photo.latitude, let lon = photo.longtitude {
                    let code = CLLocationCoordinate2DMake(Double(lat)!,Double(lon)!)
                    let span = MKCoordinateSpanMake(0.05, 0.05)
                    let region = MKCoordinateRegionMake(code, span)
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = code
                    self?.mapView.setRegion(region, animated: true)
                    self?.mapView.addAnnotation(annotation)
                    
                } else {
                    let alert = KRAlertController(title:"Error",message: "Can't get position").addAction(title: "OK")
                    
                    alert.showError(icon: true)
                }
                let url = URL(string: photo.url.flickrResolution("n"))
                self?.imageView.kf.setImage(with: url)
                self?.nextVCImageView.kf.setImage(with: url)
            }).addDisposableTo(self.disposeBag)
        
        
        self.viewModel.country.asObservable()
            .subscribe(onNext: {[weak self] country in
                if let name = country?.name {
                    self?.countryNameLabel.text = name
                } else {
                    self?.countryNameLabel.text = "Not Found..."
                }
            }).addDisposableTo(self.disposeBag)
        
        
        /* :TODO disconnectedで遷移した時に
            Presenting view controllers on detached view controllers is discouraged
            => self.view.window.rootViewController.present ...で遷移すべきだがライブラリで操作している
         */
        self.viewModel.state.asObservable()
            .subscribe(onNext:{state in
                switch state {
                case .error:
                    let alert = KRAlertController(
                        title:"Error",
                        message:"Please check the communication environment")
                        .addAction(title: "OK")
                    alert.showError(icon: true)
                default:
                    break
                }
                
            }).addDisposableTo(self.disposeBag)

    }

    class func instatiate() -> MapViewController {
        let storyBoard = UIStoryboard(name: "Map", bundle: nil)
        let instance = storyBoard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        return instance
    }
  
}
extension MapViewController {
    func tappedNearByView(_ tapGesture: UITapGestureRecognizer){
        let nextVC = NearPlaceViewController.instatiate()
        nextVC.dataStream.value = self.viewModel.photoData.value
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}

