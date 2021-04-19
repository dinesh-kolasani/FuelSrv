//
//  AppDelegate.swift
//  FuelSrv
//
//  Created by PBS9 on 01/04/19.
//  Copyright © 2019 Dinesh Raja. All rights reserved.
//

import UIKit

import UserNotifications
import Firebase

import FBSDKCoreKit
import GoogleSignIn
import GoogleMaps
import GooglePlaces
import LGSideMenuController
import IQKeyboardManagerSwift
import Stripe
import Fabric
import Crashlytics


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,GIDSignInDelegate {
    
    var window: UIWindow?
    var orderDataDict = [String:Any]()
    var sideMenuController: LGSideMenuController?
    var gcmMessageIDKey = "gcm.message_id"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        GMSServices.provideAPIKey(GMSServicesid)
        GMSPlacesClient.provideAPIKey(GMSPlacesClientid)
        
        STPPaymentConfiguration.shared().publishableKey = StripPaymentKey
        
        
        //Firebase Configure
        FirebaseApp.configure()
        
    // [START set_messaging_delegate]
        Messaging.messaging().delegate = self
        
//        let uuid = UIDevice.current.identifierForVendor?.uuidString
//        defaultValues.set(uuid, forKey: "DeviceID")
        
        UIApplication.shared.statusBarView?.backgroundColor = #colorLiteral(red: 0.08235294118, green: 0.6509803922, blue: 0.3411764706, alpha: 1)
        UINavigationBar.appearance().tintColor = #colorLiteral(red: 0.08235294118, green: 0.6509803922, blue: 0.3411764706, alpha: 1)
        
        
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        GIDSignIn.sharedInstance()?.clientID = GoogleClientid
        
        GIDSignIn.sharedInstance().delegate = self

        IQKeyboardManager.shared.enable = true
        //Firebase PushNotification.
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_,_ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        
        configureSideMenu()
       // navigation()
        return true
    }
    
//    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
//        print("Firebase registration token: \(fcmToken)")
//    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            
            print("\(error.localizedDescription)")
            
        }else{
            print("\(error.localizedDescription)")

        }
    }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        
    }
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let handle = ApplicationDelegate.shared.application(application, open: url, options: options)
        
        return handle
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
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification

        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)

        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }

        // Print full message.
        print(userInfo)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification

        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)

        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }

        // Print full message.
        print(userInfo)

        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
    }
}
extension AppDelegate {
    // MARK: Navigation Method
    func navigation()
    {
        UINavigationBar.appearance().barTintColor =  #colorLiteral(red: 0.08235294118, green: 0.6509803922, blue: 0.3411764706, alpha: 1)
        UINavigationBar.appearance().tintColor = .white
        let customFont = UIFont(name: "SegoeUI-Semibold", size: 20) ?? .boldSystemFont(ofSize: 20)
        
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white , NSAttributedStringKey.font: customFont ]
        
        UINavigationBar.appearance().isTranslucent = false
        
        let imgBack = UIImage(named: "back")
        UINavigationBar.appearance().backIndicatorImage = imgBack
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = imgBack

        
    }
    
    //MARK:- Side Menu Configure
    func configureSideMenu() {
        
        UIApplication.shared.statusBarView?.backgroundColor = #colorLiteral(red: 0.08235294118, green: 0.6509803922, blue: 0.3411764706, alpha: 1)
        window = UIWindow.init(frame: UIScreen.main.bounds)
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        //let userID = UserDefaults.standard.value(forKey: "UserID") as? String ?? ""
        
        if defaultValues.string(forKey: "UserID") == nil
        {
            let delegate = UIApplication.shared.delegate as? AppDelegate
            let vc = storyBoard.instantiateViewController(withIdentifier: "LogInVC") as! LogInVC
            let nav = UINavigationController(rootViewController: vc)
            delegate?.window?.rootViewController = nav
            window?.rootViewController = nav
            window?.makeKeyAndVisible()
        }else {
            
            navigation()
            if defaultValues.integer(forKey: "UserType") == 1 {

                let rootViewController = DriverStoryBoard.instantiateViewController(withIdentifier: "DriverHomeVC") as! DriverHomeVC
                let menuVC = KMainStoryBoard.instantiateViewController(withIdentifier: "SideMenuVC") as! SideMenuVC
                //let rightViewController = NavigationController(rootViewController: menuVC)
                //rightViewController.isNavigationBarHidden = true

                let navigationController = NavigationController(rootViewController: rootViewController)
                navigationController.isNavigationBarHidden = true

                sideMenuController = LGSideMenuController(rootViewController: navigationController,
                                                          leftViewController: nil,
                                                          rightViewController: menuVC)

                sideMenuController?.rightViewWidth = (window?.bounds.width)! - 80
                //sideMenuController?.leftViewPresentationStyle = .slideBelow;
                menuVC.hideView.isHidden = false
                menuVC.menuBG.image = #imageLiteral(resourceName: "Driverbg-1")
                menuVC.driverSectionBtn.isHidden = true
                menuVC.userSectionBtn.isHidden = false
                menuVC.profileIMG.layer.borderColor = #colorLiteral(red: 0.08235294118, green: 0.6509803922, blue: 0.3411764706, alpha: 1)

                self.window = UIWindow(frame: DEVICE_SIZE)
                self.window?.rootViewController = sideMenuController
                self.window?.makeKeyAndVisible()
            }else{
                let rootViewController = KMainStoryBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                let menuVC = KMainStoryBoard.instantiateViewController(withIdentifier: "SideMenuVC") as! SideMenuVC
                //let rightViewController = NavigationController(rootViewController: menuVC)
                //rightViewController.isNavigationBarHidden = true

                let navigationController = NavigationController(rootViewController: rootViewController)
                navigationController.isNavigationBarHidden = true

                sideMenuController = LGSideMenuController(rootViewController: navigationController,
                                                          leftViewController: nil,
                                                          rightViewController: menuVC)

                sideMenuController?.rightViewWidth = (window?.bounds.width)! - 80
                //sideMenuController?.leftViewPresentationStyle = .slideBelow;

                self.window = UIWindow(frame: DEVICE_SIZE)
                self.window?.rootViewController = sideMenuController
                self.window?.makeKeyAndVisible()
            }

        }
    }
}
@available(iOS 10, *)

extension AppDelegate : UNUserNotificationCenterDelegate {

    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo

        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)

        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }

        // Print full message.
        print(userInfo)

        // Change this to your preferred presentation option
        completionHandler([.alert])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }

        // Print full message.
        print(userInfo)

        completionHandler()
    }
}

// MARK: - Push Notification MessagingDelegate methods.


extension AppDelegate: MessagingDelegate{

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
            defaultValues.set(fcmToken, forKey: "DeviceID")
        defaultValues.synchronize()
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }

    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Message data:", remoteMessage.appData)
    }

}

enum OrderDataEnum: String {
    case UserLocation
    case Schedule
    case ServicesType
    case FuelType
    case FillMyTires
    case PlowMyDriveway
    case WindShieldWasherFluid
    case Oil
    case Vehicle
    case FuelAmount
    case Payment
    case Promocode
    case Membership
}


