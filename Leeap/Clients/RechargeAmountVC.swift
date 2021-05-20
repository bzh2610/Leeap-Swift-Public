//
//  RechargeAmountVC.swift
//  AAInfographics
//
//  Created by Evan OLLIVIER on 21/03/2019.
//

import Foundation
import UIKit



class RechargeAmountVC: UIViewController, UITextFieldDelegate{
    
    
    @IBOutlet weak var amount: UITextField!
    
    
    override func viewDidLoad() {
        amount.delegate=self
        let tap0 = UITapGestureRecognizer(target: self, action: #selector(self.resign_keyboard(_:)))
        self.view.addGestureRecognizer(tap0)
    }

    @objc func resign_keyboard(_ sender: Any){
        self.amount.resignFirstResponder()
    }
  
    
    func sendNotification()->Bool{
        let formatter = NumberFormatter()
        formatter.decimalSeparator = ","
        let amount = formatter.number(from: self.amount.text ?? "0.0")
        
        if let doubleAmount = amount?.doubleValue {
             print(doubleAmount)
            if(doubleAmount < 5){
                let alert = UIAlertController(title: "Erreur", message: "Le montant minimum pour un rechargement par carte bancaire est de 5€00", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                    alert.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true)
                return false
               // self.amount.textColor = UIColor.init(red: 255/255, green: 35/255, blue: 12/255, alpha: 1)
            }else{
               
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "rechargeAmountChanged"), object: nil, userInfo: ["amount": doubleAmount])
               // self.amount.textColor = UIColor.white
                return true
            }
            
        } else {
            print("not parseable")
            self.amount.textColor = UIColor.init(red: 255/255, green: 35/255, blue: 12/255, alpha: 1)
            return false
        }
    }
    
    
    
    var val = 0.00
    var lastlength = 4
    @IBAction func editbegin(_ sender: Any) {
        if((Double(self.amount.text ?? "0.00") ?? 0.00) == 0){
            self.amount.text = ""
        }
        
    }
    
    @IBAction func valueChanged(_ sender: Any) {
    
    
        let tok =  self.amount.text!.components(separatedBy:",")
        print(tok.count-1)
        
       if((tok.count-1)==1){ 
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
    
 
    @IBAction func saveAndClose(_ sender: Any) {
        if(sendNotification()){
            self.dismiss(animated: true, completion: {})
        }
    }
    
    
    
    @IBAction func close(sender: Any){

        self.dismiss(animated: true, completion: {})
    }
    
    

}
