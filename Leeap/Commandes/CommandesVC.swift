//
//  CommandesVC.swift
//  Leeap
//
//  Created by Evan OLLIVIER on 03/03/2019.
//  Copyright © 2019 Evan OLLIVIER. All rights reserved.
//

import Foundation
import UIKit
#if canImport(CoreNFC)
import CoreNFC
#endif



@available(iOS 11.0, *)
class CommandesVC: UIViewController, NFCNDEFReaderSessionDelegate{
    
    var nfcSession: NFCNDEFReaderSession?
    
    
    @IBAction func scanButton(_ sender: Any) {
        if NFCNDEFReaderSession.readingAvailable {
            nfcSession = NFCNDEFReaderSession.init(delegate: self, queue: nil, invalidateAfterFirstRead: true)
            nfcSession?.begin()
        }else{
            
        }
    }
    
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print("The session was invalidated: \(error)")
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        var result = ""
        for payload in messages[0].records {
            result += String.init(data: payload.payload.advanced(by: 3), encoding: .utf8)!
        }
        
        DispatchQueue.main.async {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let resultViewController = storyBoard.instantiateViewController(withIdentifier: "BraceletInfo") as! BraceletInfo
            resultViewController.bracelet = result
            self.present(resultViewController, animated:true, completion:nil)
            
        }
    }
  
    
    
    
    
    
   
    @IBOutlet weak var total: UILabel!
    
    override func viewDidLoad(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateCartAndTotal), name: NSNotification.Name(rawValue: "addSoftDrink"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateCartAndTotal), name: NSNotification.Name(rawValue: "deleteCartItem"), object: nil)
        
     
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.updateCartAndTotal()
    }
    
    @IBAction func showPanierDev(_ sender: Any) {

        print(AdminCart.card)

    }
    
    func displayCart(){
        let myVC = storyboard?.instantiateViewController(withIdentifier: "BasketRecap") as! BasketRecap

        navigationController?.present(myVC, animated: true, completion: nil)
    }
    
    @IBAction func pannier_button(_ sender: Any) {
      displayCart()
    }
    
    @IBAction func total_button(_ sender: Any) {
         displayCart()
    }
    
    @IBAction func softdrinks(_ sender: Any) {
         AdminCart.brewage_view_type = ""
    }
    @IBAction func bottledrinks(_ sender: Any) {
         AdminCart.brewage_view_type = "bottles"
    }
    @IBAction func alcooldrinks(_ sender: Any) {
         AdminCart.brewage_view_type = "alcool"
    }

    
    @objc func updateCartAndTotal(){
         var total = 0.0;
        for (_, dictionnary) in AdminCart.card {
            
            total = total + (dictionnary["price"] as! Double) * Double(dictionnary["qt"] as! Int)
            
        }
        
        self.total.text = total.formattedWithSeparator
    }
    
   
}
