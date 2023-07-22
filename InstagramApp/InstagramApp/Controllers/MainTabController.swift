//
//  MainTabController.swift
//  InstagramApp
//
//  Created by Md. Asiuzzaman on 22/7/23.
//

import UIKit

class MainTabController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewControllers()
    }
    
    func configureViewControllers() {
        view.backgroundColor = .white
        let feed = FeedController()
        let search = SearchController()
        let image = ImageSelectorController()
        let notifications = NotificationController()
        let profie = ProfileController()
        viewControllers = [feed, search, image, notifications, profie]
    }
}
