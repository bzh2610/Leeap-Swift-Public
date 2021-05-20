//
//  APIClient.swift
//  Leeap
//
//  Created by Evan OLLIVIER on 12/03/2019.
//  Copyright © 2019 Evan OLLIVIER. All rights reserved.
//
import Alamofire
import Stripe

class MainAPIClient: NSObject, STPEphemeralKeyProvider {
    
    static let shared = MainAPIClient()
    
    var baseURLString = ""
    
    // MARK: Rocket Rides
    
    enum RequestRideError: Error {
        case missingBaseURL
        case invalidResponse
        case denied
    }
    
    //HERE
    
    func requestRide(source: String, amount: Int, currency: String, token: String, completion: @escaping (Ride?, RequestRideError?) -> Void) {
       /* let endpoint = "/api/rides"
        
        guard
            !baseURLString.isEmpty,
            let baseURL = URL(string: baseURLString),
            let url = URL(string: endpoint, relativeTo: baseURL) else {
                completion(nil, .missingBaseURL)
                return
        }*/
       
        // Important: For this demo, we're trusting the `amount` and `currency` coming from the client request.
        // A real application should absolutely have the `amount` and `currency` securely computed on the backend
        // to make sure the user can't change the payment amount from their web browser or client-side environment.
        print(STPPaymentConfiguration.shared().publishableKey)
        let parameters: [String: Any] = [
            "token": UserData.token,
            "iOS": [
                "charge":[
                "source": source,
                "amount": amount,
                "currency": currency,
                "metadata": [
                    // example-ios-backend allows passing metadata through to Stripe
                    "phone": UserData.phone,
                    "token": token,
                    "charge_request_id": "B3E611D1-5FA1-4410-9CEC-00958A5126CB",
                    ],
                ]
            ]
        ]
        print(parameters)
        
        Alamofire.request(Leeap.URL,
                          method: .post,
                          parameters: parameters
        ).responseJSON{
            response in
            
            switch response.result{
            case .success(let JSON):
                print("Success with JSON: \(JSON)")
                
                let response = JSON as! NSDictionary
                
                let success = response.object(forKey: "success") as? Bool ?? false
                if(success){
                    completion(Ride(pilotName: "Et hop ! +"+String(Double(amount)/100.0)+"€ !", pilotVehicle: "Facturé à "+UserData.firstname+" "+UserData.lastname, pilotLicense: ""), nil)
                }else{
                     completion(nil, .denied )
                }
                
                
            case .failure(let error):
                completion(nil, .invalidResponse)
                return
            }

            /*guard let pilotName = json["pilot_name"] as? String,
                let pilotVehicle = json["pilot_vehicle"] as? String,
                let pilotLicense = json["pilot_license"] as? String else {
                    completion(nil, .invalidResponse)
                    return
             }*/
            
                   }
    }
    
    // MARK: STPEphemeralKeyProvider
    
    enum CustomerKeyError: Error {
        case missingBaseURL
        case invalidResponse
    }
    
    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
        /*let endpoint = "/api/passengers/me/ephemeral_keys"
        
        guard
            !baseURLString.isEmpty,
            let baseURL = URL(string: baseURLString),
            let url = URL(string: endpoint, relativeTo: baseURL) else {
                completion(nil, CustomerKeyError.missingBaseURL)
                return
        }
        
        let parameters: [String: Any] = ["api_version": apiVersion]
        
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON { (response) in
            guard let json = response.result.value as? [AnyHashable: Any] else {
                completion(nil, CustomerKeyError.invalidResponse)
                return
            }
            
            completion(json, nil)
        }*/
        print("API VERSION")
        print(apiVersion) //2015-10-12
        
        let url = Leeap.URL
        //self.baseURL//.appendingPathComponent("ephemeral_keys")
        Alamofire.request(url, method: .post, parameters:[
            "iOS": [
                "api_version": apiVersion,
            ],
            "token": UserData.token
            ])
            .validate(statusCode: 200..<300)
            .responseJSON { responseJSON in
                print(responseJSON);//Debug
                switch responseJSON.result {
                case .success(let json):
                    completion(json as? [String: AnyObject], nil)
                case .failure(let error):
                    completion(nil, error)
                }
        }
    }
    
}
