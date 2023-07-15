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
    
    var dataModel: HotelsArray! = nil
    private let useCells: [UITableViewCell.Type] = [AboutTableViewCell.self]
    
    var isExpendDataList: [Bool] = [] //控制展開/縮合
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
        
        //加入縮合式SectionView
        let sectionViewNib: UINib = UINib(nibName: "SectionTableViewHeaderFooterView", bundle: nil)
        tableView.register(sectionViewNib, forHeaderFooterViewReuseIdentifier: "SectionViewIdentifier")
        
        // 註冊cell
        useCells.forEach {
            tableView.register(UINib(nibName: $0.storyboardIdentifier, bundle: Bundle.messageCoreBundle),
                                      forCellReuseIdentifier: $0.storyboardIdentifier)
        }
        
        getAboutDataModel()
    }
    
    func getAboutDataModel() {
        let section = [["關於"],
                       ["設定"]]
        
        let row = [["APP版本", "旅店資料來源"],
                   ["動工中"]]
        
        for index in 0..<section.count {
            aboutDataModel.insert(.init(sectionDataModel: section[index], rowDataModel: row[index]), at: index)
            isExpendDataList.append(false)
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
        let sectionView: SectionTableViewHeaderFooterView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SectionViewIdentifier") as! SectionTableViewHeaderFooterView
        
        sectionView.isExpand = self.isExpendDataList[section]
        sectionView.buttonTag = section
        sectionView.delegate = self
        
        // arrrow
        let downArrow = UIImage(systemName: "chevron.down")
        let rightArrow = UIImage(systemName: "chevron.right")
        sectionView.arrowBth.setImage(self.isExpendDataList[section] == true ? downArrow : rightArrow, for: .normal)
    
        sectionView.titleLabel.text = aboutDataModel[section].sectionDataModel[0]

        return sectionView
    }
    
    // row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isExpendDataList[section] {
            return aboutDataModel[section].rowDataModel.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AboutTableViewCell.self), for: indexPath) as! AboutTableViewCell
        
        let aboutDataModel = aboutDataModel[indexPath.section]
        switch indexPath.section {
        case 0:
            // 關於
            switch indexPath.row {
            case 0:
                // 版本
                let versions = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")
                
                cell.titleImageView.image = UIImage(systemName: "tray.circle")
                cell.titleLabel.text = aboutDataModel.rowDataModel[indexPath.row]
                
                cell.subtitleLabel.textColor = UIColor.mainRed
                cell.subtitleLabel.text = "\(versions ?? "")"
                
            case 1:
                // 資料來源
                cell.titleImageView.image = UIImage(systemName: "archivebox.circle")
                cell.titleLabel.text = aboutDataModel.rowDataModel[indexPath.row]
                
                cell.subtitleLabel.textColor = UIColor.blue
                cell.subtitleLabel.text = "政府資料開放平臺"
                
                let tap = UITapGestureRecognizer(target: self, action: #selector(openWKUrl))
                cell.subtitleLabel.addGestureRecognizer(tap)
                cell.subtitleLabel.isUserInteractionEnabled = true
                
            default:
                break
            }
        case 1:
            // 設定
            switch indexPath.row {
            case 0:
                cell.titleImageView.image = UIImage(systemName: "moon.stars")
                cell.titleLabel.text = aboutDataModel.rowDataModel[indexPath.row]
                cell.subtitleLabel.text = "創作者還在摸索..."
            default:
                break
            }
            
        default:
            break
        }
        return cell
    }
}

// MARK: - SectionViewDelegate
extension AboutViewController: SectionViewDelegate {
    
    func sectionView(_ sectionView: SectionTableViewHeaderFooterView, _ didPressTag: Int, _ isExpand: Bool) {
        self.isExpendDataList[didPressTag] = !isExpand
        self.tableView.reloadSections(IndexSet(integer: didPressTag), with: .automatic)
    }
    
}
