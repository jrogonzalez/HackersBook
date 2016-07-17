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
    
    
    
    // Array de tags con todas las distintas tematicas en
    // orden alfabetico. No puede bajo ningun concepto haber ninguno repetido
    var tags : Set<String>
    
    //MARK: - Initializers
    init(model: Library){
        self.model = model
        self.tags = self.model.obtainSectionForLibraryDict(model.bookListTags)        
        super.init(nibName: nil, bundle: nil)
        self.title = "HackerBooks"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        self.title = "Hackerbooks"
    }
    
    // MARK: - Table View Delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch UIDevice.currentDevice().userInterfaceIdiom {
        case .Phone:
            // It's an iPhone
            // Averiguar cual es el libro
            
            // Averiguar cual es el libro
            let selectedBook = book(forIndexPath: indexPath)
            
            // Creamos un character view controller
            let bookVC = BookViewController(model: selectedBook)
            
            // Lo metro dentro de un navigation
            let charNav = UINavigationController(rootViewController: bookVC)           
            
            // asignamos delegados
            self.delegate = bookVC
//            bookVC.delegate = uVC

            
            self.navigationController?.pushViewController(charNav, animated: true)
            
            // Avisar al delegado
            delegate?.libraryViewController(self, didSelectBook: selectedBook)

            
            
            break
        case .Pad:
            // It's an iPad
            // Averiguar cual es el libro
            let selectedBook = book(forIndexPath: indexPath)
            
            // Avisar al delegado
            delegate?.libraryViewController(self, didSelectBook: selectedBook)
            
            saveLastBookSelectedSection(indexPath.section, row: indexPath.row)
            
            
            // Enviamos la misma info via notificaciones
            let nc = NSNotificationCenter.defaultCenter()
            let notif = NSNotification(name: BookDidChangeNotification, object: self, userInfo: [BookKey:selectedBook])
            nc.postNotification(notif)

            
            
            break
        default:
            // Uh, oh! What could it be?
            break
        }
        
        
        
        
        
        
    }

    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        //Cambiamos el color a la celda
        view.tintColor = UIColor(red: 0.5, green: 0, blue: 0.13, alpha: 1)
        
        let header : UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        
        header.textLabel?.textColor = UIColor.whiteColor()
        header.textLabel?.textAlignment = NSTextAlignment.Left
        
    }


    // Numero total de libros
    var booksCount: Int {
        get{
            let count: Int = self.model.bookListTags.count
            return count
        }
    }

//    // Cantidad de libros que hay en una tematica.
//    // Si el tag no existe, debe de devolver cero.
//    func bookCountForTag (tag: String?) -> Int{
//        return 0
//        
//    }

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
    }


//    func bookAtIndex(index: Int?, row: String?) -> Book?{
//        guard let aTag = row,
//            let aIndex = index else{
//            return nil
//        }
//                
//        guard booksForTag(aTag)?.count != 0,
//            let num = booksForTag(aTag) else{
//            return nil
//        }
//        
//        return num[aIndex]
//        
//    }
    
    // Un Book para que libro que esta en la posicion 'index' de aquellos bajo un cierto tag.
    // Si el indice no existe o el tag no existe devuelve nil
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
        
        return model.booksCount(forTag: sectionName)
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
        
        do{
            cell?.imageView?.image = try theBook.loadImage()!
        }catch{
            
        }
        
        // Sincronizar personaje -> celda
        cell?.textLabel?.text = theBook.title
        cell?.textLabel?.font = UIFont(name: "pepe", size: CGFloat(8))
        
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
        
    }
    
    func saveLastBookSelectedSection(section: Int, row: Int){
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject([lastSection: String(section), lastRow: String(row)], forKey: lastBook)
        
    }
    
    func reloadTable(){
        //sincronizamos
        self.tableView.reloadData()
    }
    
    func libraryViewController(vc: BookViewController, didSelectBook book: Book){
        
        // Creamos un character view controller
        let bookVC = BookViewController(model: book)
        
        self.delegate = bookVC
        
        // Lo metro dentro de un navigation
        _ = self.navigationController?.pushViewController(bookVC, animated: true)
    }
    
    

}

// Definimos los metodos del delegado
protocol LibraryViewControllerDelegate{
    
    func libraryViewController(vc: LibraryViewController, didSelectBook book: Book)
    
}

// Implementamos los metodos del delegado
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

