//
//  MainTabController.swift
//  InstagramApp
//
//  Created by Md. Asiuzzaman on 22/7/23.
//

import UIKit
import Firebase

class MainTabController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewControllers()
        checkIfUserIsLoggedIn()
        //logout()
    }
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let controller = LoginController()
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
        }
        catch {
            print("[Logout] MainTabController: Failed to Signout")
        }
    }
    
    func configureViewControllers() {
        view.backgroundColor = .white
        
        let layout = UICollectionViewFlowLayout()
        let feed = templateNavigationController(
            unselectedImage: UIImage(imageLiteralResourceName: "home_unselected"),
            selectedImage: UIImage(imageLiteralResourceName: "home_selected"),
            viewController: FeedController(collectionViewLayout: layout)
        )
        let search = templateNavigationController(
            unselectedImage: UIImage(imageLiteralResourceName: "search_unselected"),
            selectedImage: UIImage(imageLiteralResourceName: "search_selected"),
            viewController: SearchController()
        )
        let image = templateNavigationController(
            unselectedImage: UIImage(imageLiteralResourceName: "plus_unselected"),
            selectedImage: UIImage(imageLiteralResourceName: "plus_unselected"),
            viewController: ImageSelectorController()
        )
        let notifications = templateNavigationController(
            unselectedImage: UIImage(imageLiteralResourceName: "like_unselected"),
            selectedImage: UIImage(imageLiteralResourceName: "like_selected"),
            viewController: NotificationController()
        )
        let profie = templateNavigationController(
            unselectedImage: UIImage(imageLiteralResourceName: "profile_unselected"),
            selectedImage: UIImage(imageLiteralResourceName: "profile_selected"),
            viewController: ProfileController()
        )
        
        viewControllers = [feed, search, image, notifications, profie]
        tabBar.tintColor = .black
    }
    
    func templateNavigationController(
        unselectedImage: UIImage,
        selectedImage: UIImage,
        viewController: UIViewController) -> UINavigationController
    {
        let nav = UINavigationController(rootViewController: viewController)
        nav.tabBarItem.image = unselectedImage
        nav.tabBarItem.selectedImage = selectedImage
        nav.navigationBar.tintColor = .black
        return nav
    }
}
