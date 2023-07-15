//
//  ImageCollectionViewCell.swift
//  寶島旅社
//
//  Created by Eric Lin on 2022/10/20.
//  Copyright © 2022 Eric Lin. All rights reserved.
//

import UIKit

class ImageDataCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var hotelImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            //圓角
            titleLabel.layer.cornerRadius = 15
            titleLabel.layer.masksToBounds = true
            
            //邊框線條
            titleLabel.layer.borderWidth = 2
            titleLabel.layer.borderColor = UIColor.mainGreen.cgColor
            
            titleLabel.backgroundColor = UIColor.white
        }
    }
}
