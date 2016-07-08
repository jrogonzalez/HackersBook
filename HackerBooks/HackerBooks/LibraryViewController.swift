//
//  LibraryViewController.swift
//  HackerBooks
//
//  Created by jro on 07/07/16.
//  Copyright © 2016 jro. All rights reserved.
//

import Foundation
import UIKit

class LibraryViewController: UITableViewController{
    
    // Array de Libros
    var model: Library
    
    // Array de tags con todas las distintas tematcas en
    // orden alfabetico. No puede bajo ningun concepto haber ninguno repetido
    var tags : Set<String>
    
    init(model: Library){
        self.model = model
        self.tags = self.model.obtainTagsForLibrary(model.bookList)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }



    // Numero total de libros
    var booksCount: Int {
        get{
            let count: Int = self.model.bookList.count
            return count
        }
    }

    // Cantidad de libros que hay en una tematica.
    // Si el tag no existe, debe de devolver cero.
    func bookCountForTag (tag: String?) -> Int{
        return 0
        
    }

    // Array de los libros (instancias de Book) que hay en una tematica
    // Un libro puede estar en una o mas tematicas. Si no hay libros por una tematica, ha de devolver nil
    func booksForTag (tag: String?) -> [Book]?{
        guard let num = tag else{
            return nil
        }
        return model.bookList[num]
    }

    // Un Book para que libro que esta en la posicion 'index' de aquellos bajo un cierto tag. Mira a ver si puedes usar el metodo anterior para hacer parte de tu trabajo.
    // Si el indice no existe o el tag no existe, ha de devolver nil

    func bookAtIndex(index: Int?, tag: String?) -> Book?{
        guard let aTag = tag,
            let aIndex = index else{
            return nil
        }
                
        guard booksForTag(aTag)?.count == 0,
            let num = booksForTag(aTag) else{
            return nil
        }
        
        return num[aIndex]
        
    }
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // numero de tags en la libreria
        return model.tagsCount
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Numero de libros en un determinado tag
        
        return model.booksCount(forTag: getTag(section))
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Tipo de celda
        let cellId = "BookCell"
        
        
        
        // Averiguar de que personaje me estan preguntando
        let theBook = book(forIndexPath: indexPath)
        
        // Crear la celda
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        
        if cell == nil{
            // el opcional esta vacio: hay que crear la celda a pelo
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
        }
        
        // Sincronizar personaje -> celda
        cell?.imageView?.image = theBook.image_url
        cell?.textLabel?.text = theBook.title
//        cell?.detailTextLabel?.text = theBook.
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return getTag(section)
    }
    
    //MARK: - Utils
    func getTag(forSection: Int) -> String{
        let list = model.obtainTagsForLibrary(model.bookList)
        var array = Array(list)
        
        return array[forSection]
    }
    
    func book(forIndexPath indexPath: NSIndexPath)-> Book{
        return model.book(atIndex: indexPath.row, forTag: getTag(indexPath.section))
    }
    
    
    
    
    
    
    
    
    
    

}