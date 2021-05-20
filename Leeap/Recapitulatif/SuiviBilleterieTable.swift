//
//  SuiviBilleterieTable.swift
//  Leeap
//
//  Created by Evan OLLIVIER on 04/03/2019.
//  Copyright © 2019 Evan OLLIVIER. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

struct Billet {
    
    var id : Int
    var firstname : String
    var lastname : String
    var email : String
    var price: Double
    var qt: Int
    
}


class SuiviBilleterieViewCell: UITableViewCell{
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var firstname: UILabel!
    @IBOutlet weak var lastname: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
}



class SuiviBilleterie: UITableViewController{
    
    var headlines = [
        Billet(id: 1,
               firstname: "Chargement...",
               lastname: "",
               email: "test@test.com",
               price: 0.00,
               qt: 0),
        ]
  
    var total = 0.00
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.row)!")
        
        // Get Cell Label
        let indexPath = tableView.indexPathForSelectedRow!
        let currentCell = tableView.cellForRow(at: indexPath)! as! SuiviBilleterieViewCell
        
        let valueToPass = ["firstname": currentCell.firstname.text!]
        print("value: \(valueToPass)")
        
        performSegue(withIdentifier: "billeterie_show_ticket_details", sender: valueToPass)
    }

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
  
        if (segue.identifier == "billeterie_show_ticket_details") {
            let childViewController = segue.destination as! BilleterieTicket
            
            if let cell = sender as? SuiviBilleterieViewCell {
                let valueToPass = ["firstname": cell.firstname.text!]
                childViewController.valueToPass = valueToPass//cell.firstname.text!
            }
            
            // Now you have a pointer to the child view controller.
            // You can save the reference to it, or pass data to it.
        }
    }
    
    
    // MARK: - Table view data source
    
    override func viewDidLoad() {
        self.tableView.rowHeight = 60.0
        print("SuiviBilleterieTable.viewDidLoad()")
        
        Alamofire.request(Leeap.URL,
                          method: .post,
                          parameters: [
                            "ticket":[
                                "getAll": true,
                            ],
                            "token": UserData.token
            ]
            ).responseJSON{
                response in
                
                switch response.result{
                case .success(let JSON):
                    print("Success with JSON: \(JSON)")
                    
                    let response = JSON as! NSDictionary
                    
                    let history = response.object(forKey: "data")!
                    var id = 0
                    self.headlines.removeAll(keepingCapacity: false)
                    for row in history as! [[String : AnyObject]]{
                        id = id + 1
                        let amountStr = row["Price"] as! String
                        var amount = Double(amountStr)!
                        
                        amount = -amount/100.00 //Les rechargement sont négatifs et inversement
                        self.headlines.append(Billet(id: id,
                                                    firstname: row["Firstname"] as! String,
                                                    lastname: row["Name"] as! String,
                                                    email: row["Email"] as! String,
                                                    price: 0,
                                                    qt: 0
                        ))
                        
                    }
                    
                    self.tableView.reloadData()
                    
                case .failure(let error):
                    print("Request failed with error: \(error)")
                }
        
    }
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return headlines.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TicketCell", for: indexPath) as! SuiviBilleterieViewCell
        
        
        var headline = headlines[indexPath.row]
        cell.email?.text = headline.email
        cell.firstname?.text = headline.firstname+" "+headline.lastname

        if(headline.price < 0.0){
            headline.price = -headline.price
        }
        
        cell.priceLabel?.text = String(format: "%.2f", headline.price)+"€"
        
        return cell
    }
    
}
