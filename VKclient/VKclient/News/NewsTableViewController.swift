//
//  NewsTableViewController.swift
//  VKclient
//
//  Created by Mac on 21.07.2020.
//  Copyright © 2020 Alexander. All rights reserved.
//

import UIKit

class NewsTableViewController: UITableViewController {
    
    
    var newsArray = [
        News(newsLext: "Сегодня солнечно", newsPhoto: UIImage(named: "sunny"), numberOfViews: "20", authorAva: UIImage(named: "weather"), authorName: "Погода на сегодня"),
        News(newsLext: "Открытие ресторана на берегу Невы", newsPhoto: UIImage(named: "rest"), numberOfViews: "10", authorAva: UIImage(named: "community2"), authorName: "Куда сходить?")
    ]


    override func viewDidLoad() {
        super.viewDidLoad()

    
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell") as? NewsTableViewCell else {fatalError()}
       
        cell.authorNameLabel.text = newsArray[indexPath.row].authorName
        cell.authorAva.image = newsArray[indexPath.row].authorAva
        cell.newsLextLabel.text = newsArray[indexPath.row].newsLext
        cell.newsPhoto.image = newsArray[indexPath.row].newsPhoto
        cell.numberOfViews.text = newsArray[indexPath.row].numberOfViews
    
         
             
           return cell
           
       }
       override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
           return newsArray.count
       }
       
      
    
      
       

    
  

   

}
