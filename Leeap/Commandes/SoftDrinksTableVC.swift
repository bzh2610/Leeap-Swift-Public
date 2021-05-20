//
//  SoftDrinksTableVC.swift
//  Leeap
//
//  Created by Evan OLLIVIER on 01/03/2019.
//  Copyright © 2019 Evan OLLIVIER. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Alamofire

struct Headline {
    
    var id : Int
    var title : String
    var date : String
    var price : Double
    var qt: Int
    
}

class DrinksTableViewCell: UITableViewCell{
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var qtLabel: UILabel!
    @IBOutlet weak var x: UILabel!
    @IBOutlet weak var increment: UIButton!
    var id: Int!
    

    
    @IBAction func increment(_ sender: Any) {
        self.x.isHidden=false
        var val = 1
        
        if((self.qtLabel.text?.count)! > 0 ){
            val = ((self.qtLabel.text! as NSString).integerValue + 1)
        }
        
        self.qtLabel.text = String(val)
        let conso:[String: Any] = ["title": self.titleLabel?.text, "price": (self.priceLabel?.text as! NSString).doubleValue, "qt": val ]
       // if(AdminCart.card[self.id] == nil){
            AdminCart.card[self.id] = conso
print(AdminCart.card)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "addSoftDrink"), object: nil, userInfo: nil)
        
    }
    
    @IBAction func decrement(_ sender: Any) {
        var val = ((self.qtLabel.text! as NSString).integerValue - 1)
       
        
        if(val<=0){
            val=0
            self.qtLabel.text = ""
            self.x.isHidden=true
        }else{
            self.qtLabel.text = String(val)
        }
        
        let conso:[String: Any] = ["title": self.titleLabel?.text, "price": (self.priceLabel?.text as! NSString).doubleValue, "qt": val ]
        
        //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "addSoftDrink"), object: nil, userInfo: conso)
        if(val == 0){
            AdminCart.card.removeValue(forKey: self.id)
        }else{
            AdminCart.card[self.id] = conso
        }
        
        print(AdminCart.card)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "addSoftDrink"), object: nil, userInfo: nil)
        
        
        let vc = BasketRecapTable()
        
            vc.headlines = [
                Row(id: 1, title: "test", date: "", price: 12.00, qt: 0),
        ]
          
        
        print(vc.headlines)
        
        
    }
}




class SoftDrinksTableVC: UITableViewController{
    
    var headlines = [
        Headline(id: 1, title: "Chargement...", date: "", price: 0.00, qt: 0),
        ]
    
    
   @objc func getHistory(){

        Alamofire.request(Leeap.URL,
                          method: .post,
                          parameters: [
                                "consommations":[
                                    "get":[
                                    AdminCart.brewage_view_type: true
                                    ]
                                ]
            ]
            ).responseJSON{
                response in
                print(AdminCart.brewage_view_type)
                switch response.result{
                case .success(let JSON):
                    print("Success with JSON: \(JSON)")
                    
                    let response = JSON as! NSDictionary
                let success = response.object(forKey: "success") as! Bool
                    if(success){
                let history = response.object(forKey: "data")!
                var id = 0
                self.headlines.removeAll(keepingCapacity: false)
                for row in history as! [[String : AnyObject]]{
                    id = (row["Id"] as! NSString).integerValue
                    let amountStr = row["Price"] as! String
                    var amount = Double(amountStr)!
                    amount = amount/100.00 //Les rechargement sont négatifs et inversement
                    print((row["Name"] as! String)+" ==>"+String(amount))
                    
                    if(AdminCart.card[id] != nil){
                        self.headlines.append(Headline(id: id,
                                                       title: (row["Name"] as! String),
                                                       date: row["Alcool"] as! String,
                                                       price: amount,
                                                       qt: AdminCart.card[id]?["qt"] as! Int))
                    }else{
                        self.headlines.append(Headline(id: id,
                                                       title: (row["Name"] as! String),
                                                       date: row["Alcool"] as! String,
                                                       price: amount,
                                                       qt: 0))
                    }
                    
                
                }
        
                self.tableView.reloadData()
                    }
                case .failure(let error):
                    print("Request failed with error: \(error)")
                }
        }
        }

    
        
    
    
    
    

 
    // MARK: - Table view data source
    
    override func viewDidLoad() {
        self.tableView.rowHeight = 60.0
        self.getHistory();
        print(headlines)
        
               NotificationCenter.default.addObserver(self, selector: #selector(self.getHistory), name: NSNotification.Name(rawValue: "changeCartSection"), object: nil)
        
        
    }
    
   
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return headlines.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath) as! DrinksTableViewCell
        
        
        var headline = headlines[indexPath.row]
        cell.titleLabel?.text = headline.title
        cell.qtLabel.textColor = UIColor.white
        cell.x.textColor = UIColor.white
        
        if(headline.qt > 0){
            cell.qtLabel.isHidden=false
            cell.x.isHidden=false
            cell.qtLabel?.text = String(headline.qt)
        }
        
        //cell.dateLabel?.text = headline.date
        if(headline.price > 0.0){
          
//            cell.priceLabel?.textColor = UIColor.green
        }else{
             headline.price = -headline.price
  //          cell.priceLabel?.textColor = UIColor.red
        }
        cell.id=headline.id
        cell.priceLabel?.text = String(format: "%.2f", headline.price)+"€"
        //cell.imageView?.image = UIImage(named: headline.image)
        
        
        return cell
    }
    
}

