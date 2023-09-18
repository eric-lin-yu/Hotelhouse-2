//
//  DataModel.swift
//  寶島旅社
//
//  Created by Eric Lin on 2022/10/12.
//  Copyright © 2022 Eric Lin. All rights reserved.
//

import Foundation
import SwiftyJSON

struct HotelDataModel {
    let updateInterval: String
    let language: String
    let providerID: String
    let updatetime: String
    var hotels: [Hotels] = []
    
    init (json: JSON) {
        updateInterval = json["UpdateInterval"].stringValue
        language = json["Language"].stringValue
        providerID = json["ProviderID"].stringValue
        updatetime = json["Updatetime"].stringValue
        
        let hotelsArray = json["Hotels"].arrayValue
        hotels = hotelsArray.map { Hotels(json: $0) }
    }
}

 /*
  "Hotels": [
    {
      "AlternateNames": [],
      "Description": "位於南投縣的民宿",
      "PositionLat": 23.935199,
      "PositionLon": 120.970365,
      "Geometry": null,
      "HotelClasses": [4],
      "HotelStars": 0,
      "TaiwanHost": 0,
      "PostalAddress": {
        "City": "南投縣",
        "CityCode": "10008",
        "Town": "埔里鎮",
        "TownCode": "10008020",
        "ZipCode": "545",
        "StreetAddress": "水頭里水頭路1號"
      },
      "Telephones": [
        {
          "Tel": "(049)2927101"
        }
      ],
      "Images": [
        {
          "Name": null,
          "Description": "外觀",
          "URL": "https://taiwan.taiwanstay.net.tw/twpic/15545.jpg",
          "Width": null,
          "Height": null,
          "Keywords": []
        }
      ],
      "Organizations": [
        {
          "Name": "交通部觀光局",
          "Class": "Provider",
          "TaxCode": null,
          "AgencyCode": "315080000H",
          "URL": null,
          "Telephones": null,
          "MobilePhones": null,
          "Faxes": null,
          "Email": null
        }
      ],
      "ServiceTimeInfo": "",
      "TrafficInfo": "",
      "ParkingInfo": "車位:小客車0輛、機車0輛、大客車0輛",
      "Facilities": [],
      "ServiceStatus": 1,
      "PaymentMethods": [],
      "LocatedCities": [],
      "WebsiteURL": "",
      "ReservationURLs": [],
      "MapURLs": [],
      "SameAsURLs": [],
      "SocialMediaURLs": [],
      "RoomInfo": "",
      "ServiceInfo": "自行車友善旅宿",
      "TotalRooms": 3,
      "LowestPrice": 2200,
      "CeilingPrice": 3600,
      "TotalCapacity": 10,
      "AccessibleRooms": 0,
      "Toilets": null,
      "LiftingEquipments": null,
      "ParkingSpaces": 0,
      "CheckTimes": null,
      "Remarks": "",
      "UpdateTime": "2023-06-27T01:32:03+08:00"
    },
  */

