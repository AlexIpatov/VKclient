//
//  FriendsTableViewController.swift
//  VKclient
//
//  Created by Mac on 08.07.2020.
//  Copyright © 2020 Alexander. All rights reserved.
//

import UIKit


class FriendsTableViewController: UITableViewController {
    
    let interactiveTransition = InteractiveTransition()
    var friends = [
        User(name: "Алеша", avatar:  UIImage(named: "manAva"), photos: aleshaPhoto),
        User(name: "Артур", avatar:  UIImage(named: "manAva"), photos: aleshaPhoto),
        User(name: "Даша", avatar:  UIImage(named: "womanAva"), photos: dashaPhoto),
        User(name: "Дмитрий", avatar: UIImage(named: "manAva"), photos: alexPhoto),
        User(name: "Саша",avatar: UIImage(named: "manAva"), photos: alexPhoto),
        User(name: "Сергей", avatar: UIImage(named: "manAva"), photos: alexPhoto)
        
        
    ]
    
    var sortedFriends = [
        [User(name: "Алеша", avatar:  UIImage(named: "manAva"), photos: aleshaPhoto),
          User(name: "Артур", avatar:  UIImage(named: "manAva"), photos: aleshaPhoto)],
        [User(name: "Даша", avatar:  UIImage(named: "womanAva"), photos: dashaPhoto),
         User(name: "Дмитрий", avatar: UIImage(named: "manAva"), photos: alexPhoto)],
        [User(name: "Саша",avatar: UIImage(named: "manAva"), photos: alexPhoto),
         User(name: "Сергей", avatar: UIImage(named: "manAva"), photos: alexPhoto)]
    ]
    
    
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var searchBarEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false}
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarEmpty
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
          loadFriends(token: Session.shared.token)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: "SectionHeaderForFriendsTableView", bundle: nil), forHeaderFooterViewReuseIdentifier: "headerFriendsTable")
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if isFiltering {
            return 1
        } else {
            return sortedFriends.count
        }
    }
    
    override  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell") as? FriendsCell else {fatalError()}
        var user: User
        if isFiltering {
            user = filterFriends[indexPath.row]
        } else {
            user = sortedFriends[indexPath.section][indexPath.row]
        }
        
        cell.avaImage.image = user.avatar
        cell.titleLabel.text = String(user.name)
        
        return cell
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        var charFriends = friends.map{$0.name.first!}
        
        var seen: Set<Character> = []
        charFriends = charFriends.filter {
            if seen.contains($0) {
                return false
            }
            else {
                seen.insert($0)
                return true
            }
        }
        let  section = charFriends[section]
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
            user = sortedFriends[indexPath.section][indexPath.row]
        }
        
        
        vc.photoInPhotoCollection = user.photos
        navigationController?.delegate = self
        navigationController?.pushViewController(vc, animated: true)
        
        
        
        
    }
    private var filterFriends = [User]()
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filterFriends.count
        } else {
            return sortedFriends[section].count
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    /*
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     friends.remove(at: indexPath.row)
     
     tableView.deleteRows(at: [indexPath], with: .right)
     
     
     }
     }
     
     */
    
    
}
extension FriendsTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    
    private func filterContentForSearchText(_ searchText: String) {
        filterFriends = friends.filter({(friend: User) -> Bool in
            return friend.name.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
}


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
