//
//  CommentCell.swift
//  InstagramApp
//
//  Created by Md. Asiuzzaman on 1/8/23.
//

import UIKit

class CommentCell: UICollectionViewCell {
    
    var viewModel: CommentViewModel? {
        didSet {
            configure()
        }
    }
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.image = UIImage(imageLiteralResourceName: "venom-7")
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    
     private let commentLabel: UILabel =  {
         let label = UILabel()
         return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(profileImageView)
        profileImageView.centerY(
            inView: self,
            leftAnchor: leftAnchor,
            paddingLeft: 8
        )
        profileImageView.setDimensions(height: 40, width: 40)
        profileImageView.layer.cornerRadius = 40 / 2
        
        addSubview(commentLabel)
        commentLabel.centerY(
            inView: profileImageView,
            leftAnchor: profileImageView.rightAnchor,
            paddingLeft: 8
        )
        commentLabel.anchor(right: rightAnchor, paddingRight: 8)
        commentLabel.numberOfLines = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure() {
        guard let viewModel else { return }
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        commentLabel.attributedText = viewModel.commentLabelText()
    }
}
