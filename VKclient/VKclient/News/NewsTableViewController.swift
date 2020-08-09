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
        News(newsLext: "Сегодня солнечно, осадков не ожидается. Температура воздуха +25 градусов.", newsPhoto: UIImage(named: "sunny"), numberOfViews: "20", authorAva: UIImage(named: "weather"), authorName: "Погода на сегодня"),
        News(newsLext: "Открытие ресторана на берегу Невы. В первый вечер работы ресторана для всех посетителей выступят изветсные исполнители. Не пропустите!", newsPhoto: UIImage(named: "rest"), numberOfViews: "10", authorAva: UIImage(named: "community2"), authorName: "Куда сходить?"),
        News(newsLext: "Когда-то Ричи называли «британским Тарантино», и могло казаться, что для подобного рода сравнений есть основания – взять хотя бы общность криминальной тематики и любовь к ярким персонажам. Но как раз в «Джентльменах» (к которым Ричи сам написал сценарий) очень хорошо видны различия двух режиссеров: там, где Тарантино выстраивает сложные стилизации под ушедшие эпохи и щедрой рукой рассыпает миллионы отсылок к поп-культуре, претензии Ричи намного более скромны. Он снимает стильный детектив в привычных для него декорациях, делая ставку на распутывание сюжетных линий, в то время как замысловатые игры с нарративом его явно интересуют намного меньше. Так что его новая работа должна понравиться всем, кто помнит «Большой куш» и «Карты, деньги, два ствола»: это не «опять», а «снова». «Джентльмены» - это классический фильм Гая Ричи, со всеми плюсами и минусами, только выполненный на более высоком уровне, и с большим числом звездных имен на афише. Как выясняется, годы работы над многомиллионными блокбастерами не прошли даром, но Ричи все еще нигде не чувствует себя так же комфортно, как в кишащем разнокалиберными гангстерами Лондоне.", newsPhoto: UIImage(named: "news3"), numberOfViews: "60", authorAva: UIImage(named:"films"), authorName: "Кино")
        
    ]


    override func viewDidLoad() {
        super.viewDidLoad()
       tableView.register(UINib(nibName: " NewsTableViewCellXib", bundle: nil), forCellReuseIdentifier: "NewsCellXib")
       
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCellXib") as?  NewsTableViewCellXib else {fatalError()}

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
