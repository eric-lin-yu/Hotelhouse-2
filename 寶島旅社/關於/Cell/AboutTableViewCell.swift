//
//  AboutTableViewCell.swift
//  寶島旅社
//
//  Created by Eric Lin on 2022/11/9.
//  Copyright © 2022 Eric Lin. All rights reserved.
//

import UIKit

class AboutTableViewCell: UITableViewCell {
    
    @IBOutlet weak var aboutBcakgroundView: UIView! {
        didSet {
//            aboutBcakgroundView.roundFrameView(roundView: aboutBcakgroundView)
        }
    }
    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
