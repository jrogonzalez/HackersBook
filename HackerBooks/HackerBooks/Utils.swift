
import Foundation
import UIKit


    
    //MARK: - Loading
    func loadFromLocalFile(fileName name: String, bundle: NSBundle = NSBundle.mainBundle()) throws -> JSONArray?{
        
        if let url = NSURL(string: name),
            data = NSData(contentsOfURL: url),
            maybeArray = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? JSONArray,
            array = maybeArray{
            
            return array
            
        }else{
            return nil
        }
    }
    
    
    func loadFromRemoteFile(fileURL name: String, bundle: NSBundle = NSBundle.mainBundle()) throws -> JSONArray{
        
        if let url = NSURL(string: name),
            data = NSData(contentsOfURL: url),
            maybeArray = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? JSONArray,
            array = maybeArray{
            
            try  data.writeToURL(obtainLocalUrlDocumentsFile(fileBooks), options: NSDataWritingOptions.AtomicWrite)
            
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(urlHackerBooks, forKey: "JSON_Data")
            
            
            return array
            
        }else{
            throw BookErrors.jsonParsingError
        }
    }
    
    


    


    func obtainLocalUrlDocumentsFile(file: String) -> NSURL{
        
        let fm = NSFileManager.defaultManager()
        let url = fm.URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).last!
        let fich = url.URLByAppendingPathComponent(file)
        return fich
        
    }
    
    func fileForResourceName(name: String?) -> String{
        
        let components = name?.componentsSeparatedByString("/")
        let fileName = components?.last
        return fileName!
        
    }
    