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
    @Persisted var hotelName: String
    @Persisted var descriptionText: String
    @Persisted var px: String
    @Persisted var py: String
    @Persisted var grade: String
    @Persisted var classData: List<Int>
    @Persisted var add: String
    @Persisted var region: String
    @Persisted var town: String
    @Persisted var tel: List<String>
    @Persisted var gov: List<RLM_Organization>
    @Persisted var website: String
    @Persisted var images: List<RLM_HotelImages>
    @Persisted var spec: String
    @Persisted var serviceinfo: String
    @Persisted var totalNumberofRooms: String
    @Persisted var accessibilityRooms: String
    @Persisted var lowestPrice: String
    @Persisted var ceilingPrice: String
    @Persisted var industryEmail: String
    @Persisted var totalNumberofPeople: String
    @Persisted var parkingSpace: String
    @Persisted var parkinginfo: String
    
    convenience init( hotelID: String,
                     hotelName: String,
                     descriptionText: String,
                     px: String,
                     py: String,
                     grade: String,
                     classData: [Int],
                     add: String,
                     region: String,
                     town: String,
                     tel: [String],
                     gov: [RLM_Organization],
                     website: String,
                     images: [RLM_HotelImages],
                     spec: String,
                     serviceinfo: String,
                     totalNumberofRooms: String,
                     accessibilityRooms: String,
                     lowestPrice: String,
                     ceilingPrice: String,
                     industryEmail: String,
                     totalNumberofPeople: String,
                     parkingSpace: String,
                     parkinginfo: String) {
        self.init()
        
        self.hotelID = hotelID
        self.hotelName = hotelName
        self.descriptionText = descriptionText
        self.px = px
        self.py = py
        self.grade = grade
        self.classData.append(objectsIn: classData)
        self.add = add
        self.region = region
        self.town = town
        self.tel.append(objectsIn: tel)
        self.gov.append(objectsIn: gov)
        self.website = website
        self.images.append(objectsIn: images)
        self.spec = spec
        self.serviceinfo = serviceinfo
        self.totalNumberofRooms = totalNumberofRooms
        self.accessibilityRooms = accessibilityRooms
        self.lowestPrice = lowestPrice
        self.ceilingPrice = ceilingPrice
        self.industryEmail = industryEmail
        self.totalNumberofPeople = totalNumberofPeople
        self.parkingSpace = parkingSpace
        self.parkinginfo = parkinginfo
    }
}

class RLM_HotelImages: Object {
    @Persisted var name: String
    @Persisted var imageDescription: String
    @Persisted var url: String
    
    convenience init( name: String,
                     imageDescription: String,
                     url: String) {
        self.init()
        
        self.name = name
        self.imageDescription = imageDescription
        self.url = url
    }
}

class RLM_Organization: Object {
    @Persisted var name: String
    @Persisted var classData: String
    @Persisted var taxCode: String
    @Persisted var agencyCode: String
    @Persisted var url: String
    @Persisted var telephones: List<String>
    @Persisted var mobilePhones: List<String>
    @Persisted var faxes: List<String>
    @Persisted var email: String
    
    convenience init( name: String,
                     classData: String,
                     taxCode: String,
                     agencyCode: String,
                     url: String,
                     telephones: [String],
                     mobilePhones: [String],
                     faxes: [String],
                     email: String) {
        self.init()
        
        self.name = name
        self.classData = classData
        self.taxCode = taxCode
        self.agencyCode = agencyCode
        self.url = url
        self.telephones.append(objectsIn: telephones)
        self.mobilePhones.append(objectsIn: mobilePhones)
        self.faxes.append(objectsIn: faxes)
        self.email = email
    }
}
