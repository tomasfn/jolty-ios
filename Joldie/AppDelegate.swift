//
//  AppDelegate.swift
//  Jolty
//
//  Created by Tomás Fernandez Nuñez on 5/22/18.
//  Copyright © 2018 Tomás Fernandez Nuñez. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import UserNotifications
import UserNotificationsUI
import NotificationCenter
import CoreLocation
import GeoFire
import FBSDKCoreKit
import GooglePlaces
import ZAlertView

enum Environment {
    case TEST, PROD
    
    var description: String {
        switch self {
        case .TEST: return "TEST"
        case .PROD: return "PRODUCTION"
        }
    }
    
    func debugLog() {
        debugPrint("--> Environment: \(description) <--")
    }
}

//
let environment: Environment = .PROD
//

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    
    var locationManager = CLLocationManager()
    
    var guestUserInfo: [AnyHashable: Any]!
    
    var geoFireRef: DatabaseReference?
    var geoFire: GeoFire?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        Messaging.messaging().delegate = self
        Messaging.messaging().isAutoInitEnabled = true
        
        GMSPlacesClient.provideAPIKey("AIzaSyCXMeP5u5iS7GKlI2q3BNV5wjRs487JstA")
        
        registerForPushNotifications()
        
        UIDevice.current.isBatteryMonitoringEnabled = true

        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // 1. Convert device token to string
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        
        Messaging.messaging().apnsToken = deviceToken as Data
        
        let token = tokenParts.joined()
        // 2. Print device token to use for PNs payloads
        print("Device Token: \(token)")
        
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
//        Messaging.messaging().connect { error in
//            print(error)
//        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // 1. Print out error if PNs registration not successful
        print("Failed to register for remote notifications with error: \(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        //        if let messageID = userInfo[gcmMessageIDKey] {
        //            print("Message ID: \(messageID)")
        //        }
        
        // Print full message.
        print(userInfo)
        
        guestUserInfo = userInfo
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
        
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        if response.actionIdentifier == "ReplyAction" {
            
            UserModel.isChargerSharer(newState: "false")
            
            // Reply text
            print(guestUserInfo)
            
            let name = UserModelShared.currentUserData(attribute: "name")!
            
            let helpUserId = guestUserInfo?["helpUserId"] as? String ?? ""
            let JoltyId = guestUserInfo?["JoltyId"] as? String ?? ""
            let fcmToken = guestUserInfo?["fcmToken"] as? String ?? ""
            
            if let textResponse =  response as? UNTextInputNotificationResponse {
                let sendText =  textResponse.userText
                print("Received text message: \(sendText)")
                
                let title = "\(name) " + "says: ".localized()
                
                FirebasePushNotificationsManager.sendCloudMessage(title: title, body: sendText, toToken: fcmToken, JoltyId: JoltyId, helpUserId: helpUserId, name: name)
            }
            
            if UserModelShared.currentGuestUserData(attribute: "name") == "" {
                Database.database().reference().child("Jolty").child(JoltyId).child("saviourUser").setValue(Auth.auth().currentUser?.uid)
                
                UserModel.guestInfo(forGuestID: helpUserId, completion: { (userModel) in
                    DispatchQueue.main.async(execute: {
                    })
                })
            }
            
            let state = UIApplication.shared.applicationState
            if state == .background {
                

            } else if state == .active {
                
            }
            
            if let wd = UIApplication.shared.delegate?.window {
                var vc = wd!.rootViewController
                if(vc is UINavigationController){
                    vc = (vc as! UINavigationController).visibleViewController
                    
                }
                
                if(vc is NewJoltyViewController){
                    //your code
                    
                }
            }
            
            
        } else if response.actionIdentifier == "cancelRequestedHelpIdentifier" {
            guestUserInfo = nil
            
            print("user cancelled the help")
        }
        
        completionHandler()
        
    }

    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        if Auth.auth().currentUser != nil {
            Database.database().reference().child("Users").child((Auth.auth().currentUser!.uid)).child("user_details").child("currentFcmToken").setValue("\(fcmToken)")
        }
        
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        let googleDidHandle = GIDSignIn.sharedInstance().handle(url,
                                                                sourceApplication: sourceApplication,
                                                                annotation: annotation)
        
        let facebookDidHandle = FBSDKApplicationDelegate.sharedInstance().application(
            application,
            open: url,
            sourceApplication: sourceApplication,
            annotation: annotation)
        
        return googleDidHandle || facebookDidHandle
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            
            ZAlertView(title: "Oops...", message: error.localizedDescription, closeButtonText: "Ok".localized()) { (alert) in
                alert.dismissAlertView()
            }.show()
            
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        UserModel.loginUserWithCredentials(credential: credential) { (success) in
            
            
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any])
        -> Bool {
            return GIDSignIn.sharedInstance().handle(url,
                                                     sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                     annotation: [:])
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
        if let location = LocationManager.sharedManager.lastLocation {
            createRegion(location: location)
        }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo
        
        // Print full message.
        print(userInfo)
        
        // Change this to your preferred presentation option
        completionHandler(UNNotificationPresentationOptions.alert)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        if let location = LocationManager.sharedManager.lastLocation {
            createRegion(location: location)
        }
    }
    
    func createRegion(location:CLLocation?) {
        
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            let coordinate = CLLocationCoordinate2DMake((location?.coordinate.latitude)!, (location?.coordinate.longitude)!)
            let regionRadius = 50.0
            
            let region = CLCircularRegion(center: CLLocationCoordinate2D(
                latitude: coordinate.latitude,
                longitude: coordinate.longitude),
                                          radius: regionRadius,
                                          identifier: "aabb")
            
            region.notifyOnExit = true
            region.notifyOnEntry = true
            
            //Send your fetched location to server
            
            //Stop your location manager for updating location and start regionMonitoring
            self.locationManager.stopUpdatingLocation()
            self.locationManager.startMonitoring(for: region)
        }
        else {
            print("System can't track regions")
        }
    }
    
    func registerForPushNotifications() {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            print("Permission granted: \(granted)")
            // 1. Check if permission granted
            guard granted else { return }
            
            // Define Actions
            
            let replyAction = UNTextInputNotificationAction(
                identifier: "ReplyAction",
                title: "Yes, reply to message".localized(),
                options: [.foreground], textInputButtonTitle: "Send".localized(),
                textInputPlaceholder: "Input text here".localized())
            
            
            let cancelRequestedHelp = UNNotificationAction(identifier: "cancelRequestedHelpIdentifier",
                                                           title: "I'm sorry, I can't help now".localized(),
                                                           options: [])
            
            // Add actions to Jolty creation
            let needsHelpCategory = UNNotificationCategory(identifier: "needsHelpCategory",
                                                           actions: [replyAction,  cancelRequestedHelp],
                                                           intentIdentifiers: [],
                                                           options: [])
            
            // Add category to notifications frameowork
            UNUserNotificationCenter.current().setNotificationCategories([needsHelpCategory])
            
            
            
            // 2. Attempt registration for remote notifications on the main thread
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
        
        UNUserNotificationCenter.current().delegate = self
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Entered Region")
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("Exited Region")
        
        locationManager.stopMonitoring(for: region)
        
        //Start location manager and fetch current location
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if UIApplication.shared.applicationState == .active {
        } else {
            
            if let user = Auth.auth().currentUser {
                geoFireRef = Database.database().reference().child("Geolocs")
                geoFire = GeoFire(firebaseRef: geoFireRef!)
                geoFire?.setLocation(locations.last!, forKey: user.uid)
            }
            //App is in BG/ Killed or suspended state
            //send location to server
            // create a New Region with current fetched location
            if let location = locations.last {
                self.createRegion(location: location)
            }
            
            //Make region and again the same cycle continues.
        }
    }
}

