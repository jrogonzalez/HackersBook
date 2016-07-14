//
//  JSONProcessing.swift
//  HackerBooks
//
//  Created by jro on 04/07/16.
//  Copyright © 2016 jro. All rights reserved.
//

import Foundation
import UIKit

/*
 {
 "authors": "Caleb Doxsey",
 "image_url": "http://hackershelf.com/media/cache/09/ad/09ad5199bbacbc8180465378365e8b4e.jpg",
 "pdf_url": "http://www.golang-book.com/assets/pdf/gobook.pdf",
 "tags": "programming, go, golang",
 "title": "An Introduction to Programming in Go"
 },
 */

//MARK: - Aliases
typealias   JSONObject      =   AnyObject
typealias   JSONDictionary  =   [String:   JSONObject]
typealias   JSONArray       =   [JSONDictionary]

let urlHackerBooks = "https://t.co/K9ziV0z3SJ"
let fileBooks = "HackerBooks.txt"

func decode(book json: JSONDictionary) throws  -> Book {
    
    //Validamos el dict
    guard let author = json["authors"] as? String else{
        throw BookErrors.wrongJSONFormat
    }
    
    let components = author.componentsSeparatedByString(",")
    var aut = Set<String>()
    for each in components{
        aut.insert(each.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()))
    }
    
    
    
    guard let imageString = json["image_url"] as? String else{
//        imageURL = NSURL(string: imageString),
//        imgData = NSData(contentsOfURL: imageURL),
//        image = UIImage(data: imgData)
    
        throw   BookErrors.wrongJSONFormat
    }
    
    guard let pdfString = json["pdf_url"] as? String else{
            throw   BookErrors.wrongJSONFormat
    }
    
    guard let tags = json["tags"] as? String else{
        throw BookErrors.wrongJSONFormat
    }
    
    let tagArray = tags.componentsSeparatedByString(",")
    
    var tagSet = Set<String>()
    for each in tagArray{
        tagSet.insert(each.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()))
    }
    let tag = Tag(tags: tagSet)
    
    
    guard let title = json["title"] as? String else{
        throw BookErrors.wrongJSONFormat
    }
    
    return Book(authors: aut, image: imageString, pdf: pdfString, tags: tag, title: title, isFavourite: false)
}

func decode(book  json: JSONDictionary?) throws -> Book{
    
    
    if case .Some(let jsonDict) = json{
        return try decode(book: jsonDict)
    }else{
        throw BookErrors.nilJSONObject
    }


}

func readJSON() throws -> [Book]{
    
    var json : JSONArray = JSONArray()
    let defaults = NSUserDefaults.standardUserDefaults()
    let file = obtainLocalUrlDocumentsFile(fileBooks)
    do{
    
        // Si existe la variable es que ya hemos cargado el fichero anteriormente
        let nombre = defaults.stringForKey("JSON_Data")
        
        if nombre != nil {
            // Comprobamos si tenemos los datos en local
            json = try loadFromLocalFile(fileName: file.absoluteString)!
            print("cargado desde LOCAL")
            
        } else{
            // Comprobamos el la URL para cargarlos
            json = try loadFromRemoteFile(fileURL: urlHackerBooks)
            print("cargado desde REMOTO")

        }
        
        var chars = [Book]()
        for dict in json{
            do{
                let char = try decode(book: dict)
                chars.append(char)
            }catch{
                print("error al procesar \(dict)")
            }
        }
        
        return chars

    }catch{
        throw BookErrors.wrongJSONFormat
    }
  
    
}




