//
//  Tags.swift
//  HackerBooks
//
//  Created by jro on 07/07/16.
//  Copyright © 2016 jro. All rights reserved.
//

import Foundation

class Tag: Equatable, Hashable{
    
    var tags = Set<String>()
    
    init(tags: Set<String>){
        self.tags = tags
    }
    
    
    //MARK: - Array
    func tagToOrderArray()->[String]{
        var auxArray : [String] = Array(tags)
        auxArray.sortInPlace()
        return auxArray
    }
    
    func tagOrderedToArray(tags: Set<String>) -> [String]{
        
        // Transformamos en un array y ordenamos alfabeticamente
        let auxArray = Array(tags.sort())
        
        // Creamos el array de salida e introducimos el primer elemento el favorito
        var salida : [String] = []
        salida.insert("favourite", atIndex: 0)
        
        //Iteramos y vamos introduciendo los tags salvo el favorito que ya lo introdujimos en la posicion 0
        for each in auxArray {
            if (each != "favourite"){
                salida.append(each)
            }
        }
        
        return salida
    }
    
    
    func tagOrderedToArray() -> [String]{
        
        // Transformamos en un array y ordenamos alfabeticamente
        let auxArray = Array(tags.sort())
        
        // Creamos el array de salida e introducimos el primer elemento el favorito
        var salida : [String] = []
        salida.insert("favourite", atIndex: 0)
        
        //Iteramos y vamos introduciendo los tags salvo el favorito que ya lo introdujimos en la posicion 0
        for each in auxArray {
            if (each != "favourite"){
                salida.append(each)
            }
        }
        
        return salida
    }
    
    //MARK: - Proxies
    var proxyForComparison : String{
        get{
            let array = Array(tags.sort())
            return array.joinWithSeparator("-")
        }
    }
    
    var proxyForSorting : String{
        get{
            return proxyForComparison
        }
    }

    
    
    /// The hash value.
    ///
    /// **Axiom:** `x == y` implies `x.hashValue == y.hashValue`.
    ///
    /// - Note: The hash value is not guaranteed to be stable across
    ///   different invocations of the same program.  Do not persist the
    ///   hash value across program runs.
    var hashValue: Int {
        get{
            return 0
        }
    }
    
    
}

func ==(lhs: Tag, rhs: Tag) -> Bool{
    guard (lhs !== rhs) else{
        return true
    }
    
    return lhs.proxyForComparison == rhs.proxyForComparison
}

func <(lhs: Tag, rhs: Tag) -> Bool{
    return lhs.proxyForSorting < rhs.proxyForSorting
}
