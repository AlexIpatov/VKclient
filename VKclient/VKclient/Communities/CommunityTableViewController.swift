//
//  CommunityTableViewController.swift
//  VKclient
//
//  Created by Mac on 08.07.2020.
//  Copyright © 2020 Alexander. All rights reserved.
//
import UIKit
import Kingfisher
import RealmSwift

class CommunityTableViewController: UITableViewController {
    private var filterGroups = [Group]()
    private var groups: Results<Group>? {
        let groups: Results<Group>? = realmManager?.getObjects()
        return groups
    }
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchBarEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false}
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarEmpty
    }
    private let networkService = NetworkService.shared
    private let realmManager = RealmManager.shared
    
    func loadData(completion: (() -> Void)? = nil){
        networkService.loadGroups(token: Session.shared.token)
        { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(groups):
                DispatchQueue.main.async {
                    try? self.realmManager?.add(objects: groups)
                    self.tableView.reloadData()
                    completion?()
                }
                
            case let .failure(error):
                print(error)
            }
        }
    }
    private var groupsNotificationToken: NotificationToken?
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        notification()
        
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        tableView.dataSource = self
        tableView.delegate = self
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommunityCell") as? CommunitiesCell else {fatalError()}
        var group: Group?
        if isFiltering {
            group = filterGroups[indexPath.row]
        } else {
            group = groups?[indexPath.row]
        }
        cell.communityName.text = group?.name
        let urlImg = group?.photo_200
        cell.communityImage.kf.setImage(with: URL(string: urlImg!))
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filterGroups.count
        } else {
            return groups?.count ?? 0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    private func notification() {
        groupsNotificationToken = groups?.observe  { [weak self] change in
            switch change {
            case .initial:
                #if DEBUG
                print("Initialized")
                #endif
            case let .update(results, deletions: deletions, insertions: insertions, modifications: modifications):
                #if DEBUG
                print("""
                    New count: \(results.count)
                    Deletions: \(deletions)
                    Insertions: \(insertions)
                    Modifications: \(modifications)
                    """)
                #endif
                self?.tableView.beginUpdates()
                self?.tableView.deleteRows(at: deletions.map { IndexPath(item: $0, section: 0) }, with: .automatic)
                self?.tableView.insertRows(at: insertions.map { IndexPath(item: $0, section: 0) }, with: .automatic)
                self?.tableView.reloadRows(at: modifications.map { IndexPath(item: $0, section: 0) }, with: .automatic)
                
                self?.tableView.endUpdates()
            case let .error(error):
                print(error)
            }
        }
    }
}
extension CommunityTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    private func filterContentForSearchText(_ searchText: String) {
        filterGroups = groups!.filter({(group: Group) -> Bool in
            return group.name.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
}
