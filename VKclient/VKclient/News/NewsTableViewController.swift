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
    var buttonShareTapped: Bool = false
    var news: News?
    let networkService = NetworkService.shared
    let realmManager = RealmManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRefreshControl()
        loadNews()
        
        tableView.prefetchDataSource = self
        tableView.register(UINib(nibName: "NewsTableViewCellXib", bundle: nil), forCellReuseIdentifier: "NewsCellXib")
    }
    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Refreshing...")
        refreshControl?.tintColor = .blue
        refreshControl?.addTarget(self, action: #selector(refreshNews), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    @objc func refreshNews() {
        self.refreshControl?.beginRefreshing()
        
        loadNews()
        self.refreshControl?.endRefreshing()
    }
    private func loadNews() {
        networkService.loadPartNews(token: Session.shared.token, startFrom: "") { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(news):
                self.news = news
                self.tableView.reloadData()
            case let .failure(error):
                print(error)
            }
        }
    }
    // var indexPathCell: IndexPath!
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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
        let photoHeight = newsItems.height
        let photoWigth = newsItems.width
        var ratio: CGFloat = 1
        if photoHeight != 0 {
            ratio = CGFloat(photoWigth) / CGFloat(photoHeight)
        } else {
            ratio = tableView.frame.width
        }
        let calcPhotoHeight = tableView.frame.width / ratio
        cell.heightConstraint.constant = calcPhotoHeight
        let numberOfCharactersInNews = newsItems.newsText.count
        var newsTextCounted = newsItems.newsText
        var titleForButton = ""
        var buttonConstraint: CGFloat = 0
        if numberOfCharactersInNews > 200 {
            if buttonShareTapped {
                titleForButton = "Показать меньше"
            } else {
                newsTextCounted = String(newsTextCounted.dropLast(numberOfCharactersInNews - 200 ) + "...")
                titleForButton = "Показать больше"
            }
            buttonConstraint = 20
        }
        cell.showMoreButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        cell.buttonShowConstraint.constant = buttonConstraint
        cell.showMoreButton.setTitle(titleForButton, for: .normal)
        cell.newsTextLabel.text = newsTextCounted
        cell.numberOfViews.text = String(newsItems.numberOfViews)
        cell.countsOfLikeLabel.text = String(newsItems.numberOfLikes)
        cell.commentsLablel.text = String(newsItems.numberOfComments)
        cell.sharedLabel.text = String(newsItems.numberOfShares)

        
        return cell
        
    }
 
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news?.newsItems.count ?? 0
    }
    
    @objc func buttonTapped() {
        if buttonShareTapped {
            buttonShareTapped = false
        } else {
            buttonShareTapped = true
        }
        tableView.reloadData()
    }
    
    
}
extension NewsTableViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard indexPaths.contains(where: isloadingCell(for:)) else {
            return
        }
        networkService.loadPartNews(token: Session.shared.token, startFrom: Session.shared.nextFrom){ [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(news):
                self.news?.newsGroups =  (self.news?.newsGroups ?? []) + news.newsGroups
                self.news?.newsItems =  (self.news?.newsItems ?? []) + news.newsItems
                self.news?.newsProfiles =  (self.news?.newsProfiles ?? []) + news.newsProfiles
                
                self.tableView.reloadData()
                
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func isloadingCell(for indexPath: IndexPath) -> Bool {
        let newsCount = news?.newsItems.count ?? 0
        return indexPath.row == newsCount - 3
    }
}
