//
//  refund.swift
//  Leeap
//
//  Created by Evan OLLIVIER on 29/03/2019.
//  Copyright © 2019 Evan OLLIVIER. All rights reserved.
//

import Foundation
import UIKit
import Alamofire


class Refund: UIViewController, UITextFieldDelegate{
    
    
    @IBOutlet weak var IBAN: UITextField!
    @IBOutlet weak var BIC: UITextField!
    
    
    override func viewDidLoad() {
        BIC.delegate=self
        IBAN.delegate=self
        
        let tap0 = UITapGestureRecognizer(target: self, action: #selector(self.resign_keyboard(_:)))
        self.view.addGestureRecognizer(tap0)
    }
    
    @objc func resign_keyboard(_ sender: Any){
        self.IBAN.resignFirstResponder()
        self.BIC.resignFirstResponder()
    }
    
}
