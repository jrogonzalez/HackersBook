//
//  Book.swift
//  HackerBooks
//
//  Created by jro on 04/07/16.
//  Copyright © 2016 jro. All rights reserved.
//

import Foundation
import  UIKit

class Book{
    
    //MARK: - Properties
    var authors     =   Set<String>()
    var image       :   String
    var pdf         :   String
    var tags        :   Tag
    var title       :   String
    var isFavourite :   Bool
    
    //MARK:  Initializers
    init(authors: Set<String>, image: String , pdf: String, tags: Tag, title: String, isFavourite: Bool){
        self.authors        = authors
        self.image          = image
        self.pdf            = pdf
        self.tags           = tags
        self.title          = title
        self.isFavourite    = isFavourite
        
    }
    
    func loadImage() throws -> UIImage?{
        
        //Probamos a buscarla en local
        let localURLCache = obtainLocalCacheUrlDocumentsFile(fileForResourceName(self.image))
        let localURL = obtainLocalUrlDocumentsFile(fileForResourceName(self.image))
        
        //Buscamos en la cache
        if let imgDataCache = NSData(contentsOfURL: localURLCache),
            imageCache = UIImage(data: imgDataCache) {
            
            return imageCache
            
        }else if let imgData = NSData(contentsOfURL: localURL),
            image = UIImage(data: imgData) {
            
            return image
            
        }else{
            
            //Si no esta en local probamos en remoto
            if let imgURL = NSURL(string: self.image),
                imgData = NSData(contentsOfURL: imgURL),
                image = UIImage(data: imgData) {
                
                do{
                    try imgData.writeToURL(localURLCache, options: NSDataWritingOptions.AtomicWrite)
                    try imgData.writeToURL(localURL, options: NSDataWritingOptions.AtomicWrite)
                }catch{
                    throw BookErrors.imageNotFound
                }
                return image                
            }
        }
        
        return nil
    }
    
    
    func loadPdf() throws -> NSURLRequest?{
        
        //Probamos a buscarla en local
        let localURLCache = obtainLocalCacheUrlDocumentsFile(fileForResourceName(self.pdf))
        let localURL = obtainLocalUrlDocumentsFile(fileForResourceName(self.pdf))
        
        
        if NSData(contentsOfURL: localURLCache) != nil{
            let pdfCache = NSURLRequest(URL: localURLCache)
            
            return pdfCache
        }else if NSData(contentsOfURL: localURL) != nil{
            let pdf = NSURLRequest(URL: localURL)
            
            return pdf
        }else{
            
            //Si no esta en local probamos en remoto
            let pdfURL = NSURL(string: self.pdf)            
            let pdf = NSURLRequest(URL: pdfURL!)
            
            do{
                if let pdfData = NSData(contentsOfURL: pdfURL!) {
                    try pdfData.writeToURL(localURLCache, options: NSDataWritingOptions.AtomicWrite)
                    try pdfData.writeToURL(localURL, options: NSDataWritingOptions.AtomicWrite)
                }
                
            }catch{
                throw BookErrors.imageNotFound
            }
            
            return pdf
            
            
        }
        
    }
    
    func markAsFavourite(){
        self.isFavourite = true
    }
    
}