//
//  WifiController.swift
//  CPUMonitoring
//
//  Created by John Allen on 6/20/18.
//  Copyright © 2018 jallen.studios. All rights reserved.
//

import UIKit
import TrafficPolice
import Charts

class WifiController: UIViewController {

//    func post(summary: TrafficSummary) {
//        totalValues += 1
//        times.append(totalValues)
//        AppDelegate.wifiValues.append(Double(summary.data.received)/1000.0)
//        print(summary.description)
//    }
//
//
    
    var totalValues = 0.0
    
    
    
    
    
    
    //var wifiValues: [Double] = []
    //var times: [Double] = [] //holds time at every sensor value
    var sensorValues: [Double] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0] //holds all values from LoPy
    var totalXmoved = 0.0
    
    let chtChart: LineChartView = {
        let view = LineChartView()
        view.noDataText = "Connect to sensor"
        view.noDataFont = NSUIFont(name: "HelveticaNeue", size: 18.0)
        return view
    }()
    
    let topContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let refreshButton: UIButton = {
        let b = UIButton(type: .system)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.isUserInteractionEnabled = true
        b.setTitle("Update Graph", for: .normal)
        //b.backgroundColor = UIColor.blue
        b.addTarget(self, action: #selector(updateGraph), for: .touchUpInside)
        return b
    }()
    
    let titleLabel: UITextView = {
        let textView = UITextView()
        textView.text = "Voltage"
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .center
        textView.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 30)
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TrafficManager.shared.delegate = self
        //TrafficManager.shared.start()
        
        view.addSubview(chtChart)
        
        AppDelegate.WifiController = self
        //cpuInfoCtrl?.startCPULoadUpdates(withFrequency: 2)
        
        
        chtChart.legend.enabled = false
        view.addSubview(topContainer)
        topContainer.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 0).isActive = true
        topContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        topContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        topContainer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.12).isActive = true
        
        //topContainer.addSubview(titleLabel)
        
        //        titleLabel.topAnchor.constraint(equalTo: topContainer.topAnchor, constant: 0).isActive = true
        //        titleLabel.trailingAnchor.constraint(equalTo: topContainer.trailingAnchor, constant: 0).isActive = true
        //        titleLabel.leadingAnchor.constraint(equalTo: topContainer.leadingAnchor, constant: 0).isActive = true
        //        titleLabel.bottomAnchor.constraint(equalTo: topContainer.bottomAnchor, constant: 0).isActive = true
        
        view.addSubview(refreshButton)
        
        //refreshButton.frame = CGRect(x: 100, y: 200, width: 100, height: 100)
        NSLayoutConstraint.activate([
            refreshButton.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
            refreshButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05),
            refreshButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 6),
            refreshButton.widthAnchor.constraint(equalToConstant: 100)
            ])
        
        
        
        
        chtChart.chartDescription?.text = ""
        chtChart.translatesAutoresizingMaskIntoConstraints = false
        chtChart.topAnchor.constraint(equalTo: refreshButton.bottomAnchor, constant: 10).isActive = true
        chtChart.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        chtChart.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        chtChart.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: 0).isActive = true
        //        var timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        
        
        
        view.bringSubview(toFront: refreshButton)
        
        
    }
    
    
    
    @objc func update() {
        let number = arc4random_uniform(20)
        AppDelegate.times.append(Double(totalValues))
        totalValues = 1 + totalValues
        sensorValues.append(Double(number))
        updateGraph()
    }
    
    var firstTime = true
    
    
    @objc func updateGraph() {
        
        chtChart.notifyDataSetChanged()
        
        
        var lineChartEntry  = [ChartDataEntry]()
        
        for i in 0..<AppDelegate.times.count {
            
            let value = ChartDataEntry(x: AppDelegate.times[i], y: AppDelegate.wifiValues[i])
            
            lineChartEntry.append(value)
        }
        
        let chartDataSet = LineChartDataSet(values: lineChartEntry, label: "Voltage")
        let chartData = LineChartData()
        
        chartData.addDataSet(chartDataSet)
        chartData.setDrawValues(false)
        
        
        //3cc5ea
        //MARK: COLORS
        chartDataSet.fillAlpha = 1
        
        
        //BLue - Green
        let gradientColors = [colorWithHexString(hexString: "#3cc5ea").cgColor, colorWithHexString(hexString: "#4df7cf").cgColor] as CFArray
        chartDataSet.setCircleColor(colorWithHexString(hexString: "#3cc5ea"))
        chartDataSet.circleHoleColor = colorWithHexString(hexString: "#3cc5ea")
        chartDataSet.colors = [colorWithHexString(hexString: "#3cc5ea")]
        
        //#fb594a
        //Orange
        
        //        let gradientColors = [colorWithHexString(hexString: "#fd9d32").cgColor, colorWithHexString(hexString: "#fb594a").cgColor] as CFArray
        //        chartDataSet.setCircleColor(colorWithHexString(hexString: "#fd9d32"))
        //        chartDataSet.circleHoleColor = colorWithHexString(hexString: "#fd9d32")
        //        chartDataSet.colors = [colorWithHexString(hexString: "#fd9d32")]
        
        
        //Purple
        //        let gradientColors = [colorWithHexString(hexString: "#814ae9").cgColor, colorWithHexString(hexString: "#3a84f8").cgColor] as CFArray
        //        chartDataSet.setCircleColor(colorWithHexString(hexString: "#814ae9"))
        //        chartDataSet.circleHoleColor = colorWithHexString(hexString: "#814ae9")
        //        chartDataSet.colors = [colorWithHexString(hexString: "#814ae9")]
        
        
        
        
        let colorLocations: [CGFloat] = [1.0, 0.0]
        guard let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) else { print("gradient error"); return }
        chartDataSet.fill = Fill.fillWithLinearGradient(gradient, angle: 90.0)
        chartDataSet.drawFilledEnabled = true
        
        
        
        
        
        
        
        
        
        chartDataSet.circleRadius = 0
        //chartDataSet.circleHoleRadius = 3
        chartDataSet.drawCirclesEnabled = true
        chartDataSet.lineWidth = 2
        chartDataSet.mode = .horizontalBezier
        
        
        if(firstTime){
            chtChart.animate(xAxisDuration: 1, easingOption: .easeInCubic)
            firstTime = false
            chtChart.moveViewToAnimated(xValue: 16, yValue: 0, axis: YAxis.AxisDependency.left, duration: 1, easing: nil)
            
        }
        
        
        
        
        chtChart.leftAxis.axisMinimum = 0
        chtChart.xAxis.labelPosition = .bottom
        chtChart.xAxis.drawGridLinesEnabled = false
        chtChart.chartDescription?.enabled = true
        chtChart.legend.enabled = true
        chtChart.rightAxis.enabled = false
        chtChart.setVisibleXRange(minXRange: 0, maxXRange: 14)
        chtChart.leftAxis.labelFont = UIFont(name: "AppleSDGothicNeo-Medium", size: 16)!
        chtChart.xAxis.labelFont = UIFont(name: "AppleSDGothicNeo-Medium", size: 16)!
        chtChart.leftAxis.drawAxisLineEnabled = false
        
       
        chtChart.leftAxis.drawGridLinesEnabled = true
        chtChart.leftAxis.drawLabelsEnabled = true
        chtChart.leftAxis.gridColor = NSUIColor.gray.withAlphaComponent(0.4)
        chtChart.data = chartData
        
        chtChart.animate(xAxisDuration: 0.5, easingOption: .easeInOutCubic)
        chtChart.setVisibleXRangeMaximum(25)
        if (AppDelegate.times.count > 25)
        {
            //chtChart.moveViewToX(totalXmoved)
            chtChart.moveViewToAnimated(xValue: Double(AppDelegate.times.count), yValue: 0, axis: YAxis.AxisDependency.left, duration: 0.5, easing: nil)
            
            totalXmoved += 1.0
        }
        
        
    }
    
    func colorWithHexString(hexString: String, alpha:CGFloat? = 1.0) -> UIColor {
        
        // Convert hex string to an integer
        let hexint = Int(self.intFromHexString(hexStr: hexString))
        let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexint & 0xff) >> 0) / 255.0
        let alpha = alpha!
        
        // Create color object, specifying alpha as well
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }
    
    func intFromHexString(hexStr: String) -> UInt32 {
        var hexInt: UInt32 = 0
        // Create scanner
        let scanner: Scanner = Scanner(string: hexStr)
        // Tell scanner to skip the # character
        scanner.charactersToBeSkipped = NSCharacterSet(charactersIn: "#") as CharacterSet
        // Scan hex value
        scanner.scanHexInt32(&hexInt)
        return hexInt
    }
    
}
