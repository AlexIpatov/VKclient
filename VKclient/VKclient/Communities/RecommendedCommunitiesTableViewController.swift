//
//  RecommendedCommunitiesTableViewController.swift
//  VKclient
//
//  Created by Mac on 08.07.2020.
//  Copyright © 2020 Alexander. All rights reserved.
//

import UIKit

class RecommendedCommunitiesTableViewController: UITableViewController {

       
       var recommendedCommunities = [
           "SomeCommunity",
           "SomeCommunity2"
       ]
       
       var name = "GeekBrains"
       
       override func viewDidLoad() {
           super.viewDidLoad()
           tableView.dataSource = self
           tableView.delegate = self
        loadGroupsSearch(token: Session.shared.token, name: name)
       }

    
       override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecommendedCommunityCell") as? recommendedCommunitiesCell else {fatalError()}
        cell.recommendedCommunityName.text = recommendedCommunities[indexPath.row]
           return cell
           
       }

       override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
           return recommendedCommunities.count
       }
       
       override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 90
       }
      
}
