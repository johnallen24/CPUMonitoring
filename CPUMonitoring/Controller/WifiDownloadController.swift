//
//  WifiDownloadController.swift
//  CPUMonitoring
//
//  Created by John Allen on 6/21/18.
//  Copyright © 2018 jallen.studios. All rights reserved.
//

import UIKit
import TrafficPolice

class WifiDownloadController: UIViewController, UIGestureRecognizerDelegate, TrafficManagerDelegate {
   
   
    

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    let graphView: GraphView = {
        let gv = GraphView()
        gv.translatesAutoresizingMaskIntoConstraints = false
        gv.titleLabel.text = "Wifi Download Data vs. Time"
        gv.yLabel.text = "Download Data (MB)"
        gv.xLabel.text = "Time (s)"
        gv.color = .pink
        gv.chtChart.leftAxis.axisMaximum = 20
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
    
    var currentWifiValue: Double?
    var wifiValues: [Double] = []
    var times: [Double] = []
    
    func getWifi() {
        if let wifiValue = currentWifiValue {
        wifiValues.append(Double(wifiValue))
        times.append(Double(wifiValues.count))
        }
    }
    
    var difference: Double = 0 
    
    func post(summary: TrafficSummary) {
        if let wifiValue = currentWifiValue {
            difference = abs(wifiValue - Double(summary.data.received) / 1000000.0)
            print(difference)
        }
        currentWifiValue = Double(summary.data.received) / 1000000.0
        //currentWifiValue = Double(DataUsage.getDataUsage().wifiReceived) / 1000000000.0
        
    }
    
    
    @objc func refreshGraph() {
        if wifiValues.count != 0 {
            graphView.updateGraph(xValues: times, yValues: wifiValues)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TrafficManager.shared.delegate = self
        TrafficManager.shared.start()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(refreshGraph))
        tap.numberOfTapsRequired = 2
        tap.delegate = self
        tapView.addGestureRecognizer(tap)
        
        
        
        if let appdelegate = UIApplication.shared.delegate as? AppDelegate {
            appdelegate.wifiDownloadController = self
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

struct DataUsageInfo {
    var wifiReceived: UInt32 = 0
    var wifiSent: UInt32 = 0
    var wirelessWanDataReceived: UInt32 = 0
    var wirelessWanDataSent: UInt32 = 0
    
    mutating func updateInfoByAdding(info: DataUsageInfo) {
        wifiSent += info.wifiSent
        wifiReceived += info.wifiReceived
        wirelessWanDataSent += info.wirelessWanDataSent
        wirelessWanDataReceived += info.wirelessWanDataReceived
    }
}

class DataUsage {
    
    private static let wwanInterfacePrefix = "pdp_ip"
    private static let wifiInterfacePrefix = "en"
    
    class func getDataUsage() -> DataUsageInfo {
        var interfaceAddresses: UnsafeMutablePointer<ifaddrs>? = nil
        
        var dataUsageInfo = DataUsageInfo()
        
        guard getifaddrs(&interfaceAddresses) == 0 else { return dataUsageInfo }
        
        var pointer = interfaceAddresses
        while pointer != nil {
            guard let info = getDataUsageInfo(from: pointer!) else {
                pointer = pointer!.pointee.ifa_next
                continue
            }
            dataUsageInfo.updateInfoByAdding(info: info)
            pointer = pointer!.pointee.ifa_next
        }
        
        freeifaddrs(interfaceAddresses)
        
        return dataUsageInfo
    }
    
    private class func getDataUsageInfo(from infoPointer: UnsafeMutablePointer<ifaddrs>) -> DataUsageInfo? {
        let pointer = infoPointer
        
        let name: String! = String(cString: infoPointer.pointee.ifa_name)
        let addr = pointer.pointee.ifa_addr.pointee
        guard addr.sa_family == UInt8(AF_LINK) else { return nil }
        
        return dataUsageInfo(from: pointer, name: name)
    }
    
    private class func dataUsageInfo(from pointer: UnsafeMutablePointer<ifaddrs>, name: String) -> DataUsageInfo {
        var networkData: UnsafeMutablePointer<if_data>? = nil
        var dataUsageInfo = DataUsageInfo()
        
        if name.hasPrefix(wifiInterfacePrefix) {
            networkData = unsafeBitCast(pointer.pointee.ifa_data, to: UnsafeMutablePointer<if_data>.self)
            dataUsageInfo.wifiSent += networkData?.pointee.ifi_obytes ?? 0
            dataUsageInfo.wifiReceived += networkData?.pointee.ifi_ibytes ?? 0
        } else if name.hasPrefix(wwanInterfacePrefix) {
            networkData = unsafeBitCast(pointer.pointee.ifa_data, to: UnsafeMutablePointer<if_data>.self)
            dataUsageInfo.wirelessWanDataSent += networkData?.pointee.ifi_obytes ?? 0
            dataUsageInfo.wirelessWanDataReceived += networkData?.pointee.ifi_ibytes ?? 0
        }
        
        return dataUsageInfo
    }
}
