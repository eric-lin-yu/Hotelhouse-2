//
//  ViewController.swift
//  寶島旅社
//
//  Created by Eric Lin. on 2022/10/12.
//

import UIKit
import MessageUI
import SkeletonView

class FrontPageViewController: UIViewController {
    enum FrontPageViewStatus {
        case searchView
        case resultTableView
    }
    
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
    
    private var downloadAllData: [HotelDataModel] = []
    private var hotelDataModel: [HotelDataModel] = []
    private var frontPageViewStatus: FrontPageViewStatus = .searchView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchView.isHidden = true
        
        DispatchQueue.main.async {
            LoadingPageView.shard.show()
        }
        // download DataModel
        viewModel.getHotelBookData { response in
            LoadingPageView.shard.dismiss()
            self.searchView.isHidden = false
            self.kanaheiImageView.loadGif(name: ImageNames.shared.searchViewImageName)
            self.downloadAllData = response?.dataArray ?? []
        }
    
        tableView.dataSource = self
        tableView.delegate = self
        // 註冊cell
        tableView.register(UINib(nibName: "FrontPageTableViewCell", bundle: nil), forCellReuseIdentifier: FrontPageTableViewCell.cellIdenifier)
        
        let searchTap = UITapGestureRecognizer(target: self, action: #selector((toggleSearchViewVisibility)))
        showSearchBtnView.isUserInteractionEnabled = true
        showSearchBtnView.addGestureRecognizer(searchTap)
        
        let mapTap = UITapGestureRecognizer(target: self, action: #selector((showMapView)))
        showMapBtnView.isUserInteractionEnabled = true
        showMapBtnView.addGestureRecognizer(mapTap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    //MARK: - searchBar相關
    @IBAction func searchAction(_ sender: Any) {
        guard let searchText = searchTextField.text, !searchText.isEmpty else {
            showAlert(title: "通知", message: "查詢條件未輸入哦")
            return
        }
        hotelDataModel = []
        filterContent(for: searchText)
        self.view.endEditing(true)
    }
    
    // 過濾條件
    private func filterContent(for searchText: String) {
        let text = searchText.replacingOccurrences(of: "台", with: "臺")
        hotelDataModel = downloadAllData.filter { (info) -> Bool in
            let isMatch = info.add.localizedCaseInsensitiveContains(text) ||
            info.hotelName.localizedCaseInsensitiveContains(text)
            return isMatch
        }
        
        if hotelDataModel.isEmpty {
            showAlert(title: "通知", message: "輸入條件未查到相符的資料哦...")
        } else {
            self.frontPageViewStatus = .resultTableView
            searchView.isHidden = true
            topButtonView.isHidden = false
            
            // 初次搜尋後，才開啟此功能
            let tap = UITapGestureRecognizer(target: self, action: #selector(toggleSearchViewVisibility))
            searchBcakgroundView.isUserInteractionEnabled = true
            searchBcakgroundView.addGestureRecognizer(tap)
            
            
            tableView.isSkeletonable = true
            tableView.showAnimatedGradientSkeleton()
       
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                self.tableView.stopSkeletonAnimation()
                self.view.hideSkeleton(reloadDataAfter: true,
                                       transition: .crossDissolve(0.25))
                
                self.tableView.reloadData()
                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }
        }
    }
    
    @IBAction func cancelBtn(_ sender: Any) {
        searchTextField.text = ""
    }
    
    @objc func toggleSearchViewVisibility() {
        searchView.isHidden.toggle()
        frontPageViewStatus = searchView.isHidden ? .resultTableView : .searchView
    }
    
    @objc func showMapView() {
        let vc = MapSearchViewController.make(dataModel: self.downloadAllData)
        vc.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(vc, animated: true)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(self.back))
    }
    
    private func isDataEmpty(_ dataStr: String) -> Bool {
        return dataStr.isEmpty
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
// SkeletonTableViewDataSource change UITableViewDataSource
extension FrontPageViewController: SkeletonTableViewDataSource, UITableViewDelegate {
    // skeletonView
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return FrontPageTableViewCell.cellIdenifier
    }
    
    // show skeletonView
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hotelDataModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return frontPageTableViewCell(on: tableView, at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = HotelDetailViewController.make(hotelData: hotelDataModel[indexPath.row])
        vc.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(vc, animated: true)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(self.back))
    }

    // MARK: Cell
    private func frontPageTableViewCell(on tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FrontPageTableViewCell.cellIdenifier, for: indexPath) as! FrontPageTableViewCell
        
        let dataModel = hotelDataModel[indexPath.row]
        
        configureCell(cell, with: dataModel)
        
        cell.loveBtn.tag = indexPath.row
        cell.loveBtn.addTarget(self, action: #selector(loveBtnAction(_:)), for: .touchUpInside)
        
        // 電話
        cell.phoneBtn.isHidden = isDataEmpty(dataModel.tel[0])
        cell.phoneBtn.tag = indexPath.row
        cell.phoneBtn.addTarget(self, action: #selector(phoneBtnAction(_:)), for: .touchUpInside)
        
        // 官網
        cell.webBtn.isHidden = isDataEmpty(dataModel.website)
        cell.webBtn.tag = indexPath.row
        cell.webBtn.addTarget(self, action: #selector(webBtnAction(_:)), for: .touchUpInside)
        
        // 信箱
        cell.emailBtn.isHidden = isDataEmpty(dataModel.industryEmail)
        cell.emailBtn.tag = indexPath.row
        cell.emailBtn.addTarget(self, action: #selector(emailBtnAction(_:)), for: .touchUpInside)
        
        return cell
    }
    
    private func configureCell(_ cell: FrontPageTableViewCell, with dataModel: HotelDataModel) {
        cell.nameLabel.text = dataModel.hotelName
        
        cell.hotelimageView.loadUrlImage(urlString: dataModel.images.first?.url ?? "") { result in
            switch result {
            case .success(let image):
                if let image = image {
                    cell.hotelimageView.image = image
                } else {
                    cell.hotelimageView.image = UIImage(named: "iconError")
                }
            case .failure(_):
                cell.hotelimageView.image = UIImage(named: "iconError")
            }
        }
        
        // 星級
        cell.gradeLabel.isHidden = isDataEmpty(dataModel.grade)
        cell.gradeLabel.text = "☆級：\(dataModel.grade)"
        
        cell.govLabel.text = dataModel.hotelID
        cell.descriptionLabel.text = dataModel.description
        
        // 價格
        let priceText = dataModel.lowestPrice != dataModel.ceilingPrice ? "\(dataModel.lowestPrice) ~ \(dataModel.ceilingPrice)" : "\(dataModel.ceilingPrice)"
        cell.priceLabel.text = "： \(priceText)"
        
        // 旅店類別
        if let hotelClass = dataModel.classData.first.flatMap(HotelClass.init(rawValue:)) {
            cell.hotleCalssLabel.text = "：\(hotelClass.description)"
        } else {
            cell.hotleCalssLabel.text = "旅店未提供"
        }
        
        let formattedAddress = AddressFormatter.shared.formatAddress(region: dataModel.region, town: dataModel.town, add: dataModel.add)
        cell.addLabel.text = formattedAddress
    }
    
    //MARK: Button標籤區
    // love
    @objc func loveBtnAction(_ sender: UIButton) {
        //...
    }
    
    // 撥打電話鈕
    @objc func phoneBtnAction(_ sender: UIButton) {
        let index = sender.tag
        let searchData = hotelDataModel[index]
        
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
        let searchData = hotelDataModel[index]
        
        let vc = OpenWKWebViewController.make(urlString: searchData.website,
                                              title: searchData.hotelName)
        vc.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(vc, animated: true)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(self.back))
    }
    
    // e-mail
    @objc func emailBtnAction(_ sender: UIButton) {
        let index = sender.tag
        let searchData = hotelDataModel[index]
     
        sendEmail(email: searchData.industryEmail)
    }
}
