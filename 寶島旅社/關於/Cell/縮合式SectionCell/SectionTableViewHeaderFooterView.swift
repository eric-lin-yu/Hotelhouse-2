//
//  SectionTableViewHeaderFooterView.swift
//  Pitaya
//
//  Created by Eric Lin on 2022/1/10.
//  Copyright © 2022 Eric Lin. All rights reserved.
//

import UIKit

protocol SectionViewDelegate {
    func sectionView(_ sectionView: SectionTableViewHeaderFooterView, _ didPressTag: Int, _ isExpand: Bool)
}

class SectionTableViewHeaderFooterView: UITableViewHeaderFooterView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var arrowBth: UIButton!
    @IBOutlet weak var sectionBcakgroundView: UIView! {
        didSet {
            sectionBcakgroundView.roundFrameView(roundView: sectionBcakgroundView)
        }
    }
    
    var delegate: SectionViewDelegate?
    var buttonTag: Int!
    var isExpand: Bool! //cell的狀態(展開/縮合)
    
    //觸擊按鈕
    @IBAction func pressExpendButton(_ sender: UIButton) {
        self.delegate?.sectionView(self, self.buttonTag, self.isExpand)
    }
}
