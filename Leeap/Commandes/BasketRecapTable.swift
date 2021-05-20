//
//  BasketRecapTable.swift
//  Leeap
//
//  Created by Evan OLLIVIER on 03/03/2019.
//  Copyright © 2019 Evan OLLIVIER. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

struct Row {
    
    var id : Int
    var title : String
    var date : String
    var price : Double
    var qt: Int
    
}

class RecapTableViewCell: UITableViewCell{
    @IBOutlet weak var titleLabel: UILabel!
    var id: Int!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var qtLabel: UILabel!

    @IBAction func delete_item(_ sender: Any) {
        print("deleting item..")
        let conso:[String: Any] = ["title": self.titleLabel?.text]
       AdminCart.card.removeValue(forKey: self.id)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "deleteCartItem"), object: nil, userInfo: conso)
    }
    
    
}




class BasketRecapTable: UITableViewController{
    
    var headlines = [
        Row(id: 1, title: "Chargement...", date: "", price: 0.00, qt: 0),
        ]
    var pannier : [String: Any] = [:]
    var total = 0.00
    
    @objc func deleteItem(_ notification: NSNotification){
        
      //  if let dict = notification.userInfo as Dictionary? {
          //  if let item = dict["title"] as! String? {
                
              //  pannier.removeValue(forKey: item)
                self.updateSubTotal()
         //   }
    //    }
    }
    
    @objc func updateSubTotal(){
        print("BasketRecapTable.updateSubtotal")

                    self.headlines.removeAll(keepingCapacity: false)
                    for (item, dictionnary) in AdminCart.card {
                        
            
                        total = total + (dictionnary["price"] as! Double) * Double(dictionnary["qt"] as! Int)
                        
                        
                        self.headlines.append(Row(id: item,
                                                  title: dictionnary["title"] as! String,
                                                       date: "",
                                                       price: (dictionnary["price"] as! Double),
                                                       qt:dictionnary["qt"] as! Int
                        ))
                        
                    }
                    
                      self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func viewDidLoad() {
        self.tableView.rowHeight = 60.0
      //  self.getHistory();
        print("BasketRecapTable.viewDidLoad()")
      //  print(pannier)
        self.updateSubTotal()
        
         NotificationCenter.default.addObserver(self, selector: #selector(self.deleteItem(_:)), name: NSNotification.Name(rawValue: "deleteCartItem"), object: nil)
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return headlines.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecapCell", for: indexPath) as! RecapTableViewCell
        
      
        var headline = headlines[indexPath.row]
          cell.id = headline.id
        cell.titleLabel?.text = headline.title
        cell.qtLabel?.text = String(headline.qt)
        if(headline.price > 0.0){
            //Pass
        }else{
            headline.price = -headline.price
        }
        
        cell.priceLabel?.text = String(format: "%.2f", headline.price)+"€"
        
        return cell
    }
    
}


