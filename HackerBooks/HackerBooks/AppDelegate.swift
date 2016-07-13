//
//  AppDelegate.swift
//  HackerBooks
//
//  Created by jro on 04/07/16.
//  Copyright © 2016 jro. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // crear una window
        window = UIWindow(frame:UIScreen.mainScreen().bounds)
        
        // crear instancia de modelo
        do{
            let chars = try readJSON()
            
            let ordenAlfabetico : Bool = false

            //Creamos el modelo
            let model = Library(books: chars, orderedAlphabetically: ordenAlfabetico)
            
            // crear el VC
//            let uVC = BookViewController(model: model)
            let uVC = LibraryViewController(model: model)
            
            let tVC = SelectOrderViewController(table: uVC)
            
            // Lo metemos en un Nav
            let uNav = UINavigationController(rootViewController: tVC)

            
            
            // Creamos un character view controller
            let bookVC = BookViewController(model: try uVC.lastSelectedBook()!)

            // Lo metro dentro de un navigation
            let charNav = UINavigationController(rootViewController: bookVC)
            
            // Creamos el splitView y le endosmos los dos nav
            let splitVC = UISplitViewController()
            splitVC.viewControllers = [uNav, charNav]
            
            // Nav como root view Controller
            window?.rootViewController = splitVC

            
            // asignamos delegados
            uVC.delegate = bookVC
            bookVC.delegate = uVC
            
            
            // Mostramos la window
            window?.makeKeyAndVisible()
            
            return true
            
            
        }catch{
            fatalError("Error while loading JSON")
        }
        
        return true
    
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
//    func downloadJSON() throws {
//        // obtener el directorio Documents donde se guardará la caché
//        let fm = NSFileManager.defaultManager()
//        let urls = fm.URLsForDirectory(NSSearchPathDirectory.DocumentDirectory,
//                                       inDomains: NSSearchPathDomainMask.UserDomainMask)
//        let urlDir = urls.last!
//        
//        // descargar el fichero JSON
//        guard let urlSrc = NSURL(string: urlHackerBooks) else {
//            throw BookErrors.resourceURLNotReachable
//        }
//        
//        let request = NSURLRequest(URL: urlSrc)
//        var response: NSURLResponse?
//        let data = try NSURLConnection.sendSynchronousRequest(request, returningResponse: &response)
//        
//        // guardar el JSON en la cache
//        data.writeToURL(urlDir, atomically: true)
//    }


}




