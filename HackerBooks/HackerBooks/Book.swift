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
    
}