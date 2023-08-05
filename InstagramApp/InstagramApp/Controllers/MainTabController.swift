//
//  MainTabController.swift
//  InstagramApp
//
//  Created by Md. Asiuzzaman on 22/7/23.
//

import UIKit
import Firebase
import YPImagePicker

class MainTabController: UITabBarController {
    
     var user: User? {
        didSet {
            guard let user else { return }
            configureViewControllers(withUser: user)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserIsLoggedIn()
        //logout()
        fetchUser()
    }
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let controller = LoginController()
                controller.delegate = self
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
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        UserService.fetchuser(withUid: uid) { user in
            self.user = user
        }
    }
    
    func configureViewControllers(withUser user: User) {
        view.backgroundColor = .white
        
        self.delegate = self
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
        
        ///  profile layout
        let profileController = ProfileController(user: user)
        let profie = templateNavigationController(
            unselectedImage: UIImage(imageLiteralResourceName: "profile_unselected"),
            selectedImage: UIImage(imageLiteralResourceName: "profile_selected"),
            viewController: profileController
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
    
    func didFinishPickingMedia(for picker: YPImagePicker) {
        picker.didFinishPicking { items, _ in
            picker.dismiss(animated: false) {
                guard let selectedImage = items.singlePhoto?.image else { return }
                print(" Debug: Selected Image is : \(selectedImage)")
                
                let postController = UploadPostController()
                postController.selectedImage = selectedImage
                postController.delegate = self
                postController.currentUser = self.user
                let nav = UINavigationController(rootViewController: postController)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: false, completion: nil)
            }
            
        }
        
    }
}

extension MainTabController: AuthenticationDelegate {
    func authenticationDidComplete() {
        print("Tapped authenticationDidComplete")
        fetchUser()
        self.dismiss(animated: true, completion: nil)
    }
}

extension MainTabController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.firstIndex(of: viewController)

        if index == 2 {
            var config = YPImagePickerConfiguration()
            config.library.mediaType = .photo
            config.shouldSaveNewPicturesToAlbum = false
            config.startOnScreen = .library
            config.screens = [.library]
            config.hidesStatusBar = false
            config.hidesBottomBar = false
            config.library.maxNumberOfItems = 1
            
            
            let picker = YPImagePicker(configuration: config)
            picker.modalPresentationStyle = .fullScreen
            present(picker, animated: true, completion: nil)
            didFinishPickingMedia(for: picker)
        }

        return true
    }
}

extension MainTabController: UploadPostControllerDelegate {
    func didFinishUploadingPost(_ controller: UploadPostController) {
        selectedIndex = 0
        controller.dismiss(animated: true, completion: nil)
        
        guard let navController = viewControllers?.first as? UINavigationController else { return }
        guard let feed = navController.viewControllers.first as? FeedController else { return }
        feed.handleRefreshController()
    }
}
