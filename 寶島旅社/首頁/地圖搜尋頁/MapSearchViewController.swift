//
//  MapSearchViewController.swift
//  寶島旅社
//
//  Created by Eric Lin on 2022/11/17.
//  Copyright © 2022 Eric Lin. All rights reserved.
//

import UIKit
import MapKit

class MapSearchViewController: UIViewController {
    static func make(dataModel: [HotelDataModel]) -> MapSearchViewController {
        let storyboard = UIStoryboard(name: "MapSearchStoryboard", bundle: nil)
        let vc: MapSearchViewController = storyboard.instantiateViewController(withIdentifier: "MapSearchIdentity") as! MapSearchViewController
        
        vc.dataModel = dataModel
        return vc
    }
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapSegmentedControl: UISegmentedControl! {
        didSet {
            //圓角
            mapSegmentedControl.layer.cornerRadius = 15
            mapSegmentedControl.layer.masksToBounds = true
            
            //邊框線條
            mapSegmentedControl.layer.borderWidth = 2
            mapSegmentedControl.layer.borderColor = UIColor.mainGreen.cgColor
            
            mapSegmentedControl.backgroundColor = UIColor.white
        }
    }
    @IBOutlet weak var userLocationImageView: UIImageView!
    @IBOutlet weak var backBtn: UIButton!
    
    var dataModel: [HotelDataModel] = []
    let manager = CLLocationManager()
    var circleOverlay: MKCircle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.activityType = .automotiveNavigation
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        manager.delegate = self
        mapView.delegate = self
        mapSegmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.mainRed,
                                                    .font: UIFont.boldSystemFont(ofSize: 20)], for: .normal)
        
        getUserLocation()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector((getUserLocation)))
        userLocationImageView.isUserInteractionEnabled = true
        userLocationImageView.addGestureRecognizer(tap)
        
        backBtn.addTarget(self, action: #selector(back), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 關閉navigation
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 開啟navigation
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @objc func getUserLocation() {
        switch manager.authorizationStatus {
        case .notDetermined:
            // 首次使用 向user取得隱私權限
            manager.requestWhenInUseAuthorization()
            
            getUserLocation()
        case .denied, .restricted:
            // user已拒絕過權限 或 未開啟定位功能
            let message = "如欲使用此功能，請開啟定位權限\n\n請至\n設定 > 隱私權與安全性 >\n定位服務 > 永許旅社取得您得位置。"
            showAlertClosure(title: "定位權限已關閉", message: message, okBtn: "前往開啟") {
                // 開啟設定
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
            }
            
        case .authorizedWhenInUse:
            // user接受
            manager.startUpdatingLocation()
            mapView.showsUserLocation = true
        default:
            break
        }
    }
    
    @IBAction func mayTypeChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            // 標準
            mapSegmentedControl.setTitle("標準", forSegmentAt: 0)
            mapView.mapType = .standard
        case 1:
            // 衛星
            mapSegmentedControl.setTitle("衛星", forSegmentAt: 1)
            mapView.mapType = .satellite
        case 2:
            // 混合
            mapSegmentedControl.setTitle("混合", forSegmentAt: 2)
            mapView.mapType = .hybrid
        default:
            break
        }
    }
}

// MARK: - MapDelegate
extension MapSearchViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        // 取得地圖的新位置
        let centerCoordinate = mapView.centerCoordinate
        let newCircle = MKCircle(center: centerCoordinate, radius: 1000.0)
        if let existingCircleOverlay = circleOverlay {
            mapView.removeOverlay(existingCircleOverlay)
        }
        
        // 添加新的圓圈到地圖上
        mapView.addOverlay(newCircle)
        circleOverlay = newCircle
        
        // 更新旅店資訊
        updateHotelAnnotations(for: centerCoordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latLocation = locations.last else {
            assertionFailure("Invalid location or coordinate.")
            return
        }
        let coordinate = latLocation.coordinate
        
        // 定位到map時,放大畫面到定位的位置
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01) // 放大的畫面經緯度範圍
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
        // 更新圓圈標記的位置
        if let existingCircleOverlay = circleOverlay {
            mapView.removeOverlay(existingCircleOverlay)
        }
        
        let regionRadius = 1000.0
        let newCircle = MKCircle(center: coordinate, radius: regionRadius)
        circleOverlay = newCircle
        mapView.addOverlay(newCircle)
        
        // 更新旅店資訊
        updateHotelAnnotations(for: coordinate)
        
        manager.stopUpdatingLocation()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.userLocationImageView.isHidden = false
        }
    }
    
    private func updateHotelAnnotations(for coordinate: CLLocationCoordinate2D) {
        // Add user location annotation
          let userLocationAnnotation = MKPointAnnotation()
          userLocationAnnotation.coordinate = coordinate
          userLocationAnnotation.title = "您的位置"
          mapView.addAnnotation(userLocationAnnotation)
        
        var annotations: [MKPointAnnotation] = []
        
        for index in 0..<dataModel.count {
            let py = self.dataModel[index].py as NSString
            let px = self.dataModel[index].px as NSString
            
            let hotelCoordinate = CLLocationCoordinate2D(latitude: px.doubleValue, longitude: py.doubleValue)
            
            // 確認座標是否在circle範圍內
            let center = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            let hotelLocation = CLLocation(latitude: hotelCoordinate.latitude, longitude: hotelCoordinate.longitude)
            let regionRadius = 1000.0
            
            if center.distance(from: hotelLocation) <= regionRadius {
                let annotation = MKPointAnnotation()
                annotation.coordinate = hotelCoordinate
                annotation.title = self.dataModel[index].hotelName
                
                if let classData = dataModel[index].classData.first,
                   let hotelClass = HotelClass(rawValue: classData) {
                    annotation.subtitle = hotelClass.description
                } else {
                    annotation.subtitle = "旅店未提供"
                }
                
                annotations.append(annotation)
            }
        }
        // 移除舊的標記
        mapView.removeAnnotations(mapView.annotations)
        // 將所有新的標記add到mapView上
        mapView.addAnnotations(annotations)
    }

    // annotation Cellout view
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // 檢查是否為使用者定位的標記，保持預設樣式
        if annotation is MKUserLocation {
            return nil
        }
        
        let identifier = "CustomAnnotationView"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            
            let button = UIButton(type: .detailDisclosure)
            button.tintColor = UIColor.orange
            annotationView?.rightCalloutAccessoryView = button
            
        } else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }
    
    // touch Callout 面板
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        var annotation = MKPointAnnotation()
        if let anAnnotation = view.annotation as? MKPointAnnotation {
            annotation = anAnnotation
        }
        #if DEBUG
        let selectedTitle = "\(annotation.title ?? "")"
        print("You selected index: \(selectedTitle)")
        #endif
        
        //依dataModel.name == annotation.title，抓取其index
        if let index = self.dataModel.firstIndex(where: { $0.hotelName == annotation.title }) {
            let vc = HotelDetailViewController(hotelDataModel: dataModel[index])
            vc.hidesBottomBarWhenPushed = true
            
            self.navigationController?.pushViewController(vc, animated: true)
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(self.back))
        }
    }
    
    // 繪製圓圈
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let circleRenderer = MKCircleRenderer(overlay: overlay)
        circleRenderer.strokeColor = UIColor.red
        circleRenderer.lineWidth = 1.0
        return circleRenderer
    }
    
}

