//
//  CommentInputAccessoryView.swift
//  InstagramApp
//
//  Created by Md. Asiuzzaman on 3/8/23.
//

import Foundation
import UIKit

protocol CommentInputAccessoryViewDelegate: AnyObject {
    func inputView(_
        inputVeiw: CommentInputAccessoryView,
        wantsToUploadComment comment: String
    )
}

class CommentInputAccessoryView: UIView {
    
    weak var delegate: CommentInputAccessoryViewDelegate?
    
    private let commentTextView: InputTextView = {
        let textView = InputTextView()
        textView.placeholderText = "Enter your comments..."
        textView.font = .systemFont(ofSize: 14)
        textView.isScrollEnabled = false
        textView.placeHolderShouldCenter = true
        return textView
    }()
    
    private let postButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("POST", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 15)
        button.addTarget(self, action: #selector(didTapPostButton), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        autoresizingMask = .flexibleHeight
        backgroundColor = .white
        
        addSubview(postButton)
        postButton.anchor(top: topAnchor, right: rightAnchor, paddingRight: 8)
        postButton.setDimensions(height: 50, width: 50)
        addSubview(commentTextView)
        commentTextView.anchor(
            top: topAnchor,
            left: leftAnchor,
            bottom: safeAreaLayoutGuide.bottomAnchor,
            right:  postButton.leftAnchor,
            paddingTop: 8,
            paddingLeft: 8,
            paddingBottom: 8,
            paddingRight: 8
        )
        
        let devider = UIView()
        devider.backgroundColor = .lightGray
        addSubview(devider)
        devider.anchor(
            top: topAnchor,
            left: leftAnchor,
            right: rightAnchor,
            height: 0.5
        )
    }
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    @objc func didTapPostButton() {
        delegate?.inputView(self, wantsToUploadComment: commentTextView.text)
    }
    
    func clearCommentTextView() {
        commentTextView.text = nil
        commentTextView.placeholderLabel.isHidden = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
