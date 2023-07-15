//
//  DataModel.swift
//  寶島旅社
//
//  Created by Eric Lin on 2022/10/12.
//  Copyright © 2022 Eric Lin. All rights reserved.
//

import Foundation
import SwiftyJSON

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

struct DataInfoArray {
    let hotelID: String
    let hotelName: String
    /// 旅館介紹
    let description: String
    let px: String
    let py: String
    /// 星級
    let grade: String
    /// 旅館類別 (1.國際觀光旅館、2.一般觀光旅館、3.一般旅館、4.民宿)
    let classData: String
    let add: String
    /// 縣市
    let region: String
    let town: String
    let tel: String
    /// 旅館民宿之管理權責單位代碼
    let gov: String
    /// 官網
    let website: String
    /// image1.URL
    let picture1: String
    /// image1.說明
    let picdescribe1: String
    /// image2.URL
    let picture2: String
    /// image2.說明
    let picdescribe2: String
    /// image3.URL
    let picture3: String
    /// image3.說明
    let picdescribe3: String
    /// 補充說明
    let spec: String
    /// 服務說明
    let serviceinfo: String
    /// 總房數
    let totalNumberofRooms: String
    /// 無障礙客房
    let accessibilityRooms: String
    /// 最低價格
    let lowestPrice: String
    /// 最高價格
    let ceilingPrice: String
    /// 信箱
    let industryEmail: String
    /// 總容納人數
    let totalNumberofPeople: String
    /// 停車位
    let parkingSpace: String
    /// 停車位說明
    let parkinginfo: String
    
    init (json: JSON) {
        /*
         "PostalAddress": {
           "City": "南投縣",
           "CityCode": "10008",
           "Town": "埔里鎮",
           "TownCode": "10008020",
           "ZipCode": "545",
           "StreetAddress": "水頭里水頭路1號"
         },
         */
        hotelID = json["HotelID"].stringValue
        hotelName = json["HotelName"].stringValue
        description = json["Description"].stringValue
        px = json["PositionLat"].stringValue
        py = json["PositionLon"].stringValue
        
        grade = json["Grade"].stringValue
        classData = json["Class"].stringValue
        add = json["PostalAddress"]["StreetAddress"].stringValue
        region = json["Region"].stringValue
        town = json["PostalAddress"]["Town"].stringValue
        tel = json["Tel"].stringValue
        gov = json["Gov"].stringValue
        website = json["Website"].stringValue
        picture1 = json["Picture1"].stringValue
        picture2 = json["Picture2"].stringValue
        picture3 = json["Picture3"].stringValue
        picdescribe1 = json["Picdescribe1"].stringValue
        picdescribe2 = json["Picdescribe2"].stringValue
        picdescribe3 = json["Picdescribe3"].stringValue
        spec = json["Spec"].stringValue
        serviceinfo = json["Serviceinfo"].stringValue
        totalNumberofRooms = json["TotalNumberofRooms"].stringValue
        accessibilityRooms = json["AccessibilityRooms"].stringValue
        lowestPrice = json["LowestPrice"].stringValue
        ceilingPrice = json["CeilingPrice"].stringValue
        industryEmail = json["IndustryEmail"].stringValue
        totalNumberofPeople = json["TotalNumberofPeople"].stringValue
        parkingSpace = json["ParkingSpace"].stringValue
        parkinginfo = json["Parkinginfo"].stringValue
    }
}

struct HotelBookDataModel {
    let updateInterval: String
    let language: String
    let providerID: String
    let updatetime: String
    var dataArray: [DataInfoArray] = []
    
    init (json: JSON) {
        updateInterval = json["UpdateInterval"].stringValue
        language = json["Language"].stringValue
        providerID = json["ProviderID"].stringValue
        updatetime = json["Updatetime"].stringValue
        
        let arr = json["Hotels"].arrayValue
        arr.forEach { (element) in
            self.dataArray.append(DataInfoArray(json: element))
        }
    }
}

