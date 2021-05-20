//
//  UserSettingsVC.swift
//  Leeap
//
//  Created by Evan OLLIVIER on 22/03/2019.
//  Copyright © 2019 Evan OLLIVIER. All rights reserved.
//

import Foundation
import UIKit



class UserSettingsVC: UITableViewController{
    
    
    @IBOutlet weak var backtochooserow: UITableViewCell!
    
    @IBOutlet weak var fullname: UILabel!
    
    @IBAction func backToChooseMenu(_ sender: Any){
        print("back")
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "ModeChoose")
        self.present(VC, animated: true, completion: nil)
    }

    @IBAction func disconnect(_ sender: Any) {
        AppSecurity().revokeToken()
        //Load login view Controller
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "intropages")
        self.present(VC, animated: true, completion: nil)
    }
    
    
   
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.barStyle = .black;
        self.fullname.text=UserData.firstname+" "+UserData.lastname
        
        if(!UserData.administrator){
            self.backtochooserow.isHidden=true//removeFromSuperview()
        }
    }
}


class ProfileSettingsVC: UIViewController, UITextFieldDelegate{
     @IBOutlet weak var firstname: UITextField!
     @IBOutlet weak var lastname: UITextField!
     @IBOutlet weak var address: UITextField!
     @IBOutlet weak var city: UITextField!
     @IBOutlet weak var postcode: UITextField!
     @IBOutlet weak var country: UITextField!

    @objc func dismiss_keyboard(_ sender: Any){
        firstname!.resignFirstResponder()
        lastname!.resignFirstResponder()
        address!.resignFirstResponder()
        city!.resignFirstResponder()
        postcode!.resignFirstResponder()
        country!.resignFirstResponder()
        
    }
    
    override func viewDidLoad() {
        self.firstname.text = UserData.firstname
        self.lastname.text = UserData.lastname
        //self.address.text = UserData.a
        self.city.text = UserData.city
        self.postcode.text = UserData.postcode
        self.country.text = "France"
        
        
        let tap0 = UITapGestureRecognizer(target: self, action: #selector(dismiss_keyboard(_: )))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tap0)
        self.firstname?.delegate=self
        self.lastname?.delegate=self
         self.address?.delegate=self
         self.city?.delegate=self
         self.postcode?.delegate=self
         self.country?.delegate=self

        
    }
    
}
