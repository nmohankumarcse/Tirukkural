//
//  AppDelegate.swift
//  Tirukkral
//
//  Created by Muthu on 11/04/17.
//  Copyright © 2017 Mohan. All rights reserved.
//

import UIKit
import CoreData
import SVProgressHUD
import UserNotifications
import TwitterKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {

    var window: UIWindow?
    var kuralsForThisMonth : [Kural] = []

    internal func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        TWTRTwitter.sharedInstance().start(withConsumerKey:"2vwOfQUhFeglqrkPMdQcAvYYK", consumerSecret:"F19UXOXbtLNB3ewoUNuFebmnGDksBlAOYWc8EAvf1NRLLNV7UO")

        let sections = CoreDataHelper.shared().getAllSections()
        if sections.count < 3{
            SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)
            SVProgressHUD.show()
            self.completeParsing() {isCompleted in
                // your completion block code here.
                if isCompleted{
                    SVProgressHUD.dismiss(completion: nil)
                    for _ in 1...31{
                        let kural =  CoreDataHelper.shared().getRandomKuralForTheDay()
                        self.kuralsForThisMonth.append(kural)
                    }
                    self.initializeRootView(kural: self.kuralsForThisMonth[0])
                    self.askPermissionForLocalNotification()
                }
            }
        }
        else{
            for _ in 1...31{
                let kural =  CoreDataHelper.shared().getRandomKuralForTheDay()
                self.kuralsForThisMonth.append(kural)
            }
            self.initializeRootView(kural: self.kuralsForThisMonth[0])
            self.askPermissionForLocalNotification()
        }
        return true
    }
    
    internal func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return TWTRTwitter.sharedInstance().application(app, open: url, options: options)
    }
    
    func initializeRootView(kural : Kural?){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabbar = (storyboard.instantiateViewController(withIdentifier: "tabbar") as! UITabBarController)
        let nav : UINavigationController = tabbar.viewControllers![0] as! UINavigationController
        let kuralDetail : KuralDetailTableViewController = nav.viewControllers[0] as! KuralDetailTableViewController
        
        if kural != nil{
            kuralDetail.kural = kural
            kuralDetail.isRandom = true
            self.window?.rootViewController = tabbar
        }
    }
    
    func completeParsing(completion: @escaping (Bool) -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            print("url : \(urls[urls.count-1])")
            if let path = Bundle.main.url(forResource: "tirukkural", withExtension: "json") {
                
                do {
                    let jsonData = try Data(contentsOf: path, options: .mappedIfSafe)
                    do {
                        if let jsonResult = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? NSDictionary {
                            let sections : NSArray = jsonResult.object(forKey: "sections") as! NSArray
                            //                        let chapters : NSArray = jsonResult.object(forKey: "chapters") as! NSArray
                            let kurals : NSArray = jsonResult.object(forKey: "kurals") as! NSArray
                            let cdh = CoreDataHelper()
                            for (_, section) in sections.enumerated() {
                                cdh.insertSection(sectionName: section as! String)
                            }
                            
                            for (index, kural) in kurals.enumerated() {
                                cdh.insertKural(kural: kural as! NSDictionary, index: index)
                                if index == kurals.count-1{
                                    completion(true)
                                }
                            }
                        }
                    } catch let error as NSError {
                        print("Error: \(error)")
                    }
                } catch let error as NSError {
                    print("Error: \(error)")
                }
            }
        })
        // Call YOUR completion here...
    }
    
    func askPermissionForLocalNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge]) { (granted, error) in
            self.sheduleLocalNotification()
        }
    }

    
    func sheduleLocalNotification(){
        let content = UNMutableNotificationContent()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        for (index,element) in self.kuralsForThisMonth.enumerated(){
            let kural = element
            content.title = (kural.hasChapter?.chapterName!)!
            let kuralDescription : [String] = (kural.kural!.components(separatedBy: ","))
            content.body  = "\(kuralDescription[0]) \n \(kuralDescription[1]) \n\n \(kural.kuralMeaningEng!)"
            content.sound = UNNotificationSound.default
            let dict : Dictionary<String, Any> = ["kuralNo" : kural.kuralNo]
            content.userInfo = dict
            let calendar = Calendar(identifier: .gregorian)
            let components = calendar.dateComponents(in: .current, from: Date.init())
            let newComponents = DateComponents(calendar: calendar, timeZone: .current, month: components.month, day: components.day!+index, hour: components.hour, minute: components.minute)
            let trigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().add(request) {(error) in
                if let error = error {
                    print("Uh oh! We had an error: \(error)")
                }
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print(response)
        let dict = response.notification.request.content.userInfo
        let kural = CoreDataHelper.shared().getKuralForNo(no: dict["kuralNo"] as! Int)
        self.initializeRootView(kural: kural)
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
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Tirukkral")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

