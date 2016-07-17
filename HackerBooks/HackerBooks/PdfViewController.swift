//
//  PdfViewController.swift
//  HackerBooks
//
//  Created by jro on 06/07/16.
//  Copyright © 2016 jro. All rights reserved.
//

import UIKit

class PdfViewController: UIViewController, UIWebViewDelegate {
    
    var model : Book
    
    @IBOutlet weak var pdfView: UIWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: -initalizers
    init(model: Book){
        
        
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func synchronized(){
        
        do{
            pdfView.loadRequest(try model.loadPdf()!)
        }catch{
            
        }
        
        pdfView.delegate = self
        activityIndicator.startAnimating()
        
        
    }
    
    // MARK: - View Data
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)  
        
        // Alta en notificación
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector: #selector(bookDidChange), name: BookDidChangeNotification, object: nil)
        
        self.synchronized()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Baja en la notificación
        let nc = NSNotificationCenter.defaultCenter()
        nc.removeObserver(self)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Paramos el monitorActivity
        activityIndicator.stopAnimating()
    }
    
    func bookDidChange(notification: NSNotification)  {
        
        // Sacar el userInfo
        let info = notification.userInfo!
        
        activityIndicator.startAnimating()
        
        // Sacar el libro
        let book = info[BookKey] as? Book
        
        // Actualizar el modelo
        self.model = book!
        
        // Sincronizar las vistas
        synchronized()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func webViewDidFinishLoad(webView: UIWebView) {
        activityIndicator.stopAnimating()
        
        activityIndicator.hidden = true
    }

}
