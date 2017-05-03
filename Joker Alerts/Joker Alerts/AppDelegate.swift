//
//  AppDelegate.swift
//  Joker Alerts
//
//  Created by Jordan Little on 2/28/17.
//  Copyright © 2017 Washington State University. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UNUserNotificationCenter.current().delegate = self
        
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert, .badge, .sound])
        { (granted, error) in
            // Enable or disable features based on authorization.
            let vc = self.window?.rootViewController as! ViewController
            vc.notificationsOkay = granted
        }
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        checkIfNotificationsStillOkay()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        checkIfNotificationsStillOkay()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse, withCompletionHandler
        completionHandler: @escaping () -> Void) {
        // Do stuff with response here (non-blocking)
        let vc = self.window?.rootViewController as! ViewController
        vc.handleNotification(response)
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification, withCompletionHandler
        completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler([.alert]) // no options ([]) means no notification
    }
    
    func checkIfNotificationsStillOkay() {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings(completionHandler:
            self.handleNotificationSettings)
    }
    
    func handleNotificationSettings (notificationSettings:
        UNNotificationSettings) {
        let vc = self.window?.rootViewController as! ViewController
        
        if ((notificationSettings.alertSetting == .enabled) &&
            (notificationSettings.badgeSetting == .enabled) &&
            (notificationSettings.soundSetting == .enabled)) {
            vc.notificationsOkay = true
        } else {
            vc.notificationsOkay = false
        }
    }
}


