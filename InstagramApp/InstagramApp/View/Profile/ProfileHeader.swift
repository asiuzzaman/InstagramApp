//
//  ProfileHeader.swift
//  InstagramApp
//
//  Created by Md. Asiuzzaman on 25/7/23.
//

import UIKit

protocol ProfileHeaderDelegate: AnyObject {
    func header(_ profileHeader: ProfileHeader, didTapActionButtonFor user: User)
    //func header(_ profileHeader: ProfileHeader, wantsToUnfollow uid: String)
    //func headerWantsToShowEditProfile(_ profileHeader: ProfileHeader)
}

class ProfileHeader: UICollectionReusableView {
    
    var viewModel: ProfileHeaderViewModel? {
        didSet {
            configure()
        }
    }
    
    weak var delegate : ProfileHeaderDelegate?
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(imageLiteralResourceName: "venom-7")
        return imageView
    }()
    
    private let profileNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Asiuzzaman"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    private lazy var postLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var followerLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var followingLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    
    private let gridButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(imageLiteralResourceName: "grid"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.5)
        return button
    }()
    
    private let listButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(imageLiteralResourceName: "list"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.5)
        return button
    }()
    
    private let bookMarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(imageLiteralResourceName: "ribbon"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.5)
        return button
    }()
    
    private lazy var editProfileFollowButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.layer.cornerRadius = 3
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 0.5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(handleEditProfileFollowTapped), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, paddingTop: 16, paddingLeft: 12)
        profileImageView.setDimensions(height: 80, width: 80)
        profileImageView.layer.cornerRadius = 80 / 2
        
        addSubview(profileNameLabel)
        profileNameLabel.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, paddingTop: 12, paddingLeft: 12)
        addSubview(editProfileFollowButton)
        editProfileFollowButton.anchor(
            top: profileNameLabel.bottomAnchor,
            left: leftAnchor,
            right: rightAnchor,
            paddingTop: 16,
            paddingLeft: 24,
            paddingRight: 24
        )
        
        let stackView = UIStackView(arrangedSubviews: [postLabel, followerLabel, followingLabel])
        stackView.distribution = .fillEqually
        addSubview(stackView)
        stackView.centerY(inView: profileImageView)
        stackView.anchor(
            left: profileImageView.rightAnchor,
            right: rightAnchor,
            paddingLeft: 12,
            paddingRight: 12,
            height: 50
        )
        
        let topDeviver = UIView()
        topDeviver.backgroundColor = .lightGray

        let bottomDeviver = UIView()
        topDeviver.backgroundColor = .lightGray

        let buttonStack = UIStackView(arrangedSubviews: [gridButton, listButton, bookMarkButton])
        buttonStack.distribution = .fillEqually
        addSubview(buttonStack)
        addSubview(topDeviver)
        addSubview(bottomDeviver)

        buttonStack.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 50)
        topDeviver.anchor(top: buttonStack.topAnchor, left: leftAnchor, right: rightAnchor, height: 0.5)

        bottomDeviver.anchor(top: buttonStack.bottomAnchor, left: leftAnchor, right: rightAnchor, height: 0.5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleEditProfileFollowTapped() {
            print("Debug handleEditProfileFollowTapped is tapped")
        guard let viewModel else { return }
        delegate?.header(self, didTapActionButtonFor: viewModel.user)
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func configure() {
        guard let viewModel = viewModel else { return }
        guard let imageURL = viewModel.profileImageUrl else {
            print("[ProfileHeader] Couldn't get URL")
            return
        }
        
        print("[ProfileHeader] Configure")
        profileNameLabel.text = viewModel.fullName
        profileImageView.sd_setImage(with: imageURL)
        editProfileFollowButton.setTitle(viewModel.followButtonText, for: .normal)
        editProfileFollowButton.backgroundColor = viewModel.followButtonBackgroudColor
        editProfileFollowButton.setTitleColor(viewModel.followButtonTextColor, for: .normal)
        
        followerLabel.attributedText = viewModel.numberOfFollowers
        followingLabel.attributedText = viewModel.numberOfFollowing
        postLabel.attributedText = viewModel.numberOfPosts
    }
}
