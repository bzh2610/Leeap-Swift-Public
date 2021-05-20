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
import WebKit

struct Event{
    
    var id : Int
    var title : String
    var date : String
    var cover: String
    var attendees : Int
    var volume: Int
    var visible: Bool
    
}

class EventCell: UITableViewCell, WKNavigationDelegate{
    @IBOutlet weak var titleLabel: UILabel!
    var id: Int!
    var price: Double!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var background: UIImageView!
    var cover = WKWebView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cover.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(cover)
        contentView.bringSubviewToFront(background)
        contentView.bringSubviewToFront(cover)
        contentView.bringSubviewToFront(titleLabel)
        contentView.bringSubviewToFront(dateLabel)
        
        cover.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        cover.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        cover.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        cover.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
}




class EventSelector: UITableViewController{
    
    var events: [Event] = []
    
    func getHistory(){
        
        Alamofire.request(Leeap.URL,
                          method: .post,
                          parameters: [
                            "events":[
                                "list": true,
                            ]
            ]
            ).responseJSON{
                response in
                
                switch response.result{
                case .success(let JSON):
                    print("Success with JSON: \(JSON)")
                    
                    let response = JSON as! NSDictionary
                    
                    let history = response.object(forKey: "data")!
                    
                    self.events.removeAll(keepingCapacity: false)
                    for row in history as! [[String : AnyObject]]{
                    
                        print(row)
                        let id = Int(row["Id"] as? String ?? "0") ?? 0
                        
                        self.events.append(Event(id: id,
                                                               title: row["name"] as? String ?? "?",
                                                               date: row["date"] as? String ?? "",
                                                               cover: row["cover"] as? String ?? "",
                                                               attendees : row["attendees"] as? Int ?? 0,
                                                               volume: row["volume"] as? Int ?? 0,
                                                               visible: row["visible"] as? Bool ?? true
                            )
                        )
                        
                    }
                    
                    self.tableView.reloadData()
                    
                case .failure(let error):
                    print("Request failed with error: \(error)")
                }
        }
    }
    
    

    
    // MARK: - Table view data source
    
    override func viewDidLoad() {
        self.tableView.rowHeight = 120.0

        self.getHistory();
     //   print(headlines)
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventCell
        
        
        let event = events[indexPath.row]
        

        print(cell.cover.frame)
        cell.cover.uiDelegate = self as? WKUIDelegate
        //cell.cover.isUserInteractionEnabled=false
        cell.cover.contentMode = .scaleAspectFill
        cell.cover.alpha = 0.2
        cell.cover.backgroundColor=UIColor.red
       
        
        print(indexPath.row)
        if((indexPath.row+1) % 5 == 0){
             cell.background?.image = UIImage(named: "card_blue")
        }else if((indexPath.row+1) % 4 == 0){
            cell.background?.image = UIImage(named: "card_green")
        }else if((indexPath.row+1) % 3 == 0){
            cell.background?.image = UIImage(named: "card_orange")
        }else if((indexPath.row+1) % 2 == 0){
            cell.background?.image = UIImage(named: "card_red")
        }else{
            cell.background?.image = UIImage(named: "card_violet")
        }
       
        cell.titleLabel?.text = event.title
        cell.dateLabel?.text  = event.date
        cell.id = event.id
        if (!event.cover.isEmpty){
        let myURL = URL(string: event.cover)
        let myRequest = URLRequest(url: myURL!)
             cell.cover.load(myRequest)
        }
       
        
        
        
        return cell
    }
    
}

