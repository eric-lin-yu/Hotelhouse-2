//
//  HotelDetailViewController.swift
//  寶島旅社
//
//  Created by Eric Lin on 2022/10/20.
//  Copyright © 2022 Eric Lin. All rights reserved.
//

import UIKit

class HotelDetailViewController: UIViewController {
    static func make(hotelData: DataInfoArray) -> HotelDetailViewController {
        let storyboard = UIStoryboard(name: "HotelDetailStoryboard", bundle: nil)
        let vc: HotelDetailViewController = storyboard.instantiateViewController(withIdentifier: "HotelDetailIdentifier") as! HotelDetailViewController
        
        vc.dataModel = hotelData
        
        return vc
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var dataModel: DataInfoArray! = nil
    
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
        let imageData = [dataModel.picture1, dataModel.picture2, dataModel.picture3]
        let titleData = [dataModel.picdescribe1, dataModel.picdescribe2, dataModel.picdescribe3]
        
        for index in 0..<imageData.count {
            if imageData[index] != "" {
                self.collectionImageDataModel.append(imageData[index])
                self.collectiontitleDataModel.append(titleData[index])
            }
        }
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
 
}

//MARK: - TableView
extension HotelDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return useCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return openDetailCollectionTableViewCell(on: tableView, at: indexPath)
        case 1:
            return openHotelDetailCell(on: tableView, at: indexPath)
        case 2:
            return openDescriptionTableViewCell(on: tableView, at: indexPath)
        case 3:
            return openHotelExtraDetailCell(on: tableView, at: indexPath)
        case 4:
            return openMapTableViewCell(on: tableView, at: indexPath)
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "", for: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 4:
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
        cell.collectionView.register(UINib(nibName: "ImageDataCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: String(describing: ImageDataCollectionViewCell.self))
        
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
        
        cell.delegate = self
        cell.configure(dataModel: dataModel)
        
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
        
        switch collectionImageDataModel.count {
        case 0:
            // error
            cell.hotelImageView.loadGif(name: "嘎喔兔兔")
            cell.titleLabel.text = "很抱歉，此旅店尚未提供圖檔哦~"
            return cell
        default:
            // 下載圖片
            let url = URL(string: collectionImageDataModel[indexPath.row])
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!)
                DispatchQueue.main.async {
                    cell.hotelImageView.image = UIImage(data: data!)
                }
            }
            if collectiontitleDataModel[indexPath.row] != "" {
                cell.titleLabel.text = collectiontitleDataModel[indexPath.row]
            } else {
                cell.titleLabel.text = "實景示意圖"
            }
            return cell
        }

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

// MARK: HotelDetailsDelegate
extension HotelDetailViewController: HotelDetailsCellDelegate {
    
    func getOpenWebView() {
        let vc = OpenWKWebViewController.make(urlString: dataModel.website,
                                              title: dataModel.hotelName)
        vc.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(vc, animated: true)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(self.back))
    }
    
}
