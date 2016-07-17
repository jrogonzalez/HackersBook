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

    @IBOutlet weak var SelectOrderButton: UISegmentedControl!
    @IBAction func selectOrder(sender: AnyObject) {
        if sender.selectedSegmentIndex == 0{
            table.model.modifyOrderedAlphabetically(true)
            table.reloadTable()
        } else{
            table.model.modifyOrderedAlphabetically(false)
            table.reloadTable()
        }
        
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
        
        let ancho = CGFloat(320)
        let alto = CGFloat(650)
        
        let X = CGFloat(0)
        let Y = CGFloat(100)
        
        let position = CGPoint(x: X, y: Y)
        
        let tamanio = CGSize(width: ancho,
                                height: alto)
        
        let area = CGRect(origin: position, size: tamanio)

        let tableView = UIScrollView(frame: area)

        self.table.tableView.frame = tableView.frame
        self.table.tableView.bounds = tableView.bounds
        
        tableView.addSubview(self.table.tableView)
        
        self.view.addSubview(tableView)
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
