//
//  BookViewController.swift
//  HackerBooks
//
//  Created by jro on 06/07/16.
//  Copyright © 2016 jro. All rights reserved.
//

import UIKit
import Foundation

class BookViewController: UIViewController {
    
    
    //MARK: - Properties
    var model : Book
    var favourite : Bool = false
    var delegate: BookViewControllerDelegate?
    
    @IBOutlet weak var coverPdf: UIImageView!
    
    @IBOutlet weak var titlePdf: UITextField!
    
    @IBOutlet weak var authorsPdf: UITextField!
    
    @IBOutlet weak var tagsPdf: UITextField!
    
    @IBOutlet weak var emptyStar: UIImageView!
    
    @IBOutlet weak var filledStar: UIImageView!
    
    @IBAction func displayPDF(sender: AnyObject) {
        
        // Creamos el pdfViewController
        let pVC = PdfViewController(model: model)
        
        // Push to the navigator
        navigationController?.pushViewController(pVC, animated: true)
    
    }
    
    
    //MARK: -initalizers
    init(model: Book){
        self.model = model
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func syncWithModelView(){
        
        do{
            coverPdf.image = try model.loadImage()
        }catch{
            
        }
        
        titlePdf.text = model.title
        titlePdf.userInteractionEnabled = false
        
        let pru = model.authors.sort()
        
        let arryAuthors = Array(pru)
        authorsPdf.text = arryAuthors.joinWithSeparator(", ")
        authorsPdf.userInteractionEnabled = false
        
        let pru2 = model.tags.tags.sort()
        tagsPdf.text = pru2.joinWithSeparator(", ")
        tagsPdf.userInteractionEnabled = false
        
        self.favourite = model.isFavourite
        
        if (self.favourite){
            emptyStar.hidden = true
            filledStar.hidden = false
        }else{
            emptyStar.hidden = false
            filledStar.hidden = true
        }
        
        
        
        
    }
    

    // MARK: - View Data
    override func viewDidLoad() {
        super.viewDidLoad()

        // create tap gesture recognizer
        let tapGestureEmptyStar = UITapGestureRecognizer(target: self, action: #selector(BookViewController.emptyStarTapped(_:)))
        let tapGestureFilledStar = UITapGestureRecognizer(target: self, action: #selector(BookViewController.filledStarTapped(_:)))
        
        // add it to the image view;
        emptyStar.addGestureRecognizer(tapGestureEmptyStar)
        // make sure imageView can be interacted with by user
        emptyStar.userInteractionEnabled = true
        
        // add it to the image view;
        filledStar.addGestureRecognizer(tapGestureFilledStar)
        
        // make sure imageView can be interacted with by user
        filledStar.userInteractionEnabled = true
    }
    
    func emptyStarTapped(gesture: UIGestureRecognizer) {
        
        // Añadimos a favoritos
        if let emptyStar = gesture.view as? UIImageView {
            
            //Iniciamos los valores del ViewController
            emptyStar.hidden = true
            filledStar.hidden = false
            model.isFavourite = true
            
            // Avisamos al delegado
            delegate?.bookViewController(self, didAddFavourite: model)
            
            
        }
    }

    func filledStarTapped(gesture: UIGestureRecognizer) {

        // Eliminamos de favoritos
        if let filledStar = gesture.view as? UIImageView {
            
            //Iniciamos los valores del ViewController
            filledStar.hidden = true
            emptyStar.hidden = false
            model.isFavourite = false
            
            //Avisamos al delegado
            delegate?.bookViewController(self, didRemoveFavourite: model)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        emptyStar.image = UIImage(named: "EmptyStar.jpg")
        filledStar.image = UIImage(named: "filledStar.png")
        
        syncWithModelView()
    }
    
    func bookDidChange(notification: NSNotification)  {
        
        // Sacar el userInfo
        let info = notification.userInfo!
        
        // Sacar el personaje
        let char = info[BookKey] as? Book
        
        // Actualizar el modelo
        model = char!
        
        // Sincronizar las vistas
        syncWithModelView()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Baja en la notificación
        let nc = NSNotificationCenter.defaultCenter()
        nc.removeObserver(self)
        
    }

}

//Definimos la interfaz de delagado
protocol BookViewControllerDelegate{
    
    func bookViewController(vc: BookViewController, didAddFavourite book: Book)
    func bookViewController(vc: BookViewController, didRemoveFavourite book: Book)
    
}

//Implementamos los metodos del delegado
extension BookViewController: LibraryViewControllerDelegate{
    
    
    func libraryViewController(vc: LibraryViewController, didSelectBook book: Book){
        // Actualizamos el modelo
        model = book
        
        // Sincronizamos las vistas con el nuevo modelo
        syncWithModelView()
    }
}
