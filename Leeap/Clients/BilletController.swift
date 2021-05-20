//
//  BilletController.swift
//  Leeap
//
//  Created by Evan OLLIVIER on 18/03/2019.
//  Copyright © 2019 Evan OLLIVIER. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import WebKit

class BilletController: UIViewController{
    
    @IBOutlet weak var fullname: UILabel!
    @IBOutlet weak var QRCodeView: UIWebView!
    @IBOutlet weak var email: UILabel!
    
    override func viewDidLoad() {
        
        print(UserData.email)
        self.fullname.text = UserData.firstname+" "+UserData.lastname
        self.email.text = UserData.email
        
        let url = URL (string: "https://leeap.cash/stripe/phpqrcode/?QRCode="+UserData.qrcode);
        let request = URLRequest(url: url!);
      QRCodeView.loadRequest(request)
        QRCodeView.scalesPageToFit=true
        QRCodeView.isUserInteractionEnabled=false
    }
}
