//
//  Extensions.swift
//  Leeap
//
//  Created by Evan OLLIVIER on 12/03/2019.
//  Copyright © 2019 Evan OLLIVIER. All rights reserved.
//

import Foundation
import UIKit


struct Ride {
    
    let pilotName: String
    
    let pilotVehicle: String
    
    let pilotLicense: String
    
}


extension UIView {
    
    // Apply clipping mask on certain corners with corner radius
    func layoutCornerRadiusMask(corners: UIRectCorner, cornerRadius: CGFloat) {
        let cornerRadii = CGSize(width: cornerRadius, height: cornerRadius)
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: cornerRadii)
        
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        
        layer.mask = mask
    }
    
    // Apply corner radius and rounded shadow path
    func layoutCornerRadiusAndShadow(cornerRadius: CGFloat) {
        // Apply corner radius for background fill only
        layer.cornerRadius = cornerRadius
        
        // Apply shadow with rounded path
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.15
        layer.shadowRadius = 2.0
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
    }
    
}


extension UIColor {
    
    // Blue
    
    static let riderDarkBlueColor = UIColor(red: 50.0 / 255.0, green: 49.0 / 255.0, blue: 94.0 / 255.0, alpha: 1.0)         // #32315E
    
    static let riderBlueColor = UIColor(red: 0.0 / 255.0, green: 144.0 / 255.0, blue: 250.0 / 255.0, alpha: 1.0)            // #0090FA
    
    // Gray
    
    static let riderDarkGrayColor = UIColor(red: 135.0 / 255.0, green: 152.0 / 255.0, blue: 171.0 / 255.0, alpha: 1.0)      // #8798AB
    
    static let riderGrayColor = UIColor(red: 170.0 / 255.0, green: 183.0 / 255.0, blue: 197.0 / 255.0, alpha: 1.0)          // #AAB7C5
    
    static let riderLightGrayColor = UIColor(red: 233.0 / 255.0, green: 238.0 / 255.0, blue: 245.0 / 255.0, alpha: 1.0)     // #E9EEF5
    
    static let riderVeryLightGrayColor = UIColor(red: 246.0 / 255.0, green: 249.0 / 255.0, blue: 252.0 / 255.0, alpha: 1.0) // #F6F9FC
    
    // Green
    
    static let riderGreenColor = UIColor(red: 19.0 / 255.0, green: 181.0 / 255.0, blue: 125.0 / 255.0, alpha: 1.0)          // #13B57D
    
    static let riderLightGreenColor = UIColor(red: 173.0 / 255.0, green: 242.0 / 255.0, blue: 180.0 / 255.0, alpha: 1.0)    // #ADF2B4
    
}


extension UIAlertController {
    
    /// Initialize an alert view titled "Oops" with `message` and single "OK" action with no handler
    convenience init(message: String?) {
        self.init(title: "Oops", message: message, preferredStyle: .alert)
        
        let dismissAction = UIAlertAction(title: "OK", style: .default)
        addAction(dismissAction)
        
        preferredAction = dismissAction
    }
    
    /// Initialize an alert view titled "Oops" with `message` and "Retry" / "Skip" actions
    convenience init(message: String?, retryHandler: @escaping (UIAlertAction) -> Void) {
        self.init(title: "Oops", message: message, preferredStyle: .alert)
        
        let retryAction = UIAlertAction(title: "Retry", style: .default, handler: retryHandler)
        addAction(retryAction)
        
        let skipAction = UIAlertAction(title: "Skip", style: .default)
        addAction(skipAction)
        
        preferredAction = skipAction
    }
    
}


