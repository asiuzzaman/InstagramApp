//
//  FeedCell.swift
//  InstagramApp
//
//  Created by Md. Asiuzzaman on 23/7/23.
//

import UIKit

class FeedCell: UICollectionViewCell {
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.image = UIImage(imageLiteralResourceName: "venom-7")
        return imageView
    }()
    
    private lazy var userNameButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Venom", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.addTarget(self, action: #selector(didTapUserName), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        addSubview(profileImageView)
        profileImageView.anchor(
            top: topAnchor,
            left: leftAnchor,
            paddingTop: 12,
            paddingLeft: 12
        )
        
        profileImageView.setDimensions(height: 40, width: 40)
        profileImageView.layer.cornerRadius = 40 / 2
        
        addSubview(userNameButton)
        userNameButton.centerY (
            inView: profileImageView,
            leftAnchor: profileImageView.rightAnchor,
            paddingLeft: 8
        )
    }
    
    @objc func didTapUserName() {
        print("Debug: userName button tapped")
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
