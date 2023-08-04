//
//  InputTextView.swift
//  InstagramApp
//
//  Created by Md. Asiuzzaman on 29/7/23.
//

import UIKit

class InputTextView: UITextView {
    
     let placeholderLabel: UILabel = { /// Enter caption...
        let lebel = UILabel()
        lebel.textColor = .lightGray
        return lebel
    }()
    
    var placeholderText: String? {
        didSet {
            placeholderLabel.text = placeholderText
        }
    }
    
    var placeHolderShouldCenter = true {
        didSet {
            if placeHolderShouldCenter {
                placeholderLabel.anchor (
                    left: leftAnchor,
                    right: rightAnchor,
                    paddingLeft: 8
                )
                placeholderLabel.centerY(inView: self)
            }
            else {
                placeholderLabel.anchor(
                    top: topAnchor,
                    left: leftAnchor,
                    paddingTop: 6,
                    paddingLeft: 8
                )
            }
        }
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        addSubview(placeholderLabel)
        
        NotificationCenter
            .default
            .addObserver(
                self,
                selector: #selector(handleTextDidChange),
                name: UITextView.textDidChangeNotification,
                object: nil
            )
    }
    
    @objc func handleTextDidChange() {
       // print("[check] handleTextDidChange")
        placeholderLabel.isHidden = !text.isEmpty
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
