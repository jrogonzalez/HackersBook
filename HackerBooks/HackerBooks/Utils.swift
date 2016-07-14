
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
    
    
    func loadImage(forPath path: String) throws -> UIImage?{
        
        
        //Probamos a buscarla en local
        let localURL = obtainLocalUrlDocumentsFile(fileForResourceName(path))
        
        if let imgData = NSData(contentsOfURL: localURL),
            image = UIImage(data: imgData) {
            return image
            
        }else{
            
            //Si no esta en local probamos en remoto
            if let imgURL = NSURL(string: path),
                imgData = NSData(contentsOfURL: imgURL),
                image = UIImage(data: imgData) {
                
                do{
                    try imgData.writeToURL(localURL, options: NSDataWritingOptions.AtomicWrite)
                }catch{
                    throw BookErrors.imageNotFound
                }
                return image
                
            }
        }
        
        return nil
        
        
    }

    func loadPdf(forPath path: String) throws -> NSURLRequest?{
        
        
        //Probamos a buscarla en local
        let localURL = obtainLocalUrlDocumentsFile(fileForResourceName(path))
        let pdfData = NSData(contentsOfURL: localURL)
        
        if pdfData != nil{
             let pdf = NSURLRequest(URL: localURL)
            print("load pdf from LOCAL")
            return pdf
        }else{
            
            //Si no esta en local probamos en remoto
             let pdfURL = NSURL(string: path)
            
             let pdf = NSURLRequest(URL: pdfURL!)
                
                do{
                    if let pdfData = NSData(contentsOfURL: pdfURL!) {
                        try pdfData.writeToURL(localURL, options: NSDataWritingOptions.AtomicWrite)
                    }
                    
                }catch{
                    throw BookErrors.imageNotFound
                }
                print("load pdf from REMOTE")
                return pdf
                
            
        }
        
    }


    func obtainLocalUrlDocumentsFile(file: String) -> NSURL{
        
        let fm = NSFileManager.defaultManager()
        let url = fm.URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).last!
        let fich = url.URLByAppendingPathComponent(file)
        print(file)
        return fich
        
    }
    
    func fileForResourceName(name: String?) -> String{
        
        let components = name?.componentsSeparatedByString("/")
        let fileName = components?.last
        return fileName!
        
    }
    
    func obtainImage(path: String) throws -> UIImage{
        
        // Busco a imagen
        do{
            let image =  try loadImage(forPath: path)
            return image!
        }catch{
            throw BookErrors.imageNotFound
        }
    }

    
