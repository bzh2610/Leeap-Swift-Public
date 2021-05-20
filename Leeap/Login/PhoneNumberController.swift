//
//  PhoneNumberController.swift
//  Leeap
//
//  Created by Evan OLLIVIER on 17/03/2019.
//  Copyright © 2019 Evan OLLIVIER. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import CountryPickerView

class PhoneNumberController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var error_description: UILabel!
    @IBOutlet weak var contact_support_btn: UIButton!
     @IBOutlet weak var phoneInput: UITextField?;
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var countryCodeText: UILabel!
    
    var phone: String = ""
     let cpvInternal = CountryPickerView()
   
    @IBAction func contact_support(_ sender: Any) {
        
        if let url = URL(string: "https://m.me/leeapCash") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:])
            } else {
               
            }
        }
        
    }
    
    
   
    
    @objc func dismiss_keyboard(_ sender: Any){
        phoneInput!.resignFirstResponder()
        
    }
    override func viewDidLoad() {
        let tap0 = UITapGestureRecognizer(target: self, action: #selector(dismiss_keyboard(_: )))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tap0)
        self.phoneInput?.delegate=self
        cpvInternal.dataSource = self as CountryPickerViewDataSource
        
        cpvInternal.delegate=self
        
    }
    
    
    @IBAction func next(_ sender: Any) {
        self.contact_support_btn.isHidden=true
        self.error_description.isHidden=true
        
        phone = self.phoneInput!.text!
        phone = phone.replacingOccurrences(of: " ", with: "")
        phone = phone.replacingOccurrences(of: "+33", with: "0")
        print(phone as Any)
        
        if(phone.count > 0){
        if(phone.prefix(upTo: phone.index(phone.startIndex, offsetBy: 1)) == "0"){
            //Nothing
        }else{
            phone = "0"+phone
        }
        }
        
        var phone_indicative = self.countryCodeText.text!
        if(phone_indicative.prefix(upTo: phone_indicative.index(phone_indicative.startIndex, offsetBy: 1)) == "+"){
            phone_indicative = String(phone_indicative.dropFirst())
        }

        Alamofire.request(Leeap.URL,
                          method: .post,
                          parameters: [
                            "sms":[
                                "request": [
                                    "phone": phone,
                                    "indicative": phone_indicative
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
                    
                    let result = response.object(forKey: "success") as? Bool ?? false
                    let description = response.object(forKey: "text") as? String
                    print("RESULT === >")
                    print(result)
                    if(result == true){
                        self.next_controller()
                    }else{
                        self.error_description.text = description
                        self.contact_support_btn.isHidden=false
                        self.error_description.isHidden=false
                    }
                    
                case .failure(let error):
                    self.error_description.text = "Impossible de se connecter à notre serveur. Merci de réessayer."
                    self.contact_support_btn.isHidden=false
                    self.error_description.isHidden=false
                    
        }
        }
    
        //CALL NEXT CONTROLLER
        
        
    }
    
    func next_controller(){
       //Delete 0 in 06 or 07
        if(phone.prefix(upTo: phone.index(phone.startIndex, offsetBy: 1)) == "0"){
            phone = String(phone.dropFirst())
        }
        //Delete + in country code
        var phone_indicative = self.countryCodeText.text!
        if(phone_indicative.prefix(upTo: phone_indicative.index(phone_indicative.startIndex, offsetBy: 1)) == "+"){
            phone_indicative = String(phone_indicative.dropFirst())
        }
        
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "PhoneCodeController") as! PhoneCodeController
        myVC.phone_number = phone
        myVC.phone_indicative = phone_indicative
        
        self.present(myVC, animated: true, completion: nil)

    }
    
    
   
    @IBAction func press_countryCode(_ sender: Any) {
          cpvInternal.showCountriesList(from: self)
    }
}





extension PhoneNumberController: CountryPickerViewDelegate {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        // Only countryPickerInternal has it's delegate set
        let title = "Pays choisi"
        let message = "Name: \(country.name) \nCode: \(country.code) \nPhone: \(country.phoneCode)"
        //  showAlert(title: title, message: message)
        flagImageView.image = country.flag
        flagImageView.isHidden=false
        flagImageView.layer.cornerRadius = 12.5;
        flagImageView.layer.masksToBounds = true
        //        flagLabel.text = country.phoneCode
        countryCodeText.text = country.phoneCode
    }
}

extension PhoneNumberController: CountryPickerViewDataSource {
    func preferredCountries(in countryPickerView: CountryPickerView) -> [Country] {
        if countryPickerView.tag == cpvInternal.tag/* && //showPreferredCountries.isOn*/ {
            var countries = [Country]()
            ["FR", "GB", "US", "BE"].forEach { code in
                if let country = countryPickerView.getCountryByCode(code) {
                    countries.append(country)
                }
            }
            return countries
        }
        return []
    }
    
    func sectionTitleForPreferredCountries(in countryPickerView: CountryPickerView) -> String? {
        if countryPickerView.tag == cpvInternal.tag /* && showPreferredCountries.isOn */ {
            return ""
        }
        return nil
    }
    
    
    
    func navigationTitle(in countryPickerView: CountryPickerView) -> String? {
        return "Choissez un pays"
    }
    
    //   func searchBarPosition(in countryPickerView: CountryPickerView) -> SearchBarPosition {
    /*       if countryPickerView.tag == cpvMain.tag {
     /*  switch searchBarPosition.selectedSegmentIndex {
     case 0: return .tableViewHeader
     case 1: return .navigationBar
     default: return .hidden
     }*/
     }
     return .tableViewHeader
     }*/
    
    func showPhoneCodeInList(in countryPickerView: CountryPickerView) -> Bool {
        //if countryPickerView.tag == cpvMain.tag {
        //  return showPhoneCodeInList.isOn
        //}
        //return false
        return true
    }
}
