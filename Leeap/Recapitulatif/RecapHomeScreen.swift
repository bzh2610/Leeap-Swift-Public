//
//  File.swift
//  Leeap
//
//  Created by Evan OLLIVIER on 23/02/2019.
//  Copyright © 2019 Evan OLLIVIER. All rights reserved.
//

import UIKit

class DarkTabBarController: UITabBarController{
    
}


class RecapHomeScreen: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
      
    }
    

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}


class ActivateScreen: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var IBAN: UITextField!
    
    @objc func dismiss_keyboard(_ sender: Any){
        IBAN!.resignFirstResponder()
        
    }
    override func viewDidLoad() {
        let tap0 = UITapGestureRecognizer(target: self, action: #selector(dismiss_keyboard(_: )))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tap0)
          self.tabBarController?.tabBar.isHidden = true;
    }
    
    @IBAction func close(_ sender: Any) {
        
        self.dismiss(animated: true, completion: {});
         self.tabBarController?.tabBar.isHidden = false;
    }
    
}


class PersonalizeScreen: UIViewController{


    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: {});
       
        self.navigationController?.popViewController(animated: true)
    }
}
