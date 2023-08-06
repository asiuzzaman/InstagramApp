//
//  FeedController.swift
//  InstagramApp
//
//  Created by Md. Asiuzzaman on 22/7/23.
//

import UIKit
import Firebase

private let reuseIdentifier = "Cell"
class FeedController: UICollectionViewController {
    
    private var posts = [Post]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var post: Post?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        fetchPosts()
    }
    
    /// Collection data from FireStore
    func fetchPosts() {
        
        guard post == nil else { return }
        
        PostServices.fetchPosts {
            posts in
            self.posts = posts
            print("fetchPosts is called ")
            self.collectionView.refreshControl?.endRefreshing()
            self.checkIfUserLikedPost()
        }
    }
    
    func checkIfUserLikedPost() {
        self.posts.forEach {
            post in
            PostServices.checkIfUserLikedPost(post: post) {
                didLike in
                //print("post is: \(post.caption) and Like is: \(didLike)")
                if let index = self.posts.firstIndex(where: { $0.postId == post.postId }) {
                    self.posts[index].didLike = didLike
                }
                
            }
        }
    }
    
    
    @objc func handleLogout() {
        
        do {
            try Auth.auth().signOut()
            let controller = LoginController()
            controller.delegate = self.tabBarController as? MainTabController
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
        catch {
            print("[Logout] MainTabController: Failed to Signout")
        }
    }
    
    // MARK: - Helpers
    func configureView() {
        collectionView.backgroundColor = .white
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        if post == nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                title: "Logout",
                style: .plain,
                target: self,
                action: #selector(handleLogout)
            )
        }
        
        navigationItem.title = "Feed"
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(handleRefreshController), for: .valueChanged)
        collectionView.refreshControl = refresher
    }
    
    @objc func handleRefreshController() {
        posts.removeAll()
        fetchPosts()
    }
    
}

extension FeedController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return post == nil ? posts.count : 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedCell
        
        cell.delegate = self
        
        if let post = post {
            cell.viewModel = PostViewModel(post: post)
        } else {
            cell.viewModel = PostViewModel(post: posts[indexPath.row])
        }
       
        return cell
    }
    
}

extension FeedController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.frame.width
        let height = width + 8 + 40 + 50 + 60
        return CGSize(width: width, height: height)
    }
}

extension FeedController: FeedCellDelegate {
    func cell(_ cell: FeedCell, wantsToShowProfile uid: String) {
        UserService.fetchuser(withUid: uid) {
            user in
            let controller = ProfileController(user: user)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func cell(_ cell: FeedCell, wantsToShowCommentsFor post: Post) {
        print("wantsToShowCommentsFor tapped")
        let commentController = CommentController(post: post)
        navigationController?.pushViewController(commentController, animated: true)
    }
    
    func cell(_ cell: FeedCell, didLike post: Post) {
        //print("didlike tapped")
        
        cell.viewModel?.post.didLike.toggle()
        guard let tab = self.tabBarController as? MainTabController else { return }
        guard let user = tab.user else { return }
        
        if post.didLike {
            print("Unlike your post")
            PostServices.unlikePost(post: post) { _ in
                cell.likeButton.setImage(UIImage(imageLiteralResourceName: "like_unselected"), for: .normal)
                cell.likeButton.tintColor = .black
                cell.viewModel?.post.likes = post.likes - 1
            }
        }
        else {
            print("Send like this post")
            PostServices.likePost(post: post) { error in
                if let error = error {
                    print("Failed to like this post: \(error.localizedDescription)")
                }
                cell.likeButton.setImage(UIImage(imageLiteralResourceName: "like_selected"), for: .normal)
                cell.likeButton.tintColor = .red
                cell.viewModel?.post.likes = post.likes + 1
                NotificationService.uploadNotification(
                    toUid: post.ownerId,
                    fromUser: user,
                    type: .like,
                    post: post
                )
            }
        }
    }
}
