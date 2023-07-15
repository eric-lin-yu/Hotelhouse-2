//
//  ViewController.swift
//  寶島旅社
//
//  Created by Eric Lin. on 2022/10/12.
//

import UIKit
import MessageUI

enum FrontPageViewStatus {
    case searchView
    case resultTableView
}

class FrontPageViewController: UIViewController {
    static func makeToHome() -> FrontPageViewController {
        let storyboard = UIStoryboard(name: "FrontPageStoryboard", bundle: nil)
        let vc: FrontPageViewController = storyboard.instantiateViewController(withIdentifier: "FrontPageIentity") as! FrontPageViewController
        return vc
    }
    
    //MARK: IBOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topButtonView: UIView!
    
    ///showSearchBtnView
    @IBOutlet weak var showSearchBtnView: UIView! {
        didSet {
            showSearchBtnView.roundFrameView(roundView: showSearchBtnView)
        }
    }
    ///showMapSearchView
    @IBOutlet weak var showMapBtnView: UIView! {
        didSet {
            showMapBtnView.roundFrameView(roundView: showMapBtnView)
        }
    }
    
    // SearchView相關
    ///查詢View
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchBcakgroundView: UIView!
    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            searchTextField.delegate = self
            //圓角
            searchTextField.layer.cornerRadius = 15
            searchTextField.layer.masksToBounds = true
            
            //邊框線條
            searchTextField.layer.borderWidth = 2
            searchTextField.layer.borderColor = UIColor.mainGreen.cgColor
            
