//
//  GraphView.swift
//  CPUMonitoring
//
//  Created by John Allen on 6/21/18.
//  Copyright © 2018 jallen.studios. All rights reserved.
//

import UIKit
import Charts

class GraphView: UIView {
    
    let chtChart: LineChartView = {
        let view = LineChartView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.noDataText = "No Data"
        view.noDataFont = NSUIFont(name: "HelveticaNeue", size: 18.0)
        return view
    }()
    
    let titleLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        //lb.backgroundColor = UIColor.blue
        lb.font = UIFont(name: "GillSans-SemiBold", size: 32)
         lb.textAlignment = .center
        return lb
    }() 
    

    let yLabel: UILabel = {
        let lb = UILabel()
        //lb.backgroundColor = UIColor.red
        lb.font = UIFont(name: "GillSans-SemiBold", size: 24)
        lb.textAlignment = .center
        
        return lb
    }()
    
    let xLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        //lb.backgroundColor = UIColor.green
        lb.textAlignment = .center
        lb.font = UIFont(name: "GillSans-SemiBold", size: 24)
        return lb
    }()
    
    let yLabelContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    enum graphColor {
        case blue
        case pink
    }
    
    var color: graphColor = .blue
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }

    func setupViews() {
        
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            titleLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.1)
            ])
        
        addSubview(yLabelContainer)
        //yLabelContainer.backgroundColor = UIColor.purple
        NSLayoutConstraint.activate([
            yLabelContainer.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0),
            yLabelContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            yLabelContainer.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.05),
            yLabelContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
            ])
        
        addSubview(yLabel)
        
        addSubview(xLabel)
        NSLayoutConstraint.activate([
            xLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            xLabel.leadingAnchor.constraint(equalTo: yLabelContainer.trailingAnchor, constant: 0),
            xLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            xLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.07)
            ])
        
        addSubview(chtChart)
        NSLayoutConstraint.activate([
            chtChart.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0),
            chtChart.leadingAnchor.constraint(equalTo: yLabel.trailingAnchor, constant: 0),
            chtChart.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            chtChart.bottomAnchor.constraint(equalTo: xLabel.topAnchor, constant: 0)
            ])
    }
    
    override func layoutSubviews() {
        
         yLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
          yLabel.frame = yLabelContainer.frame
        
        
    }


    
    @objc func updateGraph(xValues: [Double], yValues: [Double]) {
        
        chtChart.notifyDataSetChanged()
        
        var lineChartEntry  = [ChartDataEntry]()
        
        for i in 0..<xValues.count {
            let value = ChartDataEntry(x: xValues[i], y: yValues[i])
            lineChartEntry.append(value)
        }
        
        let chartDataSet = LineChartDataSet(values: lineChartEntry, label: nil)
       
        let chartData = LineChartData()
        
        chartData.addDataSet(chartDataSet)
        chartData.setDrawValues(false)
        
        
        //3cc5ea
        //MARK: COLORS
        chartDataSet.fillAlpha = 1
        
        
        //BLue - Green
//        let gradientColors = [colorWithHexString(hexString: "#3cc5ea").cgColor, colorWithHexString(hexString: "#4df7cf").cgColor] as CFArray
//        chartDataSet.setCircleColor(colorWithHexString(hexString: "#3cc5ea"))
//        chartDataSet.circleHoleColor = colorWithHexString(hexString: "#3cc5ea")
//        chartDataSet.colors = [colorWithHexString(hexString: "#3cc5ea")]
        var gradientColors: CFArray
        
        chartDataSet.colors = [colorWithHexString(hexString: "#3cc5ea")]
        if color == .blue {
             gradientColors = [colorWithHexString(hexString: "#3cc5ea").cgColor, colorWithHexString(hexString: "#4df7cf").cgColor] as CFArray
                    chartDataSet.setCircleColor(colorWithHexString(hexString: "#3cc5ea"))
                    chartDataSet.circleHoleColor = colorWithHexString(hexString: "#3cc5ea")
                    chartDataSet.colors = [colorWithHexString(hexString: "#3cc5ea")]
        }
        else {
            
            gradientColors = [colorWithHexString(hexString: "#fd9d32").cgColor, colorWithHexString(hexString: "#fb594a").cgColor] as CFArray
            chartDataSet.colors = [colorWithHexString(hexString: "#fd9d32")]
        }
       
        

        let colorLocations: [CGFloat] = [1.0, 0.0]
        guard let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) else { print("gradient error"); return }
        chartDataSet.fill = Fill.fillWithLinearGradient(gradient, angle: 90.0)
        chartDataSet.drawFilledEnabled = true
        
        

        chartDataSet.circleRadius = 0
        //chartDataSet.circleHoleRadius = 3
        chartDataSet.drawCirclesEnabled = true
        chartDataSet.lineWidth = 2
        chartDataSet.mode = .horizontalBezier
        
        chtChart.chartDescription?.text = ""
        chtChart.legend.enabled = false
        chtChart.leftAxis.axisMinimum = 0
        chtChart.xAxis.labelPosition = .bottom
        chtChart.xAxis.drawGridLinesEnabled = false
        chtChart.chartDescription?.enabled = true
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
        chtChart.setVisibleXRangeMaximum(60)
        if (xValues.count > 60)
        {
            chtChart.moveViewToAnimated(xValue: Double(xValues.count), yValue: 0, axis: YAxis.AxisDependency.left, duration: 0.5, easing: nil)
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
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
