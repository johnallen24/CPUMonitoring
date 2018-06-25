
//  AppDelegate.swift
//  CPUMonitoring
//
//  Created by John Allen on 6/13/18.
//  Copyright © 2018 jallen.studios. All rights reserved.
//

import UIKit
import UserNotifications
import TrafficPolice

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    static var viewController: ViewController3?
    static var WifiController: WifiController?
    static var wifiValues: [Double] = []
    
    var totalValues = 0.0
    static var times: [Double] = []
    
    var cpuGraphController: CPUGraphController?
    var wifiDownloadController: WifiDownloadController? {
        didSet {
            startTimer()
        }
    }
    
    var backgroundTest: BackgroundTask?
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
         //registerForPushNotifications()
        //startTimer()
        backgroundTest = BackgroundTask()
        backgroundTest?.startBackgroundTask()
        return true
    }
    
    var timer: Timer?
    var timerForWifiReset: Timer?
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(getValues), userInfo: nil, repeats: true)
        timerForWifiReset = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(resetWifi), userInfo: nil, repeats: true)
        
    }
    
    func stopTimer() {
       timer?.invalidate()
       timer = nil
        timerForWifiReset?.invalidate()
        timerForWifiReset = nil
    }
    
    @objc func resetWifi() {
        if let difference = wifiDownloadController?.difference {
            if difference < 0.00001 {
                TrafficManager.shared.reset()
            }
        }
    }
    
    @objc func getValues() {
        print("hello")
        cpuGraphController?.getCPU()
        wifiDownloadController?.getWifi()
    }
    
    
//    func registerForPushNotifications() {
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
//            (granted, error) in
//            print("Permission granted: \(granted)")
//
//            guard granted else { return }
//            self.getNotificationSettings()
//        }
//    }
//
//    func getNotificationSettings() {
//        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
//            print("Notification settings: \(settings)")
//            guard settings.authorizationStatus == .authorized else { return }
//            DispatchQueue.main.async(execute: {
//                print("Hello")
//                UIApplication.shared.registerForRemoteNotifications()
//            })
//
//
//        }
//    }
//
//
//    func application(_ application: UIApplication,
//                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        print("hey")
//        let tokenParts = deviceToken.map { data -> String in
//            return String(format: "%02.2hhx", data)
//        }
//
//        let token = tokenParts.joined()
//        print("Device Token: \(token)")
//    }
//
//    func application(_ application: UIApplication,
//                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
//        print("Failed to register: \(error)")
//    }
//
//    var handler: ((UIBackgroundFetchResult) -> Void)?
//
//    func application(
//        _ application: UIApplication,
//        didReceiveRemoteNotification userInfo: [AnyHashable : Any],
//        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//
//        TrafficManager.shared.delegate = self
//        AppDelegate.viewController?.cpuInfoCtrl?.startCPULoadUpdates(withFrequency: 2)
//        TrafficManager.shared.start()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { // change 2 to desired number of seconds
//            AppDelegate.viewController?.cpuInfoCtrl?.stopCPULoadUpdates()
//            TrafficManager.shared.cancel()
//          completionHandler(.newData)
//        }
//
//    }
//
//
//    @objc func getCPU() {
//        print("john")
//        handler!(.newData)
//
//    }
//
//
//
//
    func applicationWillResignActive(_ application: UIApplication) {
       
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
       cpuGraphController?.refreshGraph()
         wifiDownloadController?.refreshGraph()
        cpuGraphController?.graphView.yLabel.frame = (cpuGraphController?.graphView.yLabelContainer.frame)!
        wifiDownloadController?.graphView.yLabel.frame = (wifiDownloadController?.graphView.yLabelContainer.frame)!
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

