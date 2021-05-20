//
//  AccessSuccessAssociation.swift
//  Leeap
//
//  Created by Evan OLLIVIER on 11/03/2019.
//  Copyright © 2019 Evan OLLIVIER. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func pop(numberOfTimes: Int) {
        guard let navigationController = navigationController else {
            return
        }
        let viewControllers = navigationController.viewControllers
        let index = numberOfTimes + 1
        if viewControllers.count >= index {
        navigationController.popToViewController(viewControllers[viewControllers.count - index], animated: true)
        }
    }
}


class AccessSuccessAssociation: UIViewController {
    @IBOutlet weak var amount: UILabel!
    var amount_text: String = ""
    
    override func viewDidLoad() {
        self.amount.text = self.amount_text
    }
    @IBAction func close(_ sender: Any) {
        
        //self.dismiss(animated: true, completion: {});
       // self.tabBarController?.tabBar.isHidden = false;
        
        self.presentingViewController?
            .presentingViewController?.dismiss(animated: true, completion: nil)
        
       
    }
}
