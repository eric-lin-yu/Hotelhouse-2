//
//  AboutViewController.swift
//  寶島旅社
//
//  Created by Eric Lin on 2022/10/14.
//  Copyright © 2022 Eric Lin. All rights reserved.
//

import UIKit

class AboutViewController: BaseViewController {
    enum AboutViewControllerType: Int, CaseIterable {
        case about = 0
        case setup = 1
        
        var title: String {
            switch self {
            case .about:
                return "關於"
            case .setup:
                return "設定"
            }
        }
        
        var cellData: [String] {
            switch self {
            case .about:
                return [
                    "APP版本",
                    "資料來源",
                ]
            case .setup:
                return [
                    "動工中",
                ]
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
        
        let headerView = SettingsTableViewHeaderFooterView(title: sectionType.title, reuseIdentifier: SettingsTableViewHeaderFooterView.reuseIdentifier)
        
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
        
        switch indexPath.row {
        case 0:
            // 版本
            let versions = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")
            let subtitle = "\(versions ?? "")"
            cell.configure(title: rowDataTitle, subtitle: subtitle)
            
        case 1:
            // 資料來源
            let subtitle = "政府資料開放平臺"
            let tap = UITapGestureRecognizer(target: self, action: #selector(openWKUrl))
            cell.configure(title: rowDataTitle, subtitle: subtitle, tap: tap)
            
        default:
            break
        }
    }

    private func configureCellForSetupSection(indexPath: IndexPath, cell: PersonalSettingsLanguageTableViewCell) {
        let rowDataTitle = cellData[indexPath.section].cellData[indexPath.row]
        
        switch indexPath.row {
        case 0:
            let subtitle = "創作者還在摸索..."
            cell.configure(title: rowDataTitle, subtitle: subtitle)
            
        default:
            break
        }
    }
}
