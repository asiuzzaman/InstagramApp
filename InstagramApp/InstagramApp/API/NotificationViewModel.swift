//
//  NotificationViewModel.swift
//  InstagramApp
//
//  Created by Md. Asiuzzaman on 6/8/23.
//

import UIKit

struct NotificationViewModel {
    
    var notification: Notification
    
    init(notification: Notification) {
        self.notification = notification
    }
    
    var postImageUrl: URL? {
        return URL(string: notification.postImageUrl ?? "")
    }
    
    var profileImageUrl: URL? {
        return URL(string: notification.userProfileImageUrl)
    }
    
    var timestampString: String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        
        return formatter.string(from: notification.timestamp.dateValue(), to: Date())
    }
    
    var notificationMessage: NSAttributedString {
        let username = notification.username
        let message = notification.type.notificationMessage
        let attText = NSMutableAttributedString(string: username, attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        attText.append(NSMutableAttributedString(string: message, attributes: [.font: UIFont.systemFont(ofSize: 14)]))
        
        attText.append(NSMutableAttributedString(
            string: " \(timestampString ?? "" )",
            attributes: [
                .font: UIFont.systemFont(ofSize: 12),
                .foregroundColor: UIColor.lightGray
            ]
        ))
        return attText
    }
    
    var shouldHidePostImage : Bool { self.notification.type == .follow }
    //var shouldHideFollowButton: Bool { notification.type != .follow }
    
    var followButtonText: String { return notification.userIsFollowed ? "Following" : "Follow"}
    var followButtonBackgroundColor: UIColor {
        return notification.userIsFollowed ? .white: .systemBlue
    }
    
    var followButtonTextColor: UIColor {
        return notification.userIsFollowed ? .black: .white
    }
    
}