            searchTextField.backgroundColor = UIColor.white
        }
    }
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var kanaheiImageView: UIImageView!
    
    lazy var viewModel: HotelBookViewModel = {
        return HotelBookViewModel()
    }()
    let cellIdenifier = "FrontPageIdenifier"
    var downloadAllData: [DataInfoArray] = []
    var dataModel: [DataInfoArray] = []
    var frontPageViewStatus: FrontPageViewStatus!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchView.isHidden = true
        frontPageViewStatus = .searchView
        LoadingPageView.shard.show()
        // download DataModel
        viewModel.getHotelBookData { response in
            LoadingPageView.shard.dismiss()
            self.searchView.isHidden = false
            self.kanaheiImageView.loadGif(name: "棒棒兔兔")
            self.downloadAllData = response?.dataArray ?? []
        }
    
        tableView.dataSource = self
        tableView.delegate = self
        // 註冊cell
        tableView.register(UINib(nibName: "FrontPageTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdenifier)
        
        let searchTap = UITapGestureRecognizer(target: self, action: #selector((isCheckShowSearchView)))
        showSearchBtnView.isUserInteractionEnabled = true
        showSearchBtnView.addGestureRecognizer(searchTap)
        
        let mapTap = UITapGestureRecognizer(target: self, action: #selector((showMapView)))
        showMapBtnView.isUserInteractionEnabled = true
        showMapBtnView.addGestureRecognizer(mapTap)
        
//        topButtonView.isHidden = true
    }
   
    
    //MARK: - searchBar相關
    @IBAction func searchBtn(_ sender: Any) {
        if searchTextField.text != "" {
            dataModel = []
            filterContent(for: searchTextField.text ?? "")
            self.view.endEditing(true)
        } else {
            showAlert(title: "通知", message: "查詢條件未輸入哦")
        }
    }
    
    // 過濾條件
    func filterContent(for searchText: String) {
        let text = searchText.replacingOccurrences(of: "台", with: "臺")
        dataModel = downloadAllData.filter { (info) -> Bool in
            let isMatch = info.add.localizedCaseInsensitiveContains(text) ||
                info.hotelName.localizedCaseInsensitiveContains(text)
            return isMatch
        }
        
        if dataModel.count == 0 {
            showAlert(title: "通知", message: "輸入條件未查到相符的資料哦...")
            tableView.reloadData()
        } else {
            self.frontPageViewStatus = .resultTableView
            searchView.isHidden = true
            topButtonView.isHidden = false
            
            // 初次搜尋後，才開啟此功能
            let tap = UITapGestureRecognizer(target: self, action: #selector((isCheckShowSearchView)))
            searchBcakgroundView.isUserInteractionEnabled = true
            searchBcakgroundView.addGestureRecognizer(tap)
            
            tableView.reloadData()
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
    
    @IBAction func cancelBtn(_ sender: Any) {
        searchTextField.text = ""
    }
    
    @objc func isCheckShowSearchView() {
        switch frontPageViewStatus {
        case .searchView:
            searchView.isHidden = true
            frontPageViewStatus = .resultTableView
        case .resultTableView:
            searchView.isHidden = false
            frontPageViewStatus = .searchView
        default:
            break
        }
    }
    
    @objc func showMapView() {
        let vc = MapSearchViewController.make(dataModel: self.downloadAllData)
        vc.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(vc, animated: true)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(self.back))
    }
    
    func isCheckDataHidden(dataStr: String) -> Bool {
        if dataStr == "" {
            return true
        } else {
            return false
        }
    }

}

//MARK: - TextFieldDelegate
extension FrontPageViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//MARK: - TableView
extension FrontPageViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return frontPageTableViewCell(on: tableView, at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = HotelDetailViewController.make(hotelData: dataModel[indexPath.row])
        vc.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(vc, animated: true)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(self.back))
    }

    // MARK: Cell
    func frontPageTableViewCell(on tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdenifier, for: indexPath) as! FrontPageTableViewCell
        
        let dataModel = dataModel[indexPath.row]

        cell.nameLabel.text = dataModel.hotelName

        //ImageDownload
        if dataModel.picture1 != "" {
            let url = URL(string: dataModel.picture1)
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!)
                DispatchQueue.main.async {
                    cell.hotelimageView.image = UIImage(data: data!)
                }
            }
        } else {
            cell.hotelimageView.image = UIImage(named: "iconError")
        }

        // 星級
        cell.gradeLabel.isHidden = isCheckDataHidden(dataStr: dataModel.grade)
        cell.gradeLabel.text = "☆級：\(dataModel.grade)"

        cell.govLabel.text = dataModel.hotelID
        cell.descriptionLabel.text = dataModel.description

        // 價格
        if dataModel.lowestPrice != dataModel.ceilingPrice {
            cell.priceLabel.text = "： \(dataModel.lowestPrice) ~ \(dataModel.ceilingPrice)"
        } else {
            cell.priceLabel.text = "： \(dataModel.ceilingPrice)"
        }

        // 旅店類別
        switch dataModel.classData {
        case "1":
            cell.hotleCalssLabel.text = "： 國際觀光旅館"
        case "2":
            cell.hotleCalssLabel.text = "： 一般觀光旅館"
        case "3":
            cell.hotleCalssLabel.text = "： 一般旅館"
        case "4":
            cell.hotleCalssLabel.text = "： 民宿"
        default:
            cell.hotleCalssLabel.text = "： 旅店未提供"
        }

        cell.addLabel.text = dataModel.add

        cell.loveBtn.tag = indexPath.row
        cell.loveBtn.addTarget(self, action: #selector(loveBtnAction(_:)), for: .touchUpInside)

        // 電話
        cell.phoneBtn.isHidden = isCheckDataHidden(dataStr: dataModel.tel)
        cell.phoneBtn.tag = indexPath.row
        cell.phoneBtn.addTarget(self, action: #selector(phoneBtnAction(_:)), for: .touchUpInside)

        // 官網
        cell.webBtn.isHidden = isCheckDataHidden(dataStr: dataModel.website)
        cell.webBtn.tag = indexPath.row
        cell.webBtn.addTarget(self, action: #selector(webBtnAction(_:)), for: .touchUpInside)

        // 信箱
        cell.emailBtn.isHidden = isCheckDataHidden(dataStr: dataModel.industryEmail)
        cell.emailBtn.tag = indexPath.row
        cell.emailBtn.addTarget(self, action: #selector(emailBtnAction(_:)), for: .touchUpInside)
        
        return cell
    }
    
    //MARK: Button標籤區
    // love
    @objc func loveBtnAction(_ sender: UIButton) {
        //...
    }
    
    // 撥打電話鈕
    @objc func phoneBtnAction(_ sender: UIButton) {
        let index = sender.tag
        let searchData = dataModel[index]
        
        showAlertClosure(title: "通知", message: "將外撥電話至 \(searchData.hotelName)", okBtn: "確定") {
            let phone = searchData.tel
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
    
    // open web
    @objc func webBtnAction(_ sender: UIButton) {
        let index = sender.tag
        let searchData = dataModel[index]
        
        let vc = OpenWKWebViewController.make(urlString: searchData.website,
                                              title: searchData.hotelName)
        vc.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(vc, animated: true)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(self.back))
    }
    
    // e-mail
    @objc func emailBtnAction(_ sender: UIButton) {
        let index = sender.tag
        let searchData = dataModel[index]
     
        sendEmail(email: searchData.industryEmail)
    }
}
