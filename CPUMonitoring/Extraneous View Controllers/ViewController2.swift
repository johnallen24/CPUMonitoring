
//  ViewController2.swift
//  CPUMonitoring
//
//  Created by John Allen on 6/14/18.
//  Copyright © 2018 jallen.studios. All rights reserved.


import UIKit

class ViewController2: UIViewController, CPUInfoControllerDelegate {
    
    var label: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.boldSystemFont(ofSize: 20)
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    
    
    func cpuLoadUpdated(_ loadArray: [Any]!) {
       var avr: Double = 0
        print("")
        for load in loadArray {
            if let cpuLoad = load as? CPULoad {
                avr += cpuLoad.total
            }
        }
      
       avr /= Double(loadArray.count)
       //label.text = "\(avr)%"
        print("CPU: \(avr)%")
    }
    

    var cpuInfoCtrl: CPUInfoController?
    var backgroundTest: BackgroundTask?
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //********AppDelegate.viewController = self 
        cpuInfoCtrl = CPUInfoController()
        cpuInfoCtrl?.startCPULoadUpdates(withFrequency: 2)
        cpuInfoCtrl?.delegate = self
        //print(cpuInfoCtrl)
        setupViews()
        backgroundTest = BackgroundTask()
        backgroundTest?.startBackgroundTask()
        
    }

    func setupViews() {
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.heightAnchor.constraint(equalToConstant: 200),
            label.widthAnchor.constraint(equalToConstant: 200)
            ])
    }
}
