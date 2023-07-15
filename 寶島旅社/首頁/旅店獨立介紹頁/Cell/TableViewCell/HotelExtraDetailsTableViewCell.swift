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
    
    func configure(dataModel: DataInfoArray) {
        
        // 補充說明
        if dataModel.spec != "" && dataModel.serviceinfo != "" {
            let spec = dataModel.spec
            let serviceinfo = dataModel.serviceinfo
            spec_infoLabel.text = "\(spec)\n\n提供服務：\n\(serviceinfo)"
        } else if dataModel.spec == "" && dataModel.serviceinfo != "" {
            spec_infoLabel.text = "\(dataModel.serviceinfo)"
        } else if dataModel.spec != "" && dataModel.serviceinfo == ""{
            spec_infoLabel.text = "\(dataModel.spec)"
        } else {
            spec_infoLabel.text = "誠摯歡迎您的到來！"
        }
        
        // 房間數
        if dataModel.accessibilityRooms == "0" {
            roomsLabel.text = "：總共 \(dataModel.totalNumberofRooms) 間房"
        } else {
            // 實測accessibilityRooms目前參數皆為 0,因此暫時不會進入此
            roomsLabel.text = "：總共 \(dataModel.totalNumberofRooms) 間房\n 並提供無障客房 \(dataModel.accessibilityRooms)間"
        }
        // 容納人數
        peopleLabel.text = "：可容納 \(dataModel.totalNumberofPeople) 人"
        
        // 停車位
        if dataModel.parkingSpace != "0" {
            let parkinginfo = dataModel.parkinginfo.dropFirst(3)
            parkingLabel.text = "：\(parkinginfo)"
        } else {
            parkingLabel.text = "：很抱歉暫無提供停車位"
        }
        
    }
    
}
