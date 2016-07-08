//
//  PdfViewController.swift
//  HackerBooks
//
//  Created by jro on 06/07/16.
//  Copyright © 2016 jro. All rights reserved.
//

import UIKit

class PdfViewController: UIViewController, UIWebViewDelegate {
    
    let model : Book
    
    @IBOutlet weak var pdfView: UIWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    init(model: Book){
        
        
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func synchronized(){
        
        let pru = NSURLRequest(URL: model.pdf_url)
        pdfView.delegate = self
        activityIndicator.startAnimating()
        pdfView.loadRequest(pru)
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.synchronized()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        activityIndicator.stopAnimating()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func webViewDidFinishLoad(webView: UIWebView) {
        activityIndicator.stopAnimating()
        
        activityIndicator.hidden = true
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
