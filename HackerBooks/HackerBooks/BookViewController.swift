//
//  BookViewController.swift
//  HackerBooks
//
//  Created by jro on 06/07/16.
//  Copyright © 2016 jro. All rights reserved.
//

import UIKit

class BookViewController: UIViewController {
    
    
    //MARK: - Properties
    var model : Book
    
    @IBOutlet weak var coverPdf: UIImageView!
    
    @IBOutlet weak var titlePdf: UITextField!
    
    @IBOutlet weak var authorsPdf: UITextField!
    
    @IBOutlet weak var tagsPdf: UITextField!
    
    @IBAction func displayPDF(sender: AnyObject) {
        
        // Create a pdfViewController
        let pVC = PdfViewController(model: model)
        
        // Push to the navigator
        navigationController?.pushViewController(pVC, animated: true)
    
    }
    init(model: Book){
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func syncWithModelView(){
        
        coverPdf.image = model.image_url
        titlePdf.text = model.title
        
        let pru = model.authors.sort()
        
        let arryAuthors = Array(pru)
        authorsPdf.text = arryAuthors.joinWithSeparator(",")
        
        let pru2 = model.tags.tags.sort()
        tagsPdf.text = pru2.joinWithSeparator(",")
        
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        syncWithModelView()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension BookViewController: LibraryViewControllerDelegate{
    
    
    func libraryViewController(vc: LibraryViewController, didSelectBook book: Book){
        // Actualizamos el modelo
        model = book
        
        // Sincronizamos las vistas con el nuevo modelo
        syncWithModelView()
    }
}
