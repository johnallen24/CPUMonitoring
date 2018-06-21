//
//  ViewController.swift
//  CPUMonitoring
//
//  Created by John Allen on 6/13/18.
//  Copyright © 2018 jallen.studios. All rights reserved.
//

import UIKit
import CoreLocation
import TrafficPolice

class ViewController: UIViewController, CLLocationManagerDelegate, TrafficManagerDelegate {
    
    func post(summary: TrafficSummary) {
        summary.data.received
        print(summary.description)
        
    }
    
    
    
//    func post(summary: TrafficSummary) {
//        print(summary.description)
//    }
    

    var performanceView: GDPerformanceMonitor?
    var backgroundTest: BackgroundTask?
    var cpuValues: [Double] = []
    
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.requestAlwaysAuthorization()
        return manager
    }()
    
    var label: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.boldSystemFont(ofSize: 20)
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TrafficManager.shared.delegate = self
        TrafficManager.shared.start()
        GDPerformanceView.viewController = self
        GDPerformanceMonitor.sharedInstance.startMonitoring()
        self.performanceView = GDPerformanceMonitor.init()
        self.performanceView?.startMonitoring()
        performanceView?.hideMonitoring()
        setupViews()
       backgroundTest = BackgroundTask()
       //let timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runcode), userInfo: nil, repeats: true)
        backgroundTest?.startBackgroundTask()
        
    }
    
    

    
    @objc func runcode() {
        
        var cpu: Float? = nil
        let basicInfoCount = MemoryLayout<mach_task_basic_info_data_t>.size / MemoryLayout<natural_t>.size
        
        var kern: kern_return_t
        
        var threadList = UnsafeMutablePointer<thread_act_t>.allocate(capacity: 1)
        var threadCount = mach_msg_type_number_t(basicInfoCount)
        
        var threadInfo = thread_basic_info.init()
        var threadInfoCount: mach_msg_type_number_t
        
        var threadBasicInfo: thread_basic_info
        var threadStatistic: UInt32 = 0
        
        kern = withUnsafeMutablePointer(to: &threadList) {
            #if swift(>=3.1)
            return $0.withMemoryRebound(to: thread_act_array_t?.self, capacity: 1) {
                task_threads(mach_task_self_, $0, &threadCount)
            }
            #else
            return $0.withMemoryRebound(to: (thread_act_array_t?.self)!, capacity: 1) {
            task_threads(mach_task_self_, $0, &threadCount)
            }
            #endif
        }
        if kern != KERN_SUCCESS {
            cpu = -1
        }
        
        if threadCount > 0 {
            threadStatistic += threadCount
        }
        
        var totalUsageOfCPU: Float = 0.0
        
        for i in 0..<threadCount {
            threadInfoCount = mach_msg_type_number_t(THREAD_INFO_MAX)
            
            kern = withUnsafeMutablePointer(to: &threadInfo) {
                $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                    thread_info(threadList[Int(i)], thread_flavor_t(THREAD_BASIC_INFO), $0, &threadInfoCount)
                }
            }
            if kern != KERN_SUCCESS {
                cpu = -1
            }
            
            threadBasicInfo = threadInfo as thread_basic_info
            
            if threadBasicInfo.flags & TH_FLAGS_IDLE == 0 {
                totalUsageOfCPU = totalUsageOfCPU + Float(threadBasicInfo.cpu_usage) / Float(TH_USAGE_SCALE) * 100.0
            }
        }
        
        cpu = totalUsageOfCPU
        
        //Memory
        var taskInfo = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size)/4
        let result: kern_return_t = withUnsafeMutablePointer(to: &taskInfo) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_, task_flavor_t(MACH_TASK_BASIC_INFO), $0, &count)
            }
        }
        
        var used: UInt64 = 0
        if result == KERN_SUCCESS {
            used = UInt64(taskInfo.resident_size)
        }
        
        let total = ProcessInfo.processInfo.physicalMemory
      
        
        
        
        
       
        if let cpuValue = cpu {
            label.text = "CPU \(cpuValue)%"
            cpuValues.append(Double(cpuValue))
            print("CPU: \(cpuValue)%")

        }
        
         print("Used Memory: \(used/10000)")
         print("Total Memory: \(total/10000)")
            }
    
    func setupViews() {
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.heightAnchor.constraint(equalToConstant: 100),
            label.widthAnchor.constraint(equalToConstant: 100)
            ])
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("hello")
    }

}

