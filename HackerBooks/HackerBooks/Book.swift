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
    var image_url   :   UIImage
    var pdf_url     :   NSURL
    var tags        :   Tag
    var title       :   String
    var isFavourite  :   Bool
    
    //MARK:  Initializers
    init(authors: Set<String>, image_url: UIImage , pdf_url: NSURL, tags: Tag, title: String, isFavourite: Bool){
        self.authors        = authors
        self.image_url      = image_url
        self.pdf_url        = pdf_url
        self.tags           = tags
        self.title          = title
        self.isFavourite    = isFavourite
        
    }
    
    convenience init?(authors: Set<String>, image_url: String , pdf_url: String, tags: Tag, title: String, isFavourite: Bool){
        
        guard let pdfURL = NSURL(string: pdf_url) else{
            return nil
        }
        
        
        guard let imageURL = NSURL(string: image_url),
            data = NSData(contentsOfURL: imageURL),
            image = UIImage(data: data) else{
                return nil
        }
        
        self.init(authors: authors, image_url: image , pdf_url: pdfURL, tags: tags, title: title, isFavourite: false)
    }
    
}