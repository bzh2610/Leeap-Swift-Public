//
//  AdminSettingsVC.swift
//  Leeap
//
//  Created by Evan OLLIVIER on 18/03/2019.
//  Copyright © 2019 Evan OLLIVIER. All rights reserved.
//

import Foundation
import UIKit
import Alamofire



class AdminSettingsVC: UITableViewController{
    
    @IBAction func backtochoosemenu(_ sender: Any) {
        print("back")
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "ModeChoose")
        self.present(VC, animated: true, completion: nil)
    }
    
    @IBAction func disconnect(_ sender: Any) {
        AppSecurity().revokeToken()
        //Load login view Controller
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "intropages")
        self.present(VC, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        
    }
}
