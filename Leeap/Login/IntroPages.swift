//
//  IntroPages.swift
//  Leeap
//
//  Created by Evan OLLIVIER on 27/02/2019.
//  Copyright © 2019 Evan OLLIVIER. All rights reserved.
//

import Foundation
import UIKit


class IntroPages: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var pages = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        
        let p1: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "welcome1")
        let p2: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "welcome2")
        let p3: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "welcome3")
        let p4: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "welcome4")

        
        // etc ...
        
        pages.append(p1)
        pages.append(p2)
        pages.append(p3)
        pages.append(p4)
       
        
        // etc ...
        
        setViewControllers([p1], direction: UIPageViewController.NavigationDirection.forward, animated: false, completion: nil)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController)-> UIViewController? {
        
        let cur = pages.firstIndex(of: viewController)!
        
        // if you prefer to NOT scroll circularly, simply add here:
        // if cur == 0 { return nil }
        
        let prev = abs((cur - 1) % pages.count)
        return pages[prev]
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController)-> UIViewController? {
        
        let cur = pages.firstIndex(of: viewController)!
        
        // if you prefer to NOT scroll circularly, simply add here:
        // if cur == (pages.count - 1) { return nil }
        
        let nxt = abs((cur + 1) % pages.count)
        return pages[nxt]
    }
    
    func presentationIndex(for pageViewController: UIPageViewController)-> Int {
        return pages.count
    }
    
}
