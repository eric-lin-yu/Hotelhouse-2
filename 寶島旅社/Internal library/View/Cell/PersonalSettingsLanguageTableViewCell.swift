//
//  PersonalSettingsLanguageTableViewCell.swift
//  CathayWalletPodTest
//
//  Created by Eric Lin on 2023/3/16.
//

import UIKit

class PersonalSettingsLanguageTableViewCell: UITableViewCell {
    //MARK: - UIs
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.whitesmokeGray
        // addsubView
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - setup Constraint
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            
            subtitleLabel.leftAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 10),
            subtitleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            subtitleLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
        ])
    }
    
    func configure(title: String, subtitle: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
    
}
