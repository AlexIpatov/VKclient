//
//  CommunityTableViewController.swift
//  VKclient
//
//  Created by Mac on 08.07.2020.
//  Copyright © 2020 Alexander. All rights reserved.
//

import UIKit

class CommunityTableViewController: UITableViewController {


    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
    }

 
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommunityCell") as? CommunitiesCell else {fatalError()}
       let data = groups[indexPath.row]
        cell.communityName.text = data.name
        cell.communityImage.image = data.avatar
          
        return cell
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return groups.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
           if editingStyle == .delete {
                  tableView.beginUpdates()
               groups.remove(at: indexPath.row)
               tableView.deleteRows(at: [indexPath], with: .right)
            tableView.endUpdates()
               
           }
       }
    @IBAction func addCommunity(_ sendoer: Any) {
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
    
    private func addCommunity(name: String){
      
        groups.append(Group.init(name: name, avatar: nil))
        tableView.reloadData()
      
        
    }
}
