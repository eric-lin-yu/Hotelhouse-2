//
//  HotelDetailViewController.swift
//  寶島旅社
//
//  Created by Eric Lin on 2022/10/20.
//  Copyright © 2022 Eric Lin. All rights reserved.
//

import UIKit

class HotelDetailViewController: UIViewController {
    enum HotelDetailType: Int {
        case hotelImage = 0
        case hotelDetails
        case hotelDescription
        case hotelExtra
        case hotelMap
    }
    
    static func make(hotelData: HotelDataModel) -> HotelDetailViewController {
        let storyboard = UIStoryboard(name: "HotelDetailStoryboard", bundle: nil)
        let vc: HotelDetailViewController = storyboard.instantiateViewController(withIdentifier: "HotelDetailIdentifier") as! HotelDetailViewController
        
        vc.dataModel = hotelData
        
        return vc
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var dataModel: HotelDataModel! = nil
    
    var collectionImageDataModel: [String] = []
    var collectiontitleDataModel: [String] = []
    // add New Cell
    private let useCells: [UITableViewCell.Type] = [HotelDetailCollectionTableViewCell.self, MapTableViewCell.self, DescriptionTableViewCell.self, HotelExtraDetailsTableViewCell.self, HotelDetailsTableViewCell.self]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = dataModel.hotelName
        getCollectionViewDataModel()
        tableView.dataSource = self
        tableView.delegate = self
        
        // 註冊cell
        useCells.forEach {
            tableView.register(UINib(nibName: $0.storyboardIdentifier, bundle: Bundle.messageCoreBundle),
                                      forCellReuseIdentifier: $0.storyboardIdentifier)
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "phone.circle"), style: .plain, target: self, action: #selector(callPhoneBtn))
        
    }
    
    func getCollectionViewDataModel() {
        self.collectionImageDataModel = dataModel.images.compactMap { $0.url.isEmpty ? nil : $0.url }
        self.collectiontitleDataModel = dataModel.images.compactMap { $0.url.isEmpty ? nil : $0.imageDescription }
    }
    
   @objc func callPhoneBtn() {
        showAlertClosure(title: "通知", message: "將外撥電話至 \(dataModel.hotelName)", okBtn: "確定") {
            let phone = self.dataModel.tel
            if let url = URL(string: "tel:\(phone)") {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    self.showAlert(title: "通知", message: "撥打失敗，請稍後再嘗試")
                }
            } else {
                #if DEBUG
                print("連結錯誤")
                #endif
            }
        }
    }
    
    @objc func getOpenWebView() {
        let vc = OpenWKWebViewController.make(urlString: dataModel.website,
                                              title: dataModel.hotelName)
        vc.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(vc, animated: true)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(self.back))
    }
}

//MARK: - TableView
extension HotelDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return useCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let type = HotelDetailType(rawValue: indexPath.row) else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "", for: indexPath)
            return cell
        }
        
        switch type {
        case .hotelImage:
            return openDetailCollectionTableViewCell(on: tableView, at: indexPath)
        case .hotelDetails:
            return openHotelDetailCell(on: tableView, at: indexPath)
        case .hotelDescription:
            return openDescriptionTableViewCell(on: tableView, at: indexPath)
        case .hotelExtra:
            return openHotelExtraDetailCell(on: tableView, at: indexPath)
        case .hotelMap:
            return openMapTableViewCell(on: tableView, at: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let type = HotelDetailType(rawValue: indexPath.row) else {
            return
        }
        
        switch type {
        case .hotelMap:
            let vc = HotelDetailMapViewController.make(hotelData: dataModel)

            self.navigationController?.pushViewController(vc, animated: true)
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(self.back))
        default:
            break
        }
    }
    
    //MARK: Cell
    // collection
    func openDetailCollectionTableViewCell(on tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HotelDetailCollectionTableViewCell.self), for: indexPath) as! HotelDetailCollectionTableViewCell
        cell.collectionView.dataSource = self
        cell.collectionView.delegate = self
        
        cell.pageControl.numberOfPages = collectionImageDataModel.count
        // 分頁模式
        cell.collectionView.isPagingEnabled = true
        cell.collectionView.register(ImageDataCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: ImageDataCollectionViewCell.self))
        
        return cell
    }
    
    // 說明介紹
    func openDescriptionTableViewCell(on tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DescriptionTableViewCell.self), for: indexPath) as! DescriptionTableViewCell
        
        cell.configure(dataModel: dataModel)
        
        return cell
    }
    
    // 旅店說明
    func openHotelDetailCell(on tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HotelDetailsTableViewCell.self), for: indexPath) as! HotelDetailsTableViewCell
        
        cell.configure(dataModel: dataModel, delegate: self)
    
        return cell
    }
    
    // 額外細節說明
    func openHotelExtraDetailCell(on tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HotelExtraDetailsTableViewCell.self), for: indexPath) as! HotelExtraDetailsTableViewCell
        
        cell.configure(dataModel: dataModel)
        
        return cell
    }
    
    // MAP
    func openMapTableViewCell(on tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MapTableViewCell.self), for: indexPath) as! MapTableViewCell
        
        cell.configure(dataModel: dataModel)
        
        return cell
    }
}

//MARK: - Collection
extension HotelDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionImageDataModel.count {
        case 0:
            return 1 //show error imageView
        default:
            return collectionImageDataModel.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ImageDataCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ImageDataCollectionViewCell.self), for: indexPath) as! ImageDataCollectionViewCell
        
        if indexPath.row < collectionImageDataModel.count {
            let imageURL = collectionImageDataModel[indexPath.row]
            let title = collectiontitleDataModel[indexPath.row]
            cell.configure(with: imageURL, title: title)
        } else {
            cell.configure()
        }
        return cell
    }
    
    // cell的間距。如設定isPagingEnabled(換頁模式)的話，要設定為0
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // cell自適應為CollectionView的Layout
    // Estimate Size記得要設定為None，不然無法work
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width,
                      height: collectionView.bounds.height)
    }
    
    // CollectionView 繼承自 ScrollView。可直接使用
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.frame.size.width + 0.6
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? HotelDetailCollectionTableViewCell
        // 這裡要用as?, as!實機會偶發閃退問題
        cell?.pageControl.currentPage = Int(page)
    }
}

//MARK: - HotelDetailsTableViewCellDelegate
extension HotelDetailViewController: HotelDetailsTableViewCellDelegate {
    func webLabelTapped(for cell: HotelDetailsTableViewCell) {
        self.getOpenWebView()
    }
}
