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
    var bookListTags : BookDictionary = BookDictionary()
    var bookListAlpha : BookDictionary = BookDictionary()
    
    var tags : Tag?
    
    //MARK: - Initializers
    init(books: BookArray, orderedAlphabetically: Bool){
     
        let defaults = NSUserDefaults.standardUserDefaults()
//        if (orderedAlphabetically){
            //Creamos un nuevo diccionario vacio
            let sorted = books.sort {$0.title < $1.title}
            
            bookListAlpha = makeOneSectionEmptyLibrary()
            
            
            defaults.setObject(["lastSection": "0", "lastRow": "0"], forKey: "lastBook")
            
            //Recorremos el array de libros para irlos añadiendo
            for each in sorted{
                    bookListAlpha["books"]?.append(each)
                
            }
//        } else {
            //Creamos un nuevo diccionario vacio
            bookListTags = makeEmptyLibrary(obtainSectionForLibrary(books))
            defaults.setObject(["lastSection": "1", "lastRow": "0"], forKey: "lastBook")
            
            //Recorremos el array de libros para irlos añadiendo
            for each in books{
                for each2 in each.tags.tagToOrderArray(){
                    bookListTags[each2]?.append(each)
                }
            }
//        }
        
    }
    
    var tagsCount : Int{
        get{
            // indicar cuantos tags hay
            return bookListTags.count
        }
    }
    
    
    func booksCount(forTag tag: String)-> Int{
        
        // cuantos libros hay para esta Tag?
        guard let num = bookListTags[tag]?.count else{
            return 0
        }
        
        return num
    }
    
    func book(forSection section: String, atRow row: Int
                           ) -> Book{
        
        // el personaje nº index en el tag introducido
        let chars = bookListTags[section]!
        let char = chars[row]
        
        return char
        
        
    }
    
    func book(forSection section: Int, atRow row: Int) -> Book?{
        
        
        if section == 0{
            if bookListTags["favourite"]?.count == 0 {
                //Obtengo el tag de esa fila
                guard let bookSection = obtainSection(section) else{
                    return nil
                }
                
                guard let  bookRow = bookListTags[bookSection] else{
                    return nil
                }
                
                return bookRow[row]
            }else if bookListTags["favourite"]?.count > 0{
                guard let  bookRow = bookListTags["favourite"] else{
                    return nil
                }
                
                return bookRow[row]
            }
        } else {
            //Obtengo el tag de esa fila
            guard let bookSection = obtainSection(section) else{
                return nil
            }
            
            guard let  bookRow = bookListTags[bookSection] else{
                return nil
            }
            
            return bookRow[row]
        }
        
        return nil
        
        
    }

    
    
    //MARK: Utils
    func makeEmptyLibrary(tags: Tag) -> BookDictionary {
        
        var d = BookDictionary()
        let array = Array(tags.tags.sort())
        
        //Creamos el tag de vavoritos
        d["favourite"] = BookArray()
        
        for each in array{
            d[each]  =   BookArray()
            tags.tags.insert(each)
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
    
    func addFavorite(book: Book){
        bookListAlpha["favourite"]?.append(book)
        bookListTags["favourite"]?.append(book)
    }
    
    func removeFavorite(book: Book){
        if var listAlpha = bookListAlpha["favourite"]{
            var i = 0
            for each in listAlpha{
                if each.title == book.title{
                    bookListAlpha["favourite"]?.removeAtIndex(i)
                }
                i += 1
            }
        }
        
        if var listTags = bookListTags["favourite"]{
            var m = 0
            for each in listTags{
                if each.title == book.title{
                    bookListTags["favourite"]?.removeAtIndex(m)
                }
                m += 1
            }
        }                
    }
    
    func obtainSectionForLibrary(books:BookArray)-> Tag{
        let tags = Tag(tags: Set<String>())
        for each in books{
            let array = Array(each.tags.tags.sort())
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
                let array = Array(book.tags.tags)
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
//        let tags = obtainTagsForLibrary(bookListTags)
//        let arrayTags = Array(tags)
//        return arrayTags[0]
        return "1"
        
    }
    
    
    func obtainSection(section: Int) -> String?{
//        let tags = obtainSectionForLibrary(bookListTags)
        let tags = obtainSectionForLibraryDict(bookListTags)
        let arrayTags = Array(tags.sort())
        return arrayTags[section]
        
    }
    
    
    
//    func orderFotTagRow() -> String?{
//        let tags = obtainTagsForLibrary(bookListTags)
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









 