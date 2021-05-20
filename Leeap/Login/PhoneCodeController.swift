//
//  PhoneCodeController.swift
//  cashLess
//
//  Created by Evan OLLIVIER on 18/01/2019.
//  Copyright © 2019 Evan OLLIVIER. All rights reserved.
//

import Foundation
import UIKit
import Alamofire


class PhoneCodeController: UIViewController, UITextFieldDelegate {
    var phone_number : String!
    var phone_indicative: String!
    var previouslength = 0;
    var resign_automatically = true;
    @IBOutlet weak var code: UITextField!
    
    @IBOutlet weak var description_label: UILabel!
    @IBOutlet weak var code1: UILabel!
    @IBOutlet weak var code2: UILabel!
    @IBOutlet weak var code3: UILabel!
    @IBOutlet weak var code4: UILabel!
    @IBOutlet weak var code5: UILabel!
    @IBOutlet weak var code6: UILabel!
    
    @IBOutlet weak var underline: UIImageView!
    
    @IBOutlet weak var underline2: UIImageView!
    
    @IBOutlet weak var underline3: UIImageView!
    
    @IBOutlet weak var underline4: UIImageView!
    
    @IBOutlet weak var underline5: UIImageView!
    
    @IBOutlet weak var underline6: UIImageView!
    
    
    @IBOutlet weak var CodeInvalidBtn: UIButton!
    
    
    @IBAction func sendBackCode(_ sender: Any) {
        print(phone_number)
        Alamofire.request(Leeap.URL,
                          method: .post,
                          parameters: [
                            "sms":[
                                "request": phone_number!
                            ]
            ]
            ).responseJSON{
                response in
                print(response)
                print("Requested...")
                switch response.result{
                case .success(let JSON):
                    print("Success with JSON: \(JSON)")
                    self.CodeInvalidBtn.setTitle("Code invalide. Cliquez ici pour le renvoyer.", for: .normal)
                    self.CodeInvalidBtn.isHidden=true
                    
                    self.code1.text = ""
                    self.code2.text = ""
                    self.code3.text = ""
                    self.code4.text = ""
                    self.code5.text = ""
                    self.code6.text = ""
                    self.code.text = ""
                    
                    
                case .failure(let error):
                    self.CodeInvalidBtn.setTitle("Impossible de se connecter à notre serveur. Merci de réessayer.", for: .normal)
                  
                }
        }
                    
    }
    
    func next_controller(set_password: Bool = false){
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "PinCodeController") as! PinCodeController
        myVC.SMSCode = self.code.text!
        myVC.phoneCode = self.phone_indicative
        myVC.phoneNumber = phone_number
        myVC.set_password = set_password
        self.present(myVC, animated:true, completion:nil)
    }
    
    @IBAction func `continue`(_ sender: Any) {
        
        Alamofire.request(Leeap.URL,
                          method: .post,
                          parameters: [
                            "sms":[
                                "checkCode": [
                                    "indicative": self.phone_indicative!,
                                    "number": phone_number!,
                                    "code": self.code.text!
                                ]
                           ]
            ]
            ).responseJSON{
                response in
                print(response)
                print("Requested...")
                switch response.result{
                case .success(let JSON):
                    print("Success with JSON: \(JSON)")
                    
                    let response = JSON as! NSDictionary
                    
                    let result = response.object(forKey: "success") as? Bool
                    let set_password = response.object(forKey: "set_password") as! Bool
                    
                    if(result == true){
                         self.CodeInvalidBtn.isHidden=true
                        self.next_controller(set_password: set_password)
                    }else{
                        self.CodeInvalidBtn.setTitle("Code invalide. Cliquez ici pour le renvoyer.", for: .normal)
                       self.CodeInvalidBtn.isHidden=false
                    }
                    
                case .failure(let error):
                   self.CodeInvalidBtn.setTitle("Impossible de se connecter à notre serveur. Merci de réessayer.", for: .normal)
                   self.CodeInvalidBtn.isHidden=false
                    
                }
        }
        
    }
    
    
    
    @objc func dismiss_keyboard(_ sender: Any){
        code!.resignFirstResponder()
        
    }
    override func viewDidLoad() {
        
    
       
        
        let tap0 = UITapGestureRecognizer(target: self, action: #selector(dismiss_keyboard(_: )))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tap0)
        self.code?.delegate=self
        
        print(phone_indicative)
        print(phone_number)
        
        code.addTarget(self, action: #selector(self.change), for: UIControl.Event.allEditingEvents )
        code.becomeFirstResponder()
        
        self.description_label.text = "Entrez le code à six chiffres envoyé au 0"+phone_number
    }
    
    
    @objc func change(){
        self.code1.text = ""
        self.code2.text = ""
        self.code3.text = ""
        self.code4.text = ""
        self.code5.text = ""
        self.code6.text = ""
        
        
        var code_ = Array(self.code.text!)
        if(code_.count > 0){
            self.code1.text = String(code_[0])
        }
        if(code_.count > 1){
            self.code2.text = String(code_[1])
        }
        if(code_.count > 2){
            self.code3.text = String(code_[2])
        }
        if(code_.count > 3){
            self.code4.text = String(code_[3])
        }
        if(code_.count > 4){
            self.code5.text = String(code_[4])
        }
        if(code_.count > 5){
            self.code6.text = String(code_[5])
            if(resign_automatically){
              self.code.resignFirstResponder()
                resign_automatically=false
            }else{
                resign_automatically=true
            }
            
        }
        
        self.underline.image = UIImage(named: "underlineOff")
        self.underline2.image = UIImage(named: "underlineOff")
        self.underline3.image = UIImage(named: "underlineOff")
        self.underline4.image = UIImage(named: "underlineOff")
        self.underline5.image = UIImage(named: "underlineOff")
        self.underline6.image = UIImage(named: "underlineOff")
        
        if(code_.count==0){
            self.underline.image = UIImage(named: "underlineOn")
        }
        if(code_.count==1){
            self.underline2.image = UIImage(named: "underlineOn")
        }
        if(code_.count==2){
            self.underline3.image = UIImage(named: "underlineOn")
        }
        if(code_.count==3){
            self.underline4.image = UIImage(named: "underlineOn")
        }
        if(code_.count==4){
            self.underline5.image = UIImage(named: "underlineOn")
        }
        if(code_.count==5){
            self.underline6.image = UIImage(named: "underlineOn")
        }
    }
    
    
    
    
}
