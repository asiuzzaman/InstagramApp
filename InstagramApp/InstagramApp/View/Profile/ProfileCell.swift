//
//  ProfileCell.swift
//  InstagramApp
//
//  Created by Md. Asiuzzaman on 25/7/23.
//

import UIKit

class ProfileCell : UICollectionViewCell {
    
    
    private let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(imageLiteralResourceName: "venom-7")
        return imageView
    }()
    
    var viewModel: PostViewModel? {
        didSet {
            configure()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        addSubview(postImageView)
        postImageView.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        guard let viewModel else { return }
        postImageView.sd_setImage(with: viewModel.imageUrl)
    }
}
