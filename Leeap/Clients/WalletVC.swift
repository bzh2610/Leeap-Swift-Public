//
//  RideRequestViewController.swift
//  RocketRides
//
//  Created by Romain Huet on 5/26/16.
//  Copyright © 2016 Romain Huet. All rights reserved.
//

import UIKit
import Stripe
import Alamofire


class RideRequestViewController: UIViewController, STPPaymentContextDelegate {
    
   
    @IBOutlet weak var balanceLabel: UILabel!
    // Controllers
    
    private let customerContext: STPCustomerContext
    private let paymentContext: STPPaymentContext
    

    
    private enum RideRequestState {
        case none
        case requesting
        case active(Ride)
    }
    private var rideRequestState: RideRequestState = .none {
        didSet {
            reloadRequestRideButton()
        }
    }
    
    private var price = 0 {
        didSet {
            // Forward value to payment context
            paymentContext.paymentAmount = price
        }
    }
    
    // Views
    
    //@IBOutlet var mapView: MKMapView!
    
    @IBOutlet var inputContainerView: UIView!
    //@IBOutlet var destinationButton: UIButton!
    @IBOutlet var paymentButton: UIButton!
    @IBOutlet var priceButton: UIButton!
    @IBOutlet var rideDetailsView: UIView!
    @IBOutlet var pilotView: UIView!
    @IBOutlet var pilotViewNameLabel: UILabel!
    @IBOutlet var vehicleView: UIView!
    @IBOutlet var vehicleViewModelLabel: UILabel!
    @IBOutlet var vehicleViewLicenseLabel: UILabel!
    @IBOutlet var requestRideButton: UIButton!

    
    required init?(coder aDecoder: NSCoder) {
        customerContext = STPCustomerContext(keyProvider: MainAPIClient.shared)
        paymentContext = STPPaymentContext(customerContext: customerContext)
        
        super.init(coder: aDecoder)
        paymentContext.paymentCurrency="EUR"
        paymentContext.paymentCountry="FR"
        paymentContext.delegate = self
        paymentContext.hostViewController = self
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let priceFormatter = NumberFormatter()
        priceFormatter.numberStyle = .currency
        priceFormatter.locale = Locale(identifier: "fr_FR")
        
        let priceString = priceFormatter.string(for: Double(price) / 100.00) ?? "ERROR"
        priceButton.setTitle(priceString, for: .normal)
        priceButton.setTitleColor(.riderDarkBlueColor, for: .normal)
        
        // Apply corner radius and shadow styling to floating views
        let cornerRadius: CGFloat = 5.0
        
        inputContainerView.layoutCornerRadiusAndShadow(cornerRadius: cornerRadius)
        paymentButton.layoutCornerRadiusMask(corners: [.topLeft, .bottomLeft], cornerRadius: cornerRadius)
        priceButton.layoutCornerRadiusMask(corners: [.topRight, .bottomRight], cornerRadius: cornerRadius)
        
        rideDetailsView.layoutCornerRadiusAndShadow(cornerRadius: cornerRadius)
        pilotView.layoutCornerRadiusMask(corners: [.topLeft, .bottomLeft], cornerRadius: cornerRadius)
        vehicleView.layoutCornerRadiusMask(corners: [.topRight, .bottomRight], cornerRadius: cornerRadius)
    }
    
    
    
