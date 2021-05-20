//
//  ManualSignupVC.swift
//  Leeap
//
//  Created by Evan OLLIVIER on 04/03/2019.
//  Copyright © 2019 Evan OLLIVIER. All rights reserved.
//

import Foundation
import UIKit


class ManualSignupVC: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
   
    
   
    @IBOutlet weak var firstname: UITextField!
    @IBOutlet weak var lastname: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var reglement: UITextField!
    let modes_reglements = [String](arrayLiteral: "Autre", "Carte Bancaire", "Chèque", "Espèces", "Virement")
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do this for each UITextField
        firstname.delegate = self
        lastname.delegate = self
        email.delegate = self
        phone.delegate = self
        
        let thePicker = UIPickerView()
        
        thePicker.delegate=self
        reglement.inputView = thePicker

        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        reglement.inputAccessoryView = toolBar
        
       
    }
    
    @objc func doneClick() {
        if let nextField = reglement.superview?.viewWithTag(reglement.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            reglement.resignFirstResponder()
        }
    }

    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView( _ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return modes_reglements.count
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return modes_reglements[row]
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        reglement.text = modes_reglements[row]
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        // Do not add a line break
        return false
    }
    
    
    
    
}
