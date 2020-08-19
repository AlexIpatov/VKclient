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
    
    private var groups = [Group]()
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
        let networkService = NetworkService()
        networkService.loadGroups(token: Session.shared.token)
        { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(groups):
                self.groups = groups
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            case let .failure(error):
                print(error)
            }
        }
        
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
        var group: Group
        
        if isFiltering {
            group = filterGroups[indexPath.row]
        } else {
            group = groups[indexPath.row]
        }
        cell.communityName.text = group.name
        let urlImg = group.photo_200
        cell.communityImage.kf.setImage(with: URL(string: urlImg))
        
        return cell
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering {
            return filterGroups.count
        } else {
            return groups.count
        }
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            groups.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .right)
            tableView.endUpdates()
            
        }
    }
    
    
    /*    @IBAction func addCommunity(_ sendoer: Any) {
     let alert = UIAlertController(title: "Введите название сообщества", message: nil, preferredStyle: .alert)
     alert.addTextField{(textField) in
     textField.placeholder = "Название"
     }
     let action = UIAlertAction(title: "ОК", style: .default){[weak self, weak alert] (action) in
     guard let firstText = alert?.textFields?.first?.text else {return}
     
     self?.addCommunity(name: firstText)
     }
     
     alert.addAction(action)
     present(alert,animated: true, completion: nil)
     }
     
     / private func addCommunity(name: String){
     
     groups.append(Group.init(id: name: name, photo_200: nil))
     tableView.reloadData()
     
     
     }
     */
    private var filterGroups = [Group]()
    
}
extension CommunityTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    private func filterContentForSearchText(_ searchText: String) {
        filterGroups = groups.filter({(group: Group) -> Bool in
            return group.name.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
}
