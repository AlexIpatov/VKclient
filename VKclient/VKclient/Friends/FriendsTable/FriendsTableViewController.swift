//
//  FriendsTableViewController.swift
//  VKclient
//
//  Created by Mac on 08.07.2020.
//  Copyright © 2020 Alexander. All rights reserved.
//

import UIKit
import RealmSwift
import Kingfisher
class FriendsTableViewController: UITableViewController {
    private var friends: Results<User>? {
        let friends: Results<User>? = realmManager?.getObjects()
        return friends
    }
    var sortedFriends = [Character: [User]]()
    
    let interactiveTransition = InteractiveTransition()
    
    func sortFriends(friends: [User]) -> [Character: [User]]  {
        var friendsDict = [Character: [User]]()
        
        friends
            .sorted { $0.first_name < $1.first_name }
            .forEach { friend in
                guard let firstChar = friend.first_name.first else { return }
                if var thisChar = friendsDict[firstChar] {
                    thisChar.append(friend)
                    friendsDict[firstChar] = thisChar
                } else {
                    friendsDict[firstChar] = [friend]
                }
        }
        
        return friendsDict
    }
    
    
    
    
    //searchController
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var searchBarEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false}
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarEmpty
    }
    let networkService = NetworkService.shared
     private let realmManager = RealmManager.shared
    
    private func loadData() {
        networkService.loadFriends(token: Session.shared.token) {
                 [weak self] result in
                 guard let self = self else { return }
                 switch result {
                 case let .success(friends):
                     DispatchQueue.main.async {
                         try? self.realmManager?.add(objects: friends)
                         self.tableView.reloadData()
                       
                     }
                      self.sortedFriends = self.sortFriends(friends: friends)
                     
                     
                 case let .failure(error):
                     print(error)
                 }
             }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        
       
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: "SectionHeaderForFriendsTableView", bundle: nil), forHeaderFooterViewReuseIdentifier: "headerFriendsTable")
    }
    
    //---------------------
    override func numberOfSections(in tableView: UITableView) -> Int {
        if isFiltering {
            return 1
        } else {
            return sortedFriends.keys.count
        }
    }
    
    override  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell") as? FriendsCell else {fatalError()}
        
        var user: User
        
        
        if isFiltering {
            user = filterFriends[indexPath.row]
        } else {
            let firstChar = sortedFriends.keys.sorted()[indexPath.section]
            let friends = sortedFriends[firstChar]!
            user = friends[indexPath.row]
        }
        let urlImg = user.photo_100
        cell.avaImage.kf.setImage(with: URL(string: urlImg))
        
        cell.titleLabel.text = String(user.first_name + " " + user.last_name)
        
        return cell
        
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let  section = sortedFriends.keys.sorted()[section]
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "headerFriendsTable") as? SectionHeaderForFriendsTableView else {fatalError()}
        if isFiltering {
            header.Char.text = "Результаты поиска:"
        } else {
            header.Char.text = String(section)
        }
        
        return header
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "friendsPhotoVC") as? PhotoFriendsCollectionViewController else {
            return
        }
        var user: User
        
        
        if isFiltering {
            user = filterFriends[indexPath.row]
        } else {
            let firstChar = sortedFriends.keys.sorted()[indexPath.section]
            let friends = sortedFriends[firstChar]!
            user = friends[indexPath.row]
        }
        
        
        vc.userID = user.id
        navigationController?.delegate = self
        navigationController?.pushViewController(vc, animated: true)
        
        
        
        
    }
    
    
    private var filterFriends = [User]()
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filterFriends.count
        } else {
            let keysSorted = sortedFriends.keys.sorted()
            return sortedFriends[keysSorted[section]]?.count ?? 0
            
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    
}
// search
extension FriendsTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    
    private func filterContentForSearchText(_ searchText: String) {
        filterFriends = friends!.filter({(friend: User) -> Bool in
            return friend.first_name.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
}


// animator


extension FriendsTableViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .pop {
            if navigationController.viewControllers.first != toVC {
                interactiveTransition.viewController = toVC
            }
            return PopAnimator()
        } else {
            interactiveTransition.viewController = toVC
            return PushAnimator()
        }
        
    }
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        return interactiveTransition.hasStarted ? interactiveTransition : nil
    }
}
