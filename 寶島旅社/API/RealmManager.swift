//
//  RealmConfigurator.swift
//  CathayWalletPodTest
//
//  Created by wistronits on 2023/3/29.
//

import Foundation
import RealmSwift
import UIKit

class RealmManager {
    enum RealmError: Error {
        case createRealmObjectFail
    }
    
    // MARK: - Property
    static let shard: RealmManager? = makeSharedInstance()
    
    let sharedRealmObjecgt: Realm
    
    // Realm Data異動調整時，Version記得調整
    private static let schemaVersion: UInt64 = 1
    
    private let realmConfig: Realm.Configuration
    
    private init() throws {
        do {
            self.realmConfig = RealmManager.createConfigure()
            self.sharedRealmObjecgt = try Realm(configuration: self.realmConfig)
        } catch let error as NSError {
            print(("Error opening realm: \(error.localizedDescription)"))
            throw RealmError.createRealmObjectFail
        }
    }

    func write(_ block: (Realm) throws -> Void) throws {
        try self.sharedRealmObjecgt.write {
            try block(sharedRealmObjecgt)
        }
    }

    /// 檢索指定物件類型的 Realm 結果叢集
    /// - Parameter objectType: 指定的物件類型。
    /// - Returns: 指定物件類型的 Realm 結果叢集。
    func objects<ObjectType: Object>(_ objectType: ObjectType.Type) -> Results<ObjectType> {
        return self.sharedRealmObjecgt.objects(objectType)
    }
    
    public func reset() {
        self.sharedRealmObjecgt.invalidate()
    }

    // MARK: - Private Function
    private static func makeSharedInstance() -> RealmManager? {
        do {
            let instance = try RealmManager.init()
            return instance
        } catch {
            // 初始化失敗的錯誤處理邏輯
            print("無法創建 Singleton 實例：\(error)")
            return nil
        }
    }
    
    /// 創建 Realm 資料庫的配置。
    /// - 配置包括：檔案路徑、加密金鑰、模式版本以及資料庫遷移的處理。
    /// - 檔案路徑由 getRealmFolderPath 方法取得，並根據 encryptionKey 的加密 key 來建立對應的資料夾和檔案名稱。
    /// - 加密 key 由 getEncryptionKey 方法取得。
    /// - Returns: Realm 資料庫的配置。
    private static func createConfigure() -> Realm.Configuration {
        let encryptionKey = getEncryptionKey()
        let folderPath = getRealmFolderPath(encryptionKey: encryptionKey)
        
        let config = Realm.Configuration(
            fileURL: URL(fileURLWithPath: folderPath),
            encryptionKey: encryptionKey,
            schemaVersion: schemaVersion,
            migrationBlock: { migration, oldSchemaVersion in
                #if DEBUG
                if oldSchemaVersion < schemaVersion {
                    print("\n -------- Realm ReloadData -------- \n")
                    defer { print("\n ---------- END ---------- \n") }
                    print("版本替換： \(oldSchemaVersion) -> \(String(describing: schemaVersion))")
                    // ... 異動調整
                }
                #endif
            })
        return config
    }
    
    /// 取得 Realm 資料庫的儲存路徑。
    /// - 資料庫會根據 encryptionKey 來當作資料夾名稱。
    /// - 資料庫的檔案名稱為 "data.realm"，位於由 encryptionKey 建立的資料夾中。
    /// - 如果資料夾不存在，才會嘗試建立。
    /// - Parameter encryptionKey: 長度為 64 個字節的加密 key，用於建立資料夾名稱。
    /// - Returns: 資料庫檔案的完整路徑。
    private static func getRealmFolderPath(encryptionKey: Data) -> String {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let folderName = encryptionKey.hexString // 使用encryptionKey來建立資料夾名稱
        let folderURL = documentsURL.appendingPathComponent(folderName)
        let filePath = folderURL.appendingPathComponent("data.realm").path
        
        if !FileManager.default.fileExists(atPath: folderURL.path) {
            try? FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
        }
        return filePath
    }
    
    private static func getEncryptionKey() -> Data {
        let deviceUUID = UIDevice.current.identifierForVendor?.uuidString ?? ""
        let encryptionKey = deviceUUID.strToSha256().map { UInt8($0) }
        
        // 如果 keyData 長度不足 64 個字元，則使用 0x00 填滿至 64 個字元
        var expandedKeyData = Data(count: 64)
        expandedKeyData.withUnsafeMutableBytes { expandedBytes in
            encryptionKey.withUnsafeBufferPointer { keyBytes in
                expandedBytes.baseAddress?.copyMemory(from: keyBytes.baseAddress!, byteCount: min(64, encryptionKey.count))
            }
        }
        return expandedKeyData
    }
    
