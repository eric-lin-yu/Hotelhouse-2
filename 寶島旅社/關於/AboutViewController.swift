//
//  AboutViewController.swift
//  寶島旅社
//
//  Created by Eric Lin on 2022/10/14.
//  Copyright © 2022 Eric Lin. All rights reserved.
//

import UIKit

class AboutViewController: BaseViewController {
    static func make() -> AboutViewController {
        let storyboard = UIStoryboard(name: "AboutStoryboard", bundle: nil)
        let vc: AboutViewController = storyboard.instantiateViewController(withIdentifier: "AboutIdentifier") as! AboutViewController
        
        return vc
    }
    
    @IBOutlet weak var kanaheiImageView: UIImageView!
    
    var dataModel: HotelsArray? = nil
    private let useCells: [UITableViewCell.Type] = [PersonalSettingsLanguageTableViewCell.self]
    
    struct AboutDataModel {
        let sectionDataModel: [String]
        let rowDataModel: [String]
    }
    
    var aboutDataModel: [AboutDataModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "設定"
        kanaheiImageView.loadGif(name: "鼓掌兔兔")
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // 註冊cell
        useCells.forEach {
            tableView.register($0.self, forCellReuseIdentifier: $0.storyboardIdentifier)
        }
        
        getAboutDataModel()
    }
    
    func getAboutDataModel() {
        let section = [["關於"],
                       ["設定"]]
        
        let row = [["APP版本", "資料來源"],
                   ["動工中"]]
        
        for index in 0..<section.count {
            aboutDataModel.insert(.init(sectionDataModel: section[index], rowDataModel: row[index]), at: index)
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
        return aboutDataModel.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = SettingsTableViewHeaderFooterView()
        
        switch section {
        case 0:
            headerView.configure(title: "關於")
        case 1:
            headerView.configure(title: "設定")
        default:
            break
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return SettingsTableViewHeaderFooterView.height
    }
    
    // row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch aboutDataModel[section].sectionDataModel.count{
        case 0:
            return aboutDataModel[section].rowDataModel.count
        case 1:
            return aboutDataModel[section].rowDataModel.count
        default:
            break
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PersonalSettingsLanguageTableViewCell.self), for: indexPath) as! PersonalSettingsLanguageTableViewCell
        
        let aboutDataModel = aboutDataModel[indexPath.section]
        switch indexPath.section {
        case 0:
            // 關於
            switch indexPath.row {
            case 0:
                
                let title = aboutDataModel.rowDataModel[indexPath.row]
                // 版本
                let versions = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")
                let subtitle = "\(versions ?? "")"
                
                cell.configure(title: title, subtitle: subtitle)
                
            case 1:
                // 資料來源
                let title = aboutDataModel.rowDataModel[indexPath.row]
                let subtitle = "政府資料開放平臺"
                
                cell.configure(title: title, subtitle: subtitle)
                
//                let tap = UITapGestureRecognizer(target: self, action: #selector(openWKUrl))
//                cell.subtitleLabel.addGestureRecognizer(tap)
//                cell.subtitleLabel.isUserInteractionEnabled = true
            default:
                break
            }
        case 1:
            // 設定
            switch indexPath.row {
            case 0:
                let title = aboutDataModel.rowDataModel[indexPath.row]
                let subtitle = "創作者還在摸索..."
                
                cell.configure(title: title, subtitle: subtitle)
            default:
                break
            }
            
        default:
            break
        }
        return cell
    }
}
