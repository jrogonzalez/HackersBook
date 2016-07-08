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
