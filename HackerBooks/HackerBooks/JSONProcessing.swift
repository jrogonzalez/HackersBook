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
    
    
    
    guard let imageString = json["image_url"] as? String,
//        imageURL = NSURL(string: imageString),
        image = UIImage(named: imageString)   else{
        throw   BookErrors.wrongJSONFormat
    }
    
    guard let pdfString = json["pdf_url"] as? String,
        pdfURL = NSURL(string: pdfString)   else{
            throw   BookErrors.wrongJSONFormat
    }
    
    guard let tags = json["tags"] as? String else{
        throw BookErrors.wrongJSONFormat
    }
    
    let tagArray = tags.componentsSeparatedByString(",")
    var tag = Set<String>()
    for each in tagArray{
        tag.insert(each.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()))
    }
    
    
    guard let title = json["title"] as? String else{
        throw BookErrors.wrongJSONFormat
    }
    
    return Book(authors: aut, image_url: image, pdf_url: pdfURL, tags: tag, title: title, isFavourite: false)
}

func decode(book  json: JSONDictionary?) throws -> Book{
    
    
    if case .Some(let jsonDict) = json{
        return try decode(book: jsonDict)
    }else{
        throw BookErrors.nilJSONObject
    }
}

//MARK: - Loading
func loadFromLocalFile(fileName name: String, bundle: NSBundle = NSBundle.mainBundle()) throws -> JSONArray{
    
    if let url = bundle.URLForResource(name),
        data = NSData(contentsOfURL: url),
        maybeArray = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? JSONArray,
        array = maybeArray{
        
        return array
        
    }else{
        throw BookErrors.jsonParsingError
    }
}


func loadFromRemoteFile(fileURL name: String, bundle: NSBundle = NSBundle.mainBundle()) throws -> JSONArray{
    
    if let url = NSURL(string: name),
        data = NSData(contentsOfURL: url),
        maybeArray = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? JSONArray,
        array = maybeArray{
        
        return array
        
    }else{
        throw BookErrors.jsonParsingError
    }
}





