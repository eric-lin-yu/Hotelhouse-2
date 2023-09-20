//
//  AboutViewController.swift
//  寶島旅社
//
//  Created by Eric Lin on 2022/10/14.
//  Copyright © 2022 Eric Lin. All rights reserved.
//

import UIKit

struct APIDataStorage {
    static var hotelDataBase: HotelDataModel?
}

class AboutViewController: BaseViewController {
    enum AboutViewControllerType: Int, CaseIterable {
        case about = 0
        case setup = 1
        
        var sectionTitle: String {
            switch self {
            case .about:
                return "關於"
            case .setup:
                return "設定"
            }
        }
        
        // 關於 Cell Type
        enum AboutCellSubtitle: Int {
            case appVersion = 0
            case apiDataSource
            case dataUpdateDate
            case totalHotelCount
            
            var stringValue: String {
                switch self {
                case .appVersion:
                    return "APP版本"
                case .apiDataSource:
                    return "資料來源"
                case .dataUpdateDate:
                    return "資料更新日期"
                case .totalHotelCount:
                    return "目前旅店總筆數"
                }
            }
        }
        
        // 設定 Cell Type
        enum SetupCellSubtitle: Int {
            case underDesign = 0
            
            var stringValue: String {
                switch self {
                case .underDesign:
                    return "動工中"
                }
            }
        }
        
        enum CellSubtitle {
            case aboutSubtitle(AboutCellSubtitle)
            case setupSubtitle(SetupCellSubtitle)
            
            var stringValue: String {
                switch self {
                case .aboutSubtitle(let aboutSubtitle):
                    return aboutSubtitle.stringValue
                case .setupSubtitle(let setupSubtitle):
                    return setupSubtitle.stringValue
                }
            }
        }
        
        var cellData: [CellSubtitle] {
            switch self {
            case .about:
                return [.aboutSubtitle(.appVersion), 
                    .aboutSubtitle(.apiDataSource),
                    .aboutSubtitle(.dataUpdateDate),
                    .aboutSubtitle(.totalHotelCount)]
            case .setup:
                return [.setupSubtitle(.underDesign)] // Add more as needed
            }
        }
    }
    
    static func make() -> AboutViewController {
        let storyboard = UIStoryboard(name: "AboutStoryboard", bundle: nil)
        let vc: AboutViewController = storyboard.instantiateViewController(withIdentifier: "AboutIdentifier") as! AboutViewController
        
        return vc
    }
    
    @IBOutlet weak var kanaheiImageView: UIImageView!
    
    var dataModel: Hotels? = nil
    private let cellData: [AboutViewControllerType] = [.about, .setup]
    private let useCells: [UITableViewCell.Type] = [PersonalSettingsLanguageTableViewCell.self]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "關於"
        kanaheiImageView.loadGif(name: ImageNames.shared.aboutImageName)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // 註冊cell
        useCells.forEach {
            tableView.register($0.self, forCellReuseIdentifier: $0.storyboardIdentifier)
        }
    }
    
    @objc func openWKUrl() {
        let vc = OpenWKWebViewController.make(urlString: "https://data.gov.tw/dataset/7780", title: "政府資料開放平臺")
        vc.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(vc, animated: true)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(self.back))
    }

}
//MARK: - TableView
extension AboutViewController: UITableViewDataSource, UITableViewDelegate {
    // section
    func numberOfSections(in tableView: UITableView) -> Int {
        return AboutViewControllerType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionType = AboutViewControllerType(rawValue: section) else {
            return nil
        }
        
        let headerView = SettingsTableViewHeaderFooterView(title: sectionType.sectionTitle, reuseIdentifier: SettingsTableViewHeaderFooterView.reuseIdentifier)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return SettingsTableViewHeaderFooterView.height
    }
    
    // row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionType = AboutViewControllerType(rawValue: section) else {
            return 0
        }
        return sectionType.cellData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PersonalSettingsLanguageTableViewCell.self), for: indexPath) as? PersonalSettingsLanguageTableViewCell else {
            return UITableViewCell()
        }
        
        let sectionType = cellData[indexPath.section]
        
        switch sectionType {
        case .about:
            configureCellForAboutSection(indexPath: indexPath, cell: cell)
        case .setup:
            configureCellForSetupSection(indexPath: indexPath, cell: cell)
        }
        
        return cell
    }
    
    private func configureCellForAboutSection(indexPath: IndexPath, cell: PersonalSettingsLanguageTableViewCell) {
        let rowDataTitle = cellData[indexPath.section].cellData[indexPath.row]
        
        switch rowDataTitle {
        case .aboutSubtitle(.appVersion):
            // 版本
            let versions = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")
            let subtitle = "\(versions ?? "")"
            cell.configure(title: rowDataTitle.stringValue, subtitle: subtitle)
            
        case .aboutSubtitle(.apiDataSource):
            // 資料來源
            let subtitle = "政府資料開放平臺"
            let tap = UITapGestureRecognizer(target: self, action: #selector(openWKUrl))
            cell.configure(title: rowDataTitle.stringValue, subtitle: subtitle, tap: tap)
            
        case .aboutSubtitle(.dataUpdateDate):
            // 資料更新日期
            let dateTimeString = APIDataStorage.hotelDataBase?.updatetime
            if let formattedDateString = dateTimeString?.formatDateToYearMonthDay() {
                cell.configure(title: rowDataTitle.stringValue, subtitle: formattedDateString)
            }
        case .aboutSubtitle(.totalHotelCount):
            // 旅店總筆數
            if let subtitle = APIDataStorage.hotelDataBase?.updateInterval {
                cell.configure(title: rowDataTitle.stringValue, subtitle: "\(subtitle) 間")
            }
        default:
            break
        }
    }

    private func configureCellForSetupSection(indexPath: IndexPath, cell: PersonalSettingsLanguageTableViewCell) {
        let rowDataTitle = cellData[indexPath.section].cellData[indexPath.row]
        
        switch rowDataTitle {
        case .setupSubtitle(.underDesign):
            let subtitle = "創作者還在摸索..."
            cell.configure(title: rowDataTitle.stringValue, subtitle: subtitle)
            
        default:
            break
        }
    }
}
