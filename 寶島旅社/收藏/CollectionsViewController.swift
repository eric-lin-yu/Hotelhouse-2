//
//  CollectionsViewController.swift
//  寶島旅社
//
//  Created by wistronits on 2023/7/28.
//  Copyright © 2023 Eric Lin. All rights reserved.
//

import UIKit

class CollectionsViewController: UIViewController {
    
    // constraint Spacing
    private let spacing: CGFloat = 20
    private let topSpacing: CGFloat = 30
    private let bottomSpacing: CGFloat = 35
    private let btnHeight: CGFloat = 50
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    //MARK: - UI
    private let bgImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "<#imageName#>")
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    //MARK: - setup
    private func setupViews() {
        
        let viewsToAdd: [UIView] = [
            //...
        ]
        viewsToAdd.forEach { view.addSubview($0) }
    }
    
    private func setupConstraint() {
        let topSafeArea = view.safeAreaLayoutGuide.topAnchor
        let leftSafeArea = view.safeAreaLayoutGuide.leftAnchor
        let rightSafeArea = view.safeAreaLayoutGuide.rightAnchor
        let bottomSafeArea = view.safeAreaLayoutGuide.bottomAnchor
        
        NSLayoutConstraint.activate([
            
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraint()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

}
