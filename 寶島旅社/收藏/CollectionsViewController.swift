//
//  CollectionsViewController.swift
//  寶島旅社
//
//  Created by wistronits on 2023/7/28.
//  Copyright © 2023 Eric Lin. All rights reserved.
//

import UIKit
import MapKit

class CollectionsViewController: UIViewController {
    private var hotelDataModel: [Hotels] = []
    private var groupedHotels: [String: [Hotels]] = [:]
    private let manager = CLLocationManager()
    
    // constraint Spacing
    private let spacing: CGFloat = 20
    private let innerLayerSpacing: CGFloat = 10
    private let searchiconBtnSize: CGFloat = 24
    private let segmentedControlSize: CGFloat = 40
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    //MARK: - UI
    private let searchView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let searchTextFiled: UITextField = {
        let textField = UITextField()
        textField.textColor = .white
        textField.backgroundColor = .sageGreen
        textField.font = .systemFont(ofSize: 17)
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 17)
        ]
        let attributedPlaceholder = NSAttributedString(string: "Search", attributes: attributes)
        textField.attributedPlaceholder = attributedPlaceholder

        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let searchiconBtn: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "iconSearch")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        segmentedControl.insertSegment(withTitle: "列表", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "地圖", at: 1, animated: false)
        
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = .sageGreen
        
        // 置中
        let paragraphStyle = NSMutableParagraphStyle()
           paragraphStyle.alignment = .center
        
        let normalTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 17),
            .paragraphStyle: paragraphStyle
        ]
        
        let selectedTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.orangeRed,
            .font: UIFont.systemFont(ofSize: 17),
            .paragraphStyle: paragraphStyle
        ]
        
        segmentedControl.setTitleTextAttributes(normalTextAttributes, for: .normal)
        segmentedControl.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.isHidden = true
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    //MARK: - setup
    private func setupViews() {
        view.backgroundColor = .white
        let viewsToAdd: [UIView] = [
            searchView,
            segmentedControl,
            tableView,
            mapView,
        ]
        viewsToAdd.forEach { view.addSubview($0) }
        
        let viewsToAddSearchView: [UIView] = [
            searchTextFiled,
            searchiconBtn,
        ]
        viewsToAddSearchView.forEach { searchView.addSubview($0) }
    }
    
    private func setupConstraint() {
        let topSafeArea = view.safeAreaLayoutGuide.topAnchor
        let leftSafeArea = view.safeAreaLayoutGuide.leftAnchor
        let rightSafeArea = view.safeAreaLayoutGuide.rightAnchor
        let bottomSafeArea = view.safeAreaLayoutGuide.bottomAnchor
        
        NSLayoutConstraint.activate([
            searchView.topAnchor.constraint(equalTo: topSafeArea, constant: spacing),
            searchView.leftAnchor.constraint(equalTo: leftSafeArea, constant: spacing),
            searchView.rightAnchor.constraint(equalTo: rightSafeArea, constant: -spacing),
            
            searchTextFiled.topAnchor.constraint(equalTo: searchView.topAnchor),
            searchTextFiled.leftAnchor.constraint(equalTo: searchView.leftAnchor),
            searchTextFiled.rightAnchor.constraint(equalTo: searchView.rightAnchor),
            searchTextFiled.bottomAnchor.constraint(equalTo: searchView.bottomAnchor),
            
            searchiconBtn.topAnchor.constraint(equalTo: searchView.topAnchor, constant: innerLayerSpacing),
            searchiconBtn.rightAnchor.constraint(equalTo: searchView.rightAnchor, constant: -innerLayerSpacing),
            searchiconBtn.bottomAnchor.constraint(equalTo: searchView.bottomAnchor, constant: -innerLayerSpacing),
            searchiconBtn.centerYAnchor.constraint(equalTo: searchView.centerYAnchor),
            searchiconBtn.heightAnchor.constraint(equalToConstant: searchiconBtnSize),
            searchiconBtn.widthAnchor.constraint(equalToConstant: searchiconBtnSize),
        
            segmentedControl.topAnchor.constraint(equalTo: searchView.bottomAnchor, constant: innerLayerSpacing),
            segmentedControl.leftAnchor.constraint(equalTo: searchView.leftAnchor),
            segmentedControl.rightAnchor.constraint(equalTo: searchView.rightAnchor),
            segmentedControl.heightAnchor.constraint(equalToConstant: segmentedControlSize),
            
            tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: innerLayerSpacing),
            tableView.leftAnchor.constraint(equalTo: leftSafeArea),
            tableView.rightAnchor.constraint(equalTo: rightSafeArea),
            tableView.bottomAnchor.constraint(equalTo: bottomSafeArea),
            
            mapView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: innerLayerSpacing),
            mapView.leftAnchor.constraint(equalTo: leftSafeArea),
            mapView.rightAnchor.constraint(equalTo: rightSafeArea),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
//        let useCells = []
//        useCells.forEach {
//            tableView.register($0.self, forCellReuseIdentifier: $0.storyboardIdentifier)
//        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraint()
        setupTableView()
        
        manager.activityType = .automotiveNavigation
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        manager.delegate = self
        mapView.delegate = self

        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        if let realmDataModels = RealmManager.shard?.getHotelDataModelsFromRealm() {
            self.hotelDataModel = realmDataModels
            self.groupedHotels = groupAndSortHotelsByCity()
            tableView.reloadData()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @objc func getUserLocation() {
        switch manager.authorizationStatus {
        case .notDetermined:
            // 首次使用 向user取得隱私權限
            manager.requestWhenInUseAuthorization()
            
            getUserLocation()
        case .denied, .restricted:
            // user已拒絕過權限 或 未開啟定位功能
            let message = "如欲使用此功能，請開啟定位權限\n\n請至\n設定 > 隱私權與安全性 >\n定位服務 > 永許旅社取得您得位置。"
            showAlertClosure(title: "定位權限已關閉", message: message, okBtn: "前往開啟") {
                // 開啟設定
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
            }
            
        case .authorizedWhenInUse:
            // user接受
            manager.startUpdatingLocation()
            mapView.showsUserLocation = true
        default:
            break
        }
    }
    
    @objc private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            tableView.isHidden = false
            mapView.isHidden = true
            tabBarController?.tabBar.isHidden = false
        case 1:
            getUserLocation()
            mapView.isHidden = false
            tableView.isHidden = true
            tabBarController?.tabBar.isHidden = true
        default:
            break
        }
    }
    
    private func groupAndSortHotelsByCity() -> [String: [Hotels]] {
        for hotel in hotelDataModel {
            let city = hotel.city
            if var cityHotels = groupedHotels[city] {
                cityHotels.append(hotel)
                groupedHotels[city] = cityHotels
            } else {
                groupedHotels[city] = [hotel]
            }
        }
        
        // Sort the grouped hotels by city name
        let sortedGroupedHotels = groupedHotels.sorted { $0.key < $1.key }
        // Convert the sorted array back to a dictionary
        let sortedGroupedHotelsDictionary = Dictionary(uniqueKeysWithValues: sortedGroupedHotels)
        return sortedGroupedHotelsDictionary
    }
}

//MARK: - TableView
extension CollectionsViewController: UITableViewDataSource, UITableViewDelegate {
    // section
    func numberOfSections(in tableView: UITableView) -> Int {
        return groupedHotels.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section < groupedHotels.count else {
            return nil
        }
        
        let cityNames = groupedHotels.keys.sorted()
        let cityName = cityNames[section]
        
        let headerView = SettingsTableViewHeaderFooterView(title: cityName, reuseIdentifier: SettingsTableViewHeaderFooterView.reuseIdentifier)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return SettingsTableViewHeaderFooterView.height
    }
    
    // row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hotelDataModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
}


//MARK: - MapView
extension CollectionsViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latLocation = locations.last else {
            assertionFailure("Invalid location or coordinate.")
            return
        }
        let coordinate = latLocation.coordinate
        
        // 定位到map時,放大畫面到定位的位置
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01) // 放大的畫面經緯度範圍
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
}
