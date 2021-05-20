//
//  AppDelegate.swift
//  Leeap
//
//  Created by Evan OLLIVIER on 19/02/2019.
//  Copyright © 2019 Evan OLLIVIER. All rights reserved.
//

import UIKit
import CoreData
import Stripe
import Alamofire

extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = " "
        formatter.decimalSeparator = "€"
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    static let withComma: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = " "
        formatter.decimalSeparator = ","
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
}


extension String {
    var doubleValue: Float {
        let converter = NumberFormatter()
        
        converter.decimalSeparator = ","
        if let result = converter.number(from: self) {
            return result.floatValue
            
        } else {
            
            converter.decimalSeparator = "."
            if let result = converter.number(from: self) {
                return result.floatValue
            }
        }
        return 0
    }
}


extension Double{
    var formattedWithSeparator: String {
        return Formatter.withSeparator.string(for: self) ?? ""
    }
    
    var formattedWithComma: String {
        return Formatter.withSeparator.string(for: self) ?? ""
    }
    
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension CGFloat{
    var formattedWithSeparator: String {
        return Formatter.withSeparator.string(for: self) ?? ""
    }
}


struct Leeap{
    static var prod: Bool = false
    static var URL_PROD = "https://apiv2.leeap.cash"
    static var URL_TEST = "https://dev.leeap.cash"
    static var URL = URL_TEST
    static let STRIPE_TEST = ""
    static let STRIPE_PROD = ""
    static var STRIPE = STRIPE_TEST
}

struct AdminCart{
    static var card: [Int: [String: Any]] = [:]
    static var brewage_view_type: String = ""
}


struct UserCart{
    static var amount: Double = 0.00
}

struct TempLoginData{
    static var TWO_FA = ""
    static var token = ""
    static var code = ""
    static var phone = ""
    static var pasword = ""
}


struct UserData{
    static var id = ""
    static var firstname = ""
    static var lastname = ""
    static var email = ""
    static var phone = ""
    static var token = ""
    static var balance = 0.00
    static var qrcode = ""
    static var administrator = false
    static var city = ""
    static var phoneindicative = ""
    static var postcode = ""
  
}

class Authentication{
    
    
    public func setEnvironment(){
        Alamofire.request("https://apiv2.leeap.cash/",
                          method: .post,
                          parameters: [ "PROD_OR_TEST": true ]
            ).responseJSON{
                response in
                
                switch response.result{
                case .success(let JSON):
                    print("Success with JSON: \(JSON)")
                    
                    let response = JSON as! NSDictionary
                    
                    let prod = response.object(forKey: "prod") as? Bool ?? false
                    Leeap.prod=prod
                    if(prod){
                        Leeap.URL=Leeap.URL_PROD
                        Leeap.STRIPE=Leeap.STRIPE_PROD
                        STPPaymentConfiguration.shared().publishableKey = Leeap.STRIPE_PROD
                    }else{
                        Leeap.URL=Leeap.URL_TEST
                        Leeap.STRIPE=Leeap.STRIPE_TEST
                        STPPaymentConfiguration.shared().publishableKey = Leeap.STRIPE_TEST
                    }
                    
                    
                case .failure(let error):
                    Leeap.prod=false
                }
    }
    }
}

class AppSecurity{
    
    public func revokeToken(){
        var query: [String: Any] = [
            (kSecClass as String): kSecClassInternetPassword,
            (kSecAttrServer as String): "api.leeap.cash"
        ]
        print(SecItemDelete(query as CFDictionary))
        
        query = [
            (kSecClass as String): kSecClassInternetPassword,
            (kSecAttrServer as String): "leeap.cash"
        ]
        print(SecItemDelete(query as CFDictionary))
        
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private let appleMerchantIdentifier: String = "merchant.leeap.cash"


    override init() {
        super.init()
        
        Alamofire.request("https://apiv2.leeap.cash/",
                          method: .post,
                          parameters: [ "PROD_OR_TEST": true ]
                ).responseJSON{
                response in
                
                switch response.result{
                case .success(let JSON):
                    print("Success with JSON: \(JSON)")
                    
                    let response = JSON as! NSDictionary
                    
                    let prod = response.object(forKey: "prod") as? Bool ?? false
                    Leeap.prod=prod
                    if(prod){
                        Leeap.URL=Leeap.URL_PROD
                        Leeap.STRIPE=Leeap.STRIPE_PROD
                       // self.publishableKey=Leeap.STRIPE_PROD
                        STPPaymentConfiguration.shared().publishableKey = Leeap.STRIPE_PROD
                    }else{
                        Leeap.URL=Leeap.URL_TEST
                        Leeap.STRIPE=Leeap.STRIPE_TEST
                        //self.publishableKey=Leeap.STRIPE_TEST
                        STPPaymentConfiguration.shared().publishableKey = Leeap.STRIPE_TEST
                    }
                    
                    // Stripe payment configuration
                    STPPaymentConfiguration.shared().requiredBillingAddressFields = STPBillingAddressFields.name
         
                    STPPaymentConfiguration.shared().companyName = "NUIT DE L'ENIB (VIA LEEAP CASH)"
                    STPPaymentConfiguration.shared().accessibilityLanguage = "FR"
                    
                    if !self.appleMerchantIdentifier.isEmpty {
                        STPPaymentConfiguration.shared().appleMerchantIdentifier = self.appleMerchantIdentifier
                    }
                    
                    // Stripe theme configuration
                    STPTheme.default().primaryBackgroundColor = .riderVeryLightGrayColor
                    STPTheme.default().primaryForegroundColor = .riderDarkBlueColor
                    STPTheme.default().secondaryForegroundColor = .riderDarkGrayColor
                    STPTheme.default().accentColor = .riderGreenColor
                    
                    
                    // Main API client configuration
                    MainAPIClient.shared.baseURLString = Leeap.URL//baseURLString
                    
                    print(Leeap.URL)
                    
                case .failure(let error):
                    Leeap.prod=false
                }
                    
        }
    
    }

    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UIApplication.shared.statusBarStyle = .lightContent
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        if #available(iOS 10.0, *) {
            self.saveContext()
        } else {
            // Fallback on earlier versions
        }
    }

    // MARK: - Core Data stack

    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Leeap")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    @available(iOS 10.0, *)
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

