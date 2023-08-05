//
//  CommentViewModel.swift
//  InstagramApp
//
//  Created by Md. Asiuzzaman on 5/8/23.
//

import Foundation
import Firebase

struct CommentViewModel {
    let comment: Comment
    
    init(comment: Comment) {
        self.comment = comment
    }
    
    var commentText: String {
        comment.commentText
    }
    
    var timestamp: Timestamp {
        comment.timestamp
    }
    
    //var userProfileImageUrl: URL? { URL(string: post.ownerImageUrl) }
    var profileImageUrl: URL? {
        URL(string: comment.profileImageUrl)
    }
    
    
    func size(forWidth width: CGFloat) -> CGSize {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = comment.commentText
        label.lineBreakMode = .byCharWrapping
        label.setWidth(width)
        return label.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
    
    
    func commentLabelText() -> NSAttributedString {
        
        let attributedString = NSMutableAttributedString(string: comment.userName + " " , attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        
        attributedString.append(NSAttributedString(string: comment.commentText, attributes: [.font: UIFont.boldSystemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        
        return attributedString
    }
}


