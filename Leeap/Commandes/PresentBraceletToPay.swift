//
//  PresentBraceletToPay.swift
//  Leeap
//
//  Created by Evan OLLIVIER on 25/02/2019.
//  Copyright © 2019 Evan OLLIVIER. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Alamofire
#if canImport(CoreNFC)
import CoreNFC
#endif


@available(iOS 11.0, *)

class PresentBraceletToPay: UIViewController, UITextFieldDelegate, NFCNDEFReaderSessionDelegate {
    
    @IBOutlet weak var total_label: UILabel!
    var total: String?
    
    var nfcSession: NFCNDEFReaderSession?
    
    
    override func viewDidLoad() {
        self.total_label.text=(total ?? "0,00")
    }
    @IBAction func scanButton(_ sender: Any) {
        if NFCNDEFReaderSession.readingAvailable {
        nfcSession = NFCNDEFReaderSession.init(delegate: self, queue: nil, invalidateAfterFirstRead: true)
        nfcSession?.begin()
        }else{
            
        }
    }
    @IBAction func close(_ sender: Any) {
        

            self.dismiss(animated: true, completion: {});
            self.tabBarController?.tabBar.isHidden = false;
        
        
    }
    

    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print("The session was invalidated: \(error)")
    }
    
   
    var sendDict: [[String: Any]] = []
    
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        var bracelet = ""
        for payload in messages[0].records {
            bracelet += String.init(data: payload.payload.advanced(by: 3), encoding: .utf8)!
        }
        
        DispatchQueue.main.async {
            
            var jsonString = ""
            
            AdminCart.card.forEach { (arg) in
                let (id, element) = arg
                self.sendDict.append(["qt": element["qt"] as! Int, "id": id])
                
            }
             print(AdminCart.card)
           print(self.sendDict)
          
           
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: self.sendDict, options: [])
                jsonString = String(data: jsonData, encoding: String.Encoding.utf8)!
            } catch {
                print("FAILED TO MAKE JSON FROM CART")
            }
            
            
            Alamofire.request(Leeap.URL,
                              method: .post,
                              parameters: [
                                "consommations":[
                                    "pay": [
                                        "bracelet": bracelet,
                                        "token": UserData.token,
                                        "conso": jsonString
                                    ]
                                ]
                ]
                ).responseJSON{
                    response in
                    
                    switch response.result{
                    case .success(let JSON):
                        print("Success with JSON: \(JSON)")
                        
                        let response = JSON as! NSDictionary
              
                        let success = response.object(forKey: "success") as! Bool
                        let text = response.object(forKey: "text") as? String ?? ""
                        
                        if(!success){
                            let alert = UIAlertController(title: "Erreur", message: "Le serveur a répondu: "+text, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true)
                        }else{
                            let alert = UIAlertController(title: "Succès !", message: "C'est payé !", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
                                AdminCart.card=[:]
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "deleteCartItem"), object: nil, userInfo: nil)
                                self.dismiss(animated: true, completion: {});
                                self.tabBarController?.tabBar.isHidden = false;
                                
                            }))
                            self.present(alert, animated: true)
                            
                            
                        }
                        
                        
                        
                       
                        
                    case .failure(let error):
                        print(error)
                        
                    }
            }
        }
    }
}
