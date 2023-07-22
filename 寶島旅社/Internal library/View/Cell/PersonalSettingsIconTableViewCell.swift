//
//  PersonalSettingsTableViewCell.swift
//  CathayWalletPodTest
//
//  Created by Eric Lin on 2023/3/15.
//

import UIKit

class PersonalSettingsIconTableViewCell: UITableViewCell {
    //MARK: - UIs
    private let titleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let arrowRightImageView: UIImageView = {
        let imageView = UIImageView()
        
        let image = UIImage(named: "btnArrowRight(B)")
        imageView.image = image
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // addsubView
        addSubview(titleImageView)
        addSubview(titleNameLabel)
        addSubview(arrowRightImageView)
        
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - setup Constraint
    private func setupConstraint() {
        // Vertically
        NSLayoutConstraint.activate([
            arrowRightImageView.heightAnchor.constraint(equalToConstant: 24),
            
            titleImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            titleImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15),
            
            titleNameLabel.centerYAnchor.constraint(equalTo: titleImageView.centerYAnchor),
            arrowRightImageView.centerYAnchor.constraint(equalTo: titleImageView.centerYAnchor)
        ])
        
        // Horizontally
        NSLayoutConstraint.activate([
            titleImageView.widthAnchor.constraint(equalToConstant: 36),
            arrowRightImageView.widthAnchor.constraint(equalToConstant: 24),
            
            titleImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            titleNameLabel.leftAnchor.constraint(equalTo: titleImageView.rightAnchor, constant: 10),
            arrowRightImageView.leftAnchor.constraint(equalTo: titleNameLabel.rightAnchor, constant: 10),
            arrowRightImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20)
        ])
    }

    func configure(image: String, title: String) {
        
        titleImageView.image = UIImage(named: image)
        titleNameLabel.text = title

    }
}
