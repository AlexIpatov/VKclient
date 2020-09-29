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
import PromiseKit
class FriendsTableViewController: UITableViewController {
    private var friends: Results<User>? {
        let friends: Results<User>? = realmManager?.getObjects()
        return friends
    }
    var sortedFriends = [[User]]() {
    didSet {
        sortedIds = sortedFriends.map { $0.map { $0.id } }
           
           if let friends: Results<User> = realmManager?.getObjects() {
            self.cachedUserIds = Array(friends).map { $0.id }
           } else {
               cachedUserIds.removeAll()
           }
       }
    }
    let interactiveTransition = InteractiveTransition()
    var sortedIds = [[Int?]]()
    var cachedUserIds = [Int?]()

    
  
    
    
    
    
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
        networkService.loadFriends(token: Session.shared.token)
            .get {  [weak self] friends in
                guard let self = self else { return }
                try? self.realmManager?.add(objects: friends)
                self.tableView.reloadData()
        }
            .catch{ [weak self] error in
                print("Error: \(error)")
        }
    }

   
    private var friendsNotificationToken: NotificationToken?
    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
       realmNotification()
      

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: "SectionHeaderForFriendsTableView", bundle: nil), forHeaderFooterViewReuseIdentifier: "headerFriendsTable")
    }
    deinit {
            friendsNotificationToken?.invalidate()
        }
    
    private func getUserIndexPathByRealmOrder(order: Int) -> IndexPath? {
        guard order < cachedUserIds.count, let userId = cachedUserIds[order] else { return nil }
        
        guard let section = sortedIds.firstIndex(where: { $0.contains(userId) }),
            let item = sortedIds[section].firstIndex(where: { $0 == userId }) else { return nil }
        
        return IndexPath(item: item, section: section)
    }
    
    //---------------------
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
       
            user = sortedFriends[indexPath.section][indexPath.item]
        }
        let urlImg = user.photo_100
        cell.avaImage.kf.setImage(with: URL(string: urlImg))
        
        cell.titleLabel.text = String(user.first_name + " " + user.last_name)
        
        return cell
        
    }
    private func sortFriends() {
         sortedFriends.removeAll()
         
         guard let ffriends = friends else { return }
         let friends: [User] = Array(ffriends)
         var sortedFriends = [[User]]()
         
         let groupedElements = Dictionary(grouping: friends) { friend -> String in
            return String(friend.first_name.prefix(1))
         }
         let sortedKeys = groupedElements.keys.sorted()
         sortedKeys.forEach { key in
             if let values = groupedElements[key] {
                 sortedFriends.append(values)
             }
         }
         
         self.sortedFriends = sortedFriends
     }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let  section = sortedFriends[section].first?.first_name.first ?? " "
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
            user = sortedFriends[indexPath.section][indexPath.item]
        }
        
        
        vc.userID = user.id
        navigationController?.delegate = self
        navigationController?.pushViewController(vc, animated: true)
        
        
        
        
    }
    
    func realmNotification() {
        friendsNotificationToken = friends?.observe  { [weak self] change in
        guard let self = self else { return }
                  switch change {
                  case .initial:
                    self.sortFriends()
                       self.tableView.reloadData()
                  
                  case let .update(results, deletions: deletions, insertions: insertions, modifications: modifications):
                      #if DEBUG
                      print("""
                          New count: \(results.count)
                          Deletions: \(deletions)
                          Insertions: \(insertions)
                          Modifications: \(modifications)
                      """)
                      #endif
                      
                      let deletions = deletions.compactMap { self.getUserIndexPathByRealmOrder(order: $0) }
                      let modifications = modifications.compactMap { self.getUserIndexPathByRealmOrder(order: $0) }
                                    
                        self.sortFriends()
                      let insertions = insertions.compactMap { self.getUserIndexPathByRealmOrder(order: $0) }
                                  
                                  guard insertions.count == 0 else {
                                      self.tableView.reloadData()
                                      return
                                  }
                                  
                        self.tableView.beginUpdates()
                      if !modifications.isEmpty {
                                        self.tableView.reloadRows(at: modifications, with: .automatic)
                                    }
                                    if !deletions.isEmpty {
                                        let rowsInDeleteSections = Set(deletions.map { $0.section })
                                            .compactMap { ($0, self.tableView.numberOfRows(inSection: $0)) }
                                        let sectionsWithOneCell = rowsInDeleteSections.filter { section, count in count == 1 }.map { section, _ in section }
                                        let sectionsWithMoreCells = rowsInDeleteSections.filter { section, count in count > 1 }.map { section, _ in section }
                                        if sectionsWithOneCell.count > 0 {
                                            self.tableView.deleteSections(IndexSet(sectionsWithOneCell), with: .automatic)
                                        }
                                        if sectionsWithMoreCells.count > 0 {
                                            let indexForDeletion = deletions.filter { sectionsWithMoreCells.contains($0.section) }
                                            self.tableView.deleteRows(at: indexForDeletion, with: .automatic)
                                        }
                                    }

                      self.tableView.endUpdates()
                      
                  case let .error(error):
                    print(error)
                    
                    
                  }
              }

    }
    
    private var filterFriends = [User]()
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filterFriends.count
        } else {
            return  sortedFriends[section].count
            
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


/*
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
 
 
 case let .failure(error):
 print(error)
 }
 }
 }
 */
    
