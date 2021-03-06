//
//  AppDelegate.swift
//  ToDoFIRE
//
//  Created by Dmitry Shapkin on 14/12/2019.
//  Copyright © 2019 ShapkinDev. All rights reserved.
//

import UIKit
import CoreData
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var handle: AuthStateDidChangeListenerHandle?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()

        FirebaseApp.configure()
        observeAuthorisedState()
        
        return true
    }
    
    private func observeAuthorisedState() {
        window?.rootViewController = UINavigationController(rootViewController: LoginViewController()) as UINavigationController
        var rootViewController = window?.rootViewController as! UINavigationController
        
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if user == nil {
                rootViewController = UINavigationController(rootViewController: LoginViewController())
            } else {
                rootViewController.pushViewController(TasksViewController(), animated: true)
            }
        }
    }
    
    private func setupRootViewController(
        viewController: UIViewController) {
        
        window?.rootViewController = UINavigationController(rootViewController: viewController)
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "ToDoFIRE")
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

