//
//  AccessHomeScreen.swift
//  Leeap
//
//  Created by Evan OLLIVIER on 23/02/2019.
//  Copyright © 2019 Evan OLLIVIER. All rights reserved.
//
import Foundation
import UIKit
import WebKit

class AccessHomeScreen: UIViewController {
    
    @IBAction func unwindToAccessHomeScreen(segue:UIStoryboardSegue) { }
   
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    
    
}


import AAInfographics
import QuartzCore


class DashFirstChart: UIViewController{
   
    override func viewDidLoad() {
        self.view.frame = self.view.bounds;
        self.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.layer.cornerRadius = 10;
        self.view.layer.masksToBounds = true;
        self.view.backgroundColor = UIColor.init(red: 70/255, green: 70/255, blue: 70/255, alpha: 1)
        //self.view.layer.backgroundColor = UIColor.init(red: 255, green: 255, blue: 255, alpha: 0.1).cgColor
        print(self.view.layer.frame.height)
        let chartViewWidth  = self.view.layer.bounds.width+10
        let chartViewHeight = CGFloat(160.00)//self.view.layer.bounds.height
        print(chartViewWidth)
        print("<== wide and high ==>")
        print(chartViewHeight)
        let aaChartView = AAChartView()
        aaChartView.frame = CGRect(x:-35,y:0,width:chartViewWidth,height:chartViewHeight+25)
        aaChartView.backgroundColor = UIColor.clear;
        aaChartView.isClearBackgroundColor = true;
        aaChartView.scrollEnabled=false;
    
        // set the content height of aachartView
        // aaChartView?.contentHeight = self.view.frame.size.height
        self.view.addSubview(aaChartView)
        
        
        let aaChartModel = AAChartModel()
            .chartType(.area)//Can be any of the chart types listed under `AAChartType`.
            .animationType(.bounce)
            .title("")//The chart title
            .subtitle("")//The chart subtitle
            .backgroundColor("#00000000")
            .dataLabelEnabled(false) //Enable or disable the data labels. Defaults to false
            .legendEnabled(false)
            .yAxisGridLineWidth(0)
            .xAxisGridLineWidth(0)
            .xAxisVisible(false)
            .symbol(.circle)
            .yAxisVisible(false)
            //.stacking(.normal)
            .axisColor("#FFF")
            .tooltipValueSuffix("€")//the value suffix of the chart tooltip
            .categories(["Jan", "Feb", "Mar", "Apr", "May", "Jun",
                         "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"])
            .colorsTheme(["#06caf4","#ffc069","#fe117c","#7dffc0"])
            .series([
                AASeriesElement()
                    .name("Volume")
                    
                    .fillOpacity(0.5)
                    .data([515.0, 299.0, 100.0, 285.0, 120.0, 381.0, 40.0, 265.0, 431.0, 117.0, 665.0, 505.0])
                    .toDic()!,

                ])
        
        aaChartView.aa_drawChartWithChartModel(aaChartModel)
    }
}

import WebKit

class DashboardHomeScreen: UIViewController {

    @IBOutlet weak var pagecontrol: UIPageControl!
    
    
    @objc func pageControlValueChange(_ notification: NSNotification) {
        
        if let dict = notification.userInfo as NSDictionary? {
            if let pageIndex = dict["index"] as? Int{
                pagecontrol.currentPage=pageIndex
                print("Dashboard page index:"+String(pageIndex))
    }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
         NotificationCenter.default.addObserver(self, selector: #selector(self.pageControlValueChange(_:)), name: NSNotification.Name(rawValue: "DashboardPageControlChange"), object: nil)
        
        
       /* let url = URL (string: "https://leeap.cash/charts?blue")
        let requestObj = URLRequest(url: url!)
        test.load(requestObj)
        test.isOpaque = false;
        test.backgroundColor = UIColor.clear;*/
        /*
        let url = URL (string: "https://leeap.cash/charts?blue")
        let requestObj = URLRequest(url: url!)
        wv2.load(requestObj)
        wv2.isOpaque = false;
        wv2.backgroundColor = UIColor.clear;
        
        wv3.load(requestObj)
        wv3.isOpaque = false;
        wv3.backgroundColor = UIColor.clear;*/
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    
    
}


