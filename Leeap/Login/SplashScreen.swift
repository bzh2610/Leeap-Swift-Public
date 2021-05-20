//
//  SplashScreen.swift
//  Leeap
//
//  Created by Evan OLLIVIER on 19/03/2019.
//  Copyright © 2019 Evan OLLIVIER. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import LocalAuthentication



class SplashScreen: UIViewController{
    
    private var match_found = false;
    private var password_ = "";
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        
        
        
        let query: [String: Any] = [
            (kSecClass as String): kSecClassInternetPassword,
            (kSecAttrServer as String): "api.leeap.cash",
            (kSecMatchLimit as String): kSecMatchLimitOne,
            (kSecReturnAttributes as String): true,
            (kSecReturnData as String): true]
        var item: CFTypeRef?
        
        // should succeed
        SecItemCopyMatching(query as CFDictionary, &item)
       
        if let item = item as? [String: Any],
            let username = item[kSecAttrAccount as String] as? String,
            let passwordData = item[kSecValueData as String] as? Data,
            let password = String(data: passwordData, encoding: .utf8) {
            print("\(username) - \(password)")
            match_found=true;
            self.password_=password
        }
        print(match_found)
        if(match_found == true){
            
          //NEED TO INIT PROD AND TEST AGAIN
            Authentication().setEnvironment()
            
            Alamofire.request(Leeap.URL_PROD,
                              method: .post,
                              parameters: [
                                "profile":[
                                    "getLogedUserProfile" : true,
                                    "token": self.password_
                                    
                                ]
                ]
                ).responseJSON{
                    response in
                    print(Leeap.URL)
                    print(self.password_)
                    
                    switch response.result{
                    case .success(let JSON):
                        print("Success with JSON: \(JSON)")
                        
                        let response = JSON as! NSDictionary
                        
                        let success = response.object(forKey: "success") as! Bool
                        
                        if(success == true){
                let storyboard = UIStoryboard(name: "Login", bundle: nil)
                let VC = storyboard.instantiateViewController(withIdentifier: "PinCodeController") as! PinCodeController
                VC.SPLASH_LOGIN=true
                self.present(VC, animated: true, completion: nil)
                
                           /* if let admin = (response.object(forKey: "Administrator") as? NSString)?.boolValue {
                                if(admin){
                                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                    let VC = storyboard.instantiateViewController(withIdentifier: "ModeChoose") as! UIViewController
                                    self.present(VC, animated: true, completion: nil)
                                    
                                    
                                }else{
                                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                    let VC = storyboard.instantiateViewController(withIdentifier: "userHomeScreen") as! UITabBarController
                                    self.present(VC, animated: true, completion: nil)
                                }
                            }else{
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let VC = storyboard.instantiateViewController(withIdentifier: "loginPhone") as! PhoneNumberController
                                self.present(VC, animated: true, completion: nil)
                            }
                              */
                            
                        }else{
                            var query: [String: Any] = [
                                (kSecClass as String): kSecClassInternetPassword,
                                (kSecAttrServer as String): "api.leeap.cash"
                            ]
                           // print(SecItemDelete(query as CFDictionary))
                            
                            query = [
                                (kSecClass as String): kSecClassInternetPassword,
                                (kSecAttrServer as String): "leeap.cash"
                            ]
                          //  print(SecItemDelete(query as CFDictionary))
                
                            let storyboard = UIStoryboard(name: "Login", bundle: nil)
                            let VC = storyboard.instantiateViewController(withIdentifier: "loginPhone") as! PhoneNumberController
                            self.present(VC, animated: true, completion: nil)
                        }
                    case .failure(let error):
                        print(error)
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let VC = storyboard.instantiateViewController(withIdentifier: "LostNetworkVC") as! LostNetworkVC
                        self.present(VC, animated: true, completion: nil)
                    }
            }
        }else{
            print("No result for creditentials")
            
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let VC = storyboard.instantiateViewController(withIdentifier: "intropages") 
            self.present(VC, animated: true, completion: nil)
            
        }
        
    }
}
