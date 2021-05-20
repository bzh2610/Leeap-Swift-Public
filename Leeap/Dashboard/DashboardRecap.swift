//
//  DashboardRecap.swift
//  Leeap
//
//  Created by Evan OLLIVIER on 11/03/2019.
//  Copyright © 2019 Evan OLLIVIER. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class DashboardRecap: UIViewController{
    
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var entrance_bought: UILabel!
    @IBOutlet weak var entrance_scanned: UILabel!
    @IBOutlet weak var mealCount: UILabel!
    
    var date_text : String = ""
    
    override func viewDidLoad() {
        self.date.text = date_text
        Alamofire.request(Leeap.URL,
                          method: .post,
                        parameters:[
            "ticket": [
                "getEventInfo": true,
            ],
            "token": UserData.token
            ])
            .validate(statusCode: 200..<300)
            .responseJSON { responseJSON in
                print(responseJSON);//Debug
                switch responseJSON.result {
                case .success(let JSON):
                    let response = JSON as! NSDictionary
                    let payed = response.object(forKey: "ticketsPayed") as! String
                    let used = response.object(forKey: "ticketsUsed") as! String
                    let mealUsed = response.object(forKey: "mealUsed") as! String
                    let mealTotal = response.object(forKey: "mealTotal") as! String
                    
                    self.entrance_bought.text=payed
                    self.entrance_scanned.text = used
                    self.mealCount.text = mealUsed+"/"+mealTotal
                    
                case .failure(let error):
                    print(error)
                }
        }
    }
    
}
