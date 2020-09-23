//
//  NewsTableViewController.swift
//  VKclient
//
//  Created by Mac on 21.07.2020.
//  Copyright © 2020 Alexander. All rights reserved.
//

import UIKit
import RealmSwift
import Kingfisher
class NewsTableViewController: UITableViewController {
    
   
       
    var news: News?

  let networkService = NetworkService.shared
    let realmManager = RealmManager.shared
    override func viewDidLoad() {
        super.viewDidLoad()
        networkService.loadNews(token: Session.shared.token) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case let .success(news):
                    self.news = news
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                case let .failure(error):
                    print(error)
                }
            }
           
        

       tableView.register(UINib(nibName: "NewsTableViewCellXib", bundle: nil), forCellReuseIdentifier: "NewsCellXib")
       
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCellXib") as?  NewsTableViewCellXib else {fatalError()}
    
        let newsItems = news!.newsItems[indexPath.row]
        let id = newsItems.id
        let newsGroups = news?.newsGroups.filter{$0.id == -id}.first
        let newsProfiles = news?.newsProfiles.filter{$0.id == id}.first
        if newsGroups == nil{
            let avaUrl = newsProfiles?.authorAva
                      cell.authorAva.kf.setImage(with: URL(string: avaUrl ?? ""))
                      cell.authorNameLabel.text = newsProfiles?.authorName
          
        } else {
          let avaUrl = newsGroups?.groupAva
                    cell.authorAva.kf.setImage(with: URL(string: avaUrl ?? ""))
            cell.authorNameLabel.text = newsGroups?.groupName
        }
        let url = newsItems.newsPhoto
        cell.newsPhoto.kf.setImage(with: URL(string: url ))
        cell.newsTextLabel.text = newsItems.newsText
       
        
        
        
        return cell
           
       }
       override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return news?.newsItems.count ?? 0
       }
       
   
}
