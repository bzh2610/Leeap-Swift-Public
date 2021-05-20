//
//  PinCodeController.swift
//  Leeap
//
//  Created by Evan OLLIVIER on 17/03/2019.
//  Copyright © 2019 Evan OLLIVIER. All rights reserved.
//


import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import LocalAuthentication





class PinCodeController: UIViewController {
    
    
    @IBOutlet weak var pin1: UIImageView!
    @IBOutlet weak var pin3: UIImageView!
    @IBOutlet weak var pin4: UIImageView!
    @IBOutlet weak var pin2: UIImageView!
    @IBOutlet weak var description_code: UILabel!
    @IBOutlet weak var nine: UILabel!
    @IBOutlet weak var seven: UILabel!
    @IBOutlet weak var eight: UILabel!
    @IBOutlet weak var six: UILabel!
    @IBOutlet weak var five: UILabel!
    @IBOutlet weak var four: UILabel!
    @IBOutlet weak var three: UILabel!
    @IBOutlet weak var two: UILabel!
    @IBOutlet weak var one: UILabel!
    @IBOutlet weak var zero: UILabel!
    @IBOutlet weak var erase: UILabel!
    @IBOutlet weak var forgot: UILabel!
    
    var count = 0
    var SPLASH_LOGIN=false;
    var code = [0,0,0,0];
    var phoneCode = ""
    var phoneNumber = ""
    var SMSCode = ""
    var phoneData: Dictionary<String, String> = [:]
    var set_password: Bool = false
    
    func setPhone( phoneNumber: String, phoneCode: String ){
        self.phoneCode = phoneCode
        self.phoneNumber = phoneNumber
        print(phoneCode)
        print(phoneNumber)
    }
    
    @objc func setPhoneInfo(_ notification: NSNotification){
        
        if((notification.userInfo?["code"]) != nil && (notification.userInfo?["number"]) != nil){
            setPhone(phoneNumber: notification.userInfo?["number"] as! String, phoneCode: notification.userInfo?["code"] as! String)
        }
    }
    
    override func viewDidLoad() {
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(setPhoneInfo(_:)), name: Notification.Name(rawValue: "phoneData"), object: nil)
        
