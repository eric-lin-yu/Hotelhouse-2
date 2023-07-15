//
//  MapBottomSheetViewController.swift
//  寶島旅社
//
//  Created by wistronits on 2023/6/7.
//  Copyright © 2023 Eric Lin. All rights reserved.
//

import UIKit

class MapBottomSheetViewController: UIViewController {
    
    static func make() -> MapBottomSheetViewController {
        let storyboard = UIStoryboard(name: "MapSearchStoryboard", bundle: nil)
        let vc: MapBottomSheetViewController = storyboard.instantiateViewController(withIdentifier: "MapBottomSheetIdentity") as! MapBottomSheetViewController
        
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
}
