//
//  DashboardRecapVC.swift
//  Leeap
//
//  Created by Evan OLLIVIER on 11/03/2019.
//  Copyright © 2019 Evan OLLIVIER. All rights reserved.
//
import Foundation
import UIKit
import Alamofire

class DashboardRecapVC: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    
    var pages = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        
        let p1: DashboardRecap! = storyboard?.instantiateViewController(withIdentifier: "dashboardInsight") as? DashboardRecap
        let p2: DashboardRecap! = storyboard?.instantiateViewController(withIdentifier: "dashboardInsight") as? DashboardRecap
        let p3: DashboardRecap! = storyboard?.instantiateViewController(withIdentifier: "dashboardInsight") as? DashboardRecap
        
        
        // etc ...
        p1.date_text = "Aujourd'hui"
        p2.date_text = "Cette semaine"
        p3.date_text = "Ce mois"
        pages.append(p1)
        pages.append(p2)
        pages.append(p3)
        // etc ...
        
        setViewControllers([p1], direction: UIPageViewController.NavigationDirection.forward, animated: false, completion: nil)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController)-> UIViewController? {
        print("Event")
        let cur = pages.firstIndex(of: viewController)!
        
        let prev = abs((cur - 1) % pages.count)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DashboardPageControlChange"), object: nil, userInfo: ["index": prev])
        return pages[prev]
        
    }
    
   
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController)-> UIViewController? {
        print("Event")
        let cur = pages.firstIndex(of: viewController)!
        
        // if you prefer to NOT scroll circularly, simply add here:
        // if cur == (pages.count - 1) { return nil }
        
        let nxt = abs((cur + 1) % pages.count)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DashboardPageControlChange"), object: nil, userInfo: ["index": nxt])
        return pages[nxt]
    }
    
    func presentationIndex(for pageViewController: UIPageViewController)-> Int {
        return pages.count
    }
}
