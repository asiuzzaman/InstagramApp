//
//  ProfileController.swift
//  InstagramApp
//
//  Created by Md. Asiuzzaman on 22/7/23.
//

import UIKit

class ProfileController: UICollectionViewController {
    private let profileCellIdentifier = "profileCell"
    private let profileHeaderIdentifier = "headerIdentifier"
    
    private var user: User
    private var posts = [Post]()
    
    init(user: User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureProfile()
        checkIfUserIsFollowed()
        fetchUserStats()
        fetchPosts()
    }
        
    func checkIfUserIsFollowed() {
        UserService.checkIfUserIsFollowed(uid: user.uid) {
            isFollowed in
            self.user.isFollowed = isFollowed
            self.collectionView.reloadData()
        }
    }
    
    /// Collection data from FireStore for showing profile posted image
    func fetchPosts() {
        PostServices.fetchPosts(forUser: user.uid) {
            posts in
            self.posts = posts
            self.collectionView.reloadData()
        }
    }
    
    func fetchUserStats() {
        UserService.fetchUserStats(uid: user.uid) {
            userStats in
            self.user.stats = userStats
            self.collectionView.reloadData()
        }
    }
    
    func configureProfile() {
        navigationItem.title = user.userName
        collectionView.backgroundColor = .white
        collectionView.register(
            ProfileCell.self,
            forCellWithReuseIdentifier: profileCellIdentifier
        )
        collectionView.register(
            ProfileHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: profileHeaderIdentifier
        )
    }
}

// MARK: - UICollectionViewDataSource

extension ProfileController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("[ProfileController] numberOfItemsInSection is called")
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("[ProfileController] cellForItemAt is called")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: profileCellIdentifier, for: indexPath) as! ProfileCell
        cell.viewModel = PostViewModel(post: posts[indexPath.row])
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        print("[ProfileController] viewForSupplementaryElementOfKind is called")
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: profileHeaderIdentifier,
            for: indexPath
        ) as! ProfileHeader
        header.viewModel = ProfileHeaderViewModel(user: user)
        header.delegate = self
        return header
    }
    
}

// MARK: - UICollectionViewDelegate

extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        controller.post = posts[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ProfileController: UICollectionViewDelegateFlowLayout {
    
    // space between column
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
       return 1
    }
    
    // space between row
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    // Size of each box
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width, height: width)
    }
    
    // Size of profile Section
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 240)
    }
}

extension ProfileController: ProfileHeaderDelegate {
    func header(_ profileHeader: ProfileHeader, didTapActionButtonFor user: User) {
        print("[ProfileController] Handle action in controller")
        
        guard let tab = self.tabBarController as? MainTabController else { return }
        guard let currentUser = tab.user else { return }
        
        if user.isCurrentUser {
            print("Show edit profile")
        }
        else if user.isFollowed {
            print("Handle unfollow the user here")
            
            UserService.unfollow(uid: user.uid) {
                error in
                self.user.isFollowed = false
                self.collectionView.reloadData()
                PostServices.updateUserFeedAfterFollowing(user: user, didFollow: false)
            }
        }
        else {
            print("Handle follow the user here")
            UserService.follow(uid: user.uid) {
                error in
                self.user.isFollowed = true
                self.collectionView.reloadData()
                
                NotificationService.uploadNotification(
                    toUid: user.uid,
                    fromUser: currentUser,
                    type: .follow
                )
                
                PostServices.updateUserFeedAfterFollowing(user: user, didFollow: true)
            }
        }
    }
}


