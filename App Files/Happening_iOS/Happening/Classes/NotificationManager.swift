//
//  NotificationManager.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-01-21.
//

import SwiftUI
import UserNotifications
import CoreLocation

final class NotificationManager: ObservableObject {
    
    static let shared = NotificationManager()
    
    // MARK: requestAuthorization
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { success, error in
            if success {
                print("Push Notifications Status: ON")
            } else {
                print("Push Notifications Status: OFF")
            }
            
            if let error = error {
                print("Push Notifications Status: ERROR : \(error)")
            }
        }
    }
    
    // MARK: TIME
    func scheduleNotification(title: String, subTitle: String, interval: CGFloat, recurring: Bool) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subTitle
        content.sound = .default
        content.badge = 1
        
        // time
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: recurring)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    // MARK: CALENDER
    func scheduleNotification(title: String, subTitle: String, month: Int?, day:Int?, weekday: Int?, hour: Int, minute: Int, recurring: Bool) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subTitle
        content.sound = .default
        content.badge = 1
        
        // calender
        var dateComponents = DateComponents()
        if let month = month {
            dateComponents.month = month
        }
        if let day = day {
            dateComponents.day = day
        }
        dateComponents.hour = hour
        dateComponents.minute = minute
        if let weekday = weekday {
            dateComponents.weekday = weekday
        }
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: recurring)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    // MARK: CALENDER - Standard Date
    func scheduleNotification(title: String, subTitle: String, ssdt: String) {
        
        // sample ssdt: 2022-04-14 20:15
        
        let monthInteger: Int = Int((ssdt as NSString).substring(with: NSMakeRange(5, 2)))!
        let dayInteger: Int = Int((ssdt as NSString).substring(with: NSMakeRange(8, 2)))!
        let hourInteger: Int = Int((ssdt as NSString).substring(with: NSMakeRange(11, 2)))!
        let minutesInteger: Int = Int((ssdt as NSString).substring(with: NSMakeRange(14, 2)))!
        
        // notify when the happening day starts
        let content1 = UNMutableNotificationContent()
        content1.title = title
        content1.subtitle = subTitle
        content1.sound = .default
        content1.badge = 1
        
        var dateComponents1 = DateComponents()
        dateComponents1.month = monthInteger
        dateComponents1.day = dayInteger
        dateComponents1.hour = 0
        dateComponents1.minute = 0
        
        let trigger1 = UNCalendarNotificationTrigger(dateMatching: dateComponents1, repeats: false)
        let request1 = UNNotificationRequest(identifier: UUID().uuidString, content: content1, trigger: trigger1)
        UNUserNotificationCenter.current().add(request1)
        
        
        // notify 5 minutes before the happening starting time
        let content2 = UNMutableNotificationContent()
        content2.title = subTitle
        content2.subtitle = "will start in 5 minutes"
        content2.sound = .default
        content2.badge = 1
        
        var dateComponents2 = DateComponents()
        dateComponents2.month = monthInteger
        dateComponents2.day = dayInteger
        dateComponents2.hour = hourInteger
        dateComponents2.minute = minutesInteger - 5
        
        let trigger2 = UNCalendarNotificationTrigger(dateMatching: dateComponents2, repeats: false)
        let request2 = UNNotificationRequest(identifier: UUID().uuidString, content: content2, trigger: trigger2)
        UNUserNotificationCenter.current().add(request2)
    }
    
    // MARK: cancelNotifications
    func cancelDeliveredNotifications() {
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    // MARK: cancelPendingNotifications
    func cancelPendingNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
