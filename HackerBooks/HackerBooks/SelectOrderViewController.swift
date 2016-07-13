//
//  SelectOrderViewController.swift
//  HackerBooks
//
//  Created by jro on 13/07/16.
//  Copyright © 2016 jro. All rights reserved.
//

import UIKit

class SelectOrderViewController: UIViewController {

    var table: LibraryViewController
    
    @IBOutlet weak var SelectOrderView: UIView!
    @IBOutlet weak var AlphaButton: UIButton!
    @IBOutlet weak var TagButton: UIButton!
    @IBAction func TagsOrderButton(sender: AnyObject) {
        print("TagsOrderButton selected")
        table.model.modifyOrderedAlphabetically(false)
        table.reloadTable()
    }
    @IBAction func AlphaOrderButton(sender: AnyObject) {
        print("AlphaOrderButton selected")
        table.model.modifyOrderedAlphabetically(true)
        table.reloadTable()
    }
    
    init(table: LibraryViewController){
        self.table = table
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addTableControllerView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Add Subview
    func addTableControllerView(){
        
        let segBounds = self.AlphaButton.bounds
        let totalBounds = self.navigationController?.view.bounds
        
//        let ancho = segBounds.size.width
//        let alto = totalBounds!.size.height
        let ancho = self.AlphaButton.bounds.size.width + self.TagButton.bounds.size.width
        let alto = CGFloat(700)
        
        
        
//        let X = segBounds.origin.x
//        let Y = segBounds.origin.y+segBounds.size.height

        let X = segBounds.origin.x
        let Y = CGFloat(100)
        
        
        print ("ancho: \(ancho) - alto \(alto)")
        
        let position = CGPoint(x: X, y: Y)
        let totalSpace = CGSize(width: ancho,
                                height: alto)
        
        print ("position: \(position) - totalSpace \(totalSpace)")
        
        // Hasta aquí calculo donde dibujar la vista
        let cgRect = CGRect(origin: position, size: totalSpace)
        
        print ("cgRect: \(cgRect)")

        let tV = UIScrollView(frame: cgRect)

        // Modifico los bordes del tableView para que se ajuste bien
        self.table.tableView.frame = tV.frame
        self.table.tableView.bounds = tV.bounds
        
        print ("frame: \(tV.frame)")
        print ("bounds: \(tV.bounds)")
        
        // Añado la subvista al uiview intermedio
        tV.addSubview(self.table.tableView)
        
        // Inserto la vista en el uiview principal
        self.view.addSubview(tV)
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
