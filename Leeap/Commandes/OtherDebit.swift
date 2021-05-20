//
//  OtherDebit.swift
//  Leeap
//
//  Created by Evan OLLIVIER on 29/03/2019.
//  Copyright © 2019 Evan OLLIVIER. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
#if canImport(CoreNFC)
import CoreNFC
#endif


@available(iOS 11.0, *)
class OtherDebit: UIViewController, NFCNDEFReaderSessionDelegate, UITextFieldDelegate{
    var nfcSession: NFCNDEFReaderSession?
    
    @IBOutlet weak var libele: UITextField!
    
    @IBOutlet weak var amount: UITextField!
    
    
    @objc func dismiss_keyboard(_ sender: Any){
        libele.resignFirstResponder()
        amount.resignFirstResponder()
    }
    override func viewDidLoad() {
        libele.delegate=self
        amount.delegate=self
        let tap0 = UITapGestureRecognizer(target: self, action: #selector(dismiss_keyboard(_: )))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tap0)
        self.tabBarController?.tabBar.isHidden = true;
    }
    
    
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
           // self.custom_debit(bracelet: result)
            if(Array(self.amount.text!).count > 0 && Array(self.libele.text!).count > 0){
               self.custom_debit(bracelet: result)
            }else{
                let alert = UIAlertController(title: "Attention", message: "Merci de renseigner un montant et un libelé", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }
    
    
    func custom_debit(bracelet: String){
         let doublePrice = ((self.amount?.text)?.doubleValue ?? 0.00) * 100.00
        print( doublePrice)
        let params = [
            "consommations": [
                "pay": [
                    "token": UserData.token,
                    "label": self.libele.text!,
                    "bracelet": bracelet,
                    "amount": String(doublePrice)
                ]
            ]
        ];
        
        Alamofire.request(Leeap.URL,
                          method: .post,
                          parameters: params
            ).responseJSON{
                response in
                switch response.result{
                case .success(let JSON):
                    print("Success with JSON: \(JSON)")
                    
                    let response = JSON as! NSDictionary
                    let success = response.object(forKey: "success") as? Bool ?? false
                    if(success == true){
                        
                        let total = Double(response.object(forKey: "total") as! Int)/100.00
                        let newBalance = Double(response.object(forKey: "newUserBalance") as! Int)/100.00
                        
                        let alert = UIAlertController(title: "Succès", message: "Débit de "+String(total)+" réussi, nouveau solde: "+String(newBalance), preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        self.present(alert, animated: true)
                        
                    }else{
                        
                        let alert = UIAlertController(title: "Erreur", message: response.object(forKey: "text") as? String, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        self.present(alert, animated: true)
                        
                    }
                    
                    
                case .failure(let error):
                    let alert = UIAlertController(title: "Erreur", message: "Pas de réponse serveur", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true)
                    
                }
        }
    }
    
    
    
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: {});
        self.tabBarController?.tabBar.isHidden = false;
    }
    
    
    @IBAction func valueChanged(_ sender: Any) {
        

        let tok =  self.amount.text!.components(separatedBy:",")
        print(tok.count-1)
        
        if((tok.count-1)==0){
            // sendNotification()
        }
        else if((tok.count-1)==1){ //Une ",""
            let result = tok[1]
            if(result.count > 2){ //Effacer plus de deux décimales
                self.amount.text = String((self.amount.text?.dropLast())!)
                self.valueChanged(self.amount)
                self.amount.resignFirstResponder()
            }else{ //décimales okay
                //sendNotification()
            }
        }else{ //Plus de 2 ","
            self.amount.text = String((self.amount.text?.dropLast())!)
            self.valueChanged(self.amount)
        }
        
    }
    
    
}
