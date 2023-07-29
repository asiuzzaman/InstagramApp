//
//  InputTextView.swift
//  InstagramApp
//
//  Created by Md. Asiuzzaman on 29/7/23.
//

import UIKit

class InputTextView: UITextView {
    
   private let placeholderLabel: UILabel = { /// Enter caption...
        let lebel = UILabel()
        lebel.textColor = .lightGray
        return lebel
    }()
    
    var placeholderText: String? {
        didSet {
            placeholderLabel.text = placeholderText
        }
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        addSubview(placeholderLabel)
        placeholderLabel.anchor(
            top: topAnchor,
            left: leftAnchor,
            paddingTop: 6,
            paddingLeft: 8
        )
        
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
