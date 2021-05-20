//
//  BilleterieTicket.swift
//  Leeap
//
//  Created by Evan OLLIVIER on 04/03/2019.
//  Copyright © 2019 Evan OLLIVIER. All rights reserved.
//

import Foundation
import UIKit


class BilleterieTicket: UIViewController{
    var valueToPass: [String: Any] = [:]//String = ""

    @IBOutlet weak var full_name: UILabel!
    
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: {});
        self.tabBarController?.tabBar.isHidden = false;
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        full_name.text = valueToPass["firstname"] as? String
    }
    
}
