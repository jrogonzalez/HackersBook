
import Foundation
import UIKit


    
//MARK: - Loading
func loadFromLocalFile(fileName name: String, bundle: NSBundle = NSBundle.mainBundle()) -> JSONArray?{
    
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
        
        //Guardamos en cache y en local
        try  data.writeToURL(obtainLocalCacheUrlDocumentsFile(fileBooks), options: NSDataWritingOptions.AtomicWrite)
        try  data.writeToURL(obtainLocalUrlDocumentsFile(fileBooks), options: NSDataWritingOptions.AtomicWrite)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(urlHackerBooks, forKey: "JSON_Data")
        
        
        return array
        
    }else{
        throw BookErrors.jsonParsingError
    }
}

func obtainLocalUrlDocumentsFile(file: String) -> NSURL{
    
    //Obtenemos una ruta local de la carpeta documentos y componemos una URL con el fochero que nos dan de entrada
    let fm = NSFileManager.defaultManager()
    let url = fm.URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).last!
    let fich = url.URLByAppendingPathComponent(file)
//    print(fich)
    return fich
    
}

func obtainLocalCacheUrlDocumentsFile(file: String) -> NSURL{
    
    //Obtenemos una ruta local de la carpeta Cache y componemos una URL con el fochero que nos dan de entrada
    let fm = NSFileManager.defaultManager()
    let url = fm.URLsForDirectory(NSSearchPathDirectory.CachesDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).last!
    let fich = url.URLByAppendingPathComponent(file)
//    print(fich)
    return fich
    
}

func fileForResourceName(name: String?) -> String{
    
    let components = name?.componentsSeparatedByString("/")
    let fileName = components?.last
    return fileName!
    
}

    