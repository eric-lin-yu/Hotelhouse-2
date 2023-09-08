//
//  RLM_DataModel.swift
//  寶島旅社
//
//  Created by Eric Lin on 2023/7/28.
//  Copyright © 2023 Eric Lin. All rights reserved.
//

import Foundation
import RealmSwift

class RLM_CollectionsHotels: Object {
    @Persisted var hotelID: String
    @Persisted var controller: List<String>
    @Persisted var images: List<RLM_HotelImages>
    //TODO: 待新增 ...

    convenience init(hotelID: String, controller: [String], images: [RLM_HotelImages]) {
        self.init()
        
        self.hotelID = hotelID
        self.controller.append(objectsIn: controller)
        self.images.append(objectsIn: images)
    }
}

class RLM_HotelImages: Object {
    @Persisted var name: String
    @Persisted var imageDescription: String
    @Persisted var url: String
    
    convenience init(name: String, imageDescription: String, url: String) {
        self.init()
        
        self.name = name
        self.imageDescription = imageDescription
        self.url = url
    }
}
