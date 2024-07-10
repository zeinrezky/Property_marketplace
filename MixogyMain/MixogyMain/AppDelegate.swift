//
//  AppDelegate.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 28/02/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import DropDown
import Firebase
import GoogleMaps
import GooglePlaces
import IQKeyboardManager
import SVProgressHUD
import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let gcmMessageIDKey = "AAAAuTozcAg:APA91bGKmXOrKkjKAfgusvBTLk5jIjhysa1DlMrerANzCf_z-1m_fnj47M30grhyL_WFXCQZ88rW6snOU5K1H6q9b8pJ0sfji3lD6S-luiK3l4etTg4WC7U-w4WNWcV63a4O0qPLPmrL"
    
    private var onBoardingViewController: OnBoardingPagerViewController {
        return OnBoardingPagerViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: nil
        )
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print("application openURL options is called")
        
        let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication]
        let urlScheme = url.scheme
        let urlQuery = url.query
        
        print("value \(urlQuery)");
        print("scheme \(urlQuery)");
        print("query \(urlQuery)");
        
        // Check URL scheme and caller
//        if ([urlScheme isEqualToString:@"freedomofkeima"] &&
//            [sourceApplication isEqualToString:@"com.apple.SafariViewService"]) {
//            // Pass it via notification
//            NSLog(@"Value: %@", urlQuery);
//            NSDictionary *data = [NSDictionary dictionaryWithObject:urlQuery forKey:@"key"];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"SafariCallback" object:self userInfo:data];
//
//            return true
//        }
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared().isEnabled = true
        GMSPlacesClient.provideAPIKey(Constants.GoogleAPIKey)
        GMSServices.provideAPIKey(Constants.GoogleAPIKey)
        FirebaseApp.configure()
        UIBarButtonItem
            .appearance()
            .setBackButtonTitlePositionAdjustment(
                UIOffset(horizontal: -1000.0, vertical: 0.0),
                for: .default
        )
        DropDown.startListeningToKeyboard()
        DropDown.appearance().textFont = UIFont(name: "Nunito-Bold", size: 15) ?? UIFont.systemFont(ofSize: 15)
        DropDown.appearance().backgroundColor = UIColor.white
        DropDown.appearance().selectionBackgroundColor = UIColor.white
        DropDown.appearance().cellHeight = 44
        SVProgressHUD.setDefaultMaskType(.black)
        UITabBar.appearance().barTintColor = .clear
        UITabBar.appearance().backgroundColor = .clear
        UITabBar.appearance().clipsToBounds = true
        UITabBar.appearance().backgroundImage = UIImage.from(color: UIColor.clear)
        UITabBar.appearance().shadowImage = UIImage.from(color: UIColor.clear)
        window = UIWindow(frame: UIScreen.main.bounds)
        UITabBar.appearance().barTintColor = UIColor.clear
        window?.rootViewController = onBoardingViewController
        window?.makeKeyAndVisible()
        Messaging.messaging().delegate = self
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        } else {
          let settings: UIUserNotificationSettings =
          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
        if CLLocationManager.locationServicesEnabled() {
             switch CLLocationManager.authorizationStatus() {
                case .notDetermined, .restricted, .denied:
                    self.presentAskPermissionAlert()
                
                case .authorizedAlways, .authorizedWhenInUse:
                    print("Access")
                }
        } else {
            self.presentAskPermissionAlert()
                print("Location services are not enabled")
        }
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken.hexString)")
        
        InstanceID.instanceID().instanceID { (result, error) in
            if let result = result {
                Preference.deviceToken = result.token
            }
        }
        
        Messaging.messaging().apnsToken = deviceToken
    }
}

// MARK: - Private Extension

fileprivate extension AppDelegate {
    
    func configureUI() {
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -1000.0, vertical: 0.0), for: .default)
        DropDown.startListeningToKeyboard()
        DropDown.appearance().textColor = UIColor.black
        DropDown.appearance().textFont = UIFont(name: "Nunito-Bold", size: 15) ?? UIFont.systemFont(ofSize: 15)
        DropDown.appearance().backgroundColor = UIColor.white
        DropDown.appearance().selectionBackgroundColor = UIColor.white
        DropDown.appearance().cellHeight = 44
    }
}

// [START ios_10_message_handling]
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
    print("payload = \(userInfo)")
    // Change this to your preferred presentation option
    let type = userInfo["type"] as? String ?? ""
    
    if !type.isEmpty {
        NotificationCenter.default.post(
            name: Notification.Name(Constants.ItemTypeKey),
            object: nil,
            userInfo: ["type": type]
        )
        
        Preference.inboxCount = 1
    }
    completionHandler([[.alert, .sound]])
  }

  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo
    // Print message ID.
    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID: \(messageID)")
    }

    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // Messaging.messaging().appDidReceiveMessage(userInfo)
    // Print full message.
    print("payload = \(userInfo)")
    let type = userInfo["type"] as? String ?? ""
    
    if !type.isEmpty {
        NotificationCenter.default.post(
            name: Notification.Name(Constants.ItemTypeKey),
            object: nil,
            userInfo: ["type": type]
        )
        
        Preference.inboxCount = 1
    }
    
    completionHandler()
  }
}
// [END ios_10_message_handling]

extension AppDelegate : MessagingDelegate {
  // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    print("Firebase registration token: \(fcmToken)")
    let pasteboard = UIPasteboard.general
    pasteboard.string = fcmToken
    
    let dataDict:[String: String?] = ["token": fcmToken]
    NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    // TODO: If necessary send token to application server.
    // Note: This callback is fired at each app startup and whenever a new token is generated.
  }
  // [END refresh_token]
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "informaton".localized(), message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    func presentAskPermissionAlert() {
        let alertController = UIAlertController(
            title: "Permission denied",
            message: "Please, allow the application to access to your photo location.",
            preferredStyle: .alert)

      let alertAction = UIAlertAction(title: "Ok", style: .default) { _ in
        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.openURL(settingsURL)
        }
      }

        let viewController = UIApplication.shared.keyWindow?.rootViewController
        let cancelAction = UIAlertAction(title: "cancel".localized(), style: .cancel) { _ in
            viewController?.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(alertAction)
        alertController.addAction(cancelAction)

        viewController?.present(alertController, animated: true, completion: nil)
    }
}
