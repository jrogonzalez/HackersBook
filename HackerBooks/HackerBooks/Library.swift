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
    init(books: BookArray, orderedAlphabetically: Bool){
     
        if (orderedAlphabetically){
            //Creamos un nuevo diccionario vacio
            let sorted = books.sort {$0.title < $1.title}
            
            bookList = makeOneSectionEmptyLibrary()
            
            //Recorremos el array de libros para irlos añadiendo
            for each in sorted{
                    bookList["books"]?.append(each)
                
            }
        } else {
            //Creamos un nuevo diccionario vacio
            bookList = makeEmptyLibrary(obtainSectionForLibrary(books))
            
            
            //Recorremos el array de libros para irlos añadiendo
            for each in books{
                for each2 in each.tags{
                    bookList[each2]?.append(each)
                }
            }
        }
        
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
        
        // el personaje nº index en el tag introducido
        let chars = bookList[tag]!
        let char = chars[index]
        
        return char
        
        
    }
    
    func book(atIndex index: Int,
                      forTag tag: Int) throws -> Book?{
        
        //Obtengo el tag de esa fila
        guard let tagRow = obtainSectionForRow(tag) else{
            throw BookErrors.bookNotFound
        }
        
        guard let bookSection = bookList[tagRow] else{
            throw BookErrors.bookNotFound
        }
        
        return bookSection[index]
    }

    
    
    //MARK: Utils
    func makeEmptyLibrary(tags: Tag) -> BookDictionary {
        
        var d = BookDictionary()
        let array = Array(tags.tags)
        
        //Creamos el tag de vavoritos
        d["Favourite"] = BookArray()
        
        for each in array{
            d[each]  =   BookArray()
        }
        
        return d
    }
    
    func makeOneSectionEmptyLibrary() ->BookDictionary{
        var d = BookDictionary()
        
        //Creamos el tag de vavoritos
        d["favourite"] = BookArray()
        d["books"]  = BookArray()
        
        return d
        
    }
    
    func obtainSectionForLibrary(books:BookArray)-> Tag{
        let tags = Tag(tags: Set<String>())
        for each in books{
            let array = Array(each.tags)
            for each in array{
                tags.tags.insert(each.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()))
            }
            
        }
        
        return tags
    }
    
    func obtainSectionForLibrary(books: BookDictionary)-> Set<String>{
        var tags = Set<String>()
        for (_, value) in books{
            for book in value{
                let array = Array(book.tags)
                for each in array{
                    tags.insert(each.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()))
                }
            }
            
            
        }
        
        return tags
    }
    
    func obtainSectionForLibraryDict(books: BookDictionary)-> Set<String>{
        var tags = Set<String>()
        for (key, _) in books{
            tags.insert(key.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()))
        }
        
        return tags
    }
    
    func obtainFirstSection() -> String?{
//        let tags = obtainTagsForLibrary(bookList)
//        let arrayTags = Array(tags)
//        return arrayTags[0]
        return "1"
        
    }
    
    
    func obtainSectionForRow(row: Int) -> String?{
//        let tags = obtainSectionForLibrary(bookList)
        let tags = obtainSectionForLibraryDict(bookList)
        let arrayTags = Array(tags)
        return arrayTags[row]
        
    }
    
//    func orderFotTagRow() -> String?{
//        let tags = obtainTagsForLibrary(bookList)
//        let arrayTags = Array(tags)
//        return arrayTags[row]
//        
//    }
    
    
    //MARK: - Proxies
    var proxyForComparison : String{
        get{
            return ""
        }
    }
    
    var proxyForSorting : String{
        get{
            return proxyForComparison
        }
    }
    
    
//    //MARK: - Equatable & Comparable
//    func ==(lhs: BookDictionary, rhs: BookDictionary) -> Bool{
//    
//    guard (lhs !== rhs) else{
//    return true
//    }
//    
//    return lhs.proxyForComparison == rhs.proxyForComparison
//    }
//    
//    func <(lhs: StarWarsCharacter, rhs: StarWarsCharacter) -> Bool{
//    return lhs.proxyForSorting < rhs.proxyForSorting
//    }
    
    
    
}

extension Dictionary {
    
    //MARK: - Order
    // Faster because of no lookups, may take more memory because of duplicating contents
    func keysSortedByValue(isOrderedBefore:(Value, Value) -> Bool) -> [Key] {
        return Array(self)
            .sort() {
                let (_, lv) = $0
                let (_, rv) = $1
                return isOrderedBefore(lv, rv)
            }
            .map {
                let (k, _) = $0
                return k
        }
    }
}









 