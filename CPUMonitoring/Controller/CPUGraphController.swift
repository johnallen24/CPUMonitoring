//
//  CPUGraphController.swift
//  CPUMonitoring
//
//  Created by John Allen on 6/21/18.
//  Copyright © 2018 jallen.studios. All rights reserved.
//

import UIKit

class CPUGraphController: UIViewController, CPUInfoControllerDelegate, UIGestureRecognizerDelegate {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var cpuInfoCtrl: CPUInfoController?
    
    let graphView: GraphView = {
        let gv = GraphView()
        gv.translatesAutoresizingMaskIntoConstraints = false
        gv.titleLabel.text = "CPU Usage vs. Time"
        gv.yLabel.text = "CPU Usage (%)"
        gv.xLabel.text = "Time (s)"
        gv.chtChart.leftAxis.axisMaximum = 100
        return gv
    }()
    
    let tapView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
//    let tap: UITapGestureRecognizer = {
//        let t = UITapGestureRecognizer(target: self, action: #selector(refreshGraph))
//        //t.numberOfTapsRequired = 2
//        return t
//    }()
    
    var currentCPU: Double?
    var cpuValues: [Double] = []
    var times: [Double] = []
    
    func getCPU() {
        if let cpu = currentCPU {
            cpuValues.append(cpu)
            times.append(Double(cpuValues.count))
        }
    }
    
    
    
    @objc func refreshGraph() {
        print("hello there")
        print(cpuValues)
        if cpuValues.count != 0 {
        graphView.updateGraph(xValues: times, yValues: cpuValues)
        }
    }
    
    func cpuLoadUpdated(_ loadArray: [Any]!) {
        var avr: Double = 0
        for load in loadArray {
            if let cpuLoad = load as? CPULoad {
                avr += cpuLoad.total
            }
        }
       avr /= Double(loadArray.count)
       currentCPU = avr
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("going")
        cpuInfoCtrl = CPUInfoController()
        cpuInfoCtrl?.delegate = self
        cpuInfoCtrl?.startCPULoadUpdates(withFrequency: 2)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(refreshGraph))
        tap.numberOfTapsRequired = 2
        tap.delegate = self
        tapView.addGestureRecognizer(tap)
        
        
        
        if let appdelegate = UIApplication.shared.delegate as? AppDelegate {
            appdelegate.cpuGraphController = self
        }
        

        
        setupViews()
    }
    
    func setupViews() {
        
        view.addSubview(graphView)
        NSLayoutConstraint.activate([
            graphView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            graphView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            graphView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            graphView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: 0)
            ])
        
        view.addSubview(tapView)
        NSLayoutConstraint.activate([
            tapView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            tapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tapView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2),
            tapView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2)
            ])
    }
    
}
