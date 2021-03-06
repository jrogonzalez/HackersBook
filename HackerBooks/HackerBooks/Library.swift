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
    

    var tagsTags : Tag = Tag(tags: Set<String>())
    var tagsAlpha : Tag = Tag(tags: Set<String>())
    
    var favourites = Set<String>()
    
    var orderedAlphabetically = false
    
    //MARK: - Initializers
    init(books: BookArray, orderedAlphabetically: Bool){
        
        loadFavourites()
        
        let defaults = NSUserDefaults.standardUserDefaults()
        self.orderedAlphabetically = orderedAlphabetically
        print(" orderedAlphabetically: \(orderedAlphabetically)")
        //Creamos un nuevo diccionario vacio
        let sorted = books.sort {$0.title < $1.title}
        
        //Creamos los diccionarios vacios
        bookListAlpha = makeOneSectionEmptyLibrary()
        bookListTags = makeEmptyLibrary(obtainSectionForLibrary(books))
            
        //MARK: TODO implementar lasSeectedBook, esta pare a tenia hecha pero al tener difeentes maneras de ordenar 
        //me quedó cojo como ubicar la celda que tenia selecionada en el lastIndex. Lo he dejado por tener constancia del trabajo ya hecho
        defaults.setObject(["lastSection": "1", "lastRow": "0"], forKey: "lastBook")
            
        //Recorremos el array de libros para irlos añadiendo
        for each in sorted{
            
            //Introducimos los favoritos en los dos diccionarios
            // Lo hacemos aqui ya que no tenemos duplicados al tenerlos odenados alfabeticamente
            if favourites.contains(each.title){
                bookListAlpha["favourite"]?.append(each)
                bookListTags["favourite"]?.append(each)
                each.markAsFavourite()
            }
            
            bookListAlpha["books"]?.append(each)
        }
        
        
        //Recorremos el array de libros para irlos añadiendo
        for each in books{
            for each2 in each.tags.tagToOrderArray(){
                bookListTags[each2]?.append(each)
            }
        }
        
    }
    
    var tagsCount : Int{
        get{
            //Comprobamos como estamos ordenando en el modelo
            if (orderedAlphabetically){
                // indicar cuantos tags hay
                return bookListAlpha.count
            }else{
                // indicar cuantos tags hay
                return bookListTags.count
            }
        }
    }
    
    func modifyOrderedAlphabetically(orderAlpha: Bool){
        self.orderedAlphabetically = orderAlpha
    }
    
    
    func booksCount(forTag tag: String)-> Int{
        
        //Comprobamos como estamos ordenando en el modelo
        if (orderedAlphabetically){
            // cuantos libros hay para esta Tag?
            guard let num = bookListAlpha[tag]?.count else{
                return 0
            }
            
            return num

        }else{
            // cuantos libros hay para esta Tag?
            guard let num = bookListTags[tag]?.count else{
                return 0
            }
            
            return num

        }
    }

    
    func book(forSection section: Int, atRow row: Int) -> Book?{
        
        //La parte de los favoritos es inde
        if section == 0{
            
            //Comprobamos como estamos ordenando en el modelo
            if (orderedAlphabetically){
                if bookListAlpha["favourite"]?.count > 0{
                    guard let  bookRow = bookListAlpha["favourite"] else{
                        return nil
                    }
                    
                    return bookRow[row]
                }

            }else{
                if bookListTags["favourite"]?.count > 0{
                    guard let  bookRow = bookListTags["favourite"] else{
                        return nil
                    }
                    
                    return bookRow[row]
                }
            }
        }
        
        
        //Comprobamos como estamos ordenando en el modelo
        if (orderedAlphabetically){
            //Obtengo el tag de esa fila
            guard let bookSection = obtainSection(section) else{
                return nil
            }
            
            guard let  bookRow = bookListAlpha[bookSection] else{
                return nil
            }
            
            return bookRow[row]
        }else{
            //Obtengo el tag de esa fila
            guard let bookSection = obtainSection(section) else{
                return nil
            }
            
            guard let  bookRow = bookListTags[bookSection] else{
                return nil
            }
            
            return bookRow[row]
        }
    }

    
    
    //MARK: Utils
    func makeEmptyLibrary(tags: Tag) -> BookDictionary {
        
        var d = BookDictionary()
        let array = Array(tags.tags.sort())
        
        //Creamos el tag de vavoritos
        d["favourite"] = BookArray()
        tagsTags.tags.insert("favourite")
        
        for each in array{
            d[each]  =   BookArray()
            tags.tags.insert(each)
            tagsTags.tags.insert(each)
        }
        
        return d
    }
    
    func makeOneSectionEmptyLibrary() ->BookDictionary{
        var d = BookDictionary()
        
        //Creamos el tag de vavoritos
        d["favourite"] = BookArray()
        d["books"]  = BookArray()
        
        tagsAlpha.tags.insert("favourite")
        tagsAlpha.tags.insert("books")
        
        return d
        
    }
    
    func addFavorite(book: Book){
        bookListAlpha["favourite"]?.append(book)
        bookListTags["favourite"]?.append(book)
        favourites.insert(book.title)
        saveFavourites()
    }
    
    func removeFavorite(book: Book){
        if let listAlpha = bookListAlpha["favourite"]{
            var i = 0
            for each in listAlpha{
                if each.title == book.title{
                    bookListAlpha["favourite"]?.removeAtIndex(i)
                }
                i += 1
            }
        }
        
        if let listTags = bookListTags["favourite"]{
            var m = 0
            for each in listTags{
                if each.title == book.title{
                    bookListTags["favourite"]?.removeAtIndex(m)
                }
                m += 1
            }
        }
        
        favourites.remove(book.title)
        saveFavourites()
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
        return "1"
        
    }
    
    
    func obtainSection(section: Int) -> String?{
        
        let tags : [String]
        
        //Comprobamos como estamos ordenando en el modelo
        if (orderedAlphabetically){
            tags = tagsAlpha.tagOrderedToArray()
        }else{
            tags = tagsTags.tagOrderedToArray()
        }

        return tags[section]
        
    }
    
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
    
    func saveFavourites(){
        
      do{
        
        //Creo la url local
        let urlCache = obtainLocalCacheUrlDocumentsFile("FavouriteBooks.txt")
        let url = obtainLocalUrlDocumentsFile("FavouriteBooks.txt")
        
        let lista = favourites.joinWithSeparator("#")
        
        try lista.writeToURL(urlCache, atomically: true, encoding: NSUTF8StringEncoding)
        try lista.writeToURL(url, atomically: true, encoding: NSUTF8StringEncoding)

        
      }catch let error as NSError{
        print("Error en el guardado de favorito: \(error)")
      }
        
    }
    
    func loadFavourites(){
        //Creo la url local
        let urlCache = obtainLocalCacheUrlDocumentsFile("FavouriteBooks.txt")
        let url = obtainLocalUrlDocumentsFile("FavouriteBooks.txt")

        do{
           
            let dataCache = try NSString(contentsOfURL: urlCache, encoding: NSUTF8StringEncoding)
            
            let lista = dataCache.componentsSeparatedByString("#")
            for each in lista{
                favourites.insert(each)
            }

        }catch let error as NSError{
            print("No existe en cache el fichero FavouriteBooks.txt \(error)")
        }
        
        
        do{
                       
            let data = try NSString(contentsOfURL: url, encoding: NSUTF8StringEncoding)
            
            let lista = data.componentsSeparatedByString("#")
            for each in lista{
                favourites.insert(each)
            }
            
        }catch let error as NSError{
            print("No existe en documentos el fichero FavouriteBooks.txt \(error)")
        }

        
       
        
    }
    
}








 