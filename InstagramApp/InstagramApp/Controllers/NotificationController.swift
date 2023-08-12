//
//  NotificationController.swift
//  InstagramApp
//
//  Created by Md. Asiuzzaman on 22/7/23.
//

import UIKit

private let reuseIdentifier = "NotificationCell"

class NotificationController: UITableViewController {
    
    private var notifications = [Notification]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    private let refresher = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUITableView()
        fetchNotifications()
    }
    
    func fetchNotifications() {
        NotificationService.fetchNotifications {
            notifications in
            self.notifications = notifications
            self.checkIfUserIsFollowed()
            print("Fetched Notifications are: \(notifications)")
        }
    }
    func checkIfUserIsFollowed() {
        notifications.forEach { notification in
            
            guard notification.type == .follow else { return }
            
            UserService.checkIfUserIsFollowed(uid: notification.uid) { isFollowed in
               // guard let self else { return }
                if let index = self.notifications.firstIndex(where: {$0.id == notification.id}) {
                    self.notifications[index].userIsFollowed = isFollowed
                }
            }
        }
    }
    
    @objc func handleRefresh() {
        notifications.removeAll()
        fetchNotifications()
        refresher.endRefreshing()
    }
    
    func configureUITableView() {
        view.backgroundColor = .white
        navigationItem.title = "Notifications"
        tableView.register(NotificationCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
        
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = refresher
    }
}

// MARK: UITableViewDataSource
extension NotificationController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NotificationCell
        cell.viewModel = NotificationViewModel(notification: notifications[indexPath.row])
        cell.delegate = self
        return cell
    }
}

// MARK: UITableViewDelegate
extension NotificationController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("[NotificationController] didSelectRowAt")
        showLoader(true)
        
        let uid = notifications[indexPath.row].uid
        UserService.fetchuser(withUid: uid) {
            user in
            let controller = ProfileController(user: user)
            self.navigationController?.pushViewController(controller, animated: true)
            self.showLoader(false)
        }
    }
}

// MARK: NotificationCellDelegate
extension NotificationController: NotificationCellDelegate {
    func cell(_ cell: NotificationCell, wantsToFollow uid: String) {
        print("[NotificationController] wantsToFollow")
        showLoader(true)
        UserService.follow(uid: uid) { _ in
            self.showLoader(false)
            cell.viewModel?.notification.userIsFollowed.toggle()
        }
    }
    
    func cell(_ cell: NotificationCell, wantsToUnfollow uid: String) {
        print("[NotificationController] wantsToUnfollow")
        showLoader(true)
        UserService.unfollow(uid: uid) { _ in
            self.showLoader(false)
            cell.viewModel?.notification.userIsFollowed.toggle()
        }
    }
    
    func cell(_ cell: NotificationCell, wantsToViewPost postId: String) {
        print("[NotificationController] wantsToViewPost")
        showLoader(true)
        PostServices.fetchPost(withPostId: postId) {
            post in
            self.showLoader(false)
            let controller = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
            controller.post = post
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    
}

