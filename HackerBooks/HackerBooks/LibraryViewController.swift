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
    var delegate: LibraryViewControllerDelegate?
    let lastBook = "lastBook"
    let lastRow = "lastRow"
    let lastSection = "lastSection"
    
    // Array de tags con todas las distintas tematcas en
    // orden alfabetico. No puede bajo ningun concepto haber ninguno repetido
    var tags : Set<String>
    
    init(model: Library){
        self.model = model
        self.tags = self.model.obtainSectionForLibraryDict(model.bookList)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    // MARK: - Table View Delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // Averiguar cual es el personaje
        let selectedBook = book(forIndexPath: indexPath)
        
        // Crear un character view Controller
        //        let charVC = CharacterViewController(model: char)
        
        // Avisar al delegado
        delegate?.libraryViewController(self, didSelectBook: selectedBook)
        
        saveLastBookSelectedSection(indexPath.section, row: indexPath.row)
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
        let aux = model.bookList[num]
        return aux
    }
    
    
    func booksForTag (tag: Int?) -> [Book]?{
        
        guard let num = model.obtainSectionForRow(tag!) else{
            return nil
        }
        
        let aux = model.bookList[num]
        return aux
    }

    // Un Book para que libro que esta en la posicion 'index' de aquellos bajo un cierto tag. Mira a ver si puedes usar el metodo anterior para hacer parte de tu trabajo.
    // Si el indice no existe o el tag no existe, ha de devolver nil

    func bookAtIndex(index: Int?, row: String?) -> Book?{
        guard let aTag = row,
            let aIndex = index else{
            return nil
        }
                
        guard booksForTag(aTag)?.count != 0,
            let num = booksForTag(aTag) else{
            return nil
        }
        
        return num[aIndex]
        
    }
    
    
    func bookAtIndex(section: Int?, row: Int?) -> Book?{
        
        //Averiaguamos de que tag es el int que nos han mandado
        guard let aSection = section,
            let aRow = row else{
                return nil
        }
        
        guard booksForTag(aSection)?.count != 0,
            let num = booksForTag(aSection) else{
                return nil
        }
        
        return num[aRow]
        
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
        let list = model.obtainSectionForLibraryDict(model.bookList)
        var array = Array(list)
        
        return array[forSection]
    }
    
    func book(forIndexPath indexPath: NSIndexPath)-> Book{
        return model.book(atIndex: indexPath.row, forTag: getTag(indexPath.section))
    }
    
    //MARK: - NSUserDefaults methods
    
    func lastSelectedBook() throws -> Book?{
        let defaults = NSUserDefaults.standardUserDefaults()
        
        // si no existe el ultimo libro seleccionado inicializamos uno
        if defaults.objectForKey(lastBook) == nil {
            self.defaultBook()
        }
        
        let bookSelected = defaults.objectForKey(lastBook)
        
        //sacamos las coordenadas del NSUserDefaults
        let row = Int((bookSelected![lastRow] as? String)!)
        let section = Int((bookSelected![lastSection] as? String)!) //Hacems un Int del String
        
        guard let book = bookAtIndex(section, row: row) else{
            throw BookErrors.bookNotFound
        }
        
        return book
        
        
    }
    
    func defaultBook(){
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject([lastSection: "1", lastRow: "0"], forKey: lastBook)
//        defaults.setObject(model.obtainFirstTag()!, forKey: lastRow)
//        defaults.setInteger(0, forKey: lastSection)
        
//        defaults.setObject(model.book(atIndex: 0, forTag: model.obtainFirstTag()!), forKey: lastBook)
//        defaults.setObject(model.obtainFirstTag()!, forKey: lastRow)
//        defaults.setInteger(0, forKey: lastSection)
        
//        return bookAtIndex(0, tag: model.obtainFirstTag()!)
        
        
    }
    
    func saveLastBookSelectedSection(section: Int, row: Int){
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject([lastSection: String(section), lastRow: String(row)], forKey: lastBook)
        
    }
        
    

}


protocol LibraryViewControllerDelegate{
    
    func libraryViewController(vc: LibraryViewController, didSelectBook book: Book)
    
    
}