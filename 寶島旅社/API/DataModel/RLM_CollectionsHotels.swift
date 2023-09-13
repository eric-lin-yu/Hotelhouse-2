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
    
    convenience init(collectionsHotels: RLM_CollectionsHotels) {
        self.init()
        
        self.hotelID = collectionsHotels.hotelID
        self.hotelName = collectionsHotels.hotelName
        self.descriptionText = collectionsHotels.descriptionText
        self.px = collectionsHotels.px
        self.py = collectionsHotels.py
        self.grade = collectionsHotels.grade
        self.classData = collectionsHotels.classData
        self.add = collectionsHotels.add
        self.region = collectionsHotels.region
        self.town = collectionsHotels.town
        self.tel = collectionsHotels.tel
        self.gov.append(objectsIn: collectionsHotels.gov)
        self.website = collectionsHotels.website
        self.images.append(objectsIn: collectionsHotels.images)
        self.spec = collectionsHotels.spec
        self.serviceinfo = collectionsHotels.serviceinfo
        self.totalNumberofRooms = collectionsHotels.totalNumberofRooms
        self.accessibilityRooms = collectionsHotels.accessibilityRooms
        self.lowestPrice = collectionsHotels.lowestPrice
        self.ceilingPrice = collectionsHotels.ceilingPrice
        self.industryEmail = collectionsHotels.industryEmail
        self.totalNumberofPeople = collectionsHotels.totalNumberofPeople
        self.parkingSpace = collectionsHotels.parkingSpace
        self.parkinginfo = collectionsHotels.parkinginfo
    }
}

class RLM_HotelImages: Object {
    @Persisted var name: String
    @Persisted var imageDescription: String
    @Persisted var url: String
    
    convenience init(hotelImages: RLM_HotelImages) {
        self.init()
        
        self.name = hotelImages.name
        self.imageDescription = hotelImages.imageDescription
        self.url = hotelImages.url
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
    
    convenience init(organization: RLM_Organization) {
        self.init()
        
        self.name = organization.name
        self.classData = organization.classData
        self.taxCode = organization.taxCode
        self.agencyCode = organization.agencyCode
        self.url = organization.url
        self.telephones = organization.telephones
        self.mobilePhones = organization.mobilePhones
        self.faxes = organization.faxes
        self.email = organization.email
    }
}
