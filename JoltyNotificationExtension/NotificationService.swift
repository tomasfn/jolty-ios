//
//  NotificationService.swift
//  JoltyNotificationExtension
//
//  Created by Tomás Fernandez Nuñez on 15/06/2019.
//  Copyright © 2019 Tomás Fernandez Nuñez. All rights reserved.
//

import UserNotifications
import NotificationCenter
import UserNotificationsUI

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
                
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        
        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
            bestAttemptContent.title = "\(bestAttemptContent.title) [modified]"
            
            contentHandler(bestAttemptContent)
        }
    }
    
    func didReceive(_ notification: UNNotification) {
        let message = notification.request.content.body
        let userInfo = notification.request.content.userInfo
        // populate data from received Push Notification in your widget UI...
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}
