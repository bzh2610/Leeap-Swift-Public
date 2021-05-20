//
//  EnableFaceId.swift
//  Leeap
//
//  Created by Evan OLLIVIER on 17/03/2019.
//  Copyright © 2019 Evan OLLIVIER. All rights reserved.
//

import Foundation
import UIKit
import LocalAuthentication





class EnableFaceIDController: UIViewController{
    
    var administrator = false
    var firstname = ""
    
    @IBOutlet weak var hello_firstname: UILabel!
    @IBOutlet weak var biometric_description: UILabel!
    @IBOutlet weak var biometric_icon: UIImageView!
    
    func biometricType() -> String {
        let authContext = LAContext()
        if #available(iOS 11, *) {
            let _ = authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
            switch(authContext.biometryType) {
            case .none:
                return ""
            case .touchID:
                self.biometric_description.text = "Afin de protéger votre accès à Leeap, vous pouvez activer Touch ID"
                return "touchId"
            case .faceID:
                self.biometric_description.text = "Afin de protéger votre accès à Leeap, vous pouvez activer Face ID"
                return "faceId"
            }
        } else {
            return ""
            // return authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) ?? ""
        }
    }
   
    @IBOutlet weak var okay_enable: UIButton!
    
    @IBAction func okay_enable(_ sender: Any) {
        
        let myContext = LAContext()
        let myLocalizedReasonString = "Se connecter à Leeap"
        var authError: NSError?
        if #available(iOS 8.0, macOS 10.12.1, *) {
            
            
            if myContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
                
                myContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: myLocalizedReasonString) { success, evaluateError in
                    
                    DispatchQueue.main.async {
                        if success {
                            // User authenticated successfully, take appropriate action
                            print("Awesome!!... User authenticated successfully")
                            self.nextView()
                        } else {
                            // User did not authenticate successfully, look at error and take appropriate action
                            self.okay_enable.setTitle("Réessayer", for: .normal)
                            print("Sorry!!... User did not authenticate successfully")
                        }
                    }
                }
            } else {
                // Could not evaluate policy; look at authError and present an appropriate message to user
                self.okay_enable.setTitle("Non autorisé", for: .normal)
                // self.okay_enable.isEnabled = false
                print("Sorry!!.. Could not evaluate policy.")
                
            }
        } else {
            // Fallback on earlier versions
            print("Ooops!!.. This feature is not supported.")
            self.okay_enable.setTitle("Non supporté", for: .normal)
            //self.okay_enable.isEnabled = false
        }
        
        
      
        
    }
    
    @IBAction func usePinCode(_ sender: Any) {
        self.nextView()
    }
    
    func nextView(){
       
        
        if(UserData.administrator){
            let storyBoard : UIStoryboard = UIStoryboard(name: "Login", bundle:nil)
            let resultViewController = storyBoard.instantiateViewController(withIdentifier: "ModeChoose")
            self.present(resultViewController, animated:true, completion:nil)
        }else{
            let storyBoard : UIStoryboard = UIStoryboard(name: "User", bundle:nil)
            let resultViewController = storyBoard.instantiateViewController(withIdentifier: "userHomeScreen")
            self.present(resultViewController, animated:true, completion:nil)
            
        }
       
        
    }
    
    override func viewDidLoad() {
        self.hello_firstname.text = "Bonjour "+UserData.firstname+" !"
        print(self.biometricType())
        self.biometric_icon.image = UIImage(named: self.biometricType())
        

        
    }
    
    
    
}
