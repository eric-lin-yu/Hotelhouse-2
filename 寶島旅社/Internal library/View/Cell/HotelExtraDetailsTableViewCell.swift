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
            spec_infView.roundFrameView(roundView: spec_infView)
        }
    }
    
    // 房間資訊
    @IBOutlet weak var roomsLabel: UILabel!
    @IBOutlet weak var roomsView: UIView! {
        didSet {
            roomsView.roundFrameView(roundView: roomsView)
        }
    }
    
    // 人數
    @IBOutlet weak var peopleLabel: UILabel!
    @IBOutlet weak var peopleView: UIView! {
        didSet {
            peopleView.roundFrameView(roundView: peopleView)
        }
    }
    
    // 停車位
    @IBOutlet weak var parkingLabel: UILabel!
    @IBOutlet weak var parkingView: UIView! {
        didSet {
            parkingView.roundFrameView(roundView: parkingView)
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
    
    func configure(dataModel: HotelDataModel) {
        var labelText = ""
        
        if !dataModel.spec.isEmpty {
            labelText += "\(dataModel.spec)\n\n"
        }
        
        if !dataModel.serviceinfo.isEmpty {
            labelText += "提供服務：\n\(dataModel.serviceinfo)\n"
        }
        
        if labelText.isEmpty {
            labelText = "誠摯歡迎您的到來！"
        }
        
        spec_infoLabel.text = labelText
        
        if dataModel.accessibilityRooms == "0" {
            roomsLabel.text = "：總共 \(dataModel.totalNumberofRooms) 間房"
        } else {
            roomsLabel.text = "：總共 \(dataModel.totalNumberofRooms) 間房\n 並提供無障礙客房 \(dataModel.accessibilityRooms) 間"
        }
        
        peopleLabel.text = "：可容納 \(dataModel.totalNumberofPeople) 人"
        
        if dataModel.parkingSpace != "0" {
            let parkinginfo = dataModel.parkinginfo.dropFirst(3)
            parkingLabel.text = "：\(parkinginfo)"
        } else {
            parkingLabel.text = "：很抱歉暫無提供停車位"
        }
    }
    
}
