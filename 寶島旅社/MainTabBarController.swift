//
//  MainTabBarController.swift
//  Pitaya
//
//  Created by Eric Lin on 2022/10/14.
//  Copyright © 2022 Eric Lin. All rights reserved.
//

import UIKit

/// TabBar Tag
///  - frontPage: 首頁
///  - collections: 收藏
///  - About: 設定
enum AppTag: Int {
    case frontPage = 0
    case collections
    case About
}

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TabBarStyle設定
        if #available(iOS 15.0, *) {
            let tabbarAppearance = UITabBarAppearance()
            tabbarAppearance.backgroundColor = UIColor.mainGreen

            tabbarAppearance.stackedLayoutAppearance.normal.iconColor = .white //未選中
            tabbarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [
                .foregroundColor: UIColor.white,
                .font: UIFont.boldSystemFont(ofSize: 14) ]

            tabbarAppearance.stackedLayoutAppearance.selected.iconColor = .mainRed //選中
            tabbarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [
                .foregroundColor: UIColor.mainRed,
                .font: UIFont.boldSystemFont(ofSize: 14) ]

            UITabBar.appearance().scrollEdgeAppearance = tabbarAppearance
            UITabBar.appearance().standardAppearance = tabbarAppearance

        } else {
            UITabBar.appearance().tintColor = UIColor.mainRed
            UITabBar.appearance().unselectedItemTintColor = UIColor.white //未選中
            UITabBar.appearance().barTintColor = UIColor.mainGreen
            UITabBar.appearance().backgroundColor = UIColor.mainGreen
        }
        
        setUpChildViewControllers()
        
    }
    
    // get.TabBar
    func setUpChildViewControllers() {
        let firstViewController = FrontPageViewController.makeToHome()
        addChildViewController(childController: firstViewController,
                               image: "briefcase.fill",
                               title: "首頁",
                               tag: .frontPage)
        
        let secondViewController = CollectionsViewController.make()
        addChildViewController(childController: secondViewController,
                               image: "list.clipboard",
                               title: "收藏",
                               tag: .collections)
        
        let thirdViewController = AboutViewController.make()
        addChildViewController(childController: thirdViewController,
                               image: "gearshape.2.fill",
                               title: "關於",
                               tag: .About)
    }
    
    // get.Navigation
    func addChildViewController(childController: UIViewController,
                                image: String,
                                title: String,
                                tag: AppTag) {
        
        childController.title = title
        childController.tabBarItem.image = UIImage.init(systemName: image)
        childController.tabBarItem.tag = tag.rawValue
    
        //let navigationController = MainNavigationViewController.init(rootViewController: childController) //使用Code製作NavigationViewController用法
        
        let navigationController = UINavigationController(rootViewController: childController)
        
        self.addChild(navigationController)
    }

}


