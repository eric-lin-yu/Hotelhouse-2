//
//  HotelDetailsTableViewCell.swift
//  寶島旅社
//
//  Created by wistronits on 2022/11/16.
//  Copyright © 2022 Eric Lin. All rights reserved.
//

import UIKit

class HotelDetailsTableViewCell: UITableViewCell {
    @IBOutlet weak var hotelClassView: UIView!
    @IBOutlet weak var hotelCalssLabel: UILabel!
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var webLabel: UILabel!
    @IBOutlet weak var collectionsView: UIView!
    @IBOutlet weak var collectionsImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
 
    func configure(dataModel: HotelsArray, tapAction: Selector? = nil) {
        
        if let classData = dataModel.classData.first,
            let hotelClass = HotelClass(rawValue: classData) {
            hotelCalssLabel.text = " 旅館類別： \(hotelClass.description)"
        } else {
            hotelCalssLabel.text = "旅店未提供"
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
            
            if let tapAction {
                let tap = UITapGestureRecognizer(target: self, action: tapAction)
                webLabel.isUserInteractionEnabled = true
                webLabel.addGestureRecognizer(tap)
            }
        } else {
            webLabel.text = "旅店未提供"
            webLabel.textColor = UIColor.black
        }
    }
}
