//
//  ModeChoose.swift
//  Leeap
//
//  Created by Evan OLLIVIER on 22/03/2019.
//  Copyright © 2019 Evan OLLIVIER. All rights reserved.
//

import Foundation
import  UIKit
#if canImport(CoreNFC)
import CoreNFC
#endif

class ModeChooseVC: UIViewController{
    
    
    @IBOutlet weak var hello_firstname: UILabel!
    @IBOutlet weak var error_desc: UILabel!
    @IBOutlet weak var adminButton: UIButton!
    
    @IBAction func admin(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "DarkTabBarController") as! DarkTabBarController
        self.present(myVC, animated: true, completion: nil)
    }
    
    
    @IBAction func user(_ sender: Any) {
         let storyboard = UIStoryboard.init(name: "User", bundle: nil)
         let myVC = storyboard.instantiateViewController(withIdentifier: "userHomeScreen") as! UITabBarController
         self.present(myVC, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        self.hello_firstname.text = "Bonjour "+UserData.firstname+" !"
        if #available(iOS 11.0, *) {
            if NFCNDEFReaderSession.readingAvailable {
                // available
                self.adminButton.isEnabled=true
                self.error_desc.isHidden=true
                self.adminButton.setTitle("Espace administrateur", for: .normal)
            }
            else {
                // not
                self.adminButton.isEnabled=false
                 self.error_desc.isHidden=false
                self.error_desc.text = "⚠ L'espace administrateur est uniquement fonctionnel sur les appareils équipés d'une puce NFC (iPhone >7)."
                self.adminButton.setTitle("⛔️ Espace administrateur", for: .normal)
            }
        } else {
            //iOS don't support
            self.adminButton.isEnabled=false
            self.error_desc.isHidden=false
            self.error_desc.text = "⚠ L'espace administrateur est uniquement fonctionnel sur les appareils équipés d'iOS >11 d'une puce NFC (iPhone >7)."
            self.adminButton.setTitle("⛔️ Espace administrateur", for: .normal)
        }
    }
}
