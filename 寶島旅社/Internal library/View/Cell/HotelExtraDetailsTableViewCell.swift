//
//  HotelDetailTableViewCell.swift
//  寶島旅社
//
//  Created by Eric Lin on 2022/10/27.
//  Copyright © 2022 Eric Lin. All rights reserved.
//

import UIKit

class HotelExtraDetailsTableViewCell: UITableViewCell {
    // 額外補充說明
    @IBOutlet weak var spec_infoLabel: UILabel!
    @IBOutlet weak var spec_infView: UIView! {
        didSet {
            spec_infView.addRoundBorder()
        }
    }
    
    // 房間資訊
    @IBOutlet weak var roomsLabel: UILabel!
    @IBOutlet weak var roomsView: UIView! {
        didSet {
            roomsView.addRoundBorder()
        }
    }
    
    // 人數
    @IBOutlet weak var peopleLabel: UILabel!
    @IBOutlet weak var peopleView: UIView! {
        didSet {
            peopleView.addRoundBorder()
        }
    }
    
    // 停車位
    @IBOutlet weak var parkingLabel: UILabel!
    @IBOutlet weak var parkingView: UIView! {
        didSet {
            parkingView.addRoundBorder()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(dataModel: Hotels) {
        var labelText = ""
        
        if !dataModel.spec.isEmpty {
            labelText += "\(dataModel.spec)\n\n"
        }
        
        if !dataModel.serviceInfo.isEmpty {
            labelText += "提供服務：\n\(dataModel.serviceInfo)\n"
        }
        
        if labelText.isEmpty {
            labelText = "誠摯歡迎您的到來！"
        }
        
        spec_infoLabel.text = labelText
        
        if dataModel.accessibleRooms == "0" {
            roomsLabel.text = "：總共 \(dataModel.totalRooms) 間房"
        } else {
            roomsLabel.text = "：總共 \(dataModel.totalRooms) 間房\n 並提供無障礙客房 \(dataModel.accessibleRooms) 間"
        }
        
        peopleLabel.text = "：可容納 \(dataModel.totalCapacity) 人"
        
        if dataModel.parkingSpaces != "0" {
            let parkinginfo = dataModel.parkingInfo.dropFirst(3)
            parkingLabel.text = "：\(parkinginfo)"
        } else {
            parkingLabel.text = "：很抱歉暫無提供停車位"
        }
    }
    
}
