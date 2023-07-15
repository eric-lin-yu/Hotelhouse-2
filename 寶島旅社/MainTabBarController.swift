//
//  MainTabBarController.swift
//  Pitaya
//
//  Created by Eric Lin on 2022/10/14.
//  Copyright © 2022 Eric Lin. All rights reserved.
//

import UIKit

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
        addChildViewController(childController: firstViewController, image: "briefcase.fill", title: "首頁", tag: 0)
        
//        let secondViewController = LatesViewController.make()
//        addChildViewController(childController: secondViewController, image: "list.clipboard", title: "收藏", tag: 1)
        
        let thirdViewController = AboutViewController.make()
        addChildViewController(childController: thirdViewController, image: "gearshape.2.fill", title: "關於", tag:  2)
    }
    
    // get.Navigation
    func addChildViewController(childController: UIViewController, image: String, title: String, tag: Int) {
        childController.title = title
        childController.tabBarItem.image = UIImage.init(systemName: image)
        childController.tabBarItem.tag = tag
    
        //let navigationController = MainNavigationViewController.init(rootViewController: childController) //使用Code製作NavigationViewController用法
        
        let navigationController = UINavigationController(rootViewController: childController)
        
        self.addChild(navigationController)
    }

}


