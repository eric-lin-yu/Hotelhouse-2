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
    static func make(dataModel: [HotelsArray]) -> MapSearchViewController {
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
    
    var dataModel: [HotelsArray] = []
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
        //        showBottomSheet()
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
    
    func showBottomSheet() {
        let vc = MapBottomSheetViewController.make()

        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .automatic
        if let sheet = nav.sheetPresentationController {
            if #available(iOS 16.0, *) {
                sheet.detents = [.medium(), .large(), .custom(resolver: { context in
                    context.maximumDetentValue * 0.2 })]
            } else {
                sheet.detents = [.medium(), .large()]
            }
            // 高於medium時，無法操作
            sheet.largestUndimmedDetentIdentifier = .medium
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 30.0
        }
        // 下滑關閉
        nav.isModalInPresentation = true
        present(nav, animated: true, completion: nil)
    }
}

// MARK: - MapDelegate
extension MapSearchViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    
    //地圖範圍變化時，重新讀取
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let region = mapView.region
        #if DEBUG
        print("Move to: \(region.center.latitude),\(region.center.longitude)")
        #endif
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
        
        // 新增一個地標,在user's旁
        var storeCoordinate = coordinate
        storeCoordinate.latitude += 0.0001
        storeCoordinate.longitude += 0.0001
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = storeCoordinate
        annotation.title = "Here!"
        
        var annotations: [MKPointAnnotation] = []
        
        if annotations.isEmpty {
            // add hotel annotation
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
            // 將所有標記add到mapView上
            mapView.addAnnotations(annotations)
        }
        
        // 更新圓圈標記的位置
        if let existingCircleOverlay = circleOverlay {
            mapView.removeOverlay(existingCircleOverlay)
        }
        
        let regionRadius = 1000.0
        let newCircle = MKCircle(center: coordinate, radius: regionRadius)
        circleOverlay = newCircle
        mapView.addOverlay(newCircle)
        
        manager.stopUpdatingLocation()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.userLocationImageView.isHidden = false
        }
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
            let vc = HotelDetailViewController.make(hotelData: dataModel[index])
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

