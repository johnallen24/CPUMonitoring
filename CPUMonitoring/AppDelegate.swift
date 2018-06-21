//
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
class AppDelegate: UIResponder, UIApplicationDelegate, TrafficManagerDelegate {

    var window: UIWindow?
    static var viewController: ViewController3?
    static var WifiController: WifiController?
    static var wifiValues: [Double] = []
    
    var totalValues = 0.0
    static var times: [Double] = []
    
    func post(summary: TrafficSummary) {
        print("perfect")
        totalValues += 1
        AppDelegate.times.append(totalValues)
        AppDelegate.wifiValues.append(Double(summary.data.received)/1000.0)
        print(summary.description)
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
         registerForPushNotifications()
        return true
    }
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            print("Permission granted: \(granted)")
            
            guard granted else { return }
            self.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async(execute: {
                print("Hello")
                UIApplication.shared.registerForRemoteNotifications()
            })
            
            
        }
    }
    
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("hey")
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        
        let token = tokenParts.joined()
        print("Device Token: \(token)")
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    var handler: ((UIBackgroundFetchResult) -> Void)?
    
    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable : Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        TrafficManager.shared.delegate = self
        AppDelegate.viewController?.cpuInfoCtrl?.startCPULoadUpdates(withFrequency: 2)
        TrafficManager.shared.start()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { // change 2 to desired number of seconds
            AppDelegate.viewController?.cpuInfoCtrl?.stopCPULoadUpdates()
            TrafficManager.shared.cancel()
          completionHandler(.newData)
        }
       
    }
    
    
    @objc func getCPU() {
        print("john")
        handler!(.newData)
        
    }
    
    
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