        if(set_password == true){
            self.description_code.text = "Définissez un code PIN pour la connexion à Leeap"
        }else{
            self.description_code.text = "Entrez votre code PIN"
        }
        print(phoneNumber)
        print(phoneCode)
        print(SMSCode)
        
        
        if(SPLASH_LOGIN){
            self.try_biometrical_auth();
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        pin1.alpha=0.5
        pin2.alpha=0.5
        pin3.alpha=0.5
        pin4.alpha=0.5
        
        let tap0 = UITapGestureRecognizer(target: self, action: #selector(self.press0))
        zero.isUserInteractionEnabled = true
        zero.addGestureRecognizer(tap0)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.press1))
        one.isUserInteractionEnabled = true
        one.addGestureRecognizer(tap)
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.press2))
        two.isUserInteractionEnabled = true
        two.addGestureRecognizer(tap2)
        
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(self.press3))
        three.isUserInteractionEnabled = true
        three.addGestureRecognizer(tap3)
        
        let tap4 = UITapGestureRecognizer(target: self, action: #selector(self.press4))
        four.isUserInteractionEnabled = true
        four.addGestureRecognizer(tap4)
        
        let tap5 = UITapGestureRecognizer(target: self, action: #selector(self.press5))
        five.isUserInteractionEnabled = true
        five.addGestureRecognizer(tap5)
        
        let tap6 = UITapGestureRecognizer(target: self, action: #selector(self.press6))
        six.isUserInteractionEnabled = true
        six.addGestureRecognizer(tap6)
        
        
        let tap7 = UITapGestureRecognizer(target: self, action: #selector(self.press7))
        seven.isUserInteractionEnabled = true
        seven.addGestureRecognizer(tap7)
        
        let tap8 = UITapGestureRecognizer(target: self, action: #selector(self.press8))
        eight.isUserInteractionEnabled = true
        eight.addGestureRecognizer(tap8)
        
        let tap9 = UITapGestureRecognizer(target: self, action: #selector(self.press9))
        nine.isUserInteractionEnabled = true
        nine.addGestureRecognizer(tap9)
        
        
        let tapErase = UITapGestureRecognizer(target: self, action: #selector(self.pressErase))
        erase.isUserInteractionEnabled = true
        erase.addGestureRecognizer(tapErase)
        
    }
    
    
    
    @objc func press1(){
        UIView.transition(with: one, duration: 0.2, options: .transitionCrossDissolve, animations: {
            self.one.textColor = UIColor(red: 251/255, green: 78/255, blue: 163/255, alpha: 0.5)
        }, completion: { _ in
            UIView.transition(with: self.one, duration: 0.2, options: .transitionCrossDissolve, animations: {
                self.one.textColor = UIColor(red:255/255, green:255/255, blue:255/255, alpha: 1.0)
            }, completion: nil);
        });
        
        tapFunction(value: 1)
    }
    
    @objc func press2(){
        UIView.transition(with: one, duration: 0.2, options: .transitionCrossDissolve, animations: {
            self.two.textColor = UIColor(red: 251/255, green: 78/255, blue: 163/255, alpha: 0.5)
        }, completion: { _ in
            UIView.transition(with: self.two, duration: 0.2, options: .transitionCrossDissolve, animations: {
                self.two.textColor = UIColor(red:255/255, green:255/255, blue:255/255, alpha: 1.0)
            }, completion: nil);
        });
        
        tapFunction(value: 2)
    }
    
    @objc func press3(){
        UIView.transition(with: three, duration: 0.2, options: .transitionCrossDissolve, animations: {
            self.three.textColor = UIColor(red: 251/255, green: 78/255, blue: 163/255, alpha: 0.5)
        }, completion: { _ in
            UIView.transition(with: self.three, duration: 0.2, options: .transitionCrossDissolve, animations: {
                self.three.textColor = UIColor(red:255/255, green:255/255, blue:255/255, alpha: 1.0)
            }, completion: nil);
        });
        
        tapFunction(value: 3)
    }
    
    @objc func press4(){
        UIView.transition(with: four, duration: 0.2, options: .transitionCrossDissolve, animations: {
            self.four.textColor = UIColor(red: 251/255, green: 78/255, blue: 163/255, alpha: 0.5)
        }, completion: { _ in
            UIView.transition(with: self.four, duration: 0.2, options: .transitionCrossDissolve, animations: {
                self.four.textColor = UIColor(red:255/255, green:255/255, blue:255/255, alpha: 1.0)
            }, completion: nil);
        });
        
        tapFunction(value: 4)
    }
    
    
    @objc func press5(){
        UIView.transition(with: five, duration: 0.2, options: .transitionCrossDissolve, animations: {
            self.five.textColor = UIColor(red: 251/255, green: 78/255, blue: 163/255, alpha: 0.5)
        }, completion: { _ in
            UIView.transition(with: self.five, duration: 0.2, options: .transitionCrossDissolve, animations: {
                self.five.textColor = UIColor(red:255/255, green:255/255, blue:255/255, alpha: 1.0)
            }, completion: nil);
        });
        
        tapFunction(value: 5)
    }
    
    
    @objc func press6(){
        UIView.transition(with: six, duration: 0.2, options: .transitionCrossDissolve, animations: {
            self.six.textColor = UIColor(red: 251/255, green: 78/255, blue: 163/255, alpha: 0.5)
        }, completion: { _ in
            UIView.transition(with: self.six, duration: 0.2, options: .transitionCrossDissolve, animations: {
                self.six.textColor = UIColor(red:255/255, green:255/255, blue:255/255, alpha: 1.0)
            }, completion: nil);
        });
        
        tapFunction(value: 6)
    }
    
    
    @objc func press7(){
        UIView.transition(with: seven, duration: 0.2, options: .transitionCrossDissolve, animations: {
            self.seven.textColor = UIColor(red: 251/255, green: 78/255, blue: 163/255, alpha: 0.5)
        }, completion: { _ in
            UIView.transition(with: self.seven, duration: 0.2, options: .transitionCrossDissolve, animations: {
                self.seven.textColor = UIColor(red:255/255, green:255/255, blue:255/255, alpha: 1.0)
            }, completion: nil);
        });
        
        tapFunction(value: 7)
    }
    
    
    @objc func press8(){
        UIView.transition(with: eight, duration: 0.2, options: .transitionCrossDissolve, animations: {
            self.eight.textColor = UIColor(red: 251/255, green: 78/255, blue: 163/255, alpha: 0.5)
        }, completion: { _ in
            UIView.transition(with: self.eight, duration: 0.2, options: .transitionCrossDissolve, animations: {
                self.eight.textColor = UIColor(red:255/255, green:255/255, blue:255/255, alpha: 1.0)
            }, completion: nil);
        });
        
        tapFunction(value: 8)
    }
    
    
    @objc func press9(){
        UIView.transition(with: nine, duration: 0.2, options: .transitionCrossDissolve, animations: {
            self.nine.textColor = UIColor(red: 251/255, green: 78/255, blue: 163/255, alpha: 0.5)
        }, completion: { _ in
            UIView.transition(with: self.nine, duration: 0.2, options: .transitionCrossDissolve, animations: {
                self.nine.textColor = UIColor(red:255/255, green:255/255, blue:255/255, alpha: 1.0)
            }, completion: nil);
        });
        
        tapFunction(value: 9)
    }
    
    
    @objc func press0(){
        UIView.transition(with: zero, duration: 0.2, options: .transitionCrossDissolve, animations: {
            self.zero.textColor = UIColor(red: 251/255, green: 78/255, blue: 163/255, alpha: 0.5)
        }, completion: { _ in
            UIView.transition(with: self.zero, duration: 0.2, options: .transitionCrossDissolve, animations: {
                self.zero.textColor = UIColor(red:255/255, green:255/255, blue:255/255, alpha: 1.0)
            }, completion: nil);
        });
        
        tapFunction(value: 0)
    }
    
    
    
    @objc func pressErase(){
        
        UIView.transition(with: erase, duration: 0.2, options: .transitionCrossDissolve, animations: {
            self.erase.textColor = UIColor(red: 251/255, green: 78/255, blue: 163/255, alpha: 0.5)
        }, completion: { _ in
            UIView.transition(with: self.erase, duration: 0.2, options: .transitionCrossDissolve, animations: {
                self.erase.textColor = UIColor(red:255/255, green:255/255, blue:255/255, alpha: 1.0)
            }, completion: nil);
        });
        
        
        tapFunction(value: -1)
    }
    
    @objc func tapFunction(value: NSInteger){
        
        
        
        
        pin1.alpha=0.5
        pin2.alpha=0.5
        pin3.alpha=0.5
        pin4.alpha=0.5
        
        if(value >= 0){
            if(count < 4){
                count = count + 1
                code[count-1]=value
            }
        }else{
            if(count > 0){
                count = count - 1
                code[count]=0;
            }
        }
        
        
        
        
        if(count < 4){
            pin4.alpha=0.5
            pin3.alpha=1
            pin2.alpha=1
            pin1.alpha=1
        }else{
            pin4.alpha=1
        }
        if(count < 3){
            pin3.alpha=0.5
            pin2.alpha=1
            pin1.alpha=1
        }else{
            pin3.alpha=1
        }
        if(count < 2){
            pin2.alpha=0.5
            pin1.alpha=1
        }else{
            pin2.alpha=1
        }
        if(count < 1){
            pin1.alpha=0.5
        }else{
            pin1.alpha=1
        }
        
        
        
        
        
        
        
        
        if(count == 4){
            
            print(code)
            print(phoneNumber)
            let codeString = String(code[0])+String(code[1])+String(code[2])+String(code[3])
            print(codeString)
            
            if(SPLASH_LOGIN){
                self.password_ = codeString
                self.getProfileInfo();
            }
            
            
            Alamofire.request(Leeap.URL,
                              method: .post,
                              parameters: [
                                "sms": [
                                    "connect": [
                                    "number": self.phoneNumber,
                                    "2FA": self.SMSCode,
                                    "PIN": codeString,
                                    "phonecode": self.phoneCode
                                    ]
                                ]
                ]).responseJSON{
                    response in
                    print(response)
                    print("Requested...")
                    switch response.result{
                    case .success(let JSON):
                        print("SMS/Connect: \(JSON)")
                        
                        let response = JSON as! NSDictionary
                        
                        let success = response.object(forKey: "success") as? Bool
                        if(success==false){ //Sucess == false ou cast failed
                            print(JSON)
                            self.reset()

                            if(response["text"] != nil){
                            self.description_code.text = response["text"] as? String
                            }else{
                              self.description_code.text = "Réponse incorrecte du serveur."
                            }
                        }else{
                            if let admin = (response.object(forKey: "Administrator") as? NSString)?.boolValue {
                            
                            self.setRememberToken(token: response.object(forKey: "token") as! String, password: codeString, phone: self.phoneNumber)
                            self.match_found = true
                            self.biometric_sucess = false
                            UserData.token = response.object(forKey: "token") as? String ?? ""
                            UserData.email = response.object(forKey: "Email") as? String ?? ""
                            UserData.administrator = admin
                            UserData.firstname = response.object(forKey: "Firstname") as? String ?? ""
                            UserData.lastname = response.object(forKey: "Lastname") as? String ?? ""
                            UserData.qrcode = response.object(forKey: "QRCode") as? String ?? "NUL"
                            UserData.city = response.object(forKey: "City") as? String ?? "NUL"
                            UserData.id = response.object(forKey: "Id") as? String ?? "NUL"
                            UserData.phoneindicative = response.object(forKey: "PhoneIndicative") as? String ?? "NUL"
                            UserData.postcode = response.object(forKey: "Postcode") as? String ?? "NUL"
                            }
                            
                            let storyBoard : UIStoryboard = UIStoryboard(name: "Login", bundle:nil)
                            let resultViewController = storyBoard.instantiateViewController(withIdentifier: "faceIdConfirm") as! EnableFaceIDController
                            resultViewController.administrator=UserData.administrator
                            self.present(resultViewController, animated:true, completion:nil)
                        }
                    case .failure(let error):
                        print(error)
                    }
            }
            
            
           
            
        }
        
    }
    
    
    
    
    func reset(){
        self.count=0
        self.code = [0,0,0,0]
        
        self.pin1.alpha=0.5
        self.pin2.alpha=0.5
        self.pin3.alpha=0.5
        self.pin4.alpha=0.5
    }
    
    func showKeyboard(show: Bool){
        let keys = [zero, one, two, three, four, five, six, seven, eight, nine, erase, forgot]
      
        keys.forEach { key in
            if(show){
                key?.isHidden=false
            }else{
                key?.isHidden=true
            }
        }
    }
    
    func setRememberToken(token: String, password: String, phone: String){
       
        AppSecurity().revokeToken()
        
            var server = "leeap.cash"
            var username = phone
            var password = password.data(using: .utf8)!
            var attributes: [String: Any] = [
                (kSecClass as String): kSecClassInternetPassword,
                (kSecAttrServer as String): server,
                (kSecAttrAccount as String): username,
                (kSecValueData as String): password]
            // Let's add the item to the Keychain! 😄
            SecItemAdd(attributes as CFDictionary, nil) == noErr
        
        
        
         server = "api.leeap.cash"
         username = "token"
         password = token.data(using: .utf8)!
         attributes = [
            (kSecClass as String): kSecClassInternetPassword,
            (kSecAttrServer as String): server,
            (kSecAttrAccount as String): username,
            (kSecValueData as String): password]
        SecItemAdd(attributes as CFDictionary, nil) == noErr
    
    }
    
    
    
    
    
    
    
    
    
    
    /*=======================================
     =
     =
     =              ALREADY SIGNED UP
     =
     =
     ========================================*/
    
    
    func try_biometrical_auth(){
        showKeyboard(show: false)
        let myContext = LAContext()
        let myLocalizedReasonString = "Se connecter à Leeap"
        var authError: NSError?
        if #available(iOS 8.0, macOS 10.12.1, *) {
            
            
            if myContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
                
                myContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: myLocalizedReasonString) { success, evaluateError in
                    
                    DispatchQueue.main.async {
                        if success {
                            // User authenticated successfully, take appropriate action
                            print("User authenticated successfully")
                            self.biometric_sucess=true;
                             self.match_found=true;
                            self.getProfileInfo()
                            
                        } else {
                            // User did not authenticate successfully, look at error and take appropriate action
                             self.showKeyboard(show: true)
                            print("Sorry user did not authenticate successfully")
                        }
                    }
                }
            } else {
                // Could not evaluate policy; look at authError and present an appropriate message to user
                 self.showKeyboard(show: true)
                print("Sorry Could not evaluate policy.")
            }
        } else {
            // Fallback on earlier versions
            self.showKeyboard(show: true)
            print("Ooops This feature is not supported.")
        }
        
        
      
        
        
    }
    
    
    
    
    
    private var password_ = ""
    private var match_found = false;
    private var biometric_sucess = false;
    
    func getProfileInfo(){
        print("biometric success")
        print(biometric_sucess)
        print("match found")
        print(match_found)
        if(!biometric_sucess){
            let query: [String: Any] = [
                (kSecClass as String): kSecClassInternetPassword,
                (kSecAttrServer as String): "leeap.cash",
                (kSecMatchLimit as String): kSecMatchLimitOne,
                (kSecReturnAttributes as String): true,
                (kSecReturnData as String): true]
            var item: CFTypeRef?
            
            SecItemCopyMatching(query as CFDictionary, &item) == noErr
            
            if let item = item as? [String: Any],
                let username = item[kSecAttrAccount as String] as? String,
                let passwordData = item[kSecValueData as String] as? Data,
                let password = String(data: passwordData, encoding: .utf8) {
                if(password == password_){
                match_found=true;
                password_=password
                }
            }
            
        }
        
        
        if(match_found){
        let query: [String: Any] = [
            (kSecClass as String): kSecClassInternetPassword,
            (kSecAttrServer as String): "api.leeap.cash",
            (kSecMatchLimit as String): kSecMatchLimitOne,
            (kSecReturnAttributes as String): true,
            (kSecReturnData as String): true]
        var item: CFTypeRef?
        
        // should succeed
        SecItemCopyMatching(query as CFDictionary, &item) == noErr
        
        if let item = item as? [String: Any],
            let username = item[kSecAttrAccount as String] as? String,
            let passwordData = item[kSecValueData as String] as? Data,
            let password = String(data: passwordData, encoding: .utf8) {
            print("\(username) - \(password)")
            match_found=true;
            password_=password
        }
        print(match_found)
        if(match_found == true){
            Alamofire.request(Leeap.URL,
                              method: .post,
                              parameters: [
                                "profile":[
                                    "getLogedUserProfile" : true,
                                    "token": password_
                                    
                                ]
                ]
                ).responseJSON{
                    response in
                    
                    switch response.result{
                    case .success(let JSON):
                        print("Success with JSON: \(JSON)")
                        
                        let response = JSON as! NSDictionary
                 
                        let success = response.object(forKey: "success") as! Bool
                        
                        if(success){
                            if let admin = (response.object(forKey: "Administrator") as? NSString)?.boolValue {
                                UserData.token = self.password_
                                UserData.email = response.object(forKey: "Email") as? String ?? ""
                                UserData.administrator = admin
                                UserData.firstname = response.object(forKey: "Firstname") as? String ?? ""
                                UserData.lastname = response.object(forKey: "Lastname") as? String ?? ""
                                UserData.qrcode = response.object(forKey: "QRCode") as? String ?? "NUL"
                                UserData.city = response.object(forKey: "City") as? String ?? "NUL"
                                UserData.id = response.object(forKey: "Id") as? String ?? "NUL"
                                UserData.phoneindicative = response.object(forKey: "PhoneIndicative") as? String ?? "NUL"
                                UserData.postcode = response.object(forKey: "Postcode") as? String ?? "NUL"
                                
                                //Select relevant view controller
                                if(admin){
                                    let storyboard = UIStoryboard(name: "Login", bundle: nil)
                                    let VC = storyboard.instantiateViewController(withIdentifier: "ModeChoose")
                                    self.present(VC, animated: true, completion: nil)
                                }else{
                                    let storyboard = UIStoryboard(name: "User", bundle: nil)
                                    let VC = storyboard.instantiateViewController(withIdentifier: "userHomeScreen") as! UITabBarController
                                    self.present(VC, animated: true, completion: nil)
                                }
                            }else{
                                let storyboard = UIStoryboard(name: "User", bundle: nil)
                                let VC = storyboard.instantiateViewController(withIdentifier: "userHomeScreen") as! UITabBarController
                                self.present(VC, animated: true, completion: nil)
                            }
                        }else{
                            AppSecurity().revokeToken()
                            //Load login view Controller
                            let storyboard = UIStoryboard(name: "Login", bundle: nil)
                            let VC = storyboard.instantiateViewController(withIdentifier: "intropages")
                            self.present(VC, animated: true, completion: nil)
                        }
                    case .failure(let error):
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let VC = storyboard.instantiateViewController(withIdentifier: "LostNetworkVC") as! LostNetworkVC
                        self.present(VC, animated: true, completion: nil)
                    }
            }
        }
        }
    }
}
