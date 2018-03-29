//
//  NotificationManager.swift
//  MyAlermApp
//
//  Created by Rajesh Karmaker on 29/3/18.
//  Copyright © 2018 Rajesh Karmaker. All rights reserved.
//

import UIKit
import UserNotifications
class NotificationManager: NSObject {
    static let shared = NotificationManager()
    private override init() {
        
    }
    func requestAuthorization() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
        }
    }
    func createNotification(withID ID:String,withTitle title:String,withBody body:String,OnDate triggerDate:Date,withInfo info:[AnyHashable : Any]?){
        
        let triggerWeekly = Calendar.current.dateComponents([.weekday,.hour,.minute], from: triggerDate)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerWeekly, repeats: true)
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default()
        if let userInfo = info{
            content.userInfo = userInfo
        }
        
        let request = UNNotificationRequest(identifier: ID, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) {(error) in
            if let error = error {
                print("Uh oh! We had an error: \(error)")
            }
            else{
                print("\(ID) notification created")
            }
        }
    }
}
extension NotificationManager:UNUserNotificationCenterDelegate{
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.sound])
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
    }
}