    override func viewDidLoad() {
         self.balanceLabel.text=""
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
        NotificationCenter.default.addObserver(self, selector: #selector(self.amountChanged(_:)), name: NSNotification.Name(rawValue: "rechargeAmountChanged"), object: nil)
        
        Alamofire.request(Leeap.URL,
                          method: .post,
                          parameters: [ "profile":[ "getLogedUserProfile" : true, "token": UserData.token ] ]
            ).responseJSON{
                response in
                
                switch response.result{
                case .success(let JSON):
                    print("Success with JSON: \(JSON)")
                    let response = JSON as! NSDictionary
                    let success = response.object(forKey: "success") as! Bool
                    if(success){
                        UserData.administrator = (response.object(forKey: "Administrator") as? NSString)?.boolValue ?? false
                        var balance = (response.object(forKey: "Balance") as? NSString)?.doubleValue ?? 0.00
                        balance = balance/100
                        UserData.balance = balance
                        
                        self.balanceLabel.text = balance.formattedWithSeparator
                    }
                case .failure(let error):
                    print("Kinda stuck")
                }
        }
    }
    
    

    
    @IBAction
    private func handlePaymentButtonTapped() {
        presentPaymentMethodsViewController()
    }
    
    
    @IBAction
    private func handlePriceButtonTapped() {
        self.show_recharge()
    }
    
    func show_recharge(){
        let storyboard = UIStoryboard.init(name: "User", bundle: nil)
        let walletVC = storyboard.instantiateViewController(withIdentifier: "RechargeAmountVC") as? RechargeAmountVC ;
        self.present(walletVC!, animated: true, completion: {})
    }
    
    @IBAction
    private func handleRequestRideButtonTapped() {
        switch rideRequestState {
        case .none:
            if(price > 0){
            let alert = UIAlertController(title: "Confirmer", message: "Confirmez votre rechargement de "+(Double(price)/100.00).formattedWithSeparator /*(self.priceButton.titleLabel?.text)!*/, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Oui", style: .default, handler: { action in
                    self.rideRequestState = .requesting
                    self.paymentContext.requestPayment()
                }))
                
                alert.addAction(UIAlertAction(title: "Annuler", style: .default, handler: { action in
                    alert.dismiss(animated: true, completion: nil)
                }))
                 self.present(alert, animated: true)
            }else{
                   self.show_recharge()
            }
            
            
            
           
            // Update to requesting state
            
        case .requesting:
            // Do nothing
            break
        case .active:
            // Complete the ride
            completeActiveRide()
        }
    }
    
    // MARK: Helpers
    
    private func presentPaymentMethodsViewController(retry: Bool = false) {
        guard !STPPaymentConfiguration.shared().publishableKey.isEmpty else {
            // Present error immediately because publishable key needs to be set
            //Try once to set then cancels
            if(retry==false){
            Authentication().setEnvironment()
            presentPaymentMethodsViewController(retry: true)
            }else{
            let message = "Please assign a value to `publishableKey` before continuing. See `AppDelegate.swift`."
            present(UIAlertController(message: message), animated: true)
            }
            return
        }
        
        guard !MainAPIClient.shared.baseURLString.isEmpty else {
            // Present error immediately because base url needs to be set
            //Try once to set then cancels
            if(retry==false){
            MainAPIClient.shared.baseURLString = Leeap.URL
            presentPaymentMethodsViewController(retry: true)
            }else{
            let message = "Please assign a value to `MainAPIClient.shared.baseURLString` before continuing. See `AppDelegate.swift`."
            present(UIAlertController(message: message), animated: true)
            }
            return
        }
        
        // Present the Stripe payment methods view controller to enter payment details
        paymentContext.presentPaymentMethodsViewController()
    }
    
  
    
    private func reloadPaymentButtonContent() {
        guard let selectedPaymentMethod = paymentContext.selectedPaymentMethod else {
            // Show default image, text, and color
           // paymentButton.setImage(#imageLiteral(resourceName: "Payment"), for: .normal)
            paymentButton.setTitle("Payment", for: .normal)
            paymentButton.setTitleColor(.riderGrayColor, for: .normal)
            // Show selected payment method image, label, and darker color
        
            paymentButton.setTitleColor(.riderDarkBlueColor, for: .normal)
            return
        }
        
       
            paymentButton.setTitle(selectedPaymentMethod.label, for: .normal)
            paymentButton.setImage(selectedPaymentMethod.image, for: .normal)
            
        
        
       
    }
    
    private func reloadPriceButtonContent() {
      
        
        let priceFormatter = NumberFormatter()
        priceFormatter.numberStyle = .currency
        priceFormatter.locale = Locale(identifier: "fr_FR")
        
        let priceString = priceFormatter.string(for: price / 100) ?? "ERROR"
        priceButton.setTitle(priceString, for: .normal)
        priceButton.setTitleColor(.riderDarkBlueColor, for: .normal)
    }
    
    private func reloadRequestRideButton() {
        guard /*pickupPlacemark != nil &&*//* destinationPlacemark != nil &&*/ paymentContext.selectedPaymentMethod != nil else {
            // Show disabled state
            //requestRideButton.backgroundColor = .riderGreenColor
            //requestRideButton.setTitle("Recharger mon compte", for: .normal)
            //requestRideButton.setTitleColor(.white, for: .normal)
            //requestRideButton.setImage(#imageLiteral(resourceName: "Arrow"), for: .normal)
            requestRideButton.isEnabled = true
            return
        }
        
        switch rideRequestState {
        case .none:
            // Show enabled state
           // requestRideButton.backgroundColor = .riderGreenColor
           // requestRideButton.setTitle("Recharger", for: .normal)
           // requestRideButton.setTitleColor(.white, for: .normal)
          //  requestRideButton.setImage(#imageLiteral(resourceName: "Arrow"), for: .normal)
            requestRideButton.isEnabled = true
        case .requesting:
            // Show loading state
           // requestRideButton.backgroundColor = .riderGrayColor
          //  requestRideButton.setTitle("···", for: .normal)
          //  requestRideButton.setTitleColor(.white, for: .normal)
          //  requestRideButton.setImage(nil, for: .normal)
            requestRideButton.isEnabled = false
        case .active:
            // Show completion state
           /* requestRideButton.backgroundColor = .white
            requestRideButton.setTitle("Ok !", for: .normal)
            requestRideButton.setTitleColor(.riderDarkBlueColor, for: .normal)
            requestRideButton.setImage(nil, for: .normal)*/
            requestRideButton.isEnabled = true
        }
    }
    
    
    func paymentError(){
        let alert = UIAlertController(title: "Erreur", message: "Le débit de votre carte à échoué. Merci de réessayer. Si le problème persiste, contactez votre banque.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true)
    }
    
    private func animateActiveRide() {
        
        guard case let .active(ride) = rideRequestState else {
            // Missing active ride
            return
        }
        
        // Update ride information in ride details view
        pilotViewNameLabel.text = ride.pilotName
        vehicleViewModelLabel.text = ride.pilotVehicle
        vehicleViewLicenseLabel.text = ride.pilotLicense
        
        // Show ride details view
        rideDetailsView.isHidden = false
        

    }
    
    private func completeActiveRide() {
        guard case .active = rideRequestState else {
            // Missing active ride
            return
        }
        
        // Reset to none state
        rideRequestState = .none
        // Hide ride details view
        rideDetailsView.isHidden = true
    }
    
    // MARK: STPPaymentContextDelegate
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        if let customerKeyError = error as? MainAPIClient.CustomerKeyError {
            switch customerKeyError {
            case .missingBaseURL:
                // Fail silently until base url string is set
                print("[ERROR]: Please assign a value to `MainAPIClient.shared.baseURLString` before continuing. See `AppDelegate.swift`.")
            case .invalidResponse:
                // Use customer key specific error message
                print("[ERROR]: Missing or malformed response when attempting to `MainAPIClient.shared.createCustomerKey`. Please check internet connection and backend response formatting.");
                
                present(UIAlertController(message: "Impossible de récupérer les informations client", retryHandler: { (action) in
                    // Retry payment context loading
                    paymentContext.retryLoading()
                }), animated: true)
                
            }
        }
        else {
            // Use generic error message
            print("[ERROR]: Unrecognized error while loading payment context: \(error)");
            
            present(UIAlertController(message: "Impossible de récupérer les informations de paiement", retryHandler: { (action) in
                // Retry payment context loading
                paymentContext.retryLoading()
            }), animated: true)
        }
    }
    
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        // Reload related components
        reloadPaymentButtonContent()
        reloadRequestRideButton()
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPErrorBlock) {
        // Create charge using payment result
        let source = paymentResult.source.stripeID
        print(paymentResult)
        
        MainAPIClient.shared.requestRide(source: source, amount: price, currency: "eur", token: UserData.token) { [weak self] (ride, error) in
            guard let strongSelf = self else {
                // View controller was deallocated
                return
            }
            
            guard error == nil else {
                // Error while requesting ride
                completion(error)
                return
            }
            
            // Save ride info to display after payment finished
            strongSelf.rideRequestState = .active(ride!)
            completion(nil)
        }
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        switch status {
        case .success:
            // Animate active ride
             NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadUserHistory"), object: nil)
            viewDidAppear(false)
            animateActiveRide()
        case .error:
            // Present error to user
            if let requestRideError = error as? MainAPIClient.RequestRideError {
                switch requestRideError {
                case .missingBaseURL:
                    // Fail silently until base url string is set
                    print("[ERROR]: Please assign a value to `MainAPIClient.shared.baseURLString` before continuing. See `AppDelegate.swift`.")
                case .invalidResponse:
                    // Missing response from backend
                    print("[ERROR]: Missing or malformed response when attempting to `MainAPIClient.shared.requestRide`. Please check internet connection and backend response formatting.");
                    present(UIAlertController(message: "Le débit de votre carte à échoué. Si le problème persiste, contactez votre banque."), animated: true)
                    
                 case .denied:
                     present(UIAlertController(message: "Le débit de votre carte à échoué. Si le problème persiste, contactez votre banque."), animated: true)
                }
            }
            else {
                // Use generic error message
                print("[ERROR]: Unrecognized error while finishing payment: \(String(describing: error))");
                present(UIAlertController(message: "Impossible de recharger votre compte."), animated: true)
            }
            
            // Reset ride request state
            rideRequestState = .none
        case .userCancellation:
            // Reset ride request state
            rideRequestState = .none
        }
    }
    
  
    @objc func amountChanged(_ notification: NSNotification){
            
            if let dict = notification.userInfo as Dictionary? {
                if let item = dict["amount"] as! Double? {
                    price = Int(item*100)
                    print(price)
                    paymentContext.paymentAmount = price
                    
                    let priceFormatter = NumberFormatter()
                    priceFormatter.numberStyle = .currency
                    priceFormatter.locale = Locale(identifier: "fr_FR")
                    
                    let priceString = priceFormatter.string(for: Double(price) / 100.00) ?? "ERROR"
                    priceButton.setTitle(priceString, for: .normal)
                    priceButton.setTitleColor(.riderDarkBlueColor, for: .normal)
                }
            }
    }
}
