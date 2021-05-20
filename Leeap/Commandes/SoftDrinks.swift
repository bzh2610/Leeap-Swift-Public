//
//  SoftDrinks.swift
//  Leeap
//
//  Created by Evan OLLIVIER on 03/03/2019.
//  Copyright © 2019 Evan OLLIVIER. All rights reserved.
//

import Foundation
import UIKit

class SoftDrinks: UIViewController{
    
    @IBOutlet weak var subtotal: UILabel!
    @IBOutlet weak var embed_view: UIView!
    
   
    
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: {});
        self.tabBarController?.tabBar.isHidden = false;
    }
    

    
    override func viewDidLoad() {
        
         AdminCart.brewage_view_type = self.restorationIdentifier ?? ""
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeCartSection"), object: nil, userInfo: nil)
        
        // NotificationCenter.default.addObserver(self, selector: #selector(self.updateSubTotal(_:)) , name: NSNotification.Name(rawValue: "addSoftDrink"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateSubTotal(_:)), name: NSNotification.Name(rawValue: "addSoftDrink"), object: nil)
        var total: Double = 0.00
        print(AdminCart.card)
        AdminCart.card.forEach { (arg) in
            let (_, element) = arg
            total=total + (element["price"] as! Double) * Double(element["qt"] as! Int)
        }
        self.subtotal.text="Sous total: "+total.formattedWithSeparator
    }
    
    
    
    @objc func updateSubTotal(_ notification: NSNotification){
        print("SoftDrinks.updateSubtotal()")
                    var total = 0.0;
                    AdminCart.card.forEach { (arg) in
                        let (_, element) = arg
                        total=total + (element["price"] as! Double) * Double(element["qt"] as! Int)
                    }
                    self.subtotal.text="Sous total: "+total.formattedWithSeparator
    }
    
}
