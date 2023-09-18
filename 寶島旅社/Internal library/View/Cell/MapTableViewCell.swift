//
//  MapTableViewCell.swift
//  寶島旅社
//
//  Created by wistronits on 2022/10/21.
//  Copyright © 2022 Eric Lin. All rights reserved.
//

import UIKit
import MapKit

class MapTableViewCell: UITableViewCell {
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var roundFramView: UIView! {
        didSet {
            roundFramView.roundFrameView(roundView: roundFramView)
        }
    }
    //  "Region": "南投縣", "Town": "埔里鎮"
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var townLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configure(dataModel: Hotels) {
        regionLabel.text = dataModel.region
        townLabel.text = dataModel.town
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(dataModel.add) { (placemarks, error) in
            if let error = error {
                print("地址轉換失敗：\(error.localizedDescription)")
                // 使用備用的座標或其他方法進行處理
                let px = dataModel.px as NSString
                let py = dataModel.py as NSString
                
                let annotation = MKPointAnnotation()
                annotation.title = dataModel.hotelName
                annotation.coordinate = CLLocationCoordinate2D(latitude: px.doubleValue,
                                                               longitude: py.doubleValue)
                
                self.mapView.addAnnotation(annotation)
                self.mapView.showAnnotations([annotation], animated: true)
                self.mapView.selectAnnotation(annotation, animated: true)
                
                let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 300, longitudinalMeters: 300)
                self.mapView.setRegion(region, animated: false)
                
                return
            }
            
            if let location = placemarks?.first?.location {
                let annotation = MKPointAnnotation()
                annotation.title = dataModel.hotelName
                annotation.coordinate = location.coordinate
                
                self.mapView.addAnnotation(annotation)
                self.mapView.showAnnotations([annotation], animated: true)
                self.mapView.selectAnnotation(annotation, animated: true)
                
                let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 300, longitudinalMeters: 300)
                self.mapView.setRegion(region, animated: false)
            }
        }
    }
    
}
