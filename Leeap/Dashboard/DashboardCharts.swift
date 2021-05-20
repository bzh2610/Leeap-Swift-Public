//
//  AccessCharts.swift
//  Leeap
//
//  Created by Evan OLLIVIER on 10/03/2019.
//  Copyright © 2019 Evan OLLIVIER. All rights reserved.
//

import Foundation
import AAInfographics
import QuartzCore
import UIKit
import Alamofire

class DashboardFirstChart: UIViewController{
    
    @IBOutlet weak var metric_name: UILabel!
    var entries: [Float] = []
    var keys: [String] = []
    
    func getDate(){
        
        Alamofire.request(Leeap.URL,
                          method: .post,
                          parameters: [
                            "ticket":[
                                "getVolumeInfo": true,
                            ]
            ]
            ).responseJSON{
                response in
                
                switch response.result{
                case .success(let JSON):
                    print("Success with JSON: \(JSON)")
                    
                    let response = JSON as! NSDictionary
                    
                    let history = response.object(forKey: "data")!
                    print(history)
                   
                    for row in history as! [[String : AnyObject]]{
                        self.keys.append(row["date"] as! String)
                        self.entries.append(Float(row["volume"] as! String)!)
                    }
                   
                    self.makeGraph(keys: self.keys, entries: self.entries)
                case .failure(let error):
                    print(error)
                    
                }
        }


    }
    override func viewDidLoad() {
        self.getDate();
        print(self.keys)
        print(self.entries)
        self.metric_name.text = "Volume"
       
    }
    
    func makeGraph(keys: [String], entries: [Float]){
        self.view.frame = self.view.bounds;
        self.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.layer.cornerRadius = 10;
        self.view.layer.masksToBounds = true;
        self.view.backgroundColor = UIColor.init(red: 70/255, green: 70/255, blue: 70/255, alpha: 1)
        //self.view.layer.backgroundColor = UIColor.init(red: 255, green: 255, blue: 255, alpha: 0.1).cgColor
        print(self.view.layer.frame.height)
        let chartViewWidth  = self.view.layer.bounds.width+65
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
            //.markerRadius(5)
            
            .yAxisVisible(false)
            //.stacking(.normal)
            .axisColor("#FFF")
            .tooltipValueSuffix("€")//the value suffix of the chart tooltip
            .categories(self.keys/*["Jan", "Feb", "Mar", "Apr", "May", "Jun",
                 "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]*/)
            .colorsTheme(["#06caf4"])//"#c87df5", "#fe117c", "#ffc069", "#7dffc0"]
            .series([
                AASeriesElement()
                    .name("Volume")
                    
                    .fillOpacity(0.5)
                    .data(self.entries)
                    .toDic()!,

                ])
        
        aaChartView.aa_drawChartWithChartModel(aaChartModel)
    }
    
    
}
















class DashboardSecondChart: UIViewController{
    
    @IBOutlet weak var metric_name: UILabel!
    var entries: [Float] = []
    var keys: [String] = []
    // var cumulated : [Float] =
    func getDate(){
        
        Alamofire.request(Leeap.URL,
                          method: .post,
                          parameters: [
                            "ticket":[
                                "getVolumeInfo": true,
                            ]
            ]
            ).responseJSON{
                response in
                
                switch response.result{
                case .success(let JSON):
                    print("Success with JSON: \(JSON)")
                    
                    let response = JSON as! NSDictionary
                    
                    let history = response.object(forKey: "data")!
                    print(history)
                    var lastValue = Float(0.00)
                    for row in history as! [[String : AnyObject]]{
                        self.keys.append(row["date"] as! String)
                        lastValue=lastValue + Float(row["volume"] as! String)!
                        self.entries.append(lastValue)
                    }
                    
                    self.makeGraph(keys: self.keys, entries: self.entries)
                case .failure(let error):
                    print(error)
                    
                }
        }
        
        
    }
    override func viewDidLoad() {
        self.getDate();
        print(self.keys)
        print(self.entries)
        self.metric_name.text = "Volume cummulé"
        
    }
    
    func makeGraph(keys: [String], entries: [Float]){
        self.view.frame = self.view.bounds;
        self.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.layer.cornerRadius = 10;
        self.view.layer.masksToBounds = true;
        self.view.backgroundColor = UIColor.init(red: 70/255, green: 70/255, blue: 70/255, alpha: 1)
        //self.view.layer.backgroundColor = UIColor.init(red: 255, green: 255, blue: 255, alpha: 0.1).cgColor
        print(self.view.layer.frame.height)
        let chartViewWidth  = self.view.layer.bounds.width+65
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
            //.markerRadius(5)
            
            .yAxisVisible(false)
            //.stacking(.normal)
            .axisColor("#FFF")
            .tooltipValueSuffix("€")//the value suffix of the chart tooltip
            .categories(self.keys/*["Jan", "Feb", "Mar", "Apr", "May", "Jun",
                 "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]*/)
            .colorsTheme(["#7dffc0"])
            .series([
                AASeriesElement()
                    .name("Volume total")
                    
                    .fillOpacity(0.5)
                    .data(self.entries/*[515.0, 299.0, 100.0, 285.0, 120.0, 381.0, 40.0, 265.0, 431.0, 117.0, 665.0, 505.0]*/)
                    .toDic()!,
                
                /*AASeriesElement()
                 .name("New York")
                 
                 .data([0.2, 0.8, 5.7, 11.3, 17.0, 22.0, 24.8, 24.1, 20.1, 14.1, 8.6, 2.5])
                 .toDic()!,*/
                ])
        
        aaChartView.aa_drawChartWithChartModel(aaChartModel)
    }
}

