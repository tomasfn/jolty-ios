//
//  PushNotificationManager.swift
//  Jolty
//
//  Created by Tomás Fernandez Nuñez on 09/10/2018.
//  Copyright © 2018 Tomás Fernandez Nuñez. All rights reserved.
//

import UIKit
import Firebase


class FirebasePushNotificationsManager {
    
    class func currentToken() -> String {
        let token = Messaging.messaging().fcmToken
        return token!
    }
    
    class func sendCloudMessage(title: String, body: String, toToken: String, JoltyId: String, helpUserId: String, name: String) {
                
        let url = URL(string: SharedInfo.firebaseFcmSendUrl)!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let key = "key=" + SharedInfo.firebaseWebApiKey
        request.setValue(key, forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        
        let data = PushNotification.messageBody(toIdToken: toToken, title: title, body: body, withJoltyId: JoltyId, withHelpUserId: helpUserId, name: name)
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: data, options: [])
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
        }
        task.resume()
        
        
    }
}

class PushNotification {
    
    class func messageBody(toIdToken: String, title: String, body: String, withJoltyId: String, withHelpUserId: String, name: String) -> [String: Any] {
        
        let data: [String: Any] = [
            "to" : toIdToken,
            "collapse_key" : "type_a",
            "content_available": true,
            "notification": [
                "title" : title.localized(),
                "body"  : body.localized(),
                "click_action" : "needsHelpCategory"
            ],
            "data": [
                "title" : "Title of Your Notification in Title".localized(),
                "body"  : "Body of Your Notification in Data".localized(),
                "helpUserId" : withHelpUserId,
                "JoltyId" : withJoltyId,
                "fcmToken" : FirebasePushNotificationsManager.currentToken(),
                "name" : name,
                "type" : "help"
            ]
        ]
        
        
        return data
    }
}
