//
//  BraceletInfo.swift
//  Leeap
//
//  Created by Evan OLLIVIER on 16/03/2019.
//  Copyright © 2019 Evan OLLIVIER. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON



class BraceletInfo: UIViewController{
    
    
    @IBOutlet weak var historyView: UIView!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    
    
    var fullname = "";
    var solde = 0.00;
    var bracelet = "";
    
    override func viewDidLoad() {
        
        print(self.bracelet);
        let controller = storyboard!.instantiateViewController(withIdentifier: "HistoryTableVC") as! HistoryTableVC
        controller.bracelet = self.bracelet;
        addChild(controller)
        self.historyView.translatesAutoresizingMaskIntoConstraints = false
        historyView.addSubview(controller.view)

        
        Alamofire.request(Leeap.URL,
                          method: .post,
                          parameters:[
                            "bracelet": [
                                "getBalance": self.bracelet,
                            ],
                            "token": UserData.token
            ])
            .validate(statusCode: 200..<300)
            .responseJSON { responseJSON in
                print(responseJSON);//Debug
                switch responseJSON.result {
                case .success(let JSON):
                    let response = JSON as! NSDictionary
                    if(response.object(forKey: "success") as! Bool == true){
                    let firstname = response.object(forKey: "firstname") as! String
                    let lastname = response.object(forKey: "lastname") as! String
                    self.solde = (Double(response.object(forKey: "balance") as! String) ?? 0.00)/100.00
                 //   let mealTotal = response.object(forKey: "mealTotal") as! String
                    
                    self.balanceLabel.text=self.solde.formattedWithSeparator
                    self.fullnameLabel.text = firstname+" "+lastname
                    }else{
                        self.fullnameLabel.text = "Bracelet Inconnu"
                    }
                    
                case .failure(let error):
                    print(error)
                }
        }
        
    }
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: {});
        self.tabBarController?.tabBar.isHidden = false;
    }
    
    
}
