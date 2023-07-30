//
//  SearchViewCell.swift
//  InstagramApp
//
//  Created by Md. Asiuzzaman on 27/7/23.
//

import UIKit
import SDWebImage

class SearchViewCell: UITableViewCell {
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.image = UIImage(imageLiteralResourceName: "venom-7")
        return imageView
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "zaman"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    var searchViewCellViewModel: SearchViewCellViewModel? {
        didSet {
            configureSearchViewCell()
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func configureSearchViewCell() {
        guard let viewModel = searchViewCellViewModel else { return }
        
        guard let imageURL = viewModel.profileImageURL else {
            print("[ProfileHeader] Couldn't get URL")
            return
        }
        userNameLabel.text = viewModel.userName
        fullNameLabel.text = viewModel.userFullName
        profileImageView.sd_setImage(with: viewModel.profileImageURL)
    }
    
    private let fullNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Md. Asiuzzaman"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(profileImageView)
        profileImageView.setDimensions(height: 48, width: 48)
        profileImageView.layer.cornerRadius = 48 / 2
        profileImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
        
        let stackView = UIStackView(arrangedSubviews: [userNameLabel, fullNameLabel])
        
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .leading
        
        addSubview(stackView)
        stackView.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 8)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