    func addHotelDataModelToRealm(_ hotelDataModel: Hotels) {
        guard let realm = RealmManager.shard else {
            return
        }
        
        // 檢查是否已建立於 Realm 中
        if realm.objects(RLM_CollectionsHotels.self).filter("hotelID == %@", hotelDataModel.hotelID).first != nil {
            ResponseHandler.presentAlertHandler(message: "此旅店您已收藏於資料庫")
            return
        }
        
        do {
            // get gov Data
            let govArray = hotelDataModel.gov.map { RLM_Organization(name: $0.name,
                                                                     classData: $0.classData,
                                                                     taxCode: $0.taxCode ?? "",
                                                                     agencyCode: $0.agencyCode ?? "",
                                                                     url: $0.url ?? "",
                                                                     telephones: $0.telephones ?? [],
                                                                     mobilePhones: $0.mobilePhones ?? [],
                                                                     faxes: $0.faxes ?? [],
                                                                     email: $0.email ?? "") }
            
            // get image data
            let hotelImageArray = hotelDataModel.images.map { RLM_HotelImages(name: $0.name,
                                                                              imageDescription: $0.imageDescription,
                                                                              url: $0.url) }
            
            let realmData = RLM_CollectionsHotels(hotelID: hotelDataModel.hotelID,
                                                  hotelName: hotelDataModel.hotelName,
                                                  descriptionText: hotelDataModel.description,
                                                  px: hotelDataModel.px,
                                                  py: hotelDataModel.py,
                                                  grade: hotelDataModel.grade,
                                                  classData: hotelDataModel.classData,
                                                  add: hotelDataModel.add,
                                                  region: hotelDataModel.region,
                                                  town: hotelDataModel.town,
                                                  tel: hotelDataModel.tel,
                                                  gov: govArray,
                                                  website: hotelDataModel.website,
                                                  images: hotelImageArray,
                                                  spec: hotelDataModel.spec,
                                                  serviceinfo: hotelDataModel.serviceinfo,
                                                  totalNumberofRooms: hotelDataModel.totalNumberofRooms,
                                                  accessibilityRooms: hotelDataModel.accessibilityRooms,
                                                  lowestPrice: hotelDataModel.lowestPrice,
                                                  ceilingPrice: hotelDataModel.ceilingPrice,
                                                  industryEmail: hotelDataModel.industryEmail,
                                                  totalNumberofPeople: hotelDataModel.totalNumberofPeople,
                                                  parkingSpace: hotelDataModel.parkingSpace,
                                                  parkinginfo: hotelDataModel.parkinginfo)
            
            try realm.write { realm in
                realm.add(realmData)
                ResponseHandler.presentAlertHandler(message: "旅店新增成功")
            }
        } catch {
            ResponseHandler.errorHandler(errorString: "發生了一些問題，資料新增失敗")
        }
    }
    
    func getHotelDataModelsFromRealm() -> [Hotels] {
        guard let realm = RealmManager.shard else {
            return []
        }
        
        let realmDataArray = realm.objects(RLM_CollectionsHotels.self)
        
        let hotelDataModels = realmDataArray.compactMap { realmData in
            let govArray = realmData.gov.map { Organization(name: $0.name,
                                                            classData: $0.classData,
                                                            taxCode: $0.taxCode,
                                                            agencyCode: $0.agencyCode,
                                                            url: $0.url,
                                                            telephones: Array($0.telephones),
                                                            mobilePhones: Array($0.mobilePhones),
                                                            faxes: Array($0.faxes),
                                                            email: $0.email) }
            
            let imagesArray = realmData.images.map { HotelImages(name: $0.name,
                                                                 imageDescription: $0.imageDescription,
                                                                 url: $0.url) }
            
            return Hotels(hotelID: realmData.hotelID,
                                  hotelName: realmData.hotelName,
                                  description: realmData.descriptionText,
                                  px: realmData.px,
                                  py: realmData.py,
                                  grade: realmData.grade,
                                  classData: Array(realmData.classData),
                                  add: realmData.add,
                                  region: realmData.region,
                                  town: realmData.town,
                                  tel: Array(realmData.tel),
                                  gov: Array(govArray),
                                  website: realmData.website,
                                  images: Array(imagesArray),
                                  spec: realmData.spec,
                                  serviceinfo: realmData.serviceinfo,
                                  totalNumberofRooms: realmData.totalNumberofRooms,
                                  accessibilityRooms: realmData.accessibilityRooms,
                                  lowestPrice: realmData.lowestPrice,
                                  ceilingPrice: realmData.ceilingPrice,
                                  industryEmail: realmData.industryEmail,
                                  totalNumberofPeople: realmData.totalNumberofPeople,
                                  parkingSpace: realmData.parkingSpace,
                                  parkinginfo: realmData.parkinginfo)
        }
        return Array(hotelDataModels)
    }
}
