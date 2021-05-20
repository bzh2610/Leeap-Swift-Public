//
//  HistoryTableVC.swift
//  Leeap
//
//  Created by Evan OLLIVIER on 16/03/2019.
//  Copyright © 2019 Evan OLLIVIER. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON


class UserHistoryTableViewCell: UITableViewCell{
    @IBOutlet weak var titleLabel: UILabel!
     @IBOutlet weak var headlineTitle:UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
}

struct Headline_history_user {
     
     var id : Int
     var title : String
     var date : String
     var price : Double
     var qt: Int
     var headlineTitle: String = ""
     
}


class UserHistoryTable: UITableViewController{
    
     var headlines: [Headline_history_user] = []
    
    
     @objc func getHistory(_ sender: Any){
        
        Alamofire.request(Leeap.URL,
                          method: .post,
                          parameters: [
                            "consommations":[
                                "history":[
                                    "user": UserData.id
                                ]
                            ]
            ]
            ).responseJSON{
                response in
                
                switch response.result{
                case .success(let JSON):
                    print("Success with JSON: \(JSON)")
                    
                    let response = JSON as! NSDictionary
                    var today_row = false
                    var yesterday_row = false
                    var two_days_ago_row = false
                    var week_row = false
                    var month_row = false
                    
                    let history = response.object(forKey: "history")!
                    var id = 0
                    self.headlines.removeAll(keepingCapacity: false)
                    for row in history as! [[String : AnyObject]]{
                        id = id + 1
                        let amountStr = Int(row["Total"] as! String)!
                        var amount = Double(amountStr)
                        amount = -amount/100.00 //Les rechargement sont négatifs et inversement
                         let calendar = Calendar.current
                         let yesterday = calendar.date(byAdding: .day, value: -1, to: Date())
                         let twoDaysAgo = calendar.date(byAdding: .day, value: -2, to: Date())
                         
                         let currentDate = Date()
                         
                         let formatter = DateFormatter()
                         formatter.locale = Locale(identifier: "US_en")
                         formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
                         let date = formatter.date(from: row["Date"] as! String)!
                         
                         print(date)
                         print(currentDate)
                         print(Calendar.current.compare(currentDate, to: date, toGranularity: .weekOfYear))
                      
                         let dateoutput = DateFormatter()
                         dateoutput.locale = Locale(identifier: "FR_fr")
                         dateoutput.dateFormat = "dd MMMM, à hh:mm"
                         var now = "Le "+dateoutput.string(from: date as Date)
                         
                         
                         if(Calendar.current.compare(currentDate, to: date, toGranularity: .day) == .orderedSame){
                              if(today_row == false){
                              today_row=true
                              print("today")
                              self.headlines.append(Headline_history_user(id: -1,
                                                                     title: "",
                                                                     date: "",
                                                                     price: 0,
                                                                     qt: 0,
                                                                     headlineTitle: "Aujourd'hui"))
                              }
                              dateoutput.dateFormat = "hh:mm"
                              now = dateoutput.string(from: date as Date)
                              
                         }else if(Calendar.current.compare(yesterday!, to: date, toGranularity: .day) == .orderedSame){
                              if(yesterday_row == false){
                                   yesterday_row=true
                                   print("yesterday")
                                   self.headlines.append(Headline_history_user(id: -2,
                                                                               title: "",
                                                                               date: "",
                                                                               price: 0,
                                                                               qt: 0,
                                                                               headlineTitle: "Hier"))
                              }
                              dateoutput.dateFormat = "hh:mm"
                              now = dateoutput.string(from: date as Date)
                         }else if(Calendar.current.compare(twoDaysAgo!, to: date, toGranularity: .day) == .orderedSame){
                              if(two_days_ago_row == false){
                                   two_days_ago_row=true
                                   print("2days ago")
                                   self.headlines.append(Headline_history_user(id: -2,
                                                                               title: "",
                                                                               date: "",
                                                                               price: 0,
                                                                               qt: 0,
                                                                               headlineTitle: "Avant hier"))
                              }
                              dateoutput.dateFormat = "hh:mm"
                              now = dateoutput.string(from: date as Date)
                         }else if(Calendar.current.compare(currentDate, to: date, toGranularity: .weekOfYear) == .orderedSame){
                              if(week_row == false){
                              week_row=true
                              print("today")
                              self.headlines.append(Headline_history_user(id: -2,
                                                                     title: "",
                                                                     date: "",
                                                                     price: 0,
                                                                     qt: 0,
                                                                     headlineTitle: "Cette semaine"))
                              }
                         }else if(Calendar.current.compare(currentDate, to: date, toGranularity: .month) == .orderedSame){
                              if(month_row == false){
                                   week_row=true
                                   print("today")
                                   self.headlines.append(Headline_history_user(id: -2,
                                                                               title: "",
                                                                               date: "",
                                                                               price: 0,
                                                                               qt: 0,
                                                                               headlineTitle: "Ce mois ci"))
                              }
                         }
                         
                         print(amount)
                              self.headlines.append(Headline_history_user(id: id,
                                                                     title: (row["Name"] as! String),
                                                                     date: now,//row["Date"] as! String,
                                                                     price: amount,
                                                                     qt: Int(row["Qt"] as! String) ?? 1,
                                                                     headlineTitle: ""))
                         
                         
                        
                        
                        
                        
                    }
                    
                    self.headlines.append(Headline_history_user(id: -3,
                                                                title: "",
                                                                date: "",
                                                                price: 0,
                                                                qt: 0,
                                                                headlineTitle: "  "))
                    
                    self.tableView.reloadData()
                    
                case .failure(let error):
                    print("Request failed with error: \(error)")
                }
        }
    }
    
    
    
    
    
    
    
    // MARK: - Table view data source
    
    override func viewDidLoad() {
        self.tableView.rowHeight = 60.0
        //print(self.bracelet);
     self.getHistory(self)
        print(headlines)
     
     NotificationCenter.default.addObserver(self,
                                            selector: #selector( self.getHistory(_:) ),
                                            name: NSNotification.Name(rawValue: "reloadUserHistory"),
                                            object: nil)
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return headlines.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserHistoryCell", for: indexPath) as! UserHistoryTableViewCell
     
        var headline = headlines[indexPath.row]
        cell.titleLabel?.text = headline.title
        if(headline.qt > 1){
            cell.titleLabel?.text = headline.title+" x "+String(headline.qt)
        }
     
     cell.headlineTitle.isHidden=true
     cell.priceLabel?.isHidden=false
     cell.titleLabel?.isHidden=false
     cell.dateLabel?.isHidden=false
     cell.dateLabel?.text  = headline.date
     cell.priceLabel?.text = headline.price.formattedWithSeparator
     
     if(headline.price > 0){
          cell.priceLabel?.text = "+"+headline.price.formattedWithSeparator
     }
     
     print(indexPath)
     print("headline.headlineTitle "+String(headline.headlineTitle))
     print("headline.title "+String(headline.title))
     print("headline.price "+String(headline.price))
     print("headline.date.count "+String(headline.date.utf16.count))
     
     if(headline.headlineTitle.count > 0){
          print("headlineTitle == YES")
          cell.priceLabel?.isHidden=true
          cell.headlineTitle?.isHidden=false
          cell.titleLabel?.isHidden=true
          cell.dateLabel?.isHidden=true
          if(headline.date.count == 0){
               cell.headlineTitle?.text = headline.headlineTitle
          }
     }
        
        return cell
    }
    
}

