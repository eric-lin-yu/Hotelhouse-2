//
//  HotelDetailsTableViewCell.swift
//  寶島旅社
//
//  Created by wistronits on 2022/11/16.
//  Copyright © 2022 Eric Lin. All rights reserved.
//

import UIKit

protocol HotelDetailsCellDelegate: AnyObject {
    func getOpenWebView()
}

class HotelDetailsTableViewCell: UITableViewCell {
    @IBOutlet weak var hotelClassView: UIView!{
        didSet {
//            hotelClassView.roundFrameView(roundView: hotelClassView)
        }
    }
    @IBOutlet weak var hotelCalssLabel: UILabel!
    @IBOutlet weak var priceView: UIView! {
        didSet {
//            priceView.roundFrameView(roundView: priceView)
        }
    }
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var webLabel: UILabel!
    
    var delegate: HotelDetailsCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
 
    func configure(dataModel: DataInfoArray) {
        
        // 旅店類別
        switch dataModel.classData {
        case "1":
            hotelCalssLabel.text = " 旅店類別：國際觀光旅館"
        case "2":
            hotelCalssLabel.text = " 旅店類別：一般觀光旅館"
        case "3":
            hotelCalssLabel.text = " 旅店類別：一般旅館"
        case "4":
            hotelCalssLabel.text = " 旅店類別：民宿"
        default:
            hotelCalssLabel.text = "： 旅店未提供說明"
        }
        
        
        // 價格
        if dataModel.lowestPrice != dataModel.ceilingPrice {
            priceLabel.text = " 價位： \(dataModel.lowestPrice) ~ \(dataModel.ceilingPrice)"
        } else {
            priceLabel.text = " 價位： \(dataModel.ceilingPrice)"
        }
        
        // 官網
        if dataModel.website != "" {
            webLabel.text = "開啟網站"
            
            let tap = UITapGestureRecognizer(target: self, action: #selector((openWebView)))
            webLabel.isUserInteractionEnabled = true
            webLabel.addGestureRecognizer(tap)
            
        } else {
            webLabel.text = "旅店未提供"
            webLabel.textColor = UIColor.black
        }
        
    }
    
    @objc func openWebView() {
        delegate?.getOpenWebView()
    }

}
