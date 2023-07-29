//
//  UploadPostController.swift
//  InstagramApp
//
//  Created by Md. Asiuzzaman on 29/7/23.
//

import UIKit

class UploadPostController: UIViewController {
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(imageLiteralResourceName: "venom-7")
        return imageView
    }()
    
    private lazy var captionTextView: InputTextView = {
        let textView = InputTextView()
        textView.placeholderText = "Enter caption..."
        textView.font = .systemFont(ofSize: 16)
        textView.delegate = self
        return textView
    }()
    
    private let charCountLabel: UILabel =  {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 14)
        label.text = "0/100"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    @objc func didTapCancle() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapShare() {
        print("didTapShare")
    }
    
    func checkMaxLength(for textView: UITextView) {
        if textView.text.count > 100 {
            textView.deleteBackward()
        }
    }
    
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Upload Post"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(didTapCancle)
        )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .done, target: self, action: #selector(didTapShare))
        
        view.addSubview(photoImageView)
        photoImageView.layer.cornerRadius = 50
        photoImageView.setDimensions(height: 180, width: 180)
        photoImageView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            paddingTop: 0
        )
        photoImageView.centerX(inView: view)
        
        
        view.addSubview(captionTextView)
        captionTextView.anchor(
            top: photoImageView.bottomAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            paddingTop: 16,
            paddingLeft: 12,
            paddingRight: 12,
            height: 64
        )
        view.addSubview(charCountLabel)
        
        charCountLabel.anchor(
            bottom: captionTextView.bottomAnchor,
            right: view.rightAnchor,
            paddingBottom: 12,
            paddingRight: 12
        )
        
    }
}

extension UploadPostController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        checkMaxLength(for: textView)
        let count = textView.text.count
        charCountLabel.text = "\(count)/100"
        //captionTextView.placeholderLabel.isHidden = !captionTextView.text.isEmpty
    }
}
