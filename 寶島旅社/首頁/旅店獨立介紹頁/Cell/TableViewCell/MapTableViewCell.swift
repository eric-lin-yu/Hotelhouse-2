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
    
    func configure(dataModel: HotelsArray) {
        regionLabel.text = dataModel.region
        townLabel.text = dataModel.town
        
        let geoCoder = CLGeocoder()  //取得位置
        geoCoder.geocodeAddressString(dataModel.add) { (placemarks, error) in
            if let error = error {
                print("地址轉換失敗：\(error.localizedDescription)")
            }
            
            let annotation = MKPointAnnotation()  //加入標記
            annotation.title = dataModel.hotelName
            
            if placemarks != nil {
                let placemark = placemarks?[0] //取得地點標記
                if let location = placemark?.location {
                    annotation.coordinate = location.coordinate
                }
            } else {
                //改抓經、緯度
                let py = dataModel.py as NSString
                let px = dataModel.px as NSString
                
                annotation.coordinate = CLLocationCoordinate2D(latitude: py.doubleValue,
                                                               longitude: px.doubleValue)
            }
            self.mapView.addAnnotation(annotation)
            self.mapView.showAnnotations([annotation], animated: true)
            self.mapView.selectAnnotation(annotation, animated: true)
            
            //設定縮放
            let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 300, longitudinalMeters: 300)
            self.mapView.setRegion(region, animated: false)
            
        }
    }
    
}
