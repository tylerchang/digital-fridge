//  Created by Tyler  Chang on 2/11/24.
//
//  This class manages all functionalities related to notifications
//  It includes utility functions for converting the shelf life inputted from the USDA dataset into interpretable units
//  The main funcition is called whenever a new notification is needed and creates 3 notifications based on the given shelf life

import Foundation
import UserNotifications

class NotificationsController{
    
    // Schedules a notification for a food for 1 Week before shelf life, 3 days before shelf life, and day of shelf life
    func scheduleNotificationsForFood(productName: String, foodUUID: String, shelfLifeLength: String, shelfLifeMetric: String) async throws{
        
        let notificationCenter = UNUserNotificationCenter.current()

//      Production Code with actual times and conversions
        let shelfLifeInSeconds = (convertShelfLifeToMinutes(shelfLifeLength: shelfLifeLength, shelfLifeMetric: shelfLifeMetric)) * 60
        let weekBeforeInSeconds = shelfLifeInSeconds * 60
        let threeDaysBeforeInSeconds = shelfLifeInSeconds * 60
        
//      Testing code with notifications that go off in a few seconds so we can see if it is working
//        let shelfLifeInSeconds = 5.0
//        let weekBeforeInSeconds = 7.0
//        let threeDaysBeforeInSeconds = 10.0
        
        // Scheduling properties for  3 notifications
        
        let shelfLifeNotificationID = foodUUID
        let shelfLifeNotificationTitle = productName + " goes bad today!"
        let shelfLifeNotificationDescription = "Use today but at your own caution!"
        let shelfLifeNotification = scheduleOneNotification(timeInSeconds: shelfLifeInSeconds, identifier: shelfLifeNotificationID, title: shelfLifeNotificationTitle, description: shelfLifeNotificationDescription)
        
        let threeDaysBeforeNotificationID = foodUUID + "threeDaysBefore"
        let threeDaysBeforeNotificationTitle = "3 Day Reminder"
        let threeDaysBeforeNotificationDescription = productName + " will reach its shelf life in 3 days! Try to use it before it goes bad!"
        let threeDaysBeforeNotification = scheduleOneNotification(timeInSeconds: threeDaysBeforeInSeconds, identifier: threeDaysBeforeNotificationID, title: threeDaysBeforeNotificationTitle, description: threeDaysBeforeNotificationDescription)
        
        let weekBeforeNotificationID = foodUUID + "weekBefore"
        let weekBeforeNotificationTitle = "Weekly Reminder"
        let weekBeforeNotificationDescription = "Friendly reminder that " + productName + " will reach its shelf life in a week. Try to use it this week!"
        let weekBeforeNotification = scheduleOneNotification(timeInSeconds: weekBeforeInSeconds, identifier: weekBeforeNotificationID, title: weekBeforeNotificationTitle, description: weekBeforeNotificationDescription)
        
        // add a notification for when the shelf life is reached
        try await notificationCenter.add(shelfLifeNotification)
        
        // Only add notification for week before if the shelf life is greater than a week
        if weekBeforeInSeconds > 0{
            try await notificationCenter.add(weekBeforeNotification)
        }
        // Only add notification for 3 days before if the shelf life is greater than 3 days
        if threeDaysBeforeInSeconds > 0{
            try await notificationCenter.add(threeDaysBeforeNotification)
        }
    }
    
    // Helper function to schedule one notification
    func scheduleOneNotification(timeInSeconds: Double, identifier: String, title: String, description: String) -> UNNotificationRequest{
         
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = description
        
        // Real code
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInSeconds, repeats: false)
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        return request
    }
    
    //  Utility function to convert shelf life to minutes
    func convertShelfLifeToMinutes(shelfLifeLength: String, shelfLifeMetric: String) -> Double{
        
        if shelfLifeMetric == "Days"{
            return (shelfLifeLength as NSString).doubleValue * 1440
        }
        else if shelfLifeMetric == "Weeks" {
            return (shelfLifeLength as NSString).doubleValue * 10080
        }
        else if shelfLifeMetric == "Months" {
            return (shelfLifeLength as NSString).doubleValue * 43800
        }
        else{
            return (shelfLifeLength as NSString).doubleValue * 525600
        }
    }
}
