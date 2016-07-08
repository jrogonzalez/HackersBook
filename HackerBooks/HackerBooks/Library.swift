//
//  Library.swift
//  HackerBooks
//
//  Created by jro on 04/07/16.
//  Copyright © 2016 jro. All rights reserved.
//

import Foundation
import UIKit


class Library {
    
    //MARK: - Utility types
    typealias BookArray         = [Book]
    typealias BookDictionary    = [String: BookArray]
    
    //MARK: - Properties
    var bookList : BookDictionary = BookDictionary()
    
    //MARK: - Initializers
    init(books: BookArray){
        
        //Creamos un nuevo diccionario vacio
        bookList = makeEmptyLibrary(obtainTagsForLibrary(books))
        
        
        //Recorremos el array de libros para irlos añadiendo
        for each in books{
            for each2 in each.tags{
                    bookList[each2]?.append(each)
            }
            
            
        }
//        self.library = book
    }
    
    var tagsCount : Int{
        get{
            // indicar cuantos tags hay
            return bookList.count
        }
    }
    
    
    func booksCount(forTag tag: String)-> Int{
        
        // cuantos libros hay para esta Tag?
        guard let num = bookList[tag]?.count else{
            return 0
        }
        
        return num
    }
    
    func book(atIndex index: Int,
                           forTag tag: String) -> Book{
        
        // el persinaje nº index en la afiliación affiliation
        let chars = bookList[tag]!
        let char = chars[index]
        
        return char
        
        
    }

    
    
    //MARK: Utils
    func makeEmptyLibrary(tags: Tag) -> BookDictionary {
        
        var d = BookDictionary()
        let array = Array(tags.tags.sort())
        
        for each in array{
            d[each]  =   BookArray()
        }
        
        return d
    }
    
    func obtainTagsForLibrary(books:BookArray)-> Tag{
        let tags = Tag(tags: Set<String>())
        for each in books{
            let array = Array(each.tags.sort())
            for each in array{
                tags.tags.insert(each.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()))
            }
            
        }
        
        return tags
    }
    
    func obtainTagsForLibrary(books: BookDictionary)-> Set<String>{
        var tags = Set<String>()
        for (_, value) in books{
            for book in value{
                let array = Array(book.tags.sort())
                for each in array{
                    tags.insert(each.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()))
                }
            }
            
            
        }
        
        return tags
    }
    
    
}
 