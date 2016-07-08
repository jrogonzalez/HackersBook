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
            
            
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject("https://t.co/K9ziV0z3SJ", forKey: "JSON_Data")
            
            //        let defaults = NSUserDefaults.standardUserDefaults()
            guard let nombre = defaults.stringForKey("JSON_Data") else{
              return Bool(false)
            }
            
//            let json = try loadFromLocalFile(fileName: "books_readable.json")
            let json = try loadFromRemoteFile(fileURL: nombre)
            
                      
            //json.appendContentsOf(try loadFromLocalFile(fileName: "forceSensitives.json"))
//            print(json)
            
            var chars = [Book]()
            for dict in json{
                do{
                    let char = try decode(book: dict)
                    chars.append(char)
                }catch{
                    print("error al procesar \(dict)")
                }
            }
            
            print(chars)
            
//            var authores = Set<String>()
//            authores.insert("Scott Chacon")
//            authores.insert("Ben Straub")
//            
//            var taggs = Set<String>()
//            taggs.insert("version control")
//            taggs.insert("Git")
//            
//            let iURL = "http://hackershelf.com/media/cache/b4/24/b42409de128aa7f1c9abbbfa549914de.jpg"
//            let iPDF = "https://progit2.s3.amazonaws.com/en/2015-03-06-439c2/progit-en.376.pdf"
//
//            let iURL = NSURL(string: "http://hackershelf.com/media/cache/b4/24/b42409de128aa7f1c9abbbfa549914de.jpg")!
//            let iPDF = NSURL(string: "https://progit2.s3.amazonaws.com/en/2015-03-06-439c2/progit-en.376.pdf")!
            
            
//            //Podemos crear el modelo
//            guard let model = Book(authors: authores,
//                             image_url: iURL,
//                             pdf_url: iPDF,
//                             tags: taggs,
//                             title: "Pro Git",
//                             isFavourite: false) else{
//                                throw BookErrors.initModelError
//            }

            //Creamos el modelo
            let model = Library(books: chars)
            
            // crear el VC
//            let uVC = BookViewController(model: model)
            let uVC = LibraryViewController(model: model)
            
            // Lo metemos en un Nav
            let uNav = UINavigationController(rootViewController: uVC)

            
            // Creamos un character view controller
            let bookVC = BookViewController(model: model.book(atIndex: 0, forTag: "git"))

            // Lo metro dentro de un navigation
            let charNav = UINavigationController(rootViewController: bookVC)
            
            // Creamos el splitView y le endosmos los dos nav
            let splitVC = UISplitViewController()
            splitVC.viewControllers = [uNav, charNav]
            
            // Nav como root view Controller
            window?.rootViewController = splitVC

            
            // asignamos delegados
            uVC.delegate = bookVC
            
            
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


}

