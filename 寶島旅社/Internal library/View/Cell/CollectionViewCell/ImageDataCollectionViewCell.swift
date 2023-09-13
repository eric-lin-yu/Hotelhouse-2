//
//  ImageCollectionViewCell.swift
//  寶島旅社
//
//  Created by Eric Lin on 2022/10/20.
//  Copyright © 2022 Eric Lin. All rights reserved.
//

import UIKit

class ImageDataCollectionViewCell: UICollectionViewCell {
    //MARK: - UI
    private let hotelImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .mainRed
        label.font = .boldSystemFont(ofSize: 17)
        label.textAlignment = .center
        label.numberOfLines = 0
        
        //圓角
        label.layer.cornerRadius = 15
        label.layer.masksToBounds = true
        
        //邊框線條
        label.layer.borderWidth = 2
        label.layer.borderColor = UIColor.mainGreen.cgColor
        
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubView()
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - setup
    private func setupSubView() {
        addSubview(hotelImageView)
        addSubview(titleLabel)
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            hotelImageView.topAnchor.constraint(equalTo: topAnchor),
            hotelImageView.leftAnchor.constraint(equalTo: leftAnchor),
            hotelImageView.rightAnchor.constraint(equalTo: rightAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: hotelImageView.bottomAnchor, constant: 10),
            titleLabel.leftAnchor.constraint(equalTo: hotelImageView.leftAnchor),
            titleLabel.rightAnchor.constraint(equalTo: hotelImageView.rightAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),
        ])
    }
    
    func configure(with imageURL: String? = nil, title: String? = nil) {
        // Set hotel image
        if let imageURL = imageURL {
            hotelImageView.loadUrlImage(urlString: imageURL) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let image):
                        self.hotelImageView.image = image ?? UIImage(named: "嘎喔兔兔")
                    case .failure:
                        self.hotelImageView.image = UIImage(named: "嘎喔兔兔")
                    }
                }
            }
        } else {
            self.hotelImageView.image = UIImage(named: "嘎喔兔兔")
        }
        
        // Set title label
        titleLabel.text = title?.isEmpty == true ? "實景示意圖" : (title ?? "很抱歉，此旅店尚未提供圖檔哦~")
    }
}
