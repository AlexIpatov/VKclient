//
//  RecommendedCommunitiesTableViewController.swift
//  VKclient
//
//  Created by Mac on 08.07.2020.
//  Copyright © 2020 Alexander. All rights reserved.
//

import UIKit

class RecommendedCommunitiesTableViewController: UITableViewController {
    
    
    var searchGroups = [Group]()
    private let searchController = UISearchController(searchResultsController: nil)
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
       
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecommendedCommunityCell") as? recommendedCommunitiesCell else {fatalError()}
        var searchGroup : Group
        searchGroup = searchGroups[indexPath.row]
        cell.recommendedCommunityName.text = searchGroup.name
        let url = searchGroup.photo_200
        cell.recommendedCommunityImage.kf.setImage(with: URL(string: url))
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return searchGroups.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
extension RecommendedCommunitiesTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let networkService = NetworkService()
        networkService.loadGroupsSearch(token: Session.shared.token, name: searchController.searchBar.text!) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(groups):
                self.searchGroups = groups
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            case let .failure(error):
                print(error)
            }
        }
        tableView.reloadData()
    }
    
}
