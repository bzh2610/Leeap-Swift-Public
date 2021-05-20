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








/*Chart 3*/
class AccessFirstChart: UIViewController{
    
    @IBOutlet weak var metric_name: UILabel!
    var entries: [Float] = []
    var keys: [String] = []
    var cumulated:[Float] = []
    
    func getDate(){
        
        Alamofire.request(Leeap.URL,
                          method: .post,
                          parameters: [
                            "ticket":[
                                "getAccessInfo": true,
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
                        self.keys.append(row["date"] as? String ?? "")
                        lastValue=lastValue + Float(row["volume"] as! String)!
                        self.cumulated.append(lastValue)
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
        self.metric_name.text = "Tickets scannés"
        
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
            .tooltipValueSuffix("")//the value suffix of the chart tooltip
            .categories(self.keys/*["Jan", "Feb", "Mar", "Apr", "May", "Jun",
                 "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]*/)
            .colorsTheme(["#FDBE75", "#CE7FEC"]) //e91e63 magenta
            .series([
                
                AASeriesElement()
                    .name("Total")
                    .data(self.cumulated)
                    .toDic()!,
                
                AASeriesElement()
                    .name("Tickets scannés")
                    .fillOpacity(0.5)
                    .data(self.entries)
                    .toDic()!,
                
                
                ])
        
        aaChartView.aa_drawChartWithChartModel(aaChartModel)
    }
}






/*Chart 3*/
class AccessSecondChart: UIViewController{
    
    @IBOutlet weak var metric_name: UILabel!
    var entries: [Float] = []
    var keys: [String] = []
    var cumulated:[Float] = []
    
    func getDate(){
        
        Alamofire.request(Leeap.URL,
                          method: .post,
                          parameters: [
                            "ticket":[
                                "getTicketsInfo": true,
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
                        self.cumulated.append(lastValue)
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
        self.metric_name.text = "Tickets vendus"
        
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
            .tooltipValueSuffix("")//the value suffix of the chart tooltip
            .categories(self.keys/*["Jan", "Feb", "Mar", "Apr", "May", "Jun",
                 "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]*/)
            .colorsTheme(["#e91e63", "#ff8c31"]) //e91e63 magenta
            .series([
                
                AASeriesElement()
                    .name("Total")
                    .data(self.cumulated)
                    .toDic()!,
                
                AASeriesElement()
                    .name("Tickets vendus")
                    .fillOpacity(0.5)
                    .data(self.entries)
                    .toDic()!,
                
                
                ])
        
        aaChartView.aa_drawChartWithChartModel(aaChartModel)
    }
}



/*Chart 3*/
class AccessThirdChart: UIViewController{
    
    @IBOutlet weak var metric_name: UILabel!
    var entries: [Float] = []
    var keys: [String] = []
    var cumulated:[Float] = []
    
    func getDate(){
        
        Alamofire.request(Leeap.URL,
                          method: .post,
                          parameters: [
                            "ticket":[
                                "getTicketsInfo": true,
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
                        self.cumulated.append(lastValue)
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
        self.metric_name.text = "Tickets vendus"
        
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
            .tooltipValueSuffix("")//the value suffix of the chart tooltip
            .categories(self.keys/*["Jan", "Feb", "Mar", "Apr", "May", "Jun",
                 "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]*/)
            .colorsTheme(["#FDBD69", "#FF4A90"]) //e91e63 magenta
            .series([
                
                AASeriesElement()
                    .name("Total")
                    .data(self.cumulated)
                    .toDic()!,
                
                AASeriesElement()
                    .name("Tickets vendus")
                    .fillOpacity(0.5)
                    .data(self.entries)
                    .toDic()!,
                
                
                ])
        
        aaChartView.aa_drawChartWithChartModel(aaChartModel)
    }
}
