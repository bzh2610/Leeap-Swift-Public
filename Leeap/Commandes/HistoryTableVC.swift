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

    
struct Headline_history {
    
    var id : Int
    var title : String
    var date : String
    var price : Double
    var qt: Int
    var refunded: Bool
    
}

class HistoryTableViewCell: UITableViewCell{
    @IBOutlet weak var titleLabel: UILabel!
    var id: Int!
    var price: Double!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var del_btn: UIButton!

    @IBAction func decrement(_ sender: Any) {
        print("HistoryTableViewCell.id METHOD decrement()")
        print(self.id)
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "refundDrinkRequest"),object: nil, userInfo: ["id": self.id, "price": self.price]))
       
    }
}




class HistoryTableVC: UITableViewController{
    
    var bracelet = ""
    var headlines: [Headline_history] = []
    
    
    func getHistory(){
        
        Alamofire.request(Leeap.URL,
                          method: .post,
                          parameters: [
                            "consommations":[
                                "history": [
                                    "bracelet": self.bracelet
                                ],
                            ]
            ]
            ).responseJSON{
                response in
                
                switch response.result{
                case .success(let JSON):
                    print("Success with JSON: \(JSON)")
                    
                    let response = JSON as! NSDictionary
                    
                    let history = response.object(forKey: "history")!

                    self.headlines.removeAll(keepingCapacity: false)
                    for row in history as! [[String : AnyObject]]{

                        let amountStr = row["Total"] as! String
                        var amount = Double(amountStr)!
                        
                        
                        amount = -amount/100.00 //Les rechargement sont négatifs et inversement
                        
                        print(row)
                        let id = Int(row["Id"] as? String ?? "0") ?? 0
                        
                        self.headlines.append(Headline_history(id: id,
                                                       title: row["Name"] as? String ?? "?",
                                                       date: row["Date"] as? String ?? "",
                                                       price: amount,
                                                       qt: Int(row["Qt"] as? String ?? "0") ?? 0,
                                                       refunded: row["Refunded"] as? Bool ?? false
                            )
                                             )
                        
                    }
                    
                    self.tableView.reloadData()
                    
                case .failure(let error):
                    print("Request failed with error: \(error)")
                }
        }
    }
    
    
    
    
    func refund(id: Int, amount: Double){  Alamofire.request(Leeap.URL,
                                             method: .post,
                                             parameters: [
                                                "consommations":[
                                                    "refund": [
                                                        "tx": id,
                                                        "token": UserData.token
                                                    ],
                                                ]
        ]
        ).responseJSON{
            response in
            
            switch response.result{
            case .success(let JSON):
                print("Success with JSON: \(JSON)")
                
                let response = JSON as? NSDictionary ?? [:]
                let success = response.object(forKey: "success") as? Bool ?? false
                let text = response.object(forKey: "text") as? String ?? "Aucune réponse"
                
                if(success == true){
                    print("refund success")
                    let montant = String(fabs(amount))
                    let confirm = UIAlertController(title: "Succès !", message: "Bracelet crédité de "+montant+" ", preferredStyle: .alert)
                    confirm.addAction(UIAlertAction(title: "Ok", style: .default, handler:nil));
                    self.present(confirm, animated: true)
                    self.getHistory()
                }else{
                    print("refund error")
                    let confirm = UIAlertController(title: "Échec !", message: text, preferredStyle: .alert)
                    confirm.addAction(UIAlertAction(title: "Ok", style: .default, handler:nil));
                    self.present(confirm, animated: true)
                }
             case .failure(let error):
                print("refund response incorrect")
                let confirm = UIAlertController(title: "Erreur", message: "Le serveur n'a pas répondu.", preferredStyle: .alert)
                confirm.addAction(UIAlertAction(title: "Ok", style: .default, handler:nil));
                self.present(confirm, animated: true)
            }
                
        }
    }
    
    @objc func alert(_ notification: NSNotification){
        
        
            print("HistoryTableVc.alert()")
            if let dict = notification.userInfo as Dictionary? {
                print(dict);
                let amount = dict["price"] as? Double ?? 0.00
                    if let id = dict["id"] as? Int {
                     print("found id");
                
                    let alert = UIAlertController(title: "Avertissement", message: "Vous êtes sur le point de recréditer le bracelet de "+String(fabs(amount))+" êtes vous sûr ?", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Oui", style: .default, handler: { action in
                       self.refund(id: id, amount: fabs(amount))
                    }))
                    alert.addAction(UIAlertAction(title: "Annuler", style: .default, handler: nil))
                     self.present(alert, animated: true)
                    
                    
                    
                    }else{
                        let confirm = UIAlertController(title: "Erreur", message: "Identifiant transaction introuvable.", preferredStyle: .alert)
                        confirm.addAction(UIAlertAction(title: "Ok", style: .default, handler:nil));
                        self.present(confirm, animated: true)
                    }
                
            }else{
                print("Not a dictionnary")
        }
        
    }
    
    
    // MARK: - Table view data source
    
    override func viewDidLoad() {
        self.tableView.rowHeight = 70.0
        print(self.bracelet);
        self.getHistory();
        print(headlines)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.alert(_:)), name: NSNotification.Name(rawValue: "refundDrinkRequest"), object: nil)
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return headlines.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath) as! HistoryTableViewCell
        
        
        let headline = headlines[indexPath.row]
        cell.titleLabel?.text = headline.title
        if(headline.qt > 1){
            cell.titleLabel?.text = headline.title+" x "+String(headline.qt)
        }
        //cell.dateLabel?.text = headline.date
        if(headline.refunded == true){
            cell.del_btn.isHidden=true
        }
        
        cell.id = headline.id
        cell.price = headline.price
        cell.dateLabel?.text  = headline.date
        cell.priceLabel?.text = String(format: "%.2f", headline.price)+"€"
        
        return cell
    }
    
}

