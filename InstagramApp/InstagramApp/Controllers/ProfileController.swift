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
    
    private var user: User? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureProfile()
        fetchUser()
    }
    
    func fetchUser() {
        UserService.fetchuser { user in
            self.user = user
            self.navigationItem.title = user.userName
        }
    }
    
    func configureProfile() {
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
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: profileCellIdentifier, for: indexPath) as! ProfileCell
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        print("[ProfileController] viewForSupplementaryElementOfKind is called")
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: profileHeaderIdentifier, for: indexPath) as! ProfileHeader
        
        if let user = user {
            header.viewModel = ProfileHeaderViewModel(user: user)
        } else {
            print("Debug: ProfileController viewModel didn't set yet")
        }
        
        return header
    }
    
}

// MARK: - UICollectionViewDelegate

extension ProfileController {
    
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


