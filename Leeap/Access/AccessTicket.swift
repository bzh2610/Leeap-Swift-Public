//
//  AccessTicket.swift
//  Leeap
//
//  Created by Evan OLLIVIER on 11/03/2019.
//  Copyright © 2019 Evan OLLIVIER. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
#if canImport(CoreNFC)
import CoreNFC
#endif


@available(iOS 11.0, *)
class AccessTicket: UIViewController, NFCNDEFReaderSessionDelegate {
    
     var nfcSession: NFCNDEFReaderSession?
    
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var fullname: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var precharge: UILabel!
    @IBOutlet weak var repas: UILabel!
    var QRCode: String! = ""
    var precharge_text: String! = ""
    
    override func viewDidLoad() {
        print(self.QRCode!)
        self.fetch(QRCode: self.QRCode!)
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
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        var result = ""
        for payload in messages[0].records {
            result += String.init(data: payload.payload.advanced(by: 3), encoding: .utf8)!
        }
        
        DispatchQueue.main.async {
            //self.braceletCode.text = "Bracelet: "+result
            //self.getBalance(numeroBracelet: result);
/*ticket: {
 bind: {
 bracelet: "BRACELET",
 QRCode: "45d8606c8cbc76eee3df"
 }
 }*/
            
            Alamofire.request(Leeap.URL,
                              method: .post,
                              parameters: [
                                "ticket":[
                                    "bind": [
                                    "bracelet": result,
                                    "QRCode": self.QRCode!,
                                    "token": UserData.token
                                    ]
                                ]
                ]
                ).responseJSON{
                    response in
                    switch response.result{
                    case .success(let JSON):
                         print("Success with JSON: \(JSON)")
                        
                         let response = JSON as! NSDictionary
                         let success = response.object(forKey: "success") as? Bool ?? false
                         if(success == true){
                            
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let myVC = storyboard.instantiateViewController(withIdentifier: "AccessSuccessAssociation") as! AccessSuccessAssociation
                            myVC.amount_text = self.precharge_text
                            
                            self.present(myVC, animated: true, completion: nil)
                            
                         }else{
                           
                            
                            let alert = UIAlertController(title: "Erreur", message: response.object(forKey: "text") as? String, preferredStyle: .alert)
                            
                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        
                            
                            self.present(alert, animated: true)
                                
                        }
                    
                    
                    case .failure(let error):
                    print(error)
                    
            }
            }
        }
    }
    
    
    func fetch(QRCode: String){
        Alamofire.request(Leeap.URL,
                          method: .post,
                          parameters: [
                            "ticket":[
                                "QRCode": QRCode,
                            ]
            ]
            ).responseJSON{
                response in
                
                switch response.result{
                case .success(let JSON):
                    print("Success with JSON: \(JSON)")
                    
                    let response = JSON as! NSDictionary
                    
                    if(response.object(forKey: "success") as! Bool == true){
                    
                  
                        self.fullname.text = (response.object(forKey: "Firstname")! as! String)+" "+(response.object(forKey: "Name")! as! String)
                        self.phone.text = (response.object(forKey: "Mobile")! as! String)
                        
                        let repas = (response.object(forKey: "Meal") as! NSString).integerValue
                        if(repas == 1){
                            self.repas.text = "Avec repas"
                        }else{
                            self.repas.text = "Sans repas"
                        }
                        
                        self.email.text = (response.object(forKey: "Email")! as! String)
                    
                        let prechargement = (response.object(forKey: "Precharge_amount")! as! NSString).doubleValue/100
                        self.precharge_text = prechargement.formattedWithSeparator
                        self.precharge.text = prechargement.formattedWithSeparator+" préchargés"
                    }else{
                        
                        //QRCode invalide
                        let alert = UIAlertController(title: "Erreur", message: response.object(forKey: "text") as? String, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: self.close(_:)))
                        self.present(alert, animated: true)
                    }
                   
                case .failure(let error):
                    print(error)
                    
                }
        }

    }
    
    
    
}
