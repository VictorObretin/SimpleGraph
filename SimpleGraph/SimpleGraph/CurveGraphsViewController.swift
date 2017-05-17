//
//  CurveGraphsViewController.swift
//  SimpleGraph
//
//  Created by Victor Obretin on 2016-11-28.
//  Copyright © 2016 Victor Obretin. All rights reserved.
//

import UIKit

class CurveGraphsViewController: PageItemViewController {

    @IBOutlet weak var curvedLineGraph: UICurveGraphView!
    @IBOutlet weak var secondCurvedLineGraph: UICurveGraphView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        resetViews()
    }
    
    internal func resetViews() {
        // Feeding Test Data
        curvedLineGraph.setValues(values:       [0.5, 0.5, 0.55, 0.45, 0.15, 0.0, 0.2, 0.7, 0.8, 0.75, 1.0])
        secondCurvedLineGraph.setValues(values: [0.3, 0.35, 0.45, 0.4, 0.35, 0.55, 0.5, 0.6, 0.7, 0.7, 0.8], animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent //or default
    }
}

