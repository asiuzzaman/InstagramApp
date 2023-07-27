//
//  SearchController.swift
//  InstagramApp
//
//  Created by Md. Asiuzzaman on 22/7/23.
//

import UIKit

private let reuseIdentifier = "UserCell"

class SearchController: UITableViewController {
    
    private var users = [User]()
    private var filteredUsers = [User]()
    
    private var inSearchMode : Bool {
        searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    private let searchController = UISearchController(searchResultsController: nil)

    

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        fetchUsers()
        configureSearchController()
    }
    
    func configureTableView() {
        view.backgroundColor = .white
        tableView.register(SearchViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 64
    }
    
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = false
    }
    
    func fetchUsers() {
        UserService.fetchUsers {
            users in
            self.users = users
            self.tableView.reloadData()
            //print("user from search controller: \(users)")
        }
    }
}

extension SearchController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inSearchMode ? filteredUsers.count: users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SearchViewCell
        let user = inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        cell.searchViewCellViewModel = SearchViewCellViewModel(user: user)
        return cell
    }
}

extension SearchController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension SearchController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
       guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        
        filteredUsers = users.filter({
            $0.userName.lowercased().contains(searchText) ||
            $0.fullName.lowercased().contains(searchText)
        })
        
        self.tableView.reloadData()
    }
}
