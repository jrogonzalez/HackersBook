//
//  LibraryViewController.swift
//  HackerBooks
//
//  Created by jro on 07/07/16.
//  Copyright © 2016 jro. All rights reserved.
//

import Foundation
import UIKit

let BookDidChangeNotification = "Selected Book did change"
let BookKey = "key"

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
        self.tags = self.model.obtainSectionForLibraryDict(model.bookListTags)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        self.title = "Hackerbooks"
                
//        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.5
//            green:0
//            blue:0.13
//            alpha:1];
    }
    
    // MARK: - Table View Delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // Averiguar cual es el personaje
        let selectedBook = book(forIndexPath: indexPath)
        
        // Crear un character view Controller
        //        let charVC = CharacterViewController(model: char)
        
        // Avisar al delegado
        delegate?.libraryViewController(self, didSelectBook: selectedBook)
        
        saveLastBookSelectedSection(indexPath.section, row: indexPath.row)
        
        
        // Enviamos la misma info via notificaciones
        let nc = NSNotificationCenter.defaultCenter()
        let notif = NSNotification(name: BookDidChangeNotification, object: self, userInfo: [BookKey:selectedBook])
        nc.postNotification(notif)

    }

    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        if model.bookListTags["favourite"]!.count>0{
            if section==0{
                view.tintColor = UIColor.redColor()
            }
            else{
                view.tintColor = UIColor(red: 0.5, green: 0, blue: 0.13, alpha: 1)
            }
        }
        else{
            view.tintColor = UIColor(red: 0.5, green: 0, blue: 0.13, alpha: 1)
        }
        
        
        
        let title = UILabel()
        title.textColor = UIColor.whiteColor()
        title.textAlignment = NSTextAlignment.Left
        
        
        
        let header : UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        
        header.textLabel?.textColor = title.textColor
        header.textLabel?.textAlignment = title.textAlignment
        
    }


    // Numero total de libros
    var booksCount: Int {
        get{
            let count: Int = self.model.bookListTags.count
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
        let aux = model.bookListTags[num]
        return aux
    }
    
    
    func booksForTag (tag: Int?) -> [Book]?{       
        
        guard let num = model.obtainSection(tag!) else{
            return nil
        }
        
        //Comprobamos como estamos ordenando en el modelo
        if (model.orderedAlphabetically){
            let aux = model.bookListAlpha[num]
            return aux
        }else{
            let aux = model.bookListTags[num]
            return aux
        }
        
        
        return nil
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
        let sectionName = getTag(section)
        
        let num = model.booksCount(forTag: sectionName)
        
        
//        print("section: \(section) nº books: \(num) --> \(sectionName)")
        
        return num
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Tipo de celda
        let cellId = "BookCell"
        
        
//        print("section: \(indexPath.section)")
//        print("row: \(indexPath.row)")
        
        // Averiguar de que personaje me estan preguntando
        let theBook = book(forIndexPath: indexPath)
//        let sectionName = getTag(indexPath.section)
//        print("tag: \(sectionName)")
        
        // Crear la celda
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        
        if cell == nil{
            // el opcional esta vacio: hay que crear la celda a pelo
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
        }
        
        
        do{
            cell?.imageView?.image = try theBook.loadImage()!
        }catch{
            
        }
        
        
        
        
        // Sincronizar personaje -> celda
        
        cell?.textLabel?.text = theBook.title
        cell?.textLabel?.font = UIFont(name: "pepe", size: CGFloat(8))
    
//        cell?.detailTextLabel?.text = theBook.
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return getTag(section)
    }
    
    //MARK: - Utils
    func getTag(forSection: Int) -> String{
        let listTags : Set<String>
        let listTagsOrdered : [String]

        //Comprobamos como estamos ordenando en el modelo
        if (model.orderedAlphabetically){
            // Sacamos el set de tags del modelo
            listTags = model.obtainSectionForLibraryDict(model.bookListAlpha)
            
            //Ordenamos los tags poniendo el favorito el primero
            listTagsOrdered = model.tagsAlpha.tagOrderedToArray(listTags)
        }else{
            // Sacamos el set de tags del modelo
            listTags = model.obtainSectionForLibraryDict(model.bookListTags)
            
            //Ordenamos los tags poniendo el favorito el primero
            listTagsOrdered = model.tagsTags.tagOrderedToArray(listTags)
        }
        
        
        let sal = listTagsOrdered[forSection]
        return sal
    }
    
    func book(forIndexPath indexPath: NSIndexPath)-> Book{
        return try model.book(forSection: indexPath.section, atRow: indexPath.row)!
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
    
    func reloadTable(){
        //sincronizamos
        self.tableView.reloadData()
    }
        
    

}


protocol LibraryViewControllerDelegate{
    
    func libraryViewController(vc: LibraryViewController, didSelectBook book: Book)
            
    
}


extension LibraryViewController: BookViewControllerDelegate{
    
    
    func bookViewController(vc: BookViewController, didAddFavourite book: Book){
        // Actualizamos el modelo
        model.addFavorite(book)        
        
        //sincronizamos
        self.tableView.reloadData()
        
    }
    
    func bookViewController(vc: BookViewController, didRemoveFavourite book: Book){
        // Actualizamos el modelo
        model.removeFavorite(book)
        
        //sincronizamos
        self.tableView.reloadData()
    }
    
}