struct Hotels {
    let hotelID: String
    /// 名稱
    let hotelName: String
    /// 描述
    let description: String
    /// 緯度
    let px: String
    /// 經度
    let py: String
    /// 星級
    let grade: String
    /// 酒店類別
    let classData: [Int]
    /// 地址
    let add: String
    /// 地區
    let region: String
    /// 城鎮
    let town: String
    /// 電話
    let tel: [String]
    /// 管理機構
    let gov: [Organization]
    /// 官網
    let website: String
    let images: [HotelImages]
    /// 特殊規格
    let spec: String
    /// 服務信息
    let serviceinfo: String
    /// 總客房數量
    let totalNumberofRooms: String
    /// 無障礙客房數量
    let accessibilityRooms: String
    /// 最低價格
    let lowestPrice: String
    /// 最高價格
    let ceilingPrice: String
    /// 官方電子信箱
    let industryEmail: String
    /// 總人數容納量
    let totalNumberofPeople: String
    /// 停車位
    let parkingSpace: String
    /// 停車位訊息
    let parkinginfo: String
    
    
    init(json: JSON) {
        hotelID = json["HotelID"].stringValue
        hotelName = json["HotelName"].stringValue
        description = json["Description"].stringValue
        px = json["PositionLat"].stringValue
        py = json["PositionLon"].stringValue
        grade = json["HotelStars"].stringValue
        
        let classesArray = json["HotelClasses"].arrayValue
        classData = classesArray.map { $0.intValue }
        
        add = json["PostalAddress"]["StreetAddress"].stringValue
        region = json["PostalAddress"]["City"].stringValue
        town = json["PostalAddress"]["Town"].stringValue
        tel = json["Telephones"].arrayValue.map { $0["Tel"].stringValue }
        
        gov = json["Organizations"].arrayValue.map { Organization(json: $0) }
        
        website = json["WebsiteURL"].stringValue
        spec = json["Spec"].stringValue
        serviceinfo = json["ServiceInfo"].stringValue
        totalNumberofRooms = json["TotalRooms"].stringValue
        accessibilityRooms = json["AccessibleRooms"].stringValue
        lowestPrice = json["LowestPrice"].stringValue
        ceilingPrice = json["CeilingPrice"].stringValue
        industryEmail = json["IndustryEmail"].stringValue
        totalNumberofPeople = json["TotalCapacity"].stringValue
        parkingSpace = json["ParkingSpaces"].stringValue
        parkinginfo = json["ParkingInfo"].stringValue
        
        let imagesArray = json["Images"].arrayValue
        images = imagesArray.map { HotelImages(json: $0) }
    }
    
    
    init( hotelID: String,
          hotelName: String,
          description: String,
          px: String,
          py: String,
          grade: String,
          classData: [Int],
          add: String,
          region: String,
          town: String,
          tel: [String],
          gov: [Organization],
          website: String,
          images: [HotelImages],
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
        
        self.hotelID = hotelID
        self.hotelName = hotelName
        self.description = description
        self.px = px
        self.py = py
        self.grade = grade
        self.classData = classData
        self.add = add
        self.region = region
        self.town = town
        self.tel = tel
        self.gov = gov
        self.website = website
        self.images = images
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

struct Organization {
    let name: String
    let classData: String
    let taxCode: String?
    let agencyCode: String?
    let url: String?
    let telephones: [String]?
    let mobilePhones: [String]?
    let faxes: [String]?
    let email: String?
    
    init(json: JSON) {
        name = json["Name"].stringValue
        classData = json["Class"].stringValue
        taxCode = json["TaxCode"].stringValue
        agencyCode = json["AgencyCode"].stringValue
        url = json["URL"].stringValue
        telephones = json["Telephones"].arrayValue.map { $0["Tel"].stringValue }
        mobilePhones = json["MobilePhones"].arrayValue.map { $0["Tel"].stringValue }
        faxes = json["Faxes"].arrayValue.map { $0["Tel"].stringValue }
        email = json["Email"].stringValue
    }
    init(name: String,
         classData: String,
         taxCode: String,
         agencyCode: String,
         url: String,
         telephones: [String],
         mobilePhones: [String],
         faxes: [String],
         email: String) {
        
        self.name = name
        self.classData = classData
        self.taxCode = taxCode
        self.agencyCode = agencyCode
        self.url = url
        self.telephones = telephones
        self.mobilePhones = mobilePhones
        self.faxes = faxes
        self.email = email
    }
}

struct HotelImages {
    let name: String
    let imageDescription: String
    let url: String
    
    init(json: JSON) {
        name = json["Name"].stringValue
        imageDescription = json["Description"].stringValue
        url = json["URL"].stringValue
    }
    
    init(name: String,
         imageDescription: String,
         url: String) {
        
        self.name = name
        self.imageDescription = imageDescription
        self.url = url
    }
}

enum HotelClass: Int {
    case international = 1
    case generalTourist = 2
    case generalHotel = 3
    case homestay = 4
    
    var description: String {
        switch self {
        case .international:
            return "國際觀光旅館"
        case .generalTourist:
            return "一般觀光旅館"
        case .generalHotel:
            return "一般旅館"
        case .homestay:
            return "民宿"
        }
    }
}

