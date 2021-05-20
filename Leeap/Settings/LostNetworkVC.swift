//
//  LostNetworkVC.swift
//  
//
//  Created by Evan OLLIVIER on 18/03/2019.
//

import Foundation
import UIKit


class LostNetworkVC: UIViewController{
    
    var sourceControllerId = ""
    
    @IBAction func retry(_ sender: Any) {
        self.dismiss(animated: true, completion: {});
    }
    
    
    
    override func viewDidLoad() {
        
    }
}
