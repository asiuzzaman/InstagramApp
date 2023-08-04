//
//  CommentController.swift
//  InstagramApp
//
//  Created by Md. Asiuzzaman on 1/8/23.
//

import Foundation
import UIKit

private let reuseIdentifier = "CommentCell"

class CommentController: UICollectionViewController {
    
    private lazy var commentInputView: CommentInputAccessoryView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let cv = CommentInputAccessoryView(frame: frame)
        cv.delegate = self
        return cv
    }()
    
    override var inputAccessoryView: UIView? {
        get { return commentInputView }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    private let post: Post
    
    init(post: Post) {
        self.post = post
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func configureUI() {
        collectionView.backgroundColor = .white
        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
    }
    
}

extension CommentController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CommentCell
        //cell.backgroundColor = .w
        return cell
    }
}

extension CommentController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
}

extension CommentController: CommentInputAccessoryViewDelegate {
    func inputView(_ inputVeiw: CommentInputAccessoryView, wantsToUploadComment comment: String) {
        
        guard let tab = self.tabBarController as? MainTabController else { return }
        
        guard let user = tab.user else { return }
        
        self.showLoader(true)
        
        CommentService.uploadComment(
            comment: comment,
            postID: post.postId,
            user: user) {
                error in
                if let err = error {
                    print("Gets error while upload your comments")
                }
                self.showLoader(false)
                inputVeiw.clearCommentTextView()
            }
        print("posted Comment: \(comment)")
    }
}
