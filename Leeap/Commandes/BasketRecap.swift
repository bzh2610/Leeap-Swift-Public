//
//  BasketRecap.swift
//  Leeap
//
//  Created by Evan OLLIVIER on 26/02/2019.
//  Copyright © 2019 Evan OLLIVIER. All rights reserved.
//

import Foundation
import UIKit

@available(iOS 11.0, *)
class BasketRecap : UIViewController {
   // var pannier : [String: Any] = [:]
    var total_numeric = 0.00
    @IBOutlet weak var total: UILabel!
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: {});
        self.tabBarController?.tabBar.isHidden = false;
    }
    
    @IBAction func close(_ sender: Any) {
    self.dismiss(animated: true, completion: {});
    self.tabBarController?.tabBar.isHidden = false;
    }
    
    override func viewDidLoad() {
       // print(pannier)
        let CVC = children.last as! BasketRecapTable
      //  CVC.pannier = pannier
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateCartAndTotal), name: NSNotification.Name(rawValue: "deleteCartItem"), object: nil)
        
        
    }
    
    @IBAction func delete_all(_ sender: Any) {
        AdminCart.card=[:]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "deleteCartItem"), object: nil, userInfo: nil)
    }

    
    @objc func updateCartAndTotal(){
        total_numeric=0.00
        for (_, dictionnary) in AdminCart.card {
            total_numeric = total_numeric + (dictionnary["price"] as! Double) * Double(dictionnary["qt"] as! Int)
        }
        self.total.text = total_numeric.formattedWithSeparator
    }
 
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "commandes_recaptable") {
            let childViewController = segue.destination as! BasketRecapTable
            //childViewController.pannier=pannier
            self.updateCartAndTotal()
           
            
            
            // Now you have a pointer to the child view controller.
            // You can save the reference to it, or pass data to it.
        }
    }

    @IBAction func pay_button(_ sender: Any) {
        print("BasketRecap.pay_button()")
   
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
            let myVC = storyboard.instantiateViewController(withIdentifier: "PresentBraceletToPay") as! PresentBraceletToPay
        
       myVC.total = total_numeric.formattedWithSeparator
        self.present(myVC, animated: true, completion: nil)
  
}


}

