//
//  CollectionsViewModel.swift
//  寶島旅社
//
//  Created by Eric Lin on 2024/7/21.
//  Copyright © 2024 Eric Lin. All rights reserved.
//

import Foundation
import MapKit

enum SegmentedControlOption: Int {
    case list = 0
    case map = 1
}

class CollectionsViewModel {
    
    // MARK: - Properties
    private var hotelDataModel: [Hotels] = []
    private var groupedHotels: [String: [Hotels]] = [:]
    private var cityNames: [String] = []
    
    var onHotelsLoaded: (() -> Void)?
    var onError: ((Error) -> Void)?
    
    var numberOfSections: Int {
        return cityNames.count
    }
    
    // MARK: - Public Methods
    func loadHotels() {
        LoadingPageView.shard.show()
        if let realmDataModels = RealmManager.shard?.getHotelDataModelsFromRealm() {
            self.hotelDataModel = realmDataModels
            self.groupAndSortHotelsByCity()
    
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                LoadingPageView.shard.dismiss()
                self.onHotelsLoaded?()
            }
        }
    }
    
    func numberOfRows(in section: Int) -> Int {
        guard section < self.cityNames.count else {
            return 0
        }
        
        let cityName = self.cityNames[section]
        return self.groupedHotels[cityName]?.count ?? 0
    }
    
    func hotel(at indexPath: IndexPath) -> Hotels? {
        guard indexPath.section < self.cityNames.count else {
            return nil
        }
        
        let cityName = self.cityNames[indexPath.section]
        return self.groupedHotels[cityName]?[indexPath.row]
    }
    
    // MARK: - Private Methods
    private func groupAndSortHotelsByCity() {
        self.groupedHotels = [:]
        
        for hotel in self.hotelDataModel {
            let city = hotel.city
            if var cityHotels = self.groupedHotels[city] {
                cityHotels.append(hotel)
                self.groupedHotels[city] = cityHotels
            } else {
                self.groupedHotels[city] = [hotel]
            }
        }
        
        let sortedGroupedHotels = self.groupedHotels.sorted { $0.key < $1.key }
        let sortedGroupedHotelsDictionary = Dictionary(uniqueKeysWithValues: sortedGroupedHotels)
        
        self.cityNames = sortedGroupedHotelsDictionary.keys.sorted()
    }
    
    func getHotelAnnotations() -> [HotelAnnotation] {
        return hotelDataModel.compactMap { hotel in
            let latitude = Double(hotel.positionLat) ?? 0.0
            let longitude = Double(hotel.positionLon) ?? 0.0
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            return HotelAnnotation(hotel: hotel, coordinate: coordinate)
        }
    }
}
