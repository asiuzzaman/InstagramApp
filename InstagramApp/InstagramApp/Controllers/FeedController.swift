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
    
    private var posts = [Post]()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        fetchPosts()
    }
    
    /// Collection data from FireStore
    func fetchPosts() {
        PostServices.fetchPosts {
            posts in
            self.posts = posts
            print("fetchPosts is called ")
            self.collectionView.refreshControl?.endRefreshing()
            self.collectionView.reloadData()
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
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
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
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedCell
        cell.viewModel = PostViewModel(post: posts[indexPath.row])
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
