//
//  CollectionsModel.swift
//  寶島旅社
//
//  Created by Eric Lin on 2024/7/21.
//  Copyright © 2024 Eric Lin. All rights reserved.
//

import Foundation
import MapKit

class HotelAnnotation: NSObject, MKAnnotation {
    let hotel: Hotels
    let coordinate: CLLocationCoordinate2D

    init(hotel: Hotels, coordinate: CLLocationCoordinate2D) {
        self.hotel = hotel
        self.coordinate = coordinate
        super.init()
    }

    var title: String? {
        return self.hotel.hotelName
    }

    var subtitle: String? {
        return self.hotel.streetAddress
    }
}
