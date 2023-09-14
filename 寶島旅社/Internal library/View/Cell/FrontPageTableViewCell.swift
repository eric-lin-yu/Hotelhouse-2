//
//  FrontPageTableViewCell.swift
//  寶島旅社
//
//  Created by Eric Lin on 2022/11/15.
//  Copyright © 2022 Eric Lin. All rights reserved.
//

import UIKit

class FrontPageTableViewCell: UITableViewCell {
    static let cellIdenifier = "FrontPageIdenifier"
    
    @IBOutlet weak var hotelimageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    ///旅館民宿之管理權責單位代碼
    @IBOutlet weak var govLabel: UILabel!
    ///星級
    @IBOutlet weak var gradeLabel: UILabel!

    ///介紹
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var hotleCalssLabel: UILabel!
    @IBOutlet weak var addLabel: UILabel!
    
    @IBOutlet weak var phoneBtn: UIButton!
    @IBOutlet weak var webBtn: UIButton!
    @IBOutlet weak var emailBtn: UIButton!
    @IBOutlet weak var loveBtn: UIButton!
    
    @IBOutlet weak var govView: UIView! {
        didSet {
            govView.roundFrameView(roundView: govView)
        }
    }
 
    @IBOutlet weak var buttonView: UIView! {
        didSet {
            buttonView.roundFrameView(roundView: buttonView)
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
}

