//
//  CollectionsViewController.swift
//  寶島旅社
//
//  Created by wistronits on 2023/7/28.
//  Copyright © 2023 Eric Lin. All rights reserved.
//

import UIKit

class CollectionsViewController: UIViewController {
    private var hotelDataModel: [Hotels] = []
    private var groupedHotels: [String: [Hotels]] = [:]
    
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
    
    //MARK: - setup
    private func setupViews() {
        view.backgroundColor = .white
        let viewsToAdd: [UIView] = [
            searchView,
            segmentedControl,
            tableView,
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        if let realmDataModels = RealmManager.shard?.getHotelDataModelsFromRealm() {
            self.hotelDataModel = realmDataModels
            self.groupedHotels = groupAndSortHotelsByCity()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
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
